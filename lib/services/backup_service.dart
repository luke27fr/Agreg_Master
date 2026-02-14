import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart';
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
  String? _lastBackupKey;

  bool get isBackingUp => _isBackingUp;
  bool get isRestoring => _isRestoring;
  DateTime? get lastBackupTime => _lastBackupTime;
  String? get lastBackupKey => _lastBackupKey;

  // Charger les infos de backup
  Future<void> loadBackupInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString('last_backup_time');
      if (timestamp != null) {
        _lastBackupTime = DateTime.parse(timestamp);
      }
      _lastBackupKey = prefs.getString('last_backup_key');
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

      // Créer la clé de backup
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final backupKey = 'agreg_backup_$timestamp.json';

      // Écrire les données via StorageService
      await StorageService.instance.write(backupKey, jsonEncode(data));

      // Mettre à jour l'index des backups
      await _addToBackupIndex(backupKey, DateTime.now());

      // Sauvegarder les infos
      _lastBackupTime = DateTime.now();
      _lastBackupKey = backupKey;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_backup_time', _lastBackupTime!.toIso8601String());
      await prefs.setString('last_backup_key', _lastBackupKey!);

      _isBackingUp = false;
      notifyListeners();

      return backupKey;
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

  // Restaurer depuis un backup (sécurisé : valide avant d'effacer)
  Future<void> restoreFromBackup(String backupKey) async {
    if (_isRestoring) return;

    _isRestoring = true;
    notifyListeners();

    try {
      // Lire les données depuis StorageService
      final content = await StorageService.instance.read(backupKey);
      if (content == null) {
        throw Exception('Fichier de backup introuvable');
      }

      final backup = jsonDecode(content) as Map<String, dynamic>;

      // Vérifier la version
      final version = backup['version'] as String?;
      if (version == null || version != '1.0.0') {
        throw Exception('Version de backup incompatible: $version');
      }

      // Valider la structure des données AVANT d'effacer
      final data = backup['data'];
      if (data == null || data is! Map<String, dynamic>) {
        throw Exception('Format de données invalide dans le backup');
      }

      // Vérifier que les données sont non vides
      if (data.isEmpty) {
        throw Exception('Le backup ne contient aucune donnée');
      }

      // Créer un backup de sécurité avant la restauration
      final prefs = await SharedPreferences.getInstance();
      final previousData = await _collectAllData();
      
      try {
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
          } else if (value is List) {
            await prefs.setStringList(key, value.cast<String>());
          }
        }

        // Recharger tous les services
        await _reloadAllServices();
      } catch (restoreError) {
        // Restauration échouée : tenter de remettre les données précédentes
        debugPrint('Erreur pendant la restauration, rollback: $restoreError');
        try {
          await prefs.clear();
          final prevData = previousData['data'] as Map<String, dynamic>;
          for (final entry in prevData.entries) {
            if (entry.value is String) {
              await prefs.setString(entry.key, entry.value);
            } else if (entry.value is int) {
              await prefs.setInt(entry.key, entry.value);
            } else if (entry.value is double) {
              await prefs.setDouble(entry.key, entry.value);
            } else if (entry.value is bool) {
              await prefs.setBool(entry.key, entry.value);
            } else if (entry.value is List) {
              await prefs.setStringList(entry.key, (entry.value as List).cast<String>());
            }
          }
          await _reloadAllServices();
        } catch (rollbackError) {
          debugPrint('Erreur rollback: $rollbackError');
        }
        rethrow;
      }

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
      final index = await _getBackupIndex();
      final backups = <BackupInfo>[];

      for (final entry in index.entries) {
        final key = entry.key;
        final dateStr = entry.value as String?;

        DateTime date;
        if (dateStr != null) {
          date = DateTime.parse(dateStr);
        } else {
          // Extraire la date du nom de clé
          final dateMatch = RegExp(r'agreg_backup_(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})').firstMatch(key);
          if (dateMatch != null) {
            try {
              date = DateFormat('yyyy-MM-dd_HH-mm-ss').parse(dateMatch.group(1)!);
            } catch (e) {
              date = DateTime.now();
            }
          } else {
            date = DateTime.now();
          }
        }

        // Vérifier que le backup existe encore
        final exists = await StorageService.instance.exists(key);
        if (exists) {
          final content = await StorageService.instance.read(key);
          backups.add(BackupInfo(
            key: key,
            name: key,
            date: date,
            size: content?.length ?? 0,
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
  Future<void> deleteBackup(String backupKey) async {
    try {
      await StorageService.instance.delete(backupKey);
      await _removeFromBackupIndex(backupKey);
      notifyListeners();
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

  // Exporter les données (retourne le contenu JSON)
  Future<String?> exportData() async {
    try {
      final data = await _collectAllData();
      return jsonEncode(data);
    } catch (e) {
      debugPrint('Erreur export: $e');
      return null;
    }
  }

  // Importer depuis un contenu JSON
  Future<void> importData(String jsonContent) async {
    // Stocker temporairement dans StorageService, puis restaurer
    const tempKey = '_temp_import_backup.json';
    await StorageService.instance.write(tempKey, jsonContent);
    try {
      await restoreFromBackup(tempKey);
    } finally {
      await StorageService.instance.delete(tempKey);
    }
  }

  // Gestion de l'index des backups
  Future<Map<String, dynamic>> _getBackupIndex() async {
    try {
      final content = await StorageService.instance.read('_backup_index.json');
      if (content != null) {
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Erreur lecture index backups: $e');
    }
    return {};
  }

  Future<void> _addToBackupIndex(String key, DateTime date) async {
    final index = await _getBackupIndex();
    index[key] = date.toIso8601String();
    await StorageService.instance.write('_backup_index.json', jsonEncode(index));
  }

  Future<void> _removeFromBackupIndex(String key) async {
    final index = await _getBackupIndex();
    index.remove(key);
    await StorageService.instance.write('_backup_index.json', jsonEncode(index));
  }
}

class BackupInfo {
  final String key;
  final String name;
  final DateTime date;
  final int size;

  BackupInfo({
    required this.key,
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
