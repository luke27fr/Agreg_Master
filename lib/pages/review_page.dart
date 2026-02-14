import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/score_service.dart';
import '../models/quiz_model.dart';
import 'quiz_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ScoreService _scoreService = ScoreService();
  Map<String, dynamic>? _quizData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
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

  Future<void> _loadQuizData() async {
    try {
      final json = await rootBundle.loadString('assets/data/quiz.json');
      if (mounted) {
        setState(() {
          _quizData = jsonDecode(json);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startReviewQuiz(List<String> ficheIds) async {
    if (_quizData == null) return;

    List<QuizQuestion> questions = [];
    for (var ficheId in ficheIds) {
      if (_quizData!.containsKey(ficheId)) {
        for (var q in _quizData![ficheId]) {
          questions.add(QuizQuestion.fromJson(q));
        }
      }
    }

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas de questions disponibles')),
      );
      return;
    }

    questions.shuffle();
    if (questions.length > 20) {
      questions = questions.sublist(0, 20);
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            title: 'Révision Intelligente',
            questions: questions,
          ),
        ),
      );
    }
  }

  Future<void> _startWrongAnswersQuiz() async {
    if (_quizData == null) return;

    final wrongQuestions = _scoreService.getRecentWrongQuestions();
    if (wrongQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas de questions ratées récemment !')),
      );
      return;
    }

    List<QuizQuestion> questions = [];
    wrongQuestions.forEach((ficheId, indices) {
      if (_quizData!.containsKey(ficheId)) {
        final ficheQuestions = _quizData![ficheId] as List;
        for (var i in indices) {
          if (i < ficheQuestions.length) {
            questions.add(QuizQuestion.fromJson(ficheQuestions[i]));
          }
        }
      }
    });

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas de questions disponibles')),
      );
      return;
    }

    questions.shuffle();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            title: 'Revoir mes erreurs',
            questions: questions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fichesToReview = _scoreService.getFichesToReview();
    final wrongQuestions = _scoreService.getRecentWrongQuestions();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Révision', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte principale - Révision intelligente
                  _buildSmartReviewCard(fichesToReview, isDark),
                  
                  const SizedBox(height: 16),
                  
                  // Revoir les erreurs
                  _buildWrongAnswersCard(wrongQuestions, isDark),
                  
                  const SizedBox(height: 24),
                  
                  // Liste des fiches à réviser
                  if (fichesToReview.isNotEmpty) ...[
                    const Text(
                      'Fiches prioritaires',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...fichesToReview.take(10).map((entry) => _buildFicheCard(entry, isDark)),
                  ],
                  
                  // Si aucune fiche à réviser
                  if (fichesToReview.isEmpty && wrongQuestions.isEmpty)
                    _buildEmptyState(isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildSmartReviewCard(List<MapEntry<String, QuizScore>> fichesToReview, bool isDark) {
    final lowScoreCount = fichesToReview.where((e) => e.value.percentage < 60).length;
    final oldCount = fichesToReview.where((e) {
      final days = DateTime.now().difference(e.value.date).inDays;
      return days >= 7 && e.value.percentage >= 60;
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: fichesToReview.isEmpty
              ? [Colors.green, Colors.green.shade700]
              : [const Color(0xFFFF9800), const Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                fichesToReview.isEmpty ? Icons.check_circle : Icons.psychology,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              const Text(
                'Révision Intelligente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fichesToReview.isEmpty
                ? 'Toutes vos fiches sont à jour ! 🎉'
                : '${fichesToReview.length} fiche(s) à réviser',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (fichesToReview.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '• $lowScoreCount avec score < 60%\n• $oldCount non révisées depuis 7+ jours',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startReviewQuiz(fichesToReview.map((e) => e.key).toList()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Commencer la révision',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWrongAnswersCard(Map<String, List<int>> wrongQuestions, bool isDark) {
    final totalWrong = wrongQuestions.values.fold(0, (sum, list) => sum + list.length);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.red, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Revoir mes erreurs',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  totalWrong > 0 
                      ? '$totalWrong question(s) ratée(s)'
                      : 'Aucune erreur récente',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          if (totalWrong > 0)
            ElevatedButton(
              onPressed: _startWrongAnswersQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Réviser'),
            ),
        ],
      ),
    );
  }

  Widget _buildFicheCard(MapEntry<String, QuizScore> entry, bool isDark) {
    final daysSince = DateTime.now().difference(entry.value.date).inDays;
    final isLowScore = entry.value.percentage < 60;
    final isOld = daysSince >= 7;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getScoreColor(entry.value.percentage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${entry.value.percentage.round()}%',
                style: TextStyle(
                  color: _getScoreColor(entry.value.percentage),
                  fontWeight: FontWeight.bold,
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
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (isLowScore)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Score faible',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                      ),
                    if (isLowScore && isOld) const SizedBox(width: 6),
                    if (isOld)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Il y a $daysSince jours',
                          style: const TextStyle(color: Colors.orange, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Color(0xFF1A237E)),
            onPressed: () => _startReviewQuiz([entry.key]),
            tooltip: 'Quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.emoji_events, size: 80, color: Colors.amber[400]),
          const SizedBox(height: 16),
          const Text(
            'Tout est à jour !',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Continuez à faire des quiz pour maintenir vos connaissances.',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}
