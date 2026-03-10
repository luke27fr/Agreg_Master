import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import 'paywall_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  int _currentPage = 0;
  bool _authLoading = false;

  static const _totalPages = 4;

  bool get _showAppleSignIn =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _totalPages - 1 && _currentPage != 2)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text('Passer',
                      style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                ),
              )
            else
              const SizedBox(height: 48),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcome(isDark, primary),
                  _buildContent(isDark, primary),
                  _buildPremium(isDark, primary),
                  _buildSignIn(isDark, primary),
                ],
              ),
            ),

            // Dots + action button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_totalPages, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? primary : (isDark ? Colors.grey[700] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Action button — hidden on premium page (has its own CTA)
                  if (_currentPage != 2)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _currentPage == _totalPages - 1 ? _finish : _goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _totalPages - 1 ? 'Commencer' : 'Suivant',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _totalPages - 1 ? Icons.check : Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 1: Welcome ──
  Widget _buildWelcome(bool isDark, Color primary) {
    return _buildStep(
      isDark: isDark,
      primary: primary,
      icon: Icons.school,
      title: 'Bienvenue sur\nAgreg Master',
      description:
          'Votre compagnon pour préparer l\'agrégation de mathématiques. Cours, exercices, annales et outils avancés.',
    );
  }

  // ── Step 2: Content ──
  Widget _buildContent(bool isDark, Color primary) {
    return _buildStep(
      isDark: isDark,
      primary: primary,
      icon: Icons.menu_book,
      title: 'Tout pour réussir\nl\'agrégation',
      description:
          'Leçons complètes, développements, démonstrations, annales corrigées, flashcards et examens blancs.',
    );
  }

  // ── Step 3: Premium (soft paywall) ──
  Widget _buildPremium(bool isDark, Color primary) {
    const amber = Color(0xFFF59E0B);
    const green = Color(0xFF22C55E);

    final features = [
      (Icons.menu_book, 'Tous les cours et leçons'),
      (Icons.edit_note, 'Exercices et développements'),
      (Icons.quiz, 'QCM et flashcards illimités'),
      (Icons.assignment, 'Annales complètes'),
      (Icons.auto_graph, 'Examens blancs et simulations'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: amber.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.diamond, size: 48, color: amber),
          ),
          const SizedBox(height: 24),
          Text(
            'Débloquez tout\navec Premium',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.primaryDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Accédez à l\'intégralité du contenu sans aucune limite.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(f.$1, size: 20, color: amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f.$2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.card_giftcard, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  '7 jours d\'essai gratuit',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaywallPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: amber,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Essai gratuit',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _goNext,
            child: Text(
              'Continuer sans Premium',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 4: Sign-in & Go ──
  Widget _buildSignIn(bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.rocket_launch, size: 48, color: primary),
          ),
          const SizedBox(height: 24),
          Text(
            'C\'est parti !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Connectez-vous pour synchroniser votre progression sur tous vos appareils.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 28),
          if (_authLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            )
          else ...[
            // Google sign-in
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  setState(() => _authLoading = true);
                  try {
                    await _authService.signInWithGoogle();
                  } catch (_) {}
                  if (mounted) setState(() => _authLoading = false);
                },
                icon: const Icon(Icons.g_mobiledata, size: 24),
                label: const Text('Continuer avec Google',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                ),
              ),
            ),
            // Apple sign-in
            if (_showAppleSignIn) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => _authLoading = true);
                    try {
                      await _authService.signInWithApple();
                    } catch (_) {}
                    if (mounted) setState(() => _authLoading = false);
                  },
                  icon: const Icon(Icons.apple, size: 24),
                  label: const Text('Continuer avec Apple',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: _finish,
              child: Text(
                'Continuer sans connexion',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Generic step builder ──
  Widget _buildStep({
    required bool isDark,
    required Color primary,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: primary),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.primaryDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
