import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'dart:async';
import 'dart:convert';
import '../utils/content_loader.dart';
import '../services/jury_virtuel_service.dart';
import '../services/subscription_service.dart';
import '../models/jury_virtuel_model.dart';
import 'paywall_page.dart';

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
  Map<String, dynamic>? _leconData; // Données complètes de la leçon

  @override
  void initState() {
    super.initState();
    _session = _service.createSession(widget.leconId, widget.leconTitre);
    _startQuestionTimer();
    _loadLeconData();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  /// Charge les données de la leçon depuis lecons.json
  Future<void> _loadLeconData() async {
    try {
      final jsonString = await ContentLoader.loadString('assets/data/lecons.json');
      final Map<String, dynamic> allData = json.decode(jsonString);

      for (final domain in allData.keys) {
        final lecons = allData[domain] as List<dynamic>;
        for (final lecon in lecons) {
          if (lecon['numero'].toString() == widget.leconId) {
            if (mounted) setState(() => _leconData = Map<String, dynamic>.from(lecon));
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur chargement données leçon: $e');
    }
  }

  /// Ouvre la page de la leçon (pause le timer)
  void _openLeconReference() {
    if (_leconData == null) return;
    _questionTimer?.cancel(); // Pause le timer

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeconReferencePage(
          leconNumero: widget.leconId,
          leconData: _leconData!,
        ),
      ),
    ).then((_) {
      // Reprendre le timer au retour
      if (mounted) _resumeTimer();
    });
  }

  void _resumeTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _questionTimeSeconds++;
      });
    });
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
        actions: [
          if (_leconData != null)
            TextButton.icon(
              onPressed: _openLeconReference,
              icon: const Icon(Icons.menu_book, size: 18),
              label: const Text('Leçon', style: TextStyle(fontSize: 13)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A237E),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
        ],
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
                                color: _getCategoryColor(currentQA.question.categorie).withValues(alpha: 0.1),
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
                        if (_showingAnswer) ...[
                          // Indice pédagogique
                          if (currentQA.question.indicePedagogique != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          // Points clés
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.checklist, color: Colors.green, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Points clés attendus :',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (currentQA.question.pointsCles != null && currentQA.question.pointsCles!.isNotEmpty)
                                  ...currentQA.question.pointsCles!.map((point) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(Icons.check_circle, size: 16, color: Colors.green),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(point, style: const TextStyle(fontSize: 13))),
                                        ],
                                      ),
                                    );
                                  })
                                else
                                  Text(
                                    'Réfléchissez aux éléments essentiels que le jury attendrait '
                                    'pour cette catégorie de question (${currentQA.question.categorie}).',
                                    style: TextStyle(fontSize: 13, color: Colors.grey[600], fontStyle: FontStyle.italic),
                                  ),
                              ],
                            ),
                          ),
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

// ============================================================================
// Page de référence de la leçon (accessible depuis le jury virtuel)
// ============================================================================
class LeconReferencePage extends StatefulWidget {
  final String leconNumero;
  final Map<String, dynamic> leconData;

  const LeconReferencePage({
    super.key,
    required this.leconNumero,
    required this.leconData,
  });

  @override
  State<LeconReferencePage> createState() => _LeconReferencePageState();
}

