class Annale {
  final String id;
  final int annee;
  final String session; // 'externe' ou 'interne'
  final String typeEpreuve; // 'ecrit1', 'ecrit2', 'oral1', 'oral2'
  final String titre;
  final String? description;
  final List<ExerciceAnnale> exercices;
  final int dureeMinutes;
  final int? baremeTotal;
  final List<String> themes; // ['Algèbre', 'Analyse', etc.]
  final String? urlSujet; // Lien vers le sujet officiel (PDF)
  final String? urlCorrige; // Lien vers le corrigé (PDF)
  final String? urlRapport; // Lien vers le rapport du jury (PDF)
  final String? urlOfficielle; // Page officielle du ministère
  final String? urlCorrection; // Legacy
  final String difficulte; // 'Facile', 'Moyen', 'Difficile', 'Très difficile'
  final List<String>? motsClefs;
  final String? rapportGlobal; // Résumé du rapport du jury
  final List<String>? parties; // Structure du sujet : ['Partie I - Titre', ...]

  Annale({
    required this.id,
    required this.annee,
    required this.session,
    required this.typeEpreuve,
    required this.titre,
    this.description,
    this.exercices = const [],
    required this.dureeMinutes,
    this.baremeTotal,
    required this.themes,
    this.urlSujet,
    this.urlCorrige,
    this.urlRapport,
    this.urlOfficielle,
    this.urlCorrection,
    required this.difficulte,
    this.motsClefs,
    this.rapportGlobal,
    this.parties,
  });

  factory Annale.fromJson(Map<String, dynamic> json) {
    return Annale(
      id: json['id'] as String,
      annee: json['annee'] as int,
      session: json['session'] as String,
      typeEpreuve: json['typeEpreuve'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      exercices: json['exercices'] != null
          ? (json['exercices'] as List)
              .map((e) => ExerciceAnnale.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : const [],
      dureeMinutes: json['dureeMinutes'] as int,
      baremeTotal: json['baremeTotal'] as int?,
      themes: (json['themes'] as List).cast<String>(),
      urlSujet: json['urlSujet'] as String?,
      urlCorrige: json['urlCorrige'] as String?,
      urlRapport: json['urlRapport'] as String?,
      urlOfficielle: json['urlOfficielle'] as String?,
      urlCorrection: json['urlCorrection'] as String?,
      difficulte: json['difficulte'] as String,
      motsClefs: json['motsClefs'] != null 
          ? (json['motsClefs'] as List).cast<String>() 
          : null,
      rapportGlobal: json['rapportGlobal'] as String?,
      parties: json['parties'] != null
          ? (json['parties'] as List).cast<String>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'annee': annee,
      'session': session,
      'typeEpreuve': typeEpreuve,
      'titre': titre,
      'description': description,
      'exercices': exercices.map((e) => e.toJson()).toList(),
      'dureeMinutes': dureeMinutes,
      'baremeTotal': baremeTotal,
      'themes': themes,
      'urlSujet': urlSujet,
      'urlCorrige': urlCorrige,
      'urlRapport': urlRapport,
      'urlOfficielle': urlOfficielle,
      'urlCorrection': urlCorrection,
      'difficulte': difficulte,
      'motsClefs': motsClefs,
      'rapportGlobal': rapportGlobal,
      'parties': parties,
    };
  }

  String get typeLabel {
    switch (typeEpreuve) {
      case 'ecrit1':
        return 'Épreuve 1 – Mathématiques générales';
      case 'ecrit2':
        return 'Épreuve 2 – Analyse et probabilités';
      case 'oral1':
        return 'Oral 1 – Leçon';
      case 'oral2':
        return 'Oral 2 – Modélisation';
      default:
        return typeEpreuve;
    }
  }
}

class ExerciceAnnale {
  final String titre;
  final String? introduction;
  final List<QuestionAnnale> questions;
  final int? bareme;
  final List<String>? themes;

  ExerciceAnnale({
    required this.titre,
    this.introduction,
    required this.questions,
    this.bareme,
    this.themes,
  });

  factory ExerciceAnnale.fromJson(Map<String, dynamic> json) {
    return ExerciceAnnale(
      titre: json['titre'] as String,
      introduction: json['introduction'] as String?,
      questions: (json['questions'] as List)
          .map((q) => QuestionAnnale.fromJson(Map<String, dynamic>.from(q as Map)))
          .toList(),
      bareme: json['bareme'] as int?,
      themes: json['themes'] != null 
          ? (json['themes'] as List).cast<String>() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'introduction': introduction,
      'questions': questions.map((q) => q.toJson()).toList(),
      'bareme': bareme,
      'themes': themes,
    };
  }
}

class QuestionAnnale {
  final String enonce;
  final String? indication;
  final String? correction;
  final int? points;
  final List<String>? sousQuestions;
  final String? rapportJury; // Commentaires et attentes du jury

  QuestionAnnale({
    required this.enonce,
    this.indication,
    this.correction,
    this.points,
    this.sousQuestions,
    this.rapportJury,
  });

  factory QuestionAnnale.fromJson(Map<String, dynamic> json) {
    return QuestionAnnale(
      enonce: json['enonce'] as String,
      indication: json['indication'] as String?,
      correction: json['correction'] as String?,
      points: json['points'] as int?,
      sousQuestions: json['sousQuestions'] != null 
          ? (json['sousQuestions'] as List).cast<String>() 
          : null,
      rapportJury: json['rapportJury'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enonce': enonce,
      'indication': indication,
      'correction': correction,
      'points': points,
      'sousQuestions': sousQuestions,
      'rapportJury': rapportJury,
    };
  }
}
