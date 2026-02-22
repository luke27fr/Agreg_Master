# 🔧 Configuration Firebase & Stores - Guide Complet

## ✅ Développement Déjà Complété

### Infrastructure de Monétisation
1. ✅ **SubscriptionService** : Service d'abonnement avec In-App Purchase
2. ✅ **PayWallPage** : Interface utilisateur premium magnifique
3. ✅ **Logique Freemium** : Limites définies (5 leçons, 10 exercices gratuits)
4. ✅ **Intégration UI** : Ajout dans settings_page, lecons_page
5. ✅ **Dépendances** : Firebase + IAP installées

---

## 🔥 **ÉTAPE 1 : Configuration Firebase**

### A. Créer un Projet Firebase

1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquer sur "Ajouter un projet"
3. Nom du projet : **agreg-master-prod**
4. Activer Google Analytics : **OUI** (recommandé)
5. Configurer Analytics : Créer un compte ou utiliser existant

### B. Ajouter l'Application Android

1. Dans Firebase Console > "Ajouter une application" > **Android**
2. **Nom du package** : `com.agregmaster.app`
   - ⚠️ **IMPORTANT** : Ce nom doit correspondre exactement à celui dans `android/app/build.gradle`
3. Télécharger `google-services.json`
4. Placer le fichier dans : `android/app/google-services.json`

### C. Ajouter l'Application iOS

1. Dans Firebase Console > "Ajouter une application" > **iOS**
2. **Bundle ID** : `com.agregmaster.app`
   - ⚠️ **IMPORTANT** : Doit correspondre à celui dans Xcode
3. Télécharger `GoogleService-Info.plist`
4. Placer le fichier dans : `ios/Runner/GoogleService-Info.plist`

### D. Activer les Services Firebase

Dans Firebase Console, activer :
- ✅ **Authentication** > Sign-in method > Anonymous (pour commencer)
- ✅ **Cloud Firestore** > Créer base de données (mode test au début)
- ✅ **Firebase Crashlytics** > Activer
- ✅ **Google Analytics** > Déjà activé

---

## 📱 **ÉTAPE 2 : Configuration Google Play Console**

### A. Créer un Compte Développeur

1. Aller sur [Google Play Console](https://play.google.com/console/)
2. Inscription (frais uniques : **25 USD**)
3. Remplir les informations légales et bancaires

### B. Créer une Application

1. Dans Play Console > "Créer une application"
2. **Nom** : `Agreg Master`
3. **Langue par défaut** : Français
4. **Type** : Application
5. **Gratuit ou payant** : Gratuit (avec achats intégrés)

### C. Configurer les Abonnements (In-App Products)

1. Dans Play Console > Votre app > **Monétisation** > **Produits**
2. Créer 3 abonnements :

#### Abonnement Mensuel
- **ID du produit** : `agreg_master_premium_monthly`
- **Nom** : Premium Mensuel
- **Description** : Accès illimité pendant 1 mois
- **Prix** : **4,99 €**
- **Période de facturation** : 1 mois
- **Essai gratuit** : 7 jours (optionnel mais recommandé)

#### Abonnement Annuel
- **ID du produit** : `agreg_master_premium_yearly`
- **Nom** : Premium Annuel
- **Description** : Accès illimité pendant 1 an - Meilleure offre
- **Prix** : **39,99 €** (économie de 17%)
- **Période de facturation** : 1 an
- **Essai gratuit** : 7 jours (optionnel)

⚠️ **IMPORTANT** : Les IDs ci-dessus sont déjà codés dans `SubscriptionService.dart`

### D. Configurer le Build Android

Fichiers à créer/modifier :

#### `android/app/build.gradle`
```gradle
android {
    defaultConfig {
        applicationId "com.agregmaster.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-crashlytics'
}

apply plugin: 'com.google.gms.google-services'
```

#### `android/build.gradle`
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    }
}
```

### E. Créer une Clé de Signature

```bash
keytool -genkey -v -keystore ~/agreg-master-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias agreg-master

