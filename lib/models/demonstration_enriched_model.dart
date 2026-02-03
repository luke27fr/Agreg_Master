/// Modèle enrichi pour les démonstrations avec ressources multimédia
class DemonstrationEnriched {
  final String id;
  final String titre;
  final String domaine;
  final String enonce;
  final List<String> preuve;
  final List<String>? corollaires;
  final List<int>? lecons;
  final List<String> tags;
  
  // Ressources enrichies
  final List<VideoResource> videos;
  final List<ArticleResource> articles;
  final String? visualisation; // URL d'une image/animation
  final String? remarque;
  final int difficulte; // 1-5
  final List<String>? erreursCourantes;

  DemonstrationEnriched({
    required this.id,
    required this.titre,
    required this.domaine,
    required this.enonce,
    required this.preuve,
    this.corollaires,
    this.lecons,
    required this.tags,
    this.videos = const [],
    this.articles = const [],
    this.visualisation,
    this.remarque,
    this.difficulte = 3,
    this.erreursCourantes,
  });

  factory DemonstrationEnriched.fromJson(Map<String, dynamic> json) {
    return DemonstrationEnriched(
      id: json['id'] as String,
      titre: json['titre'] as String,
      domaine: json['domaine'] as String,
      enonce: json['enonce'] as String,
      preuve: (json['preuve'] as List<dynamic>).cast<String>(),
      corollaires: (json['corollaires'] as List<dynamic>?)?.cast<String>(),
      lecons: (json['lecons'] as List<dynamic>?)?.cast<int>(),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((v) => VideoResource.fromJson(v as Map<String, dynamic>))
          .toList() ?? [],
      articles: (json['articles'] as List<dynamic>?)
          ?.map((a) => ArticleResource.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
      visualisation: json['visualisation'] as String?,
      remarque: json['remarque'] as String?,
      difficulte: json['difficulte'] as int? ?? 3,
      erreursCourantes: (json['erreursCourantes'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

/// Ressource vidéo
class VideoResource {
  final String titre;
  final String url;
  final String plateforme; // 'youtube', 'dailymotion', 'vimeo', etc.
  final int dureeMinutes;
  final String? auteur;
  final String? description;

  VideoResource({
    required this.titre,
    required this.url,
    required this.plateforme,
    required this.dureeMinutes,
    this.auteur,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'url': url,
    'plateforme': plateforme,
    'dureeMinutes': dureeMinutes,
    'auteur': auteur,
    'description': description,
  };

  factory VideoResource.fromJson(Map<String, dynamic> json) {
    return VideoResource(
      titre: json['titre'] as String,
      url: json['url'] as String,
      plateforme: json['plateforme'] as String,
      dureeMinutes: json['dureeMinutes'] as int,
      auteur: json['auteur'] as String?,
      description: json['description'] as String?,
    );
  }
}

/// Ressource article/cours
class ArticleResource {
  final String titre;
  final String url;
  final String type; // 'pdf', 'web', 'livre'
  final String? auteur;

  ArticleResource({
    required this.titre,
    required this.url,
    required this.type,
    this.auteur,
  });

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'url': url,
    'type': type,
    'auteur': auteur,
  };

  factory ArticleResource.fromJson(Map<String, dynamic> json) {
    return ArticleResource(
      titre: json['titre'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      auteur: json['auteur'] as String?,
    );
  }
}
