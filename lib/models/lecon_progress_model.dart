/// Modèle pour suivre la progression sur une leçon d'oral
class LeconProgress {
  final String leconId;
  final String leconNumero;
  final String leconTitre;
  final String domaine;
  
  // Développements
  int developpementsMaitrises; // 0-2
  List<String> developpementsChoisis;
  
  // Progression générale
  DateTime? derniereRevision;
  int tempsEtudeMinutes;
  int nombreRevisions;
  
  // Niveau de maîtrise (0-100)
  int niveauPlan; // Maîtrise du plan général
  int niveauDeveloppements; // Maîtrise des développements
  int niveauExemples; // Maîtrise des exemples
  int niveauReferencesBiblio; // Connaissance des références
  
  // Notes personnelles
  String? notes;
  List<String> pointsForts;
  List<String> pointsFaibles;
  
  // Historique des présentations
  List<PresentationHistory> historiquePresentations;

  LeconProgress({
    required this.leconId,
    required this.leconNumero,
    required this.leconTitre,
    required this.domaine,
    this.developpementsMaitrises = 0,
    this.developpementsChoisis = const [],
    this.derniereRevision,
    this.tempsEtudeMinutes = 0,
    this.nombreRevisions = 0,
    this.niveauPlan = 0,
    this.niveauDeveloppements = 0,
    this.niveauExemples = 0,
    this.niveauReferencesBiblio = 0,
    this.notes,
    this.pointsForts = const [],
    this.pointsFaibles = const [],
    this.historiquePresentations = const [],
  });

  /// Calcule le niveau de maîtrise global (0-100)
  int getMasteryLevel() {
    return ((niveauPlan + niveauDeveloppements + niveauExemples + niveauReferencesBiblio) / 4).round();
  }

  /// Retourne le statut de la leçon
  String getStatus() {
    final mastery = getMasteryLevel();
    if (mastery >= 80) return 'Expert';
    if (mastery >= 60) return 'Avancé';
    if (mastery >= 40) return 'Intermédiaire';
    if (mastery >= 20) return 'Débutant';
    return 'Non commencé';
  }

  /// Vérifie si la leçon est prête pour l'oral
  bool isReadyForOral() {
    return niveauPlan >= 80 &&
           niveauDeveloppements >= 80 &&
           developpementsMaitrises >= 2 &&
           niveauExemples >= 60;
  }

  Map<String, dynamic> toJson() => {
    'leconId': leconId,
    'leconNumero': leconNumero,
    'leconTitre': leconTitre,
    'domaine': domaine,
    'developpementsMaitrises': developpementsMaitrises,
    'developpementsChoisis': developpementsChoisis,
    'derniereRevision': derniereRevision?.toIso8601String(),
    'tempsEtudeMinutes': tempsEtudeMinutes,
    'nombreRevisions': nombreRevisions,
    'niveauPlan': niveauPlan,
    'niveauDeveloppements': niveauDeveloppements,
    'niveauExemples': niveauExemples,
    'niveauReferencesBiblio': niveauReferencesBiblio,
    'notes': notes,
    'pointsForts': pointsForts,
    'pointsFaibles': pointsFaibles,
    'historiquePresentations': historiquePresentations.map((e) => e.toJson()).toList(),
  };

