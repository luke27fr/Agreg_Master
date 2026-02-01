import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

import '../models/quiz_model.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;

  const QuizPage({super.key, required this.title, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  bool isAnswered = false;
  int? selectedOption;

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

  void _checkAnswer(int index) {
    if (isAnswered) return;
    setState(() {
      selectedOption = index;
      isAnswered = true;
    });
  }

  void _nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        selectedOption = null;
      });
    } else {
      Navigator.pop(context);
    }
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
                child: InkWell(
                  onTap: () => _checkAnswer(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: borderColor,
                        width: isAnswered && (index == question.correctIndex || index == selectedOption) ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildMarkdown(question.options[index]),
                  ),
                ),
              );
            }),
            if (isAnswered) ...[
              const SizedBox(height: 10),
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
