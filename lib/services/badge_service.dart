import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import 'score_service.dart';
import 'streak_service.dart';
import 'reading_service.dart';
import 'favorites_service.dart';

/// Service pour gérer les badges et achievements
class BadgeService extends ChangeNotifier {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  final Set<String> _unlockedBadges = {};
  final Map<String, DateTime> _unlockDates = {};
  bool _isLoaded = false;

  Set<String> get unlockedBadges => Set.unmodifiable(_unlockedBadges);
  bool get isLoaded => _isLoaded;

  // Définition des badges
  static final List<AchievementBadge> allBadges = [
    // Badges de démarrage
    AchievementBadge(
      id: 'first_fiche',
      title: 'Premier pas',
      description: 'Lire votre première fiche',
      icon: '📖',
      category: BadgeCategory.beginner,
    ),
    AchievementBadge(
      id: 'first_quiz',
      title: 'Première évaluation',
      description: 'Compléter votre premier quiz',
      icon: '✅',
      category: BadgeCategory.beginner,
    ),
    AchievementBadge(
      id: 'first_perfect',
      title: 'Sans faute !',
      description: 'Obtenir 100% à un quiz',
      icon: '💯',
      category: BadgeCategory.quiz,
    ),

    // Badges de régularité
    AchievementBadge(
      id: 'streak_3',
      title: 'Régulier',
      description: '3 jours consécutifs de révision',
      icon: '🔥',
      category: BadgeCategory.streak,
    ),
    AchievementBadge(
      id: 'streak_7',
      title: 'Une semaine !',
      description: '7 jours consécutifs de révision',
      icon: '🔥🔥',
      category: BadgeCategory.streak,
    ),
    AchievementBadge(
      id: 'streak_30',
      title: 'Un mois !',
      description: '30 jours consécutifs de révision',
      icon: '🏆',
      category: BadgeCategory.streak,
    ),

    // Badges de quantité
    AchievementBadge(
      id: 'fiches_10',
      title: 'Lecteur assidu',
      description: 'Lire 10 fiches',
      icon: '📚',
      category: BadgeCategory.reading,
    ),
    AchievementBadge(
      id: 'fiches_all',
      title: 'Encyclopédie',
      description: 'Lire toutes les fiches',
      icon: '🎓',
      category: BadgeCategory.reading,
    ),
    AchievementBadge(
      id: 'quiz_10',
      title: 'Quiz master',
      description: 'Compléter 10 quiz',
      icon: '🧠',
      category: BadgeCategory.quiz,
    ),
    AchievementBadge(
      id: 'quiz_50',
      title: 'Expert',
      description: 'Compléter 50 quiz',
      icon: '👑',
      category: BadgeCategory.quiz,
    ),

    // Badges de performance
    AchievementBadge(
      id: 'perfect_5',
      title: 'Perfectionniste',
      description: '5 quiz parfaits',
      icon: '⭐',
      category: BadgeCategory.quiz,
    ),
    AchievementBadge(
      id: 'average_80',
      title: 'Excellent niveau',
      description: 'Moyenne générale > 80%',
      icon: '🌟',
      category: BadgeCategory.performance,
    ),
    AchievementBadge(
      id: 'all_categories',
      title: 'Polyvalent',
      description: 'Quiz réussi dans chaque catégorie',
      icon: '🎯',
      category: BadgeCategory.performance,
    ),

    // Badges spéciaux
    AchievementBadge(
      id: 'night_owl',
      title: 'Oiseau de nuit',
      description: 'Réviser après minuit',
      icon: '🦉',
      category: BadgeCategory.special,
    ),
    AchievementBadge(
      id: 'early_bird',
      title: 'Lève-tôt',
      description: 'Réviser avant 6h du matin',
      icon: '🐦',
      category: BadgeCategory.special,
    ),
    AchievementBadge(
      id: 'favorite_collector',
      title: 'Collectionneur',
      description: 'Avoir 10 fiches en favoris',
      icon: '⭐',
      category: BadgeCategory.special,
    ),
  ];

  Future<void> loadData() async {
    if (_isLoaded) return;
    
    try {
      final content = await StorageService.instance.read('agreg_master_badges.json');
      if (content != null) {
        final Map<String, dynamic> data = jsonDecode(content);
        
        _unlockedBadges.clear();
        _unlockDates.clear();
        
        if (data['unlocked'] != null) {
          for (var badge in data['unlocked']) {
            _unlockedBadges.add(badge['id']);
            if (badge['date'] != null) {
              _unlockDates[badge['id']] = DateTime.parse(badge['date']);
            }
          }
        }
      }
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement badges: $e');
      _isLoaded = true;
    }
  }

