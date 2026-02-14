import 'package:flutter/foundation.dart';
import '../models/mind_map_model.dart';

class MindMapService extends ChangeNotifier {
  static final MindMapService _instance = MindMapService._internal();
  factory MindMapService() => _instance;
  MindMapService._internal();

  Map<String, MindMapNode> _nodes = {};
  List<LearningPath> _paths = [];

  Map<String, MindMapNode> get nodes => _nodes;
  List<LearningPath> get paths => _paths;

  /// Charge la carte mentale depuis les assets ou génère une démo
  Future<void> loadMindMap() async {
    try {
      // Pour l'instant, on génère une carte de démonstration
      _nodes = _generateDemoMindMap();
      _paths = _generateDemoPaths();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement mind map: $e');
    }
  }

  /// Obtient un nœud par ID
  MindMapNode? getNode(String id) => _nodes[id];

  /// Obtient les prérequis d'un nœud
  List<MindMapNode> getPrerequisites(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return [];
    return node.prerequisIds
        .map((id) => _nodes[id])
        .where((n) => n != null)
        .cast<MindMapNode>()
        .toList();
  }

  /// Obtient les nœuds suivants
  List<MindMapNode> getNextNodes(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return [];
    return node.suivantIds
        .map((id) => _nodes[id])
        .where((n) => n != null)
        .cast<MindMapNode>()
        .toList();
  }

  /// Obtient tous les nœuds d'un domaine
  List<MindMapNode> getNodesByDomaine(String domaine) {
    return _nodes.values.where((n) => n.domaine == domaine).toList();
  }

  /// Trouve le chemin le plus court entre deux nœuds (algorithme BFS)
  List<String>? findPath(String fromId, String toId) {
    if (!_nodes.containsKey(fromId) || !_nodes.containsKey(toId)) {
      return null;
    }

    final queue = <List<String>>[[fromId]];
    final visited = <String>{fromId};

    while (queue.isNotEmpty) {
      final path = queue.removeAt(0);
      final current = path.last;

      if (current == toId) {
        return path;
      }

      final currentNode = _nodes[current]!;
      for (final nextId in currentNode.suivantIds) {
        if (!visited.contains(nextId)) {
          visited.add(nextId);
          queue.add([...path, nextId]);
        }
      }
    }

    return null; // Pas de chemin trouvé
  }

  /// Suggère des parcours d'apprentissage selon le niveau
  List<LearningPath> getSuggestedPaths({String? domaine, int? maxDuree}) {
    var filtered = _paths.where((p) => true).toList();

    if (maxDuree != null) {
      filtered = filtered.where((p) => p.dureeEstimeeHeures <= maxDuree).toList();
    }

    return filtered;
  }