class _LeconReferencePageState extends State<LeconReferencePage> {
  bool _isLocked = false;
  bool _checkDone = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumAccess();
  }

  Future<void> _checkPremiumAccess() async {
    final sub = SubscriptionService();
    if (sub.isPremium) {
      if (mounted) setState(() => _checkDone = true);
      return;
    }
    try {
      final jsonString = await ContentLoader.loadString('assets/data/lecons.json');
      final Map<String, dynamic> allData = json.decode(jsonString);
      final numero = int.tryParse(widget.leconNumero);
      for (final domain in allData.keys) {
        final lecons = allData[domain] as List<dynamic>;
        for (int i = 0; i < lecons.length; i++) {
          if (lecons[i]['numero'] == numero) {
            if (mounted) {
              setState(() {
                _isLocked = i >= sub.getFreeAccessCount('lecons');
                _checkDone = true;
              });
            }
            return;
          }
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _checkDone = true);
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'jury_virtuel')),
    );
    if (result == true && mounted) {
      setState(() {
        _isLocked = false;
        _checkDone = true;
      });
    }
  }

  String get leconNumero => widget.leconNumero;
  Map<String, dynamic> get leconData => widget.leconData;

  /// Renders text with inline $...$ LaTeX blocks using flutter_math_fork directly.
  /// This avoids the conflict between markdown's _ (italic) and LaTeX's _ (subscript).
  Widget _mathText(String text, {TextStyle? style}) {
    final effectiveStyle = style ?? const TextStyle(fontSize: 14, height: 1.4);
    final regex = RegExp(r'\$(.+?)\$');
    final matches = regex.allMatches(text).toList();

    if (matches.isEmpty) {
      return Text(text, style: effectiveStyle);
    }

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      // Add text before the math block
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      // Add the math block
      final latex = match.group(1)!;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          latex,
          textStyle: effectiveStyle.copyWith(height: 1.0),
          mathStyle: MathStyle.text,
          onErrorFallback: (err) => Text(
            latex,
            style: effectiveStyle.copyWith(color: Colors.red[300]),
          ),
        ),
      ));
      lastEnd = match.end;
    }

    // Add remaining text after last match
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return Text.rich(
      TextSpan(style: effectiveStyle, children: spans),
    );
  }

  /// Builds a clickable tag chip for développements/prérequis
  Widget _buildClickableTag({
    required BuildContext context,
    required String label,
    required String tag,
    required Color color,
    required bool isDark,
    required String field,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showRelatedLecons(context, tag, label, color, field),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? color.withValues(alpha: 0.8) : color.withValues(alpha: 0.9),
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.open_in_new, size: 12, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a bottom sheet with all lessons related to a tag
  Future<void> _showRelatedLecons(
    BuildContext context,
    String tag,
    String label,
    Color color,
    String field,
  ) async {
    // Load all lessons
    List<Map<String, dynamic>> allLecons = [];
    try {
      final jsonString = await ContentLoader.loadString('assets/data/lecons.json');
      final Map<String, dynamic> allData = json.decode(jsonString);
      for (final domain in allData.keys) {
        final lecons = allData[domain] as List<dynamic>;
        for (final lecon in lecons) {
          allLecons.add(Map<String, dynamic>.from(lecon as Map));
        }
      }
    } catch (e) {
      return;
    }

    // Filter lessons that contain this tag
    final related = allLecons.where((l) {
      final tags = l[field] as List<dynamic>? ?? [];
      return tags.any((t) => t.toString() == tag);
    }).toList();

    // Sort by numero
    related.sort((a, b) => (a['numero'] as int).compareTo(b['numero'] as int));

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) => Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        field == 'developpements' ? Icons.science : Icons.school,
                        color: color, size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${related.length} leçon${related.length > 1 ? 's' : ''} associée${related.length > 1 ? 's' : ''}',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: related.length,
                  itemBuilder: (_, index) {
                    final lecon = related[index];
                    final numero = lecon['numero'].toString();
                    final titre = lecon['titre'] as String? ?? '';
                    final isCurrent = numero == leconNumero;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF1A237E)
                              : (isDark ? Colors.grey[800] : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          numero,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? Colors.white : null,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      title: Text(
                        titre,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isCurrent
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'actuelle',
                                style: TextStyle(fontSize: 11, color: Color(0xFF1A237E)),
                              ),
                            )
                          : const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: isCurrent
                          ? null
                          : () {
                              Navigator.pop(ctx); // Close bottom sheet
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LeconReferencePage(
                                    leconNumero: numero,
                                    leconData: lecon,
                                  ),
                                ),
                              );
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_checkDone) {
      return Scaffold(
        appBar: AppBar(title: Text('Leçon $leconNumero')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_isLocked) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(),
          title: Text('Leçon $leconNumero', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.amber),
                const SizedBox(height: 24),
                Text(
                  'Leçon $leconNumero',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  leconData['titre'] as String? ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Cette leçon est réservée aux membres Premium.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _showPaywall,
                  icon: const Icon(Icons.star),
                  label: const Text('Devenir Premium'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final titre = leconData['titre'] as String? ?? '';
    final pointsCles = leconData['points_cles'] as List<dynamic>? ?? [];
    final plan = leconData['plan'] as List<dynamic>? ?? [];
    final theoremesCles = leconData['theoremes_cles'] as List<dynamic>? ?? [];
    final exemplesImportants = leconData['exemples_importants'] as List<dynamic>? ?? [];
    final erreursCourantes = leconData['erreurs_courantes'] as List<dynamic>? ?? [];
    final conseilsJury = leconData['conseils_jury'] as List<dynamic>? ?? [];
    final developpements = leconData['developpements'] as List<dynamic>? ?? [];
    final prerequis = leconData['prerequis'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Leçon $leconNumero',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec numéro et titre
            _buildCard(isDark, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Leçon $leconNumero',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                _mathText(titre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ), borderColor: const Color(0xFF1A237E).withValues(alpha: 0.2)),

            const SizedBox(height: 16),

            // Plan détaillé
            if (plan.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.list_alt, color: const Color(0xFF1A237E), title: 'Plan détaillé',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < plan.length; i++)
                      _buildPlanItem(plan[i], i + 1, isDark),
                  ],
                ),
              ),

            // Théorèmes clés
            if (theoremesCles.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.auto_awesome, color: Colors.deepPurple, title: 'Théorèmes clés',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: theoremesCles.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.star, size: 16, color: Colors.deepPurple),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _mathText(t.toString())),
                      ],
                    ),
                  )).toList(),
                ),
              ),

            // Points clés
            if (pointsCles.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.checklist, color: Colors.green, title: 'Points clés à aborder',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pointsCles.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle, size: 16, color: Colors.green),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _mathText(point.toString())),
                      ],
                    ),
                  )).toList(),
                ),
              ),

            // Exemples importants
            if (exemplesImportants.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.lightbulb, color: Colors.amber.shade700, title: 'Exemples importants',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exemplesImportants.map((ex) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber.shade700),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _mathText(ex.toString())),
                      ],
                    ),
                  )).toList(),
                ),
              ),

            // Erreurs courantes
            if (erreursCourantes.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.warning_amber, color: Colors.red, title: 'Erreurs courantes',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: erreursCourantes.map((err) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.error_outline, size: 16, color: Colors.red),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _mathText(err.toString())),
                      ],
                    ),
                  )).toList(),
                ),
              ),

            // Conseils jury
            if (conseilsJury.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.gavel, color: Colors.teal, title: 'Conseils pour le jury',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: conseilsJury.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.tips_and_updates, size: 16, color: Colors.teal),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _mathText(c.toString())),
                      ],
                    ),
                  )).toList(),
                ),
              ),

            // Développements compatibles
            if (developpements.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.science, color: Colors.blue, title: 'Développements compatibles',
                child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: developpements.map((dev) => _buildClickableTag(
                    context: context,
                    label: dev.toString().replaceAll('_', ' '),
                    tag: dev.toString(),
                    color: Colors.blue,
                    isDark: isDark,
                    field: 'developpements',
                  )).toList(),
                ),
              ),

            // Prérequis
            if (prerequis.isNotEmpty)
              _buildSection(isDark,
                icon: Icons.school, color: Colors.orange, title: 'Prérequis',
                child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: prerequis.map((req) => _buildClickableTag(
                    context: context,
                    label: req.toString().replaceAll('_', ' '),
                    tag: req.toString(),
                    color: Colors.orange,
                    isDark: isDark,
                    field: 'prerequis',
                  )).toList(),
                ),
              ),

            // Bouton retour au jury
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour au Jury Virtuel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A237E),
                  side: const BorderSide(color: Color(0xFF1A237E)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(bool isDark, {required Widget child, Color? borderColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }

  Widget _buildSection(bool isDark, {
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _buildCard(isDark, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))),
          ]),
          const SizedBox(height: 12),
          child,
        ],
      )),
    );
  }

  Widget _buildPlanItem(dynamic item, int index, bool isDark) {
    if (item is Map<String, dynamic>) {
      final section = item['section'] as String? ?? '';
      final sousParties = item['sous_parties'] as List<dynamic>? ?? [];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(child: Text(
                    '$index',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A237E)),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(child: _mathText(section, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
              ],
            ),
            if (sousParties.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sousParties.map((sp) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(width: 5, height: 5, decoration: BoxDecoration(
                            color: Colors.grey[400], shape: BoxShape.circle,
                          )),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: _mathText(sp.toString(), style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
                      ],
                    ),
                  )).toList(),
                ),
              ),
          ],
        ),
      );
    } else {
      // Simple string
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(child: Text(
                '$index',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A237E)),
              )),
            ),
            const SizedBox(width: 10),
            Expanded(child: _mathText(item.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
          ],
        ),
      );
    }
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

            // Bouton pour démarrer une session rapide
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLeconSelectionDialog(),
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text('Démarrer une session', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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

  /// Charge toutes les leçons depuis assets/data/lecons.json
  Future<List<Map<String, dynamic>>> _loadAllLecons() async {
    try {
      final jsonString = await ContentLoader.loadString('assets/data/lecons.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<Map<String, dynamic>> allLecons = [];

      for (final domain in data.keys) {
        final lecons = data[domain] as List<dynamic>;
        for (final lecon in lecons) {
          allLecons.add({
            'numero': lecon['numero'].toString(),
            'titre': lecon['titre'] as String,
            'domain': domain,
          });
        }
      }

      // Trier par numéro
      allLecons.sort((a, b) =>
          int.parse(a['numero']).compareTo(int.parse(b['numero'])));
      return allLecons;
    } catch (e) {
      debugPrint('Erreur chargement leçons: $e');
      return [];
    }
  }

  void _showLeconSelectionDialog() async {
    final allLecons = await _loadAllLecons();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _LeconSelectionSheet(
        lecons: allLecons,
        onLeconSelected: (numero, titre) {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JuryVirtuelPage(
                leconId: numero,
                leconTitre: 'Leçon $numero – $titre',
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ============================================================================
// Bottom sheet pour sélectionner une leçon parmi les 61 disponibles
// ============================================================================
class _LeconSelectionSheet extends StatefulWidget {
  final List<Map<String, dynamic>> lecons;
  final void Function(String numero, String titre) onLeconSelected;

  const _LeconSelectionSheet({
    required this.lecons,
    required this.onLeconSelected,
  });

  @override
  State<_LeconSelectionSheet> createState() => _LeconSelectionSheetState();
}

class _LeconSelectionSheetState extends State<_LeconSelectionSheet> {
  String _searchQuery = '';
  String _selectedDomain = 'all'; // 'all', 'algebre', 'analyse'

  List<Map<String, dynamic>> get _filteredLecons {
    return widget.lecons.where((lecon) {
      // Filtre par domaine
      if (_selectedDomain != 'all' && lecon['domain'] != _selectedDomain) {
        return false;
      }
      // Filtre par recherche
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final numero = lecon['numero'] as String;
        final titre = (lecon['titre'] as String).toLowerCase();
        return numero.contains(query) || titre.contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Poignée
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Titre
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Choisir une leçon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher par numéro ou titre...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            // Filtres par domaine
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildDomainChip('all', 'Toutes', Icons.list),
                  const SizedBox(width: 8),
                  _buildDomainChip('algebre', 'Algèbre', Icons.functions),
                  const SizedBox(width: 8),
                  _buildDomainChip('analyse', 'Analyse', Icons.show_chart),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Compteur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredLecons.length} leçon${_filteredLecons.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Liste des leçons
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filteredLecons.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final lecon = _filteredLecons[index];
                  final numero = lecon['numero'] as String;
                  final titre = lecon['titre'] as String;
                  final domain = lecon['domain'] as String;
                  final isAlgebre = domain == 'algebre';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (isAlgebre ? Colors.indigo : Colors.teal)
                              .withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            numero,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isAlgebre ? Colors.indigo : Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        titre,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        isAlgebre ? 'Algèbre' : 'Analyse',
                        style: TextStyle(
                          fontSize: 12,
                          color: isAlgebre ? Colors.indigo : Colors.teal,
                        ),
                      ),
                      onTap: () => widget.onLeconSelected(numero, titre),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDomainChip(String domain, String label, IconData icon) {
    final isSelected = _selectedDomain == domain;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.grey[700],
          )),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedDomain = domain),
      selectedColor: const Color(0xFF1A237E),
      backgroundColor: Colors.grey[200],
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

