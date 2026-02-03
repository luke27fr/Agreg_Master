/// Modèle pour représenter une tâche planifiée
class PlannedTask {
  final String id;
  final String titre;
  final String type; // 'revision', 'developpement', 'examen', 'oral', 'repos'
  final DateTime dateDebut;
  final DateTime dateFin;
  final int dureeMinutes;
  final int priorite; // 1-5
  final String? leconId;
  final String? description;
  final bool completed;
  final String? notesCompletion;

  PlannedTask({
    required this.id,
    required this.titre,
    required this.type,
    required this.dateDebut,
    required this.dateFin,
    required this.dureeMinutes,
    this.priorite = 3,
    this.leconId,
    this.description,
    this.completed = false,
    this.notesCompletion,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'type': type,
    'dateDebut': dateDebut.toIso8601String(),
    'dateFin': dateFin.toIso8601String(),
    'dureeMinutes': dureeMinutes,
    'priorite': priorite,
    'leconId': leconId,
    'description': description,
    'completed': completed,
    'notesCompletion': notesCompletion,
  };

  factory PlannedTask.fromJson(Map<String, dynamic> json) {
    return PlannedTask(
      id: json['id'] as String,
      titre: json['titre'] as String,
      type: json['type'] as String,
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      dureeMinutes: json['dureeMinutes'] as int,
      priorite: json['priorite'] as int? ?? 3,
      leconId: json['leconId'] as String?,
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
      notesCompletion: json['notesCompletion'] as String?,
    );
  }

  PlannedTask copyWith({
    bool? completed,
    String? notesCompletion,
  }) {
    return PlannedTask(
      id: id,
      titre: titre,
      type: type,
      dateDebut: dateDebut,
      dateFin: dateFin,
      dureeMinutes: dureeMinutes,
      priorite: priorite,
      leconId: leconId,
      description: description,
      completed: completed ?? this.completed,
      notesCompletion: notesCompletion ?? this.notesCompletion,
    );
  }
}

/// Configuration du planificateur
class PlannerConfig {
  final DateTime dateExamen; // Date du concours
  final int heuresParJour; // Heures de travail par jour
  final List<int> joursRepos; // Jours de repos (0=dimanche, 6=samedi)
  final Map<String, int> prioritesDomaines; // domaine -> priorité
  final bool inclureRepos;
  final int dureeSessionMin;

  PlannerConfig({
    required this.dateExamen,
    this.heuresParJour = 6,
    this.joursRepos = const [0], // Dimanche par défaut
    this.prioritesDomaines = const {},
    this.inclureRepos = true,
    this.dureeSessionMin = 120,
  });

  Map<String, dynamic> toJson() => {
    'dateExamen': dateExamen.toIso8601String(),
    'heuresParJour': heuresParJour,
    'joursRepos': joursRepos,
    'prioritesDomaines': prioritesDomaines,
    'inclureRepos': inclureRepos,
    'dureeSessionMin': dureeSessionMin,
  };

  factory PlannerConfig.fromJson(Map<String, dynamic> json) {
    return PlannerConfig(
      dateExamen: DateTime.parse(json['dateExamen'] as String),
      heuresParJour: json['heuresParJour'] as int? ?? 6,
      joursRepos: (json['joursRepos'] as List<dynamic>?)?.cast<int>() ?? [0],
      prioritesDomaines: (json['prioritesDomaines'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)) ?? {},
      inclureRepos: json['inclureRepos'] as bool? ?? true,
      dureeSessionMin: json['dureeSessionMin'] as int? ?? 120,
    );
  }
}

/// Suggestion de planning
class PlanningSuggestion {
  final String nom;
  final String description;
  final List<PlannedTask> tasks;
  final int chargeTotal; // Minutes totales
  final DateTime dateDebut;
  final DateTime dateFin;
  final Map<String, int> repartitionDomaines; // domaine -> minutes

  PlanningSuggestion({
    required this.nom,
    required this.description,
    required this.tasks,
    required this.chargeTotal,
    required this.dateDebut,
    required this.dateFin,
    required this.repartitionDomaines,
  });

  int get nombreJours => dateFin.difference(dateDebut).inDays + 1;
  double get chargeParJour => chargeTotal / nombreJours;
}

/// Alerte de surcharge
class WorkloadAlert {
  final DateTime date;
  final int chargeMinutes;
  final int capaciteMinutes;
  final String message;
  final String severite; // 'info', 'warning', 'critical'

  WorkloadAlert({
    required this.date,
    required this.chargeMinutes,
    required this.capaciteMinutes,
    required this.message,
    required this.severite,
  });

  double get tauxCharge => chargeMinutes / capaciteMinutes;
}
