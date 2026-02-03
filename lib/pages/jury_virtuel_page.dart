import 'package:flutter/material.dart';
import 'dart:async';
import '../services/jury_virtuel_service.dart';
import '../models/jury_virtuel_model.dart';

class JuryVirtuelPage extends StatefulWidget {
  final String leconId;
  final String leconTitre;

  const JuryVirtuelPage({
    super.key,
    required this.leconId,
    required this.leconTitre,
  });

  @override
  State<JuryVirtuelPage> createState() => _JuryVirtuelPageState();
}

class _JuryVirtuelPageState extends State<JuryVirtuelPage> {
  final JuryVirtuelService _service = JuryVirtuelService();
  late JurySession _session;
  int _currentQuestionIndex = 0;
  Timer? _questionTimer;
  int _questionTimeSeconds = 0;
  bool _showingAnswer = false;

  @override
  void initState() {
    super.initState();
    _session = _service.createSession(widget.leconId, widget.leconTitre);
    _startQuestionTimer();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  void _startQuestionTimer() {
    _questionTimeSeconds = 0;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _questionTimeSeconds++;
      });
    });
  }

  void _nextQuestion(int? evaluation) {
    _questionTimer?.cancel();
    
    // Sauvegarder l'évaluation de la question actuelle
    final currentQA = _session.questionsReponses[_currentQuestionIndex];
    _session.questionsReponses[_currentQuestionIndex] = JuryQuestionAnswer(
      question: currentQA.question,
      heureQuestion: currentQA.heureQuestion,
      tempsReponseSecondes: _questionTimeSeconds,
      autoEvaluation: evaluation,
      notesPersonnelles: currentQA.notesPersonnelles,
    );

    if (_currentQuestionIndex < _session.questionsReponses.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showingAnswer = false;
      });
      _startQuestionTimer();
    } else {
      _endSession();
    }
  }

  void _endSession() {
    _questionTimer?.cancel();
    
    final totalDuree = _session.questionsReponses
        .map((qa) => qa.tempsReponseSecondes)
        .fold(0, (a, b) => a + b);
    
    final completedSession = JurySession(
      id: _session.id,
      leconId: _session.leconId,
      leconTitre: _session.leconTitre,
      dateDebut: _session.dateDebut,
      questionsReponses: _session.questionsReponses,
      dureeMinutes: (totalDuree / 60).ceil(),
      terminee: true,
    );

    _service.saveSession(completedSession);
    _showSummaryDialog(completedSession);
  }

  void _showSummaryDialog(JurySession session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Session terminée'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score de qualité: ${session.scoreQualite.toStringAsFixed(1)}/5',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Durée: ${session.dureeMinutes} minutes'),
            Text('Questions: ${session.questionsReponses.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQA = _session.questionsReponses[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _session.questionsReponses.length;

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
          widget.leconTitre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progression
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${_session.questionsReponses.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_questionTimeSeconds),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF1A237E)),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          // Question actuelle
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(currentQA.question.categorie).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                currentQA.question.categorie.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _getCategoryColor(currentQA.question.categorie),
                                ),
                              ),
                            ),
                            const Spacer(),
                            ...List.generate(5, (index) {
                              return Icon(
                                index < currentQA.question.difficulte ? Icons.star : Icons.star_border,
                                size: 14,
                                color: Colors.amber,
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentQA.question.question,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (currentQA.question.indicePedagogique != null && _showingAnswer) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    currentQA.question.indicePedagogique!,
                                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (currentQA.question.pointsCles != null && _showingAnswer) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Points clés attendus :',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          ...currentQA.question.pointsCles!.map((point) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(point, style: const TextStyle(fontSize: 13))),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Boutons d'action
                  if (!_showingAnswer) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _showingAnswer = true),
                        icon: const Icon(Icons.visibility),
                        label: const Text('Voir les points clés'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Auto-évaluation
                  const Text(
                    'Comment évaluez-vous votre réponse ?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  _buildEvaluationButton(5, '😄 Excellent', 'Réponse complète et précise'),
                  _buildEvaluationButton(4, '😊 Bien', 'Bonnes réponses avec détails'),
                  _buildEvaluationButton(3, '😐 Correct', 'Réponse acceptable'),
                  _buildEvaluationButton(2, '😕 Incomplet', 'Réponse partielle'),
                  _buildEvaluationButton(1, '😫 Mauvais', 'Réponse insuffisante'),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationButton(int score, String label, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _nextQuestion(score),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getScoreColor(score),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    switch (score) {
      case 5: return Colors.green;
      case 4: return Colors.blue;
      case 3: return Colors.orange;
      case 2: return Colors.deepOrange;
      case 1: return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'definition': return Colors.blue;
      case 'exemple': return Colors.green;
      case 'contre-exemple': return Colors.orange;
      case 'lien': return Colors.purple;
      case 'generalisation': return Colors.teal;
      case 'application': return Colors.indigo;
      case 'developpement': return Colors.red;
      case 'calcul': return Colors.cyan;
      default: return Colors.grey;
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter la session ?'),
        content: const Text('Votre progression sera perdue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Page principale du jury virtuel avec historique
class JuryVirtuelMainPage extends StatefulWidget {
  const JuryVirtuelMainPage({super.key});

  @override
  State<JuryVirtuelMainPage> createState() => _JuryVirtuelMainPageState();
}

class _JuryVirtuelMainPageState extends State<JuryVirtuelMainPage> {
  final JuryVirtuelService _service = JuryVirtuelService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onDataChanged);
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
    final stats = _service.getStatistics();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Jury Virtuel', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière explicative
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel, size: 40, color: Colors.white),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Entraînez-vous aux questions du jury',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Simulez les questions typiques posées après une présentation. '
                    'Mesurez votre temps de réponse et évaluez votre maîtrise.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistiques
            if (stats.totalSessions > 0) ...[
              const Text(
                'Vos statistiques',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Sessions', '${stats.totalSessions}', Icons.event),
                    _buildStatItem('Questions', '${stats.totalQuestions}', Icons.question_answer),
                    _buildStatItem('Qualité', '${stats.scoreQualiteMoyen.toStringAsFixed(1)}/5', Icons.grade),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Historique
            if (_service.sessions.isNotEmpty) ...[
              const Text(
                'Historique récent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._service.sessions.take(5).map((session) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.leconTitre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(session.dateDebut),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${session.scoreQualite.toStringAsFixed(1)}/5',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1A237E), size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
