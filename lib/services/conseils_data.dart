/// Conseils et retours d'expérience pour réussir l'agrégation de mathématiques.
/// Synthèse des rapports de jury, retours de candidats admis, et bonnes pratiques.
library;

class ConseilCategorie {
  final String id;
  final String titre;
  final String icone; // Material icon name
  final String description;
  final List<ConseilItem> conseils;

  const ConseilCategorie({
    required this.id,
    required this.titre,
    required this.icone,
    required this.description,
    required this.conseils,
  });
}

class ConseilItem {
  final String titre;
  final String contenu;
  final String? source; // "Rapport du jury 2024", "Candidat admis", etc.
  final int importance; // 1-3 (3 = crucial)
  final List<String> tags;

  const ConseilItem({
    required this.titre,
    required this.contenu,
    this.source,
    this.importance = 2,
    this.tags = const [],
  });
}

class ConseilsData {
  // ============================================================================
  // PÉPITES DU JOUR — conseils courts et percutants pour la rotation quotidienne
  // ============================================================================
  static const List<String> pepitesDuJour = [
    // Organisation & planning
    'Maîtrisez parfaitement 2 développements par leçon : c\'est le minimum pour être serein le jour J.',
    'Travaillez les leçons par thème et non par numéro : cela crée des connexions profondes entre les sujets.',
    'Pratiquez au moins une simulation orale complète par semaine à partir de janvier.',
    'Révisez les contre-exemples classiques : le jury adore les candidats qui savent dire "non, et voici pourquoi".',
    'Relisez les rapports du jury des 3 dernières années : ils disent exactement ce qu\'ils attendent.',
    'Alternez algèbre et analyse chaque jour pour garder les deux frais en mémoire.',
    'Préparez 2-3 nouveaux développements par semaine, et révisez-en 5 anciens.',
    'Un développement bien maîtrisé vaut mieux que dix développements approximatifs.',
    'Faites un examen blanc complet (5h) au moins une fois par mois à partir de novembre.',
    'Chronométrez-vous systématiquement pour vos développements à l\'oral : 15 minutes, pas une de plus.',

    // Écrit
    'À l\'écrit, soignez la rédaction des 2-3 premières questions : elles donnent le ton pour le correcteur.',
    'Ne laissez jamais une question sans réponse à l\'écrit : même une idée partielle peut rapporter des points.',
    'Rédigez proprement : un brouillon clair vaut mieux qu\'une copie illisible avec les bonnes idées.',
    'À l\'écrit, commencez toujours par lire l\'intégralité du sujet avant d\'écrire quoi que ce soit.',
    'Identifiez les questions indépendantes dans le sujet : elles vous permettent de grappiller des points même si vous bloquez ailleurs.',
    'Les 30 dernières minutes de l\'écrit doivent être consacrées à la relecture et à la correction des erreurs de signe.',
    'Le jury valorise la clarté et la concision : une preuve en 5 lignes bien écrites vaut mieux qu\'une en 15 lignes confuses.',

    // Oral — leçon
    'Pour l\'oral : un plan structuré avec des exemples vaut mieux qu\'un catalogue de théorèmes sans fil conducteur.',
    'Commencez votre leçon par un exemple motivant ou un problème concret. Le jury apprécie qu\'on donne du sens.',
    'Prévoyez toujours un exemple calculatoire dans chaque partie de votre leçon : le jury peut vous demander de le faire au tableau.',
    'Ne mettez dans votre plan que ce que vous êtes capable de démontrer si le jury le demande.',
    'La gestion du tableau est cruciale : numérotez vos théorèmes, effacez proprement, utilisez les couleurs.',
    'Si le jury pose une question et que vous ne savez pas, dites-le honnêtement plutôt que de broder.',
    'Préparez une phrase d\'introduction et de conclusion pour chaque leçon : elles encadrent votre propos.',
    'Les transitions entre les parties de votre leçon sont aussi importantes que le contenu : montrez la cohérence.',

    // Oral — développement
    'Choisissez un développement que vous maîtrisez parfaitement plutôt qu\'un développement impressionnant mais fragile.',
    'Votre développement doit être une démonstration complète, pas un survol : chaque étape doit être justifiée.',
    'Entraînez-vous à écrire votre développement debout, au tableau, avec la craie : c\'est très différent du papier.',
    'Ayez toujours un "plan B" pour votre développement : si le jury vous arrête, vous devez pouvoir rebondir.',

    // Jury & attitude
    'Le jury n\'est pas votre ennemi : il cherche à évaluer vos compétences, pas à vous piéger.',
    'Quand le jury vous pose une question, prenez 10 secondes pour réfléchir avant de répondre.',
    'Le jury apprécie l\'honnêteté : "je ne suis pas sûr, mais je pense que..." vaut mieux qu\'une affirmation fausse.',
    'Regardez les membres du jury quand vous parlez : l\'oral est aussi un exercice de communication.',
    'Ne vous effondrez pas après une question difficile : le jury teste votre résilience autant que vos connaissances.',
    'Si le jury vous guide vers la réponse, suivez ses indications : il veut vous aider à réussir.',

    // Motivation & mental
    'L\'agrégation est un marathon, pas un sprint : ménagez-vous des pauses et du repos.',
    'Formez un groupe de travail de 2-3 personnes : enseigner aux autres est la meilleure façon d\'apprendre.',
    'Ne comparez pas votre progression à celle des autres : chacun a son rythme.',
    'Les moments de découragement sont normaux : ils font partie du processus. Persévérez.',
    'Fêtez vos petites victoires : un développement maîtrisé, une leçon bouclée, un concept enfin compris.',
    'Le jour du concours, votre pire ennemi n\'est pas la difficulté du sujet, c\'est le stress. Apprenez à le gérer.',
    'Dormez suffisamment la veille des épreuves : un cerveau reposé performe 30% mieux qu\'un cerveau épuisé.',
    'Gardez une activité physique régulière pendant la préparation : elle améliore la concentration et réduit le stress.',

    // Stratégie
    'Constituez votre "valise" de livres dès janvier et entraînez-vous à y retrouver vos développements rapidement.',
    'Apprenez à reconnaître les "questions classiques" du jury : beaucoup reviennent d\'année en année.',
    'Connaissez les critères de notation : à l\'oral, le développement compte pour environ 1/3, la leçon pour 1/3, et les questions pour 1/3.',
    'Pour les leçons d\'algèbre, ayez toujours un exemple en dimension 2 ou 3 prêt à être calculé.',
    'Pour les leçons d\'analyse, ayez toujours un contre-exemple "pathologique" en réserve.',
    'Les leçons de probabilités sont souvent moins bien préparées par les candidats : c\'est une opportunité.',
    'Maîtrisez les "leçons passerelles" (ex: 153-154, 220-221) : elles permettent de recycler vos développements.',
    'Le rapport du jury le dit chaque année : "les candidats qui réussissent sont ceux qui ont des exemples concrets".',
    'Vérifiez que vos développements sont bien adaptés à la durée (15 min oral) : ni trop courts, ni trop longs.',
    'N\'oubliez jamais les applications : un théorème sans application est une coquille vide aux yeux du jury.',
  ];

