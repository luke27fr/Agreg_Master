import 'dart:io';
import 'dart:convert';

// Chemin vers ton manifest
const String manifestPath = 'assets/fiches/manifest.json';

void main() async {
  final file = File(manifestPath);

  if (!file.existsSync()) {
    print("❌ Erreur : Le fichier $manifestPath est introuvable.");
    return;
  }

  // 1. On lit le manifest
  String content = await file.readAsString();
  Map<String, dynamic> data = jsonDecode(content);
  int createdCount = 0;

  // 2. On parcourt les thèmes
  List<dynamic> themes = data['themes'];
  for (var theme in themes) {
    String folderPath = theme['path'];
    
    // Création du dossier si nécessaire
    Directory(folderPath).createSync(recursive: true);

    List<dynamic> files = theme['files'];
    for (String filename in files) {
      String filePath = '$folderPath/$filename';
      File markdownFile = File(filePath);

      // SI LE FICHIER N'EXISTE PAS -> ON LE CRÉE
      if (!markdownFile.existsSync()) {
        String title = filename
            .replaceAll('.md', '')
            .replaceAll('_', ' ')
            .split(' ')
            .map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '')
            .join(' ');

        String template = """# $title

> [!WARNING] **En construction**
> Cette fiche n'a pas encore été rédigée.
>
> *Utilisez l'IA pour générer le contenu de ce chapitre.*

## Plan suggéré
1. Définitions
2. Théorèmes Principaux
3. Exemples et Applications
""";

        await markdownFile.writeAsString(template);
        print("✨ Créé : $filename");
        createdCount++;
      }
    }
  }

  print("\n✅ Terminé ! $createdCount nouveaux fichiers ont été générés.");
}