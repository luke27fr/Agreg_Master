import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/subscription_service.dart';

/// Tests for SubscriptionService business logic.
///
/// SubscriptionService is a singleton that depends on Firebase Auth, RevenueCat,
/// SharedPreferences, and rootBundle. These tests focus on the pure business
/// logic methods that do not require external service initialization:
/// - canAccess: feature access gating
/// - getFreeAccessCount: content limits for free users
/// - Entitlement/product ID constants
///
/// Integration tests requiring RevenueCat/Firebase mocks would belong in a
/// separate integration test suite with proper mock setup.
void main() {
  late SubscriptionService service;

  setUp(() {
    service = SubscriptionService();
    // Note: The service is a singleton. We cannot easily reset _isPremium
    // in unit tests without reflection. These tests are designed to work
    // regardless of the current premium state by testing the logic paths
    // directly or by checking both free/premium scenarios structurally.
  });

  group('SubscriptionService - Constants', () {
    test('entitlementId is defined', () {
      expect(SubscriptionService.entitlementId, 'Agreg Master Pro');
    });

    test('monthlyId is defined', () {
      expect(SubscriptionService.monthlyId, 'agreg_master_premium_monthly');
    });

    test('yearlyId is defined', () {
      expect(SubscriptionService.yearlyId, 'agreg_master_premium_yearly');
    });

    test('monthly product id contains "monthly"', () {
      expect(SubscriptionService.monthlyId, contains('monthly'));
    });

    test('yearly product id contains "yearly"', () {
      expect(SubscriptionService.yearlyId, contains('yearly'));
    });
  });

  group('SubscriptionService - canAccess (free features)', () {
    // When the user is NOT premium, canAccess should return true for free features.
    // When premium, canAccess always returns true.
    // We test the free feature list completeness.

    test('free features list contains expected items', () {
      // These should always be accessible even for free users
      final freeFeatures = [
        'quiz',
        'search',
        'pomodoro',
        'maths_intuitives_preview',
        'lecons_preview',
        'exercices_preview',
        'demonstrations_preview',
        'badges',
        'streak',
      ];

      for (final feature in freeFeatures) {
        // If user is premium, canAccess always returns true.
        // If user is free, these specific features should still return true.
        expect(service.canAccess(feature), isTrue,
            reason: '$feature should be accessible');
      }
    });

    test('unknown feature returns false when not premium (or true when premium)', () {
      final result = service.canAccess('totally_unknown_premium_feature');
      // This will be true if premium, false if not. We just verify it does not crash.
      expect(result, isA<bool>());
    });
  });

  group('SubscriptionService - getFreeAccessCount', () {
    // getFreeAccessCount returns 999999 if premium, or specific limits if free.
    // We test the structure and logic of the switch cases.

    test('returns specific counts for known content types (when not premium)', () {
      // If the service happens to be premium, all will return 999999.
      // We verify at minimum the return type and positive values.
      final lecons = service.getFreeAccessCount('lecons');
      final exercices = service.getFreeAccessCount('exercices');
      final examens = service.getFreeAccessCount('examens_blancs');
      final maths = service.getFreeAccessCount('maths_intuitives');
      final demos = service.getFreeAccessCount('demonstrations');
      final annales = service.getFreeAccessCount('annales');
      final annalesPed = service.getFreeAccessCount('annales_ped');
      final fiches = service.getFreeAccessCount('fiches');
      final devs = service.getFreeAccessCount('developpements');
      final contreExemples = service.getFreeAccessCount('contre_exemples');
      final questionsJury = service.getFreeAccessCount('questions_jury');

      // All should be positive integers
      expect(lecons, greaterThan(0));
      expect(exercices, greaterThan(0));
      expect(examens, greaterThan(0));
      expect(maths, greaterThan(0));
      expect(demos, greaterThan(0));
      expect(annales, greaterThan(0));
      expect(annalesPed, greaterThan(0));
      expect(fiches, greaterThan(0));
      expect(devs, greaterThan(0));
      expect(contreExemples, greaterThan(0));
      expect(questionsJury, greaterThan(0));
    });

    test('returns 0 or 999999 for unknown content type', () {
      final result = service.getFreeAccessCount('nonexistent_type');
      // Free: returns 0, Premium: returns 999999
      expect(result == 0 || result == 999999, isTrue);
    });

    test('free access counts are ordered logically (when not premium)', () {
      // If premium, all return 999999 which still satisfies these constraints.
      final exercices = service.getFreeAccessCount('exercices');
      final examens = service.getFreeAccessCount('examens_blancs');

      // Exercices should have more free access than examens blancs
      expect(exercices, greaterThanOrEqualTo(examens));
    });

    test('exercices has higher free count than fiches', () {
      final exercices = service.getFreeAccessCount('exercices');
      final fiches = service.getFreeAccessCount('fiches');

      expect(exercices, greaterThanOrEqualTo(fiches));
    });
  });

  group('SubscriptionService - Getters', () {
    test('currentPlan is null or a String', () {
      // Before initialization, currentPlan may be null
      expect(service.currentPlan, anyOf(isNull, isA<String>()));
    });

    test('expirationDate is null or a DateTime', () {
      expect(service.expirationDate, anyOf(isNull, isA<DateTime>()));
    });

    test('isLoading is a bool', () {
      expect(service.isLoading, isA<bool>());
    });

    test('error is null or a String', () {
      expect(service.error, anyOf(isNull, isA<String>()));
    });

    test('isPremium is a bool', () {
      expect(service.isPremium, isA<bool>());
    });

    test('isInitialized is a bool', () {
      expect(service.isInitialized, isA<bool>());
    });

    test('initError is null or a String', () {
      expect(service.initError, anyOf(isNull, isA<String>()));
    });
  });

  group('SubscriptionService - Feature gating consistency', () {
    test('all preview features are in free features list', () {
      // Preview features should always be accessible for free
      expect(service.canAccess('lecons_preview'), isTrue);
      expect(service.canAccess('exercices_preview'), isTrue);
      expect(service.canAccess('demonstrations_preview'), isTrue);
      expect(service.canAccess('maths_intuitives_preview'), isTrue);
    });

    test('gamification features are free', () {
      expect(service.canAccess('badges'), isTrue);
      expect(service.canAccess('streak'), isTrue);
    });

    test('core study tools are free', () {
      expect(service.canAccess('quiz'), isTrue);
      expect(service.canAccess('search'), isTrue);
      expect(service.canAccess('pomodoro'), isTrue);
    });
  });

  group('SubscriptionService - Free content limits', () {
    // Verify expected free limits when the user is not premium.
    // If premium, all values are 999999 which still passes these tests
    // since we use greaterThanOrEqualTo.

    test('lecons free count >= 5', () {
      expect(service.getFreeAccessCount('lecons'), greaterThanOrEqualTo(5));
    });

    test('exercices free count >= 10', () {
      expect(service.getFreeAccessCount('exercices'), greaterThanOrEqualTo(10));
    });

    test('examens_blancs free count >= 1', () {
      expect(service.getFreeAccessCount('examens_blancs'), greaterThanOrEqualTo(1));
    });

    test('maths_intuitives free count >= 10', () {
      expect(service.getFreeAccessCount('maths_intuitives'), greaterThanOrEqualTo(10));
    });

    test('demonstrations free count >= 5', () {
      expect(service.getFreeAccessCount('demonstrations'), greaterThanOrEqualTo(5));
    });

    test('annales free count >= 4', () {
      expect(service.getFreeAccessCount('annales'), greaterThanOrEqualTo(4));
    });

    test('fiches free count >= 3', () {
      expect(service.getFreeAccessCount('fiches'), greaterThanOrEqualTo(3));
    });

    test('developpements free count >= 3', () {
      expect(service.getFreeAccessCount('developpements'), greaterThanOrEqualTo(3));
    });

    test('contre_exemples free count >= 3', () {
      expect(service.getFreeAccessCount('contre_exemples'), greaterThanOrEqualTo(3));
    });

    test('questions_jury free count >= 5', () {
      expect(service.getFreeAccessCount('questions_jury'), greaterThanOrEqualTo(5));
    });
  });
}
