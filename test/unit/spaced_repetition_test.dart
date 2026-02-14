import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/models/spaced_repetition_model.dart';
import 'package:agreg_master/constants/app_constants.dart';

void main() {
  group('SpacedRepetitionCard', () {
    test('should create with default values', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test_fiche',
        nextReviewDate: DateTime.now(),
      );
      expect(card.ficheId, 'test_fiche');
      expect(card.repetitionNumber, 0);
      expect(card.easeFactor, AppNumbers.defaultEaseFactor);
      expect(card.intervalDays, 0);
      expect(card.lastReviewDate, isNull);
    });

    test('should be immutable - afterReview returns new instance', () {
      final original = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
      );
      final reviewed = original.afterReview(5);
      
      expect(reviewed, isNot(same(original)));
      expect(reviewed.ficheId, original.ficheId);
      expect(reviewed.repetitionNumber, 1);
      expect(original.repetitionNumber, 0); // Original unchanged
    });

    test('should set interval to 1 day on first correct review', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
      );
      final reviewed = card.afterReview(4);

      expect(reviewed.intervalDays, 1);
      expect(reviewed.repetitionNumber, 1);
    });

    test('should set interval to 6 days on second correct review', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
        repetitionNumber: 1,
        intervalDays: 1,
      );
      final reviewed = card.afterReview(4);

      expect(reviewed.intervalDays, 6);
      expect(reviewed.repetitionNumber, 2);
    });

    test('should reset on incorrect review (quality < 3)', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
        repetitionNumber: 5,
        intervalDays: 30,
      );
      final reviewed = card.afterReview(2);

      expect(reviewed.repetitionNumber, 0);
      expect(reviewed.intervalDays, 1);
    });

    test('should clamp quality to valid range', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
      );
      
      // quality -1 should be clamped to 0 (incorrect)
      final reviewedLow = card.afterReview(-1);
      expect(reviewedLow.repetitionNumber, 0);

      // quality 10 should be clamped to 5 (correct)
      final reviewedHigh = card.afterReview(10);
      expect(reviewedHigh.repetitionNumber, 1);
    });

    test('should never have ease factor below minimum', () {
      var card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now(),
        easeFactor: AppNumbers.minEaseFactor,
      );
      
      // Multiple bad reviews
      for (int i = 0; i < 10; i++) {
        card = card.afterReview(0);
      }
      
      expect(card.easeFactor, greaterThanOrEqualTo(AppNumbers.minEaseFactor));
    });

    test('isDueForReview returns true for past dates', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(card.isDueForReview(), isTrue);
    });

    test('isDueForReview returns false for future dates', () {
      final card = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime.now().add(const Duration(days: 1)),
      );
      expect(card.isDueForReview(), isFalse);
    });

    test('getMasteryLevel returns correct levels', () {
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 0).getMasteryLevel(),
        0,
      );
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 1).getMasteryLevel(),
        20,
      );
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 3).getMasteryLevel(),
        40,
      );
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 5).getMasteryLevel(),
        60,
      );
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 7).getMasteryLevel(),
        80,
      );
      expect(
        SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now(), repetitionNumber: 10).getMasteryLevel(),
        100,
      );
    });

    test('copyWith creates correct copy', () {
      final original = SpacedRepetitionCard(
        ficheId: 'test',
        nextReviewDate: DateTime(2025, 1, 1),
        repetitionNumber: 3,
        easeFactor: 2.5,
      );
      
      final copy = original.copyWith(repetitionNumber: 5);
      expect(copy.ficheId, 'test');
      expect(copy.repetitionNumber, 5);
      expect(copy.easeFactor, 2.5);
    });

    test('serialization roundtrip preserves data', () {
      final original = SpacedRepetitionCard(
        ficheId: 'test_roundtrip',
        nextReviewDate: DateTime(2025, 6, 15, 10, 30),
        repetitionNumber: 4,
        easeFactor: 2.8,
        intervalDays: 15,
        lastReviewDate: DateTime(2025, 6, 1),
      );
      
      final json = original.toJson();
      final restored = SpacedRepetitionCard.fromJson(json);
      
      expect(restored.ficheId, original.ficheId);
      expect(restored.repetitionNumber, original.repetitionNumber);
      expect(restored.easeFactor, original.easeFactor);
      expect(restored.intervalDays, original.intervalDays);
    });

    test('fromJson handles missing/null fields gracefully', () {
      final card = SpacedRepetitionCard.fromJson({
        'ficheId': 'test',
        'nextReviewDate': DateTime.now().toIso8601String(),
      });
      
      expect(card.ficheId, 'test');
      expect(card.repetitionNumber, 0);
      expect(card.easeFactor, AppNumbers.defaultEaseFactor);
      expect(card.lastReviewDate, isNull);
    });

    test('equality based on ficheId', () {
      final card1 = SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now());
      final card2 = SpacedRepetitionCard(ficheId: 'a', nextReviewDate: DateTime.now().add(const Duration(days: 1)));
      final card3 = SpacedRepetitionCard(ficheId: 'b', nextReviewDate: DateTime.now());
      
      expect(card1, equals(card2));
      expect(card1, isNot(equals(card3)));
    });
  });

  group('ReviewStatistics', () {
    test('should create with all required fields', () {
      const stats = ReviewStatistics(
        totalCards: 50,
        dueToday: 10,
        reviewedToday: 5,
        masteredCards: 20,
        averageMastery: 60.5,
      );
      expect(stats.totalCards, 50);
      expect(stats.dueToday, 10);
      expect(stats.averageMastery, 60.5);
    });
  });
}