  Future<void> _saveData() async {
    try {
      final data = {
        'unlocked': _unlockedBadges.map((id) => {
          'id': id,
          'date': _unlockDates[id]?.toIso8601String(),
        }).toList(),
      };
      await StorageService.instance.write('agreg_master_badges.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde badges: $e');
    }
  }

  /// Déverrouille un badge
  Future<AchievementBadge?> unlock(String badgeId) async {
    if (_unlockedBadges.contains(badgeId)) return null;
    
    final badge = allBadges.firstWhere(
      (b) => b.id == badgeId,
      orElse: () => AchievementBadge(id: '', title: '', description: '', icon: '', category: BadgeCategory.beginner),
    );
    
    if (badge.id.isEmpty) return null;
    
    _unlockedBadges.add(badgeId);
    _unlockDates[badgeId] = DateTime.now();
    notifyListeners();
    await _saveData();
    
    return badge;
  }

  /// Vérifie si un badge est déverrouillé
  bool isUnlocked(String badgeId) => _unlockedBadges.contains(badgeId);

  /// Obtient la date de déverrouillage d'un badge
  DateTime? getUnlockDate(String badgeId) => _unlockDates[badgeId];

  /// Nombre de badges déverrouillés
  int get unlockedCount => _unlockedBadges.length;

  /// Nombre total de badges
  int get totalCount => allBadges.length;

  /// Pourcentage de complétion
  double get completionRate => totalCount > 0 ? unlockedCount / totalCount : 0;

  /// Vérifie et déverrouille les badges en fonction de l'état actuel
  Future<List<AchievementBadge>> checkAndUnlockBadges() async {
    final newBadges = <AchievementBadge>[];
    
    final scoreService = ScoreService();
    final streakService = StreakService();
    final readingService = ReadingService();
    final favoritesService = FavoritesService();
    
    // Vérifier les badges de lecture
    final readCount = readingService.readFiches.length;
    if (readCount >= 1) {
      final badge = await unlock('first_fiche');
      if (badge != null) newBadges.add(badge);
    }
    if (readCount >= 10) {
      final badge = await unlock('fiches_10');
      if (badge != null) newBadges.add(badge);
    }

    // Vérifier les badges de quiz
    final quizCount = scoreService.history.length;
    if (quizCount >= 1) {
      final badge = await unlock('first_quiz');
      if (badge != null) newBadges.add(badge);
    }
    if (quizCount >= 10) {
      final badge = await unlock('quiz_10');
      if (badge != null) newBadges.add(badge);
    }
    if (quizCount >= 50) {
      final badge = await unlock('quiz_50');
      if (badge != null) newBadges.add(badge);
    }

    // Vérifier les badges de performance
    final perfectCount = scoreService.history.where((h) => h.percentage == 100).length;
    if (perfectCount >= 1) {
      final badge = await unlock('first_perfect');
      if (badge != null) newBadges.add(badge);
    }
    if (perfectCount >= 5) {
      final badge = await unlock('perfect_5');
      if (badge != null) newBadges.add(badge);
    }

    final globalAvg = scoreService.getGlobalAverage();
    if (globalAvg >= 80) {
      final badge = await unlock('average_80');
      if (badge != null) newBadges.add(badge);
    }

    // Vérifier les badges de streak
    final streak = streakService.currentStreak;
    if (streak >= 3) {
      final badge = await unlock('streak_3');
      if (badge != null) newBadges.add(badge);
    }
    if (streak >= 7) {
      final badge = await unlock('streak_7');
      if (badge != null) newBadges.add(badge);
    }
    if (streak >= 30) {
      final badge = await unlock('streak_30');
      if (badge != null) newBadges.add(badge);
    }

    // Vérifier les badges spéciaux
    final now = DateTime.now();
    if (now.hour >= 0 && now.hour < 5) {
      final badge = await unlock('night_owl');
      if (badge != null) newBadges.add(badge);
    }
    if (now.hour >= 5 && now.hour < 6) {
      final badge = await unlock('early_bird');
      if (badge != null) newBadges.add(badge);
    }

    if (favoritesService.favorites.length >= 10) {
      final badge = await unlock('favorite_collector');
      if (badge != null) newBadges.add(badge);
    }

    return newBadges;
  }
}

class AchievementBadge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final BadgeCategory category;

  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
  });
}

enum BadgeCategory {
  beginner,
  streak,
  reading,
  quiz,
  performance,
  special,
}

extension BadgeCategoryExtension on BadgeCategory {
  String get label {
    switch (this) {
      case BadgeCategory.beginner:
        return 'Débutant';
      case BadgeCategory.streak:
        return 'Régularité';
      case BadgeCategory.reading:
        return 'Lecture';
      case BadgeCategory.quiz:
        return 'Quiz';
      case BadgeCategory.performance:
        return 'Performance';
      case BadgeCategory.special:
        return 'Spécial';
    }
  }
}
