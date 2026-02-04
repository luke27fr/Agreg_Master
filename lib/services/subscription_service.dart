import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences.dart';
import 'dart:async';

/// Service de gestion des abonnements premium
/// Gère In-App Purchase (Google Play + App Store) et logique freemium
class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // État de l'abonnement
  bool _isPremium = false;
  String? _currentPlan; // 'monthly', 'yearly', 'student'
  DateTime? _expirationDate;
  bool _isLoading = false;
  String? _error;

  // Product IDs (doivent correspondre aux configurations stores)
  static const String monthlyId = 'agreg_master_premium_monthly';
  static const String yearlyId = 'agreg_master_premium_yearly';
  static const String studentId = 'agreg_master_premium_student';

  // Getters
  bool get isPremium => _isPremium;
  String? get currentPlan => _currentPlan;
  DateTime? get expirationDate => _expirationDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialiser le service d'abonnement
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Vérifier disponibilité In-App Purchase
      final available = await _iap.isAvailable();
      if (!available) {
        _error = 'In-App Purchase non disponible';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Charger statut depuis stockage local
      await _loadSubscriptionStatus();

      // Écouter les mises à jour d'achats
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) {
          debugPrint('Erreur stream achats: $error');
          _error = error.toString();
          notifyListeners();
        },
      );

      // Restaurer achats précédents (important au premier lancement)
      await restorePurchases();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur initialisation subscription: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charger le statut d'abonnement depuis le stockage local
  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('isPremium') ?? false;
    _currentPlan = prefs.getString('currentPlan');
    
    final expirationTimestamp = prefs.getInt('expirationDate');
    if (expirationTimestamp != null) {
      _expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp);
      
      // Vérifier si expiré
      if (_expirationDate!.isBefore(DateTime.now())) {
        _isPremium = false;
        _currentPlan = null;
        await _saveSubscriptionStatus();
      }
    }
  }

  /// Sauvegarder le statut d'abonnement localement
  Future<void> _saveSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', _isPremium);
    await prefs.setString('currentPlan', _currentPlan ?? '');
    if (_expirationDate != null) {
      await prefs.setInt('expirationDate', _expirationDate!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('expirationDate');
    }
  }

  /// Récupérer les produits disponibles
  Future<List<ProductDetails>> getAvailableProducts() async {
    final Set<String> productIds = {monthlyId, yearlyId, studentId};
    
    final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);
    
    if (response.error != null) {
      _error = response.error!.message;
      notifyListeners();
      return [];
    }

    return response.productDetails;
  }

  /// Acheter un abonnement
  Future<bool> purchaseSubscription(String productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final products = await getAvailableProducts();
      final product = products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Produit non trouvé'),
      );

      final purchaseParam = PurchaseParam(productDetails: product);
      
      // Lancer l'achat
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('Erreur achat: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Gérer les mises à jour d'achats
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // En attente de paiement
        _isLoading = true;
        notifyListeners();
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Achat réussi
        await _verifyAndActivatePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Erreur
        _error = purchase.error?.message ?? 'Erreur d\'achat';
        _isLoading = false;
        notifyListeners();
      }

      // Compléter l'achat
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Vérifier et activer un achat
  Future<void> _verifyAndActivatePurchase(PurchaseDetails purchase) async {
    // TODO: En production, TOUJOURS vérifier avec backend (Cloud Function)
    // Pour éviter le piratage
    // Pour l'instant, on active directement (version MVP)
    
    _isPremium = true;
    _currentPlan = _getPlanFromProductId(purchase.productID);
    _expirationDate = _calculateExpiration(purchase.productID);
    
    await _saveSubscriptionStatus();
    
    _isLoading = false;
    notifyListeners();
    
    debugPrint('✅ Abonnement activé: $_currentPlan jusqu\'au $_expirationDate');
  }

  String _getPlanFromProductId(String productId) {
    if (productId == monthlyId) return 'monthly';
    if (productId == yearlyId) return 'yearly';
    if (productId == studentId) return 'student';
    return 'unknown';
  }

  DateTime _calculateExpiration(String productId) {
    final now = DateTime.now();
    if (productId == monthlyId) return now.add(const Duration(days: 30));
    if (productId == yearlyId || productId == studentId) {
      return now.add(const Duration(days: 365));
    }
    return now.add(const Duration(days: 30));
  }

  /// Restaurer les achats précédents
  Future<void> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _iap.restorePurchases();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur restauration achats: $e');
      _error = 'Impossible de restaurer les achats';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Vérifier si l'utilisateur peut accéder à une fonctionnalité
  bool canAccess(String feature) {
    // Si premium, accès total
    if (_isPremium) return true;

    // Fonctionnalités gratuites (freemium)
    final freeFeatures = [
      'quiz',
      'search',
      'pomodoro',
      'maths_intuitives_preview', // 10 premiers concepts
      'lecons_preview', // 5 premières leçons
      'exercices_preview', // 10 premiers exercices
      'demonstrations_preview', // 5 premières
      'badges',
      'streak',
    ];

    return freeFeatures.contains(feature);
  }

  /// Vérifier combien de contenu gratuit reste accessible
  int getFreeAccessCount(String contentType) {
    if (_isPremium) return 999999; // Illimité

    switch (contentType) {
      case 'lecons':
        return 5;
      case 'exercices':
        return 10;
      case 'examens_blancs':
        return 1; // 1 sujet complet
      case 'maths_intuitives':
        return 10;
      case 'demonstrations':
        return 5;
      case 'annales':
        return 0; // Premium uniquement
      default:
        return 0;
    }
  }

  /// Activer premium manuellement (pour testing ou codes promo)
  Future<void> activatePremiumManually(String plan, {int days = 30}) async {
    _isPremium = true;
    _currentPlan = plan;
    _expirationDate = DateTime.now().add(Duration(days: days));
    await _saveSubscriptionStatus();
    notifyListeners();
    debugPrint('✅ Premium activé manuellement: $plan pour $days jours');
  }

  /// Désactiver premium (pour testing)
  Future<void> deactivatePremium() async {
    _isPremium = false;
    _currentPlan = null;
    _expirationDate = null;
    await _saveSubscriptionStatus();
    notifyListeners();
  }

  /// Nettoyer à la fermeture
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
