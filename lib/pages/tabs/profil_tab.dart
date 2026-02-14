import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _scoreService.addListener(_onChanged);
    _badgeService.addListener(_onChanged);
    _streakService.addListener(_onChanged);
    _progressService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onChanged);
    _badgeService.removeListener(_onChanged);
    _streakService.removeListener(_onChanged);
    _progressService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
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
}
