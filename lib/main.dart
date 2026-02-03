import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Tes imports existants
import 'package:agreg_master/models/quiz_model.dart';
import 'package:agreg_master/pages/quiz_page.dart';
import 'package:agreg_master/services/score_service.dart';
import 'fiche_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScoreService().loadScores();
  runApp(const AgregMasterApp());
}

class AgregMasterApp extends StatelessWidget {
  const AgregMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agreg Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Bleu Nuit Profond
          primary: const Color(0xFF1A237E),
          surface: const Color(0xFFF5F7FA), // Gris très clair pour le fond
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1A237E),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A237E),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home: const ThemesScreen(),
    );
  }
}

// --- Modèle ThemeItem (Inchangé) ---
class ThemeItem {
  final String id;
  final String label;
  final String path;
  final List<String> files;

  ThemeItem({
    required this.id,
    required this.label,
    required this.path,
    required this.files,
  });

  factory ThemeItem.fromJson(Map<String, dynamic> json) {
    return ThemeItem(
      id: json['id'] as String,
      label: json['label'] as String,
      path: json['path'] as String,
      files: (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  List<ThemeItem> _themes = [];
  int _totalFiches = 0;
  bool _loading = true;
  final ScoreService _scoreService = ScoreService();

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final json = await rootBundle.loadString('assets/fiches/manifest.json');
      final data = jsonDecode(json) as Map<String, dynamic>;
      final list = (data['themes'] as List<dynamic>?)
          ?.map((e) => ThemeItem.fromJson(e as Map<String, dynamic>))
          .toList();
      
      int count = 0;
      if (list != null) {
        for (var t in list) {
          count += t.files.length;
        }
      }

      if (mounted) {
        setState(() {
          _themes = list ?? [];
          _totalFiches = count;
          _loading = false;
        });
      }
    } catch (e) {
      print("Erreur chargement: $e");
    }
  }

  // --- Helpers pour le Design ---
  Color _getThemeColor(String id) {
    if (id.contains('algebre')) return const Color(0xFF3F51B5); // Indigo
    if (id.contains('analyse')) return const Color(0xFFE91E63); // Rose
    if (id.contains('proba')) return const Color(0xFF009688);   // Teal
    if (id.contains('geo')) return const Color(0xFFFF9800);     // Orange
    return const Color(0xFF607D8B); // Gris bleu par défaut
  }

  IconData _getThemeIcon(String id) {
    if (id.contains('algebre')) return Icons.functions;
    if (id.contains('analyse')) return Icons.show_chart;
    if (id.contains('proba')) return Icons.casino;
    if (id.contains('geo')) return Icons.architecture;
    return Icons.book;
  }

  // --- Carte Stats avec Score Global ---
  Widget _buildStatsCard() {
    final globalAvg = _scoreService.getGlobalAverage();
    final completedCount = _scoreService.scores.length;
    
    String message;
    if (completedCount == 0) {
      message = "Commence par un quiz !";
    } else if (globalAvg >= 80) {
      message = "Excellent niveau ! 🎉";
    } else if (globalAvg >= 60) {
      message = "Bon travail, continue ! 👍";
    } else {
      message = "Continue tes efforts ! 💪";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.library_books, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    "$_totalFiches Fiches • $completedCount testées",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          if (completedCount > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "${globalAvg.round()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Moyenne",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- Grand Quiz ---
  Future<void> _startGeneralQuiz(BuildContext context) async {
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
      if (allQuestions.length > 20) allQuestions = allQuestions.sublist(0, 20);

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(title: "Grand Quiz Général 🔥", questions: allQuestions),
          ),
        );
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. En-tête Salutation
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bonjour !",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const Text(
                        "Agreg Master",
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF1A237E)
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF1A237E),
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // 2. Carte Résumé (Stats)
              _buildStatsCard(),

              const SizedBox(height: 30),
              const Text(
                "Matières",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // 3. Grille des Matières RESPONSIVE
              Expanded(
                child: _loading 
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // --- LOGIQUE RESPONSIVE ---
                        int crossAxisCount;
                        if (constraints.maxWidth > 1100) {
                          crossAxisCount = 4; // PC Large
                        } else if (constraints.maxWidth > 700) {
                          crossAxisCount = 2; // Tablette / Petit PC
                        } else {
                          crossAxisCount = 1; // Mobile
                        }
                        
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount, // Nombre dynamique
                            childAspectRatio: 1.1, // Ajusté pour le score
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: _themes.length,
                          itemBuilder: (context, index) {
                            final theme = _themes[index];
                            final color = _getThemeColor(theme.id);
                            final icon = _getThemeIcon(theme.id);
                            final avgScore = _scoreService.getAverageForFiches(theme.files);
                            final completedCount = _scoreService.getCompletedCount(theme.files);

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => FichesListScreen(theme: theme)),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon, color: color, size: 36),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        theme.label,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${theme.files.length} fiches • $completedCount testées",
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      // Barre de progression du score
                                      if (avgScore >= 0) ...[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: avgScore / 100,
                                            backgroundColor: Colors.grey[200],
                                            color: avgScore >= 80 ? Colors.green : (avgScore >= 60 ? Colors.orange : Colors.red),
                                            minHeight: 6,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${avgScore.round()}% moyenne",
                                          style: TextStyle(
                                            color: avgScore >= 80 ? Colors.green : (avgScore >= 60 ? Colors.orange : Colors.red),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          "Pas encore testé",
                                          style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startGeneralQuiz(context),
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.flash_on, color: Colors.white),
        label: const Text("Grand Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- Page Liste des Fiches (FichesListScreen) ---
class FichesListScreen extends StatefulWidget {
  final ThemeItem theme;
  const FichesListScreen({super.key, required this.theme});

  @override
  State<FichesListScreen> createState() => _FichesListScreenState();
}

class _FichesListScreenState extends State<FichesListScreen> {
  final ScoreService _scoreService = ScoreService();

  @override
  void initState() {
    super.initState();
    _scoreService.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    if (mounted) setState(() {});
  }
  
  Future<void> _startSectionQuiz(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      List<QuizQuestion> sectionQuestions = [];
      for (var file in widget.theme.files) {
        String key = file.replaceAll('.md', '');
        if (data.containsKey(key)) {
          for (var q in data[key]) sectionQuestions.add(QuizQuestion.fromJson(q));
        }
      }
      if (sectionQuestions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pas de quiz pour ce chapitre !")));
        return;
      }
      sectionQuestions.shuffle();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(title: "Quiz ${widget.theme.label}", questions: sectionQuestions)),
      );
    } catch (e) {}
  }

  Future<void> _startFicheQuiz(BuildContext context, String ficheId) async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      if (!data.containsKey(ficheId)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pas de quiz pour cette fiche !")));
        return;
      }
      List<QuizQuestion> questions = [];
      for (var q in data[ficheId]) {
        questions.add(QuizQuestion.fromJson(q));
      }
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage(
            title: ficheId,
            questions: questions,
            ficheId: ficheId,
          )),
        );
      }
    } catch (e) {}
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildScoreBadge(String ficheId) {
    final score = _scoreService.getScore(ficheId);
    if (score == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "—",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    
    final color = _getScoreColor(score.percentage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        "${score.score}/${score.total}",
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _scoreService.getAverageForFiches(widget.theme.files);
    final completedCount = _scoreService.getCompletedCount(widget.theme.files);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A237E)),
        title: Text(widget.theme.label, style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Carte résumé du chapitre
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$completedCount/${widget.theme.files.length} fiches testées",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (avgScore >= 0) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: avgScore / 100,
                            backgroundColor: Colors.grey[200],
                            color: _getScoreColor(avgScore),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Moyenne: ${avgScore.round()}%",
                          style: TextStyle(
                            color: _getScoreColor(avgScore),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else
                        const Text(
                          "Commencez un quiz !",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _startSectionQuiz(context),
                  icon: const Icon(Icons.school, size: 18),
                  label: const Text("Quiz"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Liste des fiches
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.theme.files.length,
              itemBuilder: (context, index) {
                final file = widget.theme.files[index];
                final ficheId = file.replaceAll('.md', '');
                final score = _scoreService.getScore(ficheId);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: score != null 
                            ? _getScoreColor(score.percentage).withOpacity(0.1)
                            : const Color(0xFF1A237E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        score != null 
                            ? (score.percentage >= 80 ? Icons.check_circle : Icons.article)
                            : Icons.article,
                        color: score != null 
                            ? _getScoreColor(score.percentage)
                            : const Color(0xFF1A237E),
                        size: 20,
                      ),
                    ),
                    title: Text(ficheId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: score != null
                        ? Text(
                            "Score: ${score.percentage.round()}% • ${_formatDate(score.date)}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildScoreBadge(ficheId),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.quiz, color: Color(0xFF1A237E), size: 20),
                          onPressed: () => _startFicheQuiz(context, ficheId),
                          tooltip: "Quiz de cette fiche",
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FichePage(assetPath: '${widget.theme.path}/$file')));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays} jours";
    return "${date.day}/${date.month}/${date.year}";
  }
}