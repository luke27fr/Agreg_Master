# 🎯 ROADMAP COMMERCIALISATION - AGREG MASTER

## 📅 TIMELINE GLOBAL
- **Phase 1 : Préparation (3-4 semaines)**
- **Phase 2 : Monétisation (2 semaines)**
- **Phase 3 : Publication (1-2 semaines)**
- **Phase 4 : Marketing (continu)**

---

## PHASE 1 : PRÉPARATION PRÉ-LANCEMENT

### ✅ A. FINALISATION CONTENU (Semaine 1-2)

#### **PRIORITÉ CRITIQUE**
- [ ] **Annales officielles 2021-2024** (8 sujets restants)
  - Externe 2023 Écrit 1 & 2
  - Externe 2022 Écrit 1 & 2
  - Externe 2021 Écrit 1 & 2
  - Interne 2024 Écrit 1 & 2
  - Minimum : Énoncés + corrections détaillées
  - Bonus : Rapports de jury

- [ ] **Examens blancs** (23 corrections manquantes)
  - Prioriser les 15 questions les plus importantes
  - Qualité > Quantité

- [ ] **Vidéos curées** (30-50 URLs spécifiques)
  - Sélectionner vraies vidéos YouTube
  - Vérifier qualité et pertinence
  - Remplacer les URLs de recherche

#### **IMPORTANT**
- [ ] **Vérification orthographe/grammaire**
  - Relecture complète de tout le contenu
  - Outil : LanguageTool ou Antidote
  
- [ ] **Cohérence pédagogique**
  - Vérifier progression difficulté
  - Uniformiser le ton/style

---

### ✅ B. LÉGAL & JURIDIQUE (Semaine 1)

#### **Documents obligatoires**
- [ ] **Conditions Générales d'Utilisation (CGU)**
  - Droits d'usage
  - Limitations de responsabilité
  - Résiliation
  
- [ ] **Politique de Confidentialité (RGPD)**
  - Collecte de données
  - Utilisation des données
  - Droits utilisateurs (accès, suppression, portabilité)
  - Cookies/tracking
  
- [ ] **Mentions légales**
  - Éditeur (vous ou société)
  - Hébergeur (Firebase/Supabase)
  - Contact support

- [ ] **Conditions d'abonnement**
  - Prix clairement indiqués
  - Durée engagement
  - Modalités de résiliation
  - Politique de remboursement (obligatoire Apple/Google)

#### **Propriété intellectuelle**
- [ ] **Vérifier droits sur le contenu**
  - Fiches : votre création → OK
  - Annales : domaine public (sujets officiels) → OK
  - Vidéos : liens seulement → OK
  - Images/icônes : vérifier licences

- [ ] **Déposer marque "Agreg Master"** (optionnel mais recommandé)
  - INPI (France) : ~250€
  - Protection nom/logo

---

### ✅ C. STRUCTURE COMMERCIALE (Semaine 1-2)

#### **Entité juridique**
Options :
1. **Micro-entreprise** (simple, rapide)
   - Plafond CA : 77,700€/an
   - Charges : ~22% du CA
   - Pas de TVA si < seuil
   
2. **SARL/SAS** (si ambition forte)
   - Plus complexe mais scalable
   - Levée de fonds possible
   
3. **Personne physique** (déconseillé pour commercial)

**Action recommandée :** Commencer en micro-entreprise, évoluer si succès.

#### **Compte bancaire pro**
- [ ] Ouvrir compte bancaire professionnel
- [ ] Lier à Apple Developer + Google Play

---

### ✅ D. INFRASTRUCTURE TECHNIQUE (Semaine 2-3)

#### **Cloud Backend (OBLIGATOIRE pour abonnements)**
- [ ] **Firebase** (recommandé pour démarrer)
  - Firestore : Stockage données utilisateur
  - Firebase Auth : Authentification (Google, Apple, Email)
  - Cloud Functions : Vérification abonnements
  - Firebase Storage : Backup cloud
  
  **OU**
  
