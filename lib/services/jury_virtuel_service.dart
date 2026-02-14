import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
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
          indicePedagogique: 'Soyez précis sur les hypothèses et les quantificateurs. Le jury attend une formulation rigoureuse.',
          pointsCles: [
            'Énoncer la définition avec toutes les hypothèses',
            'Préciser le cadre (espace, structure algébrique...)',
            'Mentionner les cas limites ou dégénérés',
            'Donner un exemple immédiat illustrant la définition',
          ],
        ),
        JuryQuestion(
          id: 'ex_1',
          question: 'Donnez un exemple d\'application de ce concept.',
          categorie: 'exemple',
          motsCles: ['exemple', 'application'],
          difficulte: 2,
          indicePedagogique: 'Choisissez un exemple non trivial mais accessible. Le jury apprécie les exemples qui illustrent la richesse du concept.',
          pointsCles: [
            'Choisir un exemple pertinent et non trivial',
            'Vérifier explicitement les hypothèses sur l\'exemple',
            'Montrer en quoi l\'exemple illustre le concept',
            'Si possible, mentionner une application concrète',
          ],
        ),
        JuryQuestion(
          id: 'contre_1',
          question: 'Connaissez-vous un contre-exemple important ?',
          categorie: 'contre-exemple',
          motsCles: ['contre-exemple', 'pathologique'],
          difficulte: 3,
          indicePedagogique: 'Les contre-exemples montrent que vous comprenez les limites du résultat. Précisez quelle hypothèse est violée.',
          pointsCles: [
            'Exhiber un contre-exemple précis',
            'Identifier l\'hypothèse qui est violée',
            'Expliquer pourquoi la conclusion tombe en défaut',
            'Mentionner si le contre-exemple est classique (Weierstrass, Dirichlet...)',
          ],
        ),
        JuryQuestion(
          id: 'lien_1',
          question: 'Quel est le lien avec les autres concepts de la leçon ?',
          categorie: 'lien',
          motsCles: ['relation', 'connexion'],
          difficulte: 3,
          indicePedagogique: 'Le jury cherche à évaluer votre vision d\'ensemble. Montrez les connexions entre les résultats.',
          pointsCles: [
            'Identifier les liens logiques (implication, équivalence)',
            'Montrer comment les résultats s\'enchaînent',
            'Mentionner les outils communs utilisés',
            'Faire le pont avec d\'autres domaines si pertinent',
          ],
        ),
        JuryQuestion(
          id: 'gen_1',
          question: 'Comment ce résultat se généralise-t-il ?',
          categorie: 'generalisation',
          motsCles: ['généralisation', 'cas particulier'],
          difficulte: 4,
          indicePedagogique: 'Montrez que vous savez situer le résultat dans un contexte plus large. Quelles hypothèses peut-on affaiblir ?',
          pointsCles: [
            'Énoncer la version plus générale du résultat',
            'Identifier les hypothèses qu\'on peut affaiblir',
            'Préciser ce qu\'on perd en généralisant',
            'Donner le cadre optimal (catégories, espaces fonctionnels...)',
          ],
        ),
        JuryQuestion(
          id: 'app_1',
          question: 'Quelle est une application concrète de ce théorème ?',
          categorie: 'application',
          motsCles: ['utilité', 'application'],
          difficulte: 3,
          indicePedagogique: 'Les applications montrent l\'utilité du résultat. Privilégiez les applications dans d\'autres domaines des mathématiques.',
          pointsCles: [
            'Décrire une application précise et pertinente',
            'Expliquer comment le théorème intervient',
            'Mentionner les domaines concernés (analyse, algèbre, physique...)',
            'Si possible, donner un énoncé de corollaire utile',
          ],
        ),
        JuryQuestion(
          id: 'dev_1',
          question: 'Pouvez-vous développer la preuve du résultat principal ?',
          categorie: 'developpement',
          motsCles: ['démonstration', 'preuve'],
          difficulte: 5,
          reponseType: 'developpement',
          indicePedagogique: 'Donnez les grandes étapes de la preuve. Le jury n\'attend pas tous les détails mais la structure logique.',
          pointsCles: [
            'Annoncer la stratégie de preuve (récurrence, absurde, construction...)',
            'Donner les étapes clés avec les arguments essentiels',
            'Mentionner les lemmes techniques utilisés',
            'Identifier les points délicats de la preuve',
            'Conclure proprement',
          ],
        ),
        JuryQuestion(
          id: 'calc_1',
          question: 'Calculez explicitement dans un exemple simple.',
          categorie: 'calcul',
          motsCles: ['calcul', 'exemple'],
          difficulte: 3,
          reponseType: 'calcul',
          indicePedagogique: 'Le jury veut voir que vous savez manipuler. Choisissez un exemple où le calcul est faisable au tableau.',
          pointsCles: [
            'Choisir un exemple de taille raisonnable',
            'Poser clairement les données et le résultat attendu',
            'Effectuer le calcul sans erreur',
            'Vérifier le résultat (cohérence, cas particuliers)',
          ],
        ),
        JuryQuestion(
          id: 'hyp_1',
          question: 'Les hypothèses du théorème sont-elles toutes nécessaires ?',
          categorie: 'hypotheses',
          motsCles: ['hypothèses', 'conditions'],
          difficulte: 4,
          indicePedagogique: 'Question piège classique du jury. Pour chaque hypothèse, montrez qu\'elle est nécessaire avec un contre-exemple.',
          pointsCles: [
            'Lister toutes les hypothèses du théorème',
            'Pour chaque hypothèse, dire si elle est nécessaire',
            'Fournir un contre-exemple quand on retire une hypothèse',
            'Mentionner si certaines hypothèses peuvent être affaiblies',
          ],
        ),
        JuryQuestion(
          id: 'hist_1',
          question: 'Connaissez-vous l\'historique de ce résultat ?',
          categorie: 'histoire',
          motsCles: ['histoire', 'auteur'],
          difficulte: 2,
          indicePedagogique: 'Quelques éléments historiques montrent votre culture mathématique. Pas besoin d\'être exhaustif.',
          pointsCles: [
            'Nommer le(s) mathématicien(s) à l\'origine du résultat',
            'Situer approximativement l\'époque',
            'Mentionner le contexte de la découverte si connu',
            'Évoquer les évolutions ultérieures du résultat',
          ],
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
  Future<void> loadData() async {
    try {
      final content = await StorageService.instance.read('jury_sessions.json');
      if (content != null) {
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
      final data = _sessions.map((e) => e.toJson()).toList();
      await StorageService.instance.write('jury_sessions.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde jury sessions: $e');
    }
  }
}
