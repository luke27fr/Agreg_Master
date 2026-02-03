import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/competition_model.dart';
import 'score_service.dart';
import 'streak_service.dart';
import 'spaced_repetition_service.dart';

class CompetitionService extends ChangeNotifier {
  static final CompetitionService _instance = CompetitionService._internal();
  factory CompetitionService() => _instance;
  CompetitionService._internal();

  AnonymousProfile? _profile;
  List<Challenge> _challenges = [];

  AnonymousProfile? get profile => _profile;
  List<Challenge> get activeChallenges => 
      _challenges.where((c) => c.isActive && !c.isExpired).toList();

  /// Crée un profil anonyme
  Future<void> createProfile(String pseudonyme, {String? avatar}) async {
    final scoreService = ScoreService();
    final streakService = StreakService();
    final srsService = SpacedRepetitionService();

    _profile = AnonymousProfile(
      pseudonyme: pseudonyme,
      avatar: avatar ?? _generateRandomAvatar(),
      dateInscription: DateTime.now(),
      statsPubliques: {
        'moyenneQuiz': scoreService.getGlobalAverage(),
        'streakActuel': streakService.currentStreak.toDouble(),
        'cartesMailrisees': srsService.getStatistics().masteredCards.toDouble(),
        'totalPoints': _calculateTotalPoints(),
      },
    );

    await _saveProfile();
    _generateChallenges();
    notifyListeners();
  }

  /// Génère un classement simulé (local)
  Leaderboard generateLeaderboard(String periode) {
    // Pour la démo, on génère des données simulées
    final entries = <LeaderboardEntry>[];
    final random = Random();

    // Position de l'utilisateur (simulée)
    final userScore = _profile?.statsPubliques['totalPoints'] ?? 0;
    final userRank = random.nextInt(50) + 1;

    // Générer 100 entrées fictives
    for (var i = 1; i <= 100; i++) {
      final isUser = i == userRank && _profile != null;
      
      entries.add(LeaderboardEntry(
        rang: i,
        pseudonyme: isUser ? _profile!.pseudonyme : _generateRandomPseudo(),
        avatar: isUser ? _profile!.avatar : _generateRandomAvatar(),
        score: isUser ? userScore : _generateScore(i),
        details: {
          'quizCompletes': random.nextInt(100),
          'streak': random.nextInt(30),
        },
        isCurrentUser: isUser,
      ));
    }

    return Leaderboard(
      periode: periode,
      entries: entries,
      lastUpdate: DateTime.now(),
    );
  }

  /// Génère des comparaisons avec la moyenne
  List<ComparisonStats> generateComparisons() {
    final scoreService = ScoreService();
    final streakService = StreakService();
    final srsService = SpacedRepetitionService();

    final stats = srsService.getStatistics();
    
    // Simuler des moyennes nationales
    return [
      ComparisonStats(
        categorie: 'Moyenne Quiz',
        valeurUtilisateur: scoreService.getGlobalAverage(),
        moyenneNationale: 68.5,
        percentile: _calculatePercentile(scoreService.getGlobalAverage(), 68.5),
        tendance: scoreService.getGlobalAverage() >= 68.5 ? 'superieur' : 'inferieur',
      ),
      ComparisonStats(
        categorie: 'Streak actuel',
        valeurUtilisateur: streakService.currentStreak.toDouble(),
        moyenneNationale: 5.2,
        percentile: _calculatePercentile(streakService.currentStreak.toDouble(), 5.2),
        tendance: streakService.currentStreak >= 5 ? 'superieur' : 'inferieur',
      ),
      ComparisonStats(
        categorie: 'Fiches maîtrisées',
        valeurUtilisateur: stats.masteredCards.toDouble(),
        moyenneNationale: 12.8,
        percentile: _calculatePercentile(stats.masteredCards.toDouble(), 12.8),
        tendance: stats.masteredCards >= 13 ? 'superieur' : 'inferieur',
      ),
      ComparisonStats(
        categorie: 'Temps de révision (min/jour)',
        valeurUtilisateur: 45.0, // À calculer réellement
        moyenneNationale: 38.5,
        percentile: _calculatePercentile(45.0, 38.5),
        tendance: 'superieur',
      ),
    ];
  }

