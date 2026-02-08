import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/quiz_model.dart';
import '../quiz_page.dart';
import '../search_page.dart';
import '../settings_page.dart';
import '../review_page.dart';
import '../flashcards_page.dart';
import '../spaced_repetition_page.dart';
import '../../services/score_service.dart';
import '../../services/favorites_service.dart';
import '../../services/streak_service.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/wellness_service.dart';
import '../../fiche_page.dart';

class AccueilTab extends StatefulWidget {
  const AccueilTab({super.key});

  @override
  State<AccueilTab> createState() => _AccueilTabState();
}

class _AccueilTabState extends State<AccueilTab> {
  final ScoreService _scoreService = ScoreService();
  final FavoritesService _favoritesService = FavoritesService();
  final StreakService _streakService = StreakService();
  final SpacedRepetitionService _srsService = SpacedRepetitionService();
  final WellnessService _wellnessService = WellnessService();
  int _totalFiches = 0;

  final List<String> _conseils = [
    'Maîtrisez parfaitement 2 développements par leçon',
    'Travaillez les leçons par thème et non par numéro',
    'Pratiquez régulièrement les simulations orales',
    'Révisez les contre-exemples classiques',
    'Anticipez les questions du jury',
    'Relisez les rapports du jury récents',
    'Alternez algèbre, analyse et géométrie',
  ];

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onChanged);
    _streakService.addListener(_onChanged);
    _srsService.addListener(_onChanged);
    _wellnessService.addListener(_onChanged);
    _favoritesService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onChanged);
    _streakService.removeListener(_onChanged);
    _srsService.removeListener(_onChanged);
    _wellnessService.removeListener(_onChanged);
    _favoritesService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final json = await rootBundle.loadString('assets/fiches/manifest.json');
      final data = jsonDecode(json) as Map<String, dynamic>;
      final list = data['themes'] as List<dynamic>?;
      int count = 0;
      if (list != null) {
        for (var t in list) {
          count += ((t as Map<String, dynamic>)['files'] as List<dynamic>).length;
        }
      }
      if (mounted) setState(() => _totalFiches = count);
    } catch (e) {
      debugPrint('Erreur chargement manifest: $e');
    }
  }

  Future<void> _startQuickQuiz() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      List<QuizQuestion> allQuestions = [];
      data.forEach((key, value) {
        if (value is List) {
          for (var q in value) allQuestions.add(QuizQuestion.fromJson(q));
        }
      });
      if (allQuestions.isEmpty) return;
      allQuestions.shuffle(Random());
      if (allQuestions.length > 10) allQuestions = allQuestions.sublist(0, 10);
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: "Quiz Rapide", questions: allQuestions),
        ));
      }
    } catch (e) {
      debugPrint('Erreur quiz: $e');
    }
  }

  void _showFavoritesSheet() async {
    final favorites = _favoritesService.favorites.toList();
    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun favori pour le moment')),
      );
      return;
    }
    final manifestJson = await rootBundle.loadString('assets/fiches/manifest.json');
    final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
    final themes = manifest['themes'] as List<dynamic>;
    final pathMap = <String, String>{};
    for (var theme in themes) {
      final themePath = theme['path'] as String;
      final files = (theme['files'] as List<dynamic>).cast<String>();
      for (var file in files) {
        pathMap[file.replaceAll('.md', '')] = '$themePath/$file';
      }
    }
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5, minChildSize: 0.3, maxChildSize: 0.9, expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text('Mes Favoris (${favorites.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: favorites.length,
                itemBuilder: (_, index) {
                  final ficheId = favorites[index];
                  final path = pathMap[ficheId];
                  return ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(ficheId),
                    onTap: path != null ? () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FichePage(assetPath: path)));
                    } : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final globalAvg = _scoreService.getGlobalAverage();
    final completedCount = _scoreService.scores.length;
    final streak = _streakService.currentStreak;
    final longestStreak = _streakService.longestStreak;
    final dueCards = _srsService.getDueCards().length;
    final reviewCount = _scoreService.getFichesToReview().length;
    final favCount = _favoritesService.favorites.length;
    final conseilIndex = DateTime.now().day % _conseils.length;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bonjour !", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                      Text("Agreg Master", style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A237E),
                      )),
                    ],
                  ),
                  Row(children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          // Wellness alert
          if (_wellnessService.activeAlerts.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: Row(children: [
                  const Icon(Icons.self_improvement, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Pensez à faire une pause !',
                    style: TextStyle(color: Colors.orange[800], fontSize: 13),
                  )),
                ]),
              ),
            ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Streak card
                _buildStreakCard(streak, longestStreak),
                const SizedBox(height: 16),

                // Quick stats row
                Row(children: [
                  Expanded(child: _buildStatCard(
                    icon: Icons.library_books, 
                    value: '$_totalFiches', 
                    label: 'Fiches', 
                    color: Colors.blue,
                    isDark: isDark,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.quiz, 
                    value: '$completedCount', 
                    label: 'Quiz faits', 
                    color: Colors.green,
                    isDark: isDark,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.trending_up, 
                    value: completedCount > 0 ? '${globalAvg.round()}%' : '--', 
                    label: 'Moyenne', 
                    color: Colors.purple,
                    isDark: isDark,
                  )),
                ]),

                const SizedBox(height: 20),

                // Daily objectives
                _buildObjectivesCard(isDark),

                const SizedBox(height: 16),

                // Actions rapides
                Text('Actions rapides', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                )),
                const SizedBox(height: 10),

                // Quick action cards
                Row(children: [
                  Expanded(child: _buildQuickAction(
                    icon: Icons.flash_on, label: 'Quiz\nrapide', color: Colors.orange,
                    onTap: _startQuickQuiz, isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.psychology, label: 'Réviser\n($reviewCount)', color: Colors.deepPurple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewPage())),
                    isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.star, label: 'Favoris\n($favCount)', color: Colors.amber,
                    onTap: _showFavoritesSheet, isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.style, label: 'Flash\ncards', color: Colors.teal,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
                    isDark: isDark,
                  )),
                ]),

                // SRS due notification
                if (dueCards > 0) ...[
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.deepOrange.withOpacity(isDark ? 0.2 : 0.05),
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionPage())),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.psychology, color: Colors.deepOrange, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$dueCards fiche${dueCards > 1 ? 's' : ''} à réviser',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('Répétition espacée - ne perdez pas votre avance !',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          )),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.deepOrange),
                        ]),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Conseil du jour
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.lightbulb, color: Colors.amber, size: 22),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Conseil du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(_conseils[conseilIndex], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    )),
                  ]),
                ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(int streak, int longestStreak) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak > 0
              ? [Colors.orange, Colors.deepOrange]
              : [Colors.grey.shade400, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Text(streak > 0 ? '🔥' : '💤', style: const TextStyle(fontSize: 36)),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              streak > 0 ? '$streak jour${streak > 1 ? 's' : ''} de suite !' : 'Commencez votre streak !',
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text('Record : $longestStreak jours', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        )),
        if (streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text('$streak', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
      ]),
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.08), blurRadius: 4)],
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ]),
    );
  }

  Widget _buildObjectivesCard(bool isDark) {
    final objectives = _streakService.todayObjectives;
    final completionRate = _streakService.getTodayCompletionRate();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.08), blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.flag, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          const Expanded(child: Text('Objectifs du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (completionRate >= 1 ? Colors.green : Colors.orange).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${(completionRate * 100).round()}%', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13,
              color: completionRate >= 1 ? Colors.green : Colors.orange,
            )),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.grey.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(completionRate >= 1 ? Colors.green : Colors.orange),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 12),
        ...objectives.values.map((obj) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(children: [
            Icon(obj.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: obj.isCompleted ? Colors.green : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(obj.title, style: const TextStyle(fontSize: 13))),
            Text('${obj.progress}/${obj.target}', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12,
              color: obj.isCompleted ? Colors.green : Colors.grey,
            )),
          ]),
        )),
      ]),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required Color color, required VoidCallback onTap, required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.08), blurRadius: 4)],
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.grey[700]),
            textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
