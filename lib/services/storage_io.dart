import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

/// Creates the platform-appropriate StorageService (mobile/desktop).
StorageService createStorageService() => MobileStorageService();

/// Mobile/desktop implementation using file system.
class MobileStorageService extends StorageService {
  @override
  Future<String?> read(String key) async {
    try {
      final file = await _getFile(key);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      debugPrint('MobileStorage read error for $key: $e');
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      final file = await _getFile(key);
      await file.writeAsString(value);
    } catch (e) {
      debugPrint('MobileStorage write error for $key: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      final file = await _getFile(key);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('MobileStorage delete error for $key: $e');
    }
  }

  @override
  Future<bool> exists(String key) async {
    try {
      final file = await _getFile(key);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<File> _getFile(String key) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$key');
  }
}