  /// Génère une carte mentale de démonstration (Algèbre)
  Map<String, MindMapNode> _generateDemoMindMap() {
    return {
      // Fondamentaux
      'logique': MindMapNode(
        id: 'logique',
        titre: 'Logique et Ensembles',
        type: 'concept',
        domaine: 'Algèbre',
        niveau: 1,
        suivantIds: ['groupes', 'espaces_vect'],
        motsCles: ['quantificateurs', 'ensembles', 'relations'],
      ),

      // Structures algébriques
      'groupes': MindMapNode(
        id: 'groupes',
        titre: 'Groupes',
        type: 'concept',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['logique'],
        suivantIds: ['groupes_finis', 'anneaux'],
        motsCles: ['sous-groupes', 'morphismes', 'quotients'],
      ),

      'groupes_finis': MindMapNode(
        id: 'groupes_finis',
        titre: 'Groupes Finis',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['groupes'],
        suivantIds: ['sylow'],
        motsCles: ['ordre', 'Lagrange', 'actions de groupes'],
      ),

      'anneaux': MindMapNode(
        id: 'anneaux',
        titre: 'Anneaux et Corps',
        type: 'concept',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['groupes'],
        suivantIds: ['polynomes', 'arithmetique'],
        motsCles: ['idéaux', 'intégrité', 'corps'],
      ),

      'arithmetique': MindMapNode(
        id: 'arithmetique',
        titre: 'Arithmétique dans Z',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['anneaux'],
        suivantIds: ['nombres_premiers'],
        motsCles: ['division euclidienne', 'PGCD', 'Bézout'],
      ),

      'nombres_premiers': MindMapNode(
        id: 'nombres_premiers',
        titre: 'Nombres Premiers',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['arithmetique'],
        motsCles: ['Euclide', 'crible', 'distribution'],
      ),

      'polynomes': MindMapNode(
        id: 'polynomes',
        titre: 'Polynômes',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['anneaux'],
        suivantIds: ['polynomes_endo', 'fractions'],
        motsCles: ['racines', 'factorisation', 'division'],
      ),

      'fractions': MindMapNode(
        id: 'fractions',
        titre: 'Fractions Rationnelles',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['polynomes'],
        motsCles: ['décomposition', 'pôles', 'résidus'],
      ),

      // Algèbre linéaire
      'espaces_vect': MindMapNode(
        id: 'espaces_vect',
        titre: 'Espaces Vectoriels',
        type: 'concept',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['logique'],
        suivantIds: ['applications_lin', 'dimension'],
        motsCles: ['sous-espaces', 'familles libres', 'génératrices'],
      ),

      'dimension': MindMapNode(
        id: 'dimension',
        titre: 'Dimension Finie',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['espaces_vect'],
        suivantIds: ['matrices'],
        motsCles: ['base', 'dimension', 'rang'],
      ),

      'applications_lin': MindMapNode(
        id: 'applications_lin',
        titre: 'Applications Linéaires',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['espaces_vect'],
        suivantIds: ['matrices', 'determinants'],
        motsCles: ['noyau', 'image', 'rang'],
      ),

      'matrices': MindMapNode(
        id: 'matrices',
        titre: 'Matrices',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 2,
        prerequisIds: ['dimension', 'applications_lin'],
        suivantIds: ['determinants', 'reduction'],
        motsCles: ['produit', 'inverse', 'rang'],
      ),

      'determinants': MindMapNode(
        id: 'determinants',
        titre: 'Déterminants',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['matrices', 'applications_lin'],
        suivantIds: ['reduction'],
        motsCles: ['multilinéarité', 'développement', 'Cramer'],
      ),

      'polynomes_endo': MindMapNode(
        id: 'polynomes_endo',
        titre: 'Polynômes d\'Endomorphismes',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['polynomes', 'applications_lin'],
        suivantIds: ['reduction'],
        motsCles: ['annulateur', 'minimal', 'Cayley-Hamilton'],
      ),

      'reduction': MindMapNode(
        id: 'reduction',
        titre: 'Réduction des Endomorphismes',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 4,
        prerequisIds: ['determinants', 'polynomes_endo'],
        suivantIds: ['jordan', 'spectral'],
        motsCles: ['diagonalisation', 'valeurs propres', 'trigonalisation'],
      ),

      'jordan': MindMapNode(
        id: 'jordan',
        titre: 'Forme de Jordan',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 5,
        prerequisIds: ['reduction'],
        motsCles: ['nilpotent', 'blocs de Jordan', 'Dunford'],
      ),

      // Euclidien
      'espaces_euclidiens': MindMapNode(
        id: 'espaces_euclidiens',
        titre: 'Espaces Euclidiens',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 3,
        prerequisIds: ['dimension'],
        suivantIds: ['spectral', 'formes_quad'],
        motsCles: ['produit scalaire', 'orthogonalité', 'Gram-Schmidt'],
      ),

      'spectral': MindMapNode(
        id: 'spectral',
        titre: 'Théorème Spectral',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 4,
        prerequisIds: ['reduction', 'espaces_euclidiens'],
        motsCles: ['symétrique', 'normal', 'diagonalisation orthogonale'],
      ),

      'formes_quad': MindMapNode(
        id: 'formes_quad',
        titre: 'Formes Quadratiques',
        type: 'lecon',
        domaine: 'Algèbre',
        niveau: 4,
        prerequisIds: ['espaces_euclidiens'],
        motsCles: ['signature', 'Sylvester', 'décomposition'],
      ),

      'sylow': MindMapNode(
        id: 'sylow',
        titre: 'Théorèmes de Sylow',
        type: 'theoreme',
        domaine: 'Algèbre',
        niveau: 4,
        prerequisIds: ['groupes_finis'],
        motsCles: ['p-groupes', 'sous-groupes de Sylow'],
      ),

      // ========== ANALYSE ==========
      
      // Suites et séries
      'suites': MindMapNode(
        id: 'suites',
        titre: 'Suites Numériques',
        type: 'concept',
        domaine: 'Analyse',
        niveau: 1,
        suivantIds: ['series', 'limites'],
        motsCles: ['convergence', 'monotonie', 'bornes'],
      ),

      'series': MindMapNode(
        id: 'series',
        titre: 'Séries Numériques',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 2,
        prerequisIds: ['suites'],
        suivantIds: ['series_entieres', 'series_fourier'],
        motsCles: ['convergence absolue', 'critères', 'reste'],
      ),

      'series_entieres': MindMapNode(
        id: 'series_entieres',
        titre: 'Séries Entières',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['series'],
        suivantIds: ['fonctions_analytiques'],
        motsCles: ['rayon de convergence', 'Abel', 'développement'],
      ),

      'series_fourier': MindMapNode(
        id: 'series_fourier',
        titre: 'Séries de Fourier',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 4,
        prerequisIds: ['series', 'integration'],
        motsCles: ['périodique', 'coefficients', 'convergence'],
      ),

      // Fonctions
      'limites': MindMapNode(
        id: 'limites',
        titre: 'Limites et Continuité',
        type: 'concept',
        domaine: 'Analyse',
        niveau: 1,
        prerequisIds: ['suites'],
        suivantIds: ['derivation', 'tvi'],
        motsCles: ['continuité', 'epsilon-delta', 'uniforme'],
      ),

      'tvi': MindMapNode(
        id: 'tvi',
        titre: 'Théorème des Valeurs Intermédiaires',
        type: 'theoreme',
        domaine: 'Analyse',
        niveau: 2,
        prerequisIds: ['limites'],
        motsCles: ['connexité', 'image continue'],
      ),

      'derivation': MindMapNode(
        id: 'derivation',
        titre: 'Dérivation',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 2,
        prerequisIds: ['limites'],
        suivantIds: ['taf', 'taylor'],
        motsCles: ['tangente', 'extremum', 'classe C^k'],
      ),

      'taf': MindMapNode(
        id: 'taf',
        titre: 'Théorème des Accroissements Finis',
        type: 'theoreme',
        domaine: 'Analyse',
        niveau: 2,
        prerequisIds: ['derivation'],
        suivantIds: ['taylor'],
        motsCles: ['Rolle', 'inégalité'],
      ),

      'taylor': MindMapNode(
        id: 'taylor',
        titre: 'Formules de Taylor',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['taf'],
        suivantIds: ['developpements_limites'],
        motsCles: ['reste', 'DL', 'approximation'],
      ),

      'developpements_limites': MindMapNode(
        id: 'developpements_limites',
        titre: 'Développements Limités',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['taylor'],
        motsCles: ['DL', 'équivalents', 'opérations'],
      ),

      // Intégration
      'integration': MindMapNode(
        id: 'integration',
        titre: 'Intégration',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 2,
        prerequisIds: ['limites'],
        suivantIds: ['integrales_impropres', 'series_fourier'],
        motsCles: ['Riemann', 'primitive', 'Fubini'],
      ),

      'integrales_impropres': MindMapNode(
        id: 'integrales_impropres',
        titre: 'Intégrales Impropres',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['integration'],
        motsCles: ['convergence', 'comparaison', 'absolue'],
      ),

      // Fonctions de plusieurs variables
      'fonctions_plusieurs_var': MindMapNode(
        id: 'fonctions_plusieurs_var',
        titre: 'Fonctions de Plusieurs Variables',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['derivation'],
        suivantIds: ['extrema', 'diff_totale'],
        motsCles: ['dérivées partielles', 'gradient', 'différentielle'],
      ),

      'extrema': MindMapNode(
        id: 'extrema',
        titre: 'Extrema Libres et Liés',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 4,
        prerequisIds: ['fonctions_plusieurs_var'],
        motsCles: ['Hessienne', 'Lagrange', 'point-selle'],
      ),

      'diff_totale': MindMapNode(
        id: 'diff_totale',
        titre: 'Différentielle Totale',
        type: 'concept',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['fonctions_plusieurs_var'],
        suivantIds: ['theoreme_inversion'],
        motsCles: ['Jacobienne', 'différentielle'],
      ),

      'theoreme_inversion': MindMapNode(
        id: 'theoreme_inversion',
        titre: 'Théorème d\'Inversion Locale',
        type: 'theoreme',
        domaine: 'Analyse',
        niveau: 5,
        prerequisIds: ['diff_totale'],
        motsCles: ['difféomorphisme', 'application réciproque'],
      ),

      // Espaces fonctionnels
      'espaces_normes': MindMapNode(
        id: 'espaces_normes',
        titre: 'Espaces Normés',
        type: 'concept',
        domaine: 'Analyse',
        niveau: 3,
        prerequisIds: ['limites'],
        suivantIds: ['espaces_banach', 'compacite'],
        motsCles: ['norme', 'distance', 'complétude'],
      ),

      'espaces_banach': MindMapNode(
        id: 'espaces_banach',
        titre: 'Espaces de Banach',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 4,
        prerequisIds: ['espaces_normes'],
        suivantIds: ['hilbert'],
        motsCles: ['complet', 'Baire', 'application linéaire continue'],
      ),

      'hilbert': MindMapNode(
        id: 'hilbert',
        titre: 'Espaces de Hilbert',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 4,
        prerequisIds: ['espaces_banach', 'espaces_euclidiens'],
        motsCles: ['produit scalaire', 'projection', 'orthogonalité'],
      ),

      'compacite': MindMapNode(
        id: 'compacite',
        titre: 'Compacité',
        type: 'concept',
        domaine: 'Analyse',
        niveau: 4,
        prerequisIds: ['espaces_normes'],
        motsCles: ['Bolzano-Weierstrass', 'recouvrement', 'Heine'],
      ),

      'fonctions_analytiques': MindMapNode(
        id: 'fonctions_analytiques',
        titre: 'Fonctions Analytiques',
        type: 'lecon',
        domaine: 'Analyse',
        niveau: 5,
        prerequisIds: ['series_entieres'],
        motsCles: ['holomorphe', 'Cauchy', 'résidus'],
      ),

      // ========== GÉOMÉTRIE ==========

      'espaces_affines': MindMapNode(
        id: 'espaces_affines',
        titre: 'Espaces Affines',
        type: 'concept',
        domaine: 'Géométrie',
        niveau: 2,
        prerequisIds: ['espaces_vect'],
        suivantIds: ['transformations_affines', 'barycentres'],
        motsCles: ['sous-espaces affines', 'direction', 'parallélisme'],
      ),

      'barycentres': MindMapNode(
        id: 'barycentres',
        titre: 'Barycentres',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 2,
        prerequisIds: ['espaces_affines'],
        suivantIds: ['convexite'],
        motsCles: ['centre de masse', 'coordonnées barycentriques'],
      ),

      'transformations_affines': MindMapNode(
        id: 'transformations_affines',
        titre: 'Transformations Affines',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['espaces_affines'],
        suivantIds: ['isometries_affines'],
        motsCles: ['application affine', 'translation', 'homothétie'],
      ),

      'isometries_affines': MindMapNode(
        id: 'isometries_affines',
        titre: 'Isométries Affines',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['transformations_affines', 'espaces_euclidiens'],
        suivantIds: ['rotations', 'similitudes'],
        motsCles: ['déplacement', 'antidéplacement', 'réflexion'],
      ),

      'rotations': MindMapNode(
        id: 'rotations',
        titre: 'Rotations',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['isometries_affines'],
        motsCles: ['angle', 'axe', 'SO(n)'],
      ),

      'similitudes': MindMapNode(
        id: 'similitudes',
        titre: 'Similitudes',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['isometries_affines'],
        motsCles: ['rapport', 'directe', 'indirecte'],
      ),

      'convexite': MindMapNode(
        id: 'convexite',
        titre: 'Convexité',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['barycentres'],
        motsCles: ['partie convexe', 'fonction convexe', 'enveloppe'],
      ),

      'courbes_parametrees': MindMapNode(
        id: 'courbes_parametrees',
        titre: 'Courbes Paramétrées',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['derivation'],
        suivantIds: ['courbure'],
        motsCles: ['tangente', 'points singuliers', 'longueur'],
      ),

      'courbure': MindMapNode(
        id: 'courbure',
        titre: 'Courbure',
        type: 'concept',
        domaine: 'Géométrie',
        niveau: 4,
        prerequisIds: ['courbes_parametrees'],
        motsCles: ['rayon de courbure', 'centre de courbure', 'Frenet'],
      ),

      'coniques': MindMapNode(
        id: 'coniques',
        titre: 'Coniques',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 3,
        prerequisIds: ['espaces_affines'],
        motsCles: ['ellipse', 'hyperbole', 'parabole', 'foyers'],
      ),

      'quadriques': MindMapNode(
        id: 'quadriques',
        titre: 'Quadriques',
        type: 'lecon',
        domaine: 'Géométrie',
        niveau: 4,
        prerequisIds: ['formes_quad', 'coniques'],
        motsCles: ['surfaces', 'réduction', 'classification'],
      ),

      // ========== PROBABILITÉS ==========

      'espaces_proba': MindMapNode(
        id: 'espaces_proba',
        titre: 'Espaces Probabilisés',
        type: 'concept',
        domaine: 'Probabilités',
        niveau: 1,
        suivantIds: ['variables_aleatoires', 'proba_conditionnelles'],
        motsCles: ['tribu', 'probabilité', 'événements'],
      ),

      'denombrement': MindMapNode(
        id: 'denombrement',
        titre: 'Dénombrement',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 1,
        suivantIds: ['espaces_proba'],
        motsCles: ['combinaisons', 'arrangements', 'permutations'],
      ),

      'proba_conditionnelles': MindMapNode(
        id: 'proba_conditionnelles',
        titre: 'Probabilités Conditionnelles',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 2,
        prerequisIds: ['espaces_proba'],
        suivantIds: ['independance'],
        motsCles: ['Bayes', 'formule des probabilités totales'],
      ),

      'independance': MindMapNode(
        id: 'independance',
        titre: 'Indépendance',
        type: 'concept',
        domaine: 'Probabilités',
        niveau: 2,
        prerequisIds: ['proba_conditionnelles'],
        suivantIds: ['variables_aleatoires'],
        motsCles: ['événements indépendants', 'tribu indépendante'],
      ),

      'variables_aleatoires': MindMapNode(
        id: 'variables_aleatoires',
        titre: 'Variables Aléatoires',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 2,
        prerequisIds: ['espaces_proba'],
        suivantIds: ['esperance', 'lois_discretes', 'lois_continues'],
        motsCles: ['loi', 'fonction de répartition', 'mesurable'],
      ),

      'esperance': MindMapNode(
        id: 'esperance',
        titre: 'Espérance et Variance',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 2,
        prerequisIds: ['variables_aleatoires'],
        suivantIds: ['inegalites_proba'],
        motsCles: ['moment', 'écart-type', 'covariance'],
      ),

      'lois_discretes': MindMapNode(
        id: 'lois_discretes',
        titre: 'Lois Discrètes Usuelles',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 2,
        prerequisIds: ['variables_aleatoires'],
        motsCles: ['Bernoulli', 'binomiale', 'Poisson', 'géométrique'],
      ),

      'lois_continues': MindMapNode(
        id: 'lois_continues',
        titre: 'Lois à Densité',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 3,
        prerequisIds: ['variables_aleatoires', 'integration'],
        suivantIds: ['loi_normale'],
        motsCles: ['densité', 'uniforme', 'exponentielle'],
      ),

      'loi_normale': MindMapNode(
        id: 'loi_normale',
        titre: 'Loi Normale',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 3,
        prerequisIds: ['lois_continues'],
        suivantIds: ['tcl'],
        motsCles: ['Gauss', 'centrée réduite', 'table'],
      ),

      'inegalites_proba': MindMapNode(
        id: 'inegalites_proba',
        titre: 'Inégalités Probabilistes',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 3,
        prerequisIds: ['esperance'],
        suivantIds: ['convergences_proba'],
        motsCles: ['Markov', 'Bienaymé-Tchebychev', 'Jensen'],
      ),

      'convergences_proba': MindMapNode(
        id: 'convergences_proba',
        titre: 'Convergences en Probabilités',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 4,
        prerequisIds: ['inegalites_proba'],
        suivantIds: ['lgn', 'tcl'],
        motsCles: ['presque sûre', 'en probabilité', 'en loi'],
      ),

      'lgn': MindMapNode(
        id: 'lgn',
        titre: 'Loi des Grands Nombres',
        type: 'theoreme',
        domaine: 'Probabilités',
        niveau: 4,
        prerequisIds: ['convergences_proba'],
        suivantIds: ['tcl'],
        motsCles: ['LGN faible', 'LGN forte', 'moyenne empirique'],
      ),

      'tcl': MindMapNode(
        id: 'tcl',
        titre: 'Théorème Central Limite',
        type: 'theoreme',
        domaine: 'Probabilités',
        niveau: 5,
        prerequisIds: ['lgn', 'loi_normale'],
        motsCles: ['convergence en loi', 'approximation normale'],
      ),

      'chaines_markov': MindMapNode(
        id: 'chaines_markov',
        titre: 'Chaînes de Markov',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 5,
        prerequisIds: ['variables_aleatoires'],
        motsCles: ['matrice de transition', 'récurrence', 'loi stationnaire'],
      ),

      'vecteurs_aleatoires': MindMapNode(
        id: 'vecteurs_aleatoires',
        titre: 'Vecteurs Aléatoires',
        type: 'lecon',
        domaine: 'Probabilités',
        niveau: 4,
        prerequisIds: ['variables_aleatoires'],
        motsCles: ['loi conjointe', 'covariance', 'indépendance'],
      ),
    };
  }

