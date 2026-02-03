import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/examen_blanc_model.dart';

class ExamenBlancService extends ChangeNotifier {
  static final ExamenBlancService _instance = ExamenBlancService._internal();
  factory ExamenBlancService() => _instance;
  ExamenBlancService._internal();

  List<ExamenBlanc> _examens = [];
  List<ExamenBlancResult> _results = [];

  List<ExamenBlanc> get examens => _examens;
  List<ExamenBlancResult> get results => _results;

  /// Charge les examens depuis les assets
  Future<void> loadExamens() async {
    try {
      // Pour l'instant, on crée des examens de démonstration
      _examens = _createDemoExamens();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement examens: $e');
    }
  }

  /// Sauvegarde un résultat d'examen
  Future<void> saveResult(ExamenBlancResult result) async {
    _results.insert(0, result);
    if (_results.length > 50) {
      _results = _results.take(50).toList();
    }
    await _saveResults();
    notifyListeners();
  }

  /// Obtient les statistiques
  ExamenBlancStatistics getStatistics() {
    if (_results.isEmpty) {
      return ExamenBlancStatistics(
        totalExamens: 0,
        examensTermines: 0,
        noteMoyenne: 0,
        tempsMoyen: 0,
        repartitionNotes: {},
        meilleurs: [],
      );
    }

    final termines = _results.where((r) => r.termine).toList();
    final noteMoyenne = termines.isEmpty
        ? 0.0
        : termines.map((r) => r.note).reduce((a, b) => a + b) / termines.length;
    final tempsMoyen = termines.isEmpty
        ? 0.0
        : termines.map((r) => r.dureeEffective).reduce((a, b) => a + b) / termines.length;

    // Répartition par tranche
    final repartition = <String, int>{
      '0-5': 0,
      '5-10': 0,
      '10-12': 0,
      '12-14': 0,
      '14-16': 0,
      '16-20': 0,
    };

    for (var result in termines) {
      if (result.note < 5) repartition['0-5'] = repartition['0-5']! + 1;
      else if (result.note < 10) repartition['5-10'] = repartition['5-10']! + 1;
      else if (result.note < 12) repartition['10-12'] = repartition['10-12']! + 1;
      else if (result.note < 14) repartition['12-14'] = repartition['12-14']! + 1;
      else if (result.note < 16) repartition['14-16'] = repartition['14-16']! + 1;
      else repartition['16-20'] = repartition['16-20']! + 1;
    }

    // Meilleurs résultats
    final meilleurs = List<ExamenBlancResult>.from(termines)
      ..sort((a, b) => b.note.compareTo(a.note));

    return ExamenBlancStatistics(
      totalExamens: _results.length,
      examensTermines: termines.length,
      noteMoyenne: noteMoyenne,
      tempsMoyen: tempsMoyen,
      repartitionNotes: repartition,
      meilleurs: meilleurs.take(5).toList(),
    );
  }

  // Persistance
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/examen_blanc_results.json');
  }

  Future<void> loadResults() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as List<dynamic>;
        _results = data
            .map((e) => ExamenBlancResult.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement résultats: $e');
    }
  }

  Future<void> _saveResults() async {
    try {
      final file = await _getFile();
      final data = _results.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde résultats: $e');
    }
  }

  /// Crée des examens de démonstration
  List<ExamenBlanc> _createDemoExamens() {
    return [
      ExamenBlanc(
        id: 'algebre_1',
        titre: 'Composition Algèbre et Géométrie - Sujet 1',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Espaces vectoriels et applications linéaires',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit E un espace vectoriel de dimension finie. Montrer qu\'un endomorphisme u est injectif si et seulement si il est surjectif.',
                indication: 'Utilisez le théorème du rang.',
                correction: 'Si u est injectif, alors dim(Ker(u)) = 0. Par le théorème du rang, dim(Im(u)) = dim(E), donc u est surjectif.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer la matrice de l\'application linéaire f: R³ → R² définie par f(x,y,z) = (x+y, 2y-z).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le rang de cette application.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Réduction des endomorphismes',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit A la matrice [[2,1],[0,2]]. Calculer les valeurs propres de A.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'A est-elle diagonalisable ? Justifier.',
                indication: 'Vérifiez la dimension des espaces propres.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer la forme de Jordan de A.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Produit scalaire et orthogonalité',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Soit E = R³ muni du produit scalaire canonique. Déterminer le projeté orthogonal du vecteur (1,2,3) sur le plan x+y+z=0.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer la distance de ce vecteur au plan.',
                points: 2,
              ),
            ],
          ),
        ],
      ),
      ExamenBlanc(
        id: 'analyse_1',
        titre: 'Composition Analyse et Probabilités - Sujet 1',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Suites et séries',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Étudier la convergence de la série ∑(1/n²).',
                indication: 'Comparez avec une série de Riemann.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Montrer que la suite u_n = ∑_{k=1}^n 1/k - ln(n) converge.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Fonctions de plusieurs variables',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x,y) = x²y + y³. Calculer le gradient de f.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Déterminer les points critiques de f.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Étudier leur nature (minimum, maximum, point selle).',
                indication: 'Utilisez la matrice hessienne.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Intégration',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Calculer ∫₀^∞ e^(-x²) dx.',
                indication: 'Utilisez une intégrale double.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'En déduire la valeur de ∫₀^∞ x²e^(-x²) dx.',
                points: 3,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
