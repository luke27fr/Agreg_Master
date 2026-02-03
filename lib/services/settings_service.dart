import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Service singleton pour gérer les paramètres de l'application
class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  bool _isDarkMode = false;
  double _fontSize = 1.0; // Multiplicateur (0.8 = petit, 1.0 = normal, 1.2 = grand)
  bool _quizTimerEnabled = false;
  int _quizTimerSeconds = 30; // Secondes par question
  bool _focusModeEnabled = false;
  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  bool get quizTimerEnabled => _quizTimerEnabled;
  int get quizTimerSeconds => _quizTimerSeconds;
  bool get focusModeEnabled => _focusModeEnabled;
  bool get isLoaded => _isLoaded;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Charge les paramètres depuis le fichier local
  Future<void> loadSettings() async {
    if (_isLoaded) return;
    
    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        _isDarkMode = data['isDarkMode'] as bool? ?? false;
        _fontSize = (data['fontSize'] as num?)?.toDouble() ?? 1.0;
        _quizTimerEnabled = data['quizTimerEnabled'] as bool? ?? false;
        _quizTimerSeconds = data['quizTimerSeconds'] as int? ?? 30;
        _focusModeEnabled = data['focusModeEnabled'] as bool? ?? false;
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement paramètres: $e');
      _isLoaded = true;
    }
  }

  /// Change le mode sombre
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
      await _persistSettings();
    }
  }

  /// Bascule le mode sombre
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _persistSettings();
  }

  /// Change la taille de police
  Future<void> setFontSize(double value) async {
    if (_fontSize != value) {
      _fontSize = value.clamp(0.8, 1.4);
      notifyListeners();
      await _persistSettings();
    }
  }

  /// Active/désactive le timer de quiz
  Future<void> setQuizTimer(bool enabled, {int? seconds}) async {
    _quizTimerEnabled = enabled;
    if (seconds != null) _quizTimerSeconds = seconds;
    notifyListeners();
    await _persistSettings();
  }

  /// Active/désactive le mode focus
  Future<void> setFocusMode(bool enabled) async {
    if (_focusModeEnabled != enabled) {
      _focusModeEnabled = enabled;
      notifyListeners();
      await _persistSettings();
    }
  }

  Future<File> _getSettingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/agreg_master_settings.json');
  }

  Future<void> _persistSettings() async {
    try {
      final file = await _getSettingsFile();
      await file.writeAsString(jsonEncode({
        'isDarkMode': _isDarkMode,
        'fontSize': _fontSize,
        'quizTimerEnabled': _quizTimerEnabled,
        'quizTimerSeconds': _quizTimerSeconds,
        'focusModeEnabled': _focusModeEnabled,
      }));
    } catch (e) {
      debugPrint('Erreur sauvegarde paramètres: $e');
    }
  }
}
