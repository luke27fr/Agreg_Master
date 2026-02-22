import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Drop-in replacement for rootBundle.loadString() that checks
/// the local OTA cache before falling back to bundled assets.
class ContentLoader {
  ContentLoader._();

  static String? _cacheDir;

  static Future<String> _getCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    if (kIsWeb) return '';
    final dir = await getApplicationDocumentsDirectory();
    _cacheDir = '${dir.path}/content_cache';
    return _cacheDir!;
  }

  /// Load a string asset, checking OTA cache first then bundled assets.
  static Future<String> loadString(String assetPath) async {
    if (!kIsWeb) {
      try {
        final cacheDir = await _getCacheDir();
        final file = File('$cacheDir/$assetPath');
        if (await file.exists()) {
          debugPrint('ContentLoader: cache hit for $assetPath');
          return await file.readAsString();
        }
      } catch (e) {
        debugPrint('ContentLoader: cache read error for $assetPath: $e');
      }
    }
    return rootBundle.loadString(assetPath);
  }

  /// Write a file to the local OTA cache.
  static Future<void> writeToCache(String assetPath, String content) async {
    if (kIsWeb) return;
    try {
      final cacheDir = await _getCacheDir();
      final file = File('$cacheDir/$assetPath');
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
    } catch (e) {
      debugPrint('ContentLoader: cache write error for $assetPath: $e');
    }
  }

  /// Check if a cached version exists for the given asset path.
  static Future<bool> hasCached(String assetPath) async {
    if (kIsWeb) return false;
    try {
      final cacheDir = await _getCacheDir();
      return File('$cacheDir/$assetPath').exists();
    } catch (_) {
      return false;
    }
  }

  /// Clear the entire OTA cache (useful for debugging or reset).
  static Future<void> clearCache() async {
    if (kIsWeb) return;
    try {
      final cacheDir = await _getCacheDir();
      final dir = Directory(cacheDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        debugPrint('ContentLoader: cache cleared');
      }
    } catch (e) {
      debugPrint('ContentLoader: cache clear error: $e');
    }
  }
}
