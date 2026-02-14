import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/smart_planner_service.dart';
import '../models/smart_planner_model.dart';

import '../widgets/global_search_button.dart';

class SmartPlannerPage extends StatefulWidget {
  const SmartPlannerPage({super.key});

  @override
  State<SmartPlannerPage> createState() => _SmartPlannerPageState();
}

class _SmartPlannerPageState extends State<SmartPlannerPage> {
  final SmartPlannerService _service = SmartPlannerService();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
    final tasksForDay = _service.getTasksForDate(_selectedDay);
    final alerts = _service.detectWorkloadAlerts();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Planning Intelligent', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          const GlobalSearchButton(),
          
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showConfigDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => _generateSmartPlanning(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Alertes
          if (alerts.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${alerts.length} alerte${alerts.length > 1 ? 's' : ''} de surcharge',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAlertsDialog(alerts),
                    child: const Text('Voir'),
                  ),
                ],
              ),
            ),

          // Calendrier
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => _service.getTasksForDate(day),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF1A237E),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          const Divider(),

          // Tâches du jour sélectionné
          Expanded(
            child: tasksForDay.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucune tâche planifiée',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasksForDay.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasksForDay[index], isDark);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addManualTask(),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard(PlannedTask task, bool isDark) {
    final color = _getTaskColor(task.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: task.completed ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: ListTile(
        leading: Container(
          width: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          task.titre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${_formatTime(task.dateDebut)} - ${_formatTime(task.dateFin)} (${task.dureeMinutes} min)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (task.description != null) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        trailing: task.completed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _service.completeTask(task.id),
              ),
      ),
    );
  }

  void _showConfigDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Configuration'),
        content: const Text('Configurez votre planning personnalisé'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _generateSmartPlanning() {
    if (_service.config == null) {
      // Créer une config par défaut
      final config = PlannerConfig(
        dateExamen: DateTime.now().add(const Duration(days: 90)),
        heuresParJour: 6,
      );
      _service.setConfig(config);
    }

    final suggestion = _service.generateSmartPlanning();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Planning Généré'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(suggestion.description),
              const SizedBox(height: 16),
              Text('Tâches: ${suggestion.tasks.length}'),
              Text('Charge totale: ${(suggestion.chargeTotal / 60).toStringAsFixed(1)}h'),
              Text('Par jour: ${suggestion.chargeParJour.toStringAsFixed(1)} min'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              for (var task in suggestion.tasks) {
                _service.addTask(task);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Planning appliqué !')),
              );
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  void _showAlertsDialog(List<WorkloadAlert> alerts) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alertes de Surcharge'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: alerts.map((alert) {
              return ListTile(
                leading: Icon(
                  alert.severite == 'critical' ? Icons.error : Icons.warning,
                  color: alert.severite == 'critical' ? Colors.red : Colors.orange,
                ),
                title: Text(_formatDate(alert.date)),
                subtitle: Text(alert.message),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _addManualTask() {
    // TODO: Implémenter dialog d'ajout manuel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité à venir')),
    );
  }

  Color _getTaskColor(String type) {
    switch (type) {
      case 'revision': return Colors.blue;
      case 'developpement': return Colors.purple;
      case 'examen': return Colors.red;
      case 'oral': return Colors.orange;
      case 'repos': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
