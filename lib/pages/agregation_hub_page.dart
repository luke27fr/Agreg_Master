import 'package:flutter/material.dart';
import 'lecons_page.dart';
import 'developpements_page.dart';
import 'contre_exemples_page.dart';
import 'demonstrations_page.dart';
import 'exercices_page.dart';
import 'planificateur_page.dart';
import 'simulation_page.dart';
import 'oral_simulation_page.dart';
import 'bibliographie_page.dart';
import 'questions_jury_page.dart';
import 'badges_page.dart';
import 'pomodoro_page.dart';
import 'spaced_repetition_page.dart';
import 'lecon_progress_page.dart';
import 'examen_blanc_page.dart';
import 'mind_map_page.dart';
import '../services/streak_service.dart';
import '../services/badge_service.dart';
import '../services/spaced_repetition_service.dart';
import '../services/lecon_progress_service.dart';
import '../services/examen_blanc_service.dart';

class AgregationHubPage extends StatefulWidget {
  const AgregationHubPage({super.key});

  @override
  State<AgregationHubPage> createState() => _AgregationHubPageState();
}

class _AgregationHubPageState extends State<AgregationHubPage> {
  final StreakService _streakService = StreakService();
  final BadgeService _badgeService = BadgeService();
  final SpacedRepetitionService _srsService = SpacedRepetitionService();
  final LeconProgressService _progressService = LeconProgressService();

  @override
  void initState() {
    super.initState();
    _streakService.addListener(_onDataChanged);
    _badgeService.addListener(_onDataChanged);
    _srsService.addListener(_onDataChanged);
    _progressService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _streakService.removeListener(_onDataChanged);
    _badgeService.removeListener(_onDataChanged);
    _srsService.removeListener(_onDataChanged);
    _progressService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Préparation Agrégation', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Badge count
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.emoji_events),
                if (_badgeService.unlockedCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '${_badgeService.unlockedCount}',
                        style: const TextStyle(fontSize: 8, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BadgesPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak card
            _buildStreakCard(isDark),

            const SizedBox(height: 16),

            // Bannière
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.school, size: 48, color: Colors.white),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agrégation de Mathématiques',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tous les outils pour réussir',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Oral
            const Text(
              'Préparation Oral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Progression des leçons (mise en avant)
            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.trending_up,
              title: 'Ma Progression',
              subtitle: '${_progressService.getReadyLecons().length} leçon${_progressService.getReadyLecons().length > 1 ? 's' : ''} prête${_progressService.getReadyLecons().length > 1 ? 's' : ''} • Tracker détaillé',
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeconProgressPage()),
              ),
            ),

            const SizedBox(height: 12),

            // Répétition Espacée (nouveau - mise en avant)
            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.psychology,
              title: 'Répétition Espacée (SRS)',
              subtitle: '${_srsService.getDueCards().length} fiche${_srsService.getDueCards().length > 1 ? 's' : ''} à réviser • Mémorisation optimale',
              color: Colors.deepOrange,
              badge: _srsService.getDueCards().isNotEmpty ? '${_srsService.getDueCards().length}' : null,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpacedRepetitionPage()),
              ),
            ),

            const SizedBox(height: 12),

            // Simulation Oral (mise en avant)
            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.record_voice_over,
              title: 'Simulation Oral',
              subtitle: 'Tirage de 2 leçons + préparation + présentation',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OralSimulationPage()),
              ),
            ),

            const SizedBox(height: 12),

            // Carte mentale (mise en avant)
            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.account_tree,
              title: 'Carte Mentale Interactive',
              subtitle: 'Visualisez les liens entre concepts et parcours suggérés',
              color: Colors.indigo,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MindMapPage()),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.menu_book,
                    title: 'Leçons',
                    subtitle: '70+ leçons',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeconsPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.science,
                    title: 'Développements',
                    subtitle: 'Plans détaillés',
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DeveloppementsPage()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.help_outline,
                    title: 'Questions jury',
                    subtitle: 'Se préparer',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuestionsJuryPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.library_books,
                    title: 'Bibliographie',
                    subtitle: 'Livres conseillés',
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BibliographiePage()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.warning_amber,
                    title: 'Contre-exemples',
                    subtitle: 'Erreurs classiques',
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContreExemplesPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.functions,
                    title: 'Démonstrations',
                    subtitle: 'Théorèmes clés',
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DemonstrationsPage()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.fitness_center,
              title: 'Exercices classiques',
              subtitle: 'Entraînez-vous sur les incontournables',
              color: Colors.indigo,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExercicesPage()),
              ),
            ),

            const SizedBox(height: 24),

            // Section Écrit
            const Text(
              'Préparation Écrit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.assignment_turned_in,
              title: 'Examens Blancs',
              subtitle: 'Sujets type concours avec correction automatique',
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamenBlancPage()),
              ),
            ),

            const SizedBox(height: 12),

            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.timer,
              title: 'Simulation Écrit',
              subtitle: 'Entraînez-vous en conditions réelles (5h)',
              color: const Color(0xFF1A237E),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SimulationPage()),
              ),
            ),

            const SizedBox(height: 24),

            // Section Organisation
            const Text(
              'Organisation & Productivité',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.calendar_month,
                    title: 'Planificateur',
                    subtitle: 'Organiser',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlanificateurPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.timer_outlined,
                    title: 'Pomodoro',
                    subtitle: 'Focus mode',
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PomodoroPage()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildWideFeatureCard(
              context,
              isDark,
              icon: Icons.emoji_events,
              title: 'Mes badges',
              subtitle: '${_badgeService.unlockedCount}/${_badgeService.totalCount} badges débloqués',
              color: Colors.amber,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BadgesPage()),
              ),
            ),

            const SizedBox(height: 24),

            // Objectifs du jour
            _buildDailyObjectivesCard(isDark),

            const SizedBox(height: 24),

            // Conseils
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Conseils de préparation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildConseil('Maîtrisez parfaitement 2 développements par leçon'),
                  _buildConseil('Travaillez les leçons par thème et non par numéro'),
                  _buildConseil('Pratiquez régulièrement les simulations'),
                  _buildConseil('Révisez les contre-exemples classiques'),
                  _buildConseil('Anticipez les questions du jury'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(bool isDark) {
    final streak = _streakService.currentStreak;
    final longestStreak = _streakService.longestStreak;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak > 0
              ? [Colors.orange, Colors.deepOrange]
              : [Colors.grey[400]!, Colors.grey[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            streak > 0 ? '🔥' : '💤',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak > 0 ? '$streak jour${streak > 1 ? 's' : ''} de suite !' : 'Pas de streak actif',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Record : $longestStreak jours',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDailyObjectivesCard(bool isDark) {
    final objectives = _streakService.todayObjectives;
    final completionRate = _streakService.getTodayCompletionRate();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: Colors.green),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Objectifs du jour',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${(completionRate * 100).round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: completionRate >= 1 ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completionRate,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(
                completionRate >= 1 ? Colors.green : Colors.orange,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          ...objectives.values.map((obj) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  obj.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: obj.isCompleted ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(obj.title)),
                Text(
                  '${obj.progress}/${obj.target}${obj.unit.isNotEmpty ? ' ${obj.unit}' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: obj.isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideFeatureCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConseil(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
