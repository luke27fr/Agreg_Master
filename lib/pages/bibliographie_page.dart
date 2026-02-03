import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/global_search_button.dart';

class BibliographiePage extends StatefulWidget {
  const BibliographiePage({super.key});

  @override
  State<BibliographiePage> createState() => _BibliographiePageState();
}

class _BibliographiePageState extends State<BibliographiePage> {
  List<dynamic> _livres = [];
  List<dynamic> _ressourcesEnLigne = [];
  bool _loading = true;
  String _filterDomaine = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final json = await rootBundle.loadString('assets/data/bibliographie.json');
      final data = jsonDecode(json);
      setState(() {
        _livres = data['livres'] ?? [];
        _ressourcesEnLigne = data['ressources_en_ligne'] ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement bibliographie: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFilteredLivres() {
    if (_filterDomaine == 'Tous') return _livres;
    return _livres.where((l) => l['domaine'] == _filterDomaine).toList();
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
        title: const Text('Bibliographie', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtres
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Tous', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Algèbre', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Analyse', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Probabilités', isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('Géométrie', isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Livres
                  const Text(
                    'Livres recommandés',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._getFilteredLivres().map((livre) => _buildLivreCard(livre, isDark)),

                  const SizedBox(height: 24),

                  // Ressources en ligne
                  const Text(
                    'Ressources en ligne',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._ressourcesEnLigne.map((res) => _buildRessourceCard(res, isDark)),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _filterDomaine == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _filterDomaine = label),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildLivreCard(Map<String, dynamic> livre, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getDomaineColor(livre['domaine']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.book, color: Color(0xFF1A237E)),
        ),
        title: Text(
          livre['titre'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          livre['auteur'],
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        children: [
          Text(
            livre['description'],
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDomaineColor(livre['domaine']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  livre['domaine'],
                  style: TextStyle(
                    color: _getDomaineColor(livre['domaine']),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  livre['editeur'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Leçons couvertes : ${(livre['lecons'] as List).join(', ')}',
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRessourceCard(Map<String, dynamic> res, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.language, color: Colors.blue),
        ),
        title: Text(res['titre'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(res['description'], style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => _launchUrl(res['url']),
      ),
    );
  }

  Color _getDomaineColor(String domaine) {
    switch (domaine) {
      case 'Algèbre':
        return Colors.blue;
      case 'Analyse':
        return Colors.pink;
      case 'Probabilités':
        return Colors.teal;
      case 'Géométrie':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir $url')),
        );
      }
    }
  }
}
