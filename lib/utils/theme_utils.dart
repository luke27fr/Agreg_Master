import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Fonctions utilitaires pour les thèmes/matières
class ThemeUtils {
  ThemeUtils._();

  /// Mapping ficheId → titre propre lisible
  static const Map<String, String> _ficheTitles = {
    // Algèbre & Arithmétique
    'theoreme_spectral': 'Théorème spectral',
    'logique_ensembles': 'Logique et ensembles',
    'groupes_structures': 'Groupes et structures algébriques',
    'groupes_finis': 'Groupes finis',
    'anneaux_corps': 'Anneaux et corps',
    'polynomes': 'Polynômes',
    'fractions_rationnelles': 'Fractions rationnelles',
    'arithmetique_z': 'Arithmétique dans ℤ',
    'nombres_premiers': 'Nombres premiers',
    'espaces_vectoriels': 'Espaces vectoriels',
    'applications_lineaires': 'Applications linéaires',
    'determinants': 'Déterminants',
    'systemes_lineaires': 'Systèmes linéaires',
    'reduction_endomorphismes': 'Réduction des endomorphismes',
    'polynomes_endomorphismes': 'Polynômes d\'endomorphismes',
    'espaces_euclidiens': 'Espaces euclidiens',
    'adjoint_spectral': 'Adjoint et théorème spectral',
    'formes_quadratiques': 'Formes quadratiques',
    'geometrie_matricielle': 'Géométrie matricielle',
    // Analyse
    'hilbert': 'Espaces de Hilbert',
    'hilbert_bases': 'Bases hilbertiennes',
    'inversion_locale': 'Théorème d\'inversion locale',
    'series_entieres': 'Séries entières',
    'reels_complexes': 'Nombres réels et complexes',
    'topologie_normes': 'Topologie des espaces normés',
    'topologie_ouverts': 'Topologie : ouverts, fermés, voisinages',
    'compacite': 'Compacité',
    'connexite': 'Connexité',
    'completude': 'Complétude',
    'suites_numeriques': 'Suites numériques',
    'series_numeriques': 'Séries numériques',
    'suites_fonctions': 'Suites de fonctions',
    'series_fonctions': 'Séries de fonctions',
    'series_fourier': 'Séries de Fourier',
    'limites_continuite': 'Limites et continuité',
    'derivabilite': 'Dérivabilité',
    'convexite_analyse': 'Convexité (analyse)',
    'integration_segment': 'Intégration sur un segment',
    'integration_impropre': 'Intégrales impropres',
    'convergences_integrales': 'Convergences et intégrales',
    'calcul_diff': 'Calcul différentiel',
    'eq_diff_lineaires': 'Équations différentielles linéaires',
    'eq_diff_non_lineaires': 'Équations différentielles non linéaires',
    // Probabilités & Stats
    'va_discretes': 'Variables aléatoires discrètes',
    'denombrement': 'Dénombrement',
    'espaces_proba': 'Espaces probabilisés',
    'conditionnement': 'Conditionnement',
    'lois_usuelles_discretes': 'Lois usuelles discrètes',
    'variables_densite': 'Variables à densité',
    'lois_usuelles_densite': 'Lois usuelles à densité',
    'esperance_variance': 'Espérance et variance',
    'vecteurs_aleatoires': 'Vecteurs aléatoires',
    'convergences': 'Convergences stochastiques',
    'lgn_tcl': 'Loi des grands nombres et TCL',
    'statistique_descriptive': 'Statistique descriptive',
    'estimation': 'Estimation',
    'intervalles_confiance': 'Intervalles de confiance',
    // Géométrie
    'convexite': 'Convexité (géométrie)',
    'isometries': 'Isométries',
    'espaces_affines': 'Espaces affines',
    'barycentres': 'Barycentres',
    'produit_scalaire_geo': 'Produit scalaire en géométrie',
    'isometries_vectorielles': 'Isométries vectorielles',
    'isometries_affines': 'Isométries affines',
    'similitudes': 'Similitudes',
    'geo_plane': 'Géométrie plane',
    'geo_espace': 'Géométrie dans l\'espace',
    'nombres_complexes_geo': 'Nombres complexes et géométrie',
    'courbes_parametrees': 'Courbes paramétrées',
    'courbes_polaire': 'Courbes en coordonnées polaires',
    'coniques': 'Coniques',
    'surfaces': 'Surfaces',
  };

  /// Retourne le titre lisible d'une fiche à partir de son ID.
  /// Si l'ID n'est pas dans le mapping, formate le snake_case en titre.
  static String getFicheTitle(String ficheId) {
    if (_ficheTitles.containsKey(ficheId)) {
      return _ficheTitles[ficheId]!;
    }
    // Fallback : snake_case → Title Case
    return ficheId
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  /// Retourne la couleur associée à un thème par son ID
  static Color getThemeColor(String id) {
    if (id.contains('algebre')) return AppColors.algebreColor;
    if (id.contains('analyse')) return AppColors.analyseColor;
    if (id.contains('proba')) return AppColors.probaColor;
    if (id.contains('geo')) return AppColors.geometrieColor;
    return AppColors.defaultThemeColor;
  }

  /// Retourne l'icône associée à un thème par son ID
  static IconData getThemeIcon(String id) {
    if (id.contains('algebre')) return Icons.functions;
    if (id.contains('analyse')) return Icons.show_chart;
    if (id.contains('proba')) return Icons.casino;
    if (id.contains('geo')) return Icons.architecture;
    return Icons.book;
  }

  /// Formate une date relative (Aujourd'hui, Hier, Il y a X jours)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays} jours";
    return "${date.day}/${date.month}/${date.year}";
  }

  /// Vérifie si le thème actuel est sombre
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Retourne la couleur de fond selon le thème
  static Color scaffoldBackground(BuildContext context) {
    return isDark(context) ? AppColors.surfaceDark : AppColors.surfaceLight;
  }

  /// Retourne la couleur de carte selon le thème
  static Color cardColor(BuildContext context) {
    return isDark(context) ? AppColors.cardDark : Colors.white;
  }

  /// Retourne la couleur du texte titre selon le thème
  static Color titleColor(BuildContext context) {
    return isDark(context) ? Colors.white : AppColors.primaryDark;
  }
}
