import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/subscription_service.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';

/// Page PayWall Premium avec offres d'abonnement.
/// Utilise RevenueCat pour afficher les prix réels depuis les stores
/// et gérer l'achat.
class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<Package> _packages = [];
  Package? _selectedPackage;
  bool _isLoading = true;
  bool _isPurchasing = false;
  final AnalyticsService _analyticsService = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _loadOfferings();
    _analyticsService.logPaywallView();
  }

  Future<void> _loadOfferings() async {
    setState(() => _isLoading = true);
    try {
      if (!_subscriptionService.isInitialized) {
        try {
          await _subscriptionService.initialize().timeout(
            const Duration(seconds: 20),
          );
        } catch (_) {}
      }
      final offerings = await _subscriptionService.getOfferings();
      if (offerings != null && offerings.current != null) {
        final packages = offerings.current!.availablePackages;
        if (mounted) {
          setState(() {
            _packages = packages;
            if (packages.isNotEmpty) {
              _selectedPackage = packages.firstWhere(
                (p) => p.packageType == PackageType.annual,
                orElse: () => packages.first,
              );
            }
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _packages = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Erreur chargement offres paywall: $e');
      if (mounted) {
        setState(() {
          _packages = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                children: [
                  // Bouton fermer
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Titre
                          const Text(
                            'Agreg Master Premium',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Déverrouillez tout le contenu\npour réussir votre agrégation',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white.withAlpha((0.85 * 255).round()),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 36),

                          // Avantages Premium
                          _buildFeaturesList(),

                          const SizedBox(height: 32),

                          // Plans d'abonnement
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          else if (_packages.isEmpty)
                            _buildNoOfferings()
                          else
                            _buildSubscriptionPlans(),

                          const SizedBox(height: 24),

                          // Bouton restaurer achats (masqué sur web)
                          if (!kIsWeb)
                            TextButton(
                              onPressed: _restorePurchases,
                              child: Text(
                                'Restaurer mes achats',
                                style: TextStyle(
                                  color: Colors.white.withAlpha((0.7 * 255).round()),
                                  fontSize: 15,
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          // Texte légal
                          Text(
                            _getLegalText(),
                            style: TextStyle(
                              color: Colors.white.withAlpha((0.6 * 255).round()),
                              fontSize: 12,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Liens légaux
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => _openLegalPage('https://agregmaster.fr/privacy.html'),
                                child: Text(
                                  'Politique de confidentialité',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha((0.7 * 255).round()),
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withAlpha((0.7 * 255).round()),
                                  ),
                                ),
                              ),
                              Text(' • ', style: TextStyle(color: Colors.white.withAlpha((0.4 * 255).round()))),
                              TextButton(
                                onPressed: () => _openLegalPage('https://agregmaster.fr/terms.html'),
                                child: Text(
                                  'Conditions d\'utilisation (EULA)',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha((0.7 * 255).round()),
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withAlpha((0.7 * 255).round()),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.school,
        'title': 'Toutes les leçons',
        'subtitle': 'Accès illimité aux 150+ leçons',
      },
      {
        'icon': Icons.quiz,
        'title': 'Exercices & Examens',
        'subtitle': '500+ exercices corrigés + examens blancs',
      },
      {
        'icon': Icons.assessment,
        'title': 'Annales officielles',
        'subtitle': 'Tous les sujets officiels avec corrections',
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Maths Intuitives',
        'subtitle': 'Comprenez tous les concepts difficiles',
      },
      {
        'icon': Icons.cloud_sync,
        'title': 'Sync Cloud',
        'subtitle': 'Synchronisez vos données entre appareils',
      },
      {
        'icon': Icons.devices,
        'title': 'Multiplateforme',
        'subtitle': 'iOS, Android et Web — un seul abonnement',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Stats avancées',
        'subtitle': 'Analyses détaillées de votre progression',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      feature['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoOfferings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.white.withAlpha((0.7 * 255).round()), size: 48),
          const SizedBox(height: 16),
          Text(
            'Offres non disponibles pour le moment.\nVeuillez réessayer plus tard.',
            style: TextStyle(
              color: Colors.white.withAlpha((0.8 * 255).round()),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _loadOfferings,
            child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      children: [
        // Afficher chaque package disponible
        ..._packages.map((package) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPlanCard(package: package),
        )),

        const SizedBox(height: 24),

        // Bouton principal
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isPurchasing || _selectedPackage == null
                ? null
                : _handlePurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            child: _isPurchasing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'S\'abonner maintenant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({required Package package}) {
    final isSelected = _selectedPackage?.identifier == package.identifier;
    final storeProduct = package.storeProduct;
    final title = _getPackageTitle(package);
    final subtitle = _getPackageSubtitle(package);
    final badge = _getPackageBadge(package);

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPackage = package);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withAlpha((0.3 * 255).round()),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.indigo.shade700
                      : Colors.white.withAlpha((0.4 * 255).round()),
                  width: 2,
                ),
                color: isSelected ? Colors.indigo.shade700 : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 16),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.indigo.shade700
                              : Colors.white,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.indigo.shade700.withAlpha((0.7 * 255).round())
                          : Colors.white.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),

            // Prix
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  storeProduct.priceString,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.indigo.shade700 : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Helpers pour les labels de packages
  // ============================================================================

  String _getPackageTitle(Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return 'Mensuel';
      case PackageType.annual:
        return 'Annuel';
      default:
        return package.storeProduct.title;
    }
  }

  String _getPackageSubtitle(Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return 'Engagement flexible';
      case PackageType.annual:
        return 'Meilleur rapport qualité/prix';
      default:
        return package.storeProduct.description;
    }
  }

  String? _getPackageBadge(Package package) {
    switch (package.packageType) {
      case PackageType.annual:
        return 'POPULAIRE';
      default:
        return null;
    }
  }

  /// Texte légal adapté selon la plateforme
  String _getLegalText() {
    if (kIsWeb) {
      return 'Paiement sécurisé via Stripe\n'
          'Annulation possible à tout moment depuis votre espace client\n'
          'L\'abonnement se renouvelle automatiquement sauf annulation.';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      return 'Paiement sécurisé via l\'App Store\n'
          'Annulation possible à tout moment dans les réglages de votre compte\n'
          'L\'abonnement se renouvelle automatiquement sauf annulation\n'
          'au moins 24h avant la fin de la période en cours.';
    }
    return 'Paiement sécurisé via votre store\n'
        'Annulation possible à tout moment\n'
        'L\'abonnement se renouvelle automatiquement sauf annulation\n'
        'au moins 24h avant la fin de la période en cours.';
  }

  // ============================================================================
  // Actions
  // ============================================================================

  bool get _showAppleSignIn => kIsWeb || (!kIsWeb && Platform.isIOS);

  /// Show a bottom sheet prompting anonymous users to sign in before purchase.
  /// Returns true if the user signed in or explicitly chose to skip.
  Future<bool> _promptSignInIfNeeded() async {
    final authService = AuthService();
    if (!authService.isAnonymous) return true;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool loading = false;
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.shield_outlined, size: 48, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text(
                'Protégez votre achat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Connectez-vous pour accéder à votre abonnement sur tous vos appareils et ne jamais le perdre.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                )
              else ...[
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setSheetState(() => loading = true);
                      try {
                        await authService.signInWithGoogle();
                        if (ctx.mounted) Navigator.pop(ctx, true);
                      } catch (e) {
                        setSheetState(() => loading = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('Erreur : $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Continuer avec Google',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ),
                if (_showAppleSignIn) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setSheetState(() => loading = true);
                        try {
                          await authService.signInWithApple();
                          if (ctx.mounted) Navigator.pop(ctx, true);
                        } catch (e) {
                          setSheetState(() => loading = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('Erreur : $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.apple, size: 24),
                      label: const Text('Continuer avec Apple',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Continuer sans compte',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ],
            ]),
          );
        });
      },
    );
    return result == true;
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackage == null) return;

    // On web, RevenueCat Web Billing handles email collection in checkout.
    // Only prompt sign-in on native platforms.
    if (!kIsWeb) {
      final proceed = await _promptSignInIfNeeded();
      if (!proceed || !mounted) return;
    }

    _analyticsService.logPurchaseStart(
      productId: _selectedPackage!.storeProduct.identifier,
      packageType: _selectedPackage!.packageType.name,
    );
    setState(() => _isPurchasing = true);

    try {
      final success = await _subscriptionService.purchasePackage(_selectedPackage!);

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          _analyticsService.logPurchaseComplete(
            productId: _selectedPackage!.storeProduct.identifier,
            packageType: _selectedPackage!.packageType.name,
          );
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Abonnement activé ! Bienvenue Premium !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (_subscriptionService.error != null) {
          _analyticsService.logPurchaseError(
            productId: _selectedPackage!.storeProduct.identifier,
            error: _subscriptionService.error ?? 'unknown',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : ${_subscriptionService.error}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
      if (mounted) {
        setState(() => _isPurchasing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _openLegalPage(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _restorePurchases() async {
    await _subscriptionService.restorePurchases();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _subscriptionService.isPremium
                ? 'Abonnement restauré !'
                : 'Aucun abonnement trouvé',
          ),
          backgroundColor: _subscriptionService.isPremium
              ? Colors.green
              : Colors.orange,
        ),
      );
      if (_subscriptionService.isPremium) {
        Navigator.of(context).pop(true);
      }
    }
  }
}
