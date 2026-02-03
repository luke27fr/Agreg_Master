/// Modèle pour le système de répétition espacée (algorithme SM-2)
class SpacedRepetitionCard {
  final String ficheId;
  DateTime nextReviewDate;
  int repetitionNumber;
  double easeFactor;
  int intervalDays;
  DateTime? lastReviewDate;
  
  SpacedRepetitionCard({
    required this.ficheId,
    required this.nextReviewDate,
    this.repetitionNumber = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.lastReviewDate,
  });

  /// Calcule la prochaine date de révision selon l'algorithme SM-2
  /// quality: 0-5 (0 = échec complet, 5 = parfait)
  void updateAfterReview(int quality) {
    lastReviewDate = DateTime.now();
    
    if (quality >= 3) {
      // Réponse correcte
      if (repetitionNumber == 0) {
        intervalDays = 1;
      } else if (repetitionNumber == 1) {
        intervalDays = 6;
      } else {
        intervalDays = (intervalDays * easeFactor).round();
      }
      repetitionNumber++;
    } else {
      // Réponse incorrecte : recommencer
      repetitionNumber = 0;
      intervalDays = 1;
    }
    
    // Mise à jour du facteur de facilité
    easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    // Le facteur de facilité ne peut pas être inférieur à 1.3
    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }
    
    nextReviewDate = DateTime.now().add(Duration(days: intervalDays));
  }

  /// Vérifie si la fiche doit être révisée aujourd'hui
  bool isDueForReview() {
    return DateTime.now().isAfter(nextReviewDate) || 
           DateTime.now().isAtSameMomentAs(nextReviewDate);
  }

  /// Retourne le nombre de jours avant la prochaine révision
  int daysUntilReview() {
    return nextReviewDate.difference(DateTime.now()).inDays;
  }

  /// Niveau de maîtrise (0-100)
  int getMasteryLevel() {
    if (repetitionNumber == 0) return 0;
    if (repetitionNumber <= 2) return 20;
    if (repetitionNumber <= 4) return 40;
    if (repetitionNumber <= 6) return 60;
    if (repetitionNumber <= 8) return 80;
    return 100;
  }

  Map<String, dynamic> toJson() => {
    'ficheId': ficheId,
    'nextReviewDate': nextReviewDate.toIso8601String(),
    'repetitionNumber': repetitionNumber,
    'easeFactor': easeFactor,
    'intervalDays': intervalDays,
    'lastReviewDate': lastReviewDate?.toIso8601String(),
  };

  factory SpacedRepetitionCard.fromJson(Map<String, dynamic> json) {
    return SpacedRepetitionCard(
      ficheId: json['ficheId'] as String,
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      repetitionNumber: json['repetitionNumber'] as int,
      easeFactor: (json['easeFactor'] as num).toDouble(),
      intervalDays: json['intervalDays'] as int,
      lastReviewDate: json['lastReviewDate'] != null 
          ? DateTime.parse(json['lastReviewDate'] as String)
          : null,
    );
  }
}

/// Statistiques de révision
class ReviewStatistics {
  final int totalCards;
  final int dueToday;
  final int reviewedToday;
  final int masteredCards;
  final double averageMastery;
  
  ReviewStatistics({
    required this.totalCards,
    required this.dueToday,
    required this.reviewedToday,
    required this.masteredCards,
    required this.averageMastery,
  });
}
