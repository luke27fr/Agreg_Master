/// Modèle pour représenter un nœud dans la carte mentale
class MindMapNode {
  final String id;
  final String titre;
  final String type; // 'lecon', 'concept', 'theoreme', 'chapitre'
  final String domaine;
  final List<String> prerequisIds; // IDs des nœuds prérequis
  final List<String> suivantIds; // IDs des nœuds suivants
  final int niveau; // Niveau de difficulté (1-5)
  final String? description;
  final List<String> motsCles;
  
  MindMapNode({
    required this.id,
    required this.titre,
    required this.type,
    required this.domaine,
    this.prerequisIds = const [],
    this.suivantIds = const [],
    this.niveau = 1,
    this.description,
    this.motsCles = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'type': type,
    'domaine': domaine,
    'prerequisIds': prerequisIds,
    'suivantIds': suivantIds,
    'niveau': niveau,
    'description': description,
    'motsCles': motsCles,
  };

  factory MindMapNode.fromJson(Map<String, dynamic> json) {
    return MindMapNode(
      id: json['id'] as String,
      titre: json['titre'] as String,
      type: json['type'] as String,
      domaine: json['domaine'] as String,
      prerequisIds: (json['prerequisIds'] as List<dynamic>?)?.cast<String>() ?? [],
      suivantIds: (json['suivantIds'] as List<dynamic>?)?.cast<String>() ?? [],
      niveau: json['niveau'] as int? ?? 1,
      description: json['description'] as String?,
      motsCles: (json['motsCles'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

/// Parcours d'apprentissage suggéré
class LearningPath {
  final String nom;
  final String description;
  final List<String> nodeIds; // Ordre suggéré des nœuds
  final int dureeEstimeeHeures;
  final String objectif;

  LearningPath({
    required this.nom,
    required this.description,
    required this.nodeIds,
    required this.dureeEstimeeHeures,
    required this.objectif,
  });

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'description': description,
    'nodeIds': nodeIds,
    'dureeEstimeeHeures': dureeEstimeeHeures,
    'objectif': objectif,
  };

  factory LearningPath.fromJson(Map<String, dynamic> json) {
    return LearningPath(
      nom: json['nom'] as String,
      description: json['description'] as String,
      nodeIds: (json['nodeIds'] as List<dynamic>).cast<String>(),
      dureeEstimeeHeures: json['dureeEstimeeHeures'] as int,
      objectif: json['objectif'] as String,
    );
  }
}

/// Lien entre deux nœuds
class MindMapLink {
  final String fromId;
  final String toId;
  final String relation; // 'prerequis', 'applique', 'generalise', 'exemple'
  final String? description;

  MindMapLink({
    required this.fromId,
    required this.toId,
    required this.relation,
    this.description,
  });
}
