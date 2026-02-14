import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

/// Service singleton pour gérer les fiches favorites
class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final Set<String> _favorites = {};
  bool _isLoaded = false;

  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool get isLoaded => _isLoaded;

  /// Charge les favoris depuis le fichier local
  Future<void> loadFavorites() async {
    if (_isLoaded) return;
    
    try {
      final content = await StorageService.instance.read('agreg_master_favorites.json');
      if (content != null) {
        final List<dynamic> data = jsonDecode(content);
        _favorites.clear();
        _favorites.addAll(data.cast<String>());
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement favoris: $e');
      _isLoaded = true;
    }
  }

  /// Vérifie si une fiche est en favoris
  bool isFavorite(String ficheId) => _favorites.contains(ficheId);

  /// Ajoute ou retire une fiche des favoris
  Future<void> toggleFavorite(String ficheId) async {
    if (_favorites.contains(ficheId)) {
      _favorites.remove(ficheId);
    } else {
      _favorites.add(ficheId);
    }
    notifyListeners();
    await _persistFavorites();
  }

  /// Ajoute une fiche aux favoris
  Future<void> addFavorite(String ficheId) async {
    if (!_favorites.contains(ficheId)) {
      _favorites.add(ficheId);
      notifyListeners();
      await _persistFavorites();
    }
  }

  /// Retire une fiche des favoris
  Future<void> removeFavorite(String ficheId) async {
    if (_favorites.remove(ficheId)) {
      notifyListeners();
      await _persistFavorites();
    }
  }

  Future<void> _persistFavorites() async {
    try {
      await StorageService.instance.write('agreg_master_favorites.json', jsonEncode(_favorites.toList()));
    } catch (e) {
      debugPrint('Erreur sauvegarde favoris: $e');
    }
  }
}
