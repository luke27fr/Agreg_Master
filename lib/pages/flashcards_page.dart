import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../utils/content_loader.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> with SingleTickerProviderStateMixin {
  Map<String, String> _glossaire = {};
  List<MapEntry<String, String>> _cards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _loading = true;
  
  // Stats de la session
  int _correct = 0;
  int _incorrect = 0;
  final Set<String> _masteredCards = {};
  final Set<String> _difficultCards = {};

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadGlossaire();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadGlossaire() async {
    try {
      final jsonString = await ContentLoader.loadString('assets/glossaire.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _glossaire = data.map((k, v) => MapEntry(k.toString(), v.toString()));
        _shuffleCards();
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement glossaire: $e');
      setState(() => _loading = false);
    }
  }

  void _shuffleCards() {
    _cards = _glossaire.entries.toList()..shuffle(Random());
    _currentIndex = 0;
    _showAnswer = false;
  }

  void _flipCard() {
    if (_showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showAnswer = !_showAnswer);
  }

  void _markCorrect() {
    _masteredCards.add(_cards[_currentIndex].key);
    _difficultCards.remove(_cards[_currentIndex].key);
    setState(() => _correct++);
    _nextCard();
  }

  void _markIncorrect() {
    _difficultCards.add(_cards[_currentIndex].key);
    setState(() => _incorrect++);
    _nextCard();
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      _flipController.reset();
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      _flipController.reset();
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _showCompletionDialog() {
    final total = _correct + _incorrect;
    final percentage = total > 0 ? (_correct / total * 100).round() : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              percentage >= 80 ? Icons.emoji_events : Icons.school,
              color: percentage >= 80 ? Colors.amber : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 12),
            const Text('Session terminée !'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correct / $total',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text('$percentage% de réussite'),
            const SizedBox(height: 16),
            if (_difficultCards.isNotEmpty)
              Text(
                '${_difficultCards.length} terme(s) à revoir',
                style: const TextStyle(color: Colors.orange),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Quitter'),
          ),
          if (_difficultCards.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _reviewDifficult();
              },
              child: const Text('Revoir les difficiles'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _restartSession();
            },
            child: const Text('Recommencer'),
          ),
        ],
      ),
    );
  }

  void _reviewDifficult() {
    setState(() {
      _cards = _glossaire.entries
          .where((e) => _difficultCards.contains(e.key))
          .toList()
        ..shuffle(Random());
      _currentIndex = 0;
      _showAnswer = false;
      _correct = 0;
      _incorrect = 0;
    });
    _flipController.reset();
  }

  void _restartSession() {
    setState(() {
      _shuffleCards();
      _correct = 0;
      _incorrect = 0;
      _masteredCards.clear();
      _difficultCards.clear();
    });
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(child: Text('Aucune carte disponible')),
      );
    }

    final card = _cards[_currentIndex];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Flashcards', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              _shuffleCards();
              _flipController.reset();
              setState(() {});
            },
            tooltip: 'Mélanger',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentIndex + 1} / ${_cards.length}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        Text(' $_correct  ', style: const TextStyle(color: Colors.green)),
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                        Text(' $_incorrect', style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _cards.length,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF1A237E),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Card
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * 3.14159;
                  final isFront = angle < 1.5708;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isFront
                            ? (isDark ? const Color(0xFF1E1E1E) : Colors.white)
                            : (isDark ? const Color(0xFF2D2D2D) : Colors.blue[50]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: isFront ? Colors.grey.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: isFront
                              ? _buildFrontCard(card.key)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(3.14159),
                                  child: _buildBackCard(card.value),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Hint
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              _showAnswer ? 'Tapez pour voir le terme' : 'Tapez pour voir la définition',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous
                IconButton(
                  onPressed: _currentIndex > 0 ? _previousCard : null,
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 32,
                ),
                // Incorrect
                ElevatedButton.icon(
                  onPressed: _showAnswer ? _markIncorrect : null,
                  icon: const Icon(Icons.close),
                  label: const Text('À revoir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                // Correct
                ElevatedButton.icon(
                  onPressed: _showAnswer ? _markCorrect : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Maîtrisé'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                // Next
                IconButton(
                  onPressed: _currentIndex < _cards.length - 1 ? _nextCard : null,
                  icon: const Icon(Icons.arrow_forward),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(String term) {
    // Format term nicely
    final displayTerm = term.replaceAll('_', ' ');
    final capitalizedTerm = displayTerm.isNotEmpty
        ? displayTerm[0].toUpperCase() + displayTerm.substring(1)
        : displayTerm;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.help_outline, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          capitalizedTerm,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Qu\'est-ce que c\'est ?',
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBackCard(String definition) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lightbulb, size: 32, color: Colors.amber),
        const SizedBox(height: 16),
        MarkdownBody(
          data: definition,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(fontSize: 16, height: 1.5),
          ),
          extensionSet: _latexExtensionSet,
          builders: {'latex': LatexElementBuilder()},
        ),
      ],
    );
  }
}
