import 'package:flutter/material.dart';

/// Constantes de couleurs de l'application
class AppColors {
  AppColors._();

  // Couleurs principales
  static const Color primaryDark = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color primaryAccent = Color(0xFF5C6BC0);

  // Couleurs de surface
  static const Color surfaceLight = Color(0xFFF5F7FA);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);

  // Couleurs par thème/matière
  static const Color algebreColor = Color(0xFF3F51B5);
  static const Color analyseColor = Color(0xFFE91E63);
  static const Color probaColor = Color(0xFF009688);
  static const Color geometrieColor = Color(0xFFFF9800);
  static const Color defaultThemeColor = Color(0xFF607D8B);

  // Couleurs de score
  static const Color scoreExcellent = Colors.green;
  static const Color scoreBon = Colors.orange;
  static const Color scoreFaible = Colors.red;

  // Couleurs de niveau
  static const Color niveauExpert = Colors.green;
  static const Color niveauAvance = Colors.teal;
  static const Color niveauIntermediaire = Colors.orange;
  static const Color niveauProgression = Colors.deepOrange;
  static const Color niveauDebutant = Colors.grey;

  /// Retourne la couleur de score en fonction du pourcentage
  static Color getScoreColor(double percentage) {
    if (percentage >= 80) return scoreExcellent;
    if (percentage >= 60) return scoreBon;
    return scoreFaible;
  }

  /// Retourne la couleur de niveau en fonction de la moyenne
  static Color getNiveauColor(double avg) {
    if (avg >= 80) return niveauExpert;
    if (avg >= 65) return niveauAvance;
    if (avg >= 50) return niveauIntermediaire;
    if (avg >= 30) return niveauProgression;
    return niveauDebutant;
  }
}

/// Constantes numériques de l'application
class AppNumbers {
  AppNumbers._();

  // Limites de quiz
  static const int quickQuizLimit = 10;
  static const int grandQuizLimit = 20;

  // Seuils de score
  static const double scoreExcellentThreshold = 80;
  static const double scoreBonThreshold = 60;

  // Seuils de niveau
  static const double niveauExpertThreshold = 80;
  static const double niveauAvanceThreshold = 65;
  static const double niveauIntermediaireThreshold = 50;
  static const double niveauProgressionThreshold = 30;

  // Breakpoints responsive
  static const double breakpointLargeDesktop = 1100;
  static const double breakpointTablet = 700;

  // Pomodoro (minutes)
  static const int pomodoroWorkMinutes = 25;
  static const int pomodoroShortBreakMinutes = 5;
  static const int pomodoroLongBreakMinutes = 15;

  // Debounce
  static const int searchDebounceDurationMs = 300;

  // SM-2 Algorithm
  static const double minEaseFactor = 1.3;
  static const double defaultEaseFactor = 2.5;
  static const int sm2CorrectThreshold = 3;
  static const int sm2QualityMin = 0;
  static const int sm2QualityMax = 5;

  // Mastery levels
  static const int masteryMin = 0;
  static const int masteryMax = 100;
}

/// Constantes de texte
class AppStrings {
  AppStrings._();

  static const String appName = 'Agreg Master';
  static const String appVersion = 'v1.0.0';
  static const String appTagline = 'Votre compagnon pour l\'agrégation';

  // Niveaux
  static String getNiveau(double avg) {
    if (avg >= AppNumbers.niveauExpertThreshold) return 'Expert';
    if (avg >= AppNumbers.niveauAvanceThreshold) return 'Avancé';
    if (avg >= AppNumbers.niveauIntermediaireThreshold) return 'Intermédiaire';
    if (avg >= AppNumbers.niveauProgressionThreshold) return 'En progression';
    return 'Débutant';
  }

  // Messages de score
  static String getScoreMessage(int completedCount, double globalAvg) {
    if (completedCount == 0) return 'Commence par un quiz !';
    if (globalAvg >= 80) return 'Excellent niveau ! 🎉';
    if (globalAvg >= 60) return 'Bon travail, continue ! 👍';
    return 'Continue tes efforts ! 💪';
  }

  // Conseils
  static const List<String> conseilsAccueil = [
    'Maîtrisez parfaitement 2 développements par leçon',
    'Travaillez les leçons par thème et non par numéro',
    'Pratiquez régulièrement les simulations orales',
    'Révisez les contre-exemples classiques',
    'Anticipez les questions du jury',
    'Relisez les rapports du jury récents',
    'Alternez algèbre, analyse et géométrie',
  ];

  static const List<String> conseilsOrganisation = [
    'Révisez une leçon d\'algèbre et une d\'analyse chaque jour',
    'Faites un examen blanc complet par semaine',
    'Utilisez le Pomodoro pour les sessions longues',
    'Préparez 2-3 développements par semaine',
  ];

  // Erreurs
  static const String errorLoadingData = 'Erreur lors du chargement des données';
  static const String errorNoQuiz = 'Pas de quiz disponible pour le moment';
  static const String errorNoFavorites = 'Aucun favori pour le moment';
  static const String errorBackupNotFound = 'Fichier de backup introuvable';
  static const String errorBackupIncompatible = 'Version de backup incompatible';
  static const String errorNetwork = 'Erreur réseau, vérifiez votre connexion';
}

/// Assets paths
class AppAssets {
  AppAssets._();

  static const String manifestPath = 'assets/fiches/manifest.json';
  static const String quizPath = 'assets/data/quiz.json';
  static const String exercicesPath = 'assets/data/exercices.json';
  static const String demonstrationsPath = 'assets/data/demonstrations.json';
  static const String contreExemplesPath = 'assets/data/contre_exemples.json';
  static const String questionsJuryPath = 'assets/data/questions_jury.json';
  static const String bibliographiePath = 'assets/data/bibliographie.json';
  static const String leconsPath = 'assets/data/lecons.json';
  static const String developpementsPath = 'assets/data/developpements.json';
}
