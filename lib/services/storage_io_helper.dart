import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

/// Save PDF bytes to a file on mobile/desktop. Returns the file path.
Future<String?> savePdfFile(String filename, Uint8List bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;
}
