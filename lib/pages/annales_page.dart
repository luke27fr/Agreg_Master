import 'package:flutter/material.dart';
import '../services/annales_service.dart';
import '../models/annale_model.dart';
import '../widgets/latex_text.dart';
import '../services/subscription_service.dart';
import 'paywall_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnalesPage extends StatefulWidget {
  const AnnalesPage({super.key});

  @override
  State<AnnalesPage> createState() => _AnnalesPageState();
}

class _AnnalesPageState extends State<AnnalesPage> {
  final AnnalesService _service = AnnalesService();
  String? _selectedYear;
  String? _selectedSession;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onDataChanged);
    _service.loadAnnales();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annales officielles'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_service.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_service.error != null) {
      return Center(child: Text('Erreur : ${_service.error}'));
    }

    final years = _service.getAvailableYears();
    var filtered = _service.annales;

    if (_selectedYear != null) {
      filtered =
          filtered.where((a) => a.annee.toString() == _selectedYear).toList();
    }
    if (_selectedSession != null) {
      filtered =
          filtered.where((a) => a.session == _selectedSession).toList();
    }
    if (_selectedType != null) {
      filtered =
          filtered.where((a) => a.typeEpreuve == _selectedType).toList();
    }

    return Column(
      children: [
        _buildFilters(years),
        _buildInfoBanner(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final annale = filtered[index];
              final globalIndex = _service.annales.indexOf(annale);
              return _buildAnnaleCard(annale, globalIndex);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blue.withValues(alpha: 0.15)
            : Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sujets officiels de l\'agrégation de mathématiques (externe et interne, 2017–2025). '
              'Les liens renvoient vers les PDF publiés par le jury.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.blue[200] : Colors.blue[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<int> years) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]
            : Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SizedBox(
            width: 100,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Année',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
              initialValue: _selectedYear,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('Toutes')),
                ...years.map((y) => DropdownMenuItem(
                      value: y.toString(),
                      child: Text(y.toString()),
                    )),
              ],
              onChanged: (value) => setState(() => _selectedYear = value),
            ),
          ),
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Concours',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
              initialValue: _selectedSession,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tous')),
                DropdownMenuItem(value: 'externe', child: Text('Externe')),
                DropdownMenuItem(value: 'interne', child: Text('Interne')),
              ],
              onChanged: (value) => setState(() => _selectedSession = value),
            ),
          ),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Épreuve',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
              initialValue: _selectedType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: null, child: Text('Toutes')),
                DropdownMenuItem(value: 'ecrit1', child: Text('EP1 / MG')),
                DropdownMenuItem(value: 'ecrit2', child: Text('EP2 / AP')),
              ],
              onChanged: (value) => setState(() => _selectedType = value),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallPage(source: 'annales')),
    );
    if (result == true && mounted) setState(() {});
  }

  Widget _buildAnnaleCard(Annale annale, int index) {
    final sub = SubscriptionService();
    final isLocked = !sub.isPremium && index >= sub.getFreeAccessCount('annales');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMG = annale.typeEpreuve == 'ecrit1';
    final isExterne = annale.session == 'externe';

    final accentColor = isExterne
        ? (isMG ? Colors.indigo : Colors.teal)
        : (isMG ? Colors.deepOrange : Colors.brown);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: accentColor.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        onTap: () => isLocked ? _showPaywall() : _showAnnaleDetail(annale),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: year badge + type + difficulty
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
                        color: isExterne ? Colors.blue[700] : Colors.orange[800],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isExterne
                          ? (isMG ? 'Maths gén.' : 'Analyse & Proba')
                          : (isMG ? 'Épreuve 1' : 'Épreuve 2'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isLocked)
                    Icon(Icons.lock, size: 18, color: Colors.amber[700]),
                  if (!isLocked)
                    _buildDifficultyDot(annale.difficulte),
                ],
              ),
              const SizedBox(height: 10),
              // Description
              if (annale.description != null)
                Text(
                  annale.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 10),
              // Theme chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ...annale.themes.map((theme) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          theme,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              // Bottom row: duration + PDF indicators
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${annale.dureeMinutes ~/ 60}h',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 16),
                  if (annale.urlSujet != null) ...[
                    Icon(Icons.description_outlined,
                        size: 14, color: accentColor),
                    const SizedBox(width: 3),
                    Text('Sujet',
                        style: TextStyle(fontSize: 11, color: accentColor)),
                    const SizedBox(width: 10),
                  ],
                  if (annale.urlCorrige != null) ...[
                    const Icon(Icons.check_circle_outline,
                        size: 14, color: Colors.green),
                    const SizedBox(width: 3),
                    const Text('Corrigé',
                        style: TextStyle(fontSize: 11, color: Colors.green)),
                    const SizedBox(width: 10),
                  ],
                  if (annale.urlRapport != null) ...[
                    const Icon(Icons.assessment_outlined,
                        size: 14, color: Colors.deepPurple),
                    const SizedBox(width: 3),
                    const Text('Rapport',
                        style:
                            TextStyle(fontSize: 11, color: Colors.deepPurple)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyDot(String difficulte) {
    Color color;
    switch (difficulte) {
      case 'Facile':
        color = Colors.green;
        break;
      case 'Moyen':
        color = Colors.orange;
        break;
      case 'Difficile':
        color = Colors.red;
        break;
      case 'Très difficile':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          difficulte,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _showAnnaleDetail(Annale annale) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMG = annale.typeEpreuve == 'ecrit1';
    final isExterne = annale.session == 'externe';
    final accentColor = isExterne
        ? (isMG ? Colors.indigo : Colors.teal)
        : (isMG ? Colors.deepOrange : Colors.brown);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title + year
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${annale.annee}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildDifficultyDot(annale.difficulte),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  annale.titre,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrégation ${annale.session} • ${annale.dureeMinutes ~/ 60} heures • Barème : ${annale.baremeTotal ?? 20}/20',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 20),

                // === PDF LINKS ===
                _buildPdfLinksSection(annale, accentColor),

                const SizedBox(height: 20),

                // === DESCRIPTION ===
                if (annale.description != null) ...[
                  Text(
                    annale.description!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // === STRUCTURE DU SUJET ===
                if (annale.parties != null && annale.parties!.isNotEmpty) ...[
                  _buildSectionTitle('Structure du sujet', Icons.list_alt),
                  const SizedBox(height: 8),
                  ...annale.parties!.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // === MOTS-CLÉS ===
                if (annale.motsClefs != null &&
                    annale.motsClefs!.isNotEmpty) ...[
                  _buildSectionTitle(
                      'Thèmes et mots-clés', Icons.label_outline),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: annale.motsClefs!
                        .map((mc) => Chip(
                              label: Text(mc,
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: accentColor.withValues(alpha: 0.08),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 0),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // === RAPPORT DU JURY ===
                if (annale.rapportGlobal != null) ...[
                  _buildSectionTitle(
                      'Extraits du rapport du jury', Icons.gavel),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.deepPurple.withValues(alpha: 0.12)
                          : Colors.deepPurple.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.deepPurple.withValues(alpha: 0.2),
                      ),
                    ),
                    child: LatexText(
                      data: annale.rapportGlobal!,
                      selectable: true,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // === EXERCICES (legacy, if any) ===
                if (annale.exercices.isNotEmpty) ...[
                  _buildSectionTitle('Exercices', Icons.edit_note),
                  const SizedBox(height: 8),
                  ...annale.exercices.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final exercice = entry.value;
                    return _buildExerciceSection(idx + 1, exercice);
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPdfLinksSection(Annale annale, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (annale.urlSujet != null)
          _buildPdfButton(
            label: 'Ouvrir le sujet (PDF)',
            icon: Icons.description,
            color: accentColor,
            url: annale.urlSujet!,
          ),
        if (annale.urlCorrige != null) ...[
          const SizedBox(height: 8),
          _buildPdfButton(
            label: 'Ouvrir le corrigé (PDF)',
            icon: Icons.check_circle,
            color: Colors.green[700]!,
            url: annale.urlCorrige!,
          ),
        ],
        if (annale.urlRapport != null) ...[
          const SizedBox(height: 8),
          _buildPdfButton(
            label: 'Rapport du jury (PDF)',
            icon: Icons.assessment,
            color: Colors.deepPurple,
            url: annale.urlRapport!,
          ),
        ],
      ],
    );
  }

  Widget _buildPdfButton({
    required String label,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _launchURL(url),
      icon: Icon(icon, size: 18),
      label: Row(
        children: [
          Expanded(child: Text(label)),
          const Icon(Icons.open_in_new, size: 14),
        ],
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciceSection(int numero, ExerciceAnnale exercice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Exercice $numero – ${exercice.titre}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            exercice.bareme != null ? Text('${exercice.bareme} points') : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (exercice.introduction != null) ...[
                  LatexText(
                    data: exercice.introduction!,
                    selectable: true,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                ],
                ...exercice.questions.asMap().entries.map((entry) {
                  final qIdx = entry.key;
                  final question = entry.value;
                  return _buildQuestion(qIdx + 1, question);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(int numero, QuestionAnnale question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$numero',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LatexText(
                  data: question.enonce,
                  selectable: true,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (question.points != null)
                Text(
                  '${question.points}pts',
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          if (question.correction != null) ...[
            const SizedBox(height: 8),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Row(
                children: [
                  Icon(Icons.school, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Voir la correction',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
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
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: LatexText(
                    data: question.correction!,
                    selectable: true,
                    style: const TextStyle(fontSize: 13, height: 1.6),
                  ),
                ),
              ],
            ),
          ],
        ],
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
              content: Text('Impossible d\'ouvrir le lien : $url'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ouverture du lien : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
