/// Profil utilisateur anonymisé pour la compétition
class AnonymousProfile {
  final String pseudonyme;
  final String? avatar; // emoji ou initiale
  final DateTime dateInscription;
  final Map<String, double> statsPubliques; // stat -> valeur
  
  AnonymousProfile({
    required this.pseudonyme,
    this.avatar,
    required this.dateInscription,
    required this.statsPubliques,
  });

  Map<String, dynamic> toJson() => {
    'pseudonyme': pseudonyme,
    'avatar': avatar,
    'dateInscription': dateInscription.toIso8601String(),
    'statsPubliques': statsPubliques,
  };

  factory AnonymousProfile.fromJson(Map<String, dynamic> json) {
    return AnonymousProfile(
      pseudonyme: json['pseudonyme'] as String,
      avatar: json['avatar'] as String?,
      dateInscription: DateTime.parse(json['dateInscription'] as String),
      statsPubliques: (json['statsPubliques'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}

/// Classement global
class Leaderboard {
  final String periode; // 'jour', 'semaine', 'mois', 'all-time'
  final List<LeaderboardEntry> entries;
  final DateTime lastUpdate;

  Leaderboard({
    required this.periode,
    required this.entries,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => {
    'periode': periode,
    'entries': entries.map((e) => e.toJson()).toList(),
    'lastUpdate': lastUpdate.toIso8601String(),
  };

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      periode: json['periode'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );
  }
}

/// Entrée dans le classement
class LeaderboardEntry {
  final int rang;
  final String pseudonyme;
  final String? avatar;
  final double score;
  final Map<String, dynamic> details; // Détails publics
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rang,
    required this.pseudonyme,
    this.avatar,
    required this.score,
    required this.details,
    this.isCurrentUser = false,
  });

  Map<String, dynamic> toJson() => {
    'rang': rang,
    'pseudonyme': pseudonyme,
    'avatar': avatar,
    'score': score,
    'details': details,
    'isCurrentUser': isCurrentUser,
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rang: json['rang'] as int,
      pseudonyme: json['pseudonyme'] as String,
      avatar: json['avatar'] as String?,
      score: (json['score'] as num).toDouble(),
      details: json['details'] as Map<String, dynamic>,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }
}

/// Comparaison avec la moyenne
class ComparisonStats {
  final String categorie;
  final double valeurUtilisateur;
  final double moyenneNationale;
  final double percentile; // 0-100, où se situe l'utilisateur
  final String tendance; // 'superieur', 'moyen', 'inferieur'

  ComparisonStats({
    required this.categorie,
    required this.valeurUtilisateur,
    required this.moyenneNationale,
    required this.percentile,
    required this.tendance,
  });

  double get ecartMoyenne => valeurUtilisateur - moyenneNationale;
  
  String get interpretationPercentile {
    if (percentile >= 90) return 'Top 10%';
    if (percentile >= 75) return 'Top 25%';
    if (percentile >= 50) return 'Moyenne haute';
    if (percentile >= 25) return 'Moyenne basse';
    return 'À améliorer';
  }
}

/// Défi / Challenge
class Challenge {
  final String id;
  final String titre;
  final String description;
  final String type; // 'quiz', 'streak', 'lecons', 'examens'
  final DateTime dateDebut;
  final DateTime dateFin;
  final Map<String, dynamic> objectif;
  final int pointsRecompense;
  final bool isActive;

  Challenge({
    required this.id,
    required this.titre,
    required this.description,
    required this.type,
    required this.dateDebut,
    required this.dateFin,
    required this.objectif,
    required this.pointsRecompense,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(dateFin);
  int get joursRestants => dateFin.difference(DateTime.now()).inDays;

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'description': description,
    'type': type,
    'dateDebut': dateDebut.toIso8601String(),
    'dateFin': dateFin.toIso8601String(),
    'objectif': objectif,
    'pointsRecompense': pointsRecompense,
    'isActive': isActive,
  };

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      objectif: json['objectif'] as Map<String, dynamic>,
      pointsRecompense: json['pointsRecompense'] as int,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
