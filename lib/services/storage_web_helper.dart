import 'package:flutter/foundation.dart';

/// On web, PDF file saving is not supported directly.
/// Returns null to indicate the file was not saved to disk.
Future<String?> savePdfFile(String filename, Uint8List bytes) async {
  debugPrint('PDF export not supported on web platform');
  return null;
}
