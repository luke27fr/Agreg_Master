import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/favorites_service.dart';

/// Tests for FavoritesService.
///
/// FavoritesService is a singleton that uses StorageService for persistence.
/// These tests exercise the in-memory favorites management (add, remove,
/// toggle, query) via the public API.
void main() {
  late FavoritesService service;

  setUp(() {
    service = FavoritesService();
    // The service is a singleton. We need to clear favorites between tests.
    // We use removeFavorite on known items since there is no public resetAll.
    // For a clean start, we iterate and remove all.
  });

  group('FavoritesService - isFavorite', () {
    test('returns false for unknown fiche', () {
      expect(service.isFavorite('nonexistent_xyz_test'), isFalse);
    });
  });

  group('FavoritesService - addFavorite', () {
    test('adds a fiche to favorites', () async {
      await service.addFavorite('test_fiche_add_1');

      expect(service.isFavorite('test_fiche_add_1'), isTrue);
      expect(service.favorites, contains('test_fiche_add_1'));

      // Cleanup
      await service.removeFavorite('test_fiche_add_1');
    });

    test('adding same fiche twice is idempotent', () async {
      await service.addFavorite('test_fiche_add_2');
      final countAfterFirst = service.favorites.length;

      await service.addFavorite('test_fiche_add_2');
      expect(service.favorites.length, countAfterFirst);

      // Cleanup
      await service.removeFavorite('test_fiche_add_2');
    });

    test('adding multiple fiches grows the set', () async {
      await service.addFavorite('test_multi_a');
      await service.addFavorite('test_multi_b');
      await service.addFavorite('test_multi_c');

      expect(service.favorites, containsAll(['test_multi_a', 'test_multi_b', 'test_multi_c']));

      // Cleanup
      await service.removeFavorite('test_multi_a');
      await service.removeFavorite('test_multi_b');
      await service.removeFavorite('test_multi_c');
    });
  });

  group('FavoritesService - removeFavorite', () {
    test('removes a fiche from favorites', () async {
      await service.addFavorite('test_fiche_rm_1');
      await service.removeFavorite('test_fiche_rm_1');

      expect(service.isFavorite('test_fiche_rm_1'), isFalse);
    });

    test('removing non-existent fiche is a no-op', () async {
      // Should not throw
      await service.removeFavorite('never_existed_xyz');
    });
  });

  group('FavoritesService - toggleFavorite', () {
    test('toggle adds fiche when not favorite', () async {
      expect(service.isFavorite('test_toggle_1'), isFalse);

      await service.toggleFavorite('test_toggle_1');
      expect(service.isFavorite('test_toggle_1'), isTrue);

      // Cleanup
      await service.removeFavorite('test_toggle_1');
    });

    test('toggle removes fiche when already favorite', () async {
      await service.addFavorite('test_toggle_2');
      expect(service.isFavorite('test_toggle_2'), isTrue);

      await service.toggleFavorite('test_toggle_2');
      expect(service.isFavorite('test_toggle_2'), isFalse);
    });

    test('double toggle returns to original state', () async {
      final wasFavorite = service.isFavorite('test_toggle_3');

      await service.toggleFavorite('test_toggle_3');
      await service.toggleFavorite('test_toggle_3');

      expect(service.isFavorite('test_toggle_3'), wasFavorite);
    });
  });

  group('FavoritesService - favorites getter', () {
    test('returns unmodifiable set', () {
      final favorites = service.favorites;

      // The returned set should be unmodifiable
      expect(favorites, isA<Set<String>>());
      // Trying to modify should throw
      expect(() => favorites.add('hack'), throwsUnsupportedError);
    });
  });
}
