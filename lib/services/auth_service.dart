import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        serverClientId: '189782425075-8vohijvlgtama9l9fa75jqk4rp5d66ue.apps.googleusercontent.com',
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
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Broadcast the specific error so the UI can show a SnackBar or Dialog
        // This helps tremendously with debugging release builds without ADB
        throw Exception('Erreur Google Sign-In : $e');
      }
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Apple Sign-In (uses Firebase's built-in provider flow + native entitlement)
  // ──────────────────────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      if (kIsWeb) {
        return await _signInWithPopup(appleProvider);
      }

      return await _signInWithProvider(appleProvider);
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
      rethrow;
    }
  }

  /// iOS/Android: use Firebase Auth provider flow (native Apple dialog on iOS).
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

  // ──────────────────────────────────────────────────────────────────────────
  // Email / Password Sign-In
  // ──────────────────────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      final result = await _linkOrSignIn(credential);
      await _syncRevenueCat();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Email Sign-In error: $e');
      rethrow;
    }
  }

  Future<UserCredential?> createAccountWithEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      UserCredential result;

      if (user != null && user.isAnonymous) {
        final credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password,
        );
        try {
          result = await user.linkWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            result = await _auth.signInWithEmailAndPassword(
              email: email.trim(),
              password: password,
            );
          } else {
            rethrow;
          }
        }
      } else {
        result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      }

      await _syncRevenueCat();
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Email Create Account error: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sign-Out  → back to anonymous
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
    await _auth.signInAnonymously();
    await _syncRevenueCat();
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Link or sign-in logic
  // ──────────────────────────────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────────────────────────────
  // Account Deletion (Apple Guideline 5.1.1(v))
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('requires-recent-login');
      }
      rethrow;
    }
    await _auth.signInAnonymously();
    await _syncRevenueCat();
    notifyListeners();
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

}
