import 'package:shared_preferences/shared_preferences.dart';
import 'subscription_service.dart';

/// Service for proactively showing paywall to engaged free users.
/// Uses session counting, content view tracking, and cooldown to avoid
/// being intrusive while still converting users who are clearly engaged.
class ProactivePaywallService {
  static final ProactivePaywallService _instance = ProactivePaywallService._();
  factory ProactivePaywallService() => _instance;
  ProactivePaywallService._();

  static const _keySessionCount = 'proactive_session_count';
  static const _keyLastPaywallShown = 'proactive_last_paywall_shown';
  static const _keyDismissedCount = 'proactive_paywall_dismissed_count';

  /// Minimum number of sessions before showing proactive paywall.
  static const _minSessions = 3;

  /// Delay (ms) before showing session paywall for first-time users.
  static const _sessionDelayMs = 30000;

  /// Delay (ms) for returning users who have dismissed before.
  static const _returningDelayMs = 60000;

  /// Number of content views in a session before triggering paywall.
  static const _contentViewLimit = 5;

  /// Cooldown (ms) between proactive paywall displays (10 minutes).
  static const _cooldownMs = 600000;

  int _sessionContentViews = 0;
  bool _sessionPaywallShown = false;

  /// Call once at app startup to increment session count and reset counters.
  Future<void> initSession() async {
    _sessionContentViews = 0;
    _sessionPaywallShown = false;
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keySessionCount) ?? 0;
    await prefs.setInt(_keySessionCount, count + 1);
  }

  /// Whether the session-based paywall should be displayed.
  Future<bool> shouldShowSessionPaywall() async {
    if (!await canShow()) return false;
    final prefs = await SharedPreferences.getInstance();
    final sessionCount = prefs.getInt(_keySessionCount) ?? 0;
    return sessionCount >= _minSessions;
  }

  /// Returns the delay (ms) to wait before displaying the session paywall.
  Future<int> getSessionDelay() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getInt(_keyDismissedCount) ?? 0;
    return dismissed > 0 ? _returningDelayMs : _sessionDelayMs;
  }

  /// Call when a user views content. Returns true if paywall should trigger.
  Future<bool> checkContentView() async {
    if (!await canShow()) return false;
    final prefs = await SharedPreferences.getInstance();
    final sessionCount = prefs.getInt(_keySessionCount) ?? 0;
    if (sessionCount < _minSessions) return false;
    _sessionContentViews++;
    if (_sessionContentViews >= _contentViewLimit) {
      await _markShown();
      return true;
    }
    return false;
  }

  /// Mark that the session paywall was shown (called externally after display).
  Future<void> markSessionPaywallShown() async {
    await _markShown();
  }

  /// Whether the proactive paywall can be shown right now.
  Future<bool> canShow() async {
    if (SubscriptionService().isPremium) return false;
    if (_sessionPaywallShown) return false;
    if (await _isCooldownActive()) return false;
    return true;
  }

  Future<bool> _isCooldownActive() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(_keyLastPaywallShown) ?? 0;
    return DateTime.now().millisecondsSinceEpoch - lastShown < _cooldownMs;
  }

  Future<void> _markShown() async {
    _sessionPaywallShown = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _keyLastPaywallShown, DateTime.now().millisecondsSinceEpoch);
    final dismissed = prefs.getInt(_keyDismissedCount) ?? 0;
    await prefs.setInt(_keyDismissedCount, dismissed + 1);
  }
}
