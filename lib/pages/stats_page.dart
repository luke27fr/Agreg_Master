import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/score_service.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final ScoreService _scoreService = ScoreService();
  Map<String, dynamic>? _manifest;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final json = await rootBundle.loadString('assets/fiches/manifest.json');
      if (mounted) {
        setState(() {
          _manifest = jsonDecode(json);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scores = _scoreService.scores;
    final history = _scoreService.history;
    final globalAvg = _scoreService.getGlobalAverage();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Statistiques', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte résumé global
                  _buildGlobalCard(globalAvg, scores.length, history.length, isDark),
                  
                  const SizedBox(height: 24),
                  
                  // Stats par matière
                  const Text(
                    'Par matière',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildThemeStats(isDark),
                  
                  const SizedBox(height: 24),
                  
                  // Historique récent
                  const Text(
                    'Historique récent',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildHistoryList(history.take(10).toList(), isDark),
                  
                  const SizedBox(height: 24),
                  
                  // Points forts / faibles
                  const Text(
                    'Analyse',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildAnalysisCards(isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildGlobalCard(double globalAvg, int fichesCount, int quizCount, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Score Global',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            globalAvg >= 0 ? '${globalAvg.round()}%' : '--',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(Icons.library_books, '$fichesCount', 'Fiches testées'),
              _buildStatItem(Icons.quiz, '$quizCount', 'Quiz passés'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  List<Widget> _buildThemeStats(bool isDark) {
    if (_manifest == null) return [];
    
    final themes = _manifest!['themes'] as List<dynamic>;
    final widgets = <Widget>[];
    
    for (var theme in themes) {
      final files = (theme['files'] as List<dynamic>).cast<String>();
      final avg = _scoreService.getAverageForFiches(files);
      final completed = _scoreService.getCompletedCount(files);
      
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getThemeColor(theme['id']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getThemeIcon(theme['id']),
                  color: _getThemeColor(theme['id']),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme['label'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completed/${files.length} fiches',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: avg >= 0 ? avg / 100 : 0,
                        backgroundColor: Colors.grey[300],
                        color: _getScoreColor(avg),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                avg >= 0 ? '${avg.round()}%' : '--',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: avg >= 0 ? _getScoreColor(avg) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildHistoryList(List<QuizHistoryEntry> history, bool isDark) {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Aucun quiz effectué',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Column(
      children: history.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getScoreColor(entry.percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${entry.percentage.round()}%',
                    style: TextStyle(
                      color: _getScoreColor(entry.percentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.ficheId,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${entry.score}/${entry.total} • ${_formatDate(entry.date)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (entry.wrongQuestionIndices.isNotEmpty)
                Tooltip(
                  message: '${entry.wrongQuestionIndices.length} erreur(s)',
                  child: Icon(Icons.error_outline, color: Colors.orange[400], size: 20),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalysisCards(bool isDark) {
    final scores = _scoreService.scores;
    
    if (scores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Pas assez de données pour l\'analyse',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    // Points forts (>= 80%)
    final strongPoints = scores.entries
        .where((e) => e.value.percentage >= 80)
        .toList()
      ..sort((a, b) => b.value.percentage.compareTo(a.value.percentage));

    // Points faibles (< 60%)
    final weakPoints = scores.entries
        .where((e) => e.value.percentage < 60)
        .toList()
      ..sort((a, b) => a.value.percentage.compareTo(b.value.percentage));

    return Column(
      children: [
        // Points forts
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Points forts (${strongPoints.length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (strongPoints.isEmpty)
                Text('Continuez à vous améliorer !', style: TextStyle(color: Colors.grey[600]))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: strongPoints.take(5).map((e) => Chip(
                    label: Text(e.key, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green.withOpacity(0.2),
                    side: BorderSide.none,
                  )).toList(),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Points faibles
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'À réviser (${weakPoints.length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (weakPoints.isEmpty)
                Text('Excellent, aucun point faible !', style: TextStyle(color: Colors.grey[600]))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: weakPoints.take(5).map((e) => Chip(
                    label: Text(e.key, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.red.withOpacity(0.2),
                    side: BorderSide.none,
                  )).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getThemeColor(String id) {
    if (id.contains('algebre')) return const Color(0xFF3F51B5);
    if (id.contains('analyse')) return const Color(0xFFE91E63);
    if (id.contains('proba')) return const Color(0xFF009688);
    if (id.contains('geo')) return const Color(0xFFFF9800);
    return const Color(0xFF607D8B);
  }

  IconData _getThemeIcon(String id) {
    if (id.contains('algebre')) return Icons.functions;
    if (id.contains('analyse')) return Icons.show_chart;
    if (id.contains('proba')) return Icons.casino;
    if (id.contains('geo')) return Icons.architecture;
    return Icons.book;
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    if (percentage >= 0) return Colors.red;
    return Colors.grey;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} jours';
    return '${date.day}/${date.month}/${date.year}';
  }
}