  /// Génère des parcours de démonstration
  List<LearningPath> _generateDemoPaths() {
    return [
      // ALGÈBRE
      LearningPath(
        nom: 'Fondamentaux d\'Algèbre',
        description: 'Parcours pour débuter en algèbre structurelle',
        nodeIds: ['logique', 'groupes', 'anneaux', 'arithmetique'],
        dureeEstimeeHeures: 40,
        objectif: 'Maîtriser les structures algébriques de base',
      ),
      LearningPath(
        nom: 'Algèbre Linéaire Complète',
        description: 'De zéro à la réduction d\'endomorphismes',
        nodeIds: [
          'espaces_vect',
          'dimension',
          'applications_lin',
          'matrices',
          'determinants',
          'polynomes_endo',
          'reduction'
        ],
        dureeEstimeeHeures: 60,
        objectif: 'Maîtrise complète de l\'algèbre linéaire',
      ),
      LearningPath(
        nom: 'Vers le Théorème Spectral',
        description: 'Parcours optimal pour comprendre le théorème spectral',
        nodeIds: [
          'espaces_vect',
          'applications_lin',
          'matrices',
          'polynomes_endo',
          'reduction',
          'espaces_euclidiens',
          'spectral'
        ],
        dureeEstimeeHeures: 50,
        objectif: 'Comprendre et appliquer le théorème spectral',
      ),
      LearningPath(
        nom: 'Arithmétique Avancée',
        description: 'Approfondissement en théorie des nombres',
        nodeIds: ['anneaux', 'arithmetique', 'nombres_premiers'],
        dureeEstimeeHeures: 30,
        objectif: 'Maîtriser l\'arithmétique dans Z',
      ),
      
      // ANALYSE
      LearningPath(
        nom: 'Analyse Fondamentale',
        description: 'Suites, séries et fonctions continues',
        nodeIds: ['suites', 'series', 'limites', 'derivation', 'integration'],
        dureeEstimeeHeures: 50,
        objectif: 'Maîtriser les fondamentaux de l\'analyse',
      ),
      LearningPath(
        nom: 'Analyse Avancée',
        description: 'Vers les espaces fonctionnels',
        nodeIds: [
          'espaces_normes',
          'espaces_banach',
          'hilbert',
          'compacite'
        ],
        dureeEstimeeHeures: 45,
        objectif: 'Comprendre les espaces de Banach et Hilbert',
      ),
      LearningPath(
        nom: 'Calcul Différentiel',
        description: 'Fonctions de plusieurs variables',
        nodeIds: [
          'derivation',
          'fonctions_plusieurs_var',
          'diff_totale',
          'extrema',
          'theoreme_inversion'
        ],
        dureeEstimeeHeures: 40,
        objectif: 'Maîtriser le calcul différentiel',
      ),
      LearningPath(
        nom: 'Séries et Développements',
        description: 'De Taylor aux séries de Fourier',
        nodeIds: [
          'taylor',
          'developpements_limites',
          'series_entieres',
          'series_fourier',
          'fonctions_analytiques'
        ],
        dureeEstimeeHeures: 55,
        objectif: 'Maîtriser les développements et séries',
      ),
      
      // GÉOMÉTRIE
      LearningPath(
        nom: 'Géométrie Affine',
        description: 'Espaces affines et transformations',
        nodeIds: [
          'espaces_affines',
          'barycentres',
          'transformations_affines',
          'convexite'
        ],
        dureeEstimeeHeures: 35,
        objectif: 'Comprendre la géométrie affine',
      ),
      LearningPath(
        nom: 'Géométrie Euclidienne',
        description: 'Isométries et géométrie métrique',
        nodeIds: [
          'espaces_euclidiens',
          'isometries_affines',
          'rotations',
          'similitudes'
        ],
        dureeEstimeeHeures: 40,
        objectif: 'Maîtriser les isométries',
      ),
      LearningPath(
        nom: 'Courbes et Surfaces',
        description: 'Étude géométrique des courbes et surfaces',
        nodeIds: [
          'courbes_parametrees',
          'courbure',
          'coniques',
          'quadriques'
        ],
        dureeEstimeeHeures: 45,
        objectif: 'Analyser courbes et surfaces',
      ),
      
      // PROBABILITÉS
      LearningPath(
        nom: 'Probabilités Fondamentales',
        description: 'Des bases aux variables aléatoires',
        nodeIds: [
          'denombrement',
          'espaces_proba',
          'proba_conditionnelles',
          'independance',
          'variables_aleatoires'
        ],
        dureeEstimeeHeures: 40,
        objectif: 'Comprendre les fondamentaux des probabilités',
      ),
      LearningPath(
        nom: 'Lois et Convergences',
        description: 'Des lois usuelles aux théorèmes limites',
        nodeIds: [
          'variables_aleatoires',
          'esperance',
          'lois_discretes',
          'lois_continues',
          'loi_normale',
          'inegalites_proba',
          'convergences_proba',
          'lgn',
          'tcl'
        ],
        dureeEstimeeHeures: 60,
        objectif: 'Maîtriser lois et convergences',
      ),
      LearningPath(
        nom: 'Probabilités Avancées',
        description: 'Vecteurs aléatoires et processus',
        nodeIds: [
          'vecteurs_aleatoires',
          'chaines_markov'
        ],
        dureeEstimeeHeures: 35,
        objectif: 'Comprendre les processus stochastiques',
      ),
    ];
  }

  /// Calcule le niveau de maîtrise global d'un parcours
  double getPathMastery(LearningPath path, Map<String, int> masteryLevels) {
    if (path.nodeIds.isEmpty) return 0;
    
    int totalMastery = 0;
    for (var nodeId in path.nodeIds) {
      totalMastery += masteryLevels[nodeId] ?? 0;
    }
    
    return totalMastery / path.nodeIds.length;
  }
}
