import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

import '../widgets/global_search_button.dart';

class ContreExemplesPage extends StatefulWidget {
  const ContreExemplesPage({super.key});

  @override
  State<ContreExemplesPage> createState() => _ContreExemplesPageState();
}

class _ContreExemplesPageState extends State<ContreExemplesPage> {
  List<dynamic> _contreExemples = [];
  bool _loading = true;
  String _searchQuery = '';

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
      final json = await rootBundle.loadString('assets/data/contre_exemples.json');
      final data = jsonDecode(json);
      setState(() {
        _contreExemples = data['contre_exemples'] ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement contre-exemples: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFiltered() {
    if (_searchQuery.isEmpty) return _contreExemples;
    return _contreExemples.where((ce) {
      final titre = (ce['titre'] as String).toLowerCase();
      final tags = (ce['tags'] as List).join(' ').toLowerCase();
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
        title: const Text('Contre-exemples', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildContreExempleCard(filtered[index], isDark);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildContreExempleCard(Map<String, dynamic> ce, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.warning_amber, color: Colors.red),
        ),
        title: Text(
          ce['titre'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 4,
            children: (ce['tags'] as List).map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(tag, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            )).toList(),
          ),
        ),
        children: [
          // Énoncé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exemple',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                MarkdownBody(
                  data: ce['enonce'],
                  extensionSet: _latexExtensionSet,
                  builders: {'latex': LatexElementBuilder()},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Explication
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explication',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                MarkdownBody(
                  data: ce['explication'],
                  extensionSet: _latexExtensionSet,
                  builders: {'latex': LatexElementBuilder()},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
