import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/score_service.dart';

class PlanificateurPage extends StatefulWidget {
  const PlanificateurPage({super.key});

  @override
  State<PlanificateurPage> createState() => _PlanificateurPageState();
}

class _PlanificateurPageState extends State<PlanificateurPage> {
  DateTime _selectedDate = DateTime.now();
  final Map<String, List<PlanItem>> _planItems = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    try {
      final content = await StorageService.instance.read('agreg_master_plan.json');
      if (content != null) {
        final Map<String, dynamic> data = jsonDecode(content);
        _planItems.clear();
        data.forEach((key, value) {
          _planItems[key] = (value as List)
              .map((item) => PlanItem.fromJson(item))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement plan: $e');
    }
    setState(() => _loading = false);
  }

  Future<void> _savePlan() async {
    try {
      final data = _planItems.map((key, value) => 
          MapEntry(key, value.map((item) => item.toJson()).toList()));
      await StorageService.instance.write('agreg_master_plan.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde plan: $e');
    }
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<PlanItem> _getItemsForDate(DateTime date) {
    return _planItems[_dateKey(date)] ?? [];
  }

  void _addItem(DateTime date, PlanItem item) {
    final key = _dateKey(date);
    _planItems[key] = [...(_planItems[key] ?? []), item];
    _savePlan();
    setState(() {});
  }

  void _toggleItem(DateTime date, int index) {
    final key = _dateKey(date);
    if (_planItems[key] != null && index < _planItems[key]!.length) {
      _planItems[key]![index].completed = !_planItems[key]![index].completed;
      _savePlan();
      setState(() {});
    }
  }

  void _deleteItem(DateTime date, int index) {
    final key = _dateKey(date);
    if (_planItems[key] != null && index < _planItems[key]!.length) {
      _planItems[key]!.removeAt(index);
      _savePlan();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = _getItemsForDate(_selectedDate);
    final completedCount = items.where((i) => i.completed).length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Planificateur', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () => _showSuggestions(context),
            tooltip: 'Suggestions',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Calendrier simplifié
                _buildCalendarHeader(isDark),
                _buildWeekView(isDark),
                
                // Statistiques du jour
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: items.isEmpty ? 0 : completedCount / items.length,
                                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(Colors.green),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$completedCount/${items.length} tâches complétées',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Liste des tâches
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Aucune tâche pour ce jour',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _showAddDialog(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter une tâche'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return _buildTaskCard(items[index], index, isDark);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 7));
              });
            },
          ),
          Text(
            _formatMonth(_selectedDate),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 7));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(bool isDark) {
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected = _dateKey(date) == _dateKey(_selectedDate);
          final hasItems = (_planItems[_dateKey(date)] ?? []).isNotEmpty;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 45,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1A237E)
                    : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _getDayName(date.weekday),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  if (hasItems) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTaskCard(PlanItem item, int index, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: item.completed,
          onChanged: (_) => _toggleItem(_selectedDate, index),
          activeColor: Colors.green,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            color: item.completed ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          _getTypeLabel(item.type),
          style: TextStyle(color: _getTypeColor(item.type), fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteItem(_selectedDate, index),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    String title = '';
    String type = 'lecon';
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvelle tâche'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Ex: Revoir leçon 101',
                ),
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'lecon', child: Text('Leçon')),
                  DropdownMenuItem(value: 'developpement', child: Text('Développement')),
                  DropdownMenuItem(value: 'exercice', child: Text('Exercice')),
                  DropdownMenuItem(value: 'fiche', child: Text('Fiche')),
                  DropdownMenuItem(value: 'autre', child: Text('Autre')),
                ],
                onChanged: (value) => setDialogState(() => type = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  _addItem(_selectedDate, PlanItem(title: title, type: type));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuggestions(BuildContext context) {
    final scoreService = ScoreService();
    final toReview = scoreService.getFichesToReview();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suggestions de révision',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (toReview.isEmpty)
              const Text('Aucune suggestion pour le moment.')
            else
              ...toReview.take(5).map((entry) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getScoreColor(entry.value.percentage),
                  child: Text(
                    '${entry.value.percentage.round()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                title: Text(entry.key),
                subtitle: Text('Dernière révision: ${_formatDateShort(entry.value.date)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    _addItem(_selectedDate, PlanItem(
                      title: 'Réviser: ${entry.key}',
                      type: 'fiche',
                    ));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tâche ajoutée')),
                    );
                  },
                ),
              )),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    const mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 
                  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
    return '${jours[date.weekday - 1]} ${date.day} ${mois[date.month - 1]}';
  }

  String _formatMonth(DateTime date) {
    const mois = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
                  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    return '${mois[date.month - 1]} ${date.year}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}';
  }

  String _getDayName(int weekday) {
    const jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return jours[weekday - 1];
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'lecon': return 'Leçon';
      case 'developpement': return 'Développement';
      case 'exercice': return 'Exercice';
      case 'fiche': return 'Fiche';
      default: return 'Autre';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'lecon': return Colors.blue;
      case 'developpement': return Colors.purple;
      case 'exercice': return Colors.orange;
      case 'fiche': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}

class PlanItem {
  String title;
  String type;
  bool completed;

  PlanItem({
    required this.title,
    required this.type,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'type': type,
    'completed': completed,
  };

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
    title: json['title'],
    type: json['type'],
    completed: json['completed'] ?? false,
  );
}
