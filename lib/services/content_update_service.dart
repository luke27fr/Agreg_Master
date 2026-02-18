import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/content_loader.dart';
import '../utils/manifest_loader.dart';

/// Service that checks Firestore for content updates and downloads
/// changed files to the local cache. The app keeps working offline
/// using bundled assets as fallback.
class ContentUpdateService extends ChangeNotifier {
  static final ContentUpdateService _instance =
      ContentUpdateService._internal();
  factory ContentUpdateService() => _instance;
  ContentUpdateService._internal();

  bool _initialized = false;
  bool _checking = false;
  int _localVersion = 0;
  int _remoteVersion = 0;
  int _filesUpdated = 0;
  String? _error;
  String? _changelog;

  bool get isChecking => _checking;
  int get localVersion => _localVersion;
  int get remoteVersion => _remoteVersion;
  int get filesUpdated => _filesUpdated;
  String? get error => _error;
  String? get changelog => _changelog;
  bool get hasUpdate => _remoteVersion > _localVersion;

  /// Initialize and check for updates in background.
  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    try {
      _localVersion = await _getLocalVersion();
      debugPrint('ContentUpdate: local version=$_localVersion');
      await checkForUpdates();
    } catch (e) {
      debugPrint('ContentUpdate: init error: $e');
      _error = e.toString();
    }
  }

  /// Check Firestore for a newer content version and download changes.
  Future<void> checkForUpdates() async {
    if (kIsWeb || _checking) return;
    _checking = true;
    _error = null;
    _filesUpdated = 0;
    notifyListeners();

    try {
      final metaDoc = await FirebaseFirestore.instance
          .collection('content_meta')
          .doc('current')
          .get()
          .timeout(const Duration(seconds: 10));

      if (!metaDoc.exists || metaDoc.data() == null) {
        debugPrint('ContentUpdate: no remote content_meta found');
        _checking = false;
        notifyListeners();
        return;
      }

      final data = metaDoc.data()!;
      _remoteVersion = (data['version'] as num?)?.toInt() ?? 0;
      _changelog = data['changelog'] as String?;

      debugPrint(
          'ContentUpdate: remote version=$_remoteVersion, local=$_localVersion');

      if (_remoteVersion > _localVersion) {
        await _downloadUpdates();
        await _setLocalVersion(_remoteVersion);
        _localVersion = _remoteVersion;
        ManifestLoader.invalidateCache();
        debugPrint(
            'ContentUpdate: updated to v$_remoteVersion ($_filesUpdated files)');
      } else {
        debugPrint('ContentUpdate: already up to date');
      }
    } catch (e) {
      debugPrint('ContentUpdate: check error: $e');
      _error = e.toString();
    } finally {
      _checking = false;
      notifyListeners();
    }
  }

  Future<void> _downloadUpdates() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('content_files')
        .where('version', isGreaterThan: _localVersion)
        .get()
        .timeout(const Duration(seconds: 30));

    for (final doc in snapshot.docs) {
      final docData = doc.data();
      final path = docData['path'] as String?;
      final content = docData['content'] as String?;
      if (path != null && content != null) {
        await ContentLoader.writeToCache(path, content);
        _filesUpdated++;
        debugPrint('ContentUpdate: cached $path');
      }
    }
  }

  // -- Local version persistence --

  Future<String> get _versionFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/content_cache/_version.json';
  }

  Future<int> _getLocalVersion() async {
    try {
      final path = await _versionFilePath;
      final file = File(path);
      if (await file.exists()) {
        final data = jsonDecode(await file.readAsString());
        return (data['version'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      debugPrint('ContentUpdate: error reading local version: $e');
    }
    return 0;
  }

  Future<void> _setLocalVersion(int version) async {
    try {
      final path = await _versionFilePath;
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({'version': version}));
    } catch (e) {
      debugPrint('ContentUpdate: error writing local version: $e');
    }
  }

  /// Force re-download all remote content (ignores local version).
  Future<void> forceUpdate() async {
    _localVersion = 0;
    await _setLocalVersion(0);
    await ContentLoader.clearCache();
    ManifestLoader.invalidateCache();
    await checkForUpdates();
  }
}
