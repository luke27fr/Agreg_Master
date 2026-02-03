import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/jury_virtuel_model.dart';

class JuryVirtuelService extends ChangeNotifier {
  static final JuryVirtuelService _instance = JuryVirtuelService._internal();
  factory JuryVirtuelService() => _instance;
  JuryVirtuelService._internal();

  List<JurySession> _sessions = [];
  Map<String, List<JuryQuestion>> _questionBank = {};

  List<JurySession> get sessions => _sessions;

  /// Initialise la banque de questions (générique pour toutes les leçons)
  void initializeQuestionBank() {
    _questionBank = {
      'general': [
        JuryQuestion(
          id: 'def_1',
          question: 'Pouvez-vous rappeler la définition principale de cette leçon ?',
          categorie: 'definition',
          motsCles: ['définition'],
          difficulte: 1,
        ),
        JuryQuestion(
          id: 'ex_1',
          question: 'Donnez un exemple d\'application de ce concept.',
          categorie: 'exemple',
          motsCles: ['exemple', 'application'],
          difficulte: 2,
        ),
        JuryQuestion(
          id: 'contre_1',
          question: 'Connaissez-vous un contre-exemple important ?',
          categorie: 'contre-exemple',
          motsCles: ['contre-exemple', 'pathologique'],
          difficulte: 3,
        ),
        JuryQuestion(
          id: 'lien_1',
          question: 'Quel est le lien avec [autre concept de la leçon] ?',
          categorie: 'lien',
          motsCles: ['relation', 'connexion'],
          difficulte: 3,
        ),
        JuryQuestion(
          id: 'gen_1',
          question: 'Comment ce résultat se généralise-t-il ?',
          categorie: 'generalisation',
          motsCles: ['généralisation', 'cas particulier'],
          difficulte: 4,
        ),
        JuryQuestion(
          id: 'app_1',
          question: 'Quelle est une application concrète de ce théorème ?',
          categorie: 'application',
          motsCles: ['utilité', 'application'],
          difficulte: 3,
        ),
        JuryQuestion(
          id: 'dev_1',
          question: 'Pouvez-vous développer la preuve du résultat principal ?',
          categorie: 'developpement',
          motsCles: ['démonstration', 'preuve'],
          difficulte: 5,
          reponseType: 'developpement',
        ),
        JuryQuestion(
          id: 'calc_1',
          question: 'Calculez explicitement dans un exemple simple.',
          categorie: 'calcul',
          motsCles: ['calcul', 'exemple'],
          difficulte: 3,
          reponseType: 'calcul',
        ),
        JuryQuestion(
          id: 'hyp_1',
          question: 'Les hypothèses du théorème sont-elles toutes nécessaires ?',
          categorie: 'hypotheses',
          motsCles: ['hypothèses', 'conditions'],
          difficulte: 4,
        ),
        JuryQuestion(
          id: 'hist_1',
          question: 'Connaissez-vous l\'historique de ce résultat ?',
          categorie: 'histoire',
          motsCles: ['histoire', 'auteur'],
          difficulte: 2,
        ),
      ],
    };
  }

  /// Génère une session de questions pour une leçon
  JurySession createSession(String leconId, String leconTitre) {
    initializeQuestionBank();
    
    // Sélectionner 5-8 questions variées
    final questions = _selectQuestions(leconId);
    
    final session = JurySession(
      id: 'jury_${DateTime.now().millisecondsSinceEpoch}',
      leconId: leconId,
      leconTitre: leconTitre,
      dateDebut: DateTime.now(),
      questionsReponses: questions.map((q) => JuryQuestionAnswer(
        question: q,
        heureQuestion: DateTime.now(),
        tempsReponseSecondes: 0,
      )).toList(),
      dureeMinutes: 0,
    );

    return session;
  }

  /// Sélectionne des questions variées pour une session
  List<JuryQuestion> _selectQuestions(String leconId) {
    final generalQuestions = _questionBank['general'] ?? [];
    final random = Random();
    
    // Sélectionner 6 questions de catégories variées
    final selected = <JuryQuestion>[];
    final categories = <String>[];
    
    // Toujours commencer par une définition
    selected.add(generalQuestions.firstWhere((q) => q.categorie == 'definition'));
    categories.add('definition');
    
    // Ajouter d'autres questions variées
    while (selected.length < 6 && generalQuestions.length > selected.length) {
      final candidate = generalQuestions[random.nextInt(generalQuestions.length)];
      if (!selected.contains(candidate) && !categories.contains(candidate.categorie)) {
        selected.add(candidate);
        categories.add(candidate.categorie);
      }
    }
    
    // Trier par difficulté croissante
    selected.sort((a, b) => a.difficulte.compareTo(b.difficulte));
    
    return selected;
  }

  /// Sauvegarde une session terminée
  Future<void> saveSession(JurySession session) async {
    _sessions.insert(0, session);
    if (_sessions.length > 50) {
      _sessions = _sessions.take(50).toList();
    }
    await _saveSessions();
    notifyListeners();
  }

  /// Obtient les statistiques
  JuryStatistics getStatistics() {
    if (_sessions.isEmpty) {
      return JuryStatistics(
        totalSessions: 0,
        totalQuestions: 0,
        tempsReponseMoyen: 0,
        scoreQualiteMoyen: 0,
        repartitionCategories: {},
        categoriesDifficiles: [],
      );
    }

    final allQA = _sessions.expand((s) => s.questionsReponses).toList();
    final totalQuestions = allQA.length;
    
    final tempsTotal = allQA
        .map((qa) => qa.tempsReponseSecondes)
        .fold(0, (a, b) => a + b);
    
    final scores = allQA
        .where((qa) => qa.autoEvaluation != null)
        .map((qa) => qa.autoEvaluation!)
        .toList();
    
    final scoreMoyen = scores.isEmpty
        ? 0.0
        : scores.fold(0, (a, b) => a + b) / scores.length;

    // Répartition par catégorie
    final repartition = <String, int>{};
    for (var qa in allQA) {
      final cat = qa.question.categorie;
      repartition[cat] = (repartition[cat] ?? 0) + 1;
    }

    // Catégories difficiles (score moyen < 3)
    final difficiles = <String>[];
    final byCat = <String, List<int>>{};
    for (var qa in allQA.where((qa) => qa.autoEvaluation != null)) {
      byCat.putIfAbsent(qa.question.categorie, () => []).add(qa.autoEvaluation!);
    }
    
    byCat.forEach((cat, scores) {
      final avg = scores.fold(0, (a, b) => a + b) / scores.length;
      if (avg < 3) {
        difficiles.add(cat);
      }
    });

    return JuryStatistics(
      totalSessions: _sessions.length,
      totalQuestions: totalQuestions,
      tempsReponseMoyen: totalQuestions > 0 ? tempsTotal / totalQuestions : 0,
      scoreQualiteMoyen: scoreMoyen,
      repartitionCategories: repartition,
      categoriesDifficiles: difficiles,
    );
  }

  // Persistance
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/jury_sessions.json');
  }

  Future<void> loadData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as List<dynamic>;
        _sessions = data
            .map((e) => JurySession.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement jury sessions: $e');
    }
  }

  Future<void> _saveSessions() async {
    try {
      final file = await _getFile();
      final data = _sessions.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde jury sessions: $e');
    }
  }
}
