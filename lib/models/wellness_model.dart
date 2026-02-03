/// Session d'étude trackée
class StudySession {
  final DateTime debut;
  final DateTime fin;
  final int dureeMinutes;
  final String? activite;
  final int? pausesPrises;
  final int concentrationNote; // 1-5

  StudySession({
    required this.debut,
    required this.fin,
    required this.dureeMinutes,
    this.activite,
    this.pausesPrises,
    required this.concentrationNote,
  });

  Map<String, dynamic> toJson() => {
    'debut': debut.toIso8601String(),
    'fin': fin.toIso8601String(),
    'dureeMinutes': dureeMinutes,
    'activite': activite,
    'pausesPrises': pausesPrises,
    'concentrationNote': concentrationNote,
  };

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      debut: DateTime.parse(json['debut'] as String),
      fin: DateTime.parse(json['fin'] as String),
      dureeMinutes: json['dureeMinutes'] as int,
      activite: json['activite'] as String?,
      pausesPrises: json['pausesPrises'] as int?,
      concentrationNote: json['concentrationNote'] as int,
    );
  }
}

/// Alerte de bien-être
class WellnessAlert {
  final String id;
  final DateTime date;
  final String type; // 'fatigue', 'surcharge', 'pause', 'repos', 'burnout'
  final String severite; // 'info', 'warning', 'critical'
  final String titre;
  final String message;
  final List<String> recommandations;
  final bool dismissed;

  WellnessAlert({
    required this.id,
    required this.date,
    required this.type,
    required this.severite,
    required this.titre,
    required this.message,
    required this.recommandations,
    this.dismissed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'type': type,
    'severite': severite,
    'titre': titre,
    'message': message,
    'recommandations': recommandations,
    'dismissed': dismissed,
  };

  factory WellnessAlert.fromJson(Map<String, dynamic> json) {
    return WellnessAlert(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      severite: json['severite'] as String,
      titre: json['titre'] as String,
      message: json['message'] as String,
      recommandations: (json['recommandations'] as List<dynamic>).cast<String>(),
      dismissed: json['dismissed'] as bool? ?? false,
    );
  }
}

/// Statistiques de bien-être
class WellnessStatistics {
  final int tempsEtudeMoyenParJour; // minutes
  final int nombreSessionsParJour;
  final double concentrationMoyenne;
  final int joursRepos;
  final int alertesActivees;
  final double risqueBurnout; // 0-100

  WellnessStatistics({
    required this.tempsEtudeMoyenParJour,
    required this.nombreSessionsParJour,
    required this.concentrationMoyenne,
    required this.joursRepos,
    required this.alertesActivees,
    required this.risqueBurnout,
  });

  String get niveauRisque {
    if (risqueBurnout >= 75) return 'Élevé';
    if (risqueBurnout >= 50) return 'Moyen';
    if (risqueBurnout >= 25) return 'Faible';
    return 'Très faible';
  }

  int get couleurRisqueValue {
    if (risqueBurnout >= 75) return 0xFFD32F2F;
    if (risqueBurnout >= 50) return 0xFFFF9800;
    if (risqueBurnout >= 25) return 0xFFFFC107;
    return 0xFF4CAF50;
  }
}
