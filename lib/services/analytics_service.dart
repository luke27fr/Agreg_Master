import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized analytics service for tracking user behavior.
/// Wraps Firebase Analytics with typed event methods.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService _instance = AnalyticsService._();
  factory AnalyticsService() => _instance;

  FirebaseAnalytics? _analyticsInstance;
  FirebaseAnalytics get _analytics {
    _analyticsInstance ??= FirebaseAnalytics.instance;
    return _analyticsInstance!;
  }

  FirebaseAnalyticsObserver? _observerInstance;
  FirebaseAnalyticsObserver get observer {
    _observerInstance ??= FirebaseAnalyticsObserver(analytics: _analytics);
    return _observerInstance!;
  }

  // ---------------------------------------------------------------------------
  // Content views
  // ---------------------------------------------------------------------------

  Future<void> logLessonView({
    required String lessonId,
    required String lessonTitle,
    String? category,
  }) =>
      _log('view_lesson', {
        'lesson_id': lessonId,
        'lesson_title': _truncate(lessonTitle),
        if (category != null) 'category': category,
      });

  Future<void> logExerciseView({
    required String exerciseId,
    required String exerciseTitle,
  }) =>
      _log('view_exercise', {
        'exercise_id': exerciseId,
        'exercise_title': _truncate(exerciseTitle),
      });

  Future<void> logDemonstrationView({
    required String demoId,
    required String demoTitle,
  }) =>
      _log('view_demonstration', {
        'demo_id': demoId,
        'demo_title': _truncate(demoTitle),
      });

  // ---------------------------------------------------------------------------
  // Quiz & training
  // ---------------------------------------------------------------------------

  Future<void> logQuizStart({
    required String quizId,
    required int questionCount,
  }) =>
      _log('quiz_start', {
        'quiz_id': quizId,
        'question_count': questionCount,
      });

  Future<void> logQuizComplete({
    required String quizId,
    required int score,
    required int total,
  }) =>
      _log('quiz_complete', {
        'quiz_id': quizId,
        'score': score,
        'total': total,
        'percentage': total > 0 ? ((score / total) * 100).round() : 0,
      });

  Future<void> logFlashcardSession({
    required String topic,
    required int cardCount,
  }) =>
      _log('flashcard_session', {
        'topic': topic,
        'card_count': cardCount,
      });

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  Future<void> logTabChange({required String tabName}) =>
      _log('tab_change', {'tab_name': tabName});

  Future<void> logSearch({required String query, int? resultCount}) =>
      _log('search', {
        'search_term': _truncate(query),
        if (resultCount != null) 'result_count': resultCount,
      });

  // ---------------------------------------------------------------------------
  // Subscription & paywall
  // ---------------------------------------------------------------------------

  Future<void> logPaywallView({String? source}) =>
      _log('paywall_view', {
        if (source != null) 'source': source,
      });

  Future<void> logPurchaseStart({
    required String productId,
    required String packageType,
  }) =>
      _log('purchase_start', {
        'product_id': productId,
        'package_type': packageType,
      });

  Future<void> logPurchaseComplete({
    required String productId,
    required String packageType,
  }) =>
      _log('purchase_complete', {
        'product_id': productId,
        'package_type': packageType,
      });

  Future<void> logPurchaseError({
    required String productId,
    required String error,
  }) =>
      _log('purchase_error', {
        'product_id': productId,
        'error': _truncate(error),
      });

  // ---------------------------------------------------------------------------
  // Engagement
  // ---------------------------------------------------------------------------

  Future<void> logStreakDay({required int streakCount}) =>
      _log('streak_day', {'streak_count': streakCount});

  Future<void> logBadgeEarned({required String badgeId}) =>
      _log('badge_earned', {'badge_id': badgeId});

  Future<void> logExportPdf({required String ficheId}) =>
      _log('export_pdf', {'fiche_id': ficheId});

  Future<void> logShareContent({required String contentType, String? itemId}) =>
      _log('share_content', {
        'content_type': contentType,
        if (itemId != null) 'item_id': itemId,
      });

  // ---------------------------------------------------------------------------
  // User properties
  // ---------------------------------------------------------------------------

  Future<void> setUserPremiumStatus(bool isPremium) =>
      _analytics.setUserProperty(
        name: 'is_premium',
        value: isPremium.toString(),
      );

  Future<void> setUserTheme(String theme) =>
      _analytics.setUserProperty(name: 'theme_mode', value: theme);

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<void> _log(String name, Map<String, Object> params) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: params,
      );
    } catch (e) {
      debugPrint('Analytics error ($name): $e');
    }
  }

  String _truncate(String value, [int maxLength = 100]) =>
      value.length > maxLength ? value.substring(0, maxLength) : value;
}
