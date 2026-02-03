import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestionsJuryPage extends StatefulWidget {
  const QuestionsJuryPage({super.key});

  @override
  State<QuestionsJuryPage> createState() => _QuestionsJuryPageState();
}

class _QuestionsJuryPageState extends State<QuestionsJuryPage> {
  List<dynamic> _questionsData = [];
  Map<int, String> _leconTitles = {};
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Charger les questions
      final questionsJson = await rootBundle.loadString('assets/data/questions_jury.json');
      final questionsData = jsonDecode(questionsJson);
      
      // Charger les leçons pour avoir les titres
      final leconsJson = await rootBundle.loadString('assets/data/lecons.json');
      final leconsData = jsonDecode(leconsJson);
      
      final Map<int, String> titles = {};
      for (var lecon in [...(leconsData['algebre'] ?? []), ...(leconsData['analyse'] ?? [])]) {
        titles[lecon['numero']] = lecon['titre'];
      }

      setState(() {
        _questionsData = questionsData['questions'] ?? [];
        _leconTitles = titles;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement questions: $e');
      setState(() => _loading = false);
    }
  }

  List<dynamic> _getFiltered() {
    if (_searchQuery.isEmpty) return _questionsData;
    
    return _questionsData.where((item) {
      final lecon = item['lecon'].toString();
      final titre = _leconTitles[item['lecon']]?.toLowerCase() ?? '';
      final questions = (item['questions'] as List).join(' ').toLowerCase();
      
      return lecon.contains(_searchQuery) || 
             titre.contains(_searchQuery.toLowerCase()) ||
             questions.contains(_searchQuery.toLowerCase());
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
        title: const Text('Questions de jury', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Questions fréquemment posées par les jurys d\'agrégation.',
                          style: TextStyle(color: Colors.orange),
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
                      hintText: 'Rechercher par numéro ou mot-clé...',
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

                // Liste
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildLeconQuestions(filtered[index], isDark);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLeconQuestions(Map<String, dynamic> item, bool isDark) {
    final leconNum = item['lecon'] as int;
    final titre = _leconTitles[leconNum] ?? 'Leçon $leconNum';
    final questions = item['questions'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$leconNum',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
        ),
        title: Text(
          'Leçon $leconNum',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          titre,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          ...questions.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