- [ ] **Supabase** (alternative open-source)
  - PostgreSQL backend
  - Auth intégrée
  - Moins cher à long terme

#### **Système d'abonnement**
- [ ] **Intégrer In-App Purchase**
  - Package : `in_app_purchase` (Flutter officiel)
  - Configurer produits sur :
    - Google Play Console
    - App Store Connect
  
- [ ] **Définir plans tarifaires**
  - Suggestion :
    - **Gratuit** : 3 leçons + 5 exercices + Maths Intuitives (teaser)
    - **Mensuel** : 4.99€/mois (tout débloqué)
    - **Annuel** : 39.99€/an (économie 33% = 2 mois gratuits)
    - **Étudiant** : 29.99€/an (avec justificatif)

- [ ] **Backend validation**
  - Cloud Function pour vérifier reçus Google/Apple
  - Empêcher piratage
  - Gérer expirations

#### **Analytics & Monitoring**
- [ ] **Firebase Analytics**
  - Tracking usage (quelles pages, combien de temps)
  - Conversion freemium → premium
  - Taux de rétention
  
- [ ] **Crashlytics**
  - Suivi crashes automatique
  - Débogage production

---

### ✅ E. OPTIMISATIONS TECHNIQUES (Semaine 3)

#### **Performance**
- [ ] **Optimiser taille APK/IPA**
  - Actuellement : 22 MB → Objectif : < 15 MB
  - Actions :
    - Compresser images
    - Tree-shaking agressif
    - Split APKs par architecture (arm64, x86)

- [ ] **Temps de chargement**
  - Lazy loading des services
  - Cache assets lourds
  - Compression JSON

#### **Qualité code**
- [ ] **Linter strict**
  - Activer toutes les règles `flutter_lints`
  - Corriger tous les warnings
  
- [ ] **Documentation code**
  - Commenter fonctions publiques
  - README technique pour maintenance

#### **Sécurité**
- [ ] **Obfuscation du code** (pour release)
  - `flutter build --obfuscate --split-debug-info`
  
- [ ] **Vérification certificats**
  - SSL pinning pour API calls
  
- [ ] **Pas de secrets en dur**
  - Utiliser environnement variables
  - Firebase Remote Config pour clés

---

## PHASE 2 : MONÉTISATION

### ✅ A. MODÈLE FREEMIUM (Semaine 4-5)

#### **Contenu gratuit (teaser qualité)**
```dart
// Limites freemium à implémenter
- Leçons : 5 leçons complètes (sélectionnées pour montrer la qualité)
- Exercices : 10 exercices avec corrections
- Examens blancs : 1 sujet complet
- Quiz : Illimité (acquisition utilisateurs)
- Maths Intuitives : 10 concepts (dont les meilleurs)
- Carte mentale : Vue complète (lecture seule)
- Démonstrations : 5 démonstrations
- Annales : 0 (premium seulement = forte incitation)
- Outils organisation : Limité (Pomodoro OK, Planning = premium)
```

#### **Contenu premium (valeur perçue haute)**
```dart
- Toutes les 70+ leçons avec fiches complètes
- 99 exercices + corrections détaillées
- 105 questions examens blancs
- 10 annales officielles 2015-2024 avec rapports jury
- Tous les concepts Maths Intuitives
- Carte mentale interactive (cliquable)
- Planning intelligent + prédictions
- Jury virtuel avancé
- Cloud Sync illimité
- Export PDF illimité
- Support prioritaire
```

#### **Implémentation PayWall**
- [ ] Créer `SubscriptionService`
  ```dart
  class SubscriptionService extends ChangeNotifier {
    bool isPremium = false;
    String? subscriptionType; // 'monthly', 'yearly', 'student'
    DateTime? expirationDate;
    
    Future<void> checkSubscription();
    Future<bool> purchaseSubscription(String productId);
    Future<void> restorePurchases();
    bool canAccess(String feature);
  }
  ```

