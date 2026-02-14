import '../constants/app_constants.dart';

/// Modèle immutable pour le système de répétition espacée (algorithme SM-2)
class SpacedRepetitionCard {
  final String ficheId;
  final DateTime nextReviewDate;
  final int repetitionNumber;
  final double easeFactor;
  final int intervalDays;
  final DateTime? lastReviewDate;

  const SpacedRepetitionCard({
    required this.ficheId,
    required this.nextReviewDate,
    this.repetitionNumber = 0,
    this.easeFactor = AppNumbers.defaultEaseFactor,
    this.intervalDays = 0,
    this.lastReviewDate,
  });

  /// Crée une copie avec les champs modifiés
  SpacedRepetitionCard copyWith({
    String? ficheId,
    DateTime? nextReviewDate,
    int? repetitionNumber,
    double? easeFactor,
    int? intervalDays,
    DateTime? lastReviewDate,
  }) {
    return SpacedRepetitionCard(
      ficheId: ficheId ?? this.ficheId,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      repetitionNumber: repetitionNumber ?? this.repetitionNumber,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    );
  }

  /// Calcule un nouveau card après révision selon l'algorithme SM-2
  /// quality: 0-5 (0 = échec complet, 5 = parfait)
  SpacedRepetitionCard afterReview(int quality) {
    // Valider le paramètre quality
    final clampedQuality = quality.clamp(AppNumbers.sm2QualityMin, AppNumbers.sm2QualityMax);

    int newRepetition;
    int newInterval;

    if (clampedQuality >= AppNumbers.sm2CorrectThreshold) {
      // Réponse correcte
      if (repetitionNumber == 0) {
        newInterval = 1;
      } else if (repetitionNumber == 1) {
        newInterval = 6;
      } else {
        newInterval = (intervalDays * easeFactor).round();
      }
      newRepetition = repetitionNumber + 1;
    } else {
      // Réponse incorrecte : recommencer
      newRepetition = 0;
      newInterval = 1;
    }

    // Mise à jour du facteur de facilité (formule SM-2)
    double newEaseFactor = easeFactor +
        (0.1 - (5 - clampedQuality) * (0.08 + (5 - clampedQuality) * 0.02));

    // Le facteur de facilité ne peut pas être inférieur au minimum
    if (newEaseFactor < AppNumbers.minEaseFactor) {
      newEaseFactor = AppNumbers.minEaseFactor;
    }

    return SpacedRepetitionCard(
      ficheId: ficheId,
      nextReviewDate: DateTime.now().add(Duration(days: newInterval)),
      repetitionNumber: newRepetition,
      easeFactor: newEaseFactor,
      intervalDays: newInterval,
      lastReviewDate: DateTime.now(),
    );
  }

  /// Vérifie si la fiche doit être révisée aujourd'hui
  bool isDueForReview() {
    final now = DateTime.now();
    return now.isAfter(nextReviewDate) || now.isAtSameMomentAs(nextReviewDate);
  }

  /// Retourne le nombre de jours avant la prochaine révision
  int daysUntilReview() {
    return nextReviewDate.difference(DateTime.now()).inDays;
  }

  /// Niveau de maîtrise (0-100)
  int getMasteryLevel() {
    if (repetitionNumber == 0) return AppNumbers.masteryMin;
    if (repetitionNumber <= 2) return 20;
    if (repetitionNumber <= 4) return 40;
    if (repetitionNumber <= 6) return 60;
    if (repetitionNumber <= 8) return 80;
    return AppNumbers.masteryMax;
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
      ficheId: json['ficheId'] as String? ?? '',
      nextReviewDate: json['nextReviewDate'] != null
          ? DateTime.parse(json['nextReviewDate'] as String)
          : DateTime.now(),
      repetitionNumber: (json['repetitionNumber'] as int?) ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? AppNumbers.defaultEaseFactor,
      intervalDays: (json['intervalDays'] as int?) ?? 0,
      lastReviewDate: json['lastReviewDate'] != null
          ? DateTime.parse(json['lastReviewDate'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is SpacedRepetitionCard &&
      runtimeType == other.runtimeType &&
      ficheId == other.ficheId;

  @override
  int get hashCode => ficheId.hashCode;
}

/// Statistiques de révision (immutable)
class ReviewStatistics {
  final int totalCards;
  final int dueToday;
  final int reviewedToday;
  final int masteredCards;
  final double averageMastery;

  const ReviewStatistics({
    required this.totalCards,
    required this.dueToday,
    required this.reviewedToday,
    required this.masteredCards,
    required this.averageMastery,
  });
}