# Conserver le mot de passe en sécurité !
```

Créer `android/key.properties` :
```properties
storePassword=VOTRE_MOT_DE_PASSE
keyPassword=VOTRE_MOT_DE_PASSE
keyAlias=agreg-master
storeFile=../agreg-master-release-key.jks
```

⚠️ **IMPORTANT** : Ajouter `key.properties` au `.gitignore` !

---

## 🍎 **ÉTAPE 3 : Configuration Apple App Store**

### A. Créer un Compte Développeur Apple

1. Aller sur [Apple Developer](https://developer.apple.com/)
2. Inscription au programme (frais annuels : **99 USD**)
3. Attendre validation (peut prendre 24-48h)

### B. Configurer l'App dans App Store Connect

1. Aller sur [App Store Connect](https://appstoreconnect.apple.com/)
2. "Mes Apps" > "+" > "Nouvelle App"
3. **Nom** : `Agreg Master`
4. **Bundle ID** : `com.agregmaster.app`
5. **SKU** : `agreg-master-2026`
6. **Accès complet ou limité** : Complet

### C. Configurer les Abonnements iOS

1. Dans App Store Connect > Votre app > **Abonnements**
2. Créer un **Groupe d'abonnements** : `Premium`
3. Créer 2 abonnements avec les **mêmes IDs** que Google Play :

- `agreg_master_premium_monthly` - **4,99 €** / mois
- `agreg_master_premium_yearly` - **39,99 €** / an

### D. Configurer Xcode

1. Ouvrir `ios/Runner.xcworkspace` dans Xcode
2. Sélectionner "Runner" (cible)
3. **Signing & Capabilities** :
   - Team : Sélectionner votre équipe
   - Bundle Identifier : `com.agregmaster.app`
   - Activer "Automatically manage signing"
4. **Capabilities** : Ajouter "In-App Purchase"

---

## ⚙️ **ÉTAPE 4 : Configuration Firestore Security Rules**

Dans Firebase Console > Firestore > Règles :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Données utilisateur privées
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Sous-collection subscriptions
      match /subscriptions/{subscriptionId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow write: if false; // Seulement via Cloud Functions
      }
      
      // Sous-collection data (notes, favoris, etc.)
      match /data/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Données publiques (leçons, exercices)
    match /content/{document=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

---

## 🧪 **ÉTAPE 5 : Tests de Développement**

### A. Tester les Achats en Mode Bac à Sable

**Android (Google Play)**
1. Play Console > **Paramètres** > **Compte de développeur**
2. Ajouter des **Testeurs sous licence** (emails Gmail)
3. Ces comptes pourront tester les achats sans payer

**iOS (App Store)**
1. App Store Connect > **Utilisateurs et accès** > **Sandbox**
2. Créer des **Testeurs Sandbox** (emails Apple ID)
3. Utiliser ces comptes dans Paramètres > App Store > Sandbox Account

### B. Activer le Mode Test dans l'Application

Dans `subscription_service.dart`, vous pouvez temporairement utiliser :

```dart
// Pour tester sans acheter (développement uniquement)
Future<void> _testPremiumAccess() async {
  await activatePremiumManually('yearly', days: 365);
}
```

### C. Vérifier Firebase

```bash
# Lancer l'app
flutter run

# Vérifier les logs Firebase
# Dans Firebase Console > Crashlytics / Analytics
# Les événements devraient apparaître dans les 24h
```

---

## 🚀 **ÉTAPE 6 : Build & Déploiement**

### Build Android (APK/AAB)

```bash
# Build AAB pour Play Store
flutter build appbundle --release

# Build APK pour tests
flutter build apk --release

# Fichiers générés :
# build/app/outputs/bundle/release/app-release.aab
# build/app/outputs/flutter-apk/app-release.apk
```

### Build iOS (IPA)

```bash
# Ouvrir Xcode
open ios/Runner.xcworkspace