- [ ] Ajouter PayWall UI
  - Écran onboarding attrayant
  - Comparatif gratuit/premium clair
  - Call-to-action percutants
  - Témoignages/reviews (si disponibles)

---

### ✅ B. MARKETING & BRANDING (Semaine 5)

#### **Identité visuelle**
- [ ] **Logo professionnel**
  - Icône app distinctive
  - Cohérent avec mathématiques/agrégation
  - Format : 1024x1024 pour stores
  
- [ ] **Screenshots/Vidéo promo**
  - 5-8 screenshots pour chaque store
  - Mettre en avant : Maths Intuitives, Annales, Carte mentale
  - Vidéo démo : 30-60 secondes (optionnel mais +30% conversion)

#### **Description store optimisée SEO**
- [ ] **Titre accrocheur**
  - Suggestion : "Agreg Master - Préparation Agrégation Maths"
  
- [ ] **Description courte** (80 caractères)
  - "Oral, Écrit, Annales : Tout pour réussir l'agrégation de maths"
  
- [ ] **Description longue**
  - Mettre en avant USP (Unique Selling Points)
  - Mots-clés : agrégation, mathématiques, oral, écrit, annales, CAPES
  - Call-to-action clair

#### **Site web/Landing page**
- [ ] **Page de présentation**
  - Démo vidéo
  - Tarifs clairs
  - FAQ
  - Témoignages
  - Contact support
  - Liens stores

---

## PHASE 3 : PUBLICATION STORES

### ✅ A. GOOGLE PLAY STORE (Semaine 6)

#### **Compte développeur**
- [ ] **S'inscrire Google Play Console**
  - Frais : 25$ (one-time)
  - Lien : https://play.google.com/console
  
#### **Préparation publication**
- [ ] **Créer fiche application**
  - Catégorie : Éducation
  - Âge minimum : 3+ (contenu éducatif)
  - Prix : Gratuit (avec achats intégrés)
  
- [ ] **Configurer In-App Products**
  - SKU mensuel : `premium_monthly_499`
  - SKU annuel : `premium_yearly_3999`
  - SKU étudiant : `premium_student_2999`

- [ ] **Générer APK/AAB signé**
  ```bash
  flutter build appbundle --release --obfuscate --split-debug-info=./debug-info
  ```
  
- [ ] **Configurer signature app**
  - Créer keystore
  - Configurer `android/key.properties`
  - **CRITIQUE** : Sauvegarder keystore en lieu sûr !

#### **Content rating**
- [ ] Remplir questionnaire Google
  - Contenu éducatif : Très probablement "Everyone"
  
#### **Test track**
- [ ] **Alpha/Beta testing**
  - Commencer par alpha interne
  - Puis beta ouverte (100-500 testeurs)
  - Collecter feedback

---

### ✅ B. APPLE APP STORE (Semaine 6-7)

#### **Compte développeur**
- [ ] **S'inscrire Apple Developer Program**
  - Frais : 99$/an (récurrent)
  - Lien : https://developer.apple.com
  - Nécessite un Mac pour upload final

#### **Préparation publication**
- [ ] **App Store Connect**
  - Créer fiche app
  - Catégorie : Éducation
  - Prix : Gratuit + achats intégrés
  
- [ ] **Configurer In-App Purchases**
  - Mêmes SKU que Android pour cohérence
  - Attendre validation Apple (24-48h)

- [ ] **Build IPA signé**
  ```bash
  flutter build ipa --release --obfuscate --split-debug-info=./debug-info
  ```

- [ ] **TestFlight**
  - Beta testing interne
  - Puis external (10,000 testeurs max)
  - Feedback avant production

#### **App Review Guidelines**
- [ ] **Vérifier conformité**
  - Pas de contenu trompeur
  - Abonnements clairement décrits
  - Politique annulation visible
  - Screenshots représentatifs

---

### ✅ C. ASPECTS LÉGAUX SUPPLÉMENTAIRES

