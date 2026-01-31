import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
        appBar: AppBar(
          title: const Text('Agreg Master'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agreg Master')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Erreur: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : const Text(
                'Agreg Master',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
                FocusScope.of(context).unfocus();
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                  _searchQuery = '';
                  _searchController.clear();
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _searchFocusNode.requestFocus();
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
            colors: [
              Color(0xFF1B365D),
              Color(0xFF2A4A7A),
            ],
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: showSearchResults
                      ? (filteredFiches.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucune fiche trouvée pour "$_searchQuery"',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: filteredFiches.length,
                              itemBuilder: (context, index) {
                                final fiche = filteredFiches[index];
                                final title = fiche.file.replaceAll('.md', '');
                                return ListTile(
                                  onTap: () => _onFicheTap(fiche.assetPath),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF1B365D),
                                    child: Icon(
                                      Icons.article_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1B365D),
                                    ),
                                  ),
                                  subtitle: Text(
                                    fiche.theme.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.open_in_new,
                                    color: Color(0xFF1B365D),
                                    size: 20,
                                  ),
                                );
                              },
                            ))
                      : (filteredThemes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucun thème pour l\'instant',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    theme.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1B365D),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF1B365D),
                                  ),
                                );
                              },
                            )),
                ),
              ),
            ],
          ),
        ),
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
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : Text(widget.theme.label),
        actions: [
          if (_isSearchMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _onSearchClose,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchTap,
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B365D),
              Color(0xFF2A4A7A),
            ],
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: filteredFiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _searchQuery.isEmpty ? Icons.description_outlined : Icons.search_off,
                                size: 56,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty ? 'Aucune fiche dans ce thème' : 'Aucune fiche trouvée pour "$_searchQuery"',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
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
                                    builder: (context) => FichePage(
                                      assetPath: assetPath,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF1B365D),
                                child: Icon(
                                  Icons.article_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                file.replaceAll('.md', ''),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1B365D),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.open_in_new,
                                color: Color(0xFF1B365D),
                                size: 20,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
