import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import '../widgets/global_search_button.dart';
import '../services/subscription_service.dart';
import 'paywall_page.dart';

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

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: () => isLocked ? _showPaywall() : _showLeconDetails(context, lecon),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
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
                    MarkdownBody(
                      data: lecon['titre'],
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      extensionSet: _latexExtensionSet,
                      builders: {'latex': LatexElementBuilder()},
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(lecon['developpements'] as List).length} développements',
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

  void _showLeconDetails(BuildContext context, Map<String, dynamic> lecon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Leçon ${lecon['numero']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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
                data: lecon['titre'],
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                extensionSet: _latexExtensionSet,
                builders: {'latex': LatexElementBuilder()},
              ),
              
              const SizedBox(height: 24),
              
              // Points clés
              const Text(
                'Points clés à aborder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...((lecon['points_cles'] as List).map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
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
              ))),
              
              const SizedBox(height: 24),
              
              // Développements
              const Text(
                'Développements compatibles',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (lecon['developpements'] as List).map((dev) => Chip(
                  label: Text(dev.toString().replaceAll('_', ' ')),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                )).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Prérequis
              if (lecon['prerequis'] != null) ...[
                const Text(
                  'Prérequis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (lecon['prerequis'] as List).map((req) => Chip(
                    label: Text(req.toString().replaceAll('_', ' ')),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                  )).toList(),
                ),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
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
