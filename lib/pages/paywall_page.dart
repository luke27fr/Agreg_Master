import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/subscription_service.dart';

/// Page PayWall Premium avec offres d'abonnement
class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<ProductDetails> _products = [];
  String _selectedProductId = SubscriptionService.yearlyId; // Par défaut: annuel
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _subscriptionService
          .getAvailableProducts()
          .timeout(const Duration(seconds: 8), onTimeout: () => []);
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement produits paywall: $e');
      if (mounted) {
        setState(() {
          _products = [];
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
          child: Column(
            children: [
              // Bouton fermer
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Titre
                      const Text(
                        '🎓 Agreg Master Premium',
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
                          fontSize: 18,
                          color: Colors.white.withAlpha((0.85 * 255).round()),
                          height: 1.4,
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
                      else
                        _buildSubscriptionPlans(),

                      const SizedBox(height: 24),

                      // Bouton restaurer achats
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
                        'Paiement sécurisé via Google Play / App Store\nAnnulation possible à tout moment\nL\'abonnement se renouvelle automatiquement sauf annulation\nau moins 24h avant la fin de la période en cours.',
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.6 * 255).round()),
                          fontSize: 12,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Liens légaux (requis par les stores)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => _openLegalPage('https://luke27fr.github.io/agregmaster-legal/privacy.html'),
                            child: Text(
                              'Politique de confidentialité',
                              style: TextStyle(
                                color: Colors.white.withAlpha((0.6 * 255).round()),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withAlpha((0.6 * 255).round()),
                              ),
                            ),
                          ),
                          Text(' | ', style: TextStyle(color: Colors.white.withAlpha((0.4 * 255).round()))),
                          TextButton(
                            onPressed: () => _openLegalPage('https://luke27fr.github.io/agregmaster-legal/terms.html'),
                            child: Text(
                              'CGU',
                              style: TextStyle(
                                color: Colors.white.withAlpha((0.6 * 255).round()),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withAlpha((0.6 * 255).round()),
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

  ProductDetails _findProduct(String id, String fallbackPrice) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return _createMockProduct(id, fallbackPrice);
  }

  Widget _buildSubscriptionPlans() {
    // Récupérer les produits
    final monthly = _findProduct(SubscriptionService.monthlyId, '4,99 €');
    final yearly = _findProduct(SubscriptionService.yearlyId, '39,99 €');
    final student = _findProduct(SubscriptionService.studentId, '29,99 €');

    return Column(
      children: [
        // Plan Annuel (POPULAIRE)
        _buildPlanCard(
          product: yearly,
          title: 'Annuel',
          subtitle: 'Meilleur rapport qualité/prix',
          badge: '🔥 POPULAIRE',
          monthlyCost: '3,33 €/mois',
          isSelected: _selectedProductId == yearly.id,
        ),

        const SizedBox(height: 12),

        // Plan Mensuel
        _buildPlanCard(
          product: monthly,
          title: 'Mensuel',
          subtitle: 'Engagement flexible',
          monthlyCost: monthly.price,
          isSelected: _selectedProductId == monthly.id,
        ),

        const SizedBox(height: 12),

        // Plan Étudiant
        _buildPlanCard(
          product: student,
          title: 'Étudiant (1 an)',
          subtitle: 'Tarif réduit avec justificatif',
          badge: '🎓 PROMO',
          monthlyCost: '2,50 €/mois',
          isSelected: _selectedProductId == student.id,
        ),

        const SizedBox(height: 24),

        // Bouton principal
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _subscriptionService.isLoading ? null : _handlePurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            child: _subscriptionService.isLoading
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

  Widget _buildPlanCard({
    required ProductDetails product,
    required String title,
    required String subtitle,
    String? badge,
    required String monthlyCost,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedProductId = product.id);
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
            // Radio
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
                  product.price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.indigo.shade700 : Colors.white,
                  ),
                ),
                Text(
                  monthlyCost,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? Colors.indigo.shade700.withAlpha((0.6 * 255).round())
                        : Colors.white.withAlpha((0.6 * 255).round()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ProductDetails _createMockProduct(String id, String price) {
    // Produit mock pour prévisualisation (si stores pas configurés)
    return ProductDetails(
      id: id,
      title: id,
      description: '',
      price: price,
      rawPrice: 0,
      currencyCode: 'EUR',
    );
  }

  Future<void> _handlePurchase() async {
    final success = await _subscriptionService.purchaseSubscription(_selectedProductId);
    if (success && mounted) {
      Navigator.of(context).pop(true); // Retour avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Abonnement activé ! Bienvenue Premium !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (_subscriptionService.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${_subscriptionService.error}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
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
                ? '✅ Abonnement restauré !'
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
