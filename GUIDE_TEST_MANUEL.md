# 🧪 Guide de Test Manuel - Agreg Master

## ✅ APPLICATION LANCÉE SUR WINDOWS !

**L'application est maintenant en cours d'exécution sur votre ordinateur Windows.**

---

## 🎯 TESTS À EFFECTUER

### 📍 **1. NAVIGATION - HUB PRINCIPAL**

#### Test de Base
- [ ] 1. Vérifier que le Hub principal s'affiche correctement
- [ ] 2. Vérifier que toutes les cartes sont visibles
- [ ] 3. Vérifier le scroll (haut/bas)
- [ ] 4. Vérifier le thème (clair/sombre dans Paramètres)

#### Nouvelles Fonctionnalités
- [ ] 5. **Cliquer sur "☁️ Sauvegarde & Cloud"**
  - ✅ Page s'ouvre ?
  - ✅ Carte de statut visible ?
  - ✅ 4 boutons d'actions visibles ?
  
- [ ] 6. **Cliquer sur "Annales Officielles"**
  - ✅ Page s'ouvre ?
  - ✅ 5 annales affichées ?
  - ✅ Filtres fonctionnels ?
  
- [ ] 7. **Cliquer sur "💡 Maths Intuitives"**
  - ✅ Page s'ouvre ?
  - ✅ 36 concepts listés ?
  - ✅ Filtrage par domaine fonctionne ?

---

### ☁️ **2. CLOUD SYNC - BACKUP/RESTORE**

#### Test Création de Backup
- [ ] 1. Ouvrir "☁️ Sauvegarde & Cloud"
- [ ] 2. Cliquer sur "**Créer une sauvegarde**"
- [ ] 3. **Vérifier :**
  - ✅ Message vert "✅ Sauvegarde créée avec succès !"
  - ✅ Carte de statut passe à "À jour" (vert)
  - ✅ Liste des backups affiche 1 backup
  - ✅ Date + Taille affichées

**RÉSULTAT ATTENDU :**
```
Statut : 🟢 À jour
Dernière sauvegarde : Il y a moins d'1 min
Liste : 1 backup affiché avec date + taille
```

#### Test Export
- [ ] 4. Cliquer sur "**Exporter les données**"
- [ ] 5. **Vérifier :**
  - ✅ Dialogue de partage s'ouvre
  - ✅ Fichier `.json` proposé
  - ⚠️ Sur Windows Desktop, Share peut ne pas fonctionner (normal)

#### Test Restauration
- [ ] 6. **AVANT** : Ajouter un favori dans une fiche
- [ ] 7. Créer un nouveau backup
- [ ] 8. Supprimer le favori
- [ ] 9. Retour à "Sauvegarde & Cloud"
- [ ] 10. Cliquer sur l'icône **🔄 Restaurer** du backup
- [ ] 11. Confirmer la restauration
- [ ] 12. **Vérifier :**
  - ✅ Message "✅ Restauration réussie !"
  - ✅ Le favori est de retour !

#### Test Suppression
- [ ] 13. Créer 2-3 backups (cliquer plusieurs fois)
- [ ] 14. Cliquer sur l'icône **🗑️ Supprimer** d'un backup
- [ ] 15. Confirmer la suppression
- [ ] 16. **Vérifier :**
  - ✅ Backup disparu de la liste
  - ✅ Message de confirmation

#### Test Nettoyage
- [ ] 17. Cliquer sur "**Nettoyer vieux backups**"
- [ ] 18. **Vérifier :**
  - ✅ Message "Aucune sauvegarde ancienne" (si tous récents)
  - OU Confirmation de suppression

---

### 📚 **3. ANNALES OFFICIELLES**

#### Test Affichage
- [ ] 1. Ouvrir "Annales Officielles"
- [ ] 2. **Vérifier :**
  - ✅ 5 annales affichées
  - ✅ Années 2022, 2023, 2024 visibles
  - ✅ Badges "Externe" / "Interne"
  - ✅ Badges de difficulté colorés

#### Test Filtres
- [ ] 3. Filtrer par **Année = 2024**
  - ✅ Seulement les annales 2024 affichées
  
- [ ] 4. Filtrer par **Session = Externe**
  - ✅ Seulement les annales Externe
  
- [ ] 5. Filtrer par **Type = Écrit 1**
  - ✅ Seulement les Écrits 1

- [ ] 6. Réinitialiser les filtres
  - ✅ Les 5 annales réapparaissent

