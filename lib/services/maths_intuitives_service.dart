import 'package:flutter/foundation.dart';
import '../models/maths_intuitives_model.dart';

class MathsIntuitivesService extends ChangeNotifier {
  List<ConceptIntuitif> _concepts = [];
  List<CategorieIntuitive> _categories = [];
  
  List<ConceptIntuitif> get concepts => _concepts;
  List<CategorieIntuitive> get categories => _categories;
  
  Future<void> loadConcepts() async {
    _concepts = _createDemoConcepts();
    _categories = _createCategories();
    notifyListeners();
  }
  
  List<ConceptIntuitif> getConceptsByDomaine(String domaine) {
    return _concepts.where((c) => c.domaine == domaine).toList();
  }
  
  List<ConceptIntuitif> getConceptsByCategorie(String categorieNom) {
    final categorie = _categories.firstWhere((c) => c.nom == categorieNom);
    return _concepts.where((c) => categorie.conceptIds.contains(c.id)).toList();
  }
  
  ConceptIntuitif? getConceptById(String id) {
    try {
      return _concepts.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<CategorieIntuitive> _createCategories() {
    return [
      CategorieIntuitive(
        nom: 'Les Fondations',
        description: 'Les briques de base qui soutiennent toutes les maths',
        emoji: '🏗️',
        conceptIds: ['espaces-vectoriels', 'dimension', 'applications-lineaires', 'groupes'],
      ),
      CategorieIntuitive(
        nom: 'Voir l\'Invisible',
        description: 'Concepts pour comprendre l\'infini et le changement',
        emoji: '🔮',
        conceptIds: ['limite', 'continuite', 'derivabilite', 'integrale', 'series'],
      ),
      CategorieIntuitive(
        nom: 'Les Super-Pouvoirs',
        description: 'Théorèmes puissants qui résolvent tout',
        emoji: '⚡',
        conceptIds: ['valeurs-propres', 'diagonalisation', 'theoreme-spectral', 'fonction-implicite'],
      ),
      CategorieIntuitive(
        nom: 'Formes et Espaces',
        description: 'Géométrie moderne et abstraite',
        emoji: '🎨',
        conceptIds: ['produit-scalaire', 'orthogonalite', 'convexite', 'topologie'],
      ),
      CategorieIntuitive(
        nom: 'Le Hasard Apprivoisé',
        description: 'Comprendre l\'incertitude avec les probabilités',
        emoji: '🎲',
        conceptIds: ['esperance', 'variance', 'loi-normale', 'convergence-proba'],
      ),
    ];
  }
  
  List<ConceptIntuitif> _createDemoConcepts() {
    return [
      // ============ LES FONDATIONS ============
      
      ConceptIntuitif(
        id: 'espaces-vectoriels',
        titre: 'Espace Vectoriel',
        domaine: 'algèbre',
        niveauAgregation: 5,
        difficulteIntuitive: 2,
        analogieSimple: 'C\'est comme un immense terrain de jeu où tu peux te déplacer dans toutes les directions possibles.',
        questionCle: 'Comment décrire tous les déplacements possibles dans un univers ?',
        explicationIntuitive: '''Imagine que tu es dans un jeu vidéo. Tu peux te déplacer vers l'avant, l'arrière, la gauche, la droite, en haut, en bas... Un espace vectoriel, c'est exactement ça : un "monde" où tu peux te déplacer librement.

Les vecteurs sont comme des flèches qui indiquent des déplacements. Et la magie ? Tu peux combiner ces flèches ! Si tu vas 2 pas en avant puis 3 pas à droite, c'est comme si tu avais pris une nouvelle flèche directement vers ta destination finale.

L'idée géniale : au lieu de décrire tous les chemins possibles (il y en a une infinité !), on trouve quelques directions de base. Comme dans ton jeu : avant/arrière, gauche/droite, haut/bas. Avec juste ces 3 directions, tu peux atteindre N'IMPORTE QUEL point du jeu !''',
        exempleConcret: '''Les coordonnées GPS sont un espace vectoriel ! Pour localiser n'importe quel point sur Terre, tu n'as besoin que de 3 informations : latitude, longitude, altitude. Toute position est une combinaison de ces trois "directions de base".

Un autre exemple : les couleurs RGB sur ton écran. Rouge + Vert + Bleu = toutes les couleurs possibles ! C'est un espace vectoriel de dimension 3.''',
        lienAvecLycee: 'Tu connais déjà un espace vectoriel : le plan ! Avec les vecteurs i⃗ (horizontal) et j⃗ (vertical), tu peux atteindre n\'importe quel point. C\'est exactement le même principe, mais généralisé à plein d\'autres situations.',
        pourquoiCestImportant: '''C'est LA structure fondamentale de toutes les maths modernes ! 

• **En physique** : décrire les mouvements, les forces, les ondes
• **En informatique** : graphisme 3D, intelligence artificielle, compression d'images
• **En économie** : modéliser des portefeuilles d'actions
• **En musique** : analyser les fréquences, créer des effets sonores

Les espaces vectoriels unifient tout ! Que tu parles de déplacements, de couleurs, de sons ou d'économie, c'est toujours la même mathématique sous-jacente.''',
        visualisation: 'Imagine un plan infini quadrillé. Chaque point est accessible en partant de l\'origine et en suivant des flèches. Les "directions de base" sont comme les axes de ton quadrillage.',
        prerequisTerminale: ['Vecteurs du plan', 'Combinaisons linéaires', 'Coordonnées'],
        ideesFausses: [
          '❌ "Un espace vectoriel, c\'est forcément géométrique" → NON ! Les polynômes, les fonctions, les matrices forment aussi des espaces vectoriels',
          '❌ "On peut toujours visualiser en 3D" → NON ! Il existe des espaces de dimension infinie (fonctions continues, séries de Fourier...)',
          '❌ "Les vecteurs ont toujours une norme" → NON ! Un espace vectoriel n\'a pas besoin de notion de "longueur"',
        ],
        anecdote: 'Le concept d\'espace vectoriel a révolutionné les maths au début du 20e siècle. Avant, on étudiait séparément la géométrie, les équations, les fonctions... L\'idée d\'espace vectoriel a montré que TOUT ça, c\'est la même chose ! C\'est un peu comme découvrir que les oiseaux, les chauves-souris et les avions volent tous grâce au même principe aérodynamique.',
        applicationsReelles: [
          'Google PageRank (classement des pages web)',
          'Reconnaissance faciale (visages = vecteurs)',
          'Compression MP3 (sons = combinaisons d\'ondes)',
          'Prévisions météo (état de l\'atmosphère = vecteur)',
        ],
      ),
      
      ConceptIntuitif(
        id: 'dimension',
        titre: 'Dimension d\'un Espace',
        domaine: 'algèbre',
        niveauAgregation: 5,
        difficulteIntuitive: 1,
        analogieSimple: 'Le nombre minimum de directions indépendantes pour atteindre n\'importe quel point.',
        questionCle: 'Combien d\'informations minimum pour décrire ta position ?',
        explicationIntuitive: '''La dimension, c'est le nombre de "degrés de liberté" que tu as.

• **Dimension 1** (une ligne) : tu ne peux qu'avancer ou reculer. Une seule information te localise : "à 5 mètres du départ"
• **Dimension 2** (un plan) : tu peux aller dans 2 directions indépendantes. Il faut 2 infos : "3 mètres à droite, 4 mètres en haut"
• **Dimension 3** (l'espace) : il faut 3 coordonnées pour te situer

L'idée clé : la dimension mesure la "complexité" de ton univers. Plus la dimension est grande, plus il faut d'informations pour décrire une position.

Surprenant : un DVD est de dimension 2 (surface plate) mais stocke un film en 3D ! Comment ? En codant la 3e dimension dans les couleurs et le mouvement.''',
        exempleConcret: '''Ta position sur Terre : dimension 2 (latitude + longitude) si tu restes au niveau de la mer, dimension 3 si tu grimpes en altitude.

Un film : dimension 3 ! Largeur + hauteur de l'image + temps. Pour décrire un pixel à un instant donné, il faut 3 infos.

La température dans ta chambre : dimension 4 ! (x, y, z, temps) car la température change selon l'endroit ET le moment.''',
        lienAvecLycee: 'Une droite est de dimension 1, un plan de dimension 2, l\'espace de dimension 3. C\'est exactement ce que tu manipules en géométrie ! La dimension généralise cette idée à tous les espaces vectoriels.',
        pourquoiCestImportant: '''La dimension permet de mesurer la complexité d'un problème. 

En **machine learning**, réduire la dimension = rendre un problème plus simple. Exemple : reconnaître un visage (des millions de pixels) peut se ramener à un problème en dimension 50-100 en gardant l'essentiel !

En **physique quantique**, l'état d'un système à N particules vit dans un espace de dimension 3N. Comprendre la dimension aide à simplifier les calculs.''',
        visualisation: 'La dimension d\'une feuille de papier est 2 (tu peux bouger à gauche/droite et haut/bas). Mais si tu froisses la feuille en boule, elle occupe de l\'espace 3D ! La dimension intrinsèque ne change pas, même si la forme change.',
        prerequisTerminale: ['Repère du plan et de l\'espace', 'Base de vecteurs', 'Vecteurs colinéaires/coplanaires'],
        ideesFausses: [
          '❌ "La dimension est toujours un petit nombre" → NON ! L\'espace des fonctions continues est de dimension infinie',
          '❌ "On peut visualiser toutes les dimensions" → Notre cerveau s\'arrête à 3D, mais les maths vont bien au-delà !',
        ],
        anecdote: 'Le mathématicien Poincaré a montré qu\'un objet peut avoir une "dimension fractale" non entière ! Un flocon de neige a une dimension d\'environ 1,26. Plus tortueux qu\'une ligne (dim 1) mais moins remplissant qu\'une surface (dim 2).',
        applicationsReelles: [
          'Compression d\'images (JPEG) : réduire la dimension en gardant l\'essentiel',
          'Analyse de données (PCA) : visualiser des données de grande dimension',
          'Physique des cordes : notre univers aurait 10 ou 11 dimensions !',
        ],
      ),

      ConceptIntuitif(
        id: 'applications-lineaires',
        titre: 'Applications Linéaires',
        domaine: 'algèbre',
        niveauAgregation: 5,
        difficulteIntuitive: 2,
        analogieSimple: 'Une machine qui transforme des vecteurs en respectant les proportions et les additions.',
        questionCle: 'Comment transformer un objet sans "casser" sa structure ?',
        explicationIntuitive: '''Imagine une photocopieuse magique qui peut agrandir, rétrécir, tourner ou déformer une image. Une application linéaire, c'est exactement ça : une transformation qui respecte certaines règles.

**Règle 1** : Si tu doubles l'original, la copie est aussi doublée (respect des proportions)
**Règle 2** : Si tu superposes deux images puis copies, c'est pareil que copier séparément puis superposer (respect de l'addition)

Ces deux règles semblent simples, mais elles sont ULTRA puissantes ! Elles permettent de décrire énormément de transformations : rotations, symétries, projections, zooms...

La magie : pour connaître TOUTE la transformation, il suffit de savoir ce qu'elle fait aux vecteurs de base ! C'est comme si pour comprendre la photocopieuse, tu n'avais qu'à tester avec deux images simples.''',
        exempleConcret: '''• **Rotation d'une image** : linéaire ! Les lignes droites restent droites
• **Projection d'un objet 3D sur un écran** : linéaire ! C'est ce que fait ton GPU en permanence
• **Dérivation** : d/dx est linéaire ! (af + bg)' = af' + bg'
• **Flou d'une photo** : linéaire ! Chaque pixel devient la moyenne de ses voisins

**Contre-exemple** : élever au carré n'est PAS linéaire car (a+b)² ≠ a² + b²''',
        lienAvecLycee: 'Les fonctions affines f(x) = ax + b sont presque linéaires... sauf le "+b" ! Une vraie fonction linéaire vérifie f(0) = 0. Les homothéties, rotations et symétries que tu connais sont des applications linéaires.',
        pourquoiCestImportant: '''Les applications linéaires sont PARTOUT car elles sont simples à comprendre et à calculer.

• **Graphisme 3D** : toutes les transformations de scène
• **Traitement du signal** : filtres audio/vidéo
• **Équations différentielles** : la dérivation est linéaire !
• **Mécanique quantique** : les observables sont des applications linéaires

De plus, beaucoup de problèmes non-linéaires peuvent se "linéariser" localement (c'est le principe de la dérivée !).''',
        visualisation: 'Imagine un quadrillage régulier. Une application linéaire déforme ce quadrillage, mais les lignes restent parallèles et régulièrement espacées. Pense à étirer un tissu élastique avec un motif carré : les carrés deviennent des parallélogrammes mais restent réguliers.',
        prerequisTerminale: ['Fonctions linéaires f(x)=ax', 'Homothéties et rotations', 'Transformations du plan'],
        ideesFausses: [
          '❌ "Linéaire = fonction affine" → NON ! f(x)=2x+3 n\'est PAS linéaire à cause du +3',
          '❌ "Seules les fonctions sont linéaires" → NON ! Matrices, dérivées, intégrales... plein d\'objets sont linéaires',
          '❌ "Linéaire = simple" → Les applications linéaires peuvent être très complexes en grande dimension',
        ],
        anecdote: 'En 1843, Hamilton cherchait comment étendre les nombres complexes (2D) en 3D. Impossible ! Il a dû passer en 4D et inventer les quaternions. Aujourd\'hui, ils servent à orienter les satellites et les personnages de jeux vidéo ! Les rotations 3D sont des applications linéaires.',
        applicationsReelles: [
          'GPS : transformations de coordonnées',
          'Spotify : recommandations (espaces de goûts musicaux)',
          'Imagerie médicale : reconstruction d\'images à partir de mesures',
          'Finance : modèles de risque de portefeuille',
        ],
      ),

      // ============ VOIR L'INVISIBLE ============

      ConceptIntuitif(
        id: 'limite',
        titre: 'Limite d\'une Fonction',
        domaine: 'analyse',
        niveauAgregation: 5,
        difficulteIntuitive: 2,
        analogieSimple: 'Vers où tends-tu quand tu t\'approches d\'un endroit, même si tu n\'y arrives jamais vraiment ?',
        questionCle: 'Que se passe-t-il "au bord" ?',
        explicationIntuitive: '''Imagine que tu marches vers un mur. Plus tu t'approches, plus tu vois les détails : les grains, les fissures... La limite, c'est ce que tu verrais si tu pouvais te rapprocher infiniment près (sans toucher !).

C'est crucial car souvent :
• On ne peut pas atteindre un point exactement (division par zéro, infini...)
• Mais on peut regarder ce qui se passe "juste avant"

Exemple : 1/2 = 0,5 ; 1/10 = 0,1 ; 1/100 = 0,01... Plus le dénominateur grandit, plus on se rapproche de 0. On dit que la limite de 1/x quand x tend vers l'infini est 0.

L'idée géniale : on peut parler de "ce qui se passe à l'infini" ou "au bord d'un trou" sans jamais y être ! C'est comme analyser un trou noir : on ne peut pas y aller, mais on étudie ce qui se passe autour.''',
        exempleConcret: '''**Zénon d'Élée** (antiquité grecque) : "Pour aller d'ici à là, tu dois d'abord parcourir la moitié, puis la moitié de ce qui reste, puis encore la moitié... Tu ne peux jamais arriver !"

La réponse ? Les limites ! 1/2 + 1/4 + 1/8 + ... = 1 exactement. Tu ARRIVES, même si tu découpes le trajet en une infinité d'étapes.

**En physique** : la vitesse instantanée. Tu ne peux pas mesurer une vitesse "à un instant" (il faut un intervalle de temps). Mais tu peux calculer distance/temps sur des intervalles de plus en plus courts. La limite de ce rapport, c'est la vitesse instantanée !''',
        lienAvecLycee: 'Tu calcules déjà des limites ! lim(x→∞) de 1/x = 0, lim(x→0) de sin(x)/x = 1 (célèbre !). Le nombre dérivé f\'(a) est défini comme une limite : lim(h→0) [f(a+h)-f(a)]/h.',
        pourquoiCestImportant: '''Les limites permettent de comprendre :

• **Le calcul différentiel** : dérivées, tangentes, vitesses
• **Les séries infinies** : π = 4(1 - 1/3 + 1/5 - 1/7 + ...)
• **L'infini** : on peut faire des calculs avec !
• **Les discontinuités** : que se passe-t-il aux "sauts" d'une fonction ?

Sans limites, pas de calcul moderne ! Newton et Leibniz ont inventé le calcul infinitésimal (dérivées et intégrales) grâce aux limites.''',
        visualisation: 'Zoome sur le graphe d\'une fonction près d\'un point. Continue à zoomer, encore et encore... Ce que tu vois en "zoomant infiniment", c\'est la limite ! Si le graphe se stabilise vers une hauteur fixe, cette hauteur est la limite.',
        prerequisTerminale: ['Limites de fonctions usuelles', 'Asymptotes', 'Continuité'],
        ideesFausses: [
          '❌ "Si la limite est L, la fonction vaut L au point" → NON ! f peut ne pas être définie en ce point',
          '❌ "La limite existe toujours" → NON ! sin(1/x) n\'a pas de limite en 0 (oscillations infinies)',
          '❌ "Limite = valeur approchée" → NON ! La limite est une valeur EXACTE (mais du "comportement au bord")',
        ],
        anecdote: 'Berkeley, philosophe du 18e siècle, attaquait les limites en les appelant "fantômes de quantités disparues". Il avait tort, mais son scepticisme a poussé les mathématiciens à rendre les limites ultra-rigoureuses (définition ε-δ de Cauchy/Weierstrass). Ironie : ce qu\'il critiquait est devenu le fondement le plus solide des maths !',
        applicationsReelles: [
          'Calcul de π avec une précision arbitraire (séries infinies)',
          'Modèles de croissance (bactéries, économie) : que se passe-t-il "à long terme" ?',
          'Physique relativiste : que se passe-t-il quand on approche la vitesse de la lumière ?',
          'Finance : valeur actuelle d\'une rente perpétuelle',
        ],
      ),

      ConceptIntuitif(
        id: 'integrale',
        titre: 'Intégrale',
        domaine: 'analyse',
        niveauAgregation: 5,
        difficulteIntuitive: 1,
        analogieSimple: 'Additionner une infinité de petits morceaux pour obtenir un tout.',
        questionCle: 'Comment mesurer quelque chose de courbe avec des outils droits ?',
        explicationIntuitive: '''Imagine que tu veux mesurer l'aire sous une courbe. Tu ne peux pas utiliser une formule simple (comme longueur × largeur) car la courbe... est courbe !

L'astuce : découpe l'aire en plein de rectangles très fins. Plus ils sont fins, meilleure est l'approximation. L'intégrale, c'est la limite quand les rectangles deviennent infiniment fins.

**Visualisation** : empile des pièces de monnaie pour remplir une forme bizarre. Les pièces ne remplissent pas parfaitement (il reste des trous). Mais avec des pièces de plus en plus petites, tu remplis de mieux en mieux. À la limite (pièces infiniment petites), tu remplis exactement !

L'intégrale unifie deux idées :
• **Géométrique** : aire sous une courbe
• **Physique** : accumulation continue (distance = intégrale de la vitesse)''',
        exempleConcret: '''**Calculer une distance** : Si tu connais ta vitesse à chaque instant, comment trouver la distance totale ? Chaque instant, tu parcours vitesse × temps (infiniment petit). L'intégrale additionne tous ces micro-déplacements !

**Volume d'eau dans un vase** : La section du vase change avec la hauteur. Volume = intégrale de la section × hauteur.

**Énergie totale** : Si la puissance varie dans le temps, l'énergie consommée = intégrale de la puissance.

**Probabilités** : L'aire sous une courbe de densité = probabilité !''',
        lienAvecLycee: 'Tu calcules des intégrales pour trouver des aires, des volumes (solides de révolution), des valeurs moyennes. La méthode des rectangles ou des trapèzes ? C\'est exactement l\'idée de l\'intégrale !',
        pourquoiCestImportant: '''L'intégrale est l'outil pour passer du local au global :

• **Physique** : distance ← vitesse, travail ← force, masse ← densité
• **Probabilités** : P(a ≤ X ≤ b) = intégrale de la densité
• **Économie** : surplus du consommateur, valeur actualisée
• **Ingénierie** : centre de gravité, moment d'inertie

Et le théorème fondamental : dérivée et intégrale sont inverses ! ∫f'(x)dx = f(x). C'est le lien magique entre variation locale (dérivée) et accumulation globale (intégrale).''',
        visualisation: 'Une rivière coule avec un débit variable. Chaque seconde, un certain volume passe. Pour connaître le volume total écoulé en une heure, tu "additionnes" tous les micro-volumes de chaque instant. C\'est une intégrale !',
        prerequisTerminale: ['Primitives', 'Aire sous une courbe', 'Méthode des rectangles'],
        ideesFausses: [
          '❌ "L\'intégrale donne toujours l\'aire" → NON ! Si f<0, l\'intégrale est négative (c\'est une "aire signée")',
          '❌ "Il faut toujours découper en rectangles" → Non, c\'est juste une visualisation. La définition rigoureuse est plus abstraite',
          '❌ "Intégrer = trouver une primitive" → Pas toujours ! Certaines fonctions (e^(-x²)) n\'ont pas de primitive "simple"',
        ],
        anecdote: 'Archimède (antiquité) calculait déjà des aires en "méthode d\'exhaustion" (ancêtre de l\'intégrale). Il a trouvé l\'aire sous une parabole ! Mais c\'est Newton et Leibniz qui ont compris que intégrale = inverse de dérivée. Cette découverte a changé le monde.',
        applicationsReelles: [
          'Calcul de longueurs de routes (courbes)',
          'Volumes de réservoirs (forme complexe)',
          'Statistiques : probabilités continues',
          'Électricité : énergie = intégrale de la puissance',
        ],
      ),

      // ============ LES SUPER-POUVOIRS ============

      ConceptIntuitif(
        id: 'valeurs-propres',
        titre: 'Valeurs Propres et Vecteurs Propres',
        domaine: 'algèbre',
        niveauAgregation: 5,
        difficulteIntuitive: 3,
        analogieSimple: 'Les directions "spéciales" qui restent inchangées (juste étirées) lors d\'une transformation.',
        questionCle: 'Quelles sont les directions privilégiées d\'une transformation ?',
        explicationIntuitive: '''Imagine que tu appliques une transformation (rotation, étirement, projection...) à tout l'espace. La plupart des vecteurs vont changer de direction ET de longueur.

Mais il existe des directions SPÉCIALES qui ne changent PAS de direction ! Elles sont juste étirées ou compressées. Ces directions magiques, ce sont les **vecteurs propres**. Le facteur d'étirement, c'est la **valeur propre**.

**Exemple concret** : Une symétrie par rapport à un axe.
• Les vecteurs le long de l'axe ne bougent pas (valeur propre = 1)
• Les vecteurs perpendiculaires sont retournés (valeur propre = -1)
• Les autres vecteurs changent de direction

Trouver les vecteurs propres, c'est comme trouver les "axes naturels" d'une transformation. C'est ULTRA puissant car dans ces directions, tout est simple !''',
        exempleConcret: '''**Vibrations d'un pont** : Chaque "mode propre" de vibration correspond à un vecteur propre. Si tu excites le pont exactement à une fréquence propre (valeur propre), il vibre de manière amplifiée. C'est ce qui a détruit le pont de Tacoma en 1940 (résonnance) !

**PageRank de Google** : Le vecteur propre principal de la matrice du web indique l'importance de chaque page !

**Stabilité d'un système** : Si toutes les valeurs propres sont <1, le système est stable (amortissement). Si une valeur propre >1, instabilité (explosion) !

**Photo en noir et blanc** : Les directions principales de variation des couleurs sont les vecteurs propres. Projeter sur le premier vecteur propre ≈ niveau de gris optimal.''',
        lienAvecLycee: 'Quand tu diagonalises une matrice 2×2, tu cherches ses vecteurs propres ! Si A a pour vecteurs propres v₁ et v₂, dans cette nouvelle base, A devient diagonale : super simple à manipuler.',
        pourquoiCestImportant: '''Les valeurs/vecteurs propres simplifient radicalement les problèmes :

• **Calcul de A^n** : Si A est diagonalisable, A^100 devient trivial !
• **Équations différentielles** : Les solutions sont dans les directions propres
• **Stabilité** : Savoir si un système explose ou se stabilise
• **Compression de données** (PCA) : Garder les directions de plus grande variance
• **Mécanique quantique** : Les états possibles sont les vecteurs propres !

Théorème spectral : Les matrices symétriques (super fréquentes !) ont toujours des vecteurs propres orthogonaux. C'est l'outil n°1 en physique et ingénierie.''',
        visualisation: 'Imagine un étirement non uniforme de l\'espace. La plupart des vecteurs sont "tordus". Mais il existe des axes magiques le long desquels les vecteurs sont juste étirés (pas tordus). Trouve ces axes, et tu comprends toute la transformation !',
        prerequisTerminale: ['Matrices 2×2', 'Déterminant', 'Systèmes linéaires'],
        ideesFausses: [
          '❌ "Toute matrice est diagonalisable" → NON ! Certaines matrices n\'ont pas assez de vecteurs propres',
          '❌ "Les valeurs propres sont toujours réelles" → NON ! Elles peuvent être complexes (rotations)',
          '❌ "C\'est juste une technique de calcul" → NON ! C\'est une propriété INTRINSÈQUE d\'une transformation',
        ],
        anecdote: 'Le nom "eigen" vient de l\'allemand et signifie "propre/caractéristique". En français on dit "valeurs propres", en anglais "eigenvalues". Ces objets ont été découverts en étudiant... les vibrations des cordes et des membranes au 18e siècle ! Aujourd\'hui, ils sont au cœur de l\'IA.',
        applicationsReelles: [
          'Google PageRank (classement des pages)',
          'Reconnaissance faciale (eigenfaces)',
          'Stabilité des avions et fusées',
          'Compression d\'images (PCA)',
          'Mécanique quantique (états propres)',
        ],
      ),

      ConceptIntuitif(
        id: 'diagonalisation',
        titre: 'Diagonalisation',
        domaine: 'algèbre',
        niveauAgregation: 5,
        difficulteIntuitive: 3,
        analogieSimple: 'Changer de point de vue pour rendre un problème compliqué super simple.',
        questionCle: 'Comment transformer un problème tordu en problème droit ?',
        explicationIntuitive: '''Imagine un problème vu de travers : tout semble compliqué, tordu, mélangé. Mais si tu tournes ta tête (change de point de vue), soudain tout s'aligne et devient évident !

La diagonalisation, c'est exactement ça. Tu changes de base (= de système de coordonnées) pour te placer dans les directions des vecteurs propres. Dans cette nouvelle base, la transformation devient super simple : elle étire juste chaque direction indépendamment.

**Avant** : Les équations sont entremêlées, x et y se mélangent
**Après** : Chaque variable évolue indépendamment !

C'est comme passer d'une équation compliquée à des équations triviales : ✓ cocher, suivant !''',
        exempleConcret: '''**Système de populations** : Imagine des lapins et des renards. Leurs populations s'influencent mutuellement (équations couplées). En diagonalisant, tu trouves deux "super-populations" qui évoluent indépendamment ! Une croit, l'autre décroit. Le comportement réel est une combinaison des deux.

**Vibrations d'une molécule** : Les atomes bougent tous ensemble de manière compliquée. En diagonalisant, tu trouves les "modes normaux" : chaque mode vibre indépendamment à sa fréquence propre. Les vibrations réelles sont des combinaisons de ces modes.

**Calcul de A^100** : Si A est 3×3, calculer A^100 directement = cauchemar. Mais si tu diagonalises A = PDP^(-1), alors A^100 = PD^100P^(-1). Et D^100 ? Trivial ! Tu élèves juste les valeurs propres à la puissance 100.''',
        lienAvecLycee: 'Diagonaliser une matrice 2×2, c\'est trouver une base de vecteurs propres. Tu exprimes la matrice dans cette base, et elle devient diagonale : [λ₁, 0; 0, λ₂]. Calculs et puissances deviennent faciles !',
        pourquoiCestImportant: '''La diagonalisation décomplexifie :

• **Systèmes dynamiques** : Prédire l'évolution à long terme
• **Équations différentielles** : Résoudre des systèmes couplés
• **Calcul de puissances** : A^n, e^A (matrice exponentielle)
• **Optimisation** : Trouver les extrema de fonctions quadratiques

Le théorème spectral garantit que les matrices symétriques sont diagonalisables avec des vecteurs propres orthogonaux. Bonus : on peut choisir une base orthonormée (super pratique) !''',
        visualisation: 'Tu as un repère tordu et une ellipse quelconque. En diagonalisant (= changeant de repère), l\'ellipse devient alignée avec les axes ! Ses demi-axes sont les vecteurs propres, leurs longueurs les valeurs propres.',
        prerequisTerminale: ['Changement de base', 'Matrices', 'Vecteurs propres'],
        ideesFausses: [
          '❌ "Toute matrice se diagonalise" → NON ! [[1,1],[0,1]] n\'est pas diagonalisable (un seul vecteur propre)',
          '❌ "C\'est juste pour simplifier les calculs" → C\'est surtout pour COMPRENDRE la structure d\'une transformation',
          '❌ "Diagonale = diagonalisable" → NON ! Une matrice diagonale est déjà diagonalisée, mais toutes ne le sont pas',
        ],
        anecdote: 'Hamilton a découvert les quaternions (1843) en cherchant à diagonaliser certaines transformations 3D. Échec ! Mais cette "erreur" a mené à une révolution : les quaternions sont utilisés aujourd\'hui pour orienter les satellites, drones, et personnages de jeux vidéo.',
        applicationsReelles: [
          'Analyse de stabilité (économie, écologie)',
          'Graphisme 3D (transformations efficaces)',
          'Cryptographie (calculs sur grands nombres)',
          'Google (calculs répétés sur le graphe du web)',
        ],
      ),

      // ============ FORMES ET ESPACES ============

      ConceptIntuitif(
        id: 'produit-scalaire',
        titre: 'Produit Scalaire',
        domaine: 'géométrie',
        niveauAgregation: 5,
        difficulteIntuitive: 1,
        analogieSimple: 'Mesurer à quel point deux vecteurs "vont dans la même direction".',
        questionCle: 'Comment mesurer la "similitude" de deux directions ?',
        explicationIntuitive: '''Le produit scalaire u⃗·v⃗ mesure si deux vecteurs sont alignés, opposés, ou perpendiculaires.

• **u⃗·v⃗ > 0** : Ils vont "dans le même sens" (angle aigu)
• **u⃗·v⃗ = 0** : Ils sont perpendiculaires (orthogonaux)
• **u⃗·v⃗ < 0** : Ils vont "en sens opposé" (angle obtus)

Formule : u⃗·v⃗ = |u⃗| |v⃗| cos(θ) où θ est l'angle entre eux.

**Intuition géométrique** : Projette u⃗ sur v⃗. Le produit scalaire = longueur de la projection × longueur de v⃗. Si u⃗ pointe vers v⃗, la projection est grande (produit positif). Si u⃗ est perpendiculaire à v⃗, la projection est nulle (produit nul).

Le produit scalaire généralise la notion d'angle et de longueur à TOUS les espaces vectoriels !''',
        exempleConcret: '''**Travail d'une force** : W = F⃗·d⃗. Si tu pousses dans la direction du mouvement (F⃗ et d⃗ alignés), travail maximal. Si tu pousses perpendiculairement (porter un sac en marchant), travail nul !

**Projection d'un immeuble** : L'ombre d'un bâtiment dépend de l'angle du soleil. Longueur de l'ombre = hauteur × cos(angle). C'est un produit scalaire !

**Similarité de documents** : Chaque document = vecteur de fréquences de mots. Le produit scalaire de deux documents mesure leur similarité (moteurs de recherche) !

**Spotify/Netflix** : Tes goûts = vecteur. Recommandation = trouver des items avec un fort produit scalaire avec tes goûts.''',
        lienAvecLycee: 'u⃗·v⃗ = x₁x₂ + y₁y₂ dans le plan. Tu l\'utilises pour calculer des angles, des distances, vérifier l\'orthogonalité. Le théorème d\'Al-Kashi (cos) est une application du produit scalaire !',
        pourquoiCestImportant: '''Le produit scalaire introduit la géométrie dans les espaces abstraits :

• **Longueur** : |u⃗| = √(u⃗·u⃗)
• **Angle** : cos(θ) = (u⃗·v⃗)/(|u⃗||v⃗|)
• **Orthogonalité** : u⃗⊥v⃗ ⟺ u⃗·v⃗=0
• **Projection** : proj_v(u) = (u⃗·v⃗/|v⃗|²)v⃗

Applications : moindres carrés (régression linéaire), bases orthonormées, décomposition en séries de Fourier, mécanique quantique (produit scalaire de fonctions d'onde).''',
        visualisation: 'Imagine u⃗ comme une flèche. Le produit scalaire u⃗·v⃗ mesure "combien de u⃗ va dans la direction de v⃗". Projette l\'ombre de u⃗ sur v⃗. L\'ombre longue = grand produit scalaire.',
        prerequisTerminale: ['Vecteurs', 'Cosinus', 'Projection orthogonale'],
        ideesFausses: [
          '❌ "Le produit scalaire donne un vecteur" → NON ! C\'est un NOMBRE (scalaire)',
          '❌ "Il faut un repère orthonormé" → NON ! Le produit scalaire existe indépendamment du repère',
          '❌ "u⃗·v⃗ = v⃗·u⃗ toujours" → OUI pour le produit scalaire standard, mais il existe des "produits scalaires" non commutatifs (tenseurs)',
        ],
        anecdote: 'Le produit scalaire a été inventé par Gibbs et Heaviside (fin 19e) pour simplifier les calculs de Maxwell en électromagnétisme. Avant, on utilisait les quaternions de Hamilton (plus compliqués). Le produit scalaire a gagné !',
        applicationsReelles: [
          'Moteurs de recherche (similarité de documents)',
          'Reconnaissance vocale (corrélation de signaux)',
          'Apprentissage automatique (distance entre données)',
          'Physique (travail, énergie, flux magnétique)',
        ],
      ),

      // ============ LE HASARD APPRIVOISÉ ============

      ConceptIntuitif(
        id: 'esperance',
        titre: 'Espérance d\'une Variable Aléatoire',
        domaine: 'probabilités',
        niveauAgregation: 5,
        difficulteIntuitive: 1,
        analogieSimple: 'La moyenne qu\'on obtiendrait "à long terme" en répétant l\'expérience.',
        questionCle: 'Quelle est la valeur "typique" d\'un événement aléatoire ?',
        explicationIntuitive: '''L'espérance E(X), c'est le centre de gravité d'une variable aléatoire.

Imagine un jeu de hasard :
• Tu gagnes 10€ avec probabilité 1/2
• Tu gagnes 0€ avec probabilité 1/2

Si tu joues 1000 fois, tu gagneras environ 500 fois. Gain total ≈ 500×10€ = 5000€. Gain moyen par partie = 5000/1000 = 5€. C'est l'espérance !

Formule : E(X) = Σ x·P(X=x) = somme des valeurs × leurs probabilités.

**Interprétation physique** : Imagine des poids sur une balance. Chaque valeur possible est un poids, et la probabilité est sa masse. L'espérance est le point d'équilibre de la balance.''',
        exempleConcret: '''**Lancer de dé** : E = 1×(1/6) + 2×(1/6) + ... + 6×(1/6) = 3,5. Si tu lances 10000 dés, la moyenne sera très proche de 3,5.

**Assurance** : La compagnie calcule l'espérance du coût des sinistres. Si E(coût) = 500€, elle te fait payer 600€ (prime) pour être rentable.

**Casino** : À la roulette, E(gain) est toujours négatif pour le joueur ! Sur le long terme, tu perds. Le casino gagne car il joue des millions de parties (loi des grands nombres).

**Investissement** : E(rendement) d'un portefeuille = rendement moyen attendu. Si E > taux sans risque, c'est intéressant (en tenant compte du risque).''',
        lienAvecLycee: 'L\'espérance généralise la moyenne : au lieu de diviser la somme par le nombre de valeurs (toutes équiprobables), on pondère chaque valeur par sa probabilité. Si toutes les proba = 1/n, on retrouve la moyenne classique.',
        pourquoiCestImportant: '''L'espérance est LA mesure centrale en probabilités :

• **Décision** : Choisir l'option avec la meilleure espérance (en moyenne)
• **Loi des grands nombres** : La moyenne observée → E(X) quand n→∞
• **Modélisation** : Prédire le comportement moyen d'un système
• **Finance** : Rendement espéré d'un investissement

Propriété linéaire : E(aX+bY) = aE(X) + bE(Y) même si X et Y ne sont pas indépendants ! Très puissant.''',
        visualisation: 'Imagine une courbe de probabilité. L\'espérance est le "centre de masse" de cette courbe. Si tu découpais la courbe en carton, elle se tiendrait en équilibre posée sur un doigt placé à l\'espérance.',
        prerequisTerminale: ['Probabilités', 'Moyenne', 'Variable aléatoire discrète'],
        ideesFausses: [
          '❌ "L\'espérance est la valeur la plus probable" → NON ! Un dé a E=3,5 mais ne donne jamais 3,5',
          '❌ "Si E(X)=5, je vais obtenir environ 5" → NON ! Tu peux avoir des valeurs très éloignées (voir la variance)',
          '❌ "L\'espérance existe toujours" → NON ! Paradoxe de Saint-Pétersbourg : E(gain) = +∞',
        ],
        anecdote: 'Le Paradoxe de Saint-Pétersbourg (18e siècle) : Un jeu où tu gagnes 2^n euros si pile sort au n-ième lancer. L\'espérance de gain est INFINIE ! Mais personne ne paierait une fortune pour jouer... Ce paradoxe a mené à la notion d\'utilité (l\'argent n\'a pas une valeur linéaire).',
        applicationsReelles: [
          'Tarification des assurances',
          'Stratégies de jeux (poker, blackjack)',
          'Gestion de portefeuilles financiers',
          'Dimensionnement de systèmes (serveurs, files d\'attente)',
        ],
      ),

      ConceptIntuitif(
        id: 'loi-normale',
        titre: 'Loi Normale (Gaussienne)',
        domaine: 'probabilités',
        niveauAgregation: 5,
        difficulteIntuitive: 2,
        analogieSimple: 'La courbe en cloche qui apparaît partout quand on additionne plein de petites variations aléatoires.',
        questionCle: 'Pourquoi tant de phénomènes suivent la même courbe en cloche ?',
        explicationIntuitive: '''Imagine que tu additionnes plein d'erreurs de mesure indépendantes : une un peu trop haute, une un peu trop basse, etc. Résultat : la somme suit une loi normale !

La loi normale est la distribution des moyennes. Quand tu moyennes beaucoup de variables aléatoires, tu obtiens une gaussienne (Théorème Central Limite).

**Caractéristiques** :
• Symétrique (en cloche)
• Centrée sur la moyenne μ
• Étalement contrôlé par l'écart-type σ
• 68% des valeurs dans [μ-σ, μ+σ]
• 95% dans [μ-2σ, μ+2σ]

C'est la distribution "par défaut" de la nature ! Dès qu'un phénomène résulte de nombreux facteurs additifs indépendants, il suit approximativement une loi normale.''',
        exempleConcret: '''**Tailles humaines** : La taille résulte de milliers de gènes + environnement. Chaque facteur ajoute ou retire quelques millimètres. Total : distribution normale !

**Notes d'examen** : Si une classe est homogène et les questions variées, les notes suivent une cloche. Les très bonnes et très mauvaises notes sont rares (extrémités).

**Erreurs de mesure** : Mesure 100 fois la longueur d'une table. Les mesures varient légèrement (main tremblante, angle de vue...). Histogramme des mesures : cloche !

**Bruit thermique** : Le voltage aléatoire dû à l'agitation des électrons suit une loi normale. C'est du bruit "blanc" gaussien.

**Finance** : Les rendements journaliers des actions sont souvent modélisés par une loi normale (approximation raisonnable sur court terme).''',
        lienAvecLycee: 'Vous rencontrez la loi normale en statistiques : tests d\'hypothèses, intervalles de confiance. La "règle des 3 sigma" dit que 99,7% des valeurs sont dans [μ-3σ, μ+3σ].',
        pourquoiCestImportant: '''La loi normale est PARTOUT :

• **Théorème Central Limite** : Les moyennes convergent vers la normale
• **Statistique** : Base des tests (Student, χ², intervalles de confiance)
• **Contrôle qualité** : Détection d'anomalies (au-delà de 3σ)
• **Machine Learning** : Initialisation des réseaux de neurones, bruit, régularisation
• **Physique** : Mouvement brownien, mécanique quantique

De plus, la loi normale a des propriétés mathématiques magnifiques : somme de normales = normale, stabilité, maximum d'entropie...''',
        visualisation: 'Imagine une planche de Galton : des billes tombent en rebondissant aléatoirement sur des clous. En bas, elles s\'accumulent en cloche ! Chaque rebond = petit aléa. La somme de tous ces aléas = position finale = loi normale.',
        prerequisTerminale: ['Loi binomiale', 'Moyenne et écart-type', 'Histogrammes'],
        ideesFausses: [
          '❌ "Toutes les données suivent une loi normale" → NON ! Revenus (loi log-normale), durées de vie (exponentielle), etc.',
          '❌ "Loi normale ⇒ moyenne = médiane = mode" → OUI mais seulement car elle est symétrique',
          '❌ "On ne sort jamais de [μ-3σ, μ+3σ]" → On peut ! C\'est juste très rare (0,3%)',
        ],
        anecdote: 'Gauss a découvert cette loi en étudiant les erreurs d\'observation astronomiques (début 19e). Il a montré qu\'elle minimise les erreurs au sens des moindres carrés. Aujourd\'hui, la loi normale est si fondamentale qu\'elle apparaît sur les anciens billets de 10 Deutsche Mark (avec le portrait de Gauss) !',
        applicationsReelles: [
          'Contrôle qualité industriel (Six Sigma)',
          'Tests médicaux (valeurs "normales")',
          'Prévisions météo (modèles d\'incertitude)',
          'Finance (risque de portefeuille, Value at Risk)',
          'Sciences sociales (QI, scores de tests)',
        ],
      ),

      // Ajoutez plus de concepts ici...
    ];
  }
}
