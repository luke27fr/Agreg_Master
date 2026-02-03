import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports
import 'package:agreg_master/models/quiz_model.dart';
import 'package:agreg_master/pages/quiz_page.dart';
import 'package:agreg_master/pages/search_page.dart';
import 'package:agreg_master/pages/stats_page.dart';
import 'package:agreg_master/pages/review_page.dart';
import 'package:agreg_master/pages/flashcards_page.dart';
import 'package:agreg_master/pages/settings_page.dart';
import 'package:agreg_master/pages/agregation_hub_page.dart';
import 'package:agreg_master/services/score_service.dart';
import 'package:agreg_master/services/favorites_service.dart';
import 'package:agreg_master/services/notes_service.dart';
import 'package:agreg_master/services/settings_service.dart';
import 'package:agreg_master/services/reading_service.dart';
import 'package:agreg_master/services/streak_service.dart';
import 'package:agreg_master/services/badge_service.dart';
import 'package:agreg_master/services/spaced_repetition_service.dart';
import 'package:agreg_master/services/lecon_progress_service.dart';
import 'package:agreg_master/services/examen_blanc_service.dart';
import 'package:agreg_master/services/mind_map_service.dart';
import 'fiche_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Charger tous les services
  await Future.wait([
    ScoreService().loadScores(),
    FavoritesService().loadFavorites(),
    NotesService().loadNotes(),
    SettingsService().loadSettings(),
    ReadingService().loadReadingProgress(),
    StreakService().loadData(),
    BadgeService().loadData(),
    SpacedRepetitionService().loadData(),
    LeconProgressService().loadData(),
    ExamenBlancService().loadExamens(),
    ExamenBlancService().loadResults(),
    MindMapService().loadMindMap(),
  ]);
  runApp(const AgregMasterApp());
}

class AgregMasterApp extends StatefulWidget {
  const AgregMasterApp({super.key});

  @override
  State<AgregMasterApp> createState() => _AgregMasterAppState();
}

