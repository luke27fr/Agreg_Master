/// Bibliothèque idéale pour l'agrégation de mathématiques.
/// Bibliographie commentée avec pages exactes des développements classiques.
library;

class LivreAgreg {
  final String id;
  final String titre;
  final String auteurs;
  final String editeur;
  final String? edition;
  final String categorie; // 'algebre', 'analyse', 'probabilites', 'geometrie', 'transversal'
  final int difficulte; // 1 = accessible, 2 = intermédiaire, 3 = avancé
  final String commentaire;
  final String pourquoi; // Pourquoi ce livre est incontournable
  final List<String> pointsForts;
  final List<String> pointsFaibles;
  final List<PageReference> developpements;
  final bool conseilleValise; // Recommandé pour la valise du jour J
  final String? isbn;
  final int? pages;

  const LivreAgreg({
    required this.id,
    required this.titre,
    required this.auteurs,
    required this.editeur,
    this.edition,
    required this.categorie,
    required this.difficulte,
    required this.commentaire,
    required this.pourquoi,
    required this.pointsForts,
    this.pointsFaibles = const [],
    required this.developpements,
    this.conseilleValise = false,
    this.isbn,
    this.pages,
  });

  String get difficulteLabel {
    switch (difficulte) {
      case 1: return 'Accessible';
      case 2: return 'Intermédiaire';
      case 3: return 'Avancé';
      default: return '';
    }
  }

  String get categorieLabel {
    switch (categorie) {
      case 'algebre': return 'Algèbre';
      case 'analyse': return 'Analyse';
      case 'probabilites': return 'Probabilités';
      case 'geometrie': return 'Géométrie';
      case 'transversal': return 'Transversal';
      default: return categorie;
    }
  }
}

class PageReference {
  final String developpement;
  final String pages; // ex: "pp. 123-128"
  final String? leconNumero; // leçon(s) correspondante(s)
  final String? commentaire;

  const PageReference({
    required this.developpement,
    required this.pages,
    this.leconNumero,
    this.commentaire,
  });
}

class BibliothequeData {
  static const List<LivreAgreg> livres = [
    // =========================================================================
    // ALGÈBRE
    // =========================================================================
    LivreAgreg(
      id: 'gourdon_algebre',
      titre: 'Les Maths en Tête — Algèbre',
      auteurs: 'Xavier Gourdon',
      editeur: 'Ellipses',
      edition: '3e édition',
      categorie: 'algebre',
      difficulte: 2,
      commentaire: 'LA référence pour l\'algèbre à l\'agrégation. Couvre tout le programme avec clarté et rigueur. Les démonstrations sont complètes et bien structurées. Un indispensable de la valise.',
      pourquoi: 'Couverture exhaustive du programme, développements directement utilisables à l\'oral, excellent comme référence rapide le jour J.',
      pointsForts: [
        'Démonstrations complètes et rigoureuses',
        'Exercices corrigés de bon niveau',
        'Organisation par thème très claire',
        'Index détaillé pour retrouver rapidement un résultat',
      ],
      pointsFaibles: [
        'Parfois concis sur les motivations',
        'Peu d\'exemples calculatoires détaillés',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Théorèmes de Sylow',
          pages: 'pp. 28-32',
          leconNumero: '101, 103',
          commentaire: 'Démonstration complète des trois théorèmes par action sur les sous-ensembles',
        ),
        PageReference(
          developpement: 'Théorème de structure des modules de type fini sur un anneau principal',
          pages: 'pp. 167-175',
          leconNumero: '150, 155',
          commentaire: 'Version avec facteurs invariants et décomposition primaire',
        ),
        PageReference(
          developpement: 'Réduction de Jordan',
          pages: 'pp. 210-220',
          leconNumero: '153, 154',
          commentaire: 'Construction de la forme normale de Jordan, avec calcul explicite',
        ),
        PageReference(
          developpement: 'Théorème de Cayley-Hamilton',
          pages: 'pp. 195-198',
          leconNumero: '150, 153',
          commentaire: 'Deux preuves : par densité des diagonalisables et par les cofacteurs',
        ),
        PageReference(
          developpement: 'Décomposition polaire et spectrale',
          pages: 'pp. 258-265',
          leconNumero: '157, 158, 171',
          commentaire: 'Théorème spectral des matrices symétriques réelles et hermitiennes',
        ),
        PageReference(
          developpement: 'Dualité et bidual',
          pages: 'pp. 112-118',
          leconNumero: '106, 145',
          commentaire: 'Bases duales, hyperplans, isomorphisme canonique en dimension finie',
        ),
        PageReference(
          developpement: 'Groupes quotients et théorèmes d\'isomorphisme',
          pages: 'pp. 40-46',
          leconNumero: '101, 103, 108',
          commentaire: 'Les trois théorèmes d\'isomorphisme avec applications',
        ),
        PageReference(
          developpement: 'Théorème fondamental de l\'algèbre (Gauss-d\'Alembert)',
          pages: 'pp. 80-83',
          leconNumero: '102, 142',
          commentaire: 'Preuve par la théorie de Galois et preuve topologique',
        ),
        PageReference(
          developpement: 'Critères d\'irréductibilité (Eisenstein)',
          pages: 'pp. 74-77',
          leconNumero: '141, 142',
          commentaire: 'Eisenstein, réductions modulo p, critère par les racines',
        ),
        PageReference(
          developpement: 'Groupe diédral et classification',
          pages: 'pp. 55-59',
          leconNumero: '101, 104, 108',
          commentaire: 'Structure du groupe diédral, sous-groupes, représentations',
        ),
        PageReference(
          developpement: 'Déterminant et formes multilinéaires alternées',
          pages: 'pp. 130-140',
          leconNumero: '152',
          commentaire: 'Construction axiomatique, développement par rapport à une ligne/colonne',
        ),
      ],
    ),