#### **Conformité stores**
- [ ] **Politique remboursement**
  - Google : 48h généralement
  - Apple : 14 jours en Europe
  - Implémenter logique graceful cancellation

- [ ] **Données personnelles**
  - Déclarer collecte données dans stores
  - Privacy Manifest iOS (obligatoire 2024+)
  - Google Play Data Safety

- [ ] **Accessibilité**
  - Tester VoiceOver (iOS) et TalkBack (Android)
  - Contraste couleurs suffisant
  - Textes alt pour images

---

## PHASE 4 : MONÉTISATION - IMPLÉMENTATION

### ✅ A. ARCHITECTURE TECHNIQUE

#### **1. Firebase Setup**

**Fichier : `pubspec.yaml`**
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_analytics: ^11.3.3
  firebase_crashlytics: ^4.1.3
  in_app_purchase: ^3.2.0
  in_app_purchase_storekit: ^0.3.17+3  # iOS
  in_app_purchase_android: ^0.3.6+3     # Android
```

**Fichier : `lib/services/subscription_service.dart`**
```dart
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService extends ChangeNotifier {
  static final InAppPurchase _iap = InAppPurchase.instance;
  
  bool isPremium = false;
  String? currentPlan; // 'monthly', 'yearly', 'student'
  DateTime? expirationDate;
  
  // Product IDs (doivent correspondre aux stores)
  static const String monthlyId = 'premium_monthly_499';
  static const String yearlyId = 'premium_yearly_3999';
  static const String studentId = 'premium_student_2999';
  
  Future<void> initSubscription() async {
    final available = await _iap.isAvailable();
    if (!available) return;
    
    // Charger statut depuis Firestore
    await _loadSubscriptionStatus();
    
    // Écouter achats
    _iap.purchaseStream.listen(_handlePurchaseUpdate);
  }
  
  Future<void> _loadSubscriptionStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final doc = await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(user.uid)
        .get();
    
    if (doc.exists) {
      final data = doc.data()!;
      isPremium = data['isPremium'] ?? false;
      currentPlan = data['plan'];
      expirationDate = (data['expirationDate'] as Timestamp?)?.toDate();
      notifyListeners();
    }
  }
  
  Future<bool> purchaseSubscription(String productId) async {
    final products = await _iap.queryProductDetails({productId});
    if (products.productDetails.isEmpty) return false;
    
    final purchaseParam = PurchaseParam(
      productDetails: products.productDetails.first,
    );
    
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
  
  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Vérifier avec serveur backend
        await _verifyPurchase(purchase);
      }
      
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }
  
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // CRITIQUE : Toujours vérifier côté serveur (Cloud Function)
    // Ne jamais faire confiance au client uniquement
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    // Sauvegarder dans Firestore
    await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(user.uid)
        .set({
      'isPremium': true,
      'plan': _getPlanFromProductId(purchase.productID),
      'purchaseDate': FieldValue.serverTimestamp(),
      'expirationDate': _calculateExpiration(purchase.productID),
      'purchaseToken': purchase.verificationData.serverVerificationData,
    });
    
    isPremium = true;
    notifyListeners();
  }
  
  DateTime _calculateExpiration(String productId) {
    final now = DateTime.now();
    if (productId == monthlyId) return now.add(Duration(days: 30));
    if (productId == yearlyId) return now.add(Duration(days: 365));
    if (productId == studentId) return now.add(Duration(days: 365));
    return now;
  }
  
  bool canAccess(String feature) {
    if (isPremium) return true;
    
    // Features gratuites
    final freeFeatures = [
      'quiz',
      'maths_intuitives_preview', // 10 concepts
      'lecons_preview', // 5 leçons
      'pomodoro',
    ];
    
    return freeFeatures.contains(feature);
  }
  
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
```

**Fichier : `lib/widgets/paywall_widget.dart`**
```dart
class PaywallWidget extends StatelessWidget {
  final String featureName;
  
