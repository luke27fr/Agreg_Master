import 'dart:convert';
import '../constants/app_constants.dart';
import '../main.dart'; // ThemeItem
import 'content_loader.dart';

/// Utilitaire centralisé pour charger le manifest des fiches
class ManifestLoader {
  ManifestLoader._();

  static List<ThemeItem>? _cachedThemes;
  static Map<String, String>? _cachedPathMap;
  static int? _cachedTotalFiches;

  /// Charge et cache les thèmes depuis le manifest
  static Future<List<ThemeItem>> loadThemes() async {
    if (_cachedThemes != null) return _cachedThemes!;

    final json = await ContentLoader.loadString(AppAssets.manifestPath);
    final data = jsonDecode(json) as Map<String, dynamic>;
    final list = (data['themes'] as List<dynamic>?)
        ?.map((e) => ThemeItem.fromJson(e as Map<String, dynamic>))
        .toList();

    _cachedThemes = list ?? [];
    return _cachedThemes!;
  }

  /// Retourne le nombre total de fiches
  static Future<int> getTotalFiches() async {
    if (_cachedTotalFiches != null) return _cachedTotalFiches!;

    final themes = await loadThemes();
    int count = 0;
    for (var t in themes) {
      count += t.files.length;
    }
    _cachedTotalFiches = count;
    return _cachedTotalFiches!;
  }

  /// Construit la map ficheId -> assetPath
  static Future<Map<String, String>> getPathMap() async {
    if (_cachedPathMap != null) return _cachedPathMap!;

    final json = await ContentLoader.loadString(AppAssets.manifestPath);
    final manifest = jsonDecode(json) as Map<String, dynamic>;
    final themes = manifest['themes'] as List<dynamic>;

    final pathMap = <String, String>{};
    for (var theme in themes) {
      final themePath = theme['path'] as String;
      final files = (theme['files'] as List<dynamic>).cast<String>();
      for (var file in files) {
        final ficheId = file.replaceAll('.md', '');
        pathMap[ficheId] = '$themePath/$file';
      }
    }

    _cachedPathMap = pathMap;
    return _cachedPathMap!;
  }

  /// Invalide le cache (utile après un changement de données)
  static void invalidateCache() {
    _cachedThemes = null;
    _cachedPathMap = null;
    _cachedTotalFiches = null;
  }
}
