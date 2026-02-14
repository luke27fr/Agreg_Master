import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/constants/app_constants.dart';

void main() {
  group('AppColors', () {
    test('getScoreColor returns correct colors', () {
      expect(AppColors.getScoreColor(90), AppColors.scoreExcellent);
      expect(AppColors.getScoreColor(80), AppColors.scoreExcellent);
      expect(AppColors.getScoreColor(70), AppColors.scoreBon);
      expect(AppColors.getScoreColor(60), AppColors.scoreBon);
      expect(AppColors.getScoreColor(50), AppColors.scoreFaible);
      expect(AppColors.getScoreColor(0), AppColors.scoreFaible);
    });

    test('getNiveauColor returns correct colors', () {
      expect(AppColors.getNiveauColor(90), AppColors.niveauExpert);
      expect(AppColors.getNiveauColor(70), AppColors.niveauAvance);
      expect(AppColors.getNiveauColor(55), AppColors.niveauIntermediaire);
      expect(AppColors.getNiveauColor(35), AppColors.niveauProgression);
      expect(AppColors.getNiveauColor(10), AppColors.niveauDebutant);
    });
  });

  group('AppStrings', () {
    test('getNiveau returns correct level names', () {
      expect(AppStrings.getNiveau(90), 'Expert');
      expect(AppStrings.getNiveau(70), 'Avancé');
      expect(AppStrings.getNiveau(55), 'Intermédiaire');
      expect(AppStrings.getNiveau(35), 'En progression');
      expect(AppStrings.getNiveau(10), 'Débutant');
    });

    test('getScoreMessage returns appropriate messages', () {
      expect(AppStrings.getScoreMessage(0, 0), contains('quiz'));
      expect(AppStrings.getScoreMessage(10, 85), contains('Excellent'));
      expect(AppStrings.getScoreMessage(10, 65), contains('Bon'));
      expect(AppStrings.getScoreMessage(10, 40), contains('Continue'));
    });

    test('conseils lists are not empty', () {
      expect(AppStrings.conseilsAccueil, isNotEmpty);
      expect(AppStrings.conseilsOrganisation, isNotEmpty);
    });
  });

  group('AppNumbers', () {
    test('quiz limits are valid', () {
      expect(AppNumbers.quickQuizLimit, greaterThan(0));
      expect(AppNumbers.grandQuizLimit, greaterThan(AppNumbers.quickQuizLimit));
    });

    test('score thresholds are ordered correctly', () {
      expect(AppNumbers.scoreExcellentThreshold, greaterThan(AppNumbers.scoreBonThreshold));
    });

    test('niveau thresholds are ordered correctly', () {
      expect(AppNumbers.niveauExpertThreshold, greaterThan(AppNumbers.niveauAvanceThreshold));
      expect(AppNumbers.niveauAvanceThreshold, greaterThan(AppNumbers.niveauIntermediaireThreshold));
      expect(AppNumbers.niveauIntermediaireThreshold, greaterThan(AppNumbers.niveauProgressionThreshold));
    });

    test('SM-2 constants are valid', () {
      expect(AppNumbers.minEaseFactor, greaterThan(0));
      expect(AppNumbers.defaultEaseFactor, greaterThan(AppNumbers.minEaseFactor));
      expect(AppNumbers.sm2QualityMax, greaterThan(AppNumbers.sm2QualityMin));
    });

    test('Pomodoro values are positive', () {
      expect(AppNumbers.pomodoroWorkMinutes, greaterThan(0));
      expect(AppNumbers.pomodoroShortBreakMinutes, greaterThan(0));
      expect(AppNumbers.pomodoroLongBreakMinutes, greaterThan(AppNumbers.pomodoroShortBreakMinutes));
    });
  });

  group('AppAssets', () {
    test('all paths start with assets/', () {
      expect(AppAssets.manifestPath, startsWith('assets/'));
      expect(AppAssets.quizPath, startsWith('assets/'));
      expect(AppAssets.exercicesPath, startsWith('assets/'));
      expect(AppAssets.demonstrationsPath, startsWith('assets/'));
      expect(AppAssets.contreExemplesPath, startsWith('assets/'));
      expect(AppAssets.questionsJuryPath, startsWith('assets/'));
      expect(AppAssets.bibliographiePath, startsWith('assets/'));
      expect(AppAssets.leconsPath, startsWith('assets/'));
      expect(AppAssets.developpementsPath, startsWith('assets/'));
    });
  });
}