#### Test Vue Détaillée
- [ ] 7. Cliquer sur une annale
- [ ] 8. **Vérifier :**
  - ✅ Modal s'ouvre
  - ✅ Titre + Description visibles
  - ✅ Sections d'exercices affichées
  - ✅ Questions avec numéros
  - ✅ Corrections détaillées visibles
  - ✅ Bouton "📄 Consulter le sujet officiel"

#### Test Lien Officiel
- [ ] 9. Cliquer sur "📄 Consulter le sujet officiel"
- [ ] 10. **Vérifier :**
  - ⚠️ Lien peut être un placeholder (normal)
  - OU Ouverture du PDF si URL réelle

---

### 💡 **4. MATHS INTUITIVES**

#### Test Affichage
- [ ] 1. Ouvrir "💡 Maths Intuitives"
- [ ] 2. **Vérifier :**
  - ✅ 36 concepts affichés
  - ✅ Domaines : Algèbre, Analyse, Géométrie, Probabilités
  - ✅ Icônes colorées par domaine

#### Test Filtrage
- [ ] 3. Sélectionner **Algèbre**
  - ✅ ~12 concepts d'algèbre affichés
  
- [ ] 4. Sélectionner **Analyse**
  - ✅ ~14 concepts d'analyse affichés
  
- [ ] 5. Sélectionner **Tous**
  - ✅ Les 36 concepts réapparaissent

#### Test Vue Concept
- [ ] 6. Cliquer sur "Valeurs propres"
- [ ] 7. **Vérifier :**
  - ✅ Page détail s'ouvre
  - ✅ Section "🎯 Analogie" présente
  - ✅ Section "💡 Explication intuitive" présente
  - ✅ Section "📝 Exemple concret" présente
  - ✅ Section "📚 Leçons associées" avec liens cliquables
  - ✅ Bouton "Marquer comme compris" fonctionnel

---

### 📝 **5. EXAMENS BLANCS**

#### Test Corrections Enrichies
- [ ] 1. Ouvrir "Examens Blancs"
- [ ] 2. Choisir un examen (ex : Analyse 2)
- [ ] 3. **Vérifier :**
  - ✅ Questions avec corrections affichent ExpansionTile
  - ✅ Corrections détaillées visibles
  - ✅ Questions SANS correction affichent :
    - 🟠 Encadré orange
    - ⏳ Icône sablier
    - 💬 Message "Correction bientôt disponible"
    - 💡 Mention de l'indication si présente

#### Test Progression
- [ ] 4. En haut de page, vérifier :
  - ✅ "82/105 questions avec corrections (78%)"
  - ✅ Barre de progression à 78%

---

### 🏋️ **6. EXERCICES CLASSIQUES**

#### Test Affichage
- [ ] 1. Ouvrir "Exercices Classiques"
- [ ] 2. **Vérifier :**
  - ✅ ~76 exercices affichés
  - ✅ Filtres : Domaine (Algèbre, Analyse, etc.)
  - ✅ Filtres : Niveau (Facile, Moyen, Difficile)

#### Test Nouveaux Exercices
- [ ] 3. Chercher "Théorème spectral"
- [ ] 4. Chercher "Cauchy-Lipschitz"
- [ ] 5. Chercher "TCL" (Théorème Central Limite)
- [ ] 6. **Vérifier :**
  - ✅ Exercices présents
  - ✅ Solutions en plusieurs étapes
  - ✅ Indications disponibles

---

### 🎬 **7. VIDÉOS (Démonstrations)**

#### Test Structure Optimisée
- [ ] 1. Ouvrir "Démonstrations"
- [ ] 2. Choisir une démonstration (ex : Lagrange, Rolle)
- [ ] 3. **Vérifier :**
  - ✅ Section "🎬 Vidéos recommandées" présente
  - ✅ Métadonnées affichées :
    - 👤 Auteur (El Jj, Prépa Agreg Maths, etc.)
    - ⏱️ Durée
    - ⭐ Qualité
    - 🏷️ Tags (cours, démonstration, etc.)

---

### 🔍 **8. RECHERCHE GLOBALE**

#### Test Loupe
- [ ] 1. **Dans TOUTES les pages**, vérifier :
  - ✅ Icône 🔍 visible en haut à droite (AppBar)
  
- [ ] 2. Cliquer sur la loupe
- [ ] 3. **Vérifier :**
  - ✅ Page de recherche s'ouvre
  - ✅ Champ de saisie fonctionnel
  
- [ ] 4. Chercher "Lagrange"
- [ ] 5. **Vérifier :**
  - ✅ Résultats pertinents (leçons, démos, etc.)

---

### 🎨 **9. UI/UX**

