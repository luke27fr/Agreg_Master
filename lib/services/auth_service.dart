import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'subscription_service.dart';

/// Manages Google and Apple Sign-In with anonymous account linking.
///
/// When a user signs in, the anonymous Firebase account is linked to the
/// social credential so the UID (and all Firestore data / RevenueCat
/// subscriptions) are preserved. If the credential already belongs to
/// another Firebase user, we sign in with that account instead (cross-device
/// restore scenario).
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get currentUser {
    try { return _auth.currentUser; } catch (_) { return null; }
  }
  bool get isAnonymous => currentUser?.isAnonymous ?? true;
  bool get isSignedIn => currentUser != null && !isAnonymous;
  String? get displayName => currentUser?.displayName;
  String? get email => currentUser?.email;
  String? get photoUrl => currentUser?.photoURL;

  // ──────────────────────────────────────────────────────────────────────────
  // Google Sign-In
  // ──────────────────────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return await _signInWithPopup(GoogleAuthProvider());
      }
      final googleUser = await GoogleSignIn(
        clientId: '189782425075-7doiosmmrha54469kcv3r8d13e33gbps.apps.googleusercontent.com',
      ).signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _linkOrSignIn(credential);
      await _syncRevenueCat();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Apple Sign-In
  // ──────────────────────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      if (kIsWeb) {
        return await _signInWithPopup(appleProvider);
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        return await _signInWithProvider(appleProvider);
      }

      // iOS: native Apple Sign-In
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final result = await _linkOrSignIn(oauthCredential);

      if (result?.user != null && appleCredential.givenName != null) {
        final name =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (name.isNotEmpty && (result!.user!.displayName?.isEmpty ?? true)) {
          await result.user!.updateDisplayName(name);
          await result.user!.reload();
        }
      }

      await _syncRevenueCat();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sign-Out  → back to anonymous
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await _auth.signInAnonymously();
    await _syncRevenueCat();
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Link or sign-in logic
  // ──────────────────────────────────────────────────────────────────────────

  /// Android: use Firebase Auth provider flow (opens browser for OAuth).
  Future<UserCredential?> _signInWithProvider(OAuthProvider provider) async {
    final user = _auth.currentUser;
    try {
      UserCredential result;
      if (user != null && user.isAnonymous) {
        result = await user.linkWithProvider(provider);
      } else {
        result = await _auth.signInWithProvider(provider);
      }
      await _syncRevenueCat();
      notifyListeners();
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        debugPrint('Credential already in use – signing in with provider');
        final result = await _auth.signInWithProvider(provider);
        await _syncRevenueCat();
        notifyListeners();
        return result;
      }
      rethrow;
    }
  }

  /// Web-only: use Firebase Auth popup flow (no separate OAuth client needed).
  Future<UserCredential?> _signInWithPopup(AuthProvider provider) async {
    final user = _auth.currentUser;
    try {
      UserCredential result;
      if (user != null && user.isAnonymous) {
        result = await user.linkWithPopup(provider);
      } else {
        result = await _auth.signInWithPopup(provider);
      }
      await _syncRevenueCat();
      notifyListeners();
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        debugPrint('Credential already in use – signing in with popup');
        final result = await _auth.signInWithPopup(provider);
        await _syncRevenueCat();
        notifyListeners();
        return result;
      }
      rethrow;
    }
  }

  /// Try to link the current anonymous account. If the credential is already
  /// used by another account, sign in with that account instead.
  Future<UserCredential?> _linkOrSignIn(AuthCredential credential) async {
    final user = _auth.currentUser;
    if (user != null && user.isAnonymous) {
      try {
        return await user.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use') {
          debugPrint('Credential already in use – signing in with existing account');
          return await _auth.signInWithCredential(credential);
        }
        rethrow;
      }
    }
    return await _auth.signInWithCredential(credential);
  }

  /// Re-login RevenueCat so subscriptions follow the Firebase UID.
  Future<void> _syncRevenueCat() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await SubscriptionService().refreshAfterAuthChange(uid);
      }
    } catch (e) {
      debugPrint('RevenueCat sync error (non-blocking): $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Apple nonce helpers
  // ──────────────────────────────────────────────────────────────────────────

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
