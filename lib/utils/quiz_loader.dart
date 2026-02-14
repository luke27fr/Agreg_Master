import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/quiz_model.dart';
import '../pages/quiz_page.dart';
import 'theme_utils.dart';

/// Utilitaire centralisé pour charger et lancer les quiz
class QuizLoader {
  QuizLoader._();

  /// Charge toutes les questions du quiz
  static Future<List<QuizQuestion>> loadAllQuestions() async {
    final String response = await rootBundle.loadString(AppAssets.quizPath);
    final Map<String, dynamic> data = json.decode(response);
    final List<QuizQuestion> questions = [];
    data.forEach((key, value) {
      if (value is List) {
        for (var q in value) {
          questions.add(QuizQuestion.fromJson(q));
        }
      }
    });
    return questions;
  }

  /// Charge les questions d'une section spécifique
  static Future<List<QuizQuestion>> loadSectionQuestions(List<String> files) async {
    final String response = await rootBundle.loadString(AppAssets.quizPath);
    final Map<String, dynamic> data = json.decode(response);
    final List<QuizQuestion> questions = [];
    for (var file in files) {
      final key = file.replaceAll('.md', '');
      if (data.containsKey(key)) {
        for (var q in data[key]) {
          questions.add(QuizQuestion.fromJson(q));
        }
      }
    }
    return questions;
  }

  /// Charge les questions d'une fiche spécifique
  static Future<List<QuizQuestion>?> loadFicheQuestions(String ficheId) async {
    final String response = await rootBundle.loadString(AppAssets.quizPath);
    final Map<String, dynamic> data = json.decode(response);
    if (!data.containsKey(ficheId)) return null;
    final List<QuizQuestion> questions = [];
    for (var q in data[ficheId]) {
      questions.add(QuizQuestion.fromJson(q));
    }
    return questions;
  }

  /// Lance un quiz rapide (10 questions)
  static Future<void> startQuickQuiz(BuildContext context) async {
    try {
      List<QuizQuestion> questions = await loadAllQuestions();
      if (questions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.errorNoQuiz)),
          );
        }
        return;
      }
      questions.shuffle(Random());
      if (questions.length > AppNumbers.quickQuizLimit) {
        questions = questions.sublist(0, AppNumbers.quickQuizLimit);
      }
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: 'Quiz Rapide', questions: questions),
        ));
      }
    } catch (e) {
      debugPrint('Erreur quiz rapide: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  /// Lance un grand quiz (20 questions)
  static Future<void> startGrandQuiz(BuildContext context) async {
    try {
      List<QuizQuestion> questions = await loadAllQuestions();
      if (questions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.errorNoQuiz)),
          );
        }
        return;
      }
      questions.shuffle(Random());
      if (questions.length > AppNumbers.grandQuizLimit) {
        questions = questions.sublist(0, AppNumbers.grandQuizLimit);
      }
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: 'Grand Quiz Général', questions: questions),
        ));
      }
    } catch (e) {
      debugPrint('Erreur grand quiz: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  /// Lance un quiz de section
  static Future<void> startSectionQuiz(BuildContext context, String label, List<String> files) async {
    try {
      List<QuizQuestion> questions = await loadSectionQuestions(files);
      if (questions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pas de quiz pour ce chapitre !')),
          );
        }
        return;
      }
      questions.shuffle();
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: 'Quiz $label', questions: questions),
        ));
      }
    } catch (e) {
      debugPrint('Erreur quiz section: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  /// Lance un quiz d'une fiche
  static Future<void> startFicheQuiz(BuildContext context, String ficheId) async {
    try {
      final questions = await loadFicheQuestions(ficheId);
      if (questions == null || questions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pas de quiz pour cette fiche !')),
          );
        }
        return;
      }
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: ThemeUtils.getFicheTitle(ficheId), questions: questions, ficheId: ficheId),
        ));
      }
    } catch (e) {
      debugPrint('Erreur quiz fiche: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }
}
