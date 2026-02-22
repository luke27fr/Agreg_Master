# Guide de Publication - Agreg Master
## Etapes completes pour publier sur Google Play et l'App Store

---

# ETAPE 1 : Generer le keystore (signature Android)

## Qu'est-ce qu'un keystore ?
Un keystore est comme un **passeport numerique** pour votre application. 
Google Play exige que chaque application soit signee avec une cle unique.
Cette cle prouve que VOUS etes le proprietaire de l'app.

> **ATTENTION** : Si vous perdez ce fichier, vous ne pourrez PLUS JAMAIS mettre a jour votre app sur le store. Gardez-en plusieurs copies !

## Instructions pas-a-pas

### 1.1 - Ouvrir un terminal (PowerShell ou CMD)
- Appuyez sur `Windows + R`
- Tapez `cmd` et appuyez sur Entree

### 1.2 - Se placer dans le dossier du projet
```
cd C:\Users\luke2\Documents\Agreg_Master\android
```

### 1.3 - Verifier que Java est installe
```
java -version
```
Si ca affiche un numero de version (ex: "17.0.x"), c'est bon.
Si ca dit "commande non reconnue", installez Java JDK 17 :
- Allez sur https://adoptium.net/
- Telechargez "Temurin JDK 17" pour Windows x64
- Installez-le et relancez votre terminal

### 1.4 - Generer le keystore
Copiez-collez cette commande EXACTEMENT :
```
keytool -genkey -v -keystore agreg-master-release.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias agreg-master
```

Le terminal va vous poser des questions. Voici quoi repondre :

```
Entrez le mot de passe du fichier de cles : 
  -> Choisissez un mot de passe SOLIDE (ex: AgregMaster2026$ecure!)
  -> NOTEZ-LE QUELQUE PART, vous en aurez besoin !

Ressaisissez le mot de passe :
  -> Retapez le meme mot de passe

Quels sont vos nom et prenom ?
  -> Votre vrai nom (ex: Luke Dupont)

Quel est le nom de votre unite organisationnelle ?
  -> Tapez : Development

Quel est le nom de votre entreprise ?
  -> Tapez : AgregMaster (ou votre nom d'entreprise si vous en avez une)

Quel est le nom de votre ville ?
  -> Votre ville (ex: Paris)

Quel est le nom de votre departement/province ?
  -> Votre region (ex: Ile-de-France)

Quel est le code pays a deux lettres ?
  -> FR

Est-ce CN=..., OU=..., O=... correct ?
  -> Tapez : oui (ou yes)

Entrez le mot de passe de la cle pour <agreg-master> :
  -> Appuyez juste sur Entree (meme mot de passe que le store)
```

### 1.5 - Verifier que le fichier a ete cree
```
dir agreg-master-release.jks
```
Vous devriez voir un fichier d'environ 2-3 Ko.

### 1.6 - SAUVEGARDER LE KEYSTORE (CRITIQUE !)
Copiez le fichier `agreg-master-release.jks` dans AU MOINS 2 endroits :
- Une cle USB
- Un dossier cloud (Google Drive, OneDrive, etc.)
- Un disque dur externe

> Si vous perdez ce fichier, vous devrez republier l'app sous un nouveau nom !

---

# ETAPE 2 : Configurer key.properties

