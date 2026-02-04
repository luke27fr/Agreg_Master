import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'score_service.dart';
import 'favorites_service.dart';
import 'notes_service.dart';
import 'reading_service.dart';
import 'streak_service.dart';
import 'badge_service.dart';
import 'spaced_repetition_service.dart';
import 'lecon_progress_service.dart';
import 'examen_blanc_service.dart';

class BackupService extends ChangeNotifier {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  bool _isBackingUp = false;
  bool _isRestoring = false;
  DateTime? _lastBackupTime;
  String? _lastBackupPath;

  bool get isBackingUp => _isBackingUp;
  bool get isRestoring => _isRestoring;
  DateTime? get lastBackupTime => _lastBackupTime;
  String? get lastBackupPath => _lastBackupPath;

  // Charger les infos de backup
  Future<void> loadBackupInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString('last_backup_time');
      if (timestamp != null) {
        _lastBackupTime = DateTime.parse(timestamp);
      }
      _lastBackupPath = prefs.getString('last_backup_path');
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement info backup: $e');
    }
  }

  // Créer une sauvegarde complète
  Future<String?> createBackup() async {
    if (_isBackingUp) return null;

    _isBackingUp = true;
    notifyListeners();

    try {
      // Collecter toutes les données
      final data = await _collectAllData();

      // Créer le fichier de backup
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final fileName = 'agreg_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      // Écrire les données
      await file.writeAsString(jsonEncode(data));

      // Sauvegarder les infos
      _lastBackupTime = DateTime.now();
      _lastBackupPath = file.path;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_backup_time', _lastBackupTime!.toIso8601String());
      await prefs.setString('last_backup_path', _lastBackupPath!);

      _isBackingUp = false;
      notifyListeners();

      return file.path;
    } catch (e) {
      _isBackingUp = false;
      notifyListeners();
      debugPrint('Erreur création backup: $e');
      rethrow;
    }
  }

  // Collecter toutes les données
  Future<Map<String, dynamic>> _collectAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final data = <String, dynamic>{};

    for (final key in keys) {
      final value = prefs.get(key);
      if (value != null) {
        data[key] = value;
      }
    }

    return {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
  }

  // Restaurer depuis un backup
  Future<void> restoreFromBackup(String filePath) async {
    if (_isRestoring) return;

    _isRestoring = true;
    notifyListeners();

    try {
      // Lire le fichier
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Fichier de backup introuvable');
      }

      final content = await file.readAsString();
      final backup = jsonDecode(content) as Map<String, dynamic>;

      // Vérifier la version
      if (backup['version'] != '1.0.0') {
        throw Exception('Version de backup incompatible');
      }

      // Restaurer les données
      final data = backup['data'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();

      // Effacer les données actuelles
      await prefs.clear();

      // Restaurer les données
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }

      // Recharger tous les services
      await _reloadAllServices();

      _isRestoring = false;
      notifyListeners();
    } catch (e) {
      _isRestoring = false;
      notifyListeners();
      debugPrint('Erreur restauration backup: $e');
      rethrow;
    }
  }

  // Recharger tous les services après restauration
  Future<void> _reloadAllServices() async {
    await Future.wait([
      ScoreService().loadScores(),
      FavoritesService().loadFavorites(),
      NotesService().loadNotes(),
      ReadingService().loadReadingProgress(),
      StreakService().loadData(),
      BadgeService().loadData(),
      SpacedRepetitionService().loadData(),
      LeconProgressService().loadData(),
      ExamenBlancService().loadResults(),
    ]);
  }

  // Obtenir la liste des backups disponibles
  Future<List<BackupInfo>> getAvailableBackups() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();
      final backups = <BackupInfo>[];

      for (final file in files) {
        if (file is File && file.path.contains('agreg_backup_')) {
          final stat = await file.stat();
          final name = file.path.split(Platform.pathSeparator).last;

          // Extraire la date du nom
          final dateMatch = RegExp(r'agreg_backup_(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})').firstMatch(name);
          DateTime? date;
          if (dateMatch != null) {
            try {
              date = DateFormat('yyyy-MM-dd_HH-mm-ss').parse(dateMatch.group(1)!);
            } catch (e) {
              date = stat.modified;
            }
          } else {
            date = stat.modified;
          }

          backups.add(BackupInfo(
            path: file.path,
            name: name,
            date: date,
            size: stat.size,
          ));
        }
      }

      // Trier par date décroissante
      backups.sort((a, b) => b.date.compareTo(a.date));
      return backups;
    } catch (e) {
      debugPrint('Erreur liste backups: $e');
      return [];
    }
  }

  // Supprimer un backup
  Future<void> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur suppression backup: $e');
      rethrow;
    }
  }

  // Auto-backup (appelé périodiquement)
  Future<void> autoBackup() async {
    // Ne faire un backup que si le dernier date de plus de 24h
    if (_lastBackupTime != null) {
      final diff = DateTime.now().difference(_lastBackupTime!);
      if (diff.inHours < 24) {
        return;
      }
    }

    await createBackup();
  }

  // Exporter vers un fichier partageable
  Future<String?> exportData() async {
    try {
      final data = await _collectAllData();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final fileName = 'agreg_export_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonEncode(data));
      return file.path;
    } catch (e) {
      debugPrint('Erreur export: $e');
      return null;
    }
  }

  // Importer depuis un fichier
  Future<void> importData(String filePath) async {
    await restoreFromBackup(filePath);
  }
}

class BackupInfo {
  final String path;
  final String name;
  final DateTime date;
  final int size;

  BackupInfo({
    required this.path,
    required this.name,
    required this.date,
    required this.size,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get dateFormatted {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