  factory LeconProgress.fromJson(Map<String, dynamic> json) {
    return LeconProgress(
      leconId: json['leconId'] as String,
      leconNumero: json['leconNumero'] as String,
      leconTitre: json['leconTitre'] as String,
      domaine: json['domaine'] as String,
      developpementsMaitrises: json['developpementsMaitrises'] as int? ?? 0,
      developpementsChoisis: (json['developpementsChoisis'] as List<dynamic>?)?.cast<String>() ?? [],
      derniereRevision: json['derniereRevision'] != null 
          ? DateTime.parse(json['derniereRevision'] as String)
          : null,
      tempsEtudeMinutes: json['tempsEtudeMinutes'] as int? ?? 0,
      nombreRevisions: json['nombreRevisions'] as int? ?? 0,
      niveauPlan: json['niveauPlan'] as int? ?? 0,
      niveauDeveloppements: json['niveauDeveloppements'] as int? ?? 0,
      niveauExemples: json['niveauExemples'] as int? ?? 0,
      niveauReferencesBiblio: json['niveauReferencesBiblio'] as int? ?? 0,
      notes: json['notes'] as String?,
      pointsForts: (json['pointsForts'] as List<dynamic>?)?.cast<String>() ?? [],
      pointsFaibles: (json['pointsFaibles'] as List<dynamic>?)?.cast<String>() ?? [],
      historiquePresentations: (json['historiquePresentations'] as List<dynamic>?)
          ?.map((e) => PresentationHistory.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  LeconProgress copyWith({
    int? developpementsMaitrises,
    List<String>? developpementsChoisis,
    DateTime? derniereRevision,
    int? tempsEtudeMinutes,
    int? nombreRevisions,
    int? niveauPlan,
    int? niveauDeveloppements,
    int? niveauExemples,
    int? niveauReferencesBiblio,
    String? notes,
    List<String>? pointsForts,
    List<String>? pointsFaibles,
    List<PresentationHistory>? historiquePresentations,
  }) {
    return LeconProgress(
      leconId: leconId,
      leconNumero: leconNumero,
      leconTitre: leconTitre,
      domaine: domaine,
      developpementsMaitrises: developpementsMaitrises ?? this.developpementsMaitrises,
      developpementsChoisis: developpementsChoisis ?? this.developpementsChoisis,
      derniereRevision: derniereRevision ?? this.derniereRevision,
      tempsEtudeMinutes: tempsEtudeMinutes ?? this.tempsEtudeMinutes,
      nombreRevisions: nombreRevisions ?? this.nombreRevisions,
      niveauPlan: niveauPlan ?? this.niveauPlan,
      niveauDeveloppements: niveauDeveloppements ?? this.niveauDeveloppements,
      niveauExemples: niveauExemples ?? this.niveauExemples,
      niveauReferencesBiblio: niveauReferencesBiblio ?? this.niveauReferencesBiblio,
      notes: notes ?? this.notes,
      pointsForts: pointsForts ?? this.pointsForts,
      pointsFaibles: pointsFaibles ?? this.pointsFaibles,
      historiquePresentations: historiquePresentations ?? this.historiquePresentations,
    );
  }
}

/// Historique d'une présentation de leçon
class PresentationHistory {
  final DateTime date;
  final int dureeMinutes;
  final int noteGlobale; // 0-20
  final String commentaire;
  final bool simulationComplete;

  PresentationHistory({
    required this.date,
    required this.dureeMinutes,
    required this.noteGlobale,
    required this.commentaire,
    this.simulationComplete = false,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'dureeMinutes': dureeMinutes,
    'noteGlobale': noteGlobale,
    'commentaire': commentaire,
    'simulationComplete': simulationComplete,
  };

  factory PresentationHistory.fromJson(Map<String, dynamic> json) {
    return PresentationHistory(
      date: DateTime.parse(json['date'] as String),
      dureeMinutes: json['dureeMinutes'] as int,
      noteGlobale: json['noteGlobale'] as int,
      commentaire: json['commentaire'] as String,
      simulationComplete: json['simulationComplete'] as bool? ?? false,
    );
  }
}

/// Statistiques globales par domaine
class DomaineStatistics {
  final String domaine;
  final int totalLecons;
  final int leconsCommencees;
  final int leconsReady;
  final double averageMastery;
  final int tempsTotal;

  DomaineStatistics({
    required this.domaine,
    required this.totalLecons,
    required this.leconsCommencees,
    required this.leconsReady,
    required this.averageMastery,
    required this.tempsTotal,
  });
}
