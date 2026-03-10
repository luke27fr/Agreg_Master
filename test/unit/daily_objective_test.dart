import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/streak_service.dart';

void main() {
  group('DailyObjective', () {
    test('should create with required fields and defaults', () {
      const objective = DailyObjective(
        id: 'fiches',
        title: 'Lire des fiches',
        target: 3,
        icon: 'menu_book',
      );

      expect(objective.id, 'fiches');
      expect(objective.title, 'Lire des fiches');
      expect(objective.target, 3);
      expect(objective.progress, 0);
      expect(objective.icon, 'menu_book');
      expect(objective.unit, '');
    });

    test('should create with custom progress and unit', () {
      const objective = DailyObjective(
        id: 'revision',
        title: 'Reviser',
        target: 15,
        progress: 5,
        icon: 'timer',
        unit: 'min',
      );

      expect(objective.progress, 5);
      expect(objective.unit, 'min');
    });

    group('isCompleted', () {
      test('returns false when progress < target', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 5,
          progress: 3,
          icon: 'star',
        );
        expect(objective.isCompleted, isFalse);
      });

      test('returns true when progress == target', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 5,
          progress: 5,
          icon: 'star',
        );
        expect(objective.isCompleted, isTrue);
      });

      test('returns true when progress > target', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 5,
          progress: 8,
          icon: 'star',
        );
        expect(objective.isCompleted, isTrue);
      });

      test('returns false when progress is 0', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 5,
          progress: 0,
          icon: 'star',
        );
        expect(objective.isCompleted, isFalse);
      });
    });

    group('progressRatio', () {
      test('returns 0 when progress is 0', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 10,
          progress: 0,
          icon: 'star',
        );
        expect(objective.progressRatio, 0.0);
      });

      test('returns 0.5 when half complete', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 10,
          progress: 5,
          icon: 'star',
        );
        expect(objective.progressRatio, 0.5);
      });

      test('returns 1.0 when exactly complete', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 10,
          progress: 10,
          icon: 'star',
        );
        expect(objective.progressRatio, 1.0);
      });

      test('clamps to 1.0 when over-complete', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 10,
          progress: 15,
          icon: 'star',
        );
        expect(objective.progressRatio, 1.0);
      });

      test('returns 0 when target is 0', () {
        const objective = DailyObjective(
          id: 'test',
          title: 'Test',
          target: 0,
          progress: 5,
          icon: 'star',
        );
        expect(objective.progressRatio, 0.0);
      });
    });

    group('copyWith', () {
      test('copies with updated progress', () {
        const original = DailyObjective(
          id: 'fiches',
          title: 'Lire des fiches',
          target: 3,
          progress: 1,
          icon: 'menu_book',
          unit: 'fiches',
        );

        final updated = original.copyWith(progress: 2);

        expect(updated.id, 'fiches');
        expect(updated.title, 'Lire des fiches');
        expect(updated.target, 3);
        expect(updated.progress, 2);
        expect(updated.icon, 'menu_book');
        expect(updated.unit, 'fiches');
      });

      test('returns same values if no argument provided', () {
        const original = DailyObjective(
          id: 'quiz',
          title: 'Faire un quiz',
          target: 1,
          progress: 0,
          icon: 'quiz',
        );

        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.title, original.title);
        expect(copy.target, original.target);
        expect(copy.progress, original.progress);
        expect(copy.icon, original.icon);
        expect(copy.unit, original.unit);
      });
    });

    group('toJson', () {
      test('produces correct map', () {
        const objective = DailyObjective(
          id: 'revision',
          title: 'Reviser',
          target: 15,
          progress: 5,
          icon: 'timer',
          unit: 'min',
        );
        final json = objective.toJson();

        expect(json['id'], 'revision');
        expect(json['title'], 'Reviser');
        expect(json['target'], 15);
        expect(json['progress'], 5);
        expect(json['icon'], 'timer');
        expect(json['unit'], 'min');
      });
    });

    group('fromJson', () {
      test('restores correct object', () {
        final json = {
          'id': 'revision',
          'title': 'Reviser',
          'target': 15,
          'progress': 5,
          'icon': 'timer',
          'unit': 'min',
        };
        final objective = DailyObjective.fromJson(json);

        expect(objective.id, 'revision');
        expect(objective.title, 'Reviser');
        expect(objective.target, 15);
        expect(objective.progress, 5);
        expect(objective.icon, 'timer');
        expect(objective.unit, 'min');
      });

      test('handles missing progress field', () {
        final json = {
          'id': 'quiz',
          'title': 'Quiz',
          'target': 1,
          'icon': 'quiz',
        };
        final objective = DailyObjective.fromJson(json);
        expect(objective.progress, 0);
      });

      test('handles missing unit field', () {
        final json = {
          'id': 'quiz',
          'title': 'Quiz',
          'target': 1,
          'icon': 'quiz',
        };
        final objective = DailyObjective.fromJson(json);
        expect(objective.unit, '');
      });

      test('serialization roundtrip preserves data', () {
        const original = DailyObjective(
          id: 'fiches',
          title: 'Lire des fiches',
          target: 3,
          progress: 2,
          icon: 'menu_book',
          unit: 'fiches',
        );
        final restored = DailyObjective.fromJson(original.toJson());

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.target, original.target);
        expect(restored.progress, original.progress);
        expect(restored.icon, original.icon);
        expect(restored.unit, original.unit);
      });
    });
  });

  group('StreakService.defaultObjectives', () {
    test('contains expected objective keys', () {
      expect(StreakService.defaultObjectives, contains('fiches'));
      expect(StreakService.defaultObjectives, contains('quiz'));
      expect(StreakService.defaultObjectives, contains('revision'));
    });

    test('all objectives have positive targets', () {
      for (final obj in StreakService.defaultObjectives.values) {
        expect(obj.target, greaterThan(0), reason: '${obj.id} target should be positive');
      }
    });

    test('all objectives have non-empty titles', () {
      for (final obj in StreakService.defaultObjectives.values) {
        expect(obj.title, isNotEmpty, reason: '${obj.id} should have a title');
      }
    });

    test('all objectives have non-empty icons', () {
      for (final obj in StreakService.defaultObjectives.values) {
        expect(obj.icon, isNotEmpty, reason: '${obj.id} should have an icon');
      }
    });

    test('revision objective has unit "min"', () {
      final revision = StreakService.defaultObjectives['revision']!;
      expect(revision.unit, 'min');
    });
  });
}
