import 'package:flutter/material.dart';
import 'dart:async';
import '../services/examen_blanc_service.dart';
import '../models/examen_blanc_model.dart';

import '../widgets/global_search_button.dart';

class ExamenBlancPage extends StatefulWidget {
  const ExamenBlancPage({super.key});

  @override
  State<ExamenBlancPage> createState() => _ExamenBlancPageState();
}

class _ExamenBlancPageState extends State<ExamenBlancPage> with SingleTickerProviderStateMixin {
  final ExamenBlancService _service = ExamenBlancService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _service.addListener(_onDataChanged);
    _service.loadExamens();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _service.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = _service.getStatistics();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Examens Blancs', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sujets', icon: Icon(Icons.assignment)),
            Tab(text: 'Résultats', icon: Icon(Icons.assessment)),
            Tab(text: 'Statistiques', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSujetsTab(isDark),
          _buildResultsTab(isDark),
          _buildStatsTab(stats, isDark),
        ],
      ),
    );
  }

  Widget _buildSujetsTab(bool isDark) {
    final examens = _service.examens;

    if (examens.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: examens.length,
      itemBuilder: (context, index) {
        final examen = examens[index];
        return _buildExamenCard(examen, isDark);
      },
    );
  }

  Widget _buildExamenCard(ExamenBlanc examen, bool isDark) {
    final icon = _getExamenIcon(examen.type);
    final color = _getExamenColor(examen.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examen.titre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${examen.dureeMinutes} minutes',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.assignment, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${examen.exercices.length} exercices',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Exercices
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: examen.exercices.length,
            itemBuilder: (context, index) {
              final exercice = examen.exercices[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  exercice.titre,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${exercice.questions.length} questions • ${exercice.bareme} points',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),

          // Bouton commencer
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _startExamen(examen),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Commencer l\'examen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab(bool isDark) {
    final results = _service.results;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aucun examen passé',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Commencez un examen blanc pour voir vos résultats',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _buildResultCard(results[index], isDark);
      },
    );
  }

  Widget _buildResultCard(ExamenBlancResult result, bool isDark) {
    final noteColor = result.note >= 14 ? Colors.green :
                     result.note >= 12 ? Colors.blue :
                     result.note >= 10 ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.examenTitre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(result.datePassage),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: noteColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: noteColor),
                ),
                child: Column(
                  children: [
                    Text(
                      '${result.note.toStringAsFixed(1)}/20',
                      style: TextStyle(
                        color: noteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      result.mention,
                      style: TextStyle(
                        color: noteColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(
                Icons.timer,
                '${result.dureeEffective} min',
                'Durée',
                Colors.blue,
              ),
              _buildStatChip(
                result.termine ? Icons.check_circle : Icons.cancel,
                result.termine ? 'Terminé' : 'Interrompu',
                'Statut',
                result.termine ? Colors.green : Colors.orange,
              ),
              _buildStatChip(
                Icons.percent,
                '${(result.scoreTotal / result.baremeTotal * 100).round()}%',
                'Score',
                noteColor,
              ),
            ],
          ),

          if (result.notesEtudiant != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Notes personnelles :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              result.notesEtudiant!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsTab(ExamenBlancStatistics stats, bool isDark) {
    if (stats.totalExamens == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Pas encore de statistiques',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vue d'ensemble
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCircle(
                  '${stats.examensTermines}',
                  'Terminés',
                  Icons.check_circle,
                ),
                _buildStatCircle(
                  stats.noteMoyenne.toStringAsFixed(1),
                  'Moyenne',
                  Icons.grade,
                ),
                _buildStatCircle(
                  '${(stats.tempsMoyen / 60).toStringAsFixed(1)}h',
                  'Temps moyen',
                  Icons.timer,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Répartition des notes
          const Text(
            'Répartition des notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...stats.repartitionNotes.entries.map((entry) {
            final count = entry.value;
            if (count == 0) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: count / stats.examensTermines,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          _getNoteColor(entry.key),
                        ),
                        minHeight: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$count',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Meilleurs résultats
          if (stats.meilleurs.isNotEmpty) ...[
            const Text(
              'Meilleurs résultats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...stats.meilleurs.take(3).map((result) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events, color: Colors.amber),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.examenTitre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            _formatDate(result.datePassage),
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${result.note.toStringAsFixed(1)}/20',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCircle(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ],
    );
  }

  void _startExamen(ExamenBlanc examen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamenRunningPage(examen: examen),
      ),
    );
  }

  IconData _getExamenIcon(String type) {
    switch (type) {
      case 'composition_algebre': return Icons.functions;
      case 'composition_analyse': return Icons.show_chart;
      case 'probleme': return Icons.psychology;
      case 'modelisation': return Icons.computer;
      default: return Icons.assignment;
    }
  }

  Color _getExamenColor(String type) {
    switch (type) {
      case 'composition_algebre': return const Color(0xFF3F51B5);
      case 'composition_analyse': return const Color(0xFFE91E63);
      case 'probleme': return const Color(0xFF009688);
      case 'modelisation': return const Color(0xFFFF9800);
      default: return Colors.grey;
    }
  }

  Color _getNoteColor(String tranche) {
    if (tranche == '16-20') return Colors.green;
    if (tranche == '14-16') return Colors.blue;
    if (tranche == '12-14') return Colors.lightBlue;
    if (tranche == '10-12') return Colors.orange;
    if (tranche == '5-10') return Colors.deepOrange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Page pour passer un examen
class ExamenRunningPage extends StatefulWidget {
  final ExamenBlanc examen;

  const ExamenRunningPage({super.key, required this.examen});

  @override
  State<ExamenRunningPage> createState() => _ExamenRunningPageState();
}

class _ExamenRunningPageState extends State<ExamenRunningPage> {
  Timer? _timer;
  int _remainingSeconds = 0;
  DateTime? _startTime;
  final Map<int, double> _scores = {};
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.examen.dureeMinutes * 60;
    _startTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _endExamen(completed: true);
        }
      });
    });
  }

  void _endExamen({bool completed = false}) {
    _timer?.cancel();

    final duree = DateTime.now().difference(_startTime!).inMinutes;
    final scoreTotal = _scores.values.fold(0.0, (a, b) => a + b);

    final result = ExamenBlancResult(
      examenId: widget.examen.id,
      examenTitre: widget.examen.titre,
      datePassage: DateTime.now(),
      dureeEffective: duree,
      termine: completed,
      scoresExercices: _scores,
      scoreTotal: scoreTotal,
      baremeTotal: widget.examen.baremeTotal.toDouble(),
      notesEtudiant: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    ExamenBlancService().saveResult(result);

    if (mounted) {
      Navigator.pop(context);
      _showResultDialog(result);
    }
  }

  void _showResultDialog(ExamenBlancResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.note >= 10 ? Icons.celebration : Icons.info,
              color: result.note >= 10 ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            const Text('Examen terminé'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${result.note.toStringAsFixed(1)}/20',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: result.note >= 14 ? Colors.green :
                       result.note >= 10 ? Colors.orange : Colors.red,
              ),
            ),
            Text(
              result.mention,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Durée: ${result.dureeEffective} minutes'),
            Text('Score: ${result.scoreTotal.toStringAsFixed(1)}/${result.baremeTotal}'),
          ],
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
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimeColor() {
    final ratio = _remainingSeconds / (widget.examen.dureeMinutes * 60);
    if (ratio < 0.1) return Colors.red;
    if (ratio < 0.25) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(),
        ),
        title: Text(
          widget.examen.titre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Timer
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: _getTimeColor(), size: 28),
                const SizedBox(width: 12),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: _getTimeColor(),
                  ),
                ),
              ],
            ),
          ),

          // Exercices
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.examen.exercices.length,
              itemBuilder: (context, index) {
                final exercice = widget.examen.exercices[index];
                return _buildExerciceCard(index, exercice, isDark);
              },
            ),
          ),

          // Notes personnelles
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes personnelles',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Difficultés rencontrées, points à revoir...',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),

          // Bouton terminer
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showEndConfirmation(),
                icon: const Icon(Icons.check),
                label: const Text('Terminer l\'examen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciceCard(int index, ExerciceExamen exercice, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A237E),
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          exercice.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${exercice.bareme} points • ${exercice.questions.length} questions'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...exercice.questions.asMap().entries.map((entry) {
                  final qIndex = entry.key;
                  final question = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${question.points} pts',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Question ${qIndex + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(question.enonce),
                        if (question.indication != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    question.indication!,
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (question.correction != null) ...[
                          const SizedBox(height: 8),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                const Icon(Icons.school, size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text(
                                  'Voir la correction',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  question.correction!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.hourglass_empty, size: 16, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Correction bientôt disponible • En attendant, essayez de résoudre seul${question.indication != null ? ' avec l\'indication ci-dessus' : ''} !',
                                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.orange.shade800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Auto-évaluation : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Slider(
                        value: _scores[index] ?? 0,
                        min: 0,
                        max: exercice.bareme.toDouble(),
                        divisions: exercice.bareme * 2,
                        label: '${_scores[index]?.toStringAsFixed(1) ?? 0}/${exercice.bareme}',
                        onChanged: (value) {
                          setState(() {
                            _scores[index] = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      '${_scores[index]?.toStringAsFixed(1) ?? 0}/${exercice.bareme}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter l\'examen ?'),
        content: const Text('Votre progression sera sauvegardée mais l\'examen sera marqué comme incomplet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _endExamen(completed: false);
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEndConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rendre votre copie ?'),
        content: const Text('Êtes-vous sûr de vouloir terminer l\'examen ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _endExamen(completed: true);
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }
}
