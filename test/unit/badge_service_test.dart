import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/badge_service.dart';

/// Tests for BadgeService and related models.
///
/// BadgeService is a singleton that depends on StorageService for persistence
/// and references other singletons (ScoreService, StreakService, etc.) in
/// checkAndUnlockBadges. These tests focus on:
/// - AchievementBadge model
/// - BadgeCategory enum and extension
/// - Badge unlock/query logic
/// - Badge definitions completeness
void main() {
  group('AchievementBadge', () {
    test('should create with required fields', () {
      const badge = AchievementBadge(
        id: 'test_badge',
        title: 'Test Badge',
        description: 'A test badge',
        icon: 'star',
        category: BadgeCategory.beginner,
      );

      expect(badge.id, 'test_badge');
      expect(badge.title, 'Test Badge');
      expect(badge.description, 'A test badge');
      expect(badge.icon, 'star');
      expect(badge.category, BadgeCategory.beginner);
    });
  });

  group('BadgeCategory', () {
    test('has all expected values', () {
      expect(BadgeCategory.values, contains(BadgeCategory.beginner));
      expect(BadgeCategory.values, contains(BadgeCategory.streak));
      expect(BadgeCategory.values, contains(BadgeCategory.reading));
      expect(BadgeCategory.values, contains(BadgeCategory.quiz));
      expect(BadgeCategory.values, contains(BadgeCategory.performance));
      expect(BadgeCategory.values, contains(BadgeCategory.special));
    });

    test('label returns French labels', () {
      expect(BadgeCategory.beginner.label, 'D\u00e9butant');
      expect(BadgeCategory.streak.label, 'R\u00e9gularit\u00e9');
      expect(BadgeCategory.reading.label, 'Lecture');
      expect(BadgeCategory.quiz.label, 'Quiz');
      expect(BadgeCategory.performance.label, 'Performance');
      expect(BadgeCategory.special.label, 'Sp\u00e9cial');
    });
  });

  group('BadgeService.allBadges - Definitions', () {
    test('has at least 10 badges defined', () {
      expect(BadgeService.allBadges.length, greaterThanOrEqualTo(10));
    });

    test('all badge ids are unique', () {
      final ids = BadgeService.allBadges.map((b) => b.id).toSet();
      expect(ids.length, BadgeService.allBadges.length);
    });

    test('all badges have non-empty id', () {
      for (final badge in BadgeService.allBadges) {
        expect(badge.id, isNotEmpty, reason: '${badge.title} should have an id');
      }
    });

    test('all badges have non-empty title', () {
      for (final badge in BadgeService.allBadges) {
        expect(badge.title, isNotEmpty, reason: '${badge.id} should have a title');
      }
    });

    test('all badges have non-empty description', () {
      for (final badge in BadgeService.allBadges) {
        expect(badge.description, isNotEmpty, reason: '${badge.id} should have a description');
      }
    });

    test('all badges have non-empty icon', () {
      for (final badge in BadgeService.allBadges) {
        expect(badge.icon, isNotEmpty, reason: '${badge.id} should have an icon');
      }
    });

    test('contains beginner badges', () {
      final beginnerBadges = BadgeService.allBadges
          .where((b) => b.category == BadgeCategory.beginner);
      expect(beginnerBadges, isNotEmpty);
    });

    test('contains streak badges', () {
      final streakBadges = BadgeService.allBadges
          .where((b) => b.category == BadgeCategory.streak);
      expect(streakBadges, isNotEmpty);
    });

    test('contains quiz badges', () {
      final quizBadges = BadgeService.allBadges
          .where((b) => b.category == BadgeCategory.quiz);
      expect(quizBadges, isNotEmpty);
    });

    test('contains performance badges', () {
      final perfBadges = BadgeService.allBadges
          .where((b) => b.category == BadgeCategory.performance);
      expect(perfBadges, isNotEmpty);
    });

    test('contains special badges', () {
      final specialBadges = BadgeService.allBadges
          .where((b) => b.category == BadgeCategory.special);
      expect(specialBadges, isNotEmpty);
    });

    test('contains expected specific badges', () {
      final ids = BadgeService.allBadges.map((b) => b.id).toSet();

      expect(ids, contains('first_fiche'));
      expect(ids, contains('first_quiz'));
      expect(ids, contains('first_perfect'));
      expect(ids, contains('streak_3'));
      expect(ids, contains('streak_7'));
      expect(ids, contains('streak_30'));
      expect(ids, contains('fiches_10'));
      expect(ids, contains('quiz_10'));
      expect(ids, contains('quiz_50'));
      expect(ids, contains('perfect_5'));
      expect(ids, contains('average_80'));
      expect(ids, contains('night_owl'));
      expect(ids, contains('early_bird'));
      expect(ids, contains('favorite_collector'));
    });
  });

  group('BadgeService - unlock and query', () {
    late BadgeService service;

    setUp(() {
      service = BadgeService();
      // Clear unlocked badges for a clean state.
      // The service is a singleton; we manipulate it through public methods.
    });

    test('isUnlocked returns false for unknown badge', () {
      expect(service.isUnlocked('nonexistent_xyz'), isFalse);
    });

    test('unlock adds badge to unlocked set', () async {
      final badge = await service.unlock('first_fiche');

      expect(badge, isNotNull);
      expect(badge!.id, 'first_fiche');
      expect(service.isUnlocked('first_fiche'), isTrue);
    });

    test('unlock returns null for already-unlocked badge', () async {
      await service.unlock('first_fiche');
      final secondAttempt = await service.unlock('first_fiche');

      expect(secondAttempt, isNull);
    });

    test('unlock returns null for invalid badge id', () async {
      final badge = await service.unlock('totally_invalid_badge');

      expect(badge, isNull);
    });

    test('getUnlockDate returns date after unlock', () async {
      await service.unlock('first_quiz');

      final date = service.getUnlockDate('first_quiz');
      expect(date, isNotNull);
      // Date should be close to now
      expect(
        date!.difference(DateTime.now()).inSeconds.abs(),
        lessThan(5),
      );
    });

    test('getUnlockDate returns null for locked badge', () {
      expect(service.getUnlockDate('streak_30'), isNull);
    });

    test('unlockedCount increments on unlock', () async {
      final before = service.unlockedCount;
      await service.unlock('streak_3');
      expect(service.unlockedCount, before + 1);
    });

    test('totalCount matches allBadges length', () {
      expect(service.totalCount, BadgeService.allBadges.length);
    });

    test('completionRate starts at valid ratio', () {
      final rate = service.completionRate;
      expect(rate, greaterThanOrEqualTo(0));
      expect(rate, lessThanOrEqualTo(1));
    });

    test('completionRate increases after unlock', () async {
      final before = service.completionRate;
      await service.unlock('early_bird');
      expect(service.completionRate, greaterThanOrEqualTo(before));
    });
  });
}
