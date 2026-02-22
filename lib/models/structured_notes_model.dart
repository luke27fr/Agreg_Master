/// Note structurée avec support LaTeX
class StructuredNote {
  final String id;
  final String titre;
  final DateTime dateCreation;
  final DateTime dateModification;
  final String contenu; // Markdown + LaTeX
  final List<String> tags;
  final String? leconId;
  final String? domaine;
  final List<NoteAttachment> attachments;
  final bool isFavorite;
  final String categorie; // 'cours', 'exercice', 'developpement', 'remarque', 'astuce'

  StructuredNote({
    required this.id,
    required this.titre,
    required this.dateCreation,
    required this.dateModification,
    required this.contenu,
    this.tags = const [],
    this.leconId,
    this.domaine,
    this.attachments = const [],
    this.isFavorite = false,
    this.categorie = 'remarque',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'dateCreation': dateCreation.toIso8601String(),
    'dateModification': dateModification.toIso8601String(),
    'contenu': contenu,
    'tags': tags,
    'leconId': leconId,
    'domaine': domaine,
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'isFavorite': isFavorite,
    'categorie': categorie,
  };

  factory StructuredNote.fromJson(Map<String, dynamic> json) {
    return StructuredNote(
      id: json['id'] as String,
      titre: json['titre'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      dateModification: DateTime.parse(json['dateModification'] as String),
      contenu: json['contenu'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      leconId: json['leconId'] as String?,
      domaine: json['domaine'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((a) => NoteAttachment.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      categorie: json['categorie'] as String? ?? 'remarque',
    );
  }

  StructuredNote copyWith({
    String? titre,
    String? contenu,
    List<String>? tags,
    bool? isFavorite,
    List<NoteAttachment>? attachments,
  }) {
    return StructuredNote(
      id: id,
      titre: titre ?? this.titre,
      dateCreation: dateCreation,
      dateModification: DateTime.now(),
      contenu: contenu ?? this.contenu,
      tags: tags ?? this.tags,
      leconId: leconId,
      domaine: domaine,
      attachments: attachments ?? this.attachments,
      isFavorite: isFavorite ?? this.isFavorite,
      categorie: categorie,
    );
  }
}

/// Pièce jointe dans une note
class NoteAttachment {
  final String nom;
  final String type; // 'image', 'pdf', 'lien'
  final String path; // Chemin local ou URL

  NoteAttachment({
    required this.nom,
    required this.type,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'type': type,
    'path': path,
  };

  factory NoteAttachment.fromJson(Map<String, dynamic> json) {
    return NoteAttachment(
      nom: json['nom'] as String,
      type: json['type'] as String,
      path: json['path'] as String,
    );
  }
}
