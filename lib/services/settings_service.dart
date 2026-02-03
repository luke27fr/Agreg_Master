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
  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;
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

  Future<File> _getSettingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/agreg_master_settings.json');
  }

  Future<void> _persistSettings() async {
    try {
      final file = await _getSettingsFile();
      await file.writeAsString(jsonEncode({
        'isDarkMode': _isDarkMode,
      }));
    } catch (e) {
      debugPrint('Erreur sauvegarde paramètres: $e');
    }
  }
}
