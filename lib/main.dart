import 'dart:convert';
import 'dart:math'; // Pour le mélange aléatoire
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour rootBundle
import 'package:google_fonts/google_fonts.dart';

// Assure-toi que ces imports correspondent bien à tes fichiers
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
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: const Color(0xFF1B365D),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B365D),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1B365D), width: 0.5),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
      ),
      home: const ThemesScreen(),
    );
  }
}

/// Modèle d'un thème (Algèbre, Analyse, etc.).
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
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
  List<({ThemeItem theme, String file, String assetPath})> _allFiches = [];
  bool _loading = true;
  String? _error;
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  // --- FONCTION QUI LANCE LE GRAND QUIZ GÉNÉRAL ---
  Future<void> _startGeneralQuiz(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      List<QuizQuestion> allQuestions = [];

      // On prend TOUT
      data.forEach((key, value) {
        if (value is List) {
          for (var q in value) {
            allQuestions.add(QuizQuestion.fromJson(q));
          }
        }
      });

      if (allQuestions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pas de questions trouvées !")),
          );
        }
        return;
      }

      // Mélange
      allQuestions.shuffle(Random());
      if (allQuestions.length > 20) {
        allQuestions = allQuestions.sublist(0, 20);
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              title: "Grand Quiz Général 🔥",
              questions: allQuestions,
            ),
          ),
        );
      }
    } catch (e) {
      print("Erreur quiz général : $e");
    }
  }
  // ------------------------------------------------

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<ThemeItem> _getFilteredThemes() => _themes;

  List<({ThemeItem theme, String file, String assetPath})> _getFilteredFiches() {
    if (_searchQuery.trim().isEmpty) return [];
    final q = _searchQuery.trim().toLowerCase();
    return _allFiches.where((f) {
      final title = f.file.replaceAll('.md', '').toLowerCase();
      final category = f.theme.label.toLowerCase();
      return title.contains(q) || category.contains(q);
    }).toList();
  }

  void _buildAllFiches() {
    _allFiches = [];
    for (final theme in _themes) {
      for (final file in theme.files) {
        _allFiches.add((
          theme: theme,
          file: file,
          assetPath: '${theme.path}/$file',
        ));
      }
    }
  }

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
      if (mounted) {
        setState(() {
          _themes = list ?? [];
          _buildAllFiches();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _onThemeTap(ThemeItem theme) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FichesListScreen(
          theme: theme,
        ),
      ),
    );
  }

  void _onFicheTap(String assetPath) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FichePage(assetPath: assetPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agreg Master')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agreg Master')),
        body: Center(child: Text('Erreur: $_error')),
      );
    }

    final filteredThemes = _getFilteredThemes();
    final filteredFiches = _getFilteredFiches();
    final showSearchResults = _searchQuery.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Rechercher une fiche...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : const Text('Agreg Master', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                  FocusScope.of(context).unfocus();
                } else {
                  _isSearching = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _searchFocusNode.requestFocus();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B365D), Color(0xFF2A4A7A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Thèmes',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: showSearchResults
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: filteredFiches.length,
                          itemBuilder: (context, index) {
                            final fiche = filteredFiches[index];
                            return ListTile(
                              title: Text(fiche.file.replaceAll('.md', '')),
                              subtitle: Text(fiche.theme.label),
                              onTap: () => _onFicheTap(fiche.assetPath),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            );
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: filteredThemes.length,
                          itemBuilder: (context, index) {
                            final theme = filteredThemes[index];
                            return ListTile(
                              onTap: () => _onThemeTap(theme),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF1B365D),
                                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text(theme.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: const Icon(Icons.chevron_right),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      // BOUTON GRAND QUIZ GÉNÉRAL
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startGeneralQuiz(context),
        label: const Text("Grand Quiz"),
        icon: const Icon(Icons.flash_on),
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// Écran listant les fiches .md d'un thème avec recherche.
class FichesListScreen extends StatefulWidget {
  final ThemeItem theme;

  const FichesListScreen({super.key, required this.theme});

  @override
  State<FichesListScreen> createState() => _FichesListScreenState();
}

class _FichesListScreenState extends State<FichesListScreen> {
  String _searchQuery = '';
  bool _isSearchMode = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  // --- FONCTION QUI LANCE LE QUIZ FILTRÉ (SPÉCIAL CHAPITRE) ---
  Future<void> _startSectionQuiz(BuildContext context) async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      List<QuizQuestion> sectionQuestions = [];

      // FILTRAGE : On ne garde que les questions des fichiers de CE thème
      for (var file in widget.theme.files) {
        // Ex: "hilbert.md" -> "hilbert"
        String key = file.replaceAll('.md', '');
        
        if (data.containsKey(key)) {
          for (var q in data[key]) {
            sectionQuestions.add(QuizQuestion.fromJson(q));
          }
        }
      }

      if (sectionQuestions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pas encore de quiz pour ce chapitre !")),
          );
        }
        return;
      }

      // Mélange uniquement la section
      sectionQuestions.shuffle(Random());

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              title: "Quiz ${widget.theme.label}", // Ex: Quiz Algèbre
              questions: sectionQuestions,
            ),
          ),
        );
      }
    } catch (e) {
      print("Erreur quiz section : $e");
    }
  }
  // ------------------------------------------------------------

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<String> _getFilteredFiles() {
    final files = widget.theme.files;
    if (_searchQuery.trim().isEmpty) return files;
    final q = _searchQuery.trim().toLowerCase();
    return files.where((f) {
      final title = f.replaceAll('.md', '').toLowerCase();
      final category = widget.theme.label.toLowerCase();
      return title.contains(q) || category.contains(q);
    }).toList();
  }

  void _onSearchTap() {
    setState(() {
      _isSearchMode = true;
      _searchQuery = '';
      _searchController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _onSearchClose() {
    setState(() {
      _isSearchMode = false;
      _searchQuery = '';
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFiles = _getFilteredFiles();

    return Scaffold(
      appBar: AppBar(
        title: _isSearchMode
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Rechercher une fiche...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : Text(widget.theme.label),
        actions: [
          IconButton(
            icon: Icon(_isSearchMode ? Icons.close : Icons.search),
            onPressed: _isSearchMode ? _onSearchClose : _onSearchTap,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B365D), Color(0xFF2A4A7A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Fiches — ${widget.theme.label}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: filteredFiles.isEmpty
                      ? Center(child: Text("Aucune fiche trouvée."))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: filteredFiles.length,
                          itemBuilder: (context, index) {
                            final file = filteredFiles[index];
                            final assetPath = '${widget.theme.path}/$file';
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) => FichePage(assetPath: assetPath),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFF1B365D),
                                child: Icon(Icons.article_outlined, color: Colors.white, size: 20),
                              ),
                              title: Text(file.replaceAll('.md', ''), style: const TextStyle(fontWeight: FontWeight.w500)),
                              trailing: const Icon(Icons.open_in_new, color: Color(0xFF1B365D), size: 20),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      // BOUTON QUIZ SPÉCIAL CHAPITRE
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startSectionQuiz(context),
        label: const Text("Quiz du Chapitre"),
        icon: const Icon(Icons.school),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}