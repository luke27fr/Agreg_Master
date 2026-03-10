import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/content_loader.dart';
import '../widgets/latex_text.dart';
import '../widgets/global_search_button.dart';
import '../services/subscription_service.dart';
import 'paywall_page.dart';
import 'jury_virtuel_page.dart';

class LeconsPage extends StatefulWidget {
  const LeconsPage({super.key});

  @override
  State<LeconsPage> createState() => _LeconsPageState();
}

class _LeconsPageState extends State<LeconsPage> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _data;
  bool _loading = true;
  late TabController _tabController;
  String _searchQuery = '';
  String _filterTag = 'Toutes';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final json = await ContentLoader.loadString('assets/data/lecons.json');
      setState(() {
        _data = jsonDecode(json);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement leçons: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _filterLecons(List<dynamic> lecons) {
    return lecons.where((l) {
      final matchTag = _filterTag == 'Toutes' ||
          (l['tags'] as List<dynamic>?)?.contains(_filterTag.toLowerCase()) == true;
      if (!matchTag) return false;
      if (_searchQuery.isEmpty) return true;
      final titre = (l['titre'] as String).toLowerCase();
      final numero = l['numero'].toString();
      return titre.contains(_searchQuery.toLowerCase()) || numero.contains(_searchQuery);
    }).toList();
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
        title: const Text('Leçons d\'oral', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Algèbre'),
            Tab(text: 'Analyse'),
            Tab(text: 'Probabilités'),
            Tab(text: 'Géométrie'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher une leçon (numéro ou titre)...',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ['Toutes', 'Externe', 'Interne'].map((tag) {
                      final selected = _filterTag == tag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: selected,
                          onSelected: (_) => setState(() => _filterTag = tag),
                          selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : isDark ? Colors.grey[400] : Colors.grey[700],
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Liste des leçons
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLeconsList(_data?['algebre'] ?? [], isDark),
                      _buildLeconsList(_data?['analyse'] ?? [], isDark),
                      _buildLeconsList(_data?['probabilites'] ?? [], isDark),
                      _buildLeconsList(_data?['geometrie'] ?? [], isDark),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLeconsList(List<dynamic> lecons, bool isDark) {
    final filtered = _filterLecons(lecons);
    
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Aucune leçon trouvée',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final lecon = filtered[index];
        return _buildLeconCard(lecon, isDark);
      },
    );
  }

  Widget _buildLeconCard(Map<String, dynamic> lecon, bool isDark) {
    final subscriptionService = SubscriptionService();
    int index = -1;
    for (final cat in ['algebre', 'analyse', 'probabilites', 'geometrie']) {
      final list = _data?[cat] as List<dynamic>?;
      if (list != null) {
        final i = list.indexOf(lecon);
        if (i != -1) { index = i; break; }
      }
    }
    final isLocked = !subscriptionService.isPremium && 
                     index >= subscriptionService.getFreeAccessCount('lecons');

    final devCount = (lecon['developpements'] as List?)?.length ?? 0;
    final themesCount = (lecon['theoremes_cles'] as List?)?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: () => isLocked
            ? _showPaywall()
            : _openLeconDetail(lecon),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${lecon['numero']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LatexText(
                      data: lecon['titre'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$devCount développements • $themesCount théorèmes',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              isLocked
                  ? const Icon(Icons.lock, size: 20, color: Colors.amber)
                  : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _openLeconDetail(Map<String, dynamic> lecon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LeconReferencePage(
          leconNumero: lecon['numero'].toString(),
          leconData: lecon,
        ),
      ),
    );
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'lecons')),
    );
    if (result == true && mounted) {
      setState(() {}); // Rafraîchir après abonnement
    }
  }
}
