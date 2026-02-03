import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Service singleton pour gérer la progression de lecture
class ReadingService extends ChangeNotifier {
  static final ReadingService _instance = ReadingService._internal();
  factory ReadingService() => _instance;
  ReadingService._internal();

  final Set<String> _readFiches = {};
  final Map<String, DateTime> _readDates = {};
  bool _isLoaded = false;

  Set<String> get readFiches => Set.unmodifiable(_readFiches);
  bool get isLoaded => _isLoaded;

  /// Charge les données depuis le fichier local
  Future<void> loadReadingProgress() async {
    if (_isLoaded) return;
    
    try {
      final file = await _getReadingFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        _readFiches.clear();
        _readDates.clear();
        data.forEach((key, value) {
          _readFiches.add(key);
          _readDates[key] = DateTime.parse(value as String);
        });
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement lecture: $e');
      _isLoaded = true;
    }
  }

  /// Vérifie si une fiche a été lue
  bool isRead(String ficheId) => _readFiches.contains(ficheId);

  /// Récupère la date de lecture
  DateTime? getReadDate(String ficheId) => _readDates[ficheId];

  /// Marque une fiche comme lue
  Future<void> markAsRead(String ficheId) async {
    if (!_readFiches.contains(ficheId)) {
      _readFiches.add(ficheId);
      _readDates[ficheId] = DateTime.now();
      notifyListeners();
      await _persistReadingProgress();
    }
  }

  /// Marque une fiche comme non lue
  Future<void> markAsUnread(String ficheId) async {
    if (_readFiches.remove(ficheId)) {
      _readDates.remove(ficheId);
      notifyListeners();
      await _persistReadingProgress();
    }
  }

  /// Bascule l'état de lecture
  Future<void> toggleRead(String ficheId) async {
    if (_readFiches.contains(ficheId)) {
      await markAsUnread(ficheId);
    } else {
      await markAsRead(ficheId);
    }
  }

  /// Compte les fiches lues dans une liste
  int getReadCount(List<String> ficheIds) {
    return ficheIds
        .where((id) => _readFiches.contains(id.replaceAll('.md', '')))
        .length;
  }

  /// Pourcentage de fiches lues
  double getReadPercentage(List<String> ficheIds) {
    if (ficheIds.isEmpty) return 0;
    return getReadCount(ficheIds) / ficheIds.length * 100;
  }

  Future<File> _getReadingFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/agreg_master_reading.json');
  }

  Future<void> _persistReadingProgress() async {
    try {
      final file = await _getReadingFile();
      final data = <String, String>{};
      for (var ficheId in _readFiches) {
        data[ficheId] = _readDates[ficheId]?.toIso8601String() ?? DateTime.now().toIso8601String();
      }
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde lecture: $e');
    }
  }
}
