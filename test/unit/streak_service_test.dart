import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/streak_service.dart';

/// Tests for StreakService business logic.
///
/// StreakService is a singleton that depends on StorageService for persistence.
/// These tests exercise the in-memory computation methods by manipulating
/// state through the public API (recordActivity, resetAll).
void main() {
  late StreakService service;

  setUp(() async {
    service = StreakService();
    // Reset all state before each test.
    // _saveData may throw without path_provider but is caught internally.
    await service.resetAll();
  });

  group('StreakService - Initial state after reset', () {
    test('currentStreak is 0', () {
      expect(service.currentStreak, 0);
    });

    test('longestStreak is 0', () {
      expect(service.longestStreak, 0);
    });

    test('totalDaysActive is 0', () {
      expect(service.totalDaysActive, 0);
    });

    test('lastActivityDate is null', () {
      expect(service.lastActivityDate, isNull);
    });

    test('todayObjectives contains default objectives', () {
      final objectives = service.todayObjectives;
      expect(objectives, contains('fiches'));
      expect(objectives, contains('quiz'));
      expect(objectives, contains('revision'));
    });
  });

  group('StreakService - recordActivity', () {
    test('first activity sets streak to 1', () async {
      await service.recordActivity('fiches');

      expect(service.currentStreak, 1);
      expect(service.totalDaysActive, 1);
      expect(service.lastActivityDate, isNotNull);
    });

    test('records progress on objective', () async {
      await service.recordActivity('fiches');

      final objectives = service.todayObjectives;
      expect(objectives['fiches']!.progress, 1);
    });

    test('multiple activities on same day accumulate progress', () async {
      await service.recordActivity('fiches');
      await service.recordActivity('fiches');
      await service.recordActivity('fiches');

      final objectives = service.todayObjectives;
      expect(objectives['fiches']!.progress, 3);
    });

    test('activity with custom amount', () async {
      await service.recordActivity('revision', amount: 5);

      final objectives = service.todayObjectives;
      expect(objectives['revision']!.progress, 5);
    });

    test('ignores unknown objective id', () async {
      await service.recordActivity('nonexistent');

      // Should not throw and state should remain unchanged
      expect(service.currentStreak, 0);
    });

    test('same day activity does not increment streak', () async {
      await service.recordActivity('fiches');
      await service.recordActivity('quiz');

      // Both on same day, streak should still be 1
      expect(service.currentStreak, 1);
      expect(service.totalDaysActive, 1);
    });

    test('longestStreak updates when currentStreak exceeds it', () async {
      await service.recordActivity('fiches');

      expect(service.longestStreak, 1);
    });

    test('progress is clamped to target * 2', () async {
      // Default fiches target is 3, so max progress is 6
      for (int i = 0; i < 10; i++) {
        await service.recordActivity('fiches');
      }

      final objectives = service.todayObjectives;
      expect(objectives['fiches']!.progress, lessThanOrEqualTo(6));
    });
  });

  group('StreakService - areAllObjectivesCompleted', () {
    test('returns false when no progress', () {
      expect(service.areAllObjectivesCompleted(), isFalse);
    });

    test('returns false when only some objectives completed', () async {
      // Complete fiches (target 3)
      for (int i = 0; i < 3; i++) {
        await service.recordActivity('fiches');
      }

      expect(service.areAllObjectivesCompleted(), isFalse);
    });

    test('returns true when all objectives completed', () async {
      // Complete fiches (target 3)
      for (int i = 0; i < 3; i++) {
        await service.recordActivity('fiches');
      }
      // Complete quiz (target 1)
      await service.recordActivity('quiz');
      // Complete revision (target 15)
      await service.recordActivity('revision', amount: 15);

      expect(service.areAllObjectivesCompleted(), isTrue);
    });
  });

  group('StreakService - getTodayCompletionRate', () {
    test('returns 0 when no progress', () {
      expect(service.getTodayCompletionRate(), 0.0);
    });

    test('returns correct rate for partial completion', () async {
      // Complete 1 of 3 objectives (fiches target=3)
      for (int i = 0; i < 3; i++) {
        await service.recordActivity('fiches');
      }

      // 1 out of 3 objectives completed = 1/3
      expect(service.getTodayCompletionRate(), closeTo(1 / 3, 0.01));
    });

    test('returns 1.0 when all objectives completed', () async {
      for (int i = 0; i < 3; i++) {
        await service.recordActivity('fiches');
      }
      await service.recordActivity('quiz');
      await service.recordActivity('revision', amount: 15);

      expect(service.getTodayCompletionRate(), 1.0);
    });
  });

  group('StreakService - resetAll', () {
    test('resets all counters', () async {
      await service.recordActivity('fiches');
      await service.recordActivity('quiz');

      await service.resetAll();

      expect(service.currentStreak, 0);
      expect(service.longestStreak, 0);
      expect(service.totalDaysActive, 0);
      expect(service.lastActivityDate, isNull);
    });

    test('reinitializes today objectives to defaults', () async {
      await service.recordActivity('fiches');
      await service.resetAll();

      final objectives = service.todayObjectives;
      for (final obj in objectives.values) {
        expect(obj.progress, 0, reason: '${obj.id} progress should be reset to 0');
      }
    });
  });
}
