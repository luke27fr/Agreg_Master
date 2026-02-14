import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final json = await rootBundle.loadString('assets/data/lecons.json');
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
    if (_searchQuery.isEmpty) return lecons;
    return lecons.where((l) {
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
          tabs: const [
            Tab(text: 'Algèbre'),
            Tab(text: 'Analyse'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barre de recherche
                Padding(
                  padding: const EdgeInsets.all(16),
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
                // Liste des leçons
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLeconsList(_data?['algebre'] ?? [], isDark),
                      _buildLeconsList(_data?['analyse'] ?? [], isDark),
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
    final index = _data!['algebre'].indexOf(lecon) != -1 
        ? _data!['algebre'].indexOf(lecon) 
        : _data!['analyse'].indexOf(lecon);
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
      MaterialPageRoute(builder: (_) => const PaywallPage()),
    );
    if (result == true && mounted) {
      setState(() {}); // Rafraîchir après abonnement
    }
  }
}
