import 'package:flutter/material.dart';
import '../services/annales_service.dart';
import '../models/annale_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnalesPage extends StatefulWidget {
  const AnnalesPage({Key? key}) : super(key: key);

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
        title: const Text('📚 Annales Officielles'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Rechercher',
          ),
        ],
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
      filtered = filtered.where((a) => a.annee.toString() == _selectedYear).toList();
    }
    if (_selectedSession != null) {
      filtered = filtered.where((a) => a.session == _selectedSession).toList();
    }
    if (_selectedType != null) {
      filtered = filtered.where((a) => a.typeEpreuve == _selectedType).toList();
    }

    return Column(
      children: [
        _buildFilters(years),
        _buildStats(_service),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return _buildAnnaleCard(filtered[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(List<int> years) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        border: Border(bottom: BorderSide(color: Colors.blue.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔍 Filtres',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Filtre année
              DropdownButton<String>(
                hint: const Text('Année'),
                value: _selectedYear,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Toutes')),
                  ...years.map((y) => DropdownMenuItem(
                        value: y.toString(),
                        child: Text(y.toString()),
                      )),
                ],
                onChanged: (value) => setState(() => _selectedYear = value),
              ),
              // Filtre session
              DropdownButton<String>(
                hint: const Text('Session'),
                value: _selectedSession,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Toutes')),
                  DropdownMenuItem(value: 'externe', child: Text('Externe')),
                  DropdownMenuItem(value: 'interne', child: Text('Interne')),
                ],
                onChanged: (value) => setState(() => _selectedSession = value),
              ),
              // Filtre type
              DropdownButton<String>(
                hint: const Text('Épreuve'),
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Toutes')),
                  DropdownMenuItem(value: 'ecrit1', child: Text('Écrit 1')),
                  DropdownMenuItem(value: 'ecrit2', child: Text('Écrit 2')),
                ],
                onChanged: (value) => setState(() => _selectedType = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AnnalesService service) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.book,
            label: 'Annales',
            value: service.annales.length.toString(),
            color: Colors.blue,
          ),
          _buildStatItem(
            icon: Icons.calendar_today,
            label: 'Années',
            value: service.getAvailableYears().length.toString(),
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.school,
            label: 'Exercices',
            value: service.annales
                .fold<int>(0, (sum, a) => sum + a.exercices.length)
                .toString(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAnnaleCard(Annale annale) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showAnnaleDetail(annale),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: annale.session == 'externe'
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${annale.annee} - ${annale.session.toUpperCase()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: annale.session == 'externe' ? Colors.blue : Colors.green,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildDifficultyChip(annale.difficulte),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                annale.titre,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (annale.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  annale.description!,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...annale.themes.map((theme) => Chip(
                        label: Text(theme, style: const TextStyle(fontSize: 11)),
                        padding: const EdgeInsets.all(4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${annale.dureeMinutes ~/ 60}h', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 16),
                  const Icon(Icons.assignment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${annale.exercices.length} exercices', style: const TextStyle(fontSize: 12)),
                  if (annale.baremeTotal != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.score, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${annale.baremeTotal} points', style: const TextStyle(fontSize: 12)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulte) {
    Color color;
    IconData icon;
    switch (difficulte) {
      case 'Facile':
        color = Colors.green;
        icon = Icons.sentiment_satisfied;
        break;
      case 'Moyen':
        color = Colors.orange;
        icon = Icons.sentiment_neutral;
        break;
      case 'Difficile':
        color = Colors.red;
        icon = Icons.sentiment_dissatisfied;
        break;
      case 'Très difficile':
        color = Colors.purple;
        icon = Icons.warning;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          difficulte,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showAnnaleDetail(Annale annale) {
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
                Text(
                  annale.titre,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (annale.urlOfficielle != null)
                  ElevatedButton.icon(
                    onPressed: () => _launchURL(annale.urlOfficielle!),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Voir le sujet officiel'),
                  ),
                const SizedBox(height: 20),
                ...annale.exercices.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final exercice = entry.value;
                  return _buildExerciceSection(idx + 1, exercice);
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciceSection(int numero, ExerciceAnnale exercice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Exercice $numero - ${exercice.titre}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: exercice.bareme != null
            ? Text('${exercice.bareme} points')
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (exercice.introduction != null) ...[
                  Text(
                    exercice.introduction!,
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
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$numero',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.enonce,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (question.points != null)
                Text(
                  '${question.points}pts',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          if (question.indication != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
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
              title: const Row(
                children: [
                  Icon(Icons.school, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
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
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    question.correction!,
                    style: const TextStyle(fontSize: 13),
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
