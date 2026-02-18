import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion des abonnements premium via RevenueCat.
/// Gère les abonnements sur iOS (App Store), Android (Google Play) et Web (Stripe).
class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // État de l'abonnement
  bool _isPremium = false;
  String? _currentPlan;
  DateTime? _expirationDate;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // RevenueCat Entitlement ID (configuré dans le Dashboard RevenueCat)
  static const String entitlementId = 'Agreg Master Pro';

  // Product IDs (doivent correspondre aux configurations RevenueCat + stores)
  static const String monthlyId = 'agreg_master_premium_monthly';
  static const String yearlyId = 'agreg_master_premium_yearly';

  // RevenueCat API Keys — à remplacer par les vraies clés du Dashboard RevenueCat
  // Ces clés sont publiques (côté client), elles ne sont pas secrètes.
  static const String _rcAppleApiKey = 'appl_KGZJHYCjiiPMQbarNCnJbyakVGP';
  static const String _rcGoogleApiKey = 'goog_YNbXFosilLoiNCiTyQvgEGRgXUw';
  static const String _rcWebApiKey = 'strp_TbOCGUgTVDBKMFCXtVXXmuUQnkc';

  // Getters
  bool get isPremium => _isPremium;
  String? get currentPlan => _currentPlan;
  DateTime? get expirationDate => _expirationDate;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  /// Initialiser RevenueCat sur toutes les plateformes.
  /// [appUserID] : Firebase UID pour synchroniser les abonnements cross-plateforme.
  Future<void> initialize({String? appUserID}) async {
    if (_isInitialized) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Choisir la bonne API key selon la plateforme
      late String apiKey;
      if (kIsWeb) {
        apiKey = _rcWebApiKey;
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                 defaultTargetPlatform == TargetPlatform.macOS) {
        apiKey = _rcAppleApiKey;
      } else {
        apiKey = _rcGoogleApiKey;
      }

      // Configurer RevenueCat
      final configuration = PurchasesConfiguration(apiKey);
      if (appUserID != null) {
        configuration.appUserID = appUserID;
      }

      await Purchases.configure(configuration);

      // Activer le mode debug en développement
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      // Vérifier le statut initial
      await _refreshSubscriptionStatus();

      // Écouter les changements de statut (achat, restauration, expiration)
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);

      _isInitialized = true;
      debugPrint('RevenueCat initialisé (premium=$_isPremium, plan=$_currentPlan)');
    } catch (e) {
      debugPrint('Erreur initialisation RevenueCat: $e');
      _error = e.toString();

      // Fallback : charger le statut depuis le stockage local
      await _loadLocalStatus();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Callback RevenueCat : appelé quand le statut change
  void _onCustomerInfoUpdated(CustomerInfo customerInfo) {
    _updateFromCustomerInfo(customerInfo);
    _saveLocalStatus();
    notifyListeners();
  }

  /// Met à jour l'état interne depuis les infos RevenueCat
  void _updateFromCustomerInfo(CustomerInfo info) {
    final entitlement = info.entitlements.all[entitlementId];

    if (entitlement != null && entitlement.isActive) {
      _isPremium = true;
      _currentPlan = _getPlanFromProductId(entitlement.productIdentifier);

      if (entitlement.expirationDate != null) {
        _expirationDate = DateTime.tryParse(entitlement.expirationDate!);
      }
    } else {
      _isPremium = false;
      _currentPlan = null;
      _expirationDate = null;
    }

    _error = null;
  }

  /// Rafraîchir le statut depuis RevenueCat
  Future<void> _refreshSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateFromCustomerInfo(customerInfo);
      await _saveLocalStatus();
    } catch (e) {
      debugPrint('Erreur refresh statut: $e');
    }
  }

  /// Récupérer les offres disponibles (prix, packages)
  Future<Offerings?> getOfferings() async {
    if (!_isInitialized || !await _ensureConfigured()) {
      _error = 'Service d\'abonnement non disponible';
      notifyListeners();
      return null;
    }

    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      debugPrint('Erreur chargement offres: $e');
      _error = 'Impossible de charger les offres';
      notifyListeners();
      return null;
    }
  }

  /// Vérifie que le SDK RevenueCat est configuré, tente une réinit sinon
  Future<bool> _ensureConfigured() async {
    try {
      if (await Purchases.isConfigured) return true;
    } catch (_) {}

    debugPrint('RevenueCat non configuré — tentative de réinitialisation');
    _isInitialized = false;
    try {
      await initialize();
      return _isInitialized;
    } catch (e) {
      debugPrint('Réinitialisation échouée: $e');
      return false;
    }
  }

  /// Acheter un package RevenueCat (fonctionne sur toutes les plateformes).
  /// Sur mobile : ouvre le flow natif (App Store / Google Play).
  /// Sur web : ouvre le flow Stripe via RevenueCat.
  Future<bool> purchasePackage(Package package) async {
    if (!_isInitialized) {
      _error = 'Service d\'abonnement non disponible';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _updateFromCustomerInfo(purchaseResult.customerInfo);
      await _saveLocalStatus();

      _isLoading = false;
      notifyListeners();
      return _isPremium;
    } on PlatformException catch (e) {
      if (e.code == '1' /* userCancelledError */) {
        debugPrint('Achat annulé par l\'utilisateur');
        _error = null;
      } else {
        debugPrint('Erreur achat: ${e.code} ${e.message}');
        _error = 'Erreur lors de l\'achat';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Erreur achat: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Restaurer les achats précédents
  Future<void> restorePurchases() async {
    if (!_isInitialized) {
      _error = 'Service d\'abonnement non disponible';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final customerInfo = await Purchases.restorePurchases();
      _updateFromCustomerInfo(customerInfo);
      await _saveLocalStatus();
    } catch (e) {
      debugPrint('Erreur restauration: $e');
      _error = 'Impossible de restaurer les achats';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ============================================================================
  // API de compatibilité (utilisée par les pages existantes)
  // ============================================================================

  /// Vérifier si l'utilisateur peut accéder à une fonctionnalité
  bool canAccess(String feature) {
    if (_isPremium) return true;

    final freeFeatures = [
      'quiz',
      'search',
      'pomodoro',
      'maths_intuitives_preview',
      'lecons_preview',
      'exercices_preview',
      'demonstrations_preview',
      'badges',
      'streak',
    ];

    return freeFeatures.contains(feature);
  }

  /// Nombre de contenu gratuit accessible par type
  int getFreeAccessCount(String contentType) {
    if (_isPremium) return 999999; // Illimité

    switch (contentType) {
      case 'lecons':
        return 5;
      case 'exercices':
        return 10;
      case 'examens_blancs':
        return 1;
      case 'maths_intuitives':
        return 10;
      case 'demonstrations':
        return 5;
      case 'annales':
        return 4; // Première année gratuite (ext MG + AP + int EP1 + EP2)
      case 'annales_ped':
        return 1; // Premier sujet pédagogique gratuit
      default:
        return 0;
    }
  }

  // ============================================================================
  // Debug / Test (protégé en production)
  // ============================================================================

  /// Activer premium manuellement (testing uniquement)
  Future<void> activatePremiumManually(String plan, {int days = 30}) async {
    if (!kDebugMode) {
      debugPrint('activatePremiumManually bloqué en mode production');
      return;
    }
    _isPremium = true;
    _currentPlan = plan;
    _expirationDate = DateTime.now().add(Duration(days: days));
    await _saveLocalStatus();
    notifyListeners();
    debugPrint('Premium activé manuellement: $plan pour $days jours');
  }

  /// Désactiver premium (testing uniquement)
  Future<void> deactivatePremium() async {
    if (!kDebugMode) {
      debugPrint('deactivatePremium bloqué en mode production');
      return;
    }
    _isPremium = false;
    _currentPlan = null;
    _expirationDate = null;
    await _saveLocalStatus();
    notifyListeners();
  }

  // ============================================================================
  // Persistance locale (fallback si RevenueCat indisponible)
  // ============================================================================

  Future<void> _saveLocalStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremium', _isPremium);
      await prefs.setString('currentPlan', _currentPlan ?? '');
      if (_expirationDate != null) {
        await prefs.setInt('expirationDate', _expirationDate!.millisecondsSinceEpoch);
      } else {
        await prefs.remove('expirationDate');
      }
    } catch (e) {
      debugPrint('Erreur sauvegarde statut local: $e');
    }
  }

  Future<void> _loadLocalStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool('isPremium') ?? false;
      _currentPlan = prefs.getString('currentPlan');
      if (_currentPlan?.isEmpty ?? true) _currentPlan = null;

      final expirationTimestamp = prefs.getInt('expirationDate');
      if (expirationTimestamp != null) {
        _expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp);
        // Vérifier si expiré
        if (_expirationDate!.isBefore(DateTime.now())) {
          _isPremium = false;
          _currentPlan = null;
          _expirationDate = null;
        }
      }
    } catch (e) {
      debugPrint('Erreur chargement statut local: $e');
    }
  }

  // ============================================================================
  // Helpers
  // ============================================================================

  String _getPlanFromProductId(String productId) {
    if (productId.contains('monthly')) return 'monthly';
    if (productId.contains('yearly')) return 'yearly';
    return 'unknown';
  }

  @override
  void dispose() {
    // RevenueCat gère son propre cycle de vie
    super.dispose();
  }
}
