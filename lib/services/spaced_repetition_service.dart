import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../models/spaced_repetition_model.dart';

class SpacedRepetitionService extends ChangeNotifier {
  static final SpacedRepetitionService _instance = SpacedRepetitionService._internal();
  factory SpacedRepetitionService() => _instance;
  SpacedRepetitionService._internal();

  Map<String, SpacedRepetitionCard> _cards = {};
  Set<String> _reviewedToday = {};

  Map<String, SpacedRepetitionCard> get cards => _cards;
  
  /// Retourne les fiches à réviser aujourd'hui
  List<SpacedRepetitionCard> getDueCards() {
    return _cards.values.where((card) => card.isDueForReview()).toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  /// Retourne les fiches à venir (prochains 7 jours)
  List<SpacedRepetitionCard> getUpcomingCards({int days = 7}) {
    final deadline = DateTime.now().add(Duration(days: days));
    return _cards.values
        .where((card) => 
            !card.isDueForReview() && 
            card.nextReviewDate.isBefore(deadline))
        .toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  /// Initialise une nouvelle fiche dans le système SRS
  void addCard(String ficheId) {
    if (!_cards.containsKey(ficheId)) {
      _cards[ficheId] = SpacedRepetitionCard(
        ficheId: ficheId,
        nextReviewDate: DateTime.now(),
      );
      _saveData();
      notifyListeners();
    }
  }

  /// Met à jour une fiche après révision
  /// quality: 0-5 (0=échec total, 3=difficile, 4=bien, 5=parfait)
  void reviewCard(String ficheId, int quality) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError('Quality must be between 0 and 5');
    }

    if (!_cards.containsKey(ficheId)) {
      addCard(ficheId);
    }

    _cards[ficheId] = _cards[ficheId]!.afterReview(quality);
    _reviewedToday.add(ficheId);
    _saveData();
    notifyListeners();
  }

  /// Obtient la carte SRS pour une fiche
  SpacedRepetitionCard? getCard(String ficheId) {
    return _cards[ficheId];
  }

  /// Statistiques globales
  ReviewStatistics getStatistics() {
    final dueToday = getDueCards().length;
    final totalCards = _cards.length;
    final masteredCards = _cards.values
        .where((card) => card.getMasteryLevel() >= 80)
        .length;
    
    final averageMastery = totalCards > 0
        ? _cards.values
            .map((card) => card.getMasteryLevel())
            .reduce((a, b) => a + b) / totalCards
        : 0.0;

    return ReviewStatistics(
      totalCards: totalCards,
      dueToday: dueToday,
      reviewedToday: _reviewedToday.length,
      masteredCards: masteredCards,
      averageMastery: averageMastery,
    );
  }

  /// Réinitialise le compteur de révisions du jour (à appeler chaque jour)
  void resetDailyReviews() {
    // Vérifie si c'est un nouveau jour
    if (_reviewedToday.isNotEmpty) {
      _reviewedToday.clear();
      _saveData();
      notifyListeners();
    }
  }

  /// Obtient les fiches par niveau de maîtrise
  Map<String, List<SpacedRepetitionCard>> getCardsByMasteryLevel() {
    return {
      'Débutant (0-20%)': _cards.values
          .where((c) => c.getMasteryLevel() <= 20)
          .toList(),
      'Apprentissage (21-40%)': _cards.values
          .where((c) => c.getMasteryLevel() > 20 && c.getMasteryLevel() <= 40)
          .toList(),
      'Intermédiaire (41-60%)': _cards.values
          .where((c) => c.getMasteryLevel() > 40 && c.getMasteryLevel() <= 60)
          .toList(),
      'Avancé (61-80%)': _cards.values
          .where((c) => c.getMasteryLevel() > 60 && c.getMasteryLevel() <= 80)
          .toList(),
      'Maîtrisé (81-100%)': _cards.values
          .where((c) => c.getMasteryLevel() > 80)
          .toList(),
    };
  }

  // Persistance des données
  Future<void> loadData() async {
    try {
      final content = await StorageService.instance.read('spaced_repetition.json');
      if (content != null) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        
        _cards = (data['cards'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            SpacedRepetitionCard.fromJson(value as Map<String, dynamic>),
          ),
        );

        _reviewedToday = (data['reviewedToday'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toSet() ?? {};

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement SRS: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final data = {
        'cards': _cards.map((key, value) => MapEntry(key, value.toJson())),
        'reviewedToday': _reviewedToday.toList(),
        'lastSave': DateTime.now().toIso8601String(),
      };
      await StorageService.instance.write('spaced_repetition.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde SRS: $e');
    }
  }

  /// Supprime une fiche du système
  void removeCard(String ficheId) {
    _cards.remove(ficheId);
    _reviewedToday.remove(ficheId);
    _saveData();
    notifyListeners();
  }

  /// Réinitialise toutes les données
  Future<void> clearAllData() async {
    _cards.clear();
    _reviewedToday.clear();
    await _saveData();
    notifyListeners();
  }
}
