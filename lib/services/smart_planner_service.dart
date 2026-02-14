import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../models/smart_planner_model.dart';
import 'lecon_progress_service.dart';
import 'spaced_repetition_service.dart';

class SmartPlannerService extends ChangeNotifier {
  static final SmartPlannerService _instance = SmartPlannerService._internal();
  factory SmartPlannerService() => _instance;
  SmartPlannerService._internal();

  List<PlannedTask> _tasks = [];
  PlannerConfig? _config;

  List<PlannedTask> get tasks => _tasks;
  PlannerConfig? get config => _config;

  /// Configure le planificateur
  Future<void> setConfig(PlannerConfig config) async {
    _config = config;
    await _saveConfig();
    notifyListeners();
  }

  /// Génère un planning intelligent basé sur la config
  PlanningSuggestion generateSmartPlanning() {
    if (_config == null) {
      throw Exception('Configuration non définie');
    }

    final tasks = <PlannedTask>[];
    final now = DateTime.now();
    
    // Récupérer les données des services
    final progressService = LeconProgressService();
    final srsService = SpacedRepetitionService();
    
    // 1. Ajouter les révisions SRS urgentes
    final dueCards = srsService.getDueCards();
    for (var card in dueCards.take(5)) {
      tasks.add(PlannedTask(
        id: 'srs_${card.ficheId}_${DateTime.now().millisecondsSinceEpoch}',
        titre: 'Révision SRS: ${card.ficheId}',
        type: 'revision',
        dateDebut: now,
        dateFin: now.add(const Duration(minutes: 30)),
        dureeMinutes: 30,
        priorite: 5,
        leconId: card.ficheId,
      ));
    }

    // 2. Ajouter les leçons prioritaires
    final priorityLecons = progressService.getPriorityLecons(limit: 10);
    var currentDate = now.add(const Duration(days: 1));
    
    for (var i = 0; i < priorityLecons.length && tasks.length < 30; i++) {
      final lecon = priorityLecons[i];
      
      // Éviter les jours de repos
      while (_config!.joursRepos.contains(currentDate.weekday % 7)) {
        currentDate = currentDate.add(const Duration(days: 1));
      }
      
      final duree = _config!.dureeSessionMin;
      tasks.add(PlannedTask(
        id: 'lecon_${lecon.leconId}_${currentDate.millisecondsSinceEpoch}',
        titre: 'Leçon ${lecon.leconNumero}: ${lecon.leconTitre}',
        type: 'developpement',
        dateDebut: currentDate.add(const Duration(hours: 9)),
        dateFin: currentDate.add(Duration(hours: 9, minutes: duree)),
        dureeMinutes: duree,
        priorite: 5 - (lecon.getMasteryLevel() ~/ 20),
        leconId: lecon.leconId,
        description: 'Niveau actuel: ${lecon.getStatus()}',
      ));
      
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // 3. Planifier des examens blancs (1 par semaine)
    var examenDate = now.add(const Duration(days: 7));
    while (examenDate.isBefore(_config!.dateExamen.subtract(const Duration(days: 14)))) {
      tasks.add(PlannedTask(
        id: 'examen_${examenDate.millisecondsSinceEpoch}',
        titre: 'Examen Blanc',
        type: 'examen',
        dateDebut: examenDate.add(const Duration(hours: 9)),
        dateFin: examenDate.add(const Duration(hours: 14)),
        dureeMinutes: 300,
        priorite: 5,
        description: 'Conditions réelles - 5 heures',
      ));
      examenDate = examenDate.add(const Duration(days: 7));
    }

    // 4. Ajouter des pauses si configuré
    if (_config!.inclureRepos) {
      for (var task in tasks) {
        if (task.dureeMinutes >= 120) {
          // Suggérer une pause après les longues sessions
          tasks.add(PlannedTask(
            id: 'pause_${task.id}',
            titre: 'Pause',
            type: 'repos',
            dateDebut: task.dateFin,
            dateFin: task.dateFin.add(const Duration(minutes: 15)),
            dureeMinutes: 15,
            priorite: 1,
          ));
        }
      }
    }

    // Calculer les statistiques
    final chargeTotal = tasks.fold(0, (sum, task) => sum + task.dureeMinutes);
    final repartition = <String, int>{};
    
    for (var task in tasks) {
      final type = task.type;
      repartition[type] = (repartition[type] ?? 0) + task.dureeMinutes;
    }

    return PlanningSuggestion(
      nom: 'Planning Intelligent',
      description: 'Planning optimisé jusqu\'au ${_formatDate(_config!.dateExamen)}',
      tasks: tasks,
      chargeTotal: chargeTotal,
      dateDebut: now,
      dateFin: _config!.dateExamen,
      repartitionDomaines: repartition,
    );
  }

  /// Détecte les alertes de surcharge
  List<WorkloadAlert> detectWorkloadAlerts() {
    if (_config == null) return [];

    final alerts = <WorkloadAlert>[];
    final tasksByDate = <DateTime, List<PlannedTask>>{};

    // Grouper par jour
    for (var task in _tasks) {
      final date = DateTime(task.dateDebut.year, task.dateDebut.month, task.dateDebut.day);
      tasksByDate.putIfAbsent(date, () => []).add(task);
    }

    // Vérifier la charge de chaque jour
    for (var entry in tasksByDate.entries) {
      final charge = entry.value.fold(0, (sum, task) => sum + task.dureeMinutes);
      final capacite = _config!.heuresParJour * 60;

      if (charge > capacite * 1.5) {
        alerts.add(WorkloadAlert(
          date: entry.key,
          chargeMinutes: charge,
          capaciteMinutes: capacite,
          message: 'Surcharge critique: ${(charge / 60).toStringAsFixed(1)}h prévues pour ${(capacite / 60)}h disponibles',
          severite: 'critical',
        ));
      } else if (charge > capacite * 1.2) {
        alerts.add(WorkloadAlert(
          date: entry.key,
          chargeMinutes: charge,
          capaciteMinutes: capacite,
          message: 'Charge élevée: ${(charge / 60).toStringAsFixed(1)}h prévues',
          severite: 'warning',
        ));
      }
    }

    return alerts;
  }

  /// Ajoute une tâche manuelle
  Future<void> addTask(PlannedTask task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  /// Marque une tâche comme complétée
  Future<void> completeTask(String taskId, {String? notes}) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        completed: true,
        notesCompletion: notes,
      );
      await _saveTasks();
      notifyListeners();
    }
  }

  /// Obtient les tâches pour une date
  List<PlannedTask> getTasksForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    return _tasks.where((task) {
      final taskDate = DateTime(task.dateDebut.year, task.dateDebut.month, task.dateDebut.day);
      return taskDate == targetDate;
    }).toList();
  }

  /// Obtient les tâches de la semaine
  List<PlannedTask> getTasksForWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    
    return _tasks.where((task) {
      return task.dateDebut.isAfter(monday.subtract(const Duration(days: 1))) &&
             task.dateDebut.isBefore(sunday.add(const Duration(days: 1)));
    }).toList();
  }

  // Persistance
  Future<void> loadData() async {
    await Future.wait([
      _loadTasks(),
      _loadConfig(),
    ]);
  }

  Future<void> _loadTasks() async {
    try {
      final content = await StorageService.instance.read('planned_tasks.json');
      if (content != null) {
        final data = jsonDecode(content) as List<dynamic>;
        _tasks = data
            .map((e) => PlannedTask.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement tâches: $e');
    }
  }

  Future<void> _loadConfig() async {
    try {
      final content = await StorageService.instance.read('planner_config.json');
      if (content != null) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        _config = PlannerConfig.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement config: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      final data = _tasks.map((e) => e.toJson()).toList();
      await StorageService.instance.write('planned_tasks.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde tâches: $e');
    }
  }

  Future<void> _saveConfig() async {
    try {
      if (_config != null) {
        await StorageService.instance.write('planner_config.json', jsonEncode(_config!.toJson()));
      }
    } catch (e) {
      debugPrint('Erreur sauvegarde config: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