  const PaywallWidget({required this.featureName, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.amber),
          SizedBox(height: 16),
          Text(
            'Contenu Premium',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Déverrouillez $featureName et tout le contenu pour réussir l\'agrégation',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          _buildPricingCard('Mensuel', '4,99€/mois', Colors.blue),
          SizedBox(height: 12),
          _buildPricingCard('Annuel', '39,99€/an', Colors.green, 
            badge: 'Économisez 33%'),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(...),
            child: Text('Voir les options'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Peut-être plus tard'),
          ),
        ],
      ),
    );
  }
}
```

---

### ✅ B. BACKEND CLOUD FUNCTIONS (SÉCURITÉ)

**Fichier : `functions/src/index.ts` (Firebase)**
```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Vérifier reçu Google Play
export const verifyAndroidPurchase = functions.https.onCall(async (data, context) => {
  const { purchaseToken, productId } = data;
  const uid = context.auth?.uid;
  
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  
  // Vérifier avec Google Play API
  // Utiliser @googleapis/androidpublisher
  const isValid = await verifyWithGooglePlay(purchaseToken, productId);
  
  if (isValid) {
    await admin.firestore().collection('subscriptions').doc(uid).set({
      isPremium: true,
      plan: productId,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  
  return { success: isValid };
});

// Vérifier reçu Apple App Store
export const verifyIOSPurchase = functions.https.onCall(async (data, context) => {
  const { receipt, productId } = data;
  const uid = context.auth?.uid;
  
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  
  // Vérifier avec Apple App Store API
  const isValid = await verifyWithAppStore(receipt);
  
  if (isValid) {
    await admin.firestore().collection('subscriptions').doc(uid).set({
      isPremium: true,
      plan: productId,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  
  return { success: isValid };
});

// Webhook pour renouvellements/expirations (Apple Server-to-Server)
export const appleWebhook = functions.https.onRequest(async (req, res) => {
  // Apple envoie notifications automatiques
  // Ex: RENEWAL, DID_FAIL_TO_RENEW, etc.
  const notification = req.body;
  
  // Mettre à jour Firestore selon type notification
  // ...
  
  res.status(200).send('OK');
});

// Webhook Google Play (Real-time Developer Notifications)
export const googleWebhook = functions.https.onRequest(async (req, res) => {
  // Google envoie notifications Pub/Sub
  // ...
  
  res.status(200).send('OK');
});
```

---

## PHASE 5 : MARKETING & ACQUISITION

### ✅ A. STRATÉGIE LANCEMENT

#### **Pré-lancement (2-3 semaines avant)**
- [ ] **Créer buzz sur réseaux sociaux**
  - Twitter/X : #agrégation #maths #concours
  - LinkedIn : Groupes profs de maths
  - Reddit : r/france, r/AgrégationMaths (si existe)
  
- [ ] **Liste d'attente email**
  - Landing page avec inscription
  - Offre early-bird : -20% première année

#### **Canaux acquisition**
1. **Organic (gratuit)**
   - SEO App Stores (mots-clés optimisés)
   - Bouche-à-oreille
   - Forums prépa agrégation
   
2. **Partenariats**
   - Universités/prépas agrégation
   - Profs de maths influents
   - Associations étudiantes
   
3. **Paid (si budget)**
   - Google Ads : recherches "préparation agrégation"
   - Facebook/Instagram : ciblage étudiants M1/M2 maths
   - YouTube : sponsoring chaînes maths

#### **Pricing stratégie**
- [ ] **Lancement promotionnel**
  - 30 premiers jours : -30% (2.99€/mois au lieu de 4.99€)
  - Créer urgence
  
- [ ] **Offre étudiant**
  - Vérification carte étudiant (manuelle au début)
  - 29.99€/an = prix très accessible

---

### ✅ B. MÉTRIQUES DE SUCCÈS

#### **KPIs à tracker**
```dart
// À implémenter dans Analytics
1. Downloads : Objectif 1000 premier mois
2. Conversion freemium → premium : 2-5% standard
3. Taux rétention J7 : >40%
4. Taux rétention J30 : >20%
5. LTV (Lifetime Value) : >50€ par utilisateur premium
6. Churn rate : <10%/mois
```

---

## 💰 BUSINESS MODEL - PROJECTIONS

### **Scénario Conservateur (An 1)**

**Hypothèses :**
- 5000 downloads première année
- Conversion : 3% (150 premium)
- Mix : 60% mensuel, 40% annuel
- Churn : 15%/mois

**Revenus annuels :**
- Mensuel : 90 × 4.99€ × 8 mois (moyenne) = 3,600€
- Annuel : 60 × 39.99€ = 2,400€
- **Total An 1 : ~6,000€ net** (après frais stores 30%)

### **Scénario Optimiste (An 2)**

**Hypothèses :**
- 20,000 downloads
- Conversion : 5%
- Meilleure rétention (churn 10%)

**Revenus annuels :**
- **Total An 2 : ~40,000€ net**

---

## 📱 ÉCOSYSTÈME AMATHS - STRATÉGIE MULTI-APP

### **Architecture globale**

```
AMATHS ÉCOSYSTÈME
├── Agreg Master (agrégation) ✅ EN COURS
├── AMaths Lycée (nouveau) 
│   ├── Première Spé Maths
│   ├── Terminale Spé Maths  
│   └── Maths Expertes
└── AMaths CAPES (futur optionnel)
```

### **Synergie entre apps**

#### **1. Code partagé (Flutter Package)**
```
packages/
├── amaths_core/
│   ├── widgets/ (composants réutilisables)
│   ├── services/ (SubscriptionService, AnalyticsService)
│   └── models/ (User, Subscription, Progress)
├── amaths_ui/ (Design System unifié)
└── amaths_content/ (Moteur rendu LaTeX, Markdown)
```

**Avantages :**
- ✅ Développement 3x plus rapide app 2
- ✅ Cohérence UX/UI entre apps
- ✅ Bugs fixés dans une app = fixés partout

#### **2. Modèle tarifaire écosystème**

**Option A : Apps séparées**
- AMaths Lycée : 2.99€/mois ou 24.99€/an
- Agreg Master : 4.99€/mois ou 39.99€/an
- **Bundle** : 6.99€/mois ou 54.99€/an (économie 30%)

**Option B : App unique avec modules**
- App "AMaths Complete"
- Débloquer par niveau : Lycée, Agrégation, CAPES
- Plus complexe à gérer mais meilleure cross-sell

**Recommandation :** Option A (simplicité)

#### **3. Cross-promotion**
```dart
// Dans Agreg Master
if (user.age < 20 || user.level == 'L1') {
  showBanner("Vous préparez le bac ? Découvrez AMaths Lycée !");
}

// Dans AMaths Lycée
if (user.completionRate > 80%) {
  showBanner("Prêt pour l'agrégation ? Découvrez Agreg Master !");
}
```

---

## 🎓 AMATHS LYCÉE - SPEC RAPIDE

### **Contenu à créer**

#### **Première Spé Maths**
- Suites numériques
- Fonctions (dérivation, limites)
- Géométrie repérée
- Probabilités conditionnelles
- Variables aléatoires
- ~25 chapitres

#### **Terminale Spé Maths**
- Suites (récurrence, limites)
- Fonctions (continuité, convexité, expo/log)
- Primitives et intégrales
- Équations différentielles
- Géométrie dans l'espace
- Probabilités (lois continues)
- ~30 chapitres

#### **Maths Expertes**
- Nombres complexes
- Arithmétique (congruences, Bézout)
- Matrices
- Graphes
- ~15 chapitres

### **Fonctionnalités adaptées lycée**

```dart
// Simplifier vs Agreg Master
✅ Garder :
- Fiches de cours
- Exercices avec corrigés
- Quiz
- Flashcards SRS
- Maths Intuitives (adapter au niveau)
- Planning révisions Bac
- Pomodoro
- Badges

❌ Retirer (pas pertinent lycée) :
- Simulation oral 45min
- Jury virtuel
- Développements
- Annales agrégation
- Carte mentale complexe

➕ Ajouter (spécifique lycée) :
- Annales BAC (2015-2024)
- Sujets type E3C/Spécialité
- Calculatrice graphique intégrée
- Aide parentale (suivi progression pour parents)
- Révisions Brevet (pour élèves faibles)
```

### **Différenciation pédagogique**

| Aspect | Agreg Master | AMaths Lycée |
|--------|--------------|--------------|
| Ton | Professionnel, exigeant | Accessible, encourageant |
| Difficulté | Très élevée | Modulaire (facile → difficile) |
| Exemples | Théoriques, abstraits | Concrets, vie quotidienne |
| Volume | Dense, complet | Progressif, digestible |
| Autonomie | Totale | Guidé avec tutos |

---

## ⚡ PLAN D'ACTION IMMÉDIAT

### **SEMAINE 1-2 : Finaliser Agreg Master**
1. Compléter 8 annales restantes
2. Finir 23 corrections examens blancs
3. Implémenter Firebase + Auth
4. Créer SubscriptionService

### **SEMAINE 3-4 : Monétisation**
1. Configurer In-App Purchase
2. Créer PayWall UI
3. Implémenter logique freemium
4. Tester achats sandbox (Google + Apple)

### **SEMAINE 5-6 : Légal & Publication**
1. Rédiger CGU + Confidentialité
2. Créer comptes développeur
3. Préparer assets stores (logo, screenshots, vidéo)
4. Soumettre pour review

### **SEMAINE 7-8 : Lancement**
1. Beta testing (100 utilisateurs)
2. Correction bugs critiques
3. Publication publique
4. Marketing initial

### **MOIS 3-6 : Développer AMaths Lycée**
1. Réutiliser architecture Agreg Master
2. Adapter contenu niveau lycée
3. Lancement T2 2026

---

## 💡 MES RECOMMANDATIONS STRATÉGIQUES

### **1. FOCUS court-terme : Agreg Master parfait**
Ne vous dispersez pas. Une app excellente vaut mieux que deux moyennes.

**Objectif :** Lancer Agreg Master COMPLET avant septembre 2026 (rentrée = pic demande).

### **2. Validation marché AVANT gros investissement**
- Lancer version beta gratuite
- Collecter emails intéressés
- Sonder willingness-to-pay (combien prêts à payer ?)
- **SI succès** → Investir temps sur AMaths Lycée

### **3. Marché lycée = 100x plus grand**
- Agrégation : ~1500 candidats/an (France)
- Bac Spé Maths : ~150,000 élèves/an
- **Mais** : Plus de concurrence (apps établies)

**Stratégie :** Commencer par agrégation (niche, moins de concurrence), prouver le modèle, puis scaler sur lycée.

### **4. Prix psychologiques**
- **4.99€/mois** = prix "café" (acceptable impulsif)
- **39.99€/an** = "4 mois gratuits" (rationnel)
- Éviter 9.99€+ (barrière psychologique lycéens/étudiants)

### **5. Marketing étudiant = bouche-à-oreille**
- Excellent produit = marketing gratuit
- Programme parrainage : 1 mois gratuit par filleul
- Versions établissements (licences groupées)

---

## 🎯 VOULEZ-VOUS QUE JE COMMENCE L'IMPLÉMENTATION ?

Je peux implémenter **maintenant** :

**A)** Firebase + Auth + SubscriptionService (base monétisation)

**B)** Compléter les 8 annales restantes (contenu prioritaire)

**C)** Créer le PayWall + logique freemium

**D)** Préparer les documents légaux (CGU, Confidentialité)

**E)** Autre chose ?

**Quelle priorité souhaitez-vous que je traite en premier ?**