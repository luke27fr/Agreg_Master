import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/score_service.dart';

/// Tests for ScoreService business logic.
///
/// ScoreService is a singleton that depends on StorageService for persistence.
/// These tests focus on the pure computation methods (averages, counts, review
/// logic) which can be exercised by manipulating the singleton's in-memory
/// state via its public API (saveScore) or by checking freshly-created
/// instances before any data is loaded.
void main() {
  // The ScoreService is a singleton. We get the same instance every time.
  // We reset it before each test group.
  late ScoreService service;

  setUp(() {
    service = ScoreService();
    // Reset internal state between tests by calling resetAllScores.
    // Note: this calls StorageService which may throw in a test env
    // without path_provider, but the service catches errors internally.
    service.resetAllScores();
  });

  group('ScoreService - Initial state', () {
    test('scores map is initially empty after reset', () {
      expect(service.scores, isEmpty);
    });

    test('history is initially empty after reset', () {
      expect(service.history, isEmpty);
    });

    test('getGlobalAverage returns -1 when no scores', () {
      expect(service.getGlobalAverage(), -1);
    });

    test('getAverageForFiches returns -1 for unknown fiches', () {
      expect(service.getAverageForFiches(['unknown_a', 'unknown_b']), -1);
    });

    test('getCompletedCount returns 0 for unknown fiches', () {
      expect(service.getCompletedCount(['unknown_a', 'unknown_b']), 0);
    });

    test('getFichesToReview returns empty when no scores', () {
      expect(service.getFichesToReview(), isEmpty);
    });

    test('getRecentWrongQuestions returns empty when no history', () {
      expect(service.getRecentWrongQuestions(), isEmpty);
    });
  });

  group('ScoreService - saveScore and getScore', () {
    test('saveScore stores a score for a fiche', () async {
      await service.saveScore('fiche_a', 8, 10);

      final score = service.getScore('fiche_a');
      expect(score, isNotNull);
      expect(score!.score, 8);
      expect(score.total, 10);
      expect(score.percentage, 80.0);
    });

    test('saveScore overwrites previous score for same fiche', () async {
      await service.saveScore('fiche_a', 5, 10);
      await service.saveScore('fiche_a', 9, 10);

      final score = service.getScore('fiche_a');
      expect(score!.score, 9);
    });

    test('saveScore adds entry to history', () async {
      await service.saveScore('fiche_a', 8, 10);
      await service.saveScore('fiche_b', 5, 10);

      expect(service.history.length, 2);
      // History is inserted at position 0, so most recent first
      expect(service.history[0].ficheId, 'fiche_b');
      expect(service.history[1].ficheId, 'fiche_a');
    });

    test('saveScore records wrong indices in history', () async {
      await service.saveScore('fiche_a', 8, 10, wrongIndices: [2, 5]);

      expect(service.history[0].wrongQuestionIndices, [2, 5]);
    });

    test('saveScore without wrongIndices stores empty list', () async {
      await service.saveScore('fiche_a', 10, 10);

      expect(service.history[0].wrongQuestionIndices, isEmpty);
    });

    test('history is capped at 100 entries', () async {
      for (int i = 0; i < 105; i++) {
        await service.saveScore('fiche_$i', i % 10, 10);
      }

      expect(service.history.length, 100);
    });
  });

  group('ScoreService - getGlobalAverage', () {
    test('returns average of all scores', () async {
      await service.saveScore('fiche_a', 8, 10); // 80%
      await service.saveScore('fiche_b', 6, 10); // 60%

      expect(service.getGlobalAverage(), 70.0);
    });

    test('returns percentage for single score', () async {
      await service.saveScore('fiche_a', 10, 10); // 100%

      expect(service.getGlobalAverage(), 100.0);
    });

    test('handles 0% scores', () async {
      await service.saveScore('fiche_a', 0, 10); // 0%

      expect(service.getGlobalAverage(), 0.0);
    });
  });

  group('ScoreService - getAverageForFiches', () {
    test('returns average for known fiches only', () async {
      await service.saveScore('fiche_a', 10, 10); // 100%
      await service.saveScore('fiche_b', 5, 10);  // 50%

      final avg = service.getAverageForFiches(['fiche_a', 'fiche_b', 'fiche_c']);
      expect(avg, 75.0);
    });

    test('strips .md extension from fiche ids', () async {
      await service.saveScore('fiche_a', 8, 10);

      final avg = service.getAverageForFiches(['fiche_a.md']);
      expect(avg, 80.0);
    });

    test('returns -1 when no fiches are found', () {
      final avg = service.getAverageForFiches(['nonexistent']);
      expect(avg, -1);
    });

    test('returns -1 for empty list', () {
      final avg = service.getAverageForFiches([]);
      expect(avg, -1);
    });
  });

  group('ScoreService - getCompletedCount', () {
    test('counts completed fiches correctly', () async {
      await service.saveScore('fiche_a', 8, 10);
      await service.saveScore('fiche_b', 6, 10);

      final count = service.getCompletedCount(['fiche_a', 'fiche_b', 'fiche_c']);
      expect(count, 2);
    });

    test('strips .md extension', () async {
      await service.saveScore('fiche_a', 8, 10);

      final count = service.getCompletedCount(['fiche_a.md']);
      expect(count, 1);
    });

    test('returns 0 when no matches', () {
      final count = service.getCompletedCount(['nonexistent']);
      expect(count, 0);
    });
  });

  group('ScoreService - getFichesToReview', () {
    test('returns fiches with score below 80%', () async {
      await service.saveScore('good', 9, 10);    // 90% - should NOT be in review (unless old)
      await service.saveScore('weak', 5, 10);     // 50% - should be in review

      final toReview = service.getFichesToReview();
      final reviewIds = toReview.map((e) => e.key).toList();

      expect(reviewIds, contains('weak'));
    });

    test('sorted by score ascending then date ascending', () async {
      await service.saveScore('medium', 7, 10);  // 70%
      await service.saveScore('bad', 3, 10);      // 30%

      final toReview = service.getFichesToReview();
      // 'bad' (30%) should come before 'medium' (70%)
      if (toReview.length >= 2) {
        expect(toReview[0].key, 'bad');
        expect(toReview[1].key, 'medium');
      }
    });
  });

  group('ScoreService - getRecentWrongQuestions', () {
    test('returns wrong questions keyed by ficheId', () async {
      await service.saveScore('fiche_a', 8, 10, wrongIndices: [2, 5]);
      await service.saveScore('fiche_b', 10, 10); // no wrong

      final wrong = service.getRecentWrongQuestions();
      expect(wrong.containsKey('fiche_a'), isTrue);
      expect(wrong['fiche_a'], [2, 5]);
      expect(wrong.containsKey('fiche_b'), isFalse);
    });

    test('returns empty map when all scores are perfect', () async {
      await service.saveScore('fiche_a', 10, 10);

      expect(service.getRecentWrongQuestions(), isEmpty);
    });
  });

  group('ScoreService - resetAllScores', () {
    test('clears all scores and history', () async {
      await service.saveScore('fiche_a', 8, 10);
      await service.saveScore('fiche_b', 6, 10);

      await service.resetAllScores();

      expect(service.scores, isEmpty);
      expect(service.history, isEmpty);
      expect(service.getGlobalAverage(), -1);
    });
  });
}
