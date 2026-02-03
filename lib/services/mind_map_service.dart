import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    };
  }

  /// Génère des parcours de démonstration
  List<LearningPath> _generateDemoPaths() {
    return [
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