## 2.1 - Creer le fichier
Allez dans le dossier `C:\Users\luke2\Documents\Agreg_Master\android\`

Creez un fichier texte nomme **exactement** `key.properties` (sans .txt a la fin !)

### Comment creer le fichier correctement :
1. Ouvrez le Bloc-notes (Notepad)
2. Collez le contenu ci-dessous
3. Allez dans Fichier > Enregistrer sous...
4. Dans "Type", choisissez "Tous les fichiers (*.*)"
5. Dans "Nom du fichier", tapez : `key.properties`
6. Enregistrez dans `C:\Users\luke2\Documents\Agreg_Master\android\`

### Contenu a coller :
```
storePassword=VOTRE_MOT_DE_PASSE_ICI
keyPassword=VOTRE_MOT_DE_PASSE_ICI
keyAlias=agreg-master
storeFile=agreg-master-release.jks
```

### Ce qu'il faut remplacer :
- `VOTRE_MOT_DE_PASSE_ICI` -> Le mot de passe que vous avez choisi a l'etape 1.4
  (les deux lignes doivent avoir le MEME mot de passe)

### Exemple concret (NE PAS utiliser ce mot de passe !) :
```
storePassword=AgregMaster2026$ecure!
keyPassword=AgregMaster2026$ecure!
keyAlias=agreg-master
storeFile=agreg-master-release.jks
```

## 2.2 - Verifier que ca marche
Ouvrez un terminal et lancez :
```
cd C:\Users\luke2\Documents\Agreg_Master
flutter build apk --release
```

Si tout va bien, vous verrez :
```
Built build\app\outputs\flutter-apk\app-release.apk
```

Ce fichier APK est votre application signee, prete pour le store !

> **SECURITE** : Le fichier `key.properties` contient vos mots de passe.
> Il est deja dans le `.gitignore` donc il ne sera PAS envoye sur Git.
> Ne le partagez JAMAIS avec personne.

---

# ETAPE 3 : Creer les pages legales

## Pourquoi c'est obligatoire ?
Google Play et l'App Store EXIGENT que votre app ait :
- Une **Politique de confidentialite** (comment vous utilisez les donnees)
- Des **CGU** (regles d'utilisation)
- Des **Mentions legales** (qui vous etes)

Sans ces pages, votre app sera REFUSEE par les stores.

## Solution la plus simple : GitHub Pages (GRATUIT)

### 3.1 - Creer un depot GitHub pour les pages legales

1. Allez sur https://github.com/new
2. Nom du depot : `agregmaster-legal`
3. Cochez "Public"
4. Cochez "Add a README file"
5. Cliquez "Create repository"

### 3.2 - Activer GitHub Pages

1. Dans votre nouveau depot, allez dans **Settings** (onglet en haut)
2. Dans le menu de gauche, cliquez sur **Pages**
3. Sous "Source", selectionnez **main** et **/ (root)**
4. Cliquez **Save**
5. Attendez 2-3 minutes, votre site sera accessible a :
   `https://VOTRE-USERNAME.github.io/agregmaster-legal/`

### 3.3 - Creer la Politique de confidentialite

Dans votre depot GitHub, cliquez "Add file" > "Create new file"
Nom du fichier : `privacy.html`