#### Test Thème
- [ ] 1. Ouvrir Paramètres (si accessible)
- [ ] 2. Changer le thème (Clair ↔ Sombre)
- [ ] 3. **Vérifier :**
  - ✅ Changement appliqué immédiatement
  - ✅ Toutes les pages s'adaptent

#### Test Responsive
- [ ] 4. Redimensionner la fenêtre Windows
- [ ] 5. **Vérifier :**
  - ✅ Pas de débordement de texte
  - ✅ Cartes s'adaptent
  - ✅ Boutons restent accessibles

#### Test Animations
- [ ] 6. Naviguer entre pages
- [ ] 7. **Vérifier :**
  - ✅ Transitions fluides
  - ✅ Pas de lag ou freeze
  - ✅ Aucune erreur dans la console

---

## 📊 CHECKLIST FINALE

### Compilation & Lancement ✅
- [x] Application compile sans erreurs
- [x] Application lance en 34.6s
- [x] Aucun crash au démarrage

### Navigation ⏳
- [ ] Hub principal OK
- [ ] Sauvegarde & Cloud accessible
- [ ] Annales accessible
- [ ] Maths Intuitives accessible
- [ ] Toutes les autres pages accessibles

### Fonctionnalités Cloud ⏳
- [ ] Création backup fonctionne
- [ ] Export fonctionne
- [ ] Restauration fonctionne
- [ ] Suppression fonctionne
- [ ] Liste des backups OK

### Contenu ⏳
- [ ] 5 annales affichées
- [ ] Filtres annales fonctionnels
- [ ] 36 concepts intuitifs OK
- [ ] 82/105 corrections visibles
- [ ] 76 exercices accessibles
- [ ] Vidéos structurées

### UI/UX ⏳
- [ ] Thème clair/sombre
- [ ] Responsive
- [ ] Animations fluides
- [ ] Loupe recherche présente partout

---

## 🐛 RAPPORT DE BUGS

**Si vous trouvez un bug, notez :**

### Bug #1
- **Page :** _____________________
- **Action :** _____________________
- **Erreur :** _____________________
- **Screenshot :** (optionnel)

### Bug #2
- **Page :** _____________________
- **Action :** _____________________
- **Erreur :** _____________________
- **Screenshot :** (optionnel)

---

## 💬 FEEDBACK UTILISATEUR

### Points Positifs ✅
1. _____________________
2. _____________________
3. _____________________

### Points à Améliorer 🔸
1. _____________________
2. _____________________
3. _____________________

### Suggestions 💡
1. _____________________
2. _____________________
3. _____________________

---

## 🎯 INSTRUCTIONS SPÉCIALES

### Pour Tester le Backup/Restore :

**SCÉNARIO COMPLET :**

1. **Créer des données :**
   - Ajouter 3-5 favoris dans différentes fiches
   - Ajouter quelques notes personnelles
   - Compléter 1-2 exercices

2. **Créer un backup :**
   - Aller dans "☁️ Sauvegarde & Cloud"
   - Cliquer "Créer une sauvegarde"
   - Vérifier : backup créé, taille ~XX KB

3. **Modifier les données :**
   - Supprimer tous les favoris
   - Supprimer les notes
   - Réinitialiser les exercices

4. **Restaurer :**
   - Retour à "Sauvegarde & Cloud"
   - Cliquer 🔄 sur le backup précédent
   - Confirmer
   - **VÉRIFIER :** Tous les favoris/notes sont de retour !

5. **✅ SI OUI → Cloud Sync fonctionne parfaitement !**

---

## 🚀 COMMANDES UTILES

### Pendant le test :

**Hot Reload (après modification code) :**
```
Dans le terminal Flutter : Appuyer sur 'r'
```

**Hot Restart (redémarrage complet) :**
```
Dans le terminal Flutter : Appuyer sur 'R'
```

**Arrêter l'application :**
```
Dans le terminal Flutter : Appuyer sur 'q'
```

**Voir les logs :**
```
Regarder le terminal Flutter
```

---

## 📝 COMMENT REMPLIR CE GUIDE

1. **Cochez [ ]** chaque test effectué avec [x]
2. **Notez** tout bug dans "Rapport de bugs"
3. **Donnez** votre feedback
4. **Partagez** vos impressions !

---

## ✅ RÉSULTAT FINAL

**Une fois TOUS les tests effectués :**

### Note Globale : ___ / 10

### Verdict :
- [ ] 🟢 Prêt pour production
- [ ] 🟡 Améliorations mineures nécessaires
- [ ] 🔴 Bugs critiques à corriger

---

**Bon test ! 🧪📱**

**Questions ? Besoin d'aide ? Demandez ! 😊**
