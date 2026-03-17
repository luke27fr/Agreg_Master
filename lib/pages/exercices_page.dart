import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/content_loader.dart';
import '../widgets/global_search_button.dart';
import '../widgets/latex_text.dart';
import '../services/subscription_service.dart';
import '../services/proactive_paywall_service.dart';
import 'paywall_page.dart';

class ExercicesPage extends StatefulWidget {
  const ExercicesPage({super.key});

  @override
  State<ExercicesPage> createState() => _ExercicesPageState();
}

class _ExercicesPageState extends State<ExercicesPage> {
  List<dynamic> _exercices = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterDomaine = 'Tous';
  String _filterNiveau = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final json = await ContentLoader.loadString('assets/data/exercices.json');
      final data = jsonDecode(json);
      setState(() {
        _exercices = data['exercices'] ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement exercices: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFiltered() {
    return _exercices.where((ex) {
      final matchSearch = _searchQuery.isEmpty ||
          (ex['titre'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      final matchDomaine = _filterDomaine == 'Tous' || ex['domaine'] == _filterDomaine;
      final matchNiveau = _filterNiveau == 'Tous' || ex['niveau'] == _filterNiveau;
      return matchSearch && matchDomaine && matchNiveau;
    }).toList();
  }

  Color _getNiveauColor(String niveau) {
    switch (niveau) {
      case 'Facile':
        return Colors.green;
      case 'Moyen':
        return Colors.orange;
      case 'Difficile':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
        title: const Text('Exercices Classiques', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Recherche
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher un exercice...',
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
                // Filtres
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Tous', _filterDomaine, (v) => setState(() => _filterDomaine = v), isDark),
                              const SizedBox(width: 8),
                              _buildFilterChip('Algèbre', _filterDomaine, (v) => setState(() => _filterDomaine = v), isDark),
                              const SizedBox(width: 8),
                              _buildFilterChip('Analyse', _filterDomaine, (v) => setState(() => _filterDomaine = v), isDark),
                              const SizedBox(width: 8),
                              _buildFilterChip('Probabilités', _filterDomaine, (v) => setState(() => _filterDomaine = v), isDark),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Niveau
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text('Niveau: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildNiveauChip('Tous', isDark),
                      const SizedBox(width: 8),
                      _buildNiveauChip('Facile', isDark),
                      const SizedBox(width: 8),
                      _buildNiveauChip('Moyen', isDark),
                      const SizedBox(width: 8),
                      _buildNiveauChip('Difficile', isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Liste
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildExerciceCard(filtered[index], isDark);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, String currentValue, Function(String) onSelected, bool isDark) {
    final isSelected = currentValue == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(selected ? label : 'Tous'),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildNiveauChip(String niveau, bool isDark) {
    final isSelected = _filterNiveau == niveau;
    final color = niveau == 'Tous' ? Colors.grey : _getNiveauColor(niveau);
    
    return GestureDetector(
      onTap: () => setState(() => _filterNiveau = niveau),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Text(
          niveau,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'exercices')),
    );
    if (result == true && mounted) {
      setState(() {}); // Rafraîchir après abonnement
    }
  }

  Future<void> _checkProactivePaywall() async {
    final service = ProactivePaywallService();
    final shouldShow = await service.checkContentView();
    if (shouldShow && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) =>
                const PaywallPage(source: 'proactive_content_limit')),
      );
    }
  }

  Widget _buildExerciceCard(Map<String, dynamic> ex, bool isDark) {
    final sub = SubscriptionService();
    final globalIndex = _exercices.indexOf(ex);
    final isLocked = !sub.isPremium && globalIndex >= sub.getFreeAccessCount('exercices');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: isLocked
          ? ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock, color: Colors.grey),
              ),
              title: Text(
                ex['titre'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[500]),
              ),
              subtitle: const Text('Premium requis', style: TextStyle(fontSize: 11, color: Colors.amber)),
              trailing: const Icon(Icons.star, color: Colors.amber, size: 20),
              onTap: _showPaywall,
            )
          : ExpansionTile(
        onExpansionChanged: (expanded) {
          if (expanded) _checkProactivePaywall();
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNiveauColor(ex['niveau']).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.fitness_center, color: _getNiveauColor(ex['niveau'])),
        ),
        title: Text(
          ex['titre'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getNiveauColor(ex['niveau']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ex['niveau'],
                  style: TextStyle(
                    fontSize: 10,
                    color: _getNiveauColor(ex['niveau']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ex['domaine'],
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        children: [
          // Énoncé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Énoncé',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                LatexText(data: ex['enonce']),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Indication
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Indication',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LatexText(data: ex['indication']),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Solution (cachée par défaut)
          _buildSolutionSection(ex, isDark),

          // Tags
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (ex['tags'] as List).map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tag, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionSection(Map<String, dynamic> ex, bool isDark) {
    return StatefulBuilder(
      builder: (context, setSolutionState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Solution'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: (ex['solution'] as List).asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.green.withValues(alpha: 0.1),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(fontSize: 10, color: Colors.green),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LatexText(data: entry.value),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    actions: [
          const GlobalSearchButton(),
          
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Voir la solution'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
