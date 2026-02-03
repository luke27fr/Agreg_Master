import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Service pour gérer les streaks et objectifs quotidiens
class StreakService extends ChangeNotifier {
  static final StreakService _instance = StreakService._internal();
  factory StreakService() => _instance;
  StreakService._internal();

  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastActivityDate;
  Map<String, DailyObjective> _todayObjectives = {};
  int _totalDaysActive = 0;
  bool _isLoaded = false;

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  DateTime? get lastActivityDate => _lastActivityDate;
  Map<String, DailyObjective> get todayObjectives => Map.unmodifiable(_todayObjectives);
  int get totalDaysActive => _totalDaysActive;
  bool get isLoaded => _isLoaded;

  // Objectifs par défaut
  static const defaultObjectives = {
    'fiches': DailyObjective(id: 'fiches', title: 'Lire des fiches', target: 3, icon: 'menu_book'),
    'quiz': DailyObjective(id: 'quiz', title: 'Faire un quiz', target: 1, icon: 'quiz'),
    'revision': DailyObjective(id: 'revision', title: 'Réviser', target: 15, icon: 'timer', unit: 'min'),
  };

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/agreg_master_streaks.json');
  }

  Future<void> loadData() async {
    if (_isLoaded) return;
    
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        
        _currentStreak = data['currentStreak'] ?? 0;
        _longestStreak = data['longestStreak'] ?? 0;
        _totalDaysActive = data['totalDaysActive'] ?? 0;
        
        if (data['lastActivityDate'] != null) {
          _lastActivityDate = DateTime.parse(data['lastActivityDate']);
        }

        // Charger les objectifs du jour
        final today = _dateKey(DateTime.now());
        if (data['objectives'] != null && data['objectives'][today] != null) {
          final objData = data['objectives'][today] as Map<String, dynamic>;
          _todayObjectives = {};
          objData.forEach((key, value) {
            _todayObjectives[key] = DailyObjective.fromJson(value);
          });
        } else {
          _initTodayObjectives();
        }
      } else {
        _initTodayObjectives();
      }
      
      // Vérifier si le streak est toujours valide
      _checkStreakValidity();
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement streaks: $e');
      _initTodayObjectives();
      _isLoaded = true;
    }
  }

  void _initTodayObjectives() {
    _todayObjectives = Map.from(defaultObjectives);
  }

  void _checkStreakValidity() {
    if (_lastActivityDate == null) return;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(_lastActivityDate!.year, _lastActivityDate!.month, _lastActivityDate!.day);
    
    final difference = today.difference(lastDay).inDays;
    
    if (difference > 1) {
      // Streak perdu
      _currentStreak = 0;
    } else if (difference == 1) {
      // Hier, on peut continuer le streak aujourd'hui
    }
    // Si difference == 0, on est le même jour
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Enregistre une activité pour aujourd'hui
  Future<void> recordActivity(String objectiveId, {int amount = 1}) async {
    if (!_todayObjectives.containsKey(objectiveId)) return;
    
    final objective = _todayObjectives[objectiveId]!;
    final newProgress = (objective.progress + amount).clamp(0, objective.target * 2);
    
    _todayObjectives[objectiveId] = objective.copyWith(progress: newProgress);
    
    // Mettre à jour le streak si c'est un nouveau jour
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastActivityDate == null) {
      _currentStreak = 1;
      _totalDaysActive = 1;
    } else {
      final lastDay = DateTime(_lastActivityDate!.year, _lastActivityDate!.month, _lastActivityDate!.day);
      final difference = today.difference(lastDay).inDays;
      
      if (difference == 1) {
        _currentStreak++;
        _totalDaysActive++;
      } else if (difference > 1) {
        _currentStreak = 1;
        _totalDaysActive++;
      }
      // Si difference == 0, même jour, pas de changement de streak
    }
    
    _lastActivityDate = now;
    
    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }
    
    notifyListeners();
    await _saveData();
  }

  /// Vérifie si tous les objectifs du jour sont complétés
  bool areAllObjectivesCompleted() {
    return _todayObjectives.values.every((obj) => obj.progress >= obj.target);
  }

  /// Pourcentage de complétion des objectifs du jour
  double getTodayCompletionRate() {
    if (_todayObjectives.isEmpty) return 0;
    
    int completed = 0;
    for (var obj in _todayObjectives.values) {
      if (obj.progress >= obj.target) completed++;
    }
    return completed / _todayObjectives.length;
  }

  Future<void> _saveData() async {
    try {
      final file = await _getFile();
      final today = _dateKey(DateTime.now());
      
      final data = {
        'currentStreak': _currentStreak,
        'longestStreak': _longestStreak,
        'totalDaysActive': _totalDaysActive,
        'lastActivityDate': _lastActivityDate?.toIso8601String(),
        'objectives': {
          today: _todayObjectives.map((key, value) => MapEntry(key, value.toJson())),
        },
      };
      
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde streaks: $e');
    }
  }

  /// Réinitialiser les streaks (pour debug)
  Future<void> resetAll() async {
    _currentStreak = 0;
    _longestStreak = 0;
    _lastActivityDate = null;
    _totalDaysActive = 0;
    _initTodayObjectives();
    notifyListeners();
    await _saveData();
  }
}

class DailyObjective {
  final String id;
  final String title;
  final int target;
  final int progress;
  final String icon;
  final String unit;

  const DailyObjective({
    required this.id,
    required this.title,
    required this.target,
    this.progress = 0,
    required this.icon,
    this.unit = '',
  });

  bool get isCompleted => progress >= target;
  double get progressRatio => target > 0 ? (progress / target).clamp(0.0, 1.0) : 0;

  DailyObjective copyWith({int? progress}) {
    return DailyObjective(
      id: id,
      title: title,
      target: target,
      progress: progress ?? this.progress,
      icon: icon,
      unit: unit,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'target': target,
    'progress': progress,
    'icon': icon,
    'unit': unit,
  };

  factory DailyObjective.fromJson(Map<String, dynamic> json) => DailyObjective(
    id: json['id'],
    title: json['title'],
    target: json['target'],
    progress: json['progress'] ?? 0,
    icon: json['icon'],
    unit: json['unit'] ?? '',
  );
}
