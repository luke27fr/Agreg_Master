import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Tes imports existants
import 'package:agreg_master/models/quiz_model.dart';
import 'package:agreg_master/pages/quiz_page.dart';
import 'fiche_page.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    _loadManifest();
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
              Container(
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
                    const Icon(Icons.library_books, color: Colors.white, size: 40),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_totalFiches Fiches disponibles",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Continue tes efforts !",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

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
                            childAspectRatio: 1.3, // Plus rectangulaire pour l'aspect "Carte"
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: _themes.length,
                          itemBuilder: (context, index) {
                            final theme = _themes[index];
                            final color = _getThemeColor(theme.id);
                            final icon = _getThemeIcon(theme.id);

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
                                      const SizedBox(height: 16),
                                      Text(
                                        theme.label,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${theme.files.length} fiches",
                                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A237E)),
        title: Text(widget.theme.label, style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: widget.theme.files.length,
        itemBuilder: (context, index) {
          final file = widget.theme.files[index];
          final title = file.replaceAll('.md', '');
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.article, color: Color(0xFF1A237E), size: 20),
              ),
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => FichePage(assetPath: '${widget.theme.path}/$file')));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startSectionQuiz(context),
        label: const Text("Quiz Chapitre"),
        icon: const Icon(Icons.school),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
    );
  }
}