  /// Génère des challenges
  void _generateChallenges() {
    _challenges = [
      Challenge(
        id: 'streak_7',
        titre: 'Semaine de feu',
        description: 'Maintenir un streak de 7 jours consécutifs',
        type: 'streak',
        dateDebut: DateTime.now(),
        dateFin: DateTime.now().add(const Duration(days: 30)),
        objectif: {'streak': 7},
        pointsRecompense: 100,
      ),
      Challenge(
        id: 'quiz_50',
        titre: 'Marathon Quiz',
        description: 'Compléter 50 quiz avec une moyenne >= 80%',
        type: 'quiz',
        dateDebut: DateTime.now(),
        dateFin: DateTime.now().add(const Duration(days: 60)),
        objectif: {'count': 50, 'average': 80},
        pointsRecompense: 250,
      ),
      Challenge(
        id: 'lecons_20',
        titre: 'Maître des leçons',
        description: 'Préparer 20 leçons à un niveau expert',
        type: 'lecons',
        dateDebut: DateTime.now(),
        dateFin: DateTime.now().add(const Duration(days: 90)),
        objectif: {'count': 20, 'level': 80},
        pointsRecompense: 500,
      ),
    ];
  }

  double _calculatePercentile(double userValue, double moyenne) {
    // Simuler un percentile basé sur l'écart à la moyenne
    final ecart = userValue - moyenne;
    final percentile = 50 + (ecart / moyenne * 50);
    return percentile.clamp(0, 100);
  }

  double _calculateTotalPoints() {
    final scoreService = ScoreService();
    final streakService = StreakService();
    final srsService = SpacedRepetitionService();

    double points = 0;
    
    // Points pour les quiz
    points += scoreService.scores.length * 10; // 10 pts par quiz
    points += scoreService.getGlobalAverage(); // Bonus qualité
    
    // Points pour le streak
    points += streakService.currentStreak * 5;
    points += streakService.longestStreak * 2;
    
    // Points pour le SRS
    points += srsService.getStatistics().masteredCards * 20;
    
    return points;
  }

  double _generateScore(int rank) {
    // Génère un score décroissant selon le rang
    return (1000 - rank * 8).toDouble();
  }

  String _generateRandomPseudo() {
    final adjectives = ['Rapide', 'Brillant', 'Assidu', 'Motivé', 'Génial', 'Studieux'];
    final nouns = ['Matheux', 'Agrégatif', 'Candidat', 'Étudiant', 'Chercheur'];
    final random = Random();
    return '${adjectives[random.nextInt(adjectives.length)]}${nouns[random.nextInt(nouns.length)]}${random.nextInt(999)}';
  }

  String _generateRandomAvatar() {
    final avatars = ['📚', '🎓', '✏️', '🧮', '📐', '🔢', '📊', '🎯', '🏆', '⭐'];
    return avatars[Random().nextInt(avatars.length)];
  }

  // Persistance
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/competition_profile.json');
  }

  Future<void> loadData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        _profile = AnonymousProfile.fromJson(data);
        _generateChallenges();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement profil compétition: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      if (_profile != null) {
        final file = await _getFile();
        await file.writeAsString(jsonEncode(_profile!.toJson()));
      }
    } catch (e) {
      debugPrint('Erreur sauvegarde profil: $e');
    }
  }

  /// Met à jour les stats publiques
  Future<void> updateStats() async {
    if (_profile != null) {
      final scoreService = ScoreService();
      final streakService = StreakService();
      final srsService = SpacedRepetitionService();

      _profile = AnonymousProfile(
        pseudonyme: _profile!.pseudonyme,
        avatar: _profile!.avatar,
        dateInscription: _profile!.dateInscription,
        statsPubliques: {
          'moyenneQuiz': scoreService.getGlobalAverage(),
          'streakActuel': streakService.currentStreak.toDouble(),
          'cartesMailrisees': srsService.getStatistics().masteredCards.toDouble(),
          'totalPoints': _calculateTotalPoints(),
        },
      );

      await _saveProfile();
      notifyListeners();
    }
  }
}
