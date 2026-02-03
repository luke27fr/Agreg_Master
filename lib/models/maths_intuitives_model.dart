/// Modèle pour une explication intuitive de concept mathématique
class ConceptIntuitif {
  final String id;
  final String titre;
  final String domaine; // 'algèbre', 'analyse', 'géométrie', 'probabilités'
  final int niveauAgregation; // 1-5: niveau à l'agrégation
  final String analogieSimple; // Analogie de la vie quotidienne
  final String questionCle; // "À quoi ça sert vraiment ?"
  final String explicationIntuitive; // Explication sans jargon
  final String exempleConcret; // Exemple du quotidien
  final String lienAvecLycee; // Ce que le lycéen connaît déjà
  final String pourquoiCestImportant; // Impact et applications
  final List<String> ideesFausses; // Erreurs courantes à éviter
  final String? visualisation; // Description d'une image mentale
  final List<String> prerequisTerminale; // Prérequis niveau Terminale
  final String? anecdote; // Histoire ou fait amusant
  final List<String> applicationsReelles; // Applications concrètes
  final int difficulteIntuitive; // 1-5: facilité de compréhension intuitive
  
  ConceptIntuitif({
    required this.id,
    required this.titre,
    required this.domaine,
    required this.niveauAgregation,
    required this.analogieSimple,
    required this.questionCle,
    required this.explicationIntuitive,
    required this.exempleConcret,
    required this.lienAvecLycee,
    required this.pourquoiCestImportant,
    this.ideesFausses = const [],
    this.visualisation,
    this.prerequisTerminale = const [],
    this.anecdote,
    this.applicationsReelles = const [],
    this.difficulteIntuitive = 3,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'domaine': domaine,
    'niveauAgregation': niveauAgregation,
    'analogieSimple': analogieSimple,
    'questionCle': questionCle,
    'explicationIntuitive': explicationIntuitive,
    'exempleConcret': exempleConcret,
    'lienAvecLycee': lienAvecLycee,
    'pourquoiCestImportant': pourquoiCestImportant,
    'ideesFausses': ideesFausses,
    'visualisation': visualisation,
    'prerequisTerminale': prerequisTerminale,
    'anecdote': anecdote,
    'applicationsReelles': applicationsReelles,
    'difficulteIntuitive': difficulteIntuitive,
  };

  factory ConceptIntuitif.fromJson(Map<String, dynamic> json) {
    return ConceptIntuitif(
      id: json['id'] as String,
      titre: json['titre'] as String,
      domaine: json['domaine'] as String,
      niveauAgregation: json['niveauAgregation'] as int,
      analogieSimple: json['analogieSimple'] as String,
      questionCle: json['questionCle'] as String,
      explicationIntuitive: json['explicationIntuitive'] as String,
      exempleConcret: json['exempleConcret'] as String,
      lienAvecLycee: json['lienAvecLycee'] as String,
      pourquoiCestImportant: json['pourquoiCestImportant'] as String,
      ideesFausses: (json['ideesFausses'] as List<dynamic>?)?.cast<String>() ?? [],
      visualisation: json['visualisation'] as String?,
      prerequisTerminale: (json['prerequisTerminale'] as List<dynamic>?)?.cast<String>() ?? [],
      anecdote: json['anecdote'] as String?,
      applicationsReelles: (json['applicationsReelles'] as List<dynamic>?)?.cast<String>() ?? [],
      difficulteIntuitive: json['difficulteIntuitive'] as int? ?? 3,
    );
  }
}

/// Catégorie de concepts pour organisation
class CategorieIntuitive {
  final String nom;
  final String description;
  final String emoji;
  final List<String> conceptIds;
  
  CategorieIntuitive({
    required this.nom,
    required this.description,
    required this.emoji,
    required this.conceptIds,
  });
}
