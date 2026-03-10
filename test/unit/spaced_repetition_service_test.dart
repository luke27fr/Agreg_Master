import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/spaced_repetition_service.dart';
import 'package:agreg_master/models/spaced_repetition_model.dart';

/// Tests for SpacedRepetitionService business logic.
///
/// SpacedRepetitionService is a singleton that uses StorageService for
/// persistence. These tests exercise the in-memory card management and
/// SM-2 algorithm integration via the public API.
void main() {
  late SpacedRepetitionService service;

  setUp(() async {
    service = SpacedRepetitionService();
    // Clear all data for a clean test state.
    await service.clearAllData();
  });

  group('SpacedRepetitionService - Initial state', () {
    test('cards is empty after clear', () {
      expect(service.cards, isEmpty);
    });

    test('getDueCards returns empty when no cards', () {
      expect(service.getDueCards(), isEmpty);
    });

    test('getUpcomingCards returns empty when no cards', () {
      expect(service.getUpcomingCards(), isEmpty);
    });

    test('getCard returns null for unknown fiche', () {
      expect(service.getCard('nonexistent'), isNull);
    });

    test('getStatistics returns zeros when empty', () {
      final stats = service.getStatistics();
      expect(stats.totalCards, 0);
      expect(stats.dueToday, 0);
      expect(stats.reviewedToday, 0);
      expect(stats.masteredCards, 0);
      expect(stats.averageMastery, 0.0);
    });
  });

  group('SpacedRepetitionService - addCard', () {
    test('adds new card to cards map', () {
      service.addCard('algebre_01');

      expect(service.cards, contains('algebre_01'));
      expect(service.cards.length, 1);
    });

    test('new card has default values', () {
      service.addCard('algebre_01');
      final card = service.getCard('algebre_01');

      expect(card, isNotNull);
      expect(card!.ficheId, 'algebre_01');
      expect(card.repetitionNumber, 0);
    });

    test('new card is immediately due for review', () {
      service.addCard('algebre_01');
      final card = service.getCard('algebre_01');

      expect(card!.isDueForReview(), isTrue);
    });

    test('does not overwrite existing card', () {
      service.addCard('algebre_01');
      service.reviewCard('algebre_01', 5);

      final beforeRep = service.getCard('algebre_01')!.repetitionNumber;
      service.addCard('algebre_01'); // Should be a no-op
      final afterRep = service.getCard('algebre_01')!.repetitionNumber;

      expect(afterRep, beforeRep);
    });

    test('multiple cards have distinct ids', () {
      service.addCard('algebre_01');
      service.addCard('analyse_01');
      service.addCard('proba_01');

      expect(service.cards.length, 3);
      expect(service.cards.keys, containsAll(['algebre_01', 'analyse_01', 'proba_01']));
    });
  });

  group('SpacedRepetitionService - reviewCard', () {
    test('reviews existing card and updates state', () {
      service.addCard('algebre_01');
      service.reviewCard('algebre_01', 4);

      final card = service.getCard('algebre_01');
      expect(card!.repetitionNumber, 1);
      expect(card.intervalDays, 1);
    });

    test('auto-creates card if not present', () {
      service.reviewCard('new_fiche', 3);

      expect(service.getCard('new_fiche'), isNotNull);
      // After auto-create + review: repetitionNumber should be 1
      expect(service.getCard('new_fiche')!.repetitionNumber, 1);
    });

    test('throws ArgumentError for quality out of range', () {
      service.addCard('test');

      expect(() => service.reviewCard('test', -1), throwsArgumentError);
      expect(() => service.reviewCard('test', 6), throwsArgumentError);
    });

    test('tracks reviewed today count', () {
      service.addCard('a');
      service.addCard('b');
      service.reviewCard('a', 4);
      service.reviewCard('b', 3);

      final stats = service.getStatistics();
      expect(stats.reviewedToday, 2);
    });

    test('reviewing same card twice still counts once in reviewedToday', () {
      service.addCard('a');
      service.reviewCard('a', 4);
      service.reviewCard('a', 5);

      final stats = service.getStatistics();
      // _reviewedToday is a Set, so same ficheId counted once
      expect(stats.reviewedToday, 1);
    });

    test('correct review (quality >= 3) increments repetition', () {
      service.addCard('test');
      service.reviewCard('test', 3);

      expect(service.getCard('test')!.repetitionNumber, 1);
    });

    test('incorrect review (quality < 3) resets repetition', () {
      service.addCard('test');
      service.reviewCard('test', 5); // rep = 1
      service.reviewCard('test', 5); // rep = 2
      service.reviewCard('test', 1); // reset

      expect(service.getCard('test')!.repetitionNumber, 0);
    });
  });

  group('SpacedRepetitionService - getDueCards', () {
    test('newly added cards are due', () {
      service.addCard('a');
      service.addCard('b');

      final due = service.getDueCards();
      expect(due.length, 2);
    });

    test('cards reviewed with good quality are no longer immediately due', () {
      service.addCard('a');
      service.reviewCard('a', 5); // Next review is tomorrow

      final due = service.getDueCards();
      // The card should not be due anymore (next review is in the future)
      expect(due.where((c) => c.ficheId == 'a'), isEmpty);
    });

    test('due cards are sorted by nextReviewDate ascending', () {
      service.addCard('a');
      service.addCard('b');

      final due = service.getDueCards();
      if (due.length >= 2) {
        expect(
          due[0].nextReviewDate.isBefore(due[1].nextReviewDate) ||
          due[0].nextReviewDate.isAtSameMomentAs(due[1].nextReviewDate),
          isTrue,
        );
      }
    });
  });

  group('SpacedRepetitionService - getUpcomingCards', () {
    test('returns cards with future review dates within range', () {
      service.addCard('a');
      service.reviewCard('a', 5); // Next review is tomorrow (within 7 days)

      final upcoming = service.getUpcomingCards(days: 7);
      expect(upcoming.where((c) => c.ficheId == 'a').length, 1);
    });

    test('does not return due cards (already past/now)', () {
      service.addCard('a'); // Due now

      final upcoming = service.getUpcomingCards();
      expect(upcoming.where((c) => c.ficheId == 'a'), isEmpty);
    });
  });

  group('SpacedRepetitionService - getStatistics', () {
    test('totalCards counts all cards', () {
      service.addCard('a');
      service.addCard('b');
      service.addCard('c');

      expect(service.getStatistics().totalCards, 3);
    });

    test('dueToday counts only due cards', () {
      service.addCard('a');
      service.addCard('b');
      service.reviewCard('b', 5); // no longer due

      expect(service.getStatistics().dueToday, 1);
    });

    test('masteredCards counts cards with mastery >= 80', () {
      service.addCard('a');
      // To reach mastery >= 80, need repetitionNumber > 6
      // Review 7 times with quality 5
      for (int i = 0; i < 7; i++) {
        service.reviewCard('a', 5);
      }

      expect(service.getStatistics().masteredCards, 1);
    });

    test('averageMastery is 0 when no cards', () {
      expect(service.getStatistics().averageMastery, 0.0);
    });

    test('averageMastery reflects card repetitions', () {
      service.addCard('a');
      // New card has mastery 0 (repetitionNumber = 0)
      expect(service.getStatistics().averageMastery, 0.0);

      service.reviewCard('a', 5); // repetitionNumber = 1, mastery = 20
      expect(service.getStatistics().averageMastery, 20.0);
    });
  });

  group('SpacedRepetitionService - getCardsByMasteryLevel', () {
    test('empty cards produce empty categories', () {
      final levels = service.getCardsByMasteryLevel();

      for (final entry in levels.entries) {
        expect(entry.value, isEmpty, reason: '${entry.key} should be empty');
      }
    });

    test('new card is in beginner category', () {
      service.addCard('a');

      final levels = service.getCardsByMasteryLevel();
      final beginnerKey = levels.keys.firstWhere((k) => k.contains('0-20'));
      expect(levels[beginnerKey]!.length, 1);
    });

    test('returns 5 mastery level categories', () {
      final levels = service.getCardsByMasteryLevel();
      expect(levels.length, 5);
    });
  });

  group('SpacedRepetitionService - removeCard', () {
    test('removes card from cards map', () {
      service.addCard('a');
      service.removeCard('a');

      expect(service.getCard('a'), isNull);
      expect(service.cards, isEmpty);
    });

    test('removing non-existent card is a no-op', () {
      service.removeCard('nonexistent');
      // Should not throw
      expect(service.cards, isEmpty);
    });

    test('removes card from reviewedToday set', () {
      service.addCard('a');
      service.reviewCard('a', 5);
      final before = service.getStatistics().reviewedToday;

      service.removeCard('a');
      final after = service.getStatistics().reviewedToday;

      expect(after, before - 1);
    });
  });

  group('SpacedRepetitionService - resetDailyReviews', () {
    test('clears reviewedToday', () {
      service.addCard('a');
      service.reviewCard('a', 5);
      expect(service.getStatistics().reviewedToday, 1);

      service.resetDailyReviews();
      expect(service.getStatistics().reviewedToday, 0);
    });

    test('does nothing when reviewedToday is empty', () {
      service.resetDailyReviews();
      expect(service.getStatistics().reviewedToday, 0);
    });
  });

  group('SpacedRepetitionService - clearAllData', () {
    test('clears all cards and reviewed today', () async {
      service.addCard('a');
      service.addCard('b');
      service.reviewCard('a', 4);

      await service.clearAllData();

      expect(service.cards, isEmpty);
      expect(service.getStatistics().totalCards, 0);
      expect(service.getStatistics().reviewedToday, 0);
    });
  });
}