  // ============================================================================
  // CATÉGORIES DE CONSEILS DÉTAILLÉS
  // ============================================================================
  static const List<ConseilCategorie> categories = [

    // ==========================================================================
    // 1. ORGANISATION & PLANNING
    // ==========================================================================
    ConseilCategorie(
      id: 'organisation',
      titre: 'Organisation & Planning',
      icone: 'calendar_today',
      description: 'Comment structurer votre année de préparation pour maximiser vos chances.',
      conseils: [
        ConseilItem(
          titre: 'Le planning type d\'une année de préparation',
          contenu: 'Septembre-Novembre : Révision des fondamentaux. Reprendre les cours de L3/M1, consolider les bases en algèbre linéaire, analyse réelle, topologie. Objectif : pouvoir énoncer et démontrer les théorèmes fondamentaux.\n\n'
            'Décembre-Février : Construction des leçons et développements. Préparer 2-3 leçons par semaine, rédiger les développements associés. Commencer les simulations orales entre amis.\n\n'
            'Mars-Avril : Écrits. Se concentrer sur les annales, faire des examens blancs chronométrés. Au moins un sujet complet par semaine.\n\n'
            'Mai-Juin : Post-écrit, préparation oral. Revoir toutes les leçons, peaufiner les développements, multiplier les simulations orales (au moins 2 par semaine).\n\n'
            'Juin-Juillet : Oraux. Maintenir le rythme, réviser la valise, dormir suffisamment.',
          source: 'Synthèse des retours de candidats admis',
          importance: 3,
          tags: ['planning', 'organisation', 'année'],
        ),
        ConseilItem(
          titre: 'La règle des "2-2-2"',
          contenu: 'Chaque semaine, visez :\n'
            '• 2 nouvelles leçons préparées (plan + développements)\n'
            '• 2 développements complètement rédigés et maîtrisés\n'
            '• 2 anciens développements révisés\n\n'
            'Ce rythme vous permet d\'avoir couvert l\'essentiel des leçons en 6 mois, avec une base solide de 50+ développements maîtrisés.',
          source: 'Candidats admis en rang utile',
          importance: 3,
          tags: ['rythme', 'développements', 'leçons'],
        ),
        ConseilItem(
          titre: 'Le carnet de bord',
          contenu: 'Tenez un carnet (papier ou numérique) où vous notez chaque jour :\n'
            '• Ce que vous avez travaillé\n'
            '• Les points à revoir\n'
            '• Les idées de connexions entre leçons\n'
            '• Les erreurs commises\n\n'
            'Ce carnet est précieux pour identifier vos lacunes et mesurer votre progression. Relisez-le chaque dimanche pour planifier la semaine suivante.',
          importance: 2,
          tags: ['organisation', 'suivi'],
        ),
        ConseilItem(
          titre: 'Groupe de travail : le bon format',
          contenu: 'Le groupe idéal : 2 à 4 personnes, se réunissant 2-3 fois par semaine.\n\n'
            'Format efficace pour l\'oral :\n'
            '• Tirage au sort de 2 leçons\n'
            '• 30 min de préparation\n'
            '• 15 min de développement au tableau\n'
            '• 25 min de leçon\n'
            '• 10 min de questions "jury"\n\n'
            'Les autres membres jouent le rôle du jury et posent des questions. Tournez les rôles. C\'est la méthode la plus efficace pour progresser à l\'oral.',
          source: 'Rapport du jury — recommandation récurrente',
          importance: 3,
          tags: ['groupe', 'oral', 'simulation'],
        ),
        ConseilItem(
          titre: 'Gestion du temps au quotidien',
          contenu: 'Technique Pomodoro adaptée à l\'agrégation :\n'
            '• 50 min de travail intensif (une leçon, un développement, des exercices)\n'
            '• 10 min de pause active (marche, étirements)\n'
            '• Après 4 cycles, pause longue de 30 min\n\n'
            'Visez 6 à 8 heures de travail effectif par jour. Au-delà, la qualité baisse fortement. Le sommeil (7-8h) est non négociable : c\'est pendant le sommeil que la mémoire se consolide.',
          importance: 2,
          tags: ['temps', 'productivité', 'santé'],
        ),
      ],
    ),

    // ==========================================================================
    // 2. ÉPREUVES ÉCRITES
    // ==========================================================================
    ConseilCategorie(
      id: 'ecrit',
      titre: 'Réussir l\'écrit',
      icone: 'edit_note',
      description: 'Stratégies et techniques pour maximiser votre score aux épreuves écrites.',
      conseils: [
        ConseilItem(
          titre: 'Les 30 premières minutes décisives',
          contenu: 'Quand vous recevez le sujet :\n'
            '1. Lisez TOUT le sujet en entier (15-20 min). Repérez la structure, les questions indépendantes, le fil conducteur.\n'
            '2. Identifiez les questions "cadeau" (applications directes du cours) et les questions difficiles.\n'
            '3. Estimez le temps par partie et planifiez votre copie.\n\n'
            'Cette phase de lecture est cruciale : elle vous évite de perdre du temps sur une question difficile alors que des points faciles vous attendent plus loin.',
          source: 'Rapport du jury 2023-2024',
          importance: 3,
          tags: ['écrit', 'stratégie', 'temps'],
        ),
        ConseilItem(
          titre: 'Rédaction : les attentes du jury',
          contenu: 'Le jury insiste chaque année sur ces points :\n\n'
            '• Écriture lisible et copie aérée. Un correcteur qui peine à lire votre copie ne cherchera pas à vous donner des points.\n'
            '• Hypothèses clairement énoncées avant chaque résultat.\n'
            '• Les "il est clair que" et "on vérifie aisément" sont à proscrire : justifiez chaque étape.\n'
            '• Numérotez vos questions comme dans le sujet.\n'
            '• Soulignez ou encadrez vos résultats.\n'
            '• Si vous utilisez un résultat d\'une question que vous n\'avez pas traitée, dites-le explicitement ("en admettant le résultat de la question 3.b").',
          source: 'Rapport du jury — mention récurrente',
          importance: 3,
          tags: ['rédaction', 'écrit', 'jury'],
        ),
        ConseilItem(
          titre: 'Stratégie de grappillage',
          contenu: 'L\'écrit de l\'agrégation est conçu pour que personne ne finisse tout. La stratégie gagnante :\n\n'
            '• Traitez d\'abord toutes les questions que vous savez faire (premier passage rapide).\n'
            '• Revenez ensuite sur les questions moyennement difficiles.\n'
            '• En dernier, tentez les questions difficiles.\n'
            '• Les questions de fin de partie sont souvent des applications des résultats précédents : même si vous n\'avez pas démontré ces résultats, utilisez-les.\n\n'
            'Un candidat qui traite correctement 60% d\'un sujet est déjà dans les bons rangs.',
          importance: 3,
          tags: ['écrit', 'stratégie', 'points'],
        ),
        ConseilItem(
          titre: 'Les erreurs qui coûtent cher',
          contenu: 'Erreurs les plus fréquentes relevées par le jury :\n\n'
            '• Erreurs de signe et d\'indice : relisez vos calculs !\n'
            '• Confondre les hypothèses (ouvert/fermé, borné/compact, continu/uniformément continu)\n'
            '• Inverser les quantificateurs (pour tout / il existe)\n'
            '• Utiliser un théorème sans vérifier ses hypothèses (convergence dominée sans domination, Fubini sans intégrabilité)\n'
            '• Oublier des cas particuliers (n=0, ensemble vide, dimension 1)\n'
            '• Affirmer un résultat faux avec assurance : c\'est pire que de ne rien écrire.\n\n'
            'Gardez 30 minutes en fin d\'épreuve pour une relecture minutieuse ciblée sur ces erreurs.',
          source: 'Rapports du jury 2020-2024',
          importance: 3,
          tags: ['erreurs', 'écrit', 'jury'],
        ),
        ConseilItem(
          titre: 'Entraînement efficace pour l\'écrit',
          contenu: 'Programme d\'entraînement recommandé :\n\n'
            '• De novembre à mars : 1 sujet d\'annale complet par semaine, en conditions réelles (5h, sans notes).\n'
            '• Après chaque sujet : auto-correction détaillée avec les rapports du jury. Identifiez les théorèmes et techniques récurrents.\n'
            '• Constituez une "fiche de techniques" par thème : intégration, algèbre linéaire, séries, etc.\n'
            '• Les sujets récents (2018-2024) sont les plus représentatifs du style actuel.\n'
            '• Variez externe et interne : les techniques se recoupent largement.',
          importance: 2,
          tags: ['entraînement', 'écrit', 'annales'],
        ),
      ],
    ),

    // ==========================================================================
    // 3. ORAL — LEÇONS
    // ==========================================================================
    ConseilCategorie(
      id: 'oral_lecon',
      titre: 'L\'oral : la leçon',
      icone: 'school',
      description: 'Comment préparer et présenter une leçon convaincante devant le jury.',
      conseils: [
        ConseilItem(
          titre: 'Structure d\'une leçon qui marche',
          contenu: 'Un plan qui fonctionne systématiquement :\n\n'
            '1. Introduction (2-3 min) : motivation, problème fondateur, contexte historique.\n'
            '2. Définitions et premiers exemples (5 min) : poser le cadre, donner des exemples concrets.\n'
            '3. Résultats fondamentaux (8-10 min) : théorèmes principaux avec au moins une preuve.\n'
            '4. Résultats avancés (5 min) : approfondissements, cas particuliers intéressants.\n'
            '5. Applications (5 min) : au moins 2 applications concrètes de domaines différents.\n\n'
            'Total : ~25 minutes. Le jury apprécie un plan équilibré qui va du simple au complexe.',
          source: 'Rapport du jury — structure recommandée',
          importance: 3,
          tags: ['oral', 'leçon', 'plan'],
        ),
        ConseilItem(
          titre: 'Le choix des 2 leçons',
          contenu: 'Le jour de l\'oral, vous tirez 2 leçons et en choisissez une. Critères de choix :\n\n'
            '• Choisissez la leçon pour laquelle vous avez le meilleur développement.\n'
            '• Préférez une leçon que vous avez déjà présentée en simulation plutôt qu\'une "plus belle" mais jamais testée.\n'
            '• Vérifiez que vous avez des exemples calculatoires prêts.\n'
            '• Évaluez les questions probables du jury : êtes-vous prêt ?\n\n'
            'Stratégie : constituez des "familles" de leçons qui partagent les mêmes développements (ex: 153/154, 209/230, 235/236). Cela maximise la couverture avec un nombre limité de développements.',
          source: 'Candidats admis',
          importance: 3,
          tags: ['oral', 'leçon', 'choix', 'stratégie'],
        ),
        ConseilItem(
          titre: 'Le tableau : votre meilleur allié',
          contenu: 'La gestion du tableau est un art que beaucoup de candidats négligent :\n\n'
            '• Divisez le tableau en 3 colonnes : plan (à gauche, permanent), développement en cours (centre), calculs auxiliaires (droite).\n'
            '• Écrivez GROS : le jury est à 3-4 mètres. Les indices doivent être lisibles.\n'
            '• Utilisez les couleurs : rouge pour les hypothèses, bleu pour les conclusions, vert pour les exemples.\n'
            '• N\'effacez jamais un résultat important : vous pourriez en avoir besoin pour les questions.\n'
            '• Entraînez-vous à écrire debout, avec la craie, en parlant en même temps.\n\n'
            'Le jour J, arrivez 5 minutes en avance pour repérer le tableau et préparer vos craies.',
          source: 'Retour de membres du jury',
          importance: 2,
          tags: ['oral', 'tableau', 'présentation'],
        ),
        ConseilItem(
          titre: 'Les exemples qui font la différence',
          contenu: 'Le rapport du jury le répète chaque année : "les candidats manquent d\'exemples".\n\n'
            'Pour chaque leçon, préparez :\n'
            '• Un exemple introductif simple et motivant\n'
            '• Un exemple calculatoire complet (matrice 3×3, série explicite, etc.)\n'
            '• Un contre-exemple pour les hypothèses des théorèmes\n'
            '• Une application à un autre domaine des maths (ou à la physique)\n\n'
            'Exemples qui impressionnent le jury :\n'
            '• Applications concrètes (Google PageRank pour Perron-Frobenius, codage pour les corps finis)\n'
            '• Liens entre algèbre et analyse (exponentielle de matrices)\n'
            '• Interprétations géométriques des résultats algébriques',
          source: 'Rapports du jury 2020-2024',
          importance: 3,
          tags: ['oral', 'exemples', 'jury'],
        ),
        ConseilItem(
          titre: 'Les leçons "pièges" et comment les éviter',
          contenu: 'Certaines leçons sont réputées difficiles. Voici comment les aborder :\n\n'
            '• Leçons de géométrie (170, 171) : Préparez des figures soignées et des calculs explicites. Le jury attend de la géométrie, pas juste de l\'algèbre linéaire.\n'
            '• Leçons de probabilités (264) : Maîtrisez les fondations (espaces de probabilité, v.a., convergences). Ne vous contentez pas de réciter des théorèmes.\n'
            '• Leçons "méthodes" (ex: "Exemples et applications de...") : Le piège est de faire un catalogue. Trouvez un fil conducteur.\n'
            '• Leçons transversales (ex: "Utilisation des séries...") : Montrez des applications variées, pas juste de l\'analyse.\n\n'
            'Règle d\'or : si une leçon vous semble "facile", c\'est probablement que vous n\'avez pas assez creusé.',
          source: 'Synthèse des rapports du jury',
          importance: 2,
          tags: ['oral', 'leçon', 'difficultés'],
        ),
      ],
    ),

    // ==========================================================================
    // 4. ORAL — DÉVELOPPEMENTS
    // ==========================================================================
    ConseilCategorie(
      id: 'oral_dev',
      titre: 'L\'oral : les développements',
      icone: 'bookmark',
      description: 'Choisir, préparer et présenter des développements efficaces.',
      conseils: [
        ConseilItem(
          titre: 'Combien de développements préparer ?',
          contenu: 'Objectif réaliste : 25 à 35 développements bien maîtrisés.\n\n'
            'Stratégie optimale :\n'
            '• Chaque développement doit servir pour au moins 2-3 leçons différentes.\n'
            '• Visez 2 développements disponibles par leçon (un d\'algèbre/analyse pure, un plus transversal).\n'
            '• Constituez une matrice "développements × leçons" pour identifier les trous.\n\n'
            'Qualité > quantité : il vaut mieux 25 développements parfaitement maîtrisés que 50 approximatifs. Le jury voit immédiatement si vous improvisez.',
          source: 'Candidats admis dans les 100 premiers',
          importance: 3,
          tags: ['développements', 'oral', 'stratégie'],
        ),
        ConseilItem(
          titre: 'Les critères d\'un bon développement',
          contenu: 'Un développement idéal pour l\'agrégation :\n\n'
            '✓ Durée : 12-15 minutes (ni plus, ni moins)\n'
            '✓ Niveau : suffisamment technique pour montrer votre maîtrise, mais pas trop pour ne pas s\'y perdre\n'
            '✓ Complet : une démonstration du début à la fin, pas un survol\n'
            '✓ Illustratif : il doit éclairer un aspect important de la leçon\n'
            '✓ Générateur de questions : le jury doit pouvoir rebondir dessus\n\n'
            '✗ À éviter :\n'
            '✗ Un calcul long et technique sans idée mathématique\n'
            '✗ Un résultat trop difficile (risque de ne pas finir ou de faire des erreurs)\n'
            '✗ Un résultat trop simple (ne montre pas votre niveau)',
          source: 'Rapport du jury',
          importance: 3,
          tags: ['développements', 'critères', 'oral'],
        ),
        ConseilItem(
          titre: 'La technique du "développement-parachute"',
          contenu: 'Ayez toujours 3-4 développements "passe-partout" ultra-maîtrisés qui se placent dans de nombreuses leçons :\n\n'
            'Exemples classiques :\n'
            '• Théorèmes de Sylow (se place dans 5+ leçons d\'algèbre)\n'
            '• Théorème de Stone-Weierstrass (4+ leçons d\'analyse)\n'
            '• Décomposition polaire / spectrale (4+ leçons)\n'
            '• Formule de Stirling (3+ leçons)\n'
            '• Théorème de Cauchy-Lipschitz (3+ leçons)\n\n'
            'Ces développements sont votre filet de sécurité si vous tombez sur une combinaison de leçons défavorable.',
          source: 'Stratégie de candidats admis',
          importance: 2,
          tags: ['développements', 'stratégie', 'oral'],
        ),
        ConseilItem(
          titre: 'S\'entraîner au développement',
          contenu: 'Méthode d\'entraînement progressive :\n\n'
            '1. Rédiger le développement proprement sur papier (2-3 pages max).\n'
            '2. Le relire et le comprendre profondément (pas le mémoriser !). Identifier l\'idée clé de chaque étape.\n'
            '3. Le présenter au tableau de mémoire, sans notes. Chronomètre.\n'
            '4. Après une semaine, le refaire au tableau sans avoir relu vos notes.\n'
            '5. Après un mois, même exercice. Si ça passe, il est maîtrisé.\n\n'
            'Test ultime : pouvez-vous l\'expliquer à quelqu\'un qui ne connaît pas le sujet ? Si oui, vous le maîtrisez vraiment.',
          importance: 2,
          tags: ['développements', 'entraînement', 'méthode'],
        ),
      ],
    ),

    // ==========================================================================
    // 5. FACE AU JURY
    // ==========================================================================
    ConseilCategorie(
      id: 'jury',
      titre: 'Face au jury',
      icone: 'groups',
      description: 'Comment gérer les questions du jury et l\'interaction orale.',
      conseils: [
        ConseilItem(
          titre: 'Les types de questions du jury',
          contenu: 'Le jury pose plusieurs types de questions, adaptez votre réponse :\n\n'
            '1. Questions de cours : "Pouvez-vous énoncer le théorème de..." → Réponse claire et précise. Si vous hésitez sur un détail, dites-le.\n\n'
            '2. Questions de compréhension : "Pourquoi avez-vous besoin de cette hypothèse ?" → Donnez un contre-exemple sans cette hypothèse.\n\n'
            '3. Questions calculatoires : "Pouvez-vous appliquer ce résultat à..." → Le jury veut voir que vous savez calculer, pas juste réciter.\n\n'
            '4. Questions d\'extension : "Que se passe-t-il si on remplace R par C ?" → Réfléchissez à voix haute. Le jury apprécie le raisonnement plus que la réponse.\n\n'
            '5. Questions de culture : "Connaissez-vous d\'autres exemples ?" → C\'est là que vos contre-exemples et applications font la différence.',
          source: 'Synthèse des rapports du jury',
          importance: 3,
          tags: ['jury', 'questions', 'oral'],
        ),
        ConseilItem(
          titre: 'Quand on ne sait pas répondre',
          contenu: 'C\'est normal de ne pas tout savoir. Ce qui compte, c\'est la manière de gérer :\n\n'
            '• "Je ne connais pas ce résultat, mais intuitivement je dirais que..." → Le jury apprécie l\'honnêteté et le raisonnement.\n'
            '• "Je pense que c\'est vrai, voici l\'idée de preuve que j\'aurais..." → Même une idée incomplète montre votre niveau.\n'
            '• "Je ne suis pas sûr, mais peut-on se ramener au cas...?" → Montrez que vous savez vous ramener à ce que vous connaissez.\n\n'
            'Ce qui est rédhibitoire :\n'
            '• Affirmer quelque chose de faux avec assurance\n'
            '• Rester muet sans rien tenter\n'
            '• Dire "je ne sais pas" sans réfléchir au moins 30 secondes',
          source: 'Retour de membres du jury',
          importance: 3,
          tags: ['jury', 'réponse', 'oral'],
        ),
        ConseilItem(
          titre: 'Le langage corporel',
          contenu: 'L\'oral est un exercice de communication autant que de mathématiques :\n\n'
            '• Tenez-vous droit, face au jury (pas face au tableau).\n'
            '• Écrivez de côté pour ne pas tourner le dos au jury.\n'
            '• Regardez les membres du jury quand vous expliquez un point important.\n'
            '• Parlez fort et articulez : la salle est grande.\n'
            '• Respirez. Faites des pauses. Le silence n\'est pas votre ennemi.\n'
            '• Souriez quand c\'est approprié : vous êtes passionné par les maths, montrez-le !\n\n'
            'Exercice : présentez un développement devant un miroir ou filmez-vous. Vous serez surpris de vos tics.',
          importance: 2,
          tags: ['oral', 'communication', 'attitude'],
        ),
        ConseilItem(
          titre: 'Questions classiques récurrentes',
          contenu: 'Ces questions reviennent très souvent, préparez-les :\n\n'
            '• "Donnez un contre-exemple si on enlève l\'hypothèse X" (pour chaque théorème de votre plan)\n'
            '• "Quelle est la réciproque ? Est-elle vraie ?"\n'
            '• "Pouvez-vous faire le calcul dans un cas concret ?" (dimension 2 ou 3)\n'
            '• "Y a-t-il un lien avec [autre leçon] ?"\n'
            '• "Quel est le rôle de telle hypothèse dans la preuve ?"\n'
            '• "Connaissez-vous une application de ce résultat ?"\n'
            '• "Comment se généralise ce résultat en dimension infinie ?"\n\n'
            'Pour chaque théorème de votre plan, préparez les réponses à ces questions.',
          source: 'Rapports du jury et témoignages de candidats',
          importance: 3,
          tags: ['jury', 'questions', 'préparation'],
        ),
      ],
    ),

    // ==========================================================================
    // 6. MENTAL & BIEN-ÊTRE
    // ==========================================================================
    ConseilCategorie(
      id: 'mental',
      titre: 'Mental & Bien-être',
      icone: 'self_improvement',
      description: 'Gérer le stress, rester motivé et prendre soin de soi pendant la préparation.',
      conseils: [
        ConseilItem(
          titre: 'Le syndrome de l\'imposteur',
          contenu: 'Presque tous les candidats, y compris ceux qui réussissent brillamment, ressentent le syndrome de l\'imposteur :\n\n'
            '• "Je ne serai jamais prêt" → Personne ne l\'est totalement. L\'agrégation teste votre capacité à réagir, pas votre omniscience.\n'
            '• "Les autres sont bien meilleurs que moi" → Vous ne voyez que leur façade. Tout le monde doute.\n'
            '• "J\'aurais dû commencer plus tôt" → Le meilleur moment pour commencer, c\'est maintenant.\n\n'
            'Rappel : le taux de réussite est d\'environ 10-15%. Être admissible est déjà une réussite remarquable. Et chaque année de préparation, même sans succès, renforce considérablement vos compétences.',
          importance: 2,
          tags: ['mental', 'stress', 'motivation'],
        ),
        ConseilItem(
          titre: 'Gestion du stress le jour J',
          contenu: 'Techniques testées par des candidats admis :\n\n'
            'Avant l\'épreuve :\n'
            '• Préparez tout la veille (trajet, matériel, vêtements)\n'
            '• Dormez au moins 7h (même si vous ne dormez pas bien, reposez-vous)\n'
            '• Petit-déjeuner consistant, hydratation\n'
            '• Pas de révision de dernière minute le matin\n\n'
            'Pendant l\'épreuve :\n'
            '• Si le stress monte : 5 respirations profondes (inspirez 4s, bloquez 4s, expirez 6s)\n'
            '• Concentrez-vous sur la question en cours, pas sur le résultat final\n'
            '• Si vous bloquez : passez à la suite et revenez plus tard\n'
            '• Rappelez-vous : le stress modéré améliore la performance',
          source: 'Retours de candidats admis',
          importance: 3,
          tags: ['stress', 'jour J', 'mental'],
        ),
        ConseilItem(
          titre: 'L\'hygiène de vie du candidat',
          contenu: 'Votre cerveau est votre outil principal. Prenez-en soin :\n\n'
            '• Sommeil : 7-8h minimum. La mémoire se consolide pendant le sommeil profond.\n'
            '• Sport : 30 min d\'activité physique 3-4 fois par semaine. Ça améliore la concentration de 20-30%.\n'
            '• Alimentation : évitez les sucres rapides qui donnent des coups de fatigue. Privilégiez protéines, fruits secs, poisson.\n'
            '• Pauses : une vraie pause (sans écran) toutes les 2h. Marchez, regardez par la fenêtre.\n'
            '• Vie sociale : ne vous isolez pas complètement. Voir des amis, même non-mathématiciens, est essentiel.\n\n'
            'Un candidat épuisé et stressé avec 200h de travail sera moins performant qu\'un candidat reposé avec 150h.',
          importance: 2,
          tags: ['santé', 'bien-être', 'productivité'],
        ),
        ConseilItem(
          titre: 'Après un échec',
          contenu: 'Un échec à l\'agrégation n\'est pas une fin :\n\n'
            '• Beaucoup de candidats admis ont échoué une première fois (voire deux). L\'expérience accumulée est précieuse.\n'
            '• Analysez froidement vos résultats : où avez-vous perdu des points ? C\'est votre feuille de route pour l\'année suivante.\n'
            '• Les développements et leçons préparés restent. L\'année suivante, vous partez avec une longueur d\'avance considérable.\n'
            '• Demandez les copies et les notes détaillées si possible.\n'
            '• Parfois, un échec de justesse signifie que vous êtes à quelques points du succès. Persévérez.\n\n'
            'Statistique encourageante : parmi les candidats qui se présentent 2 fois, le taux d\'admission est nettement plus élevé la deuxième année.',
          importance: 2,
          tags: ['échec', 'motivation', 'résilience'],
        ),
      ],
    ),

    // ==========================================================================
    // 7. LA VALISE & LES LIVRES
    // ==========================================================================
    ConseilCategorie(
      id: 'valise',
      titre: 'La valise & les livres',
      icone: 'work',
      description: 'Constituer et maîtriser sa bibliothèque pour l\'oral.',
      conseils: [
        ConseilItem(
          titre: 'Constituer la valise optimale',
          contenu: 'Vous pouvez apporter un nombre limité de livres (généralement 4 à 6) à l\'oral. La sélection est cruciale :\n\n'
            'Configuration recommandée :\n'
            '• 1 livre d\'algèbre complet (Gourdon Algèbre)\n'
            '• 1 livre d\'analyse complet (Gourdon Analyse)\n'
            '• 1 livre de développements/oral (BMP ou équivalent)\n'
            '• 1 livre de géométrie (Audin ou Caldero-Germoni)\n'
            '• 1-2 livres complémentaires selon vos besoins\n\n'
            'Critères de choix :\n'
            '• Le livre doit contenir vos développements (avec les pages repérées)\n'
            '• Vous devez connaître le livre par cœur (savoir retrouver un résultat en < 30 secondes)\n'
            '• Préférez un livre que vous avez annoté et personnalisé',
          source: 'Candidats admis',
          importance: 3,
          tags: ['valise', 'livres', 'oral'],
        ),
        ConseilItem(
          titre: 'Comment utiliser ses livres le jour J',
          contenu: 'Pendant la préparation (3h avant l\'oral) :\n\n'
            '• Vous avez accès à vos livres pendant les 3h de préparation.\n'
            '• Ne perdez pas de temps à chercher : vous devez savoir exactement où se trouve chaque développement.\n'
            '• Utilisez des post-it colorés pour marquer les développements clés.\n'
            '• Préparez un index personnel collé à l\'intérieur de la couverture.\n\n'
            'Astuce : créez des marque-pages par leçon. Pour chaque leçon, un marque-page qui indique les pages de vos développements potentiels dans chaque livre.',
          importance: 2,
          tags: ['valise', 'préparation', 'jour J'],
        ),
        ConseilItem(
          titre: 'Annoter ses livres efficacement',
          contenu: 'Vos livres doivent être des outils de travail personnalisés :\n\n'
            '• Soulignez les hypothèses clés des théorèmes\n'
            '• Ajoutez dans la marge les numéros de leçons où le résultat se place\n'
            '• Notez les contre-exemples en face des théorèmes\n'
            '• Corrigez les coquilles (il y en a dans tous les livres)\n'
            '• Ajoutez des renvois entre les chapitres liés\n\n'
            'Attention : les annotations doivent être dans les livres eux-mêmes. Les feuilles volantes ne sont pas toujours autorisées.',
          source: 'Conseils de préparateurs',
          importance: 2,
          tags: ['livres', 'annotations', 'préparation'],
        ),
      ],
    ),

    // ==========================================================================
    // 8. ASTUCES DE CANDIDATS ADMIS
    // ==========================================================================
    ConseilCategorie(
      id: 'astuces',
      titre: 'Pépites de candidats admis',
      icone: 'emoji_events',
      description: 'Trucs et astuces partagés par ceux qui ont réussi.',
      conseils: [
        ConseilItem(
          titre: 'La technique du "fichier développement"',
          contenu: 'Créez pour chaque développement une fiche recto-verso :\n\n'
            'Recto :\n'
            '• Titre et leçons où il se place\n'
            '• Énoncé précis du résultat\n'
            '• Idée de la preuve en 3-4 lignes\n'
            '• Points délicats / pièges\n\n'
            'Verso :\n'
            '• Preuve complète et détaillée\n'
            '• Questions probables du jury et réponses\n'
            '• Référence(s) dans vos livres (page exacte)\n\n'
            'Révisez ces fiches comme des flashcards : le recto doit suffire pour reconstruire le verso.',
          source: 'Candidat admis rang 12',
          importance: 3,
          tags: ['fiches', 'développements', 'méthode'],
        ),
        ConseilItem(
          titre: 'La matrice de couverture',
          contenu: 'Construisez un tableau Excel/Google Sheets avec :\n'
            '• En lignes : les ~70 leçons du programme\n'
            '• En colonnes : vos développements (25-35)\n'
            '• Cochez les intersections\n\n'
            'Objectif : chaque leçon doit avoir au moins 2 développements cochés.\n\n'
            'Les leçons qui restent avec 0 ou 1 développement sont vos priorités de travail. C\'est le moyen le plus efficace d\'optimiser votre couverture.',
          source: 'Candidats admis — méthode récurrente',
          importance: 3,
          tags: ['stratégie', 'développements', 'couverture'],
        ),
        ConseilItem(
          titre: 'Le "Top 10" des développements les plus rentables',
          contenu: 'Ces développements se placent dans le plus grand nombre de leçons :\n\n'
            '1. Théorèmes de Sylow (5+ leçons)\n'
            '2. Théorème spectral / décomposition polaire (5+ leçons)\n'
            '3. Théorème de Cayley-Hamilton (4+ leçons)\n'
            '4. Théorème de Stone-Weierstrass (4+ leçons)\n'
            '5. Formule de Stirling (4+ leçons)\n'
            '6. Théorème de Cauchy-Lipschitz (3+ leçons)\n'
            '7. Théorème de Perron-Frobenius (3+ leçons)\n'
            '8. Simplicité de An (3+ leçons)\n'
            '9. Théorème de d\'Alembert-Gauss (3+ leçons)\n'
            '10. Théorème central limite (2-3 leçons)\n\n'
            'Maîtriser ces 10 développements vous assure une couverture minimale solide.',
          source: 'Analyse statistique des rapports du jury',
          importance: 3,
          tags: ['développements', 'top', 'rentabilité'],
        ),
        ConseilItem(
          titre: 'Optimiser les 3h de préparation',
          contenu: 'Vous disposez de 3h pour préparer votre leçon et votre développement :\n\n'
            'Planning type :\n'
            '• 0-10 min : Choisir la leçon et le développement. Décision ferme et définitive.\n'
            '• 10-40 min : Relire le développement dans votre livre, vérifier les détails.\n'
            '• 40-90 min : Rédiger le plan de la leçon. Structure, théorèmes, exemples.\n'
            '• 90-130 min : Préparer les exemples calculatoires et les preuves que vous pourriez présenter.\n'
            '• 130-160 min : Anticiper les questions du jury. Pour chaque théorème, préparer un contre-exemple.\n'
            '• 160-180 min : Relecture finale. Vérifier la cohérence du plan et la chronologie.\n\n'
            'Piège à éviter : passer trop de temps sur le développement au détriment du plan de leçon.',
          source: 'Candidats admis',
          importance: 3,
          tags: ['préparation', 'oral', '3h', 'planning'],
        ),
        ConseilItem(
          titre: 'Les derniers jours avant l\'oral',
          contenu: 'La semaine avant l\'oral :\n\n'
            '• J-7 à J-3 : Revoyez rapidement toutes vos fiches de développements. Identifiez ceux qui sont rouillés.\n'
            '• J-3 à J-1 : Faites 1-2 simulations orales complètes. Revoyez les développements fragiles.\n'
            '• J-1 : Préparez votre valise (livres, stylos, craies, bouteille d\'eau). Relisez votre index. PAS de nouveau développement.\n'
            '• Jour J matin : Petit-déjeuner léger. Pas de révision. Arrivez 30 min en avance.\n\n'
            'Le jour de l\'oral, votre mission n\'est plus d\'apprendre mais de restituer ce que vous savez avec clarté et confiance.',
          source: 'Retours de candidats admis',
          importance: 2,
          tags: ['derniers jours', 'oral', 'préparation'],
        ),
      ],
    ),
  ];

  /// Obtenir un conseil du jour basé sur la date (rotation sur toutes les pépites)
  static String getPepiteDuJour() {
    final now = DateTime.now();
    // Utiliser le jour de l'année pour une rotation sur 365 jours
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return pepitesDuJour[dayOfYear % pepitesDuJour.length];
  }

  /// Obtenir l'index du conseil du jour
  static int getPepiteIndex() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return dayOfYear % pepitesDuJour.length;
  }

  /// Rechercher dans les conseils
  static List<ConseilItem> rechercher(String query) {
    final q = query.toLowerCase();
    final results = <ConseilItem>[];
    for (final cat in categories) {
      for (final conseil in cat.conseils) {
        if (conseil.titre.toLowerCase().contains(q) ||
            conseil.contenu.toLowerCase().contains(q) ||
            conseil.tags.any((t) => t.contains(q))) {
          results.add(conseil);
        }
      }
    }
    return results;
  }
}
