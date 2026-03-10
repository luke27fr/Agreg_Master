import 'package:flutter/material.dart';
import '../models/annale_model.dart';
import '../widgets/latex_text.dart';
import '../services/subscription_service.dart';
import '../services/annales_pedagogiques_data.dart';
import 'paywall_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnalesPedagogiquesPage extends StatefulWidget {
  const AnnalesPedagogiquesPage({super.key});

  @override
  State<AnnalesPedagogiquesPage> createState() =>
      _AnnalesPedagogiquesPageState();
}

class _AnnalesPedagogiquesPageState extends State<AnnalesPedagogiquesPage> {
  late final List<Annale> _annales;

  @override
  void initState() {
    super.initState();
    _annales = AnnalesPedagogiquesData.getAllAnnalesPedagogiques();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annales pédagogiques'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _annales.length,
              itemBuilder: (context, index) =>
                  _buildAnnaleCard(_annales[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.amber.withValues(alpha: 0.12)
            : Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school, color: Colors.amber[800], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Corrections ultra-detaillees de vrais sujets d\'agregation, '
              'expliquees pas a pas comme par un tuteur patient. '
              'Ideal pour comprendre la demarche et eviter les pieges.',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? Colors.amber[200] : Colors.amber[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnaleCard(Annale annale, int index) {
    final sub = SubscriptionService();
    final isLocked =
        !sub.isPremium && index >= sub.getFreeAccessCount('annales_ped');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExterne = annale.session == 'externe';
    final isMG = annale.typeEpreuve == 'ecrit1';

    final accentColor = isExterne ? Colors.indigo : Colors.deepOrange;

    final totalQuestions =
        annale.exercices.fold<int>(0, (s, ex) => s + ex.questions.length);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: accentColor.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: () => isLocked
            ? _showPaywall()
            : _openDetail(annale),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${annale.annee}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isExterne
                          ? Colors.blue.withValues(alpha: 0.08)
                          : Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isExterne ? 'Externe' : 'Interne',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color:
                            isExterne ? Colors.blue[700] : Colors.orange[800],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Pedagogique',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isLocked)
                    Icon(Icons.lock, size: 18, color: Colors.amber[700]),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                isExterne
                    ? (isMG
                        ? 'Mathematiques generales'
                        : 'Analyse et probabilites')
                    : (isMG ? 'Epreuve 1' : 'Epreuve 2'),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              // Description
              if (annale.description != null)
                Text(
                  annale.description!,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 10),

              // Stats row
              Row(
                children: [
                  Icon(Icons.quiz_outlined, size: 15, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '$totalQuestions questions corrigees',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 14),
                  Icon(Icons.timer_outlined, size: 15, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${annale.dureeMinutes ~/ 60}h d\'epreuve',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 14),
                  Icon(Icons.menu_book_outlined,
                      size: 15, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${annale.exercices.length} parties',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'annales_pedagogiques')),
    );
    if (result == true && mounted) setState(() {});
  }

  void _openDetail(Annale annale) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _AnnalePedagogiqueDetailPage(annale: annale),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Detail page – full correction step-by-step
// ═══════════════════════════════════════════════════════════════════

class _AnnalePedagogiqueDetailPage extends StatefulWidget {
  final Annale annale;
  const _AnnalePedagogiqueDetailPage({required this.annale});

  @override
  State<_AnnalePedagogiqueDetailPage> createState() =>
      _AnnalePedagogiqueDetailPageState();
}

class _AnnalePedagogiqueDetailPageState
    extends State<_AnnalePedagogiqueDetailPage> {
  final Set<String> _revealedCorrections = {};
  final Set<String> _revealedIndications = {};

  int get _totalQuestions => widget.annale.exercices
      .fold<int>(0, (s, ex) => s + ex.questions.length);

  int get _revealedCount => _revealedCorrections.length;

  @override
  Widget build(BuildContext context) {
    final annale = widget.annale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExterne = annale.session == 'externe';
    final accentColor = isExterne ? Colors.indigo : Colors.deepOrange;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isExterne
              ? (annale.typeEpreuve == 'ecrit1'
                  ? 'MG ${annale.annee} – Pedagogique'
                  : 'AP ${annale.annee} – Pedagogique')
              : (annale.typeEpreuve == 'ecrit1'
                  ? 'EP1 ${annale.annee} – Pedagogique'
                  : 'EP2 ${annale.annee} – Pedagogique'),
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          if (annale.urlSujet != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Ouvrir le sujet PDF',
              onPressed: () => _launchURL(annale.urlSujet!),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(accentColor),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Intro card
                _buildIntroCard(annale, isDark, accentColor),
                const SizedBox(height: 16),
                // Exercices / Parties
                ...annale.exercices.asMap().entries.map((entry) {
                  return _buildPartieSection(
                    entry.key,
                    entry.value,
                    accentColor,
                    isDark,
                  );
                }),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Color accentColor) {
    final progress =
        _totalQuestions > 0 ? _revealedCount / _totalQuestions : 0.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        border: Border(
            bottom: BorderSide(color: accentColor.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: accentColor),
          const SizedBox(width: 8),
          Text(
            '$_revealedCount / $_totalQuestions corrections consultees',
            style: TextStyle(fontSize: 12, color: accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(Annale annale, bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? accentColor.withValues(alpha: 0.08)
            : accentColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            annale.titre,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agregation ${annale.session} '
            '• ${annale.dureeMinutes ~/ 60} heures '
            '• ${annale.baremeTotal ?? 20}/20',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          if (annale.rapportGlobal != null) ...[
            const SizedBox(height: 10),
            LatexText(
              data: annale.rapportGlobal!,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
          if (annale.urlSujet != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _launchURL(annale.urlSujet!),
              icon: const Icon(Icons.picture_as_pdf, size: 16),
              label: const Text('Telecharger le sujet officiel (PDF)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPartieSection(
    int partieIndex,
    ExerciceAnnale exercice,
    Color accentColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Partie header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${partieIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercice.titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (exercice.bareme != null)
                      Text(
                        '${exercice.bareme} points',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${exercice.questions.length} questions',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        if (exercice.introduction != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: LatexText(
              data: exercice.introduction!,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        // Questions
        ...exercice.questions.asMap().entries.map((entry) {
          final qKey = '${partieIndex}_${entry.key}';
          return _buildQuestionCard(
            partieIndex,
            entry.key,
            entry.value,
            qKey,
            accentColor,
            isDark,
          );
        }),
      ],
    );
  }

  Widget _buildQuestionCard(
    int partieIdx,
    int questionIdx,
    QuestionAnnale question,
    String qKey,
    Color accentColor,
    bool isDark,
  ) {
    final correctionRevealed = _revealedCorrections.contains(qKey);
    final indicationRevealed = _revealedIndications.contains(qKey);

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: correctionRevealed
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: correctionRevealed
                        ? Colors.green
                        : accentColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: correctionRevealed
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${questionIdx + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LatexText(
                    data: question.enonce,
                    selectable: true,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
                if (question.points != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${question.points} pt${question.points! > 1 ? 's' : ''}',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // Action buttons
            Row(
              children: [
                // Indication button
                if (question.indication != null && !indicationRevealed)
                  _buildActionButton(
                    label: 'Indice',
                    icon: Icons.lightbulb_outline,
                    color: Colors.amber[700]!,
                    onTap: () =>
                        setState(() => _revealedIndications.add(qKey)),
                  ),
                if (question.indication != null) const SizedBox(width: 8),
                // Correction button
                if (!correctionRevealed && question.correction != null)
                  _buildActionButton(
                    label: 'Correction detaillee',
                    icon: Icons.school_outlined,
                    color: Colors.green[700]!,
                    onTap: () =>
                        setState(() => _revealedCorrections.add(qKey)),
                  ),
              ],
            ),

            // Indication content
            if (indicationRevealed && question.indication != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.amber.withValues(alpha: 0.1)
                      : Colors.amber.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.amber.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LatexText(
                        data: question.indication!,
                        selectable: true,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color:
                              isDark ? Colors.amber[200] : Colors.amber[900],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Correction content
            if (correctionRevealed && question.correction != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.green.withValues(alpha: 0.08)
                      : Colors.green.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.green.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school, size: 16, color: Colors.green[700]),
                        const SizedBox(width: 6),
                        Text(
                          'Correction pas a pas',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LatexText(
                      data: question.correction!,
                      selectable: true,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        color: isDark ? Colors.grey[200] : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Rapport du jury
            if (correctionRevealed && question.rapportJury != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.deepPurple.withValues(alpha: 0.08)
                      : Colors.deepPurple.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.deepPurple.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.gavel, size: 14, color: Colors.deepPurple[400]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: LatexText(
                        data: question.rapportJury!,
                        selectable: true,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? Colors.deepPurple[200]
                              : Colors.deepPurple[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Impossible d\'ouvrir : $url'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
