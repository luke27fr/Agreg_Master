import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/lecon_progress_service.dart';
import '../models/lecon_progress_model.dart';

import '../widgets/global_search_button.dart';

class LeconProgressPage extends StatefulWidget {
  const LeconProgressPage({super.key});

  @override
  State<LeconProgressPage> createState() => _LeconProgressPageState();
}

class _LeconProgressPageState extends State<LeconProgressPage> with SingleTickerProviderStateMixin {
  final LeconProgressService _progressService = LeconProgressService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _progressService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _progressService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final globalStats = _progressService.getGlobalStatistics();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ma Progression', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Vue d\'ensemble', icon: Icon(Icons.dashboard)),
            Tab(text: 'Par domaine', icon: Icon(Icons.category)),
            Tab(text: 'Leçons', icon: Icon(Icons.list)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(globalStats, isDark),
          _buildDomaineTab(isDark),
          _buildLeconsTab(isDark),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> stats, bool isDark) {
    final readyPercent = stats['total'] > 0 
        ? (stats['ready'] / stats['total'] * 100).round()
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte principale
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCircle(
                      '${stats['ready']}/${stats['total']}',
                      'Prêtes',
                      Icons.check_circle,
                    ),
                    _buildStatCircle(
                      '${stats['commenced']}',
                      'Commencées',
                      Icons.school,
                    ),
                    _buildStatCircle(
                      '${(stats['totalTime'] / 60).round()}h',
                      'Travaillées',
                      Icons.timer,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '$readyPercent% prêtes pour l\'oral',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: readyPercent / 100,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Radar chart (Maîtrise globale)
          const Text(
            'Niveau de maîtrise',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildRadarChart(isDark),
          ),

          const SizedBox(height: 24),

          // Leçons prioritaires
          const Text(
            'À travailler en priorité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...(_progressService.getPriorityLecons(limit: 5).map((lecon) => 
            _buildLeconCard(lecon, isDark, showPriority: true)
          )),

          const SizedBox(height: 24),

          // Développements maîtrisés
          _buildDeveloppementsSection(isDark),
        ],
      ),
    );
  }

  Widget _buildDomaineTab(bool isDark) {
    final domaines = ['Algèbre', 'Analyse', 'Géométrie', 'Probabilités'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: domaines.length,
      itemBuilder: (context, index) {
        final domaine = domaines[index];
        final stats = _progressService.getDomaineStatistics(domaine);

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
                  Icon(_getDomaineIcon(domaine), color: _getDomaineColor(domaine), size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          domaine,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${stats.leconsReady}/${stats.totalLecons} prêtes',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getDomaineColor(domaine).withOpacity(0.1),
                    child: Text(
                      '${stats.averageMastery.round()}%',
                      style: TextStyle(
                        color: _getDomaineColor(domaine),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: stats.averageMastery / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(_getDomaineColor(domaine)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSmallStat('Commencées', '${stats.leconsCommencees}'),
                  _buildSmallStat('Temps', '${(stats.tempsTotal / 60).round()}h'),
                  _buildSmallStat('Prêtes', '${stats.leconsReady}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeconsTab(bool isDark) {
    final allLecons = _progressService.progressMap.values.toList();
    
    if (allLecons.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune leçon en cours',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Commencez à travailler une leçon !',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Trier par niveau de maîtrise décroissant
    allLecons.sort((a, b) => b.getMasteryLevel().compareTo(a.getMasteryLevel()));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allLecons.length,
      itemBuilder: (context, index) {
        return _buildLeconCard(allLecons[index], isDark);
      },
    );
  }

  Widget _buildLeconCard(LeconProgress lecon, bool isDark, {bool showPriority = false}) {
    final masteryLevel = lecon.getMasteryLevel();
    final masteryColor = masteryLevel >= 80 ? Colors.green :
                        masteryLevel >= 60 ? Colors.blue :
                        masteryLevel >= 40 ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: showPriority ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: masteryColor.withOpacity(0.1),
          child: Text(
            lecon.leconNumero,
            style: TextStyle(
              color: masteryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          lecon.leconTitre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.school, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  lecon.getStatus(),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.check_circle, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${lecon.developpementsMaitrises}/2 dev.',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: masteryLevel / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(masteryColor),
                minHeight: 4,
              ),
            ),
          ],
        ),
        trailing: lecon.isReadyForOral()
            ? const Icon(Icons.verified, color: Colors.green)
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Détails de maîtrise
                _buildMasteryRow('Plan général', lecon.niveauPlan),
                _buildMasteryRow('Développements', lecon.niveauDeveloppements),
                _buildMasteryRow('Exemples', lecon.niveauExemples),
                _buildMasteryRow('Références', lecon.niveauReferencesBiblio),
                
                const Divider(height: 24),

                // Statistiques
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSmallStat('Révisions', '${lecon.nombreRevisions}'),
                    _buildSmallStat('Temps', '${(lecon.tempsEtudeMinutes / 60).toStringAsFixed(1)}h'),
                    _buildSmallStat('Présentations', '${lecon.historiquePresentations.length}'),
                  ],
                ),

                const SizedBox(height: 16),

                // Bouton d'édition
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditDialog(lecon),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Mettre à jour'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChart(bool isDark) {
    // Calculer les moyennes par critère
    final allLecons = _progressService.progressMap.values.toList();
    
    if (allLecons.isEmpty) {
      return const Center(
        child: Text('Aucune donnée disponible', style: TextStyle(color: Colors.grey)),
      );
    }

    final avgPlan = allLecons.map((l) => l.niveauPlan).reduce((a, b) => a + b) / allLecons.length;
    final avgDev = allLecons.map((l) => l.niveauDeveloppements).reduce((a, b) => a + b) / allLecons.length;
    final avgEx = allLecons.map((l) => l.niveauExemples).reduce((a, b) => a + b) / allLecons.length;
    final avgRef = allLecons.map((l) => l.niveauReferencesBiblio).reduce((a, b) => a + b) / allLecons.length;

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 5,
        ticksTextStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 10),
        radarBorderData: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        gridBorderData: BorderSide(color: isDark ? Colors.white12 : Colors.black12, width: 1),
        tickBorderData: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        getTitle: (index, angle) {
          switch (index) {
            case 0: return const RadarChartTitle(text: 'Plan');
            case 1: return const RadarChartTitle(text: 'Dév.');
            case 2: return const RadarChartTitle(text: 'Exemples');
            case 3: return const RadarChartTitle(text: 'Biblio.');
            default: return const RadarChartTitle(text: '');
          }
        },
        dataSets: [
          RadarDataSet(
            fillColor: const Color(0xFF1A237E).withOpacity(0.2),
            borderColor: const Color(0xFF1A237E),
            borderWidth: 2,
            dataEntries: [
              RadarEntry(value: avgPlan),
              RadarEntry(value: avgDev),
              RadarEntry(value: avgEx),
              RadarEntry(value: avgRef),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryRow(String label, int level) {
    final color = level >= 80 ? Colors.green :
                  level >= 60 ? Colors.blue :
                  level >= 40 ? Colors.orange : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: level / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$level%', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
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
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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

  Widget _buildSmallStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildDeveloppementsSection(bool isDark) {
    final allLecons = _progressService.progressMap.values.toList();
    final totalDev = allLecons.map((l) => l.developpementsMaitrises).fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Colors.purple),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Développements maîtrisés',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalDev',
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Objectif: 2 développements par leçon',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(LeconProgress lecon) {
    showDialog(
      context: context,
      builder: (ctx) => _EditLeconDialog(lecon: lecon),
    );
  }

  IconData _getDomaineIcon(String domaine) {
    switch (domaine) {
      case 'Algèbre': return Icons.functions;
      case 'Analyse': return Icons.show_chart;
      case 'Géométrie': return Icons.architecture;
      case 'Probabilités': return Icons.casino;
      default: return Icons.book;
    }
  }

  Color _getDomaineColor(String domaine) {
    switch (domaine) {
      case 'Algèbre': return const Color(0xFF3F51B5);
      case 'Analyse': return const Color(0xFFE91E63);
      case 'Géométrie': return const Color(0xFFFF9800);
      case 'Probabilités': return const Color(0xFF009688);
      default: return Colors.grey;
    }
  }
}

// Dialog pour éditer une leçon
class _EditLeconDialog extends StatefulWidget {
  final LeconProgress lecon;

  const _EditLeconDialog({required this.lecon});

  @override
  State<_EditLeconDialog> createState() => _EditLeconDialogState();
}

class _EditLeconDialogState extends State<_EditLeconDialog> {
  late int _niveauPlan;
  late int _niveauDev;
  late int _niveauEx;
  late int _niveauRef;

  @override
  void initState() {
    super.initState();
    _niveauPlan = widget.lecon.niveauPlan;
    _niveauDev = widget.lecon.niveauDeveloppements;
    _niveauEx = widget.lecon.niveauExemples;
    _niveauRef = widget.lecon.niveauReferencesBiblio;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.lecon.leconNumero} - ${widget.lecon.leconTitre}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSlider('Plan général', _niveauPlan, (val) => setState(() => _niveauPlan = val)),
            _buildSlider('Développements', _niveauDev, (val) => setState(() => _niveauDev = val)),
            _buildSlider('Exemples', _niveauEx, (val) => setState(() => _niveauEx = val)),
            _buildSlider('Références biblio.', _niveauRef, (val) => setState(() => _niveauRef = val)),
          ],
        ),
      ),
      actions: [
          const GlobalSearchButton(),
          
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            LeconProgressService().updateMasteryLevels(
              widget.lecon.leconId,
              niveauPlan: _niveauPlan,
              niveauDeveloppements: _niveauDev,
              niveauExemples: _niveauEx,
              niveauReferencesBiblio: _niveauRef,
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          child: const Text('Sauvegarder'),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 100,
          divisions: 20,
          label: '$value%',
          onChanged: (val) => onChanged(val.round()),
        ),
      ],
    );
  }
}
