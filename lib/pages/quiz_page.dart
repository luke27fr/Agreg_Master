import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

import '../models/quiz_model.dart';
import '../services/score_service.dart';
import '../services/settings_service.dart';
import '../services/streak_service.dart';
import '../services/badge_service.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  final String? ficheId; // ID de la fiche pour sauvegarder le score

  const QuizPage({
    super.key,
    required this.title,
    required this.questions,
    this.ficheId,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  bool isAnswered = false;
  int? selectedOption;
  int score = 0;
  List<int> wrongIndices = []; // Track des questions ratées
  
  // Timer
  final SettingsService _settingsService = SettingsService();
  Timer? _timer;
  int _timeLeft = 0;
  bool _timerExpired = false;

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

  @override
  void initState() {
    super.initState();
    _startTimerIfEnabled();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerIfEnabled() {
    if (_settingsService.quizTimerEnabled && !isAnswered) {
      _timeLeft = _settingsService.quizTimerSeconds;
      _timerExpired = false;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          setState(() => _timeLeft--);
        } else {
          timer.cancel();
          _onTimerExpired();
        }
      });
    }
  }

  void _onTimerExpired() {
    if (!isAnswered) {
      setState(() {
        _timerExpired = true;
        isAnswered = true;
        wrongIndices.add(currentIndex);
      });
    }
  }

  void _checkAnswer(int index) {
    if (isAnswered) return;
    _timer?.cancel();
    final question = widget.questions[currentIndex];
    setState(() {
      selectedOption = index;
      isAnswered = true;
      _timerExpired = false;
      if (index == question.correctIndex) {
        score++;
      } else {
        wrongIndices.add(currentIndex); // Enregistrer l'erreur
      }
    });
  }

  void _nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        selectedOption = null;
        _timerExpired = false;
      });
      _startTimerIfEnabled();
    } else {
      _timer?.cancel();
      _showScoreDialog();
    }
  }

  void _showScoreDialog() async {
    final total = widget.questions.length;
    final percentage = (score / total * 100).round();
    
    // Sauvegarder le score si on a un ficheId
    if (widget.ficheId != null) {
      await ScoreService().saveScore(widget.ficheId!, score, total, wrongIndices: wrongIndices);
    }
    
    // Enregistrer l'activité pour les streaks
    await StreakService().recordActivity('quiz');
    
    // Vérifier les badges
    await BadgeService().checkAndUnlockBadges();
    
    String message;
    IconData icon;
    Color color;
    
    if (percentage >= 80) {
      message = "Excellent ! 🎉";
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (percentage >= 60) {
      message = "Bien joué ! 👍";
      icon = Icons.thumb_up;
      color = Colors.green;
    } else if (percentage >= 40) {
      message = "Peut mieux faire 📚";
      icon = Icons.menu_book;
      color = Colors.orange;
    } else {
      message = "À revoir ! 💪";
      icon = Icons.refresh;
      color = Colors.red;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            const Text("Résultat du Quiz"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              "$score / $total",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              "Fermer",
              style: TextStyle(fontSize: 16, color: Color(0xFF1A237E)),
            ),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _buildTheme(BuildContext context) {
    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  Widget _buildMarkdown(String data) {
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: _buildTheme(context),
      extensionSet: _latexExtensionSet,
      builders: {'latex': LatexElementBuilder()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz — ${widget.title}'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          // Timer si activé
          if (_settingsService.quizTimerEnabled && !isAnswered)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _timeLeft <= 5 ? Colors.red : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: _timeLeft <= 5 ? Colors.white : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_timeLeft}s',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _timeLeft <= 5 ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Score: $score/${currentIndex + (isAnswered ? 1 : 0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.questions.length,
              color: const Color(0xFF1A237E),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: _buildMarkdown("### Question ${currentIndex + 1}\n\n${question.question}"),
              ),
            ),
            ...List.generate(question.options.length, (index) {
              Color color = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (isAnswered) {
                if (index == question.correctIndex) {
                  color = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (index == selectedOption) {
                  color = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _checkAnswer(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: borderColor,
                        width: isAnswered && (index == question.correctIndex || index == selectedOption) ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !isAnswered ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isAnswered && index == question.correctIndex
                                  ? Colors.green
                                  : isAnswered && index == selectedOption
                                      ? Colors.red
                                      : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: isAnswered && index == question.correctIndex
                                ? Colors.green
                                : isAnswered && index == selectedOption
                                    ? Colors.red
                                    : Colors.transparent,
                          ),
                          child: isAnswered && (index == question.correctIndex || index == selectedOption)
                              ? Icon(
                                  index == question.correctIndex ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IgnorePointer(
                            child: MarkdownBody(
                              data: question.options[index],
                              selectable: false,
                              styleSheet: _buildTheme(context),
                              extensionSet: _latexExtensionSet,
                              builders: {'latex': LatexElementBuilder()},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (isAnswered) ...[
              const SizedBox(height: 10),
              // Message temps écoulé
              if (_timerExpired)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timer_off, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "Temps écoulé !",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Explication :",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                    ),
                    const SizedBox(height: 5),
                    _buildMarkdown(question.explanation),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  currentIndex < widget.questions.length - 1 ? 'Question suivante' : 'Terminer',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
