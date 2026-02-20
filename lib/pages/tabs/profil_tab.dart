import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../utils/theme_utils.dart';
import '../../widgets/shared_widgets.dart';
import '../stats_page.dart';
import '../lecon_progress_page.dart';
import '../badges_page.dart';
import '../competition_page.dart';
import '../wellness_page.dart';
import '../backup_page.dart';
import '../settings_page.dart';
import '../../services/score_service.dart';
import '../../services/badge_service.dart';
import '../../services/streak_service.dart';
import '../../services/lecon_progress_service.dart';
import '../../services/auth_service.dart';

class ProfilTab extends StatefulWidget {
  const ProfilTab({super.key});

  @override
  State<ProfilTab> createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  final ScoreService _scoreService = ScoreService();
  final BadgeService _badgeService = BadgeService();
  final StreakService _streakService = StreakService();
  final LeconProgressService _progressService = LeconProgressService();
  final AuthService _authService = AuthService();
  bool _authLoading = false;

  @override
  void initState() {
    super.initState();
    _scoreService.addListener(_onChanged);
    _badgeService.addListener(_onChanged);
    _streakService.addListener(_onChanged);
    _progressService.addListener(_onChanged);
    _authService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onChanged);
    _badgeService.removeListener(_onChanged);
    _streakService.removeListener(_onChanged);
    _progressService.removeListener(_onChanged);
    _authService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  bool get _showAppleSignIn => true;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _authLoading = true);
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _authLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _authLoading = true);
    try {
      await _authService.signInWithApple();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion Apple : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _authLoading = false);
    }
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous serez déconnecté de votre compte. '
          'Vos données locales seront conservées.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Déconnexion')),
        ],
      ),
    );
    if (confirm == true) {
      await _authService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final globalAvg = _scoreService.getGlobalAverage();
    final completedQuiz = _scoreService.scores.length;
    final badges = _badgeService.unlockedCount;
    final readyLecons = _progressService.getReadyLecons().length;
    final totalDays = _streakService.totalDaysActive;
    final niveau = AppStrings.getNiveau(globalAvg);
    final niveauColor = AppColors.getNiveauColor(globalAvg);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mon Profil', style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold,
              color: ThemeUtils.titleColor(context),
            )),

            const SizedBox(height: 20),

            _buildAuthCard(isDark),

            const SizedBox(height: 16),

            // Carte résumé profil
            Semantics(
              label: 'Niveau: $niveau. Moyenne: ${completedQuiz > 0 ? globalAvg.round() : 0}%. $completedQuiz quiz. $badges badges. $totalDays jours actifs.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primaryLight],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: niveauColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(niveau, style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildProfileStat('${completedQuiz > 0 ? globalAvg.round() : 0}%', 'Moyenne'),
                    Container(height: 30, width: 1, color: Colors.white24),
                    _buildProfileStat('$completedQuiz', 'Quiz'),
                    Container(height: 30, width: 1, color: Colors.white24),
                    _buildProfileStat('$badges', 'Badges'),
                    Container(height: 30, width: 1, color: Colors.white24),
                    _buildProfileStat('$totalDays', 'Jours'),
                  ]),
                ]),
              ),
            ),

            const SizedBox(height: 24),

            // Section Progression
            Text('Progression', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            )),
            const SizedBox(height: 10),

            ToolCard(
              icon: Icons.bar_chart, title: 'Statistiques détaillées',
              subtitle: 'Scores, graphiques et analyse',
              color: Colors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsPage())),
            ),
            ToolCard(
              icon: Icons.trending_up, title: 'Progression Leçons',
              subtitle: '$readyLecons leçon${readyLecons > 1 ? 's' : ''} prête${readyLecons > 1 ? 's' : ''} pour l\'oral',
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeconProgressPage())),
            ),
            ToolCard(
              icon: Icons.emoji_events, title: 'Mes Badges',
              subtitle: '$badges badge${badges > 1 ? 's' : ''} débloqué${badges > 1 ? 's' : ''}',
              color: Colors.amber,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesPage())),
            ),
            ToolCard(
              icon: Icons.leaderboard, title: 'Compétition',
              subtitle: 'Classement et défis',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionPage())),
            ),

            const SizedBox(height: 24),

            // Section Paramètres
            Text('Paramètres', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            )),
            const SizedBox(height: 10),

            ToolCard(
              icon: Icons.self_improvement, title: 'Bien-être',
              subtitle: 'Équilibre travail-repos',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessPage())),
            ),
            ToolCard(
              icon: Icons.cloud_upload, title: 'Sauvegarde & Cloud',
              subtitle: 'Ne perdez jamais votre progression',
              color: Colors.cyan,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupPage())),
            ),
            ToolCard(
              icon: Icons.settings, title: 'Paramètres',
              subtitle: 'Thème, notifications, compte',
              color: Colors.grey,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            ),
            if (_authService.isSignedIn)
              ToolCard(
                icon: Icons.logout, title: 'Se déconnecter',
                subtitle: _authService.email ?? '',
                color: Colors.red,
                onTap: _handleSignOut,
              ),

            const SizedBox(height: 24),
            Text('Disponible partout', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            )),
            const SizedBox(height: 10),
            if (kIsWeb) ...[
              ToolCard(
                icon: Icons.apple, title: 'App Store',
                subtitle: 'iPhone et iPad',
                color: Colors.black,
                onTap: () => launchUrl(
                  Uri.parse('https://apps.apple.com/app/agreg-master/id6740000879'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              ToolCard(
                icon: Icons.shop, title: 'Google Play',
                subtitle: 'Android',
                color: Colors.green.shade700,
                onTap: () => launchUrl(
                  Uri.parse('https://play.google.com/store/apps/details?id=com.agregmaster.app'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
            if (!kIsWeb) ToolCard(
              icon: Icons.language, title: 'Version Web',
              subtitle: 'agregmaster.fr — accessible depuis tout navigateur',
              color: Colors.indigo,
              onTap: () => launchUrl(
                Uri.parse('https://agregmaster.fr'),
                mode: LaunchMode.externalApplication,
              ),
            ),

            const SizedBox(height: 24),

            // Version
            Center(
              child: Text('${AppStrings.appName} ${AppStrings.appVersion}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(children: [
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }

  Widget _buildAuthCard(bool isDark) {
    if (_authService.isSignedIn) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? null : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: _authService.photoUrl != null
                ? NetworkImage(_authService.photoUrl!)
                : null,
            child: _authService.photoUrl == null
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _authService.displayName ?? 'Utilisateur',
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              if (_authService.email != null)
                Text(
                  _authService.email!,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
            ],
          )),
          Icon(Icons.verified, color: Colors.green[400], size: 22),
        ]),
      );
    }

    // Anonymous → show sign-in prompt
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: [
        Icon(Icons.account_circle_outlined,
            size: 48, color: isDark ? Colors.white54 : Colors.grey[400]),
        const SizedBox(height: 12),
        Text('Connectez-vous', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18,
          color: isDark ? Colors.white : Colors.black87,
        )),
        const SizedBox(height: 6),
        Text(
          'Synchronisez vos données sur tous vos appareils et protégez votre abonnement premium.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        const SizedBox(height: 18),
        if (_authLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          )
        else ...[
          _buildSignInButton(
            label: 'Continuer avec Google',
            icon: Icons.g_mobiledata,
            color: Colors.white,
            textColor: Colors.black87,
            borderColor: Colors.grey[300],
            onTap: _handleGoogleSignIn,
          ),
          if (_showAppleSignIn) ...[
            const SizedBox(height: 10),
            _buildSignInButton(
              label: 'Continuer avec Apple',
              icon: Icons.apple,
              color: isDark ? Colors.white : Colors.black,
              textColor: isDark ? Colors.black : Colors.white,
              onTap: _handleAppleSignIn,
            ),
          ],
        ],
      ]),
    );
  }

  Widget _buildSignInButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor, size: 24),
        label: Text(label, style: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 15,
        )),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
