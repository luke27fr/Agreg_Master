import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../fiche_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _allFiches = [];
  List<SearchResult> _filteredFiches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllFiches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllFiches() async {
    try {
      final manifestJson = await rootBundle.loadString('assets/fiches/manifest.json');
      final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
      final themes = manifest['themes'] as List<dynamic>;

      final List<SearchResult> fiches = [];

      for (var theme in themes) {
        final themeId = theme['id'] as String;
        final themeLabel = theme['label'] as String;
        final themePath = theme['path'] as String;
        final files = (theme['files'] as List<dynamic>).cast<String>();

        for (var file in files) {
          final ficheId = file.replaceAll('.md', '');
          final assetPath = '$themePath/$file';
          
          // Charger le contenu de la fiche pour la recherche
          try {
            final content = await rootBundle.loadString(assetPath);
            fiches.add(SearchResult(
              ficheId: ficheId,
              themeLabel: themeLabel,
              assetPath: assetPath,
              content: content,
            ));
          } catch (e) {
            // Ignorer les fiches qui ne peuvent pas être chargées
          }
        }
      }

      if (mounted) {
        setState(() {
          _allFiches = fiches;
          _filteredFiches = fiches;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement fiches: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() => _filteredFiches = _allFiches);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final results = _allFiches.where((fiche) {
      return fiche.ficheId.toLowerCase().contains(lowerQuery) ||
             fiche.themeLabel.toLowerCase().contains(lowerQuery) ||
             fiche.content.toLowerCase().contains(lowerQuery);
    }).toList();

    // Trier par pertinence (titre d'abord, puis contenu)
    results.sort((a, b) {
      final aInTitle = a.ficheId.toLowerCase().contains(lowerQuery);
      final bInTitle = b.ficheId.toLowerCase().contains(lowerQuery);
      if (aInTitle && !bInTitle) return -1;
      if (!aInTitle && bInTitle) return 1;
      return a.ficheId.compareTo(b.ficheId);
    });

    setState(() => _filteredFiches = results);
  }

  String _getSnippet(String content, String query) {
    if (query.isEmpty) return '';
    
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerContent.indexOf(lowerQuery);
    
    if (index == -1) return '';
    
    final start = (index - 50).clamp(0, content.length);
    final end = (index + query.length + 50).clamp(0, content.length);
    
    var snippet = content.substring(start, end);
    if (start > 0) snippet = '...$snippet';
    if (end < content.length) snippet = '$snippet...';
    
    return snippet.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');
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
        title: const Text('Rechercher', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rechercher un théorème, une définition...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          
          // Résultats
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFiches.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Tapez pour rechercher'
                                  : 'Aucun résultat trouvé',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredFiches.length,
                        itemBuilder: (context, index) {
                          final fiche = _filteredFiches[index];
                          final snippet = _getSnippet(fiche.content, _searchController.text);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                fiche.ficheId,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    fiche.themeLabel,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (snippet.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      snippet,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FichePage(assetPath: fiche.assetPath),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
          
          // Compteur de résultats
          if (!_loading && _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${_filteredFiches.length} résultat(s)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchResult {
  final String ficheId;
  final String themeLabel;
  final String assetPath;
  final String content;

  SearchResult({
    required this.ficheId,
    required this.themeLabel,
    required this.assetPath,
    required this.content,
  });
}
