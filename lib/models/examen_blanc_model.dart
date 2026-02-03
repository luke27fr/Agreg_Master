/// Modèle pour un examen blanc complet
class ExamenBlanc {
  final String id;
  final String titre;
  final String type; // 'composition_algebre', 'composition_analyse', 'probleme', 'modelisation'
  final int dureeMinutes;
  final List<ExerciceExamen> exercices;
  final int baremeTotal;
  
  ExamenBlanc({
    required this.id,
    required this.titre,
    required this.type,
    required this.dureeMinutes,
    required this.exercices,
    required this.baremeTotal,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'type': type,
    'dureeMinutes': dureeMinutes,
    'exercices': exercices.map((e) => e.toJson()).toList(),
    'baremeTotal': baremeTotal,
  };

  factory ExamenBlanc.fromJson(Map<String, dynamic> json) {
    return ExamenBlanc(
      id: json['id'] as String,
      titre: json['titre'] as String,
      type: json['type'] as String,
      dureeMinutes: json['dureeMinutes'] as int,
      exercices: (json['exercices'] as List<dynamic>)
          .map((e) => ExerciceExamen.fromJson(e as Map<String, dynamic>))
          .toList(),
      baremeTotal: json['baremeTotal'] as int,
    );
  }
}

/// Un exercice dans un examen
class ExerciceExamen {
  final String titre;
  final List<QuestionExamen> questions;
  final int bareme;

  ExerciceExamen({
    required this.titre,
    required this.questions,
    required this.bareme,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'questions': questions.map((q) => q.toJson()).toList(),
    'bareme': bareme,
  };

  factory ExerciceExamen.fromJson(Map<String, dynamic> json) {
    return ExerciceExamen(
      titre: json['titre'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuestionExamen.fromJson(q as Map<String, dynamic>))
          .toList(),
      bareme: json['bareme'] as int,
    );
  }
}

/// Une question dans un exercice
class QuestionExamen {
  final String enonce;
  final String? indication;
  final String? correction;
  final List<String>? pointsCles;
  final int points;

  QuestionExamen({
    required this.enonce,
    this.indication,
    this.correction,
    this.pointsCles,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
    'enonce': enonce,
    'indication': indication,
    'correction': correction,
    'pointsCles': pointsCles,
    'points': points,
  };

  factory QuestionExamen.fromJson(Map<String, dynamic> json) {
    return QuestionExamen(
      enonce: json['enonce'] as String,
      indication: json['indication'] as String?,
      correction: json['correction'] as String?,
      pointsCles: (json['pointsCles'] as List<dynamic>?)?.cast<String>(),
      points: json['points'] as int,
    );
  }
}

/// Résultat d'un examen blanc passé
class ExamenBlancResult {
  final String examenId;
  final String examenTitre;
  final DateTime datePassage;
  final int dureeEffective; // en minutes
  final bool termine; // true si l'examen a été complété
  
  // Scores par exercice
  final Map<int, double> scoresExercices; // index -> score
  final double scoreTotal;
  final double bareme Total;
  
  // Auto-évaluation
  final String? notesEtudiant;
  final Map<int, String> difficultes; // index exercice -> difficulté ressentie
  
  ExamenBlancResult({
    required this.examenId,
    required this.examenTitre,
    required this.datePassage,
    required this.dureeEffective,
    required this.termine,
    required this.scoresExercices,
    required this.scoreTotal,
    required this.baremeTotal,
    this.notesEtudiant,
    this.difficultes = const {},
  });

  double get note() => (scoreTotal / baremeTotal * 20).clamp(0, 20);
  
  String get mention() {
    if (note >= 16) return 'Très bien';
    if (note >= 14) return 'Bien';
    if (note >= 12) return 'Assez bien';
    if (note >= 10) return 'Passable';
    return 'Insuffisant';
  }

  Map<String, dynamic> toJson() => {
    'examenId': examenId,
    'examenTitre': examenTitre,
    'datePassage': datePassage.toIso8601String(),
    'dureeEffective': dureeEffective,
    'termine': termine,
    'scoresExercices': scoresExercices.map((k, v) => MapEntry(k.toString(), v)),
    'scoreTotal': scoreTotal,
    'baremeTotal': baremeTotal,
    'notesEtudiant': notesEtudiant,
    'difficultes': difficultes.map((k, v) => MapEntry(k.toString(), v)),
  };

  factory ExamenBlancResult.fromJson(Map<String, dynamic> json) {
    return ExamenBlancResult(
      examenId: json['examenId'] as String,
      examenTitre: json['examenTitre'] as String,
      datePassage: DateTime.parse(json['datePassage'] as String),
      dureeEffective: json['dureeEffective'] as int,
      termine: json['termine'] as bool,
      scoresExercices: (json['scoresExercices'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(int.parse(k), (v as num).toDouble())),
      scoreTotal: (json['scoreTotal'] as num).toDouble(),
      baremeTotal: (json['baremeTotal'] as num).toDouble(),
      notesEtudiant: json['notesEtudiant'] as String?,
      difficultes: (json['difficultes'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(int.parse(k), v as String)) ?? {},
    );
  }
}

/// Statistiques des examens blancs
class ExamenBlancStatistics {
  final int totalExamens;
  final int examensTermines;
  final double noteMoyenne;
  final double tempsmoyen;
  final Map<String, int> repartitionNotes; // tranche -> nombre
  final List<ExamenBlancResult> meilleurs;

  ExamenBlancStatistics({
    required this.totalExamens,
    required this.examensTermines,
    required this.noteMoyenne,
    required this.tempsMoyen,
    required this.repartitionNotes,
    required this.meilleurs,
  });
}
