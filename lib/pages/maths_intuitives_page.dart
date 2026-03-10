import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import '../services/maths_intuitives_service.dart';
import '../services/subscription_service.dart';
import '../models/maths_intuitives_model.dart';
import '../widgets/global_search_button.dart';
import 'paywall_page.dart';

class MathsIntuitivesPage extends StatefulWidget {
  const MathsIntuitivesPage({super.key});

  @override
  State<MathsIntuitivesPage> createState() => _MathsIntuitivesPageState();
}

class _MathsIntuitivesPageState extends State<MathsIntuitivesPage> {
  final MathsIntuitivesService _service = MathsIntuitivesService();
  String _selectedDomaine = 'Tous';
  String _selectedCategorie = 'Toutes';

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );
  
  @override
  void initState() {
    super.initState();
    _service.addListener(_onDataChanged);
    _service.loadConcepts();
  }

  @override
  void dispose() {
    _service.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final filteredConcepts = _getFilteredConcepts();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // App Bar avec gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade700, Colors.deepPurple.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.lightbulb_outline, size: 60, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Maths Intuitives',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les concepts de l\'agrégation expliqués simplement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text('Maths Intuitives'),
              centerTitle: true,
            ),
            actions: const [GlobalSearchButton()],
          ),

          // Message d'intro
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.purple.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.purple.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Bienvenue !',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tu vas découvrir les concepts clés de l\'agrégation de maths, expliqués comme si on discutait autour d\'un café. '
                    'Pas de jargon inutile, que de l\'intuition et des exemples concrets ! 🎯',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),

          // Filtres par catégorie
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explorer par thème :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategorieChip('Toutes', '🌟'),
                        ..._service.categories.map((cat) => 
                          _buildCategorieChip(cat.nom, cat.emoji)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Filtres par domaine
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDomaineChip('Tous'),
                  _buildDomaineChip('algèbre'),
                  _buildDomaineChip('analyse'),
                  _buildDomaineChip('géométrie'),
                  _buildDomaineChip('probabilités'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Liste des concepts
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final concept = filteredConcepts[index];
                  final sub = SubscriptionService();
                  final globalIndex = _service.concepts.indexOf(concept);
                  final isLocked = !sub.isPremium && globalIndex >= sub.getFreeAccessCount('maths_intuitives');
                  return _buildConceptCard(concept, isDark, isLocked: isLocked);
                },
                childCount: filteredConcepts.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  List<ConceptIntuitif> _getFilteredConcepts() {
    var concepts = _service.concepts;
    
    if (_selectedCategorie != 'Toutes') {
      concepts = _service.getConceptsByCategorie(_selectedCategorie);
    }
    
    if (_selectedDomaine != 'Tous') {
      concepts = concepts.where((c) => c.domaine == _selectedDomaine).toList();
    }
    
    return concepts;
  }

  Widget _buildCategorieChip(String nom, String emoji) {
    final isSelected = _selectedCategorie == nom;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Text(emoji, style: const TextStyle(fontSize: 18)),
        label: Text(nom),
        selected: isSelected,
        onSelected: (selected) => setState(() => _selectedCategorie = nom),
        selectedColor: Colors.deepPurple,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDomaineChip(String domaine) {
    final isSelected = _selectedDomaine == domaine;
    return ChoiceChip(
      label: Text(domaine),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedDomaine = domaine),
      selectedColor: _getDomaineColor(domaine),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
      ),
    );
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'maths_intuitives')),
    );
    if (result == true && mounted) setState(() {});
  }

  Widget _buildConceptCard(ConceptIntuitif concept, bool isDark, {bool isLocked = false}) {
    if (isLocked) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock, color: Colors.grey),
          ),
          title: Text(
            concept.titre,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[500]),
          ),
          subtitle: const Text('Premium requis', style: TextStyle(fontSize: 12, color: Colors.amber)),
          trailing: const Icon(Icons.star, color: Colors.amber, size: 20),
          onTap: _showPaywall,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showConceptDetail(concept),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                _getDomaineColor(concept.domaine).withValues(alpha: 0.1),
                _getDomaineColor(concept.domaine).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getDomaineColor(concept.domaine),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getDomaineIcon(concept.domaine),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            concept.titre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getDomaineColor(concept.domaine).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  concept.domaine,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _getDomaineColor(concept.domaine),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ...List.generate(
                                concept.difficulteIntuitive,
                                (_) => Icon(
                                  Icons.lightbulb,
                                  size: 12,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Question clé
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, size: 20, color: Colors.amber.shade900),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MarkdownBody(
                          data: concept.questionCle,
                          selectable: false,
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            p: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                          extensionSet: _latexExtensionSet,
                          builders: {'latex': LatexElementBuilder()},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Analogie
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_objects, size: 16, color: Colors.green.shade700),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MarkdownBody(
                        data: concept.analogieSimple,
                        selectable: false,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(fontSize: 13, height: 1.6),
                        ),
                        extensionSet: _latexExtensionSet,
                        builders: {'latex': LatexElementBuilder()},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Bouton "En savoir plus"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showConceptDetail(concept),
                    icon: const Icon(Icons.auto_stories, size: 18),
                    label: const Text('Lire l\'explication complète'),
                    style: TextButton.styleFrom(
                      foregroundColor: _getDomaineColor(concept.domaine),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConceptDetail(ConceptIntuitif concept) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle pour glisser
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // En-tête
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getDomaineColor(concept.domaine),
                                _getDomaineColor(concept.domaine).withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(_getDomaineIcon(concept.domaine), color: Colors.white, size: 32),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      concept.titre,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.school, color: Colors.white, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Niveau Agrég: ${concept.niveauAgregation}/5',
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...List.generate(
                                          concept.difficulteIntuitive,
                                          (_) => const Icon(Icons.lightbulb, size: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Question clé
                        _buildSection(
                          '❓ La Question Clé',
                          concept.questionCle,
                          Colors.amber,
                        ),
                        
                        // Analogie
                        _buildSection(
                          '💡 En Une Phrase',
                          concept.analogieSimple,
                          Colors.green,
                        ),
                        
                        // Explication intuitive
                        _buildSection(
                          '🎯 L\'Explication Intuitive',
                          concept.explicationIntuitive,
                          Colors.blue,
                        ),
                        
                        // Exemple concret
                        _buildSection(
                          '🌍 Exemples Concrets',
                          concept.exempleConcret,
                          Colors.orange,
                        ),
                        
                        // Lien avec lycée
                        _buildSection(
                          '🎓 Ce Que Tu Connais Déjà',
                          concept.lienAvecLycee,
                          Colors.purple,
                        ),
                        
                        // Pourquoi c'est important
                        _buildSection(
                          '⭐ Pourquoi C\'est Important',
                          concept.pourquoiCestImportant,
                          Colors.red,
                        ),
                        
                        // Visualisation
                        if (concept.visualisation != null)
                          _buildSection(
                            '👁️ Image Mentale',
                            concept.visualisation!,
                            Colors.teal,
                          ),
                        
                        // Idées fausses
                        if (concept.ideesFausses.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            '⚠️ Attention aux Pièges !',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...concept.ideesFausses.map((idee) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: MarkdownBody(
                              data: idee,
                              selectable: false,
                              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                p: TextStyle(fontSize: 14, color: Colors.red.shade900, height: 1.5),
                              ),
                              extensionSet: _latexExtensionSet,
                              builders: {'latex': LatexElementBuilder()},
                            ),
                          )),
                        ],
                        
                        // Anecdote
                        if (concept.anecdote != null)
                          _buildSection(
                            '📚 Le Saviez-Vous ?',
                            concept.anecdote!,
                            Colors.indigo,
                          ),
                        
                        // Applications réelles
                        if (concept.applicationsReelles.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            '🚀 Applications Réelles',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...concept.applicationsReelles.map((app) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _getDomaineColor(concept.domaine),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MarkdownBody(
                                    data: app,
                                    selectable: false,
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                      p: const TextStyle(fontSize: 14, height: 1.5),
                                    ),
                                    extensionSet: _latexExtensionSet,
                                    builders: {'latex': LatexElementBuilder()},
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Bouton de fermeture
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('J\'ai compris !'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getDomaineColor(concept.domaine),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String titre, String contenu, Color couleur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: couleur,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                titre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: couleur.withValues(alpha: 0.2)),
          ),
          child: MarkdownBody(
            data: contenu,
            selectable: false,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: const TextStyle(fontSize: 15, height: 1.7),
              strong: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              em: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              listBullet: const TextStyle(fontSize: 15),
              code: TextStyle(
                fontSize: 14,
                backgroundColor: Colors.grey.shade100,
                fontFamily: 'monospace',
              ),
            ),
            extensionSet: _latexExtensionSet,
            builders: {'latex': LatexElementBuilder()},
          ),
        ),
      ],
    );
  }

  Color _getDomaineColor(String domaine) {
    switch (domaine.toLowerCase()) {
      case 'algèbre': return Colors.blue.shade700;
      case 'analyse': return Colors.green.shade700;
      case 'géométrie': return Colors.orange.shade700;
      case 'probabilités': return Colors.purple.shade700;
      default: return Colors.grey.shade700;
    }
  }

  IconData _getDomaineIcon(String domaine) {
    switch (domaine.toLowerCase()) {
      case 'algèbre': return Icons.calculate;
      case 'analyse': return Icons.show_chart;
      case 'géométrie': return Icons.crop_square;
      case 'probabilités': return Icons.casino;
      default: return Icons.science;
    }
  }
}
