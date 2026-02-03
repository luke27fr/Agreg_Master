/// Question du jury virtuel
class JuryQuestion {
  final String id;
  final String question;
  final String categorie; // 'definition', 'exemple', 'lien', 'contre-exemple', 'generalisation', 'application'
  final List<String> motsCles;
  final String? reponseType; // 'courte', 'developpement', 'calcul'
  final String? indicePedagogique;
  final int difficulte; // 1-5
  final List<String>? pointsCles; // Points attendus dans la réponse

  JuryQuestion({
    required this.id,
    required this.question,
    required this.categorie,
    required this.motsCles,
    this.reponseType,
    this.indicePedagogique,
    this.difficulte = 3,
    this.pointsCles,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'categorie': categorie,
    'motsCles': motsCles,
    'reponseType': reponseType,
    'indicePedagogique': indicePedagogique,
    'difficulte': difficulte,
    'pointsCles': pointsCles,
  };

  factory JuryQuestion.fromJson(Map<String, dynamic> json) {
    return JuryQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      categorie: json['categorie'] as String,
      motsCles: (json['motsCles'] as List<dynamic>).cast<String>(),
      reponseType: json['reponseType'] as String?,
      indicePedagogique: json['indicePedagogique'] as String?,
      difficulte: json['difficulte'] as int? ?? 3,
      pointsCles: (json['pointsCles'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

/// Session de jury virtuel
class JurySession {
  final String id;
  final String leconId;
  final String leconTitre;
  final DateTime dateDebut;
  final List<JuryQuestionAnswer> questionsReponses;
  final int dureeMinutes;
  final bool terminee;
  
  JurySession({
    required this.id,
    required this.leconId,
    required this.leconTitre,
    required this.dateDebut,
    required this.questionsReponses,
    required this.dureeMinutes,
    this.terminee = false,
  });

  double get scoreQualite {
    if (questionsReponses.isEmpty) return 0;
    final total = questionsReponses
        .map((qa) => qa.autoEvaluation ?? 0)
        .fold(0, (a, b) => a + b);
    return total / questionsReponses.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'leconId': leconId,
    'leconTitre': leconTitre,
    'dateDebut': dateDebut.toIso8601String(),
    'questionsReponses': questionsReponses.map((qa) => qa.toJson()).toList(),
    'dureeMinutes': dureeMinutes,
    'terminee': terminee,
  };

  factory JurySession.fromJson(Map<String, dynamic> json) {
    return JurySession(
      id: json['id'] as String,
      leconId: json['leconId'] as String,
      leconTitre: json['leconTitre'] as String,
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      questionsReponses: (json['questionsReponses'] as List<dynamic>)
          .map((qa) => JuryQuestionAnswer.fromJson(qa as Map<String, dynamic>))
          .toList(),
      dureeMinutes: json['dureeMinutes'] as int,
      terminee: json['terminee'] as bool? ?? false,
    );
  }
}

/// Réponse à une question du jury
class JuryQuestionAnswer {
  final JuryQuestion question;
  final DateTime heureQuestion;
  final int tempsReponseSecondes;
  final int? autoEvaluation; // 1-5 (1=mauvais, 5=excellent)
  final String? notesPersonnelles;

  JuryQuestionAnswer({
    required this.question,
    required this.heureQuestion,
    required this.tempsReponseSecondes,
    this.autoEvaluation,
    this.notesPersonnelles,
  });

  Map<String, dynamic> toJson() => {
    'question': question.toJson(),
    'heureQuestion': heureQuestion.toIso8601String(),
    'tempsReponseSecondes': tempsReponseSecondes,
    'autoEvaluation': autoEvaluation,
    'notesPersonnelles': notesPersonnelles,
  };

  factory JuryQuestionAnswer.fromJson(Map<String, dynamic> json) {
    return JuryQuestionAnswer(
      question: JuryQuestion.fromJson(json['question'] as Map<String, dynamic>),
      heureQuestion: DateTime.parse(json['heureQuestion'] as String),
      tempsReponseSecondes: json['tempsReponseSecondes'] as int,
      autoEvaluation: json['autoEvaluation'] as int?,
      notesPersonnelles: json['notesPersonnelles'] as String?,
    );
  }
}

/// Statistiques du jury virtuel
class JuryStatistics {
  final int totalSessions;
  final int totalQuestions;
  final double tempsReponseMoyen;
  final double scoreQualiteMoyen;
  final Map<String, int> repartitionCategories;
  final List<String> categoriesDifficiles; // Catégories avec score faible

  JuryStatistics({
    required this.totalSessions,
    required this.totalQuestions,
    required this.tempsReponseMoyen,
    required this.scoreQualiteMoyen,
    required this.repartitionCategories,
    required this.categoriesDifficiles,
  });
}
