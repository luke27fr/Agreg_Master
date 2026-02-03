import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import '../widgets/global_search_button.dart';
import '../pages/search_page.dart';

class DeveloppementsPage extends StatefulWidget {
  const DeveloppementsPage({super.key});

  @override
  State<DeveloppementsPage> createState() => _DeveloppementsPageState();
}

class _DeveloppementsPageState extends State<DeveloppementsPage> {
  List<dynamic> _developpements = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterDomaine = 'Tous';

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
      final json = await rootBundle.loadString('assets/data/developpements.json');
      final data = jsonDecode(json);
      setState(() {
        _developpements = data['developpements'] ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement développements: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFilteredDeveloppements() {
    return _developpements.where((dev) {
      final matchSearch = _searchQuery.isEmpty ||
          (dev['titre'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      final matchDomaine = _filterDomaine == 'Tous' || dev['domaine'] == _filterDomaine;
      return matchSearch && matchDomaine;
    }).toList();
  }

  Color _getNiveauColor(String niveau) {
    switch (niveau) {
      case 'Facile':
        return Colors.green;
      case 'Classique':
        return Colors.blue;
      case 'Difficile':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Termes mathématiques importants à rendre cliquables
  static const _termsImportants = [
    'Sylow', 'groupe', 'sous-groupe', 'anneau', 'corps', 'morphisme',
    'matrice', 'déterminant', 'valeur propre', 'diagonalisation',
    'polynôme', 'racine', 'théorème', 'lemme', 'corollaire',
    'série', 'suite', 'convergence', 'limite', 'continuité',
    'dérivée', 'intégrale', 'différentielle', 'espace vectoriel',
    'norme', 'distance', 'topologie', 'compact', 'connexe',
    'Hilbert', 'Banach', 'Fourier', 'Laplace', 'Cauchy',
    'Gauss', 'Lagrange', 'Newton', 'Euler', 'Riemann',
    'isométrie', 'rotation', 'symétrie', 'translation',
    'probabilité', 'variable aléatoire', 'espérance', 'variance',
    'loi normale', 'TCL', 'loi des grands nombres',
  ];

  Widget _buildClickableText(String text, BuildContext context, bool isDark) {
    final words = text.split(' ');
    final spans = <InlineSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final cleanWord = word.replaceAll(RegExp(r'[^\w\séàèùâêîôûëïü-]'), '').toLowerCase();
      
      bool isImportant = false;
      String? matchedTerm;
      for (final term in _termsImportants) {
        if (cleanWord.contains(term.toLowerCase())) {
          isImportant = true;
          matchedTerm = term;
          break;
        }
      }

      if (isImportant) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blue.shade700, width: 1.5)),
              ),
              child: Text(
                word,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ));
      } else {
        spans.add(TextSpan(text: word));
      }

      if (i < words.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _getFilteredDeveloppements();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Développements', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Recherche et filtres
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un développement...',
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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildFilterChip('Tous', isDark),
                          const SizedBox(width: 8),
                          _buildFilterChip('Algèbre', isDark),
                          const SizedBox(width: 8),
                          _buildFilterChip('Analyse', isDark),
                          const SizedBox(width: 8),
                          _buildFilterChip('Probabilités', isDark),
                        ],
                      ),
                    ],
                  ),
                ),
                // Statistiques
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${filtered.length} développement(s)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Liste
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildDevCard(filtered[index], isDark);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _filterDomaine == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterDomaine = selected ? label : 'Tous');
      },
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildDevCard(Map<String, dynamic> dev, bool isDark) {
    final niveau = dev['niveau'] as String;
    final duree = dev['duree_min'] as int;
    final lecons = dev['lecons'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: () => _showDevDetails(context, dev),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MarkdownBody(
                      data: dev['titre'],
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      extensionSet: _latexExtensionSet,
                      builders: {'latex': LatexElementBuilder()},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getNiveauColor(niveau).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      niveau,
                      style: TextStyle(
                        color: _getNiveauColor(niveau),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '~$duree min',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.school, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Leçons: ${lecons.join(", ")}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLeconInfo(BuildContext context, int numero) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.school, color: Color(0xFF1A237E)),
            const SizedBox(width: 8),
            Text('Leçon $numero'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cette leçon peut être consultée dans la section "Leçons d\'oral".',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ce développement peut être utilisé pour cette leçon.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/lecons');
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Voir les leçons'),
          ),
        ],
      ),
    );
  }

  void _showDevDetails(BuildContext context, Map<String, dynamic> dev) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getNiveauColor(dev['niveau']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dev['niveau'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('~${dev['duree_min']} min'),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Titre
              MarkdownBody(
                data: dev['titre'],
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                extensionSet: _latexExtensionSet,
                builders: {'latex': LatexElementBuilder()},
              ),

              const SizedBox(height: 24),

              // Plan (avec mots cliquables)
              Row(
                children: [
                  const Text(
                    'Plan du développement',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Les termes importants sont cliquables',
                    child: Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...((dev['plan'] as List).map((step) {
                // Si le step contient du LaTeX ($ ou $$), utiliser MarkdownBody
                if ((step as String).contains(r'$')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right, color: Color(0xFF1A237E)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MarkdownBody(
                            data: step,
                            styleSheet: MarkdownStyleSheet(p: const TextStyle(fontSize: 14)),
                            extensionSet: _latexExtensionSet,
                            builders: {'latex': LatexElementBuilder()},
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Sinon, texte cliquable
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right, color: Color(0xFF1A237E)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildClickableText(step, context, false)),
                      ],
                    ),
                  );
                }
              })),

              const SizedBox(height: 24),

              // Points clés (avec mots cliquables)
              Row(
                children: [
                  const Text(
                    'Points clés à ne pas oublier',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Les termes importants sont cliquables',
                    child: Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...((dev['points_cles'] as List).map((point) {
                // Si le point contient du LaTeX ($ ou $$), utiliser MarkdownBody
                if ((point as String).contains(r'$')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MarkdownBody(
                            data: point,
                            styleSheet: MarkdownStyleSheet(p: const TextStyle(fontSize: 14)),
                            extensionSet: _latexExtensionSet,
                            builders: {'latex': LatexElementBuilder()},
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Sinon, texte cliquable
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: _buildClickableText(point, context, false)),
                      ],
                    ),
                  );
                }
              })),

              const SizedBox(height: 24),

              // Prérequis (cliquables)
              const Text(
                'Prérequis',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (dev['prerequis'] as List).map((req) => InkWell(
                  onTap: () {
                    Navigator.pop(ctx); // Fermer le modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPage(),
                      ),
                    ).then((_) {
                      // Pré-remplir la recherche avec le prérequis
                      // Note: Cela nécessiterait de passer un paramètre à SearchPage
                    });
                  },
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(req),
                        const SizedBox(width: 4),
                        const Icon(Icons.search, size: 14),
                      ],
                    ),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 24),

              // Leçons compatibles (cliquables)
              const Text(
                'Leçons compatibles',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (dev['lecons'] as List).map((num) => InkWell(
                  onTap: () {
                    Navigator.pop(ctx); // Fermer le modal
                    _showLeconInfo(context, num);
                  },
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Leçon $num'),
                        const SizedBox(width: 4),
                        const Icon(Icons.open_in_new, size: 14),
                      ],
                    ),
                    backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