Collez ce contenu (personnalisez les parties entre [crochets]) :

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Politique de Confidentialite - Agreg Master</title>
    <style>
        body { font-family: -apple-system, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; color: #333; }
        h1 { color: #1A237E; border-bottom: 2px solid #1A237E; padding-bottom: 10px; }
        h2 { color: #3949AB; margin-top: 30px; }
        .date { color: #666; font-style: italic; }
    </style>
</head>
<body>
    <h1>Politique de Confidentialite</h1>
    <p class="date">Derniere mise a jour : [DATE DU JOUR, ex: 7 fevrier 2026]</p>

    <h2>1. Introduction</h2>
    <p>Agreg Master ("nous", "notre", "l'application") est une application mobile de preparation 
    a l'Agregation de Mathematiques, editee par [VOTRE NOM OU NOM D'ENTREPRISE].</p>
    <p>Nous nous engageons a proteger votre vie privee. Cette politique explique quelles donnees 
    nous collectons et comment nous les utilisons.</p>

    <h2>2. Donnees collectees</h2>
    <h3>2.1 Donnees stockees localement (sur votre appareil)</h3>
    <ul>
        <li>Scores de quiz et progression</li>
        <li>Fiches favorites et notes personnelles</li>
        <li>Historique de lecture</li>
        <li>Preferences de l'application (theme, taille de police)</li>
        <li>Statistiques de serie quotidienne (streak)</li>
    </ul>
    <p>Ces donnees restent sur votre appareil sauf si vous activez la synchronisation cloud.</p>

    <h3>2.2 Donnees de synchronisation cloud (optionnel, Premium uniquement)</h3>
    <p>Si vous activez la synchronisation cloud, vos donnees de progression sont stockees 
    de maniere securisee sur Firebase (Google Cloud) avec un identifiant anonyme. 
    Aucune information personnelle (nom, email) n'est requise.</p>

    <h3>2.3 Donnees d'analyse (anonymes)</h3>
    <ul>
        <li>Firebase Analytics : donnees d'utilisation anonymes (pages visitees, duree des sessions)</li>
        <li>Firebase Crashlytics : rapports de crash techniques (sans donnees personnelles)</li>
    </ul>

    <h2>3. Utilisation des donnees</h2>
    <p>Nous utilisons vos donnees exclusivement pour :</p>
    <ul>
        <li>Vous offrir une experience personnalisee (progression, recommandations)</li>
        <li>Synchroniser vos donnees entre vos appareils (si Premium)</li>
        <li>Ameliorer la stabilite et les performances de l'application</li>
    </ul>

    <h2>4. Partage des donnees</h2>
    <p><strong>Nous ne vendons NI ne partageons vos donnees personnelles avec des tiers.</strong></p>
    <p>Les seuls services tiers utilises sont :</p>
    <ul>
        <li>Firebase (Google) : hebergement cloud et analyse anonyme</li>
        <li>Google Play / App Store : gestion des abonnements</li>
    </ul>

    <h2>5. Securite</h2>
    <p>Vos donnees cloud sont protegees par le chiffrement de Firebase (TLS/SSL). 
    Vos donnees locales sont stockees dans le stockage prive de l'application.</p>

    <h2>6. Vos droits (RGPD)</h2>
    <p>Conformement au Reglement General sur la Protection des Donnees (RGPD), vous avez le droit de :</p>
    <ul>
        <li><strong>Acces</strong> : consulter vos donnees (disponible dans l'application)</li>
        <li><strong>Rectification</strong> : modifier vos donnees</li>
        <li><strong>Suppression</strong> : effacer vos donnees (Parametres > Donnees)</li>
        <li><strong>Portabilite</strong> : exporter vos donnees (fonction Backup)</li>
    </ul>

    <h2>7. Donnees des mineurs</h2>
    <p>L'application est destinee aux etudiants preparant l'Agregation (enseignement superieur).
    Nous ne collectons pas sciemment de donnees de mineurs de moins de 16 ans.</p>

    <h2>8. Modifications</h2>
    <p>Nous pouvons modifier cette politique. Toute modification sera communiquee via 
    une mise a jour de l'application.</p>

    <h2>9. Contact</h2>
    <p>Pour toute question concernant vos donnees personnelles :</p>
    <p>Email : <a href="mailto:[VOTRE-EMAIL]">[VOTRE-EMAIL]</a></p>
</body>
</html>
```

### 3.4 - Creer les CGU (Conditions Generales d'Utilisation)

Creez un nouveau fichier : `terms.html`

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conditions Generales d'Utilisation - Agreg Master</title>
    <style>
        body { font-family: -apple-system, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; color: #333; }
        h1 { color: #1A237E; border-bottom: 2px solid #1A237E; padding-bottom: 10px; }
        h2 { color: #3949AB; margin-top: 30px; }
        .date { color: #666; font-style: italic; }
    </style>
</head>
<body>
    <h1>Conditions Generales d'Utilisation</h1>
    <p class="date">Derniere mise a jour : [DATE DU JOUR]</p>

    <h2>1. Objet</h2>
    <p>Les presentes Conditions Generales d'Utilisation (CGU) regissent l'utilisation de 
    l'application mobile "Agreg Master", editee par [VOTRE NOM OU NOM D'ENTREPRISE].</p>
    <p>En utilisant l'application, vous acceptez les presentes CGU.</p>

    <h2>2. Description du service</h2>
    <p>Agreg Master est une application de revision et de preparation a l'Agregation 
    de Mathematiques. Elle propose :</p>
    <ul>
        <li>Des fiches de cours structurees</li>
        <li>Des quiz et exercices corriges</li>
        <li>Des annales officielles avec corrections</li>
        <li>Des outils de planification et de revision</li>
        <li>Un systeme de repetition espacee</li>
    </ul>

    <h2>3. Acces au service</h2>
    <h3>3.1 Version gratuite</h3>
    <p>L'application offre un acces gratuit a un ensemble limite de fonctionnalites, 
    comprenant les quiz de base, le pomodoro, les badges et le suivi de serie.</p>

    <h3>3.2 Version Premium (abonnement)</h3>
    <p>L'acces complet au contenu est disponible via un abonnement payant. 
    Trois formules sont proposees :</p>
    <ul>
        <li><strong>Mensuel</strong> : renouvellement automatique chaque mois</li>
        <li><strong>Annuel</strong> : renouvellement automatique chaque annee</li>
        <li><strong>Etudiant</strong> : tarif reduit sur presentation d'un justificatif</li>
    </ul>

    <h2>4. Abonnement et paiement</h2>
    <ul>
        <li>Le paiement est effectue via Google Play Store ou Apple App Store</li>
        <li>L'abonnement se renouvelle automatiquement sauf annulation au moins 
        24 heures avant la fin de la periode en cours</li>
        <li>L'annulation se fait dans les parametres de votre compte Google Play 
        ou App Store (pas dans l'application)</li>
        <li>Aucun remboursement n'est effectue pour la periode en cours apres annulation</li>
        <li>Vous pouvez restaurer vos achats en cas de reinstallation</li>
    </ul>

    <h2>5. Propriete intellectuelle</h2>
    <p>L'ensemble du contenu de l'application (textes, exercices, corrections, fiches, 
    design, code) est protege par le droit d'auteur et appartient a [VOTRE NOM OU NOM D'ENTREPRISE].</p>
    <p>Toute reproduction, distribution ou modification non autorisee est interdite.</p>
    <p>Les sujets d'annales officielles sont la propriete du Ministere de l'Education Nationale 
    et sont utilises a des fins pedagogiques.</p>

    <h2>6. Responsabilite</h2>
    <ul>
        <li>L'application est fournie "en l'etat". Nous ne garantissons pas l'absence d'erreurs 
        dans le contenu pedagogique</li>
        <li>L'application ne se substitue pas a un enseignement universitaire</li>
        <li>Nous ne sommes pas responsables des resultats obtenus au concours</li>
        <li>Nous ne sommes pas responsables des pertes de donnees liees a votre appareil</li>
    </ul>

    <h2>7. Donnees personnelles</h2>
    <p>Le traitement de vos donnees est decrit dans notre 
    <a href="privacy.html">Politique de Confidentialite</a>.</p>

    <h2>8. Modification des CGU</h2>
    <p>Nous nous reservons le droit de modifier les presentes CGU. Les utilisateurs seront 
    informes des modifications via une mise a jour de l'application.</p>

    <h2>9. Droit applicable</h2>
    <p>Les presentes CGU sont regies par le droit francais. En cas de litige, les tribunaux 
    de [VOTRE VILLE] seront competents.</p>

    <h2>10. Contact</h2>
    <p>Pour toute question : <a href="mailto:[VOTRE-EMAIL]">[VOTRE-EMAIL]</a></p>
</body>
</html>
```

### 3.5 - Creer les Mentions legales

Creez un nouveau fichier : `legal.html`

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mentions Legales - Agreg Master</title>
    <style>
        body { font-family: -apple-system, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; color: #333; }
        h1 { color: #1A237E; border-bottom: 2px solid #1A237E; padding-bottom: 10px; }
        h2 { color: #3949AB; margin-top: 30px; }
    </style>
</head>
<body>
    <h1>Mentions Legales</h1>

    <h2>Editeur de l'application</h2>
    <ul>
        <li><strong>Nom</strong> : [VOTRE NOM COMPLET]</li>
        <li><strong>Statut</strong> : [Entrepreneur individuel / Auto-entrepreneur / SAS / etc.]</li>
        <li><strong>Adresse</strong> : [VOTRE ADRESSE]</li>
        <li><strong>Email</strong> : <a href="mailto:[VOTRE-EMAIL]">[VOTRE-EMAIL]</a></li>
        <li><strong>SIRET</strong> : [VOTRE NUMERO SIRET SI APPLICABLE]</li>
    </ul>

    <h2>Hebergement des donnees</h2>
    <ul>
        <li><strong>Hebergeur cloud</strong> : Google Firebase (Google LLC)</li>
        <li><strong>Adresse</strong> : 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA</li>
        <li><strong>Distribution</strong> : Google Play Store (Google LLC) et Apple App Store (Apple Inc.)</li>
    </ul>

    <h2>Propriete intellectuelle</h2>
    <p>L'application Agreg Master, son contenu, son design et son code source sont la propriete 
    de [VOTRE NOM OU NOM D'ENTREPRISE] et sont proteges par le droit de la propriete intellectuelle.</p>
    <p>Les sujets de concours officiels sont la propriete du Ministere de l'Education Nationale.</p>

    <h2>Credits</h2>
    <ul>
        <li>Developpe avec Flutter (Google)</li>
        <li>Icones : Material Design Icons (Google)</li>
        <li>Police : Poppins (Google Fonts, licence OFL)</li>
    </ul>

    <h2>Contact</h2>
    <p>Pour toute reclamation ou demande d'information :</p>
    <p>Email : <a href="mailto:[VOTRE-EMAIL]">[VOTRE-EMAIL]</a></p>
</body>
</html>
```

### 3.6 - Mettre a jour les liens dans l'application

Une fois votre site GitHub Pages en ligne, l'URL de vos pages sera :
```
https://luke27fr.github.io/agregmaster-legal/privacy.html
https://luke27fr.github.io/agregmaster-legal/terms.html
https://luke27fr.github.io/agregmaster-legal/legal.html
```

Ces liens sont deja configures dans l'application (paywall + parametres).

---

# RESUME : Checklist avant publication

## Etapes techniques (faites par l'assistant) :
- [x] Permissions Android (INTERNET, ACCESS_NETWORK_STATE)
- [x] Configuration release (minification, obfuscation, ProGuard)
- [x] Firebase Analytics + Crashlytics
- [x] Splash screen
- [x] Nettoyage code debug
- [x] Liens legaux dans l'app (Paywall + Parametres)
- [x] Protection des methodes de test

## Etapes manuelles (a faire par vous) :
- [ ] Etape 1 : Generer le keystore (10 minutes)
- [ ] Etape 2 : Creer key.properties (5 minutes)
- [ ] Etape 3 : Creer les pages legales sur GitHub (30 minutes)
- [ ] Me donner votre username GitHub pour mettre a jour les liens
- [ ] Creer un compte Google Play Developer (25$ une seule fois) : https://play.google.com/console/
- [ ] Creer un compte Apple Developer (99$/an) : https://developer.apple.com/
- [ ] Tester le build release : `flutter build apk --release`

## Pour la soumission Google Play :
- [ ] Preparer 2-8 screenshots de l'app (telephone)
- [ ] Ecrire une description courte (80 caracteres max)
- [ ] Ecrire une description longue (4000 caracteres max)
- [ ] Choisir une icone de 512x512 pixels
- [ ] Uploader l'APK ou AAB (App Bundle recommande)

## Commande pour generer l'App Bundle (recommande par Google) :
```
flutter build appbundle --release
```
Le fichier sera dans : `build\app\outputs\bundle\release\app-release.aab`
