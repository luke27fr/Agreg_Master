import 'package:flutter/material.dart';
import '../smart_planner_page.dart';
import '../planificateur_page.dart';
import '../pomodoro_page.dart';
import '../structured_notes_page.dart';
import '../../services/streak_service.dart';
import '../../services/smart_planner_service.dart';

class OrganiserTab extends StatefulWidget {
  const OrganiserTab({super.key});

  @override
  State<OrganiserTab> createState() => _OrganiserTabState();
}

class _OrganiserTabState extends State<OrganiserTab> {
  final StreakService _streakService = StreakService();
  final SmartPlannerService _plannerService = SmartPlannerService();

  @override
  void initState() {
    super.initState();
    _streakService.addListener(_onChanged);
    _plannerService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _streakService.removeListener(_onChanged);
    _plannerService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final objectives = _streakService.todayObjectives;
    final completionRate = _streakService.getTodayCompletionRate();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Organiser', style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A237E),
            )),

            const SizedBox(height: 20),

            // Objectifs du jour
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(isDark ? 0.05 : 0.08), blurRadius: 4)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.flag, color: Colors.green, size: 22),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Objectifs du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (completionRate >= 1 ? Colors.green : Colors.orange).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${(completionRate * 100).round()}%', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,
                      color: completionRate >= 1 ? Colors.green : Colors.orange,
                    )),
                  ),
                ]),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: completionRate,
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(completionRate >= 1 ? Colors.green : Colors.orange),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 14),
                ...objectives.values.map((obj) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Icon(obj.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: obj.isCompleted ? Colors.green : Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(obj.title, style: const TextStyle(fontSize: 14))),
                    Text(
                      '${obj.progress}/${obj.target}${obj.unit.isNotEmpty ? ' ${obj.unit}' : ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13,
                        color: obj.isCompleted ? Colors.green : Colors.grey,
                      ),
                    ),
                  ]),
                )),
              ]),
            ),

            // Section Planning
            _buildSectionHeader('Planning'),
            _buildToolCard(
              icon: Icons.event_note, title: 'Planning Intelligent',
              subtitle: 'Organisation optimisée jusqu\'au concours',
              color: Colors.cyan, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartPlannerPage())),
            ),
            _buildToolCard(
              icon: Icons.calendar_month, title: 'Calendrier',
              subtitle: 'Planifier vos sessions de révision',
              color: Colors.orange, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanificateurPage())),
            ),

            // Section Productivité
            _buildSectionHeader('Productivité'),
            _buildToolCard(
              icon: Icons.timer_outlined, title: 'Pomodoro',
              subtitle: 'Sessions de travail concentré (25/5 min)',
              color: Colors.red, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PomodoroPage())),
            ),
            _buildToolCard(
              icon: Icons.note_alt, title: 'Mes Notes',
              subtitle: 'Notes structurées par leçon',
              color: Colors.pink, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StructuredNotesPage())),
            ),

            const SizedBox(height: 24),

            // Conseils
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text('Conseils d\'organisation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
                const SizedBox(height: 12),
                _buildConseil('Révisez une leçon d\'algèbre et une d\'analyse chaque jour'),
                _buildConseil('Faites un examen blanc complet par semaine'),
                _buildConseil('Utilisez le Pomodoro pour les sessions longues'),
                _buildConseil('Préparez 2-3 développements par semaine'),
              ]),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildToolCard({
    required IconData icon, required String title, required String subtitle,
    required Color color, required bool isDark, required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            )),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ]),
        ),
      ),
    );
  }

  Widget _buildConseil(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.check, size: 15, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 12))),
      ]),
    );
  }
}
