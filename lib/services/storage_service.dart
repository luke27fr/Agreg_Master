import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import: dart:io only available on mobile/desktop
import 'storage_io.dart' if (dart.library.html) 'storage_web.dart' as platform_storage;

/// Abstract storage service that works on both mobile and web.
/// On mobile: uses file system (path_provider + dart:io)
/// On web: uses shared_preferences / localStorage
abstract class StorageService {
  /// Read a string value by key. Returns null if not found.
  Future<String?> read(String key);

  /// Write a string value by key.
  Future<void> write(String key, String value);

  /// Delete a value by key.
  Future<void> delete(String key);

  /// Check if a key exists.
  Future<bool> exists(String key);

  /// Get the singleton instance (platform-appropriate).
  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= platform_storage.createStorageService();
    return _instance!;
  }
}

/// Web implementation using shared_preferences.
class WebStorageService extends StorageService {
  static const String _prefix = 'agreg_storage_';

  @override
  Future<String?> read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('$_prefix$key');
    } catch (e) {
      debugPrint('WebStorage read error for $key: $e');
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$key', value);
    } catch (e) {
      debugPrint('WebStorage write error for $key: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix$key');
    } catch (e) {
      debugPrint('WebStorage delete error for $key: $e');
    }
  }

  @override
  Future<bool> exists(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('$_prefix$key');
    } catch (e) {
      return false;
    }
  }
}