    LivreAgreg(
      id: 'gourdon_analyse',
      titre: 'Les Maths en Tête — Analyse',
      auteurs: 'Xavier Gourdon',
      editeur: 'Ellipses',
      edition: '3e édition',
      categorie: 'analyse',
      difficulte: 2,
      commentaire: 'Le pendant analyse du Gourdon Algèbre. Aussi complet et rigoureux. Les chapitres sur les séries entières, l\'intégration et les équations différentielles sont particulièrement bien faits.',
      pourquoi: 'Référence complète pour l\'analyse, développements bien rédigés et directement exploitables à l\'oral.',
      pointsForts: [
        'Chapitres autonomes et bien structurés',
        'Démonstrations détaillées du théorème de convergence dominée, Fubini, etc.',
        'Bon chapitre sur les distributions',
        'Excellents exercices corrigés',
      ],
      pointsFaibles: [
        'Quelques preuves assez techniques sans motivation intuitive',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Théorème de convergence dominée de Lebesgue',
          pages: 'pp. 248-255',
          leconNumero: '228, 234',
          commentaire: 'Avec le lemme de Fatou et le théorème de convergence monotone',
        ),
        PageReference(
          developpement: 'Formule de Stirling',
          pages: 'pp. 50-54',
          leconNumero: '230, 239',
          commentaire: 'Avec méthode de Laplace et encadrement de Wallis',
        ),
        PageReference(
          developpement: 'Théorème de Stone-Weierstrass',
          pages: 'pp. 180-185',
          leconNumero: '205, 209, 246',
          commentaire: 'Version réseau : sous-algèbre séparant les points et contenant les constantes',
        ),
        PageReference(
          developpement: 'Théorème d\'Ascoli',
          pages: 'pp. 190-195',
          leconNumero: '201, 205, 246',
          commentaire: 'Caractérisation des compacts de C(X,R) par équicontinuité',
        ),
        PageReference(
          developpement: 'Séries de Fourier et convergence',
          pages: 'pp. 310-330',
          leconNumero: '235, 236, 246',
          commentaire: 'Noyaux de Dirichlet et Fejér, convergence L2, convergence ponctuelle',
        ),
        PageReference(
          developpement: 'Théorème de Cauchy-Lipschitz',
          pages: 'pp. 370-380',
          leconNumero: '220, 221',
          commentaire: 'Version locale (Picard) et version globale (linéaire)',
        ),
        PageReference(
          developpement: 'Théorème des fonctions implicites',
          pages: 'pp. 285-292',
          leconNumero: '214, 219',
          commentaire: 'Version C^k avec le théorème d\'inversion locale comme corollaire',
        ),
        PageReference(
          developpement: 'Théorème de Baire et applications',
          pages: 'pp. 165-172',
          leconNumero: '201, 204, 213',
          commentaire: 'Théorème de Banach-Steinhaus, théorème de l\'application ouverte',
        ),
        PageReference(
          developpement: 'Rayon de convergence et propriétés des séries entières',
          pages: 'pp. 100-115',
          leconNumero: '230, 232, 243',
          commentaire: 'Hadamard, Abel radial, développements classiques',
        ),
        PageReference(
          developpement: 'Formule de Poisson et transformée de Fourier',
          pages: 'pp. 335-342',
          leconNumero: '235, 236',
          commentaire: 'Avec application au calcul de sommes de séries',
        ),
      ],
    ),

    LivreAgreg(
      id: 'zuily_queffelec_analyse',
      titre: 'Analyse pour l\'agrégation',
      auteurs: 'Claude Zuily, Hervé Queffélec',
      editeur: 'Dunod',
      edition: '4e édition',
      categorie: 'analyse',
      difficulte: 2,
      commentaire: 'Un classique incontournable de l\'analyse pour l\'agrégation. Très complet, avec de nombreux exercices et problèmes. Le style est élégant et les preuves sont particulièrement soignées.',
      pourquoi: 'Exercices et problèmes d\'un excellent niveau, traitement complet de l\'analyse fonctionnelle et de la mesure.',
      pointsForts: [
        'Rédaction impeccable, style mathématique élégant',
        'Chapitre sur les distributions très accessible',
        'Problèmes corrigés de niveau agrégation',
        'Bon traitement de l\'intégration de Lebesgue',
      ],
      pointsFaibles: [
        'Certains passages nécessitent un bon niveau de maturité',
        'Moins d\'exemples concrets que le Gourdon',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Théorème de Hahn-Banach',
          pages: 'pp. 95-102',
          leconNumero: '205, 213',
          commentaire: 'Version analytique et géométrique, avec applications',
        ),
        PageReference(
          developpement: 'Théorème de Banach-Steinhaus',
          pages: 'pp. 108-113',
          leconNumero: '204, 213',
          commentaire: 'Avec le théorème de Banach-Steinhaus et applications aux séries de Fourier',
        ),
        PageReference(
          developpement: 'Théorème de Lax-Milgram',
          pages: 'pp. 130-135',
          leconNumero: '213, 219',
          commentaire: 'Avec application à l\'équation de Poisson',
        ),
        PageReference(
          developpement: 'Dual de Lp',
          pages: 'pp. 230-240',
          leconNumero: '234, 245',
          commentaire: 'Théorème de représentation de Riesz pour Lp',
        ),
        PageReference(
          developpement: 'Compacité dans les espaces Lp',
          pages: 'pp. 245-252',
          leconNumero: '201, 234',
          commentaire: 'Théorème de Riesz-Fréchet-Kolmogorov',
        ),
        PageReference(
          developpement: 'Convergence des séries de Fourier dans L2',
          pages: 'pp. 290-300',
          leconNumero: '235, 236, 246',
          commentaire: 'Base hilbertienne, identité de Parseval, convergence en norme',
        ),
      ],
    ),

    LivreAgreg(
      id: 'queffelec_zuily_algebre',
      titre: 'Algèbre et géométrie pour l\'agrégation',
      auteurs: 'Hervé Queffélec, Claude Zuily',
      editeur: 'Dunod',
      categorie: 'algebre',
      difficulte: 2,
      commentaire: 'Le complément algèbre du Zuily-Queffélec. Moins utilisé que le Gourdon mais contient d\'excellents développements originaux, notamment en géométrie.',
      pourquoi: 'Développements de géométrie très bien rédigés, bon traitement des formes bilinéaires.',
      pointsForts: [
        'Chapitres géométrie bien développés',
        'Bonne articulation algèbre-géométrie',
        'Exercices de type concours',
      ],
      pointsFaibles: [
        'Couverture moins exhaustive que le Gourdon',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Isométries du plan et de l\'espace',
          pages: 'pp. 310-325',
          leconNumero: '106, 170, 171',
          commentaire: 'Classification complète avec décomposition en réflexions',
        ),
        PageReference(
          developpement: 'Coniques et quadriques : classification',
          pages: 'pp. 340-355',
          leconNumero: '170, 171',
          commentaire: 'Réduction des formes quadratiques, invariants de similitude',
        ),
        PageReference(
          developpement: 'Endomorphismes normaux',
          pages: 'pp. 250-258',
          leconNumero: '157, 158',
          commentaire: 'Caractérisation et diagonalisation dans une base orthonormée',
        ),
      ],
    ),

    LivreAgreg(
      id: 'francinou_gianella_algebre',
      titre: 'Oraux X-ENS — Algèbre',
      auteurs: 'Serge Francinou, Hervé Gianella, Serge Nicolas',
      editeur: 'Cassini',
      categorie: 'algebre',
      difficulte: 3,
      commentaire: 'La bible des exercices d\'algèbre de haut niveau. Indispensable pour trouver des développements originaux qui impressionnent le jury. Chaque exercice est un mini-développement potentiel.',
      pourquoi: 'Mine de développements originaux et élégants, idéaux pour se démarquer à l\'oral.',
      pointsForts: [
        'Exercices très riches et bien choisis',
        'Solutions détaillées et instructives',
        'Développements originaux introuvables ailleurs',
        'Classement par thème très pratique',
      ],
      pointsFaibles: [
        'Niveau élevé, peut décourager au début',
        'Pas adapté comme premier ouvrage d\'algèbre',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Nombre de sous-groupes d\'ordre p dans Sn',
          pages: 'vol. 1, pp. 45-52',
          leconNumero: '101, 103, 104',
          commentaire: 'Application de l\'équation aux classes dans le groupe symétrique',
        ),
        PageReference(
          developpement: 'Irréductibilité des polynômes cyclotomiques',
          pages: 'vol. 2, pp. 88-94',
          leconNumero: '102, 141',
          commentaire: 'Preuve par réduction modulo p et critère d\'Eisenstein',
        ),
        PageReference(
          developpement: 'Théorème de Burnside (pαqβ)',
          pages: 'vol. 1, pp. 120-128',
          leconNumero: '101, 103, 108',
          commentaire: 'Tout groupe d\'ordre pαqβ est résoluble',
        ),
        PageReference(
          developpement: 'Sous-groupes de Z/nZ et indicatrice d\'Euler',
          pages: 'vol. 2, pp. 15-22',
          leconNumero: '102, 141',
          commentaire: 'Structure des sous-groupes cycliques et applications',
        ),
        PageReference(
          developpement: 'Exponentielle de matrices et applications',
          pages: 'vol. 3, pp. 200-215',
          leconNumero: '154, 221',
          commentaire: 'Propriétés, calculs explicites, lien avec les systèmes différentiels',
        ),
      ],
    ),

    LivreAgreg(
      id: 'francinou_gianella_analyse',
      titre: 'Oraux X-ENS — Analyse',
      auteurs: 'Serge Francinou, Hervé Gianella, Serge Nicolas',
      editeur: 'Cassini',
      categorie: 'analyse',
      difficulte: 3,
      commentaire: 'Le pendant analyse de la série Oraux X-ENS. Des exercices d\'une grande richesse mathématique, souvent transformables en développements originaux.',
      pourquoi: 'Source de développements d\'analyse de niveau excellent, permet de se démarquer.',
      pointsForts: [
        'Exercices très bien construits',
        'Thématiques variées et profondes',
        'Solutions complètes et élégantes',
      ],
      pointsFaibles: [
        'Niveau parfois au-delà du programme de l\'agrégation',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Théorème d\'approximation de Weierstrass par les polynômes de Bernstein',
          pages: 'vol. 1, pp. 78-85',
          leconNumero: '209, 230',
          commentaire: 'Construction explicite et estimation de l\'erreur',
        ),
        PageReference(
          developpement: 'Équation fonctionnelle de la fonction Gamma',
          pages: 'vol. 2, pp. 145-155',
          leconNumero: '229, 230, 239',
          commentaire: 'Propriétés de la fonction Gamma, formule de Stirling, compléments',
        ),
        PageReference(
          developpement: 'Lemme de Borel-Cantelli',
          pages: 'vol. 3, pp. 40-48',
          leconNumero: '264',
          commentaire: 'Applications aux probabilités et à la théorie de la mesure',
        ),
        PageReference(
          developpement: 'Densité des polynômes trigonométriques',
          pages: 'vol. 2, pp. 200-210',
          leconNumero: '235, 236',
          commentaire: 'Par le théorème de Stone-Weierstrass et les noyaux de Fejér',
        ),
      ],
    ),

    LivreAgreg(
      id: 'beck_malick_peyre',
      titre: 'Objectif Agrégation',
      auteurs: 'Vincent Beck, Jérôme Malick, Gabriel Peyre',
      editeur: 'H&K',
      edition: '2e édition',
      categorie: 'transversal',
      difficulte: 2,
      commentaire: 'LE livre de référence pour la préparation à l\'oral de l\'agrégation. Contient un choix judicieux de développements pour chaque leçon, avec des indications précises sur leur placement.',
      pourquoi: 'Organisation par leçon, développements clés en main avec les leçons correspondantes. Le compagnon idéal pour l\'oral.',
      pointsForts: [
        'Organisation leçon par leçon',
        'Développements calibrés pour l\'oral (15-20 min)',
        'Indications de placement dans les leçons',
        'Très bonne qualité de rédaction',
      ],
      pointsFaibles: [
        'Pas assez détaillé pour remplacer un vrai cours',
        'Certains développements mériteraient plus de motivation',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Théorème de Perron-Frobenius',
          pages: 'pp. 25-30',
          leconNumero: '153, 154, 157',
          commentaire: 'Pour les leçons de réduction et les matrices positives',
        ),
        PageReference(
          developpement: 'Théorème de d\'Alembert-Gauss (preuve analytique)',
          pages: 'pp. 45-49',
          leconNumero: '142, 170',
          commentaire: 'Preuve élégante par la topologie et l\'analyse complexe',
        ),
        PageReference(
          developpement: 'Théorème central limite',
          pages: 'pp. 280-286',
          leconNumero: '264',
          commentaire: 'Via les fonctions caractéristiques',
        ),
        PageReference(
          developpement: 'Décomposition de Dunford',
          pages: 'pp. 85-92',
          leconNumero: '153, 154',
          commentaire: 'Partie semi-simple + nilpotente, avec applications',
        ),
        PageReference(
          developpement: 'Théorème de Cartan-Dieudonné',
          pages: 'pp. 120-126',
          leconNumero: '106, 170, 171',
          commentaire: 'Toute isométrie est produit de réflexions',
        ),
        PageReference(
          developpement: 'Théorème de Weierstrass (approximation)',
          pages: 'pp. 195-200',
          leconNumero: '209, 230',
          commentaire: 'Par les polynômes de Bernstein',
        ),
        PageReference(
          developpement: 'Méthode de Newton pour la résolution d\'équations',
          pages: 'pp. 215-220',
          leconNumero: '214, 219',
          commentaire: 'Convergence quadratique et lien avec le théorème du point fixe',
        ),
      ],
    ),

    LivreAgreg(
      id: 'caldero_germoni',
      titre: 'Nouvelles Histoires hédonistes de groupes et de géométries',
      auteurs: 'Philippe Caldero, Jérôme Germoni',
      editeur: 'Calvage et Mounet',
      categorie: 'algebre',
      difficulte: 2,
      commentaire: 'Un bijou pour l\'algèbre et la géométrie. Le style est vivant et motivé, les exemples sont nombreux. Particulièrement apprécié des candidats pour ses développements de géométrie et de théorie des groupes.',
      pourquoi: 'Style très agréable, excellents développements de géométrie et de groupes. Idéal pour comprendre en profondeur.',
      pointsForts: [
        'Style vivant et motivé, pas juste des théorèmes',
        'Excellente section sur les groupes de permutations',
        'Développements géométriques très appréciés par le jury',
        'Bonne couverture de la géométrie projective',
      ],
      pointsFaibles: [
        'Organisation parfois non linéaire',
        'Certains sujets traités de manière originale mais inhabituelle',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Simplicité du groupe alterné An (n≥5)',
          pages: 'tome 1, pp. 95-105',
          leconNumero: '101, 104, 108',
          commentaire: 'Preuve par les 3-cycles et le commutateur',
        ),
        PageReference(
          developpement: 'Sous-groupes finis de SO(3)',
          pages: 'tome 1, pp. 130-145',
          leconNumero: '104, 106, 170',
          commentaire: 'Classification : cycliques, diédraux, tétraédral, octaédral, icosaédral',
        ),
        PageReference(
          developpement: 'Isométries du cube et du tétraèdre',
          pages: 'tome 1, pp. 150-165',
          leconNumero: '104, 170, 171',
          commentaire: 'Groupes de symétries des polyèdres réguliers',
        ),
        PageReference(
          developpement: 'Groupe de Galois des extensions cyclotomiques',
          pages: 'tome 2, pp. 180-195',
          leconNumero: '102, 141',
          commentaire: 'Lien avec les racines de l\'unité et la construction à la règle et au compas',
        ),
        PageReference(
          developpement: 'Théorème de Wedderburn (corps fini commutatif)',
          pages: 'tome 2, pp. 210-218',
          leconNumero: '103, 141',
          commentaire: 'Tout corps fini est commutatif — preuve par les polynômes cyclotomiques',
        ),
      ],
    ),

    LivreAgreg(
      id: 'rouviere',
      titre: 'Petit guide de calcul différentiel',
      auteurs: 'François Rouvière',
      editeur: 'Cassini',
      edition: '2e édition',
      categorie: 'analyse',
      difficulte: 1,
      commentaire: 'Un petit bijou de clarté pour le calcul différentiel. Idéal pour comprendre les théorèmes de fonctions implicites, d\'inversion locale. Très concis et efficace.',
      pourquoi: 'Le meilleur rapport effort/compréhension pour le calcul différentiel. Parfait pour réviser rapidement.',
      pointsForts: [
        'Extrêmement clair et concis',
        'Nombreux dessins et schémas explicatifs',
        'Petit format idéal pour la valise',
        'Très bon chapitre sur les sous-variétés',
      ],
      pointsFaibles: [
        'Limité au calcul différentiel',
        'Pas assez d\'exercices',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Théorème d\'inversion locale',
          pages: 'pp. 45-55',
          leconNumero: '214, 219',
          commentaire: 'Preuve claire et géométrique, avec applications',
        ),
        PageReference(
          developpement: 'Théorème des fonctions implicites',
          pages: 'pp. 60-72',
          leconNumero: '214, 219',
          commentaire: 'Déduction à partir du théorème d\'inversion locale',
        ),
        PageReference(
          developpement: 'Multiplicateurs de Lagrange',
          pages: 'pp. 90-98',
          leconNumero: '214, 219, 171',
          commentaire: 'Optimisation sous contraintes avec exemples géométriques',
        ),
        PageReference(
          developpement: 'Sous-variétés de Rn',
          pages: 'pp. 105-118',
          leconNumero: '214',
          commentaire: 'Définition, espace tangent, théorème des fonctions implicites sur les variétés',
        ),
      ],
    ),

    LivreAgreg(
      id: 'rombaldi',
      titre: 'Thèmes pour l\'agrégation de mathématiques',
      auteurs: 'Jean-Étienne Rombaldi',
      editeur: 'EDP Sciences',
      categorie: 'transversal',
      difficulte: 2,
      commentaire: 'Couvre à la fois l\'algèbre et l\'analyse avec un angle "développements pour l\'agrégation". Chaque chapitre est un thème pouvant servir de développement complet.',
      pourquoi: 'Développements thématiques originaux, bon complément au BMP.',
      pointsForts: [
        'Développements complets et bien rédigés',
        'Thèmes transversaux algèbre/analyse',
        'Bon niveau de difficulté pour l\'agrégation',
      ],
      pointsFaibles: [
        'Pas de cours, uniquement des thèmes',
        'Index moins détaillé',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Théorème de Bézout effectif et PGCD',
          pages: 'pp. 35-42',
          leconNumero: '141, 152',
          commentaire: 'Algorithme d\'Euclide étendu et applications',
        ),
        PageReference(
          developpement: 'Endomorphismes cycliques et compagnon',
          pages: 'pp. 95-105',
          leconNumero: '150, 153, 154',
          commentaire: 'Matrice compagnon et décomposition de Frobenius',
        ),
        PageReference(
          developpement: 'Lemme de Morse',
          pages: 'pp. 220-228',
          leconNumero: '214, 219',
          commentaire: 'Classification locale des points critiques non dégénérés',
        ),
      ],
    ),

    LivreAgreg(
      id: 'tauvel',
      titre: 'Algèbre et applications',
      auteurs: 'Patrice Tauvel',
      editeur: 'Springer',
      categorie: 'algebre',
      difficulte: 2,
      commentaire: 'Un cours d\'algèbre très complet avec une approche progressive. Couvre l\'algèbre commutative et les corps plus en profondeur que le Gourdon.',
      pourquoi: 'Traitement approfondi de la théorie de Galois et des anneaux. Idéal pour les leçons d\'algèbre avancées.',
      pointsForts: [
        'Théorie de Galois très bien développée',
        'Algèbre commutative détaillée',
        'Bonne couverture des anneaux et modules',
      ],
      pointsFaibles: [
        'Style parfois sec et technique',
        'Volume important (2 tomes)',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Théorème fondamental de la théorie de Galois',
          pages: 'tome 2, pp. 85-100',
          leconNumero: '141, 142',
          commentaire: 'Correspondance de Galois, extensions galoisiennes, groupe de Galois',
        ),
        PageReference(
          developpement: 'Résolution par radicaux et groupes résolubles',
          pages: 'tome 2, pp. 115-128',
          leconNumero: '108, 141, 142',
          commentaire: 'Non-résolubilité de l\'équation de degré 5',
        ),
        PageReference(
          developpement: 'Constructions à la règle et au compas',
          pages: 'tome 2, pp. 130-140',
          leconNumero: '141, 142',
          commentaire: 'Impossibilité de la duplication du cube et de la trisection de l\'angle',
        ),
      ],
    ),

    // =========================================================================
    // PROBABILITÉS
    // =========================================================================
    LivreAgreg(
      id: 'ouvrard',
      titre: 'Probabilités 2 — Maîtrise-Agrégation',
      auteurs: 'Jean-Yves Ouvrard',
      editeur: 'Cassini',
      categorie: 'probabilites',
      difficulte: 2,
      commentaire: 'Le cours de probabilités de référence pour l\'agrégation. Traitement rigoureux fondé sur la théorie de la mesure, avec de nombreux exemples et applications.',
      pourquoi: 'Cours de probabilités complet et rigoureux, bien calibré pour le programme de l\'agrégation.',
      pointsForts: [
        'Bonnes fondations mesure-probabilités',
        'Exemples calculatoires détaillés',
        'Chapitre clair sur les chaînes de Markov',
        'Exercices progressifs',
      ],
      pointsFaibles: [
        'Mise en page parfois dense',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Loi des grands nombres (forte)',
          pages: 'pp. 120-130',
          leconNumero: '264',
          commentaire: 'Par la méthode des moments d\'ordre 4 et Borel-Cantelli',
        ),
        PageReference(
          developpement: 'Théorème central limite',
          pages: 'pp. 155-168',
          leconNumero: '264',
          commentaire: 'Via les fonctions caractéristiques et le théorème de Lévy',
        ),
        PageReference(
          developpement: 'Convergence des chaînes de Markov irréductibles apériodiques',
          pages: 'pp. 210-225',
          leconNumero: '264',
          commentaire: 'Ergodicité, mesure stationnaire, vitesse de convergence',
        ),
      ],
    ),

    LivreAgreg(
      id: 'barbe_ledoux',
      titre: 'Probabilité',
      auteurs: 'Philippe Barbe, Michel Ledoux',
      editeur: 'EDP Sciences / SMAI',
      categorie: 'probabilites',
      difficulte: 3,
      commentaire: 'Un cours de probabilités avancé, plus complet qu\'Ouvrard sur certains sujets. Excellente référence pour les développements de probabilités originaux.',
      pourquoi: 'Développements avancés de probabilités pour se démarquer. Bon traitement de la convergence et des inégalités.',
      pointsForts: [
        'Traitement rigoureux et moderne',
        'Inégalités de concentration',
        'Bonne couverture des processus',
      ],
      pointsFaibles: [
        'Niveau parfois élevé pour l\'agrégation',
        'Moins d\'exemples élémentaires',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Inégalités de Markov, Bienaymé-Tchebychev, Hoeffding',
          pages: 'pp. 58-68',
          leconNumero: '264',
          commentaire: 'Inégalités de concentration fondamentales',
        ),
        PageReference(
          developpement: 'Méthode du second moment et seuils',
          pages: 'pp. 85-95',
          leconNumero: '264',
          commentaire: 'Applications combinatoires et graphes aléatoires',
        ),
      ],
    ),

    // =========================================================================
    // GÉOMÉTRIE
    // =========================================================================
    LivreAgreg(
      id: 'audin',
      titre: 'Géométrie',
      auteurs: 'Michèle Audin',
      editeur: 'EDP Sciences',
      categorie: 'geometrie',
      difficulte: 2,
      commentaire: 'Un cours de géométrie moderne et bien motivé. Le lien entre algèbre linéaire et géométrie y est particulièrement bien fait. Très apprécié pour les leçons de géométrie.',
      pourquoi: 'Le meilleur traitement de la géométrie affine, euclidienne et projective pour l\'agrégation.',
      pointsForts: [
        'Lien algèbre-géométrie remarquable',
        'Géométrie projective bien traitée',
        'Nombreuses figures',
        'Style vivant et motivé',
      ],
      pointsFaibles: [
        'Certains sujets classiques manquants',
      ],
      conseilleValise: true,
      developpements: [
        PageReference(
          developpement: 'Classification des isométries du plan et de l\'espace',
          pages: 'pp. 85-100',
          leconNumero: '106, 170, 171',
          commentaire: 'Classification complète avec décomposition en réflexions',
        ),
        PageReference(
          developpement: 'Classification des coniques',
          pages: 'pp. 145-165',
          leconNumero: '170, 171',
          commentaire: 'Par les invariants : trace, déterminant de la matrice associée',
        ),
        PageReference(
          developpement: 'Théorème de Sylvester (inertie)',
          pages: 'pp. 120-128',
          leconNumero: '157, 158, 170',
          commentaire: 'Signature d\'une forme quadratique et invariance',
        ),
        PageReference(
          developpement: 'Géométrie projective : théorème de Desargues et dualité',
          pages: 'pp. 200-215',
          leconNumero: '170',
          commentaire: 'Coordonnées homogènes, dualité points-droites, birapport',
        ),
      ],
    ),

    LivreAgreg(
      id: 'berger',
      titre: 'Géométrie (tomes 1 à 5)',
      auteurs: 'Marcel Berger',
      editeur: 'Nathan / Cassini',
      categorie: 'geometrie',
      difficulte: 3,
      commentaire: 'L\'encyclopédie de la géométrie. Extrêmement complet mais volumineux. À consulter plutôt qu\'à emporter dans la valise. Source inépuisable d\'exemples et de développements.',
      pourquoi: 'La référence absolue en géométrie, pour trouver des développements rares et originaux.',
      pointsForts: [
        'Couverture exhaustive de la géométrie',
        'Richesse encyclopédique',
        'Nombreux résultats introuvables ailleurs',
      ],
      pointsFaibles: [
        'Très volumineux (5 tomes)',
        'Pas adapté à la valise',
        'Style encyclopédique, pas toujours pédagogique',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Théorème de Gauss-Bonnet',
          pages: 'tome 3, pp. 380-395',
          leconNumero: '170, 214',
          commentaire: 'Courbure de Gauss et topologie des surfaces',
        ),
        PageReference(
          developpement: 'Formule de Euler pour les polyèdres',
          pages: 'tome 1, pp. 200-210',
          leconNumero: '170',
          commentaire: 'V - E + F = 2 et classification des polyèdres réguliers',
        ),
      ],
    ),

    // =========================================================================
    // COMPLÉMENTS / TRANSVERSAL
    // =========================================================================
    LivreAgreg(
      id: 'zavidovique',
      titre: 'Analyse',
      auteurs: 'Maxime Zavidovique',
      editeur: 'De Boeck',
      categorie: 'analyse',
      difficulte: 1,
      commentaire: 'Un cours d\'analyse très accessible et progressif. Idéal comme premier ouvrage ou pour revoir les bases. Les preuves sont détaillées avec beaucoup d\'explications intermédiaires.',
      pourquoi: 'Excellente entrée en matière, bon pour consolider les fondamentaux.',
      pointsForts: [
        'Très accessible et progressif',
        'Preuves très détaillées',
        'Bon pour les candidats venant de filières non-maths',
      ],
      pointsFaibles: [
        'Pas assez avancé pour les développements de haut niveau',
        'Couverture limitée sur certains sujets',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Suites et séries de fonctions : convergence uniforme',
          pages: 'pp. 150-165',
          leconNumero: '209, 230',
          commentaire: 'Théorèmes de continuité, dérivabilité, intégrabilité de la limite',
        ),
        PageReference(
          developpement: 'Séries entières et fonctions analytiques',
          pages: 'pp. 180-195',
          leconNumero: '230, 232',
          commentaire: 'Développements classiques, rayon de convergence, Abel',
        ),
      ],
    ),

    LivreAgreg(
      id: 'combes',
      titre: 'Algèbre et géométrie',
      auteurs: 'François Combes',
      editeur: 'Dunod',
      categorie: 'algebre',
      difficulte: 1,
      commentaire: 'Un cours d\'algèbre et géométrie très clair et bien structuré. Bon point de départ pour l\'algèbre linéaire et bilinéaire. Moins de développements avancés que le Gourdon.',
      pourquoi: 'Cours clair pour les fondamentaux d\'algèbre et de géométrie.',
      pointsForts: [
        'Très clair et pédagogique',
        'Bien structuré par chapitres',
        'Bons exercices d\'entraînement',
      ],
      pointsFaibles: [
        'Manque de profondeur pour l\'agrégation',
        'Peu de développements avancés',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Diagonalisation et trigonalisation',
          pages: 'pp. 280-300',
          leconNumero: '153, 154',
          commentaire: 'Critères de diagonalisation, polynôme minimal, exemples',
        ),
      ],
    ),

    LivreAgreg(
      id: 'ciarlet',
      titre: 'Introduction à l\'analyse numérique matricielle et à l\'optimisation',
      auteurs: 'Philippe G. Ciarlet',
      editeur: 'Dunod',
      categorie: 'transversal',
      difficulte: 2,
      commentaire: 'La référence classique pour l\'analyse numérique. Indispensable pour les leçons d\'analyse numérique matricielle (pivot de Gauss, valeurs propres, moindres carrés).',
      pourquoi: 'Les leçons d\'analyse numérique puisent largement dans ce livre.',
      pointsForts: [
        'Traitement rigoureux de l\'analyse numérique',
        'Démonstrations de convergence détaillées',
        'Applications concrètes',
      ],
      pointsFaibles: [
        'Uniquement analyse numérique',
        'Style parfois technique',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Méthode de Newton pour les systèmes',
          pages: 'pp. 210-225',
          leconNumero: '214',
          commentaire: 'Convergence quadratique locale, théorème de Kantorovich',
        ),
        PageReference(
          developpement: 'Décomposition en valeurs singulières (SVD)',
          pages: 'pp. 45-55',
          leconNumero: '157, 158',
          commentaire: 'Construction, propriétés, applications aux moindres carrés',
        ),
        PageReference(
          developpement: 'Itération QR et convergence',
          pages: 'pp. 180-195',
          leconNumero: '153, 154, 157',
          commentaire: 'Algorithme QR pour le calcul des valeurs propres',
        ),
      ],
    ),

    LivreAgreg(
      id: 'demailly',
      titre: 'Analyse numérique et équations différentielles',
      auteurs: 'Jean-Pierre Demailly',
      editeur: 'EDP Sciences',
      edition: '5e édition',
      categorie: 'analyse',
      difficulte: 2,
      commentaire: 'Très bon traitement des méthodes numériques pour les EDO et EDP. Complète bien le Ciarlet pour la partie équations différentielles numériques.',
      pourquoi: 'Développements numériques originaux pour les leçons d\'EDO.',
      pointsForts: [
        'Bon lien théorie/numérique',
        'Schémas numériques bien analysés',
        'Applications physiques',
      ],
      pointsFaibles: [
        'Focus numérique uniquement',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Méthode d\'Euler et convergence',
          pages: 'pp. 65-78',
          leconNumero: '220, 221',
          commentaire: 'Schéma d\'Euler explicite, implicite, stabilité',
        ),
        PageReference(
          developpement: 'Méthodes de Runge-Kutta',
          pages: 'pp. 82-95',
          leconNumero: '220, 221',
          commentaire: 'Construction et ordre de convergence',
        ),
      ],
    ),

    LivreAgreg(
      id: 'perrin',
      titre: 'Cours d\'algèbre',
      auteurs: 'Daniel Perrin',
      editeur: 'Ellipses',
      categorie: 'algebre',
      difficulte: 2,
      commentaire: 'Un excellent cours d\'algèbre, particulièrement apprécié pour ses chapitres sur la théorie de Galois et les groupes. Le style est clair avec de bonnes motivations.',
      pourquoi: 'Meilleur traitement de la théorie de Galois pour l\'agrégation, très bien motivé.',
      pointsForts: [
        'Théorie de Galois remarquablement exposée',
        'Style clair avec des motivations historiques',
        'Bons exercices',
        'Chapitre sur les groupes résolubles très utile',
      ],
      pointsFaibles: [
        'Ne couvre pas toute l\'algèbre linéaire',
      ],
      conseilleValise: false,
      developpements: [
        PageReference(
          developpement: 'Non-résolubilité par radicaux de l\'équation de degré ≥ 5',
          pages: 'pp. 280-295',
          leconNumero: '108, 141, 142',
          commentaire: 'Par la théorie de Galois et la simplicité de A5',
        ),
        PageReference(
          developpement: 'Extensions de corps et degré',
          pages: 'pp. 180-195',
          leconNumero: '141, 142',
          commentaire: 'Multiplicativité des degrés, extensions algébriques, transcendantes',
        ),
        PageReference(
          developpement: 'Groupe de Galois de xn - 1',
          pages: 'pp. 230-245',
          leconNumero: '102, 141, 142',
          commentaire: 'Polynômes cyclotomiques, groupe (Z/nZ)*',
        ),
      ],
    ),
  ];

  /// Livres recommandés pour la valise (jour J de l'oral)
  static List<LivreAgreg> get livresValise =>
      livres.where((l) => l.conseilleValise).toList();

  /// Livres par catégorie
  static List<LivreAgreg> parCategorie(String categorie) =>
      livres.where((l) => l.categorie == categorie).toList();

  /// Rechercher un livre ou un développement
  static List<LivreAgreg> rechercher(String query) {
    final q = query.toLowerCase();
    return livres.where((l) =>
      l.titre.toLowerCase().contains(q) ||
      l.auteurs.toLowerCase().contains(q) ||
      l.commentaire.toLowerCase().contains(q) ||
      l.developpements.any((d) => d.developpement.toLowerCase().contains(q))
    ).toList();
  }

  /// Trouver les livres contenant un développement donné
  static List<MapEntry<LivreAgreg, PageReference>> trouverDeveloppement(String query) {
    final q = query.toLowerCase();
    final results = <MapEntry<LivreAgreg, PageReference>>[];
    for (final livre in livres) {
      for (final dev in livre.developpements) {
        if (dev.developpement.toLowerCase().contains(q)) {
          results.add(MapEntry(livre, dev));
        }
      }
    }
    return results;
  }

  /// Toutes les catégories disponibles
  static const List<String> categories = [
    'algebre', 'analyse', 'probabilites', 'geometrie', 'transversal',
  ];

  /// Nombre maximum de livres recommandé pour la valise
  static const int maxLivresValise = 6;

  /// Conseil pour constituer la valise
  static const String conseilValise =
    'Pour l\'oral de l\'agrégation, vous avez le droit d\'apporter un nombre limité '
    'd\'ouvrages (généralement 4 à 6 livres). Choisissez des livres complémentaires '
    'qui couvrent l\'ensemble du programme. Notre recommandation : '
    '1 algèbre (Gourdon), 1 analyse (Gourdon), 1 oral (BMP), '
    '1 géométrie (Audin ou Caldero-Germoni), 1 exercices (Francinou), '
    '1 calcul diff (Rouvière).';
}
