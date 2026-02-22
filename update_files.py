import os
import json

# Chemin vers ton manifest
MANIFEST_PATH = 'assets/fiches/manifest.json'

def update_missing_files():
    # 1. On charge le manifest que tu viens de créer
    with open(MANIFEST_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)

    created_count = 0
    
    # 2. On parcourt chaque thème
    for theme in data['themes']:
        folder_path = theme['path']
        
        # On s'assure que le dossier existe (au cas où)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            print(f"📁 Dossier créé : {folder_path}")

        # 3. On parcourt chaque fichier déclaré dans le JSON
        for filename in theme['files']:
            file_path = os.path.join(folder_path, filename)
            
            # SI LE FICHIER N'EXISTE PAS ENCORE -> ON LE CRÉE
            if not os.path.exists(file_path):
                # On génère un titre joli à partir du nom de fichier
                # ex: 'groupes_finis.md' -> 'Groupes Finis'
                pretty_title = filename.replace('.md', '').replace('_', ' ').title()
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    content = f"""# {pretty_title}

> [!WARNING] **En construction**
> Cette fiche n'a pas encore été rédigée.
>
> *Utilisez l'IA pour générer le contenu de ce chapitre.*

## Plan suggéré
1. Définitions
2. Théorèmes Principaux
3. Exemples et Applications
"""
                    f.write(content)
                print(f"✨ Créé : {filename}")
                created_count += 1
            else:
                # Si le fichier existe déjà, on ne touche à rien !
                pass

    print(f"\n✅ Terminé ! {created_count} nouveaux fichiers ont été générés.")
    print("Ton application ne plantera pas au redémarrage.")

if __name__ == "__main__":
    update_missing_files()