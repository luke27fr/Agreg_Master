import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import 'spaced_repetition_service.dart';

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

/// Représente une entrée dans l'historique des quiz
class QuizHistoryEntry {
  final String ficheId;
  final int score;
  final int total;
  final DateTime date;
  final List<int> wrongQuestionIndices; // Indices des questions ratées

  QuizHistoryEntry({
    required this.ficheId,
    required this.score,
    required this.total,
    required this.date,
    required this.wrongQuestionIndices,
  });

  double get percentage => total > 0 ? (score / total * 100) : 0;

  Map<String, dynamic> toJson() => {
    'ficheId': ficheId,
    'score': score,
    'total': total,
    'date': date.toIso8601String(),
    'wrongQuestionIndices': wrongQuestionIndices,
  };

  factory QuizHistoryEntry.fromJson(Map<String, dynamic> json) => QuizHistoryEntry(
    ficheId: json['ficheId'] as String,
    score: json['score'] as int,
    total: json['total'] as int,
    date: DateTime.parse(json['date'] as String),
    wrongQuestionIndices: (json['wrongQuestionIndices'] as List<dynamic>?)?.cast<int>() ?? [],
  );
}

/// Service singleton pour gérer les scores des quiz
class ScoreService extends ChangeNotifier {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  // Map: ficheId -> QuizScore (dernier score)
  final Map<String, QuizScore> _scores = {};
  // Historique complet des quiz
  final List<QuizHistoryEntry> _history = [];
  bool _isLoaded = false;

  Map<String, QuizScore> get scores => Map.unmodifiable(_scores);
  List<QuizHistoryEntry> get history => List.unmodifiable(_history);
  bool get isLoaded => _isLoaded;

  /// Charge les scores depuis le fichier local
  Future<void> loadScores() async {
    if (_isLoaded) return;
    
    try {
      final storage = StorageService.instance;
      final content = await storage.read('agreg_master_scores.json');
      if (content != null) {
        final Map<String, dynamic> data = jsonDecode(content);
        _scores.clear();
        data.forEach((key, value) {
          _scores[key] = QuizScore.fromJson(value as Map<String, dynamic>);
        });
      }
      
      // Charger l'historique
      final historyContent = await storage.read('agreg_master_history.json');
      if (historyContent != null) {
        final List<dynamic> historyData = jsonDecode(historyContent);
        _history.clear();
        for (var entry in historyData) {
          _history.add(QuizHistoryEntry.fromJson(entry as Map<String, dynamic>));
        }
      }
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement scores: $e');
      _isLoaded = true;
    }
  }

  /// Sauvegarde un score pour une fiche
  Future<void> saveScore(String ficheId, int score, int total, {List<int>? wrongIndices}) async {
    final now = DateTime.now();
    
    _scores[ficheId] = QuizScore(
      score: score,
      total: total,
      date: now,
    );
    
    // Ajouter à l'historique
    _history.insert(0, QuizHistoryEntry(
      ficheId: ficheId,
      score: score,
      total: total,
      date: now,
      wrongQuestionIndices: wrongIndices ?? [],
    ));
    
    // Garder seulement les 100 dernières entrées
    if (_history.length > 100) {
      _history.removeRange(100, _history.length);
    }
    
    // Intégrer au système de répétition espacée
    _updateSpacedRepetition(ficheId, score, total);
    
    notifyListeners();
    await _persistScores();
    await _persistHistory();
  }

  /// Met à jour le système de répétition espacée selon le score
  void _updateSpacedRepetition(String ficheId, int score, int total) {
    final srsService = SpacedRepetitionService();
    final percentage = (score / total * 100);
    
    // Convertir le pourcentage en qualité (0-5)
    int quality;
    if (percentage >= 95) {
      quality = 5; // Parfait
    } else if (percentage >= 85) {
      quality = 4; // Bien
    } else if (percentage >= 70) {
      quality = 3; // Difficile mais réussi
    } else if (percentage >= 50) {
      quality = 2; // Familier mais échoué
    } else {
      quality = 0; // Échec
    }
    
    // Si la fiche n'existe pas encore dans le SRS, l'ajouter
    if (srsService.getCard(ficheId) == null) {
      srsService.addCard(ficheId);
    }
    
    // Mettre à jour avec le résultat du quiz
    srsService.reviewCard(ficheId, quality);
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

  /// Récupère les fiches à réviser (score < 80% ou pas fait depuis longtemps)
  List<MapEntry<String, QuizScore>> getFichesToReview() {
    final now = DateTime.now();
    final toReview = <MapEntry<String, QuizScore>>[];
    
    for (var entry in _scores.entries) {
      final daysSinceQuiz = now.difference(entry.value.date).inDays;
      // À réviser si score < 80% ou si plus de 7 jours
      if (entry.value.percentage < 80 || daysSinceQuiz >= 7) {
        toReview.add(entry);
      }
    }
    
    // Trier par priorité : score faible d'abord, puis par ancienneté
    toReview.sort((a, b) {
      // D'abord par score (plus bas en premier)
      final scoreCompare = a.value.percentage.compareTo(b.value.percentage);
      if (scoreCompare != 0) return scoreCompare;
      // Ensuite par date (plus ancien en premier)
      return a.value.date.compareTo(b.value.date);
    });
    
    return toReview;
  }

  /// Récupère les questions ratées récemment (pour mode révision)
  Map<String, List<int>> getRecentWrongQuestions() {
    final wrongQuestions = <String, List<int>>{};
    
    for (var entry in _history) {
      if (entry.wrongQuestionIndices.isNotEmpty) {
        wrongQuestions[entry.ficheId] = entry.wrongQuestionIndices;
      }
    }
    
    return wrongQuestions;
  }

  Future<void> _persistScores() async {
    try {
      final data = _scores.map((key, value) => MapEntry(key, value.toJson()));
      await StorageService.instance.write('agreg_master_scores.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde scores: $e');
    }
  }

  Future<void> _persistHistory() async {
    try {
      final data = _history.map((e) => e.toJson()).toList();
      await StorageService.instance.write('agreg_master_history.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde historique: $e');
    }
  }

  /// Réinitialise tous les scores
  Future<void> resetAllScores() async {
    _scores.clear();
    _history.clear();
    notifyListeners();
    await _persistScores();
    await _persistHistory();
  }
}
