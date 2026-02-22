// ignore_for_file: avoid_print
//
// Génère assets/fiches/manifest.json en scannant les dossiers
// sous assets/fiches/ et en listant les fichiers .md de chaque thème.
//
// Exécution (depuis la racine du projet) :
//   dart run tool/generate_manifest.dart
// ou :
//   dart tool/generate_manifest.dart
//

import 'dart:convert';
import 'dart:io';

const String fichesDir = 'assets/fiches';
const String manifestPath = 'assets/fiches/manifest.json';

/// Labels affichés pour certains dossiers (sinon titre dérivé du nom du dossier).
const Map<String, String> _labelOverrides = {
  'algebre': 'Algèbre',
  'analyse': 'Analyse',
};

void main() {
  final projectRoot = Directory.current;
  final fiches = Directory('${projectRoot.path}/$fichesDir');

  if (!fiches.existsSync()) {
    print('Erreur: le dossier $fichesDir n\'existe pas.');
    exit(1);
  }

  final themes = <Map<String, dynamic>>[];

  for (final entity in fiches.listSync()) {
    if (entity is! Directory) continue;

    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    // Ignorer les dossiers cachés / spéciaux
    if (name.startsWith('.')) continue;

    final path = '$fichesDir/$name';
    final mdFiles = _listMdFiles(entity);

    themes.add({
      'id': name,
      'label': _labelOverrides[name] ?? _toTitleCase(name),
      'path': path,
      'files': mdFiles..sort(),
    });
  }

  // Tri par id pour un manifest stable
  themes.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));

  final manifest = {'themes': themes};
  final json = const JsonEncoder.withIndent('  ').convert(manifest);

  final manifestFile = File('${projectRoot.path}/$manifestPath');
  manifestFile.parent.createSync(recursive: true);
  manifestFile.writeAsStringSync('$json\n');

  print('$manifestPath généré avec ${themes.length} thème(s).');
  for (final t in themes) {
    final files = t['files'] as List<String>;
    print('  - ${t['label']}: ${files.length} fiche(s)');
  }
}

/// Liste les fichiers .md (uniquement l’extension .md) dans [dir].
List<String> _listMdFiles(Directory dir) {
  final list = <String>[];
  for (final entity in dir.listSync()) {
    if (entity is! File) continue;
    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    if (name.toLowerCase().endsWith('.md')) list.add(name);
  }
  return list;
}

String _toTitleCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
