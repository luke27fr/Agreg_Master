/// CLI wrapper: collects files and calls the Node.js upload script.
///
/// Usage:
///   dart run tools/upload_content.dart --files assets/data/quiz.json,assets/glossaire.json
///   dart run tools/upload_content.dart --all
///   dart run tools/upload_content.dart --all --changelog "Ajout fiches probabilités"
///
/// Prerequisites: firebase login + npm install (in tools/)

import 'dart:io';

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

  final missing = filePaths.where((f) => !File(f).existsSync()).toList();
  if (missing.isNotEmpty) {
    print('ERROR: Files not found:');
    for (final f in missing) print('  - $f');
    exit(1);
  }

  print('Files to upload: ${filePaths.length}');

  final env = Map<String, String>.from(Platform.environment);
  if (changelog != null) env['CHANGELOG'] = changelog;

  final result = await Process.run(
    'node',
    ['tools/_upload_batch.js', ...filePaths],
    environment: env,
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);
  exit(result.exitCode);
}

List<String> _getAllContentFiles() {
  final files = <String>[];
  _add(files, 'assets/fiches/manifest.json');
  _add(files, 'assets/glossaire.json');
  for (final name in [
    'quiz', 'exercices', 'demonstrations', 'contre_exemples',
    'questions_jury', 'bibliographie', 'lecons', 'developpements',
  ]) {
    _add(files, 'assets/data/$name.json');
  }
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

void _add(List<String> files, String path) {
  if (File(path).existsSync()) files.add(path);
}
