import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../models/lecon_progress_model.dart';

class LeconProgressService extends ChangeNotifier {
  static final LeconProgressService _instance = LeconProgressService._internal();
  factory LeconProgressService() => _instance;
  LeconProgressService._internal();

  Map<String, LeconProgress> _progressMap = {};

  Map<String, LeconProgress> get progressMap => _progressMap;

  /// Obtient la progression pour une leçon
  LeconProgress? getProgress(String leconId) {
    return _progressMap[leconId];
  }

  /// Crée ou met à jour la progression d'une leçon
  Future<void> updateProgress(LeconProgress progress) async {
    _progressMap[progress.leconId] = progress;
    await _saveData();
    notifyListeners();
  }

  /// Initialise une nouvelle leçon
  Future<void> initializeLecon(
    String leconId,
    String leconNumero,
    String leconTitre,
    String domaine,
  ) async {
    if (!_progressMap.containsKey(leconId)) {
      _progressMap[leconId] = LeconProgress(
        leconId: leconId,
        leconNumero: leconNumero,
        leconTitre: leconTitre,
        domaine: domaine,
      );
      await _saveData();
      notifyListeners();
    }
  }

  /// Met à jour le temps d'étude
  Future<void> addStudyTime(String leconId, int minutes) async {
    if (_progressMap.containsKey(leconId)) {
      final progress = _progressMap[leconId]!;
      _progressMap[leconId] = progress.copyWith(
        tempsEtudeMinutes: progress.tempsEtudeMinutes + minutes,
        derniereRevision: DateTime.now(),
        nombreRevisions: progress.nombreRevisions + 1,
      );
      await _saveData();
      notifyListeners();
    }
  }

  /// Met à jour les niveaux de maîtrise
  Future<void> updateMasteryLevels(
    String leconId, {
    int? niveauPlan,
    int? niveauDeveloppements,
    int? niveauExemples,
    int? niveauReferencesBiblio,
  }) async {
    if (_progressMap.containsKey(leconId)) {
      final progress = _progressMap[leconId]!;
      _progressMap[leconId] = progress.copyWith(
        niveauPlan: niveauPlan ?? progress.niveauPlan,
        niveauDeveloppements: niveauDeveloppements ?? progress.niveauDeveloppements,
        niveauExemples: niveauExemples ?? progress.niveauExemples,
        niveauReferencesBiblio: niveauReferencesBiblio ?? progress.niveauReferencesBiblio,
        derniereRevision: DateTime.now(),
      );
      await _saveData();
      notifyListeners();
    }
  }

  /// Ajoute un développement maîtrisé
  Future<void> addMasteredDeveloppement(String leconId, String developpement) async {
    if (_progressMap.containsKey(leconId)) {
      final progress = _progressMap[leconId]!;
      if (!progress.developpementsChoisis.contains(developpement)) {
        final newList = List<String>.from(progress.developpementsChoisis)..add(developpement);
        _progressMap[leconId] = progress.copyWith(
          developpementsChoisis: newList,
          developpementsMaitrises: newList.length,
        );
        await _saveData();
        notifyListeners();
      }
    }
  }

  /// Ajoute une présentation à l'historique
  Future<void> addPresentation(
    String leconId,
    PresentationHistory presentation,
  ) async {
    if (_progressMap.containsKey(leconId)) {
      final progress = _progressMap[leconId]!;
      final newHistory = List<PresentationHistory>.from(progress.historiquePresentations)
        ..insert(0, presentation);
      _progressMap[leconId] = progress.copyWith(
        historiquePresentations: newHistory,
        derniereRevision: DateTime.now(),
      );
      await _saveData();
      notifyListeners();
    }
  }

  /// Obtient les statistiques par domaine
  DomaineStatistics getDomaineStatistics(String domaine) {
    final lecons = _progressMap.values.where((p) => p.domaine == domaine).toList();
    
    final commenced = lecons.where((l) => l.getMasteryLevel() > 0).length;
    final ready = lecons.where((l) => l.isReadyForOral()).length;
    final avgMastery = lecons.isEmpty
        ? 0.0
        : lecons.map((l) => l.getMasteryLevel()).reduce((a, b) => a + b) / lecons.length;
    final totalTime = lecons.map((l) => l.tempsEtudeMinutes).fold(0, (a, b) => a + b);

    return DomaineStatistics(
      domaine: domaine,
      totalLecons: lecons.length,
      leconsCommencees: commenced,
      leconsReady: ready,
      averageMastery: avgMastery,
      tempsTotal: totalTime,
    );
  }

  /// Obtient les leçons prêtes pour l'oral
  List<LeconProgress> getReadyLecons() {
    return _progressMap.values.where((p) => p.isReadyForOral()).toList();
  }

  /// Obtient les leçons à travailler en priorité
  List<LeconProgress> getPriorityLecons({int limit = 10}) {
    final notReady = _progressMap.values.where((p) => !p.isReadyForOral()).toList();
    
    // Trier par niveau de maîtrise croissant (les plus faibles en premier)
    notReady.sort((a, b) => a.getMasteryLevel().compareTo(b.getMasteryLevel()));
    
    return notReady.take(limit).toList();
  }

  /// Obtient les leçons récemment travaillées
  List<LeconProgress> getRecentLecons({int limit = 5}) {
    final withRevision = _progressMap.values
        .where((p) => p.derniereRevision != null)
        .toList();
    
    withRevision.sort((a, b) => b.derniereRevision!.compareTo(a.derniereRevision!));
    
    return withRevision.take(limit).toList();
  }

  /// Obtient les statistiques globales
  Map<String, dynamic> getGlobalStatistics() {
    final allLecons = _progressMap.values.toList();
    
    if (allLecons.isEmpty) {
      return {
        'total': 0,
        'commenced': 0,
        'ready': 0,
        'averageMastery': 0.0,
        'totalTime': 0,
        'developpementsMaitri ses': 0,
      };
    }

    return {
      'total': allLecons.length,
      'commenced': allLecons.where((l) => l.getMasteryLevel() > 0).length,
      'ready': allLecons.where((l) => l.isReadyForOral()).length,
      'averageMastery': allLecons.map((l) => l.getMasteryLevel()).reduce((a, b) => a + b) / allLecons.length,
      'totalTime': allLecons.map((l) => l.tempsEtudeMinutes).fold(0, (a, b) => a + b),
      'developpementsMaitrises': allLecons.map((l) => l.developpementsMaitrises).fold(0, (a, b) => a + b),
    };
  }

  // Persistance des données
  Future<void> loadData() async {
    try {
      final content = await StorageService.instance.read('lecon_progress.json');
      if (content != null) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        
        _progressMap = data.map(
          (key, value) => MapEntry(
            key,
            LeconProgress.fromJson(value as Map<String, dynamic>),
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement progression leçons: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final data = _progressMap.map((key, value) => MapEntry(key, value.toJson()));
      await StorageService.instance.write('lecon_progress.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde progression: $e');
    }
  }

  /// Réinitialise toutes les données
  Future<void> clearAllData() async {
    _progressMap.clear();
    await _saveData();
    notifyListeners();
  }
}
