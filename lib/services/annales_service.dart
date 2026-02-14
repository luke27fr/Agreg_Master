import 'package:flutter/foundation.dart';
import '../models/annale_model.dart';
import 'annales_enriched_data.dart';

class AnnalesService extends ChangeNotifier {
  List<Annale> _annales = [];
  bool _isLoading = false;
  String? _error;

  List<Annale> get annales => _annales;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtres
  List<Annale> getByYear(int year) {
    return _annales.where((a) => a.annee == year).toList();
  }

  List<Annale> getBySession(String session) {
    return _annales.where((a) => a.session == session).toList();
  }

  List<Annale> getByType(String typeEpreuve) {
    return _annales.where((a) => a.typeEpreuve == typeEpreuve).toList();
  }

  List<Annale> getByTheme(String theme) {
    return _annales.where((a) => a.themes.contains(theme)).toList();
  }

  List<Annale> getRecent({int limit = 5}) {
    final sorted = List<Annale>.from(_annales)
      ..sort((a, b) => b.annee.compareTo(a.annee));
    return sorted.take(limit).toList();
  }

  List<int> getAvailableYears() {
    return _annales.map((a) => a.annee).toSet().toList()..sort((a, b) => b.compareTo(a));
  }

  Future<void> loadAnnales() async {
    if (_annales.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Charger les annales enrichies
      _annales = AnnalesEnrichedData.getAllAnnales();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Données de démonstration supprimées — tout passe par AnnalesEnrichedData.
}
