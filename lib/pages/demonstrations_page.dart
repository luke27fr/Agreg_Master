import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/global_search_button.dart';

class DemonstrationsPage extends StatefulWidget {
  const DemonstrationsPage({super.key});

  @override
  State<DemonstrationsPage> createState() => _DemonstrationsPageState();
}

class _DemonstrationsPageState extends State<DemonstrationsPage> {
  List<dynamic> _demonstrations = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _showProofs = false; // Mode récitation

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final json = await rootBundle.loadString('assets/data/demonstrations.json');
      final data = jsonDecode(json);
      setState(() {
        _demonstrations = data['demonstrations'] ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement démonstrations: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFiltered() {
    if (_searchQuery.isEmpty) return _demonstrations;
    return _demonstrations.where((demo) {
      final titre = (demo['titre'] as String).toLowerCase();
      final tags = (demo['tags'] as List).join(' ').toLowerCase();
      return titre.contains(_searchQuery.toLowerCase()) || 
             tags.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _getFiltered();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Démonstrations', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Recherche globale
          const GlobalSearchButton(),
          // Mode récitation
          IconButton(
            icon: Icon(_showProofs ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showProofs = !_showProofs),
            tooltip: _showProofs ? 'Masquer les preuves' : 'Afficher les preuves',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Mode info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _showProofs ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _showProofs ? Colors.green : Colors.orange,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _showProofs ? Icons.menu_book : Icons.psychology,
                        color: _showProofs ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _showProofs
                              ? 'Mode lecture : preuves visibles'
                              : 'Mode récitation : essayez de retrouver les preuves !',
                          style: TextStyle(
                            color: _showProofs ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Recherche
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildDemoCard(filtered[index], isDark);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDemoCard(Map<String, dynamic> demo, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    demo['domaine'],
                    style: const TextStyle(
                      color: Color(0xFF1A237E),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Wrap(
                  spacing: 4,
                  children: (demo['tags'] as List).take(2).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  )).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Titre du théorème
            MarkdownBody(
              data: '**${demo['titre']}**',
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
              extensionSet: _latexExtensionSet,
              builders: {'latex': LatexElementBuilder()},
            ),
            
            const SizedBox(height: 12),
            
            // Énoncé
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Énoncé',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: demo['enonce'],
                    extensionSet: _latexExtensionSet,
                    builders: {'latex': LatexElementBuilder()},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),

            // Vidéos et ressources
            if (demo['videos'] != null && (demo['videos'] as List).isNotEmpty) ...[
              const Text(
                'Ressources vidéo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ...(demo['videos'] as List).map((video) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.play_circle, color: Colors.red),
                    title: Text(
                      video['titre'] as String,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${video['dureeMinutes']} min${video['auteur'] != null ? ' • ${video['auteur']}' : ''}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: const Icon(Icons.open_in_new, size: 16),
                    onTap: () => _launchVideo(video['url'] as String),
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            // Difficulté et remarque
            if (demo['difficulte'] != null || demo['remarque'] != null) ...[
              Row(
                children: [
                  if (demo['difficulte'] != null) ...[
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      'Difficulté: ${demo['difficulte']}/5',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                  if (demo['remarque'] != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.info, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        demo['remarque'] as String,
                        style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],
            
            // Preuve (masquée en mode récitation)
            if (_showProofs) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preuve',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    ...((demo['preuve'] as List).asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key + 1}. ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: MarkdownBody(
                              data: entry.value,
                              extensionSet: _latexExtensionSet,
                              builders: {'latex': LatexElementBuilder()},
                            ),
                          ),
                        ],
                      ),
                    ))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ] else
              ElevatedButton.icon(
                onPressed: () => _showProofDialog(context, demo),
                icon: const Icon(Icons.visibility),
                label: const Text('Voir la preuve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            
            // Corollaires
            if ((demo['corollaires'] as List).isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Corollaires :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              ...((demo['corollaires'] as List).map((cor) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.subdirectory_arrow_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        cor,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ))),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    try {
      final uri = Uri.parse(url);
      
      // Tenter d'ouvrir l'URL
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        // Essayer avec mode platformDefault d'abord (meilleure compatibilité Android)
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir la vidéo. Vérifiez votre connexion.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('URL non valide ou application manquante'),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Copier URL',
                onPressed: () {
                  // L'utilisateur pourrait copier l'URL manuellement
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'ouverture de la vidéo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showProofDialog(BuildContext context, Map<String, dynamic> demo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(demo['titre']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: (demo['preuve'] as List).asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}. ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: MarkdownBody(
                      data: entry.value,
                      extensionSet: _latexExtensionSet,
                      builders: {'latex': LatexElementBuilder()},
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