class _AgregMasterAppState extends State<AgregMasterApp> {
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agreg Master',
      debugShowCheckedModeBanner: false,
      themeMode: _settingsService.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
          surface: const Color(0xFFF5F7FA),
          brightness: Brightness.light,
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
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF3949AB),
          surface: const Color(0xFF121212),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: const Color(0xFF1E1E1E),
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
  final FavoritesService _favoritesService = FavoritesService();
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onScoreChanged);
    _favoritesService.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onScoreChanged);
    _favoritesService.removeListener(_onScoreChanged);
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

  // --- Bouton rapide ---
  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 28),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
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
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dialog Favoris ---
  void _showFavoritesDialog(BuildContext context) async {
    final favorites = _favoritesService.favorites.toList();
    
    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun favori pour le moment')),
      );
      return;
    }

    // Charger le manifest pour trouver les chemins des fiches
    final manifestJson = await rootBundle.loadString('assets/fiches/manifest.json');
    final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
    final themes = manifest['themes'] as List<dynamic>;

    // Construire une map ficheId -> assetPath
    final pathMap = <String, String>{};
    for (var theme in themes) {
      final themePath = theme['path'] as String;
      final files = (theme['files'] as List<dynamic>).cast<String>();
      for (var file in files) {
        final ficheId = file.replaceAll('.md', '');
        pathMap[ficheId] = '$themePath/$file';
      }
    }

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Mes Favoris (${favorites.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        _favoritesService.removeFavorite(ficheId);
                        Navigator.pop(ctx);
                        if (favorites.length > 1) {
                          _showFavoritesDialog(context);
                        }
                      },
                    ),
                    onTap: path != null
                        ? () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FichePage(assetPath: path),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favCount = _favoritesService.favorites.length;
    final reviewCount = _scoreService.getFichesToReview().length;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. En-tête avec actions
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
                      Text(
                        "Agreg Master",
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold, 
                          color: isDark ? Colors.white : const Color(0xFF1A237E)
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Bouton Recherche
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchPage()),
                        ),
                        tooltip: 'Rechercher',
                      ),
                      // Bouton Paramètres
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage()),
                        ),
                        tooltip: 'Paramètres',
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // 2. Carte Résumé (Stats)
              _buildStatsCard(),

              const SizedBox(height: 16),

              // Bouton accès rapide Préparation Agrégation
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AgregationHubPage()),
                  ),
                  icon: const Icon(Icons.school, size: 20),
                  label: const Text('Préparation Agrégation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // 3. Boutons rapides (Révision, Stats, Flashcards, Favoris)
              Row(
                children: [
                  Expanded(
                    child: _buildQuickButton(
                      icon: Icons.psychology,
                      label: 'Révision',
                      badge: reviewCount > 0 ? '$reviewCount' : null,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReviewPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickButton(
                      icon: Icons.bar_chart,
                      label: 'Stats',
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StatsPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickButton(
                      icon: Icons.style,
                      label: 'Flashcards',
                      color: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FlashcardsPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickButton(
                      icon: Icons.star,
                      label: 'Favoris',
                      badge: favCount > 0 ? '$favCount' : null,
                      color: Colors.amber,
                      onTap: () => _showFavoritesDialog(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                "Matières",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.white : Colors.black87
                ),
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
                                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.1), blurRadius: 5, offset: const Offset(0, 2))
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
  final FavoritesService _favoritesService = FavoritesService();
  final ReadingService _readingService = ReadingService();

  @override
  void initState() {
    super.initState();
    _scoreService.addListener(_onDataChanged);
    _favoritesService.addListener(_onDataChanged);
    _readingService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onDataChanged);
    _favoritesService.removeListener(_onDataChanged);
    _readingService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgScore = _scoreService.getAverageForFiches(widget.theme.files);
    final completedCount = _scoreService.getCompletedCount(widget.theme.files);
    final readCount = _readingService.getReadCount(widget.theme.files);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: isDark ? Colors.white : const Color(0xFF1A237E)),
        title: Text(widget.theme.label, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A237E), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Carte résumé du chapitre
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.1), blurRadius: 5)],
            ),
            child: Column(
              children: [
                // Progression lecture
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.blue[400], size: 20),
                    const SizedBox(width: 8),
                    Text("$readCount/${widget.theme.files.length} lues", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(width: 16),
                    Icon(Icons.quiz, color: Colors.green[400], size: 20),
                    const SizedBox(width: 8),
                    Text("$completedCount/${widget.theme.files.length} testées", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                // Barre de progression Quiz
                if (avgScore >= 0) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: avgScore / 100,
                            backgroundColor: Colors.grey[200],
                            color: _getScoreColor(avgScore),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${avgScore.round()}%",
                        style: TextStyle(
                          color: _getScoreColor(avgScore),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ] else
                  const Text(
                    "Commencez un quiz !",
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                const SizedBox(height: 12),
                // Bouton Quiz
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startSectionQuiz(context),
                    icon: const Icon(Icons.school, size: 18),
                    label: const Text("Quiz du chapitre"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                    ),
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
                final isFavorite = _favoritesService.isFavorite(ficheId);
                final isRead = _readingService.isRead(ficheId);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.1), blurRadius: 5)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Checkbox lecture
                        SizedBox(
                          width: 32,
                          child: Checkbox(
                            value: isRead,
                            onChanged: (_) => _readingService.toggleRead(ficheId),
                            activeColor: Colors.blue,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: score != null 
                                ? _getScoreColor(score.percentage).withOpacity(0.1)
                                : (isDark ? Colors.grey[800] : const Color(0xFF1A237E).withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            score != null 
                                ? (score.percentage >= 80 ? Icons.check_circle : Icons.article)
                                : Icons.article,
                            color: score != null 
                                ? _getScoreColor(score.percentage)
                                : (isDark ? Colors.grey[400] : const Color(0xFF1A237E)),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      ficheId,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: isRead ? TextDecoration.none : TextDecoration.none,
                      ),
                    ),
                    subtitle: score != null
                        ? Text(
                            "Score: ${score.percentage.round()}% • ${_formatDate(score.date)}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          )
                        : Text(
                            isRead ? "Lu" : "Non lu",
                            style: TextStyle(fontSize: 12, color: isRead ? Colors.blue : Colors.grey[400]),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton Favoris
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _favoritesService.toggleFavorite(ficheId),
                          tooltip: isFavorite ? "Retirer des favoris" : "Ajouter aux favoris",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        _buildScoreBadge(ficheId),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.quiz, color: isDark ? Colors.blue[300] : const Color(0xFF1A237E), size: 20),
                          onPressed: () => _startFicheQuiz(context, ficheId),
                          tooltip: "Quiz de cette fiche",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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