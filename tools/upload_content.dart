/// CLI script to upload local content files to Firestore for OTA delivery.
///
/// Usage:
///   dart run tools/upload_content.dart --files assets/fiches/algebre/theoreme_spectral.md,assets/data/quiz.json
///   dart run tools/upload_content.dart --all
///   dart run tools/upload_content.dart --changelog "Correction typos algèbre"
///
/// Prerequisites:
///   1. Install the Firebase CLI: https://firebase.google.com/docs/cli
///   2. Login: firebase login
///   3. npm install -g firebase-admin (or use Dart firebase_admin package)
///
/// This script uses the Firebase REST API with a service account or
/// the gcloud CLI token. For simplicity, it outputs the Firestore
/// commands you can paste into the Firebase Console or a Node.js script.

import 'dart:convert';
import 'dart:io';

const String projectId = 'agreg-master-prod';
const String firestoreBaseUrl =
    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

void main(List<String> args) async {
  final uploadAll = args.contains('--all');
  String? changelog;
  List<String> filePaths = [];

  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--files' && i + 1 < args.length) {
      filePaths = args[i + 1].split(',').map((f) => f.trim()).toList();
    }
    if (args[i] == '--changelog' && i + 1 < args.length) {
      changelog = args[i + 1];
    }
  }

  if (!uploadAll && filePaths.isEmpty) {
    print('Usage:');
    print('  dart run tools/upload_content.dart --files file1,file2 [--changelog "msg"]');
    print('  dart run tools/upload_content.dart --all [--changelog "msg"]');
    exit(1);
  }

  if (uploadAll) {
    filePaths = _getAllContentFiles();
  }

  // Validate files exist
  final missing = filePaths.where((f) => !File(f).existsSync()).toList();
  if (missing.isNotEmpty) {
    print('ERROR: Files not found:');
    for (final f in missing) {
      print('  - $f');
    }
    exit(1);
  }

  print('=== Agreg Master - Content Upload Tool ===');
  print('Project: $projectId');
  print('Files to upload: ${filePaths.length}');
  print('');

  // Generate the Node.js upload script
  final nodeScript = _generateNodeScript(filePaths, changelog);
  final outputPath = 'tools/_upload_batch.js';
  File(outputPath).writeAsStringSync(nodeScript);
  print('Generated Node.js upload script: $outputPath');
  print('');
  print('To execute the upload, run:');
  print('  cd tools && node _upload_batch.js');
  print('');
  print('Or manually upload via Firebase Console:');
  print('  https://console.firebase.google.com/project/$projectId/firestore');
  print('');

  // Also generate a JSON payload for direct REST API use
  _printSummary(filePaths);
}

List<String> _getAllContentFiles() {
  final files = <String>[];

  // Manifest
  _addIfExists(files, 'assets/fiches/manifest.json');

  // Glossaire
  _addIfExists(files, 'assets/glossaire.json');

  // Data files
  for (final name in [
    'quiz',
    'exercices',
    'demonstrations',
    'contre_exemples',
    'questions_jury',
    'bibliographie',
    'lecons',
    'developpements',
  ]) {
    _addIfExists(files, 'assets/data/$name.json');
  }

  // Fiches markdown
  for (final dir in ['algebre', 'analyse', 'probabilites', 'geometrie']) {
    final d = Directory('assets/fiches/$dir');
    if (d.existsSync()) {
      for (final f in d.listSync().whereType<File>()) {
        if (f.path.endsWith('.md')) {
          files.add(f.path.replaceAll('\\', '/'));
        }
      }
    }
  }

  return files;
}

void _addIfExists(List<String> files, String path) {
  if (File(path).existsSync()) files.add(path);
}

String _encodeDocId(String assetPath) {
  return assetPath.replaceAll('/', '--');
}

String _generateNodeScript(List<String> filePaths, String? changelog) {
  final buffer = StringBuffer();
  buffer.writeln("const admin = require('firebase-admin');");
  buffer.writeln("const fs = require('fs');");
  buffer.writeln('');
  buffer.writeln("admin.initializeApp({ projectId: '$projectId' });");
  buffer.writeln('const db = admin.firestore();');
  buffer.writeln('');
  buffer.writeln('async function main() {');
  buffer.writeln('  const batch = db.batch();');
  buffer.writeln('');

  // Get current version
  buffer.writeln("  const metaRef = db.collection('content_meta').doc('current');");
  buffer.writeln('  const metaSnap = await metaRef.get();');
  buffer.writeln('  const currentVersion = metaSnap.exists ? (metaSnap.data().version || 0) : 0;');
  buffer.writeln('  const newVersion = currentVersion + 1;');
  buffer.writeln("  console.log(`Upgrading from v\${currentVersion} to v\${newVersion}`);");
  buffer.writeln('');

  // Upload files
  for (final path in filePaths) {
    final docId = _encodeDocId(path);
    final escapedPath = path.replaceAll("'", "\\'");
    buffer.writeln("  // $path");
    buffer.writeln("  const content_${docId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')} = fs.readFileSync('../$escapedPath', 'utf8');");
    buffer.writeln("  batch.set(db.collection('content_files').doc('$docId'), {");
    buffer.writeln("    path: '$escapedPath',");
    buffer.writeln("    content: content_${docId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')},");
    buffer.writeln('    version: newVersion,');
    buffer.writeln('    updated_at: admin.firestore.FieldValue.serverTimestamp(),');
    buffer.writeln('  });');
    buffer.writeln('');
  }

  // Update meta
  final changelogStr = changelog?.replaceAll("'", "\\'") ?? 'Content update';
  buffer.writeln('  batch.set(metaRef, {');
  buffer.writeln('    version: newVersion,');
  buffer.writeln('    updated_at: admin.firestore.FieldValue.serverTimestamp(),');
  buffer.writeln("    changelog: '$changelogStr',");
  buffer.writeln('  });');
  buffer.writeln('');
  buffer.writeln('  await batch.commit();');
  buffer.writeln("  console.log(`Upload complete! v\${newVersion} - ${filePaths.length} files`);");
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln("main().catch(e => { console.error(e); process.exit(1); });");

  return buffer.toString();
}

void _printSummary(List<String> filePaths) {
  print('Files to upload:');
  for (final f in filePaths) {
    final size = File(f).lengthSync();
    final sizeKb = (size / 1024).toStringAsFixed(1);
    print('  $f (${sizeKb} KB) -> doc: ${_encodeDocId(f)}');
  }
}
