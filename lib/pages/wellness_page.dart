import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/wellness_service.dart';
import '../models/wellness_model.dart';

import '../widgets/global_search_button.dart';

class WellnessPage extends StatefulWidget {
  const WellnessPage({super.key});

  @override
  State<WellnessPage> createState() => _WellnessPageState();
}

class _WellnessPageState extends State<WellnessPage> {
  final WellnessService _service = WellnessService();

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
    final alerts = _service.activeAlerts;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Bien-être & Santé', style: TextStyle(fontWeight: FontWeight.bold)),
        $1
        actions: const [GlobalSearchButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur de risque burnout
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(stats.couleurRisqueValue).withOpacity(0.7),
                    Color(stats.couleurRisqueValue),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _getRisqueIcon(stats.risqueBurnout),
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Niveau de risque',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              stats.niveauRisque,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${stats.risqueBurnout.round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stats.risqueBurnout / 100,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Alertes actives
            if (alerts.isNotEmpty) ...[
              const Text(
                'Alertes actives',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...alerts.map((alert) => _buildAlertCard(alert, isDark)),
              const SizedBox(height: 24),
            ],

            // Statistiques
            const Text(
              'Statistiques sur 30 jours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '${stats.tempsEtudeMoyenParJour}',
                    'min/jour',
                    Icons.timer,
                    Colors.blue,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '${stats.joursRepos}',
                    'jours repos',
                    Icons.weekend,
                    Colors.green,
                    isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '${stats.concentrationMoyenne.toStringAsFixed(1)}',
                    'Concentration',
                    Icons.psychology,
                    Colors.purple,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '${stats.nombreSessionsParJour}',
                    'sessions/jour',
                    Icons.event,
                    Colors.orange,
                    isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recommandations
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.pink),
                      SizedBox(width: 8),
                      Text(
                        'Conseils bien-être',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Prenez une pause de 15 min toutes les 2 heures'),
                  _buildTip('Hydratez-vous régulièrement'),
                  _buildTip('Faites des étirements entre les sessions'),
                  _buildTip('Dormez au moins 7-8 heures par nuit'),
                  _buildTip('Prévoyez 1 jour de repos complet par semaine'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(WellnessAlert alert, bool isDark) {
    final color = alert.severite == 'critical' ? Colors.red :
                 alert.severite == 'warning' ? Colors.orange : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                alert.severite == 'critical' ? Icons.error : Icons.warning,
                color: color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.titre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => _service.dismissAlert(alert.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(alert.message),
          const SizedBox(height: 12),
          const Text(
            'Recommandations :',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          ...alert.recommandations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 14, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(rec, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  IconData _getRisqueIcon(double risque) {
    if (risque >= 75) return Icons.error;
    if (risque >= 50) return Icons.warning;
    if (risque >= 25) return Icons.info;
    return Icons.check_circle;
  }
}
