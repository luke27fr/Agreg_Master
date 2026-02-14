import '../models/annale_model.dart';

/// Données enrichies des annales officielles de l'agrégation de mathématiques
/// (externe ET interne).
///
/// Chaque entrée fournit les métadonnées et les liens vers les PDF officiels
/// (sujets, corrigés, rapports du jury). Aucun contenu d'examen n'est reproduit
/// dans l'application : tout passe par les liens PDF.
class AnnalesEnrichedData {
  static List<Annale> getAllAnnales() {
    return [
      // ──── 2025 ────
      _ext2025MG(),
      _ext2025AP(),
      _int2025EP1(),
      _int2025EP2(),
      // ──── 2024 ────
      _ext2024MG(),
      _ext2024AP(),
      _int2024EP1(),
      _int2024EP2(),
      // ──── 2023 ────
      _ext2023MG(),
      _ext2023AP(),
      _int2023EP1(),
      _int2023EP2(),
      // ──── 2022 ────
      _ext2022MG(),
      _ext2022AP(),
      _int2022EP1(),
      _int2022EP2(),
      // ──── 2021 ────
      _ext2021MG(),
      _ext2021AP(),
      _int2021EP1(),
      _int2021EP2(),
      // ──── 2020 ────
      _ext2020MG(),
      _ext2020AP(),
      _int2020EP1(),
      _int2020EP2(),
      // ──── 2019 ────
      _ext2019MG(),
      _ext2019AP(),
      _int2019EP1(),
      _int2019EP2(),
      // ──── 2018 ────
      _ext2018MG(),
      _ext2018AP(),
      _int2018EP1(),
      _int2018EP2(),
      // ──── 2017 ────
      _ext2017MG(),
      _ext2017AP(),
      _int2017EP1(),
      _int2017EP2(),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2025 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2025MG() {
    return Annale(
      id: 'ext_2025_mg',
      annee: 2025,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2025 – Épreuve 1 : Mathématiques générales',
      description:
          'Épreuve de mathématiques générales de la session 2025, couvrant '
          'algèbre, géométrie et arithmétique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Arithmétique'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg25.pdf',
      urlCorrige: null,
      urlRapport: null,
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Algèbre linéaire',
        'Groupes et anneaux',
        'Géométrie affine',
        'Polynômes',
        'Réduction des endomorphismes',
      ],
      rapportGlobal:
          'Le rapport du jury sera publié ultérieurement.',
      parties: [
        'Partie I – Algèbre',
        'Partie II – Géométrie',
        'Partie III – Problème de synthèse',
      ],
    );
  }

  static Annale _ext2025AP() {
    return Annale(
      id: 'ext_2025_ap',
      annee: 2025,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2025 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités de la session 2025, mêlant '
          'analyse fonctionnelle, intégration et probabilités.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Analyse fonctionnelle'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap25.pdf',
      urlCorrige: null,
      urlRapport: null,
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Séries de fonctions',
        'Intégrale de Lebesgue',
        'Espaces de Hilbert',
        'Convergence en loi',
        'Théorème central limite',
      ],
      rapportGlobal:
          'Le rapport du jury sera publié ultérieurement.',
      parties: [
        'Partie I – Analyse',
        'Partie II – Probabilités',
        'Partie III – Problème de synthèse',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2025 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2025EP1() {
    return Annale(
      id: 'int_2025_ep1',
      annee: 2025,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2025 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2025, '
          'couvrant algèbre, analyse et géométrie dans une perspective '
          'orientée vers l\'enseignement secondaire.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Analyse', 'Géométrie'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/25-ep1.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/corrige_ep1_2025.pdf',
      urlRapport: null,
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Groupes cycliques',
        'Suites numériques',
        'Transformations du plan',
        'Polynômes',
        'Continuité',
      ],
      rapportGlobal:
          'Le rapport du jury sera publié ultérieurement.',
      parties: [
        'Partie I – Algèbre et arithmétique',
        'Partie II – Analyse',
        'Partie III – Géométrie',
      ],
    );
  }

  static Annale _int2025EP2() {
    return Annale(
      id: 'int_2025_ep2',
      annee: 2025,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2025 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2025, '
          'mêlant analyse, probabilités et arithmétique avec une orientation '
          'vers la didactique et le programme du secondaire.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Arithmétique'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/25-ep2.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/corrige_ep2_2025.pdf',
      urlRapport: null,
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Intégration',
        'Variables aléatoires',
        'Divisibilité',
        'Fonctions convexes',
        'Dénombrement',
      ],
      rapportGlobal:
          'Le rapport du jury sera publié ultérieurement.',
      parties: [
        'Partie I – Analyse et calcul intégral',
        'Partie II – Probabilités et statistiques',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2024 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2024MG() {
    return Annale(
      id: 'ext_2024_mg',
      annee: 2024,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2024 – Épreuve 1 : Mathématiques générales',
      description:
          'Épreuve de mathématiques générales couvrant algèbre, géométrie et arithmétique. '
          'Sujet en plusieurs parties indépendantes mêlant théorie des groupes, '
          'algèbre linéaire et géométrie.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Algèbre linéaire'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg24.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2024/MG2024_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_eae_2024.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Groupes finis',
        'Formes bilinéaires',
        'Espaces euclidiens',
        'Réduction des endomorphismes',
        'Géométrie affine',
      ],
      rapportGlobal:
          'Le jury note que la barre d\'admissibilité reste basse (environ 5/20), '
          'ce qui reflète la difficulté intrinsèque des épreuves. '
          'Les candidats qui réussissent sont ceux qui maîtrisent les fondamentaux du cours '
          'et savent les appliquer avec rigueur. '
          'Le jury recommande de soigner la rédaction et de ne pas négliger les questions '
          'de début de partie, souvent plus abordables.',
      parties: [
        'Partie I – Algèbre linéaire et formes bilinéaires',
        'Partie II – Groupes et actions de groupes',
        'Partie III – Géométrie',
        'Partie IV – Problème de synthèse',
      ],
    );
  }

  static Annale _ext2024AP() {
    return Annale(
      id: 'ext_2024_ap',
      annee: 2024,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2024 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités mêlant analyse fonctionnelle, '
          'séries, intégration et probabilités.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Analyse fonctionnelle'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap24.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2024/AP2024_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_eae_2024.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Séries de Fourier',
        'Espaces de Hilbert',
        'Convergence de variables aléatoires',
        'Intégration',
        'Théorème central limite',
      ],
      rapportGlobal:
          'Le jury souligne l\'importance de bien maîtriser le cours d\'analyse '
          '(convergences, intégration, séries) et les bases de probabilités. '
          'Beaucoup de candidats perdent des points sur des questions de cours classiques. '
          'La barre d\'admissibilité se situe autour de 5/20. '
          'Il est conseillé de traiter les premières questions de chaque partie '
          'avant de s\'attaquer aux questions plus difficiles.',
      parties: [
        'Partie I – Analyse fonctionnelle',
        'Partie II – Séries et intégration',
        'Partie III – Probabilités',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2024 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2024EP1() {
    return Annale(
      id: 'int_2024_ep1',
      annee: 2024,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2024 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2024. '
          'Sujet combinant algèbre linéaire, géométrie et analyse, '
          'avec des questions en lien avec le programme du second degré.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Analyse'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/24-ep1.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/corrige_ep1_2024.pdf',
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2024_v1.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Matrices',
        'Géométrie dans l\'espace',
        'Dérivation',
        'Espaces vectoriels',
        'Endomorphismes',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2024 rappelle que ce concours '
          's\'adresse à des enseignants en exercice et attend une maîtrise solide '
          'des contenus du programme du secondaire et du supérieur proche. '
          'La barre d\'admissibilité reste modérée. '
          'Le jury encourage les candidats à s\'appuyer sur leur pratique '
          'pédagogique pour éclairer leurs réponses.',
      parties: [
        'Partie I – Algèbre linéaire et applications',
        'Partie II – Analyse et géométrie',
        'Partie III – Problème',
      ],
    );
  }

  static Annale _int2024EP2() {
    return Annale(
      id: 'int_2024_ep2',
      annee: 2024,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2024 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2024, '
          'portant sur l\'analyse, les probabilités et l\'algèbre '
          'avec une composante didactique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Algèbre'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/24-ep2.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/corrige_ep2_2024.pdf',
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2024_v1.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Séries numériques',
        'Lois de probabilité',
        'Anneaux',
        'Suites récurrentes',
        'Espérance conditionnelle',
      ],
      rapportGlobal:
          'Le jury constate que l\'épreuve 2 de l\'agrégation interne 2024 '
          'a été abordée de façon inégale par les candidats. '
          'Les questions d\'analyse sont globalement mieux traitées que celles '
          'de probabilités. Le concours s\'adressant à des enseignants titulaires, '
          'le jury attend une rigueur et une clarté de rédaction exemplaires.',
      parties: [
        'Partie I – Analyse et suites',
        'Partie II – Probabilités et dénombrement',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2023 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2023MG() {
    return Annale(
      id: 'ext_2023_mg',
      annee: 2023,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2023 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales portant sur l\'algèbre, '
          'la théorie des nombres et la géométrie. '
          'Les parties couvrent des thèmes classiques du programme.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Arithmétique', 'Géométrie'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg23.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2023/MG2023_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2023.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Anneaux et corps',
        'Polynômes',
        'Théorie de Galois',
        'Arithmétique des entiers',
        'Algèbre linéaire',
      ],
      rapportGlobal:
          'Le rapport du jury 2023 insiste sur la nécessité de connaître les résultats '
          'fondamentaux d\'algèbre (structures, polynômes, algèbre linéaire). '
          'La barre d\'admissibilité se situe aux alentours de 5/20. '
          'Le jury déplore des lacunes fréquentes en rédaction mathématique et '
          'encourage les candidats à s\'entraîner sur les annales des années précédentes. '
          'Les premières questions, souvent accessibles, doivent être traitées avec soin.',
      parties: [
        'Partie I – Algèbre générale et polynômes',
        'Partie II – Arithmétique',
        'Partie III – Algèbre linéaire et réduction',
        'Partie IV – Applications géométriques',
      ],
    );
  }

  static Annale _ext2023AP() {
    return Annale(
      id: 'ext_2023_ap',
      annee: 2023,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2023 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités articulée autour de l\'analyse réelle, '
          'l\'analyse complexe et les probabilités discrètes et continues.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Analyse complexe'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap23.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2023/AP2023_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2023.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Suites et séries de fonctions',
        'Intégrale de Lebesgue',
        'Probabilités discrètes',
        'Chaînes de Markov',
        'Analyse complexe',
      ],
      rapportGlobal:
          'Le jury constate que les candidats les mieux préparés traitent correctement '
          'les questions de cours et les applications directes en analyse. '
          'En probabilités, les chaînes de Markov et le théorème central limite '
          'restent des points faibles récurrents. '
          'La barre d\'admissibilité avoisine 5/20. '
          'Le jury recommande une préparation équilibrée entre analyse et probabilités.',
      parties: [
        'Partie I – Analyse réelle et suites de fonctions',
        'Partie II – Analyse complexe',
        'Partie III – Probabilités et processus stochastiques',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2023 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2023EP1() {
    return Annale(
      id: 'int_2023_ep1',
      annee: 2023,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2023 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2023. '
          'Sujet articulé autour de l\'algèbre, de l\'analyse et de '
          'l\'arithmétique, en lien avec les programmes du secondaire.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Analyse', 'Arithmétique'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/23-ep1.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/corrige_ep1_2023.pdf',
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2023_v2.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Réduction des matrices',
        'Fonctions de variable réelle',
        'Congruences',
        'Valeurs propres',
        'Limites',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2023 souligne que le concours '
          'cible des enseignants titulaires souhaitant évoluer dans leur carrière. '
          'L\'épreuve 1 a permis d\'évaluer la maîtrise des fondamentaux '
          'd\'algèbre et d\'analyse. La barre d\'admissibilité se situe '
          'à un niveau modéré, reflétant l\'hétérogénéité des préparations.',
      parties: [
        'Partie I – Algèbre et arithmétique',
        'Partie II – Analyse',
        'Partie III – Géométrie et applications',
      ],
    );
  }

  static Annale _int2023EP2() {
    return Annale(
      id: 'int_2023_ep2',
      annee: 2023,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2023 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2023, '
          'mêlant géométrie, probabilités et analyse avec des questions '
          'à portée didactique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Géométrie', 'Probabilités', 'Analyse'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/23-ep2.pdf',
      urlCorrige:
          'https://interne.agreg.org/data/uploads/rapports/ep2_23_v21_corrige.pdf',
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2023_v2.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Barycentres',
        'Chaînes de Markov',
        'Intégrales généralisées',
        'Similitudes',
        'Loi des grands nombres',
      ],
      rapportGlobal:
          'Le jury note que l\'épreuve 2 de la session 2023 a été globalement '
          'mieux réussie que l\'épreuve 1. Les questions de géométrie plane '
          'et de probabilités élémentaires ont été correctement traitées '
          'par la majorité des candidats. Le concours interne s\'adressant '
          'à des enseignants en poste, la clarté de la rédaction est essentielle.',
      parties: [
        'Partie I – Géométrie et transformations',
        'Partie II – Probabilités et analyse',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2022 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2022MG() {
    return Annale(
      id: 'ext_2022_mg',
      annee: 2022,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2022 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet portant sur l\'algèbre linéaire, les formes quadratiques '
          'et la géométrie. Parties progressives avec des questions de synthèse '
          'en fin de sujet.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Algèbre bilinéaire'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg22.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2022/MG2022_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2022.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Formes quadratiques',
        'Endomorphismes symétriques',
        'Géométrie euclidienne',
        'Diagonalisation',
        'Dualité',
      ],
      rapportGlobal:
          'Le jury rappelle que la maîtrise de l\'algèbre linéaire est indispensable '
          'pour obtenir un score décent à cette épreuve. '
          'La barre d\'admissibilité est d\'environ 5/20. '
          'Trop de candidats négligent les hypothèses des théorèmes et commettent '
          'des erreurs de logique dans les démonstrations. '
          'Le jury encourage à travailler les exercices classiques de réduction '
          'et de formes bilinéaires.',
      parties: [
        'Partie I – Algèbre linéaire et dualité',
        'Partie II – Formes quadratiques',
        'Partie III – Géométrie euclidienne',
      ],
    );
  }

  static Annale _ext2022AP() {
    return Annale(
      id: 'ext_2022_ap',
      annee: 2022,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2022 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve couvrant l\'analyse réelle, les équations différentielles '
          'et les probabilités. Le sujet mêle théorie de la mesure et '
          'convergence de variables aléatoires.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Équations différentielles'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap22.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2022/AP2022_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2022.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Équations différentielles',
        'Théorie de la mesure',
        'Convergence en loi',
        'Espaces Lp',
        'Variables aléatoires',
      ],
      rapportGlobal:
          'Le jury observe que les candidats peinent souvent sur les questions '
          'de théorie de la mesure et d\'intégration. '
          'Les questions de probabilités, notamment sur la convergence, sont souvent '
          'mal traitées faute de connaissances précises du cours. '
          'La barre d\'admissibilité se situe autour de 5/20. '
          'Il est fortement recommandé de réviser les théorèmes de convergence dominée, '
          'monotone, et les inégalités classiques.',
      parties: [
        'Partie I – Analyse réelle et équations différentielles',
        'Partie II – Théorie de la mesure et intégration',
        'Partie III – Probabilités et convergence',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2022 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2022EP1() {
    return Annale(
      id: 'int_2022_ep1',
      annee: 2022,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2022 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2022. '
          'Sujet portant sur l\'algèbre linéaire, la géométrie et l\'analyse, '
          'avec des questions proches de l\'enseignement en classe.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Analyse'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/22-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2022.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Diagonalisation',
        'Isométries',
        'Compacité',
        'Déterminants',
        'Courbes paramétrées',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2022 observe que les candidats '
          'enseignants maîtrisent généralement bien les notions d\'algèbre linéaire '
          'de base mais peinent sur les questions plus abstraites. '
          'Le jury rappelle que le concours interne vise des professeurs en exercice '
          'et valorise la rigueur ainsi que la capacité à relier les notions au programme du secondaire.',
      parties: [
        'Partie I – Algèbre linéaire',
        'Partie II – Géométrie et analyse',
      ],
    );
  }

  static Annale _int2022EP2() {
    return Annale(
      id: 'int_2022_ep2',
      annee: 2022,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2022 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2022, '
          'couvrant analyse, probabilités et algèbre avec une dimension '
          'pédagogique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Algèbre'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/22-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2022.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Séries entières',
        'Probabilités conditionnelles',
        'Groupes',
        'Convergence uniforme',
        'Indépendance',
      ],
      rapportGlobal:
          'Le jury constate que l\'épreuve 2 de la session 2022 est de difficulté '
          'modérée. Les questions de probabilités conditionnelles et de séries '
          'ont été correctement traitées par les candidats les mieux préparés. '
          'Le concours interne s\'adresse à des enseignants titulaires ; '
          'le jury attend donc une rédaction soignée et une bonne culture mathématique.',
      parties: [
        'Partie I – Analyse et séries',
        'Partie II – Probabilités et algèbre',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2021 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2021MG() {
    return Annale(
      id: 'ext_2021_mg',
      annee: 2021,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2021 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales centré sur l\'algèbre (groupes, anneaux) '
          'et la géométrie projective et affine.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Topologie'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg21.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2021/MG2021_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2021.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Groupes et morphismes',
        'Anneaux principaux',
        'Géométrie projective',
        'Topologie générale',
        'Matrices et déterminants',
      ],
      rapportGlobal:
          'Le jury note une session marquée par le contexte sanitaire, '
          'mais la qualité attendue reste inchangée. '
          'La barre d\'admissibilité est d\'environ 5/20. '
          'Les candidats doivent impérativement maîtriser les structures algébriques '
          'de base (groupes, anneaux, corps) et savoir mobiliser les théorèmes '
          'fondamentaux. La rédaction doit être claire et les résultats admis '
          'doivent être explicitement signalés.',
      parties: [
        'Partie I – Structures algébriques',
        'Partie II – Algèbre linéaire avancée',
        'Partie III – Géométrie',
      ],
    );
  }

  static Annale _ext2021AP() {
    return Annale(
      id: 'ext_2021_ap',
      annee: 2021,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2021 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve portant sur l\'analyse fonctionnelle, les séries entières '
          'et les probabilités continues. Sujet articulé autour de problèmes '
          'classiques avec des questions progressives.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Topologie'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap21.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2021/AP2021_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2021.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Séries entières',
        'Espaces de Banach',
        'Loi des grands nombres',
        'Transformée de Fourier',
        'Calcul intégral',
      ],
      rapportGlobal:
          'Le jury constate que l\'analyse fonctionnelle reste un point faible '
          'pour de nombreux candidats. Les résultats sur les espaces de Banach '
          'et de Hilbert doivent être parfaitement maîtrisés. '
          'En probabilités, les candidats confondent souvent les différents modes '
          'de convergence. La barre d\'admissibilité est d\'environ 5/20. '
          'Le jury recommande de s\'entraîner régulièrement sur des sujets complets.',
      parties: [
        'Partie I – Analyse fonctionnelle',
        'Partie II – Séries et développements',
        'Partie III – Probabilités continues',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2021 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2021EP1() {
    return Annale(
      id: 'int_2021_ep1',
      annee: 2021,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2021 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2021. '
          'Session marquée par le contexte sanitaire. Le sujet porte '
          'sur l\'algèbre, l\'analyse et la géométrie.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Analyse', 'Géométrie'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/21-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2021.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Polynômes',
        'Équations différentielles',
        'Géométrie affine',
        'Fractions rationnelles',
        'Théorème des valeurs intermédiaires',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2021, dans un contexte sanitaire '
          'encore difficile, note que les candidats enseignants ont fait preuve '
          'd\'une bonne volonté malgré des conditions de préparation compliquées. '
          'Les questions de base en algèbre et analyse ont été globalement bien traitées. '
          'Le jury rappelle que le concours vise à valoriser l\'expérience professionnelle '
          'et la maîtrise des contenus enseignés.',
      parties: [
        'Partie I – Algèbre',
        'Partie II – Analyse et géométrie',
      ],
    );
  }

  static Annale _int2021EP2() {
    return Annale(
      id: 'int_2021_ep2',
      annee: 2021,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2021 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2021, '
          'portant sur les probabilités, l\'analyse et l\'arithmétique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Probabilités', 'Analyse', 'Arithmétique'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/21-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2021.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Variables aléatoires discrètes',
        'Intégration',
        'Arithmétique des entiers',
        'Fonctions génératrices',
        'PGCD et PPCM',
      ],
      rapportGlobal:
          'Le jury observe que la partie probabilités de l\'épreuve 2 a été '
          'mieux abordée que les années précédentes. Les questions d\'arithmétique '
          'restent un point faible pour de nombreux candidats. '
          'Le concours interne cible des enseignants en exercice et le jury '
          'apprécie les réponses qui font le lien avec la pratique de classe.',
      parties: [
        'Partie I – Probabilités et dénombrement',
        'Partie II – Analyse et arithmétique',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2020 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2020MG() {
    return Annale(
      id: 'ext_2020_mg',
      annee: 2020,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2020 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales. Session perturbée par la crise sanitaire '
          '(COVID-19) avec un calendrier décalé. Le sujet couvre algèbre et géométrie.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Algèbre linéaire'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg20.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2020/MG2020_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2020.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Espaces vectoriels',
        'Représentations de groupes',
        'Géométrie affine',
        'Polynômes et fractions rationnelles',
        'Isométries',
      ],
      rapportGlobal:
          'Session 2020 fortement impactée par la crise sanitaire : épreuves décalées '
          'et conditions de préparation difficiles pour les candidats. '
          'Malgré ce contexte, le jury maintient ses exigences de rigueur. '
          'La barre d\'admissibilité est d\'environ 5/20. '
          'Le jury rappelle l\'importance de bien gérer son temps sur 6 heures '
          'et de prioriser les questions accessibles.',
      parties: [
        'Partie I – Algèbre linéaire',
        'Partie II – Algèbre et structures',
        'Partie III – Géométrie affine et euclidienne',
      ],
    );
  }

  static Annale _ext2020AP() {
    return Annale(
      id: 'ext_2020_ap',
      annee: 2020,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2020 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités de la session 2020 (décalée). '
          'Le sujet traite d\'analyse réelle, de calcul différentiel '
          'et de probabilités.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Calcul différentiel'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap20.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2020/AP2020_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2020.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Calcul différentiel',
        'Fonctions de plusieurs variables',
        'Mesure et intégration',
        'Martingales',
        'Probabilités discrètes',
      ],
      rapportGlobal:
          'Malgré le contexte sanitaire, le sujet conserve le niveau habituel. '
          'Le jury observe que le calcul différentiel et les fonctions de plusieurs '
          'variables restent mal maîtrisés par une majorité de candidats. '
          'En probabilités, la manipulation des espérances conditionnelles '
          'pose des difficultés récurrentes. La barre d\'admissibilité est '
          'd\'environ 5/20. Le jury conseille de travailler les classiques du cours.',
      parties: [
        'Partie I – Analyse réelle et calcul différentiel',
        'Partie II – Intégration et espaces fonctionnels',
        'Partie III – Probabilités',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2020 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2020EP1() {
    return Annale(
      id: 'int_2020_ep1',
      annee: 2020,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2020 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2020. '
          'Session impactée par la crise sanitaire. Le sujet couvre '
          'algèbre, géométrie et analyse.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Analyse'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/20-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2020.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Espaces euclidiens',
        'Coniques',
        'Suites et séries',
        'Formes bilinéaires',
        'Topologie de R',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2020 note que la crise sanitaire '
          'a impacté les conditions de préparation des candidats enseignants. '
          'Le sujet est resté de niveau habituel. Les questions de géométrie '
          'et d\'algèbre linéaire élémentaire ont été correctement abordées. '
          'Le jury rappelle que le concours interne valorise l\'expérience professionnelle.',
      parties: [
        'Partie I – Algèbre et géométrie',
        'Partie II – Analyse',
        'Partie III – Applications',
      ],
    );
  }

  static Annale _int2020EP2() {
    return Annale(
      id: 'int_2020_ep2',
      annee: 2020,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2020 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2020, '
          'portant sur l\'analyse, les probabilités et l\'algèbre.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Algèbre'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/20-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2020.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Fonctions de plusieurs variables',
        'Lois continues',
        'Matrices symétriques',
        'Dérivées partielles',
        'Espérance',
      ],
      rapportGlobal:
          'Le jury observe que l\'épreuve 2 de la session 2020 a été '
          'de difficulté modérée. Les candidats enseignants titulaires ont '
          'généralement bien traité les questions de probabilités élémentaires. '
          'L\'analyse reste le domaine le mieux maîtrisé. '
          'Le jury encourage les candidats à approfondir les probabilités continues.',
      parties: [
        'Partie I – Analyse',
        'Partie II – Probabilités et algèbre',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2019 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2019MG() {
    return Annale(
      id: 'ext_2019_mg',
      annee: 2019,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2019 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales mêlant algèbre commutative, '
          'algèbre linéaire et géométrie. Plusieurs parties indépendantes '
          'permettent d\'aborder le sujet par différents angles.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Arithmétique'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg19.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2019/MG2019_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2019.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Algèbre commutative',
        'Modules',
        'Réduction des endomorphismes',
        'Coniques et quadriques',
        'Arithmétique modulaire',
      ],
      rapportGlobal:
          'Le jury note que les candidats ayant une bonne maîtrise de l\'algèbre '
          'commutative et de la réduction ont pu traiter une part significative du sujet. '
          'La barre d\'admissibilité avoisine 5/20. '
          'Les erreurs les plus fréquentes concernent l\'utilisation incorrecte '
          'des théorèmes de factorisation et la confusion entre les différentes '
          'notions de réductibilité. Le jury encourage à travailler les exemples concrets.',
      parties: [
        'Partie I – Algèbre commutative',
        'Partie II – Algèbre linéaire et réduction',
        'Partie III – Géométrie des coniques',
        'Partie IV – Applications arithmétiques',
      ],
    );
  }

  static Annale _ext2019AP() {
    return Annale(
      id: 'ext_2019_ap',
      annee: 2019,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2019 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités couvrant les séries de Fourier, '
          'l\'analyse hilbertienne et les probabilités.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Analyse hilbertienne'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap19.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2019/AP2019_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2019.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Séries de Fourier',
        'Espaces de Hilbert',
        'Distributions',
        'Loi des grands nombres',
        'Convergence en probabilité',
      ],
      rapportGlobal:
          'Le jury constate que les séries de Fourier et l\'analyse hilbertienne '
          'sont globalement mieux traitées que les probabilités. '
          'La barre d\'admissibilité est d\'environ 5/20. '
          'Les candidats doivent veiller à justifier rigoureusement les interversions '
          'de limites et les passages à la limite sous le signe intégral. '
          'En probabilités, la connaissance précise des hypothèses des grands théorèmes '
          '(LGN, TCL) est indispensable.',
      parties: [
        'Partie I – Séries de Fourier et analyse harmonique',
        'Partie II – Analyse hilbertienne',
        'Partie III – Probabilités et statistiques',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2019 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2019EP1() {
    return Annale(
      id: 'int_2019_ep1',
      annee: 2019,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2019 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2019. '
          'Sujet couvrant l\'algèbre, l\'analyse et la géométrie, '
          'avec des questions proches du programme du lycée et du supérieur proche.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Analyse', 'Géométrie'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/19-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2019.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Théorie des groupes',
        'Suites numériques',
        'Transformations géométriques',
        'Sous-groupes',
        'Continuité uniforme',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2019 observe que les candidats '
          'enseignants ont globalement bien abordé les questions classiques '
          'd\'algèbre et de géométrie. Les questions d\'analyse plus avancées '
          'ont été moins bien traitées. Le jury rappelle que le concours cible '
          'des professeurs titulaires et valorise la capacité à relier théorie et pratique.',
      parties: [
        'Partie I – Algèbre',
        'Partie II – Analyse',
        'Partie III – Géométrie',
      ],
    );
  }

  static Annale _int2019EP2() {
    return Annale(
      id: 'int_2019_ep2',
      annee: 2019,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2019 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2019, '
          'mêlant probabilités, analyse et arithmétique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Probabilités', 'Analyse', 'Arithmétique'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/19-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2019.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Dénombrement',
        'Séries de Fourier',
        'Nombres premiers',
        'Urnes',
        'Développements limités',
      ],
      rapportGlobal:
          'Le jury note que l\'épreuve 2 de la session 2019 est bien équilibrée '
          'entre probabilités et analyse. Les questions d\'arithmétique '
          'ont posé des difficultés à de nombreux candidats. '
          'Le concours interne s\'adressant à des enseignants en poste, '
          'le jury apprécie particulièrement les réponses claires et structurées.',
      parties: [
        'Partie I – Probabilités',
        'Partie II – Analyse et arithmétique',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2018 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2018MG() {
    return Annale(
      id: 'ext_2018_mg',
      annee: 2018,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2018 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales articulé autour de l\'algèbre linéaire, '
          'la théorie des groupes et la géométrie euclidienne.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Géométrie', 'Théorie des groupes'],
      urlSujet: 'https://old.agreg.org/sujets/MG18.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2018/MG2018_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2018.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Théorie des groupes',
        'Actions de groupes',
        'Théorèmes de Sylow',
        'Espaces euclidiens',
        'Géométrie des transformations',
      ],
      rapportGlobal:
          'Le jury observe que les théorèmes de Sylow et les actions de groupes '
          'sont souvent mal utilisés par les candidats. '
          'La barre d\'admissibilité se situe autour de 5/20. '
          'Les questions de géométrie euclidienne, pourtant classiques, '
          'sont fréquemment délaissées. Le jury recommande de ne pas faire '
          'l\'impasse sur la géométrie et de bien connaître les isométries '
          'du plan et de l\'espace.',
      parties: [
        'Partie I – Théorie des groupes',
        'Partie II – Algèbre linéaire',
        'Partie III – Géométrie euclidienne',
        'Partie IV – Synthèse',
      ],
    );
  }

  static Annale _ext2018AP() {
    return Annale(
      id: 'ext_2018_ap',
      annee: 2018,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2018 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve portant sur l\'analyse réelle et complexe, les espaces fonctionnels '
          'et les probabilités. Le sujet propose des questions progressives '
          'allant du cours aux applications.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Analyse complexe'],
      urlSujet: 'https://old.agreg.org/sujets/AP18.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2018/AP2018_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2018.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Difficile',
      motsClefs: [
        'Fonctions holomorphes',
        'Résidus',
        'Espaces Lp',
        'Processus de Poisson',
        'Théorème de convergence dominée',
      ],
      rapportGlobal:
          'Le jury constate que l\'analyse complexe (fonctions holomorphes, résidus) '
          'est un domaine où les candidats bien préparés peuvent faire la différence. '
          'Les espaces Lp et leurs propriétés restent une source d\'erreurs fréquentes. '
          'La barre d\'admissibilité se situe autour de 5/20. '
          'Le jury insiste sur l\'importance de connaître les contre-exemples classiques '
          'et de savoir vérifier les hypothèses des théorèmes utilisés.',
      parties: [
        'Partie I – Analyse réelle',
        'Partie II – Analyse complexe',
        'Partie III – Probabilités et processus',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2018 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2018EP1() {
    return Annale(
      id: 'int_2018_ep1',
      annee: 2018,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2018 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2018. '
          'Sujet portant sur l\'algèbre linéaire, la géométrie euclidienne '
          'et l\'analyse, avec des questions en lien avec le programme du secondaire.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Analyse'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/18-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2018.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Réduction des endomorphismes',
        'Géométrie euclidienne',
        'Calcul intégral',
        'Trigonalisation',
        'Courbes',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2018 note que les candidats '
          'enseignants maîtrisent correctement les fondamentaux d\'algèbre linéaire. '
          'Les questions de géométrie euclidienne ont été bien abordées dans l\'ensemble. '
          'Le jury rappelle que ce concours s\'adresse à des professeurs titulaires '
          'et valorise la clarté de la rédaction et la rigueur des démonstrations.',
      parties: [
        'Partie I – Algèbre linéaire et réduction',
        'Partie II – Géométrie',
        'Partie III – Analyse',
      ],
    );
  }

  static Annale _int2018EP2() {
    return Annale(
      id: 'int_2018_ep2',
      annee: 2018,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2018 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2018, '
          'couvrant analyse, probabilités et algèbre.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Algèbre'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/18-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2018.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Fonctions holomorphes',
        'Marches aléatoires',
        'Anneaux de polynômes',
        'Séries de Laurent',
        'Simulation',
      ],
      rapportGlobal:
          'Le jury constate que l\'épreuve 2 de la session 2018 a été '
          'de difficulté modérée. Les questions de probabilités élémentaires '
          'ont été globalement bien traitées. L\'analyse reste le point fort '
          'de la majorité des candidats enseignants. Le concours interne '
          'attend une rédaction exemplaire, en particulier pour les démonstrations.',
      parties: [
        'Partie I – Analyse',
        'Partie II – Probabilités et algèbre',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2017 – EXTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _ext2017MG() {
    return Annale(
      id: 'ext_2017_mg',
      annee: 2017,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2017 – Épreuve 1 : Mathématiques générales',
      description:
          'Sujet de mathématiques générales portant sur l\'algèbre linéaire avancée, '
          'les formes bilinéaires et la géométrie. Sujet réputé exigeant.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Algèbre bilinéaire'],
      urlSujet: 'https://old.agreg.org/sujets/MG17.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2017/MG2017_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2017.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Très difficile',
      motsClefs: [
        'Formes bilinéaires symétriques',
        'Signature',
        'Classification des quadriques',
        'Endomorphismes normaux',
        'Décomposition spectrale',
      ],
      rapportGlobal:
          'Le jury note que le sujet 2017 est d\'un niveau élevé et que '
          'peu de candidats ont pu traiter l\'intégralité des questions. '
          'La barre d\'admissibilité se situe autour de 4-5/20. '
          'Les formes bilinéaires et la classification des quadriques '
          'sont des thèmes qui nécessitent une préparation approfondie. '
          'Le jury conseille de bien maîtriser les résultats de base avant '
          'd\'aborder les questions de synthèse en fin de partie.',
      parties: [
        'Partie I – Algèbre bilinéaire et formes quadratiques',
        'Partie II – Réduction et endomorphismes',
        'Partie III – Géométrie des quadriques',
      ],
    );
  }

  static Annale _ext2017AP() {
    return Annale(
      id: 'ext_2017_ap',
      annee: 2017,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2017 – Épreuve 2 : Analyse et probabilités',
      description:
          'Épreuve d\'analyse et probabilités couvrant les séries, '
          'l\'intégration, les équations différentielles et les probabilités. '
          'Sujet exigeant avec des questions de cours et des problèmes ouverts.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Équations différentielles'],
      urlSujet: 'https://old.agreg.org/sujets/AP17.pdf',
      urlCorrige:
          'https://www.vmaths.fr/wp-content/uploads/annales_agreg/2017/AP2017_corrige.pdf',
      urlRapport:
          'https://agreg.org/data/uploads/rapports/rapport_2017.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Très difficile',
      motsClefs: [
        'Séries numériques et entières',
        'Équations différentielles ordinaires',
        'Intégrale impropre',
        'Variables aléatoires continues',
        'Fonction caractéristique',
      ],
      rapportGlobal:
          'Le rapport du jury 2017 souligne la difficulté du sujet d\'analyse. '
          'Les équations différentielles et les séries entières sont les thèmes '
          'les mieux traités en moyenne. La partie probabilités reste le parent pauvre '
          'de nombreuses copies. La barre d\'admissibilité est d\'environ 4-5/20. '
          'Le jury insiste sur la nécessité de connaître les fonctions classiques '
          '(gamma, bêta, zêta) et leurs propriétés fondamentales.',
      parties: [
        'Partie I – Séries et analyse réelle',
        'Partie II – Équations différentielles',
        'Partie III – Intégration et fonctions spéciales',
        'Partie IV – Probabilités',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  2017 – INTERNE
  // ═══════════════════════════════════════════════════════════════════════════

  static Annale _int2017EP1() {
    return Annale(
      id: 'int_2017_ep1',
      annee: 2017,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2017 – Épreuve 1',
      description:
          'Première épreuve écrite de l\'agrégation interne 2017. '
          'Sujet portant sur l\'algèbre, l\'analyse et la géométrie, '
          'en lien avec les programmes de l\'enseignement secondaire.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Analyse', 'Géométrie'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep1/17-ep1.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2017.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Matrices et déterminants',
        'Fonctions convexes',
        'Géométrie plane',
        'Polynômes caractéristiques',
        'Extrema',
      ],
      rapportGlobal:
          'Le jury de l\'agrégation interne 2017 note que le sujet est '
          'de niveau classique, accessible aux candidats enseignants bien préparés. '
          'Les questions d\'algèbre linéaire et de géométrie plane ont été '
          'correctement traitées par la majorité des candidats. '
          'Le jury rappelle que le concours interne vise des professeurs en exercice '
          'et attend une rédaction claire et rigoureuse.',
      parties: [
        'Partie I – Algèbre et matrices',
        'Partie II – Analyse',
        'Partie III – Géométrie',
      ],
    );
  }

  static Annale _int2017EP2() {
    return Annale(
      id: 'int_2017_ep2',
      annee: 2017,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2017 – Épreuve 2',
      description:
          'Seconde épreuve écrite de l\'agrégation interne 2017, '
          'mêlant analyse, probabilités et arithmétique.',
      exercices: const [],
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse', 'Probabilités', 'Arithmétique'],
      urlSujet:
          'https://interne.agreg.org/data/uploads/epreuves/ep2/17-ep2.pdf',
      urlCorrige: null,
      urlRapport:
          'https://interne.agreg.org/data/uploads/rapports/ai2017.pdf',
      urlOfficielle: 'https://www.devenirenseignant.gouv.fr',
      difficulte: 'Moyen',
      motsClefs: [
        'Suites récurrentes',
        'Probabilités finies',
        'Division euclidienne',
        'Convergence',
        'Dénombrement',
      ],
      rapportGlobal:
          'Le jury observe que l\'épreuve 2 de la session 2017 a été '
          'bien équilibrée. Les questions de probabilités discrètes et '
          'd\'analyse élémentaire ont été correctement abordées. '
          'L\'arithmétique reste un domaine où les candidats enseignants '
          'gagneraient à approfondir leurs connaissances. '
          'Le jury valorise les réponses faisant le lien avec la pratique pédagogique.',
      parties: [
        'Partie I – Analyse et suites',
        'Partie II – Probabilités et arithmétique',
      ],
    );
  }
}
