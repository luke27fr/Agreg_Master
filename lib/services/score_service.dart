import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Représente le score d'un quiz pour une fiche
class QuizScore {
  final int score;
  final int total;
  final DateTime date;

  QuizScore({required this.score, required this.total, required this.date});

  double get percentage => total > 0 ? (score / total * 100) : 0;

  Map<String, dynamic> toJson() => {
    'score': score,
    'total': total,
    'date': date.toIso8601String(),
  };

  factory QuizScore.fromJson(Map<String, dynamic> json) => QuizScore(
    score: json['score'] as int,
    total: json['total'] as int,
    date: DateTime.parse(json['date'] as String),
  );
}

/// Service singleton pour gérer les scores des quiz
class ScoreService extends ChangeNotifier {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  // Map: ficheId -> QuizScore (dernier score)
  final Map<String, QuizScore> _scores = {};
  bool _isLoaded = false;

  Map<String, QuizScore> get scores => Map.unmodifiable(_scores);
  bool get isLoaded => _isLoaded;

  /// Charge les scores depuis le fichier local
  Future<void> loadScores() async {
    if (_isLoaded) return;
    
    try {
      final file = await _getScoreFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        _scores.clear();
        data.forEach((key, value) {
          _scores[key] = QuizScore.fromJson(value as Map<String, dynamic>);
        });
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement scores: $e');
      _isLoaded = true;
    }
  }

  /// Sauvegarde un score pour une fiche
  Future<void> saveScore(String ficheId, int score, int total) async {
    _scores[ficheId] = QuizScore(
      score: score,
      total: total,
      date: DateTime.now(),
    );
    notifyListeners();
    await _persistScores();
  }

  /// Récupère le score d'une fiche
  QuizScore? getScore(String ficheId) => _scores[ficheId];

  /// Calcule la moyenne des scores pour une liste de fiches
  double getAverageForFiches(List<String> ficheIds) {
    final relevantScores = ficheIds
        .map((id) => _scores[id.replaceAll('.md', '')])
        .where((s) => s != null)
        .toList();
    
    if (relevantScores.isEmpty) return -1; // -1 = pas de score
    
    double total = 0;
    for (var s in relevantScores) {
      total += s!.percentage;
    }
    return total / relevantScores.length;
  }

  /// Compte combien de fiches ont été complétées dans une liste
  int getCompletedCount(List<String> ficheIds) {
    return ficheIds
        .where((id) => _scores.containsKey(id.replaceAll('.md', '')))
        .length;
  }

  /// Calcule le score global moyen
  double getGlobalAverage() {
    if (_scores.isEmpty) return -1;
    double total = 0;
    for (var s in _scores.values) {
      total += s.percentage;
    }
    return total / _scores.length;
  }

  Future<File> _getScoreFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/agreg_master_scores.json');
  }

  Future<void> _persistScores() async {
    try {
      final file = await _getScoreFile();
      final data = _scores.map((key, value) => MapEntry(key, value.toJson()));
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde scores: $e');
    }
  }

  /// Réinitialise tous les scores
  Future<void> resetAllScores() async {
    _scores.clear();
    notifyListeners();
    await _persistScores();
  }
}