# Dans Xcode:
# 1. Product > Archive
# 2. Distribute App > App Store Connect
# 3. Upload
```

### Upload vers les Stores

**Google Play Console**
1. Production > **Versions** > **Créer une version**
2. Upload `app-release.aab`
3. Remplir notes de version
4. Envoyer pour examen

**App Store Connect**
1. Dans Xcode après Archive > **Distribute App**
2. Retourner sur App Store Connect
3. Remplir les infos, screenshots
4. **Soumettre pour examen**

---

## 📋 **Checklist Finale avant Publication**

### Légal & Confidentialité
- [ ] CGU rédigées et accessibles dans l'app
- [ ] Politique de confidentialité rédigée
- [ ] Mentions légales complètes
- [ ] Lien de suppression des données (RGPD)

### Contenu de l'Application
- [ ] Toutes les corrections d'examens blancs complétées
- [ ] Annales officielles enrichies (2015-2024)
- [ ] Tests de tous les achats intégrés
- [ ] Vérification de tous les liens externes

### Stores
- [ ] Screenshots de qualité (6 minimum par plateforme)
- [ ] Icône de l'app professionnelle (512x512, 1024x1024)
- [ ] Description store attractive et complète
- [ ] Vidéo de présentation (optionnelle mais recommandée)
- [ ] Catégorie : Éducation
- [ ] Classification d'âge : 4+ / Tout public

### Technique
- [ ] Tests sur Android 8.0 à 14.0+
- [ ] Tests sur iOS 13.0 à 17.0+
- [ ] Taille de l'APK optimisée (<50 MB)
- [ ] Tous les crashs critiques résolus
- [ ] Firebase correctement configuré

---

## 🆘 **Support & Dépannage**

### Erreur : "google-services.json missing"
**Solution** : Télécharger depuis Firebase Console et placer dans `android/app/`

### Erreur : "Purchase not found"
**Solution** : Vérifier que les Product IDs correspondent exactement entre le code et les stores

### Erreur : "Firebase not initialized"
**Solution** : Vérifier que `Firebase.initializeApp()` est bien appelé dans `main()`

### Les achats ne fonctionnent pas en test
**Solution** : 
- Android : Vérifier que vous êtes dans un compte testeur
- iOS : Vérifier que vous êtes connecté avec un compte Sandbox

---

## 📈 **Prochaines Étapes Commerciales**

Une fois l'app publiée :

1. **Marketing** : Créer une landing page web
2. **Réseaux sociaux** : Compte Instagram/Twitter dédié
3. **SEO** : Optimiser pour "agrégation mathématiques"
4. **Partenariats** : Contacter des préparateurs d'agrégation
5. **Publicité** : Google Ads / Facebook Ads ciblées
6. **Analytics** : Suivre taux de conversion Free → Premium

---

## 💰 **Projections de Revenus**

### Hypothèse Conservative (Année 1)
- 500 téléchargements/mois
- Taux de conversion : 5% (25 utilisateurs premium/mois)
- Prix moyen : 40€/an
- **Revenu annuel** : ~12 000€

### Hypothèse Optimiste (Année 2-3)
- 2000 téléchargements/mois
- Taux de conversion : 10% (200 utilisateurs premium/mois)
- Prix moyen : 40€/an
- **Revenu annuel** : ~96 000€

**Note** : Les stores prennent 15-30% de commission

---

## ✅ **STATUS ACTUEL**

✅ **Phase 1 - Infrastructure Monétisation** : **COMPLÉTÉ**
- SubscriptionService créé
- PayWall UI implémenté
- Logique freemium définie
- Firebase + IAP dépendances installées

🔄 **Phase 2 - Configuration Externe** : **EN COURS**
- Vous devez maintenant configurer Firebase Console
- Créer les comptes développeurs (Google Play + Apple)
- Configurer les abonnements dans les stores

📋 **Phase 3 - Contenu & Legal** : **À VENIR**
- Compléter corrections examens blancs
- Enrichir annales officielles
- Rédiger documents légaux

🎨 **Phase 4 - Assets & Polish** : **À VENIR**
- Créer logo professionnel
- Prendre screenshots
- Optimiser performances

---

**Prochaine action recommandée** : Commencer par créer le projet Firebase et télécharger les fichiers de configuration (`google-services.json` et `GoogleService-Info.plist`)
