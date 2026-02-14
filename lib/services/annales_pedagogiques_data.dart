import '../models/annale_model.dart';

class AnnalesPedagogiquesData {
  static List<Annale> getAllAnnalesPedagogiques() {
    return [
      _ext2025MG(),
      _ext2025AP(),
      _int2025EP1(),
      _int2025EP2(),
      _ext2024MG(),
      _ext2024AP(),
      _int2024EP1(),
      _int2024EP2(),
      _ext2023MG(),
      _ext2023AP(),
      _int2023EP1(),
      _int2023EP2(),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2024 – Mathématiques générales
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2024MG() {
    return Annale(
      id: 'ped_ext_2024_mg',
      annee: 2024,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2024 – Mathématiques générales (correction pédagogique)',
      description:
          'Correction pédagogique ultra-détaillée de l\'épreuve de mathématiques générales 2024 '
          '(algèbre linéaire, groupes, corps finis). Chaque question est décortiquée pas à pas, '
          'avec rappels de cours et pièges à éviter.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Formes bilinéaires', 'Groupes', 'Corps finis', 'Polynômes cyclotomiques'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg24.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Réduction des endomorphismes',
        'Théorèmes de Sylow',
        'Polynômes cyclotomiques',
        'Corps finis',
        'Matrices orthogonales',
      ],
      rapportGlobal:
          'Cette épreuve couvre un large spectre de l\'algèbre : réduction, formes bilinéaires, '
          'théorie des groupes et corps finis. Notre correction pédagogique reprend chaque question '
          'en détaillant les rappels de cours, les étapes de raisonnement et les pièges classiques. '
          'Prenez le temps de comprendre chaque étape. Courage, c\'est en forgeant qu\'on devient forgeron !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre linéaire et formes bilinéaires',
          introduction:
              'Cette partie porte sur la réduction des endomorphismes, les formes bilinéaires '
              'symétriques et les propriétés des espaces euclidiens.',
          bareme: 7,
          themes: ['Algèbre linéaire', 'Formes bilinéaires', 'Espaces euclidiens'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$E\$ un \$\\mathbb{R}\$-espace vectoriel de dimension \$n\$ et '
                  '\$u \\in \\mathcal{L}(E)\$ dont le polynôme caractéristique est scindé '
                  'à racines simples. Montrer que \$u\$ est diagonalisable.',
              indication:
                  'Relier la multiplicité algébrique (= 1 pour chaque racine) '
                  'à la dimension du sous-espace propre.',
              correction:
                  'Ce qu\'on nous demande : prouver que si \$\\chi_u\$ est scindé à racines simples, alors \$u\$ est diagonalisable.\n\n'
                  'Rappel : \$u\$ est diagonalisable ssi \$\\chi_u\$ est scindé et, pour chaque valeur propre \$\\lambda\$, on a \$\\dim(E_\\lambda) = m_\\lambda\$ (la multiplicité géométrique égale la multiplicité algébrique).\n\n'
                  'Puisque les racines de \$\\chi_u\$ sont simples, chaque multiplicité algébrique vaut \$m_{\\lambda_i} = 1\$.\n'
                  'Or on sait toujours que \$1 \\leq \\dim(E_{\\lambda_i}) \\leq m_{\\lambda_i}\$, donc ici \$\\dim(E_{\\lambda_i}) = 1\$ pour tout \$i\$.\n'
                  'Il y a \$n\$ valeurs propres distinctes (car \$\\deg(\\chi_u) = n\$ et les racines sont simples).\n'
                  'Donc \$\\sum_{i=1}^{n} \\dim(E_{\\lambda_i}) = n = \\dim(E)\$.\n'
                  'Les sous-espaces propres étant en somme directe, on conclut \$E = \\bigoplus_{i=1}^{n} E_{\\lambda_i}\$, ce qui prouve que \$u\$ est diagonalisable.\n\n'
                  'Attention : ne confondez pas « scindé » (toutes les racines dans le corps de base) et « racines simples » (chaque racine de multiplicité 1). Ici les DEUX conditions sont utilisées.',
              points: 3,
              rapportJury:
                  'Question classique. Le jury attend une utilisation correcte des notions '
                  'de multiplicité algébrique et géométrique.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$M \\in \\mathcal{M}_n(\\mathbb{R})\$ une matrice orthogonale '
                  '(i.e. \$M^T M = I_n\$). Montrer que \$\\det(M) = \\pm 1\$.',
              indication:
                  'Utiliser la multiplicativité du déterminant et \$\\det(M^T) = \\det(M)\$.',
              correction:
                  'Ce qu\'on nous demande : montrer que le déterminant d\'une matrice orthogonale vaut \$1\$ ou \$-1\$.\n\n'
                  'Rappel : pour toute matrice carrée, \$\\det(M^T) = \\det(M)\$ et \$\\det(AB) = \\det(A)\\det(B)\$.\n\n'
                  'On part de l\'hypothèse \$M^T M = I_n\$. En prenant le déterminant des deux côtés :\n'
                  '\$\\det(M^T M) = \\det(I_n) = 1\$.\n'
                  'Par multiplicativité : \$\\det(M^T) \\cdot \\det(M) = 1\$.\n'
                  'Or \$\\det(M^T) = \\det(M)\$, donc \$(\\det(M))^2 = 1\$.\n'
                  'En prenant la racine carrée : \$\\det(M) = 1\$ ou \$\\det(M) = -1\$.\n'
                  'Si \$\\det(M) = 1\$, on dit que \$M\$ est une rotation ; si \$\\det(M) = -1\$, c\'est une réflexion (en dimension 2).\n\n'
                  'Attention : la preuve est courte mais le jury attend une rédaction impeccable. Citez chaque propriété utilisée.',
              points: 2,
              rapportJury: 'Question de cours, bien traitée dans l\'ensemble.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$\\varphi : E \\times E \\to \\mathbb{R}\$ une forme bilinéaire symétrique '
                  'sur un espace de dimension 3. Sa matrice dans la base canonique est '
                  '\$A = \\text{diag}(1, -2, 0)\$. Déterminer le noyau et la signature de \$\\varphi\$.',
              indication:
                  'Le noyau est \$\\{x : \\varphi(x,y) = 0 \\text{ pour tout } y\\}\$. '
                  'La signature se lit sur les coefficients diagonaux.',
              correction:
                  'Ce qu\'on nous demande : trouver \$\\ker(\\varphi)\$ et la signature \$(p, q)\$.\n\n'
                  'Rappel : \$\\ker(\\varphi) = \\{x \\in E : \\forall y,\\, \\varphi(x,y) = 0\\}\$. La signature \$(p,q)\$ donne le nombre de coefficients strictement positifs et strictement négatifs dans une forme diagonale.\n\n'
                  '\$A\$ est déjà diagonale : \$\\varphi(x,y) = x_1 y_1 - 2 x_2 y_2 + 0 \\cdot x_3 y_3\$.\n'
                  'Pour \$x \\in \\ker(\\varphi)\$ : en testant \$y = e_1\$ on obtient \$x_1 = 0\$, en testant \$y = e_2\$ on obtient \$-2x_2 = 0\$ donc \$x_2 = 0\$.\n'
                  'Le vecteur \$e_3\$ est libre. Donc \$\\ker(\\varphi) = \\text{Vect}(e_3)\$, de dimension 1.\n'
                  'Les coefficients diagonaux sont \$+1, -2, 0\$ : un positif, un négatif, un nul.\n'
                  'La signature est \$(p, q) = (1, 1)\$ et le rang est \$p + q = 2\$.\n\n'
                  'Attention : la signature ne compte PAS les zéros ! Le rang de \$\\varphi\$ vaut 2, pas 3. La forme est dégénérée car \$\\ker(\\varphi) \\neq \\{0\\}\$.',
              points: 3,
              rapportJury:
                  'Distinguer signature et rang. Certains candidats oublient que '
                  'les zéros ne font pas partie de la signature.',
            ),
            QuestionAnnale(
              enonce:
                  'Dans \$\\mathbb{R}^3\$ euclidien, soit \$F = \\{(x,y,z) : x + y + z = 0\\}\$. '
                  'Calculer la projection orthogonale de \$v = (1, 2, 3)\$ sur \$F\$.',
              indication:
                  'Projeter d\'abord sur \$F^\\perp = \\text{Vect}((1,1,1))\$ puis '
                  'utiliser \$\\text{proj}_F(v) = v - \\text{proj}_{F^\\perp}(v)\$.',
              correction:
                  'Ce qu\'on nous demande : trouver \$p = \\text{proj}_F(v)\$ où \$F\$ est le plan \$x+y+z = 0\$.\n\n'
                  'Rappel : dans un espace euclidien, \$\\text{proj}_F(v) = v - \\text{proj}_{F^\\perp}(v)\$. Le vecteur normal à \$F\$ engendre \$F^\\perp\$.\n\n'
                  'Le vecteur normal au plan est \$n = (1,1,1)\$, donc \$F^\\perp = \\text{Vect}(n)\$.\n'
                  'On calcule \$\\text{proj}_{F^\\perp}(v) = \\frac{\\langle v, n \\rangle}{\\|n\\|^2} n = \\frac{1+2+3}{1+1+1}(1,1,1) = 2(1,1,1) = (2,2,2)\$.\n'
                  'Donc \$\\text{proj}_F(v) = (1,2,3) - (2,2,2) = (-1, 0, 1)\$.\n'
                  'Vérifions : \$-1 + 0 + 1 = 0\$ ✓ (bien dans \$F\$) et \$\\langle(-1,0,1),(1,1,1)\\rangle = -1+0+1 = 0\$ ✓ (orthogonal à \$n\$).\n'
                  'La distance de \$v\$ à \$F\$ est \$\\|\\text{proj}_{F^\\perp}(v)\\| = \\|(2,2,2)\\| = 2\\sqrt{3}\$.\n\n'
                  'Attention : vérifiez TOUJOURS que le résultat appartient à \$F\$ et est orthogonal à \$F^\\perp\$. C\'est la meilleure façon d\'éviter les erreurs de calcul.',
              points: 3,
              rapportJury: 'Question calculatoire classique. Le jury valorise la vérification finale.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$u\$ un endomorphisme d\'un espace euclidien \$E\$ vérifiant '
                  '\$\\langle u(x), y \\rangle = \\langle x, u(y) \\rangle\$ pour tous \$x, y \\in E\$. '
                  'Montrer que les valeurs propres de \$u\$ sont réelles et que les sous-espaces propres sont deux à deux orthogonaux.',
              indication:
                  'Pour la réalité, calculer \$\\lambda \\|x\\|^2\$ de deux façons. '
                  'Pour l\'orthogonalité, utiliser \$\\lambda \\langle x,y \\rangle = \\mu \\langle x,y \\rangle\$.',
              correction:
                  'Ce qu\'on nous demande : deux propriétés des endomorphismes auto-adjoints (symétriques).\n\n'
                  'Rappel : \$u\$ est auto-adjoint signifie \$u = u^*\$, i.e. \$\\langle u(x), y \\rangle = \\langle x, u(y) \\rangle\$ pour tous \$x, y\$.\n\n'
                  'Valeurs propres réelles : si \$u(x) = \\lambda x\$ avec \$x \\neq 0\$, alors \$\\lambda \\|x\\|^2 = \\langle \\lambda x, x \\rangle = \\langle u(x), x \\rangle = \\langle x, u(x) \\rangle = \\langle x, \\lambda x \\rangle = \\bar{\\lambda} \\|x\\|^2\$. Comme \$\\|x\\|^2 > 0\$, on a \$\\lambda = \\bar{\\lambda}\$, donc \$\\lambda \\in \\mathbb{R}\$.\n'
                  'Orthogonalité : soient \$u(x) = \\lambda x\$ et \$u(y) = \\mu y\$ avec \$\\lambda \\neq \\mu\$. Alors \$\\lambda \\langle x,y \\rangle = \\langle u(x),y \\rangle = \\langle x,u(y) \\rangle = \\mu \\langle x,y \\rangle\$.\n'
                  'Donc \$(\\lambda - \\mu)\\langle x,y \\rangle = 0\$. Comme \$\\lambda \\neq \\mu\$, on conclut \$\\langle x,y \\rangle = 0\$.\n'
                  'Ainsi les sous-espaces propres associés à des valeurs propres distinctes sont orthogonaux.\n'
                  'C\'est la première étape vers le théorème spectral : tout endomorphisme symétrique est diagonalisable en base orthonormée.\n\n'
                  'Attention : cet argument utilise de façon essentielle que le produit scalaire est défini positif (\$\\|x\\|^2 > 0\$ pour \$x \\neq 0\$).',
              points: 4,
              rapportJury:
                  'Le jury accorde une grande importance à cette preuve. La récurrence '
                  'complète pour le théorème spectral n\'est pas demandée ici.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A \\in \\mathcal{M}_n(\\mathbb{R})\$ symétrique vérifiant \$A^2 = A\$. '
                  'Montrer que \$A\$ est la matrice d\'une projection orthogonale.',
              indication:
                  'Les seules valeurs propres possibles sont 0 et 1. '
                  'Utiliser le théorème spectral pour les matrices symétriques.',
              correction:
                  'Ce qu\'on nous demande : prouver qu\'une matrice symétrique idempotente est une projection orthogonale.\n\n'
                  'Rappel : \$A^2 = A\$ signifie que \$A\$ est un projecteur. Symétrique + projecteur = projecteur orthogonal.\n\n'
                  '\$A^2 = A\$ implique \$A(A - I_n) = 0\$. Le polynôme \$X(X-1)\$ annule \$A\$, donc le polynôme minimal de \$A\$ divise \$X(X-1)\$.\n'
                  'Les valeurs propres de \$A\$ sont parmi \$\\{0, 1\\}\$. Comme \$A\$ est symétrique réelle, le théorème spectral s\'applique.\n'
                  'Il existe une base orthonormée \$(e_1, \\ldots, e_n)\$ dans laquelle \$A = \\text{diag}(1,\\ldots,1,0,\\ldots,0)\$ avec \$r\$ fois 1.\n'
                  'Posons \$F = \\text{Vect}(e_1, \\ldots, e_r)\$. Alors pour tout \$x\$, \$Ax = \\text{proj}_F(x)\$.\n'
                  'La projection est orthogonale car la base est orthonormée et \$F^\\perp = \\text{Vect}(e_{r+1}, \\ldots, e_n) = \\ker(A)\$.\n\n'
                  'Attention : sans l\'hypothèse de symétrie, \$A^2 = A\$ donne un projecteur, mais pas forcément orthogonal. C\'est la symétrie qui assure l\'orthogonalité !',
              points: 3,
              rapportJury:
                  'Exercice reliant projecteurs et théorème spectral. Le jury attend '
                  'la distinction claire entre projection et projection orthogonale.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Groupes et actions de groupes',
          introduction:
              'Cette partie explore la théorie des groupes : sous-groupes, théorèmes de Sylow, '
              'actions de groupes et classification.',
          bareme: 7,
          themes: ['Groupes', 'Actions de groupes', 'Théorèmes de Sylow'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$G\$ un groupe et \$H = \\{g \\in G : g^2 = e\\}\$. '
                  'L\'ensemble \$H\$ est-il toujours un sous-groupe de \$G\$ ? Justifier.',
              indication:
                  'Tester la stabilité par produit. Chercher un contre-exemple dans \$S_3\$.',
              correction:
                  'Ce qu\'on nous demande : déterminer si \$H = \\{g \\in G : g^2 = e\\}\$ est toujours un sous-groupe.\n\n'
                  'Rappel : pour être un sous-groupe, \$H\$ doit vérifier (1) \$e \\in H\$, (2) stabilité par produit, (3) stabilité par passage à l\'inverse.\n\n'
                  'On a \$e^2 = e\$ ✓ et si \$g^2 = e\$ alors \$g^{-1} = g\$ ✓. Reste la stabilité par produit.\n'
                  'Si \$G\$ est abélien : \$(ab)^2 = a^2 b^2 = e \\cdot e = e\$ ✓. Donc \$H\$ est un sous-groupe dans ce cas.\n'
                  'Contre-exemple : dans \$G = S_3\$, les transpositions \$(12)\$ et \$(13)\$ vérifient \$(12)^2 = (13)^2 = \\text{id}\$.\n'
                  'Mais \$(12)(13) = (132)\$ et \$(132)^2 = (123) \\neq \\text{id}\$. Donc \$(12)(13) \\notin H\$.\n'
                  'Conclusion : \$H\$ n\'est PAS toujours un sous-groupe. C\'est le cas ssi \$G\$ est abélien.\n\n'
                  'Attention : la stabilité par produit est souvent la condition qui fait défaut. Ne l\'oubliez jamais lors de la vérification des sous-groupes.',
              points: 3,
              rapportJury:
                  'Le contre-exemple dans \$S_3\$ est attendu. Le jury sanctionne '
                  'les candidats qui ne fournissent pas d\'exemple explicite.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$G\$ un groupe d\'ordre 28. Montrer que \$G\$ possède '
                  'un unique 7-Sylow, qui est donc distingué dans \$G\$.',
              indication:
                  'Appliquer le 3e théorème de Sylow : \$n_7 \\equiv 1 \\pmod{7}\$ et \$n_7 | 4\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'unicité du 7-sous-groupe de Sylow de \$G\$.\n\n'
                  'Rappel : le 3e théorème de Sylow dit que \$n_p \\equiv 1 \\pmod{p}\$ et \$n_p | m\$ où \$|G| = p^a m\$ avec \$\\gcd(p, m) = 1\$.\n\n'
                  'Ici \$|G| = 28 = 2^2 \\times 7\$, donc \$n_7 \\equiv 1 \\pmod{7}\$ et \$n_7 | 4\$.\n'
                  'Les diviseurs de 4 sont \$\\{1, 2, 4\\}\$. Parmi eux, seul \$1 \\equiv 1 \\pmod{7}\$ (car \$2 \\equiv 2\$ et \$4 \\equiv 4\$).\n'
                  'Donc \$n_7 = 1\$ : il existe un unique 7-Sylow, notons-le \$P\$.\n'
                  'Les \$p\$-Sylow sont conjugués entre eux. S\'il n\'y en a qu\'un, il est stable par conjugaison : \$\\forall g \\in G,\\, gPg^{-1} = P\$.\n'
                  'Donc \$P \\trianglelefteq G\$ (distingué). C\'est un sous-groupe cyclique d\'ordre 7 (car 7 est premier).\n\n'
                  'Attention : l\'argument « unique ⟹ distingué » repose sur le fait que les \$p\$-Sylow forment une seule classe de conjugaison. Ne l\'utilisez pas sans le mentionner.',
              points: 4,
              rapportJury:
                  'Application directe des théorèmes de Sylow. Le jury attend les '
                  'justifications complètes, notamment le lien entre unicité et normalité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$G\$ un groupe agissant sur un ensemble fini \$X\$. '
                  'Démontrer la formule orbite-stabilisateur : '
                  '\$|\\text{Orb}(x)| = [G : \\text{Stab}(x)]\$.',
              indication:
                  'Construire une bijection entre \$\\text{Orb}(x)\$ et \$G/\\text{Stab}(x)\$.',
              correction:
                  'Ce qu\'on nous demande : démontrer que la taille de l\'orbite égale l\'indice du stabilisateur.\n\n'
                  'Rappel : \$\\text{Orb}(x) = \\{g \\cdot x : g \\in G\\}\$, \$\\text{Stab}(x) = \\{g \\in G : g \\cdot x = x\\}\$.\n\n'
                  'Définissons \$\\phi : G/\\text{Stab}(x) \\to \\text{Orb}(x)\$ par \$\\phi(g \\cdot \\text{Stab}(x)) = g \\cdot x\$.\n'
                  'Bien définie : si \$g\\text{Stab}(x) = h\\text{Stab}(x)\$, alors \$h^{-1}g \\in \\text{Stab}(x)\$, donc \$h^{-1}g \\cdot x = x\$, d\'où \$g \\cdot x = h \\cdot x\$ ✓.\n'
                  'Surjective : par définition de l\'orbite, tout \$y \\in \\text{Orb}(x)\$ s\'écrit \$y = g \\cdot x\$ pour un certain \$g\$ ✓.\n'
                  'Injective : si \$g \\cdot x = h \\cdot x\$, alors \$h^{-1}g \\cdot x = x\$, donc \$h^{-1}g \\in \\text{Stab}(x)\$ et \$g\\text{Stab}(x) = h\\text{Stab}(x)\$ ✓.\n'
                  '\$\\phi\$ est bijective, donc \$|\\text{Orb}(x)| = [G : \\text{Stab}(x)]\$. Avec Lagrange : \$|G| = |\\text{Orb}(x)| \\cdot |\\text{Stab}(x)|\$.\n\n'
                  'Attention : vérifiez bien que \$\\phi\$ est bien définie AVANT de montrer l\'injectivité. C\'est l\'étape la plus souvent oubliée.',
              points: 4,
              rapportJury:
                  'Preuve fondamentale. Le jury vérifie la bonne définition de l\'application '
                  'et l\'argument de bijectivité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$H\$ un sous-groupe d\'indice 2 dans un groupe \$G\$. '
                  'Montrer que \$H\$ est distingué dans \$G\$.',
              indication:
                  'Il n\'y a que deux classes à gauche (resp. à droite) : \$H\$ et son complémentaire.',
              correction:
                  'Ce qu\'on nous demande : prouver que tout sous-groupe d\'indice 2 est nécessairement distingué.\n\n'
                  'Rappel : \$H \\trianglelefteq G\$ ssi pour tout \$g \\in G\$, \$gH = Hg\$ (classes à gauche = classes à droite).\n\n'
                  '\$[G:H] = 2\$ signifie qu\'il y a exactement 2 classes à gauche : \$H\$ et \$G \\setminus H\$. De même pour les classes à droite.\n'
                  'Cas 1 : si \$g \\in H\$, alors \$gH = H = Hg\$ (la classe de l\'élément neutre) ✓.\n'
                  'Cas 2 : si \$g \\notin H\$, alors \$gH \\neq H\$ (car \$g \\notin H\$). Comme il n\'y a que 2 classes à gauche, \$gH = G \\setminus H\$.\n'
                  'De même \$Hg \\neq H\$ et donc \$Hg = G \\setminus H\$. On obtient \$gH = G \\setminus H = Hg\$ ✓.\n'
                  'Dans les deux cas \$gH = Hg\$, donc \$H \\trianglelefteq G\$.\n\n'
                  'Attention : cet argument est spécifique à l\'indice 2. Pour \$[G:H] = 3\$ ou plus, le résultat est faux en général (ex : \$H = \\{\\text{id}, (12)\\}\$ dans \$S_3\$ a indice 3 et n\'est pas distingué).',
              points: 3,
              rapportJury:
                  'Résultat classique. Le jury valorise la clarté de la distinction des deux cas.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$G\$ un groupe fini d\'ordre \$p^n\$ (\$p\$ premier, \$n \\geq 1\$). '
                  'Montrer que le centre \$Z(G)\$ est non trivial.',
              indication:
                  'Utiliser l\'équation des classes et la divisibilité par \$p\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que le centre d\'un \$p\$-groupe contient au moins \$p\$ éléments.\n\n'
                  'Rappel : l\'équation des classes est \$|G| = |Z(G)| + \\sum_{i} [G : C_G(x_i)]\$ où la somme porte sur un représentant de chaque classe de conjugaison de taille \$> 1\$.\n\n'
                  'Chaque terme \$[G : C_G(x_i)]\$ divise \$|G| = p^n\$ (par Lagrange) et est \$> 1\$, donc \$p | [G : C_G(x_i)]\$.\n'
                  'En réduisant l\'équation des classes modulo \$p\$ : \$0 \\equiv |Z(G)| + 0 \\pmod{p}\$, donc \$p | |Z(G)|\$.\n'
                  'Comme \$e \\in Z(G)\$, on a \$|Z(G)| \\geq 1\$. Avec \$p | |Z(G)|\$, on obtient \$|Z(G)| \\geq p \\geq 2\$.\n'
                  'Donc \$Z(G)\$ est non trivial.\n'
                  'En particulier, si \$|G| = p^2\$, on peut montrer que \$G\$ est abélien (car \$G/Z(G)\$ serait cyclique).\n\n'
                  'Attention : ce résultat est propre aux \$p\$-groupes. Par exemple, \$Z(S_3) = \\{\\text{id}\\}\$ et \$|S_3| = 6\$ n\'est pas une puissance de premier.',
              points: 4,
              rapportJury:
                  'Preuve par l\'équation des classes. Le jury sanctionne les candidats '
                  'qui n\'expliquent pas pourquoi \$p\$ divise chaque \$[G : C_G(x_i)]\$.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Polynômes et corps finis',
          introduction:
              'Cette partie étudie l\'irréductibilité des polynômes, les polynômes cyclotomiques, '
              'les extensions de corps et la structure des corps finis.',
          bareme: 6,
          themes: ['Polynômes', 'Corps finis', 'Polynômes cyclotomiques', 'Frobenius'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Montrer que le polynôme \$P(X) = X^4 + 3X^3 + 3X + 3\$ est irréductible '
                  'dans \$\\mathbb{Q}[X]\$.',
              indication:
                  'Appliquer le critère d\'Eisenstein avec \$p = 3\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'irréductibilité de \$P\$ sur \$\\mathbb{Q}\$ en utilisant le critère d\'Eisenstein.\n\n'
                  'Rappel : critère d\'Eisenstein – si un premier \$p\$ vérifie \$p \\nmid a_n\$, \$p | a_i\$ pour \$i < n\$, et \$p^2 \\nmid a_0\$, alors \$P\$ est irréductible sur \$\\mathbb{Z}\$ (donc sur \$\\mathbb{Q}\$ par Gauss).\n\n'
                  'Les coefficients de \$P\$ sont \$a_4 = 1,\\, a_3 = 3,\\, a_2 = 0,\\, a_1 = 3,\\, a_0 = 3\$.\n'
                  'Avec \$p = 3\$ : \$3 \\nmid 1\$ ✓ ; \$3 | 3, 0, 3, 3\$ ✓ (noter que \$3 | 0\$) ; \$9 \\nmid 3\$ ✓.\n'
                  'Par le critère d\'Eisenstein, \$P\$ est irréductible dans \$\\mathbb{Z}[X]\$.\n'
                  'Par le lemme de Gauss, \$P\$ est alors irréductible dans \$\\mathbb{Q}[X]\$.\n'
                  'Remarque : le lemme de Gauss dit que si un polynôme primitif de \$\\mathbb{Z}[X]\$ est irréductible sur \$\\mathbb{Z}\$, il l\'est sur \$\\mathbb{Q}\$. Ici \$P\$ est primitif (\$\\gcd(1,3,0,3,3) = 1\$).\n\n'
                  'Attention : Eisenstein ne s\'applique pas toujours directement. Parfois il faut faire un changement de variable (par ex. \$P(X+1)\$) pour l\'appliquer.',
              points: 3,
              rapportJury:
                  'Application directe. Le jury attend la mention du lemme de Gauss.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer le 6e polynôme cyclotomique \$\\Phi_6(X)\$ et vérifier que '
                  '\$X^6 - 1 = \\prod_{d | 6} \\Phi_d(X)\$.',
              indication:
                  'Utiliser la relation \$X^n - 1 = \\prod_{d | n} \\Phi_d(X)\$ et les '
                  'polynômes cyclotomiques connus pour \$d = 1, 2, 3\$.',
              correction:
                  'Ce qu\'on nous demande : calculer \$\\Phi_6(X)\$ et vérifier la factorisation de \$X^6 - 1\$.\n\n'
                  'Rappel : \$\\Phi_n(X) = \\prod_{\\gcd(k,n)=1,\\, 1 \\leq k \\leq n} (X - e^{2i\\pi k/n})\$. On a \$X^n - 1 = \\prod_{d|n} \\Phi_d(X)\$.\n\n'
                  'Diviseurs de 6 : \$\\{1, 2, 3, 6\\}\$. On connaît \$\\Phi_1(X) = X-1\$, \$\\Phi_2(X) = X+1\$, \$\\Phi_3(X) = X^2+X+1\$.\n'
                  'De \$X^6-1 = \\Phi_1 \\Phi_2 \\Phi_3 \\Phi_6\$ on tire \$\\Phi_6(X) = \\frac{X^6-1}{(X-1)(X+1)(X^2+X+1)}\$.\n'
                  'On simplifie : \$\\frac{X^6-1}{X^2-1} = X^4 + X^2 + 1\$, puis \$\\frac{X^4+X^2+1}{X^2+X+1} = X^2 - X + 1\$.\n'
                  'Donc \$\\Phi_6(X) = X^2 - X + 1\$.\n'
                  'Vérification : \$\\deg(\\Phi_6) = \\varphi(6) = 6 \\cdot (1-\\frac{1}{2})(1-\\frac{1}{3}) = 2\$ ✓. Et \$(X-1)(X+1)(X^2+X+1)(X^2-X+1) = X^6-1\$ ✓.\n\n'
                  'Attention : vérifiez toujours que le degré obtenu correspond à \$\\varphi(n)\$ (indicatrice d\'Euler). C\'est un excellent contrôle.',
              points: 4,
              rapportJury: 'Le jury valorise les candidats qui vérifient le degré via l\'indicatrice d\'Euler.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$\\alpha = \\sqrt[3]{2}\$. Déterminer le degré de l\'extension '
                  '\$[\\mathbb{Q}(\\alpha) : \\mathbb{Q}]\$ et donner une base de \$\\mathbb{Q}(\\alpha)\$ '
                  'comme \$\\mathbb{Q}\$-espace vectoriel.',
              indication:
                  'Montrer que \$X^3 - 2\$ est irréductible sur \$\\mathbb{Q}\$ (Eisenstein avec \$p = 2\$).',
              correction:
                  'Ce qu\'on nous demande : calculer le degré de l\'extension \$\\mathbb{Q}(\\sqrt[3]{2})/\\mathbb{Q}\$.\n\n'
                  'Rappel : si \$\\alpha\$ est racine d\'un polynôme irréductible \$P\$ de degré \$d\$ sur \$\\mathbb{Q}\$, alors \$[\\mathbb{Q}(\\alpha):\\mathbb{Q}] = d\$ et \$(1, \\alpha, \\ldots, \\alpha^{d-1})\$ est une base.\n\n'
                  '\$P(X) = X^3 - 2\$ a pour racine \$\\alpha = \\sqrt[3]{2}\$. Appliquons Eisenstein avec \$p = 2\$ : \$2 \\nmid 1\$, \$2 | (-2)\$, \$4 \\nmid (-2)\$ ✓.\n'
                  'Donc \$P\$ est irréductible sur \$\\mathbb{Q}\$ ; c\'est le polynôme minimal de \$\\alpha\$.\n'
                  'On en déduit \$[\\mathbb{Q}(\\alpha) : \\mathbb{Q}] = \\deg(P) = 3\$.\n'
                  'Une base de \$\\mathbb{Q}(\\alpha)\$ sur \$\\mathbb{Q}\$ est \$(1, \\alpha, \\alpha^2) = (1, \\sqrt[3]{2}, \\sqrt[3]{4})\$.\n'
                  'Tout élément de \$\\mathbb{Q}(\\alpha)\$ s\'écrit de façon unique \$a + b\\sqrt[3]{2} + c\\sqrt[3]{4}\$ avec \$a, b, c \\in \\mathbb{Q}\$.\n\n'
                  'Attention : les deux autres racines de \$P\$ (à savoir \$\\alpha j\$ et \$\\alpha j^2\$ avec \$j = e^{2i\\pi/3}\$) ne sont PAS dans \$\\mathbb{Q}(\\alpha) \\subset \\mathbb{R}\$. L\'extension n\'est pas galoisienne.',
              points: 3,
              rapportJury:
                  'Le jury vérifie qu\'Eisenstein est correctement appliqué et que la base est identifiée.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que pour tout premier \$p\$ et tout \$n \\geq 1\$, il existe '
                  'un corps à \$p^n\$ éléments, unique à isomorphisme près.',
              indication:
                  'Considérer le corps de décomposition de \$X^{p^n} - X\$ sur \$\\mathbb{F}_p\$.',
              correction:
                  'Ce qu\'on nous demande : existence et unicité du corps fini \$\\mathbb{F}_{p^n}\$.\n\n'
                  'Rappel : un corps fini a toujours \$p^n\$ éléments pour un certain premier \$p\$. Ses éléments sont les racines de \$X^{p^n} - X\$.\n\n'
                  'Existence : soit \$K\$ le corps de décomposition de \$f(X) = X^{p^n} - X\$ sur \$\\mathbb{F}_p\$. L\'ensemble \$S = \\{\\alpha \\in K : \\alpha^{p^n} = \\alpha\\}\$ est un sous-corps (stable par \$+, \\times\$ grâce au Frobenius : \$(a+b)^{p^n} = a^{p^n} + b^{p^n}\$).\n'
                  'La dérivée \$f\'(X) = -1 \\neq 0\$ montre que \$f\$ n\'a pas de racine multiple, donc \$|S| = p^n\$.\n'
                  'Unicité : si \$K_1\$ et \$K_2\$ ont \$p^n\$ éléments, ils sont tous deux corps de décomposition de \$X^{p^n}-X\$ sur \$\\mathbb{F}_p\$ (car leurs éléments sont exactement les racines de ce polynôme). Deux corps de décomposition d\'un même polynôme sont isomorphes.\n'
                  'Remarque : on note ce corps \$\\mathbb{F}_{p^n}\$ ou \$\\text{GF}(p^n)\$ (Galois Field).\n\n'
                  'Attention : il est essentiel de vérifier l\'absence de racines multiples. C\'est la dérivée \$f\'(X) = p^n X^{p^n - 1} - 1 = -1\$ (car \$p^n = 0\$ en caractéristique \$p\$) qui le garantit.',
              points: 4,
              rapportJury:
                  'Question de cours fondamentale. Le jury attend existence ET unicité avec des arguments complets.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$\\mathbb{F}_q\$ le corps à \$q = p^n\$ éléments. Montrer que '
                  '\$\\phi : x \\mapsto x^p\$ (Frobenius) est un automorphisme de \$\\mathbb{F}_q\$ '
                  'et que \$\\text{Gal}(\\mathbb{F}_q / \\mathbb{F}_p) = \\langle \\phi \\rangle \\cong \\mathbb{Z}/n\\mathbb{Z}\$.',
              indication:
                  'Montrer que \$\\phi\$ est un morphisme de corps injectif, puis déterminer son ordre.',
              correction:
                  'Ce qu\'on nous demande : prouver que le Frobenius engendre le groupe de Galois.\n\n'
                  'Rappel : en caractéristique \$p\$, \$(a+b)^p = a^p + b^p\$ (les coefficients binomiaux intermédiaires sont divisibles par \$p\$). Donc \$\\phi\$ est un morphisme de corps.\n\n'
                  '\$\\phi\$ est injectif : tout morphisme de corps est injectif (le noyau est un idéal d\'un corps, donc \$\\{0\\}\$). Comme \$\\mathbb{F}_q\$ est fini, injectif ⟹ bijectif.\n'
                  'Ordre de \$\\phi\$ : \$\\phi^n(x) = x^{p^n} = x\$ pour tout \$x \\in \\mathbb{F}_q\$ (car les éléments de \$\\mathbb{F}_q\$ sont racines de \$X^{p^n} - X\$). Donc \$\\phi^n = \\text{Id}\$.\n'
                  'Si \$\\phi^k = \\text{Id}\$, alors tout \$x \\in \\mathbb{F}_q\$ vérifie \$x^{p^k} = x\$. Mais \$X^{p^k} - X\$ a au plus \$p^k\$ racines, donc \$p^n \\leq p^k\$, i.e. \$n \\leq k\$.\n'
                  'L\'ordre de \$\\phi\$ est exactement \$n\$. Or \$|\\text{Gal}(\\mathbb{F}_q/\\mathbb{F}_p)| = [\\mathbb{F}_q:\\mathbb{F}_p] = n\$ (extension galoisienne).\n'
                  'Le sous-groupe \$\\langle \\phi \\rangle\$ est d\'ordre \$n = |\\text{Gal}(\\mathbb{F}_q/\\mathbb{F}_p)|\$, donc \$\\text{Gal}(\\mathbb{F}_q/\\mathbb{F}_p) = \\langle \\phi \\rangle \\cong \\mathbb{Z}/n\\mathbb{Z}\$.\n\n'
                  'Attention : l\'identité \$(a+b)^p = a^p + b^p\$ est FAUSSE en caractéristique 0. C\'est une spécificité de la caractéristique \$p\$.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve que l\'ordre de Frobenius est exactement \$n\$, '
                  'pas seulement qu\'il divise \$n\$.',
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2024 – Analyse et probabilités
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2024AP() {
    return Annale(
      id: 'ped_ext_2024_ap',
      annee: 2024,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2024 – Analyse et probabilités (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve d\'analyse et probabilités 2024. '
          'Espaces de Hilbert, séries de Fourier, convergence dominée et théorème central limite.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse fonctionnelle', 'Intégration', 'Séries de Fourier', 'Probabilités'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap24.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Espaces de Hilbert', 'Séries de Fourier', 'Convergence dominée', 'Théorème central limite', 'Fonctions caractéristiques'],
      rapportGlobal:
          'Cette épreuve mêle analyse fonctionnelle, intégration et probabilités. '
          'Notre correction pédagogique détaille chaque étape pour vous guider.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Analyse fonctionnelle',
          introduction:
              'Cette partie porte sur les espaces de Hilbert, la projection orthogonale, '
              'les bases hilbertiennes et l\'identité de Parseval.',
          bareme: 7,
          themes: ['Espaces de Hilbert', 'Projection orthogonale', 'Bases hilbertiennes'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Montrer que l\'espace \$L^2([0,1])\$ muni du produit scalaire '
                  '\$\\langle f, g \\rangle = \\int_0^1 f(t)\\overline{g(t)}\\,dt\$ '
                  'est un espace de Hilbert.',
              indication:
                  'Il faut montrer que \$L^2\$ est complet pour la norme associée. '
                  'Utiliser le théorème de Riesz-Fischer.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$L^2([0,1])\$ est un espace de Hilbert, c\'est-à-dire un espace préhilbertien complet.\n\n'
                  'Rappel : un espace de Hilbert est un espace vectoriel muni d\'un produit scalaire, complet pour la norme \$\\|f\\| = \\sqrt{\\langle f, f \\rangle}\$.\n\n'
                  'Produit scalaire : on vérifie que \$\\langle f, g \\rangle = \\int_0^1 f \\bar{g}\$ est bien sesquilinéaire, hermitien (\$\\langle g,f \\rangle = \\overline{\\langle f,g \\rangle}\$), et défini positif (\$\\langle f,f \\rangle = 0 \\Rightarrow f = 0\$ p.p.).\n'
                  'Complétude : c\'est le théorème de Riesz-Fischer. Si \$(f_n)\$ est de Cauchy dans \$L^2\$, on extrait une sous-suite \$(f_{n_k})\$ telle que \$\\|f_{n_{k+1}} - f_{n_k}\\| \\leq 2^{-k}\$.\n'
                  'La série \$\\sum |f_{n_{k+1}} - f_{n_k}|\$ converge dans \$L^2\$ (par comparaison), donc \$(f_{n_k})\$ converge p.p. vers une limite \$f\$.\n'
                  'Par le lemme de Fatou, \$f \\in L^2\$ et \$\\|f_{n_k} - f\\|_2 \\to 0\$. Comme \$(f_n)\$ est de Cauchy, toute la suite converge vers \$f\$.\n'
                  'Donc \$L^2([0,1])\$ est complet : c\'est un espace de Hilbert.\n\n'
                  'Attention : on travaille avec des classes de fonctions (égalité presque partout). Le « défini positif » signifie \$f = 0\$ p.p., pas \$f = 0\$ partout.',
              points: 4,
              rapportJury:
                  'Le jury attend la vérification des axiomes du produit scalaire ET la complétude.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$H\$ un espace de Hilbert et \$F\$ un sous-espace vectoriel fermé. '
                  'Montrer que pour tout \$x \\in H\$, il existe un unique \$p \\in F\$ '
                  'tel que \$\\|x - p\\| = d(x, F)\$.',
              indication:
                  'Utiliser le caractère complet de \$F\$ et la caractérisation par '
                  'l\'orthogonalité : \$x - p \\perp F\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'existence et l\'unicité de la projection orthogonale sur un fermé convexe.\n\n'
                  'Rappel : \$d(x, F) = \\inf_{y \\in F} \\|x - y\\|\$. La projection minimise cette distance.\n\n'
                  'Existence : soit \$(y_n) \\subset F\$ telle que \$\\|x - y_n\\| \\to d(x,F) = \\delta\$. Par l\'identité du parallélogramme : \$\\|y_n - y_m\\|^2 = 2\\|x-y_n\\|^2 + 2\\|x-y_m\\|^2 - 4\\|x - \\frac{y_n+y_m}{2}\\|^2\$.\n'
                  'Comme \$\\frac{y_n+y_m}{2} \\in F\$ (convexité), \$\\|x - \\frac{y_n+y_m}{2}\\| \\geq \\delta\$. On obtient \$\\|y_n - y_m\\|^2 \\leq 2\\|x-y_n\\|^2 + 2\\|x-y_m\\|^2 - 4\\delta^2 \\to 0\$.\n'
                  'Donc \$(y_n)\$ est de Cauchy dans \$F\$ fermé (donc complet), et converge vers \$p \\in F\$ avec \$\\|x-p\\| = \\delta\$.\n'
                  'Unicité : si \$p_1, p_2\$ réalisent le minimum, l\'identité du parallélogramme donne \$\\|p_1 - p_2\\|^2 \\leq 0\$, donc \$p_1 = p_2\$.\n'
                  'Caractérisation : \$p = \\text{proj}_F(x)\$ ssi \$\\langle x - p, y \\rangle = 0\$ pour tout \$y \\in F\$ (orthogonalité).\n\n'
                  'Attention : l\'hypothèse « fermé » est essentielle. Un sous-espace non fermé de dimension infinie peut ne pas admettre de projection.',
              points: 4,
              rapportJury:
                  'Preuve technique. Le jury attend l\'utilisation de l\'identité du parallélogramme.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le théorème de représentation de Riesz '
                  'pour les espaces de Hilbert.',
              indication:
                  'Toute forme linéaire continue sur \$H\$ est de la forme '
                  '\$\\varphi(x) = \\langle x, a \\rangle\$ pour un unique \$a \\in H\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que toute forme linéaire continue sur un Hilbert se représente par un produit scalaire.\n\n'
                  'Rappel (énoncé) : si \$H\$ est un Hilbert et \$\\varphi \\in H\'\$ (dual topologique), il existe un unique \$a \\in H\$ tel que \$\\varphi(x) = \\langle x, a \\rangle\$ pour tout \$x\$, et \$\\|\\varphi\\| = \\|a\\|\$.\n\n'
                  'Si \$\\varphi = 0\$, prendre \$a = 0\$. Sinon, \$F = \\ker(\\varphi)\$ est un hyperplan fermé, donc \$F^\\perp\$ est de dimension 1.\n'
                  'Soit \$z \\in F^\\perp \\setminus \\{0\\}\$. Posons \$a = \\frac{\\overline{\\varphi(z)}}{\\|z\\|^2} z\$.\n'
                  'Pour \$x \\in H\$, écrivons \$x = (x - \\frac{\\varphi(x)}{\\varphi(z)}z) + \\frac{\\varphi(x)}{\\varphi(z)}z\$. Le premier terme est dans \$\\ker(\\varphi)\$.\n'
                  'On vérifie \$\\langle x, a \\rangle = \\frac{\\varphi(x)}{\\varphi(z)} \\cdot \\frac{\\varphi(z)}{\\|z\\|^2} \\|z\\|^2 = \\varphi(x)\$ ✓.\n'
                  'Unicité : si \$\\langle x, a \\rangle = \\langle x, b \\rangle\$ pour tout \$x\$, alors \$\\langle x, a-b \\rangle = 0\$ pour tout \$x\$, donc \$a = b\$.\n\n'
                  'Attention : ce théorème est FAUX dans un espace préhilbertien non complet. La complétude est utilisée pour l\'existence de \$F^\\perp \\neq \\{0\\}\$.',
              points: 4,
              rapportJury:
                  'Théorème fondamental. Le jury valorise une preuve constructive et la vérification de l\'unicité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(e_n)_{n \\geq 1}\$ une base hilbertienne de \$H\$. '
                  'Montrer que pour tout \$x \\in H\$, \$x = \\sum_{n=1}^{\\infty} \\langle x, e_n \\rangle e_n\$ '
                  '(convergence dans \$H\$).',
              indication:
                  'Montrer que les sommes partielles \$S_N = \\sum_{n=1}^{N} \\langle x, e_n \\rangle e_n\$ '
                  'convergent vers \$x\$ en utilisant Bessel puis la densité du système.',
              correction:
                  'Ce qu\'on nous demande : justifier le développement en série de Fourier abstraite dans un Hilbert.\n\n'
                  'Rappel : une base hilbertienne est un système orthonormé total (son espace vectoriel engendré est dense dans \$H\$). Les \$\\langle x, e_n \\rangle\$ sont les coefficients de Fourier.\n\n'
                  'Posons \$S_N = \\sum_{n=1}^N \\langle x, e_n \\rangle e_n\$. Comme les \$e_n\$ sont orthonormés, \$\\|S_N\\|^2 = \\sum_{n=1}^N |\\langle x, e_n \\rangle|^2\$.\n'
                  'L\'inégalité de Bessel donne \$\\sum_{n=1}^N |\\langle x, e_n \\rangle|^2 \\leq \\|x\\|^2\$. Donc la série \$\\sum |\\langle x, e_n \\rangle|^2\$ converge, et \$(S_N)\$ est de Cauchy dans \$H\$ (complet).\n'
                  'Soit \$s = \\lim S_N\$. On a \$\\langle x - s, e_n \\rangle = \\langle x, e_n \\rangle - \\langle x, e_n \\rangle = 0\$ pour tout \$n\$.\n'
                  'Comme \$(e_n)\$ est totale, le seul vecteur orthogonal à tous les \$e_n\$ est \$0\$. Donc \$x - s = 0\$, i.e. \$x = s\$.\n'
                  'On a donc \$x = \\sum_{n=1}^\\infty \\langle x, e_n \\rangle e_n\$ avec convergence dans \$H\$.\n\n'
                  'Attention : la convergence est en norme \$L^2\$, PAS ponctuelle en général. Pour la convergence ponctuelle des séries de Fourier, il faut des hypothèses de régularité supplémentaires.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'utilisation de l\'inégalité de Bessel et l\'argument de totalité.',
            ),
            QuestionAnnale(
              enonce:
                  'Démontrer l\'identité de Parseval : pour tout \$x \\in H\$, '
                  '\$\\|x\\|^2 = \\sum_{n=1}^{\\infty} |\\langle x, e_n \\rangle|^2\$.',
              indication:
                  'Utiliser le résultat précédent et la continuité du produit scalaire.',
              correction:
                  'Ce qu\'on nous demande : prouver que la norme se conserve lors du développement en base hilbertienne.\n\n'
                  'Rappel : l\'identité de Parseval généralise le théorème de Pythagore en dimension infinie. C\'est l\'analogue de \$\\|x\\|^2 = \\sum x_i^2\$ en dimension finie.\n\n'
                  'D\'après la question précédente, \$x = \\sum_{n=1}^\\infty \\langle x, e_n \\rangle e_n\$, donc \$\\|x - S_N\\| \\to 0\$.\n'
                  'Par continuité de la norme : \$\\|x\\|^2 = \\lim_{N \\to \\infty} \\|S_N\\|^2\$.\n'
                  'Or \$\\|S_N\\|^2 = \\|\\sum_{n=1}^N \\langle x, e_n \\rangle e_n\\|^2 = \\sum_{n=1}^N |\\langle x, e_n \\rangle|^2\$ (Pythagore, car les \$e_n\$ sont orthonormés).\n'
                  'En passant à la limite : \$\\|x\\|^2 = \\sum_{n=1}^\\infty |\\langle x, e_n \\rangle|^2\$.\n'
                  'Application : dans \$L^2([0,1])\$ avec la base \$(e^{2i\\pi n t})_{n \\in \\mathbb{Z}}\$, on retrouve \$\\int_0^1 |f(t)|^2 dt = \\sum_{n \\in \\mathbb{Z}} |c_n(f)|^2\$.\n\n'
                  'Attention : Parseval implique Bessel (inégalité) mais la réciproque est fausse. Parseval nécessite que le système soit TOTAL (= base hilbertienne), pas seulement orthonormé.',
              points: 3,
              rapportJury:
                  'Le jury attend la justification rigoureuse du passage à la limite dans la norme.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Séries et intégration',
          introduction:
              'Cette partie porte sur le théorème de convergence dominée, les intégrales à paramètres, '
              'les séries de Fourier et la transformée de Fourier.',
          bareme: 7,
          themes: ['Convergence dominée', 'Intégrales à paramètres', 'Séries de Fourier', 'Transformée de Fourier'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$f_n(x) = \\frac{n x}{1 + n^2 x^2}\$ pour \$x \\in [0,1]\$. '
                  'Calculer \$\\lim_{n \\to \\infty} \\int_0^1 f_n(x)\\,dx\$.',
              indication:
                  'Étudier la convergence simple de \$f_n\$, vérifier si on peut '
                  'appliquer le théorème de convergence dominée.',
              correction:
                  'Ce qu\'on nous demande : calculer la limite de l\'intégrale de \$f_n\$ en utilisant un théorème d\'interversion.\n\n'
                  'Rappel : le théorème de convergence dominée (Lebesgue) dit que si \$f_n \\to f\$ p.p. et \$|f_n| \\leq g\$ intégrable, alors \$\\int f_n \\to \\int f\$.\n\n'
                  'Convergence simple : pour \$x > 0\$, \$f_n(x) = \\frac{1}{1/(nx) + nx} \\to 0\$ car \$nx \\to \\infty\$. Pour \$x = 0\$, \$f_n(0) = 0\$. Donc \$f_n \\to 0\$ simplement.\n'
                  'Domination : \$f_n(x) = \\frac{nx}{1+n^2x^2} \\leq \\frac{1}{2}\$ (par AM-GM : \$1 + n^2x^2 \\geq 2nx\$). Donc \$|f_n| \\leq \\frac{1}{2}\$, qui est intégrable sur \$[0,1]\$.\n'
                  'Par convergence dominée : \$\\lim \\int_0^1 f_n = \\int_0^1 0 = 0\$.\n'
                  'Vérification directe : \$\\int_0^1 \\frac{nx}{1+n^2x^2}dx = \\frac{1}{2}[\\ln(1+n^2x^2)]_0^1 = \\frac{\\ln(1+n^2)}{2n} \\sim \\frac{\\ln n}{n} \\to 0\$ ✓.\n'
                  'Les deux méthodes confirment que la limite est \$0\$.\n\n'
                  'Attention : la convergence dominée ne s\'applique PAS si la domination n\'est pas par une fonction fixe intégrable. Ici, la borne \$\\frac{1}{2}\$ est constante, c\'est idéal.',
              points: 3,
              rapportJury:
                  'Le jury apprécie les candidats qui font les deux approches (dominée + calcul direct).',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$F(t) = \\int_0^{\\infty} \\frac{e^{-tx}}{1 + x^2}\\,dx\$ pour \$t > 0\$. '
                  'Montrer que \$F\$ est de classe \$C^1\$ sur \$]0, +\\infty[\$ et calculer \$F\'(t)\$.',
              indication:
                  'Appliquer le théorème de dérivation sous le signe intégral. '
                  'Vérifier l\'hypothèse de domination pour \$\\partial_t f(t,x)\$.',
              correction:
                  'Ce qu\'on nous demande : dériver une intégrale à paramètre sous le signe intégral.\n\n'
                  'Rappel : si \$f(t,x)\$ est mesurable, \$t \\mapsto f(t,x)\$ est \$C^1\$ pour presque tout \$x\$, et si \$|\\partial_t f(t,x)| \\leq g(x)\$ intégrable (indépendante de \$t\$ localement), alors \$F\'(t) = \\int \\partial_t f(t,x) dx\$.\n\n'
                  'Ici \$f(t,x) = \\frac{e^{-tx}}{1+x^2}\$ et \$\\partial_t f(t,x) = \\frac{-x e^{-tx}}{1+x^2}\$.\n'
                  'Pour \$t \\geq t_0 > 0\$ : \$|\\partial_t f(t,x)| = \\frac{x e^{-tx}}{1+x^2} \\leq \\frac{x e^{-t_0 x}}{1+x^2} \\leq x e^{-t_0 x}\$.\n'
                  'Or \$\\int_0^\\infty x e^{-t_0 x} dx = \\frac{1}{t_0^2} < \\infty\$. La domination est vérifiée.\n'
                  'Par le théorème de dérivation sous l\'intégrale : \$F\'(t) = -\\int_0^\\infty \\frac{x e^{-tx}}{1+x^2} dx\$ pour tout \$t > 0\$.\n'
                  '\$F\$ est bien \$C^1\$ sur \$]0, +\\infty[\$ (on peut itérer l\'argument pour obtenir \$C^\\infty\$).\n\n'
                  'Attention : la domination doit être uniforme en \$t\$ sur un voisinage, pas juste pour un \$t\$ fixé. C\'est pourquoi on fixe \$t \\geq t_0 > 0\$.',
              points: 4,
              rapportJury:
                  'Le jury est attentif à la domination locale en \$t\$. Ne pas oublier de fixer \$t_0\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer les coefficients de Fourier de la fonction \$2\\pi\$-périodique '
                  '\$f(x) = |x|\$ sur \$[-\\pi, \\pi]\$.',
              indication:
                  'Utiliser la parité de \$f\$ pour simplifier le calcul. '
                  'Seuls les \$a_n\$ (cosinus) sont non nuls.',
              correction:
                  'Ce qu\'on nous demande : développer \$f(x) = |x|\$ en série de Fourier sur \$[-\\pi, \\pi]\$.\n\n'
                  'Rappel : \$a_0 = \\frac{1}{2\\pi}\\int_{-\\pi}^{\\pi} f(x)dx\$, \$a_n = \\frac{1}{\\pi}\\int_{-\\pi}^{\\pi} f(x)\\cos(nx)dx\$, \$b_n = \\frac{1}{\\pi}\\int_{-\\pi}^{\\pi} f(x)\\sin(nx)dx\$.\n\n'
                  '\$f\$ est paire, donc \$b_n = 0\$ pour tout \$n\$ (produit d\'une fonction paire par une impaire est impair, d\'intégrale nulle).\n'
                  '\$a_0 = \\frac{1}{2\\pi}\\int_{-\\pi}^{\\pi} |x| dx = \\frac{1}{2\\pi} \\cdot 2 \\int_0^\\pi x dx = \\frac{1}{2\\pi} \\cdot \\pi^2 = \\frac{\\pi}{2}\$.\n'
                  'Pour \$n \\geq 1\$ : \$a_n = \\frac{2}{\\pi}\\int_0^\\pi x \\cos(nx) dx\$. Par IPP : \$= \\frac{2}{\\pi}\\left[\\frac{x\\sin(nx)}{n}\\right]_0^\\pi - \\frac{2}{n\\pi}\\int_0^\\pi \\sin(nx) dx = \\frac{2}{n\\pi}\\left[\\frac{\\cos(nx)}{n}\\right]_0^\\pi\$.\n'
                  '\$a_n = \\frac{2}{n^2 \\pi}(\\cos(n\\pi) - 1) = \\frac{2}{n^2 \\pi}((-1)^n - 1)\$. Donc \$a_n = 0\$ si \$n\$ pair, \$a_n = -\\frac{4}{n^2 \\pi}\$ si \$n\$ impair.\n'
                  'Résultat : \$|x| = \\frac{\\pi}{2} - \\frac{4}{\\pi}\\sum_{k=0}^{\\infty} \\frac{\\cos((2k+1)x)}{(2k+1)^2}\$ (convergence uniforme car \$f\$ est continue).\n\n'
                  'Attention : en posant \$x = 0\$, on retrouve \$\\sum_{k=0}^\\infty \\frac{1}{(2k+1)^2} = \\frac{\\pi^2}{8}\$. C\'est un joli bonus !',
              points: 3,
              rapportJury:
                  'Calcul classique. Le jury vérifie la bonne utilisation de la parité et l\'IPP.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f \\in L^1(\\mathbb{R})\$. Montrer que la transformée de Fourier '
                  '\$\\hat{f}(\\xi) = \\int_{\\mathbb{R}} f(x) e^{-2i\\pi \\xi x} dx\$ '
                  'est continue et tend vers 0 à l\'infini (lemme de Riemann-Lebesgue).',
              indication:
                  'Pour la continuité, utiliser la convergence dominée. '
                  'Pour le lemme de R-L, approcher \$f\$ par des fonctions en escalier.',
              correction:
                  'Ce qu\'on nous demande : deux propriétés fondamentales de la transformée de Fourier dans \$L^1\$.\n\n'
                  'Rappel : \$f \\in L^1(\\mathbb{R})\$ signifie \$\\int_{\\mathbb{R}} |f(x)| dx < \\infty\$.\n\n'
                  'Continuité : soit \$\\xi_n \\to \\xi\$. Alors \$f(x) e^{-2i\\pi \\xi_n x} \\to f(x) e^{-2i\\pi \\xi x}\$ pour tout \$x\$, et \$|f(x) e^{-2i\\pi \\xi_n x}| = |f(x)| \\in L^1\$. Par convergence dominée, \$\\hat{f}(\\xi_n) \\to \\hat{f}(\\xi)\$.\n'
                  'Lemme de Riemann-Lebesgue : pour \$f = \\mathbf{1}_{[a,b]}\$, \$\\hat{f}(\\xi) = \\frac{e^{-2i\\pi b\\xi} - e^{-2i\\pi a\\xi}}{-2i\\pi \\xi} \\to 0\$ quand \$|\\xi| \\to \\infty\$.\n'
                  'Par linéarité, le résultat vaut pour les fonctions en escalier. Comme celles-ci sont denses dans \$L^1\$, et \$\\|\\hat{f}\\|_\\infty \\leq \\|f\\|_1\$, le résultat s\'étend à tout \$L^1\$ par densité.\n'
                  'Plus précisément : pour tout \$\\varepsilon > 0\$, il existe \$g\$ en escalier avec \$\\|f-g\\|_1 < \\varepsilon/2\$, puis \$|\\hat{f}(\\xi)| \\leq |\\hat{g}(\\xi)| + \\varepsilon/2 \\to \\varepsilon/2\$ quand \$|\\xi| \\to \\infty\$.\n'
                  'Conclusion : \$\\hat{f} \\in C_0(\\mathbb{R})\$ (continue, tendant vers 0 à l\'infini).\n\n'
                  'Attention : le lemme de Riemann-Lebesgue est FAUX pour \$f \\in L^2 \\setminus L^1\$ en général. L\'hypothèse \$L^1\$ est cruciale.',
              points: 4,
              rapportJury:
                  'Le jury attend une preuve du lemme par densité des fonctions en escalier, pas un simple « admis ».',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(f_n)\$ une suite de fonctions mesurables sur \$[0,1]\$ telle que '
                  '\$f_n \\to f\$ presque partout et \$\\int_0^1 |f_n|^2 \\leq C\$ pour tout \$n\$. '
                  'Montrer que \$\\int_0^1 f_n g \\to \\int_0^1 f g\$ pour toute \$g \\in L^2([0,1])\$.',
              indication:
                  'Utiliser la convergence faible dans \$L^2\$. '
                  'Montrer que \$f \\in L^2\$ par Fatou, puis conclure.',
              correction:
                  'Ce qu\'on nous demande : prouver la convergence faible dans \$L^2\$ sous les hypothèses données.\n\n'
                  'Rappel : on dit que \$f_n \\rightharpoonup f\$ faiblement dans \$L^2\$ si \$\\langle f_n, g \\rangle \\to \\langle f, g \\rangle\$ pour tout \$g \\in L^2\$.\n\n'
                  'D\'abord, \$f \\in L^2\$ : par Fatou, \$\\int |f|^2 = \\int \\liminf |f_n|^2 \\leq \\liminf \\int |f_n|^2 \\leq C\$.\n'
                  'Pour \$g = \\mathbf{1}_A\$ (indicatrice d\'un mesurable) : \$\\int_A f_n \\to \\int_A f\$ par convergence dominée (car \$|f_n \\mathbf{1}_A| \\leq |f_n|\$ et on peut utiliser Egorov).\n'
                  'Par linéarité, le résultat s\'étend aux fonctions étagées, puis par densité des étagées dans \$L^2\$ et la borne uniforme \$\\|f_n\\|_2 \\leq \\sqrt{C}\$.\n'
                  'En détail : pour \$g \\in L^2\$ et \$\\varepsilon > 0\$, on prend \$h\$ étagée avec \$\\|g-h\\|_2 < \\varepsilon\$. Alors \$|\\int f_n g - \\int f g| \\leq |\\int f_n h - \\int f h| + (\\|f_n\\|_2 + \\|f\\|_2)\\|g-h\\|_2\$.\n'
                  'Le premier terme \$\\to 0\$ et le second \$\\leq 2\\sqrt{C}\\varepsilon\$, d\'où le résultat.\n\n'
                  'Attention : convergence faible dans \$L^2\$ n\'implique PAS convergence forte (\$\\|f_n - f\\|_2 \\to 0\$). C\'est une convergence plus faible mais très utile en analyse fonctionnelle.',
              points: 4,
              rapportJury:
                  'Question technique. Le jury vérifie la maîtrise de la convergence faible et de l\'argument de densité.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Probabilités',
          introduction:
              'Cette partie porte sur la convergence en loi, les fonctions caractéristiques, '
              'le théorème central limite et la loi des grands nombres.',
          bareme: 6,
          themes: ['Convergence en loi', 'Fonctions caractéristiques', 'TCL', 'LGN'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire de loi \$\\mathcal{N}(0,1)\$. '
                  'Calculer sa fonction caractéristique \$\\varphi_X(t) = E[e^{itX}]\$.',
              indication:
                  'Calculer l\'intégrale gaussienne en complétant le carré dans l\'exponentielle.',
              correction:
                  'Ce qu\'on nous demande : calculer \$\\varphi_X(t) = E[e^{itX}]\$ pour \$X \\sim \\mathcal{N}(0,1)\$.\n\n'
                  'Rappel : la densité de \$\\mathcal{N}(0,1)\$ est \$f(x) = \\frac{1}{\\sqrt{2\\pi}} e^{-x^2/2}\$.\n\n'
                  '\$\\varphi_X(t) = \\frac{1}{\\sqrt{2\\pi}} \\int_{-\\infty}^{+\\infty} e^{itx} e^{-x^2/2} dx = \\frac{1}{\\sqrt{2\\pi}} \\int e^{-(x^2 - 2itx)/2} dx\$.\n'
                  'On complète le carré : \$x^2 - 2itx = (x - it)^2 + t^2\$, donc l\'intégrale vaut \$e^{-t^2/2} \\cdot \\frac{1}{\\sqrt{2\\pi}} \\int e^{-(x-it)^2/2} dx\$.\n'
                  'Par le théorème de Cauchy (ou par translation dans \$\\mathbb{R}\$ car le résultat de l\'intégrale gaussienne est \$\\sqrt{2\\pi}\$), \$\\int e^{-(x-it)^2/2} dx = \\sqrt{2\\pi}\$.\n'
                  'Conclusion : \$\\varphi_X(t) = e^{-t^2/2}\$.\n'
                  'Vérification : \$\\varphi_X(0) = 1\$ ✓, \$\\varphi_X\'(0) = 0 = iE[X]\$ ✓, \$\\varphi_X\'\'(0) = -1 = -E[X^2]\$ ✓.\n\n'
                  'Attention : la justification rigoureuse du changement de contour (passage de \$\\mathbb{R}\$ à \$\\mathbb{R} + it\$) utilise l\'analyse complexe. En concours, la complétion du carré suffit généralement.',
              points: 3,
              rapportJury:
                  'Calcul fondamental. Le jury attend la complétion du carré et les vérifications.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer le théorème central limite. Donner un exemple d\'application '
                  'au calcul approché d\'une probabilité.',
              indication:
                  'Penser à une somme de \$n\$ variables de Bernoulli pour l\'application numérique.',
              correction:
                  'Ce qu\'on nous demande : énoncer le TCL et l\'illustrer concrètement.\n\n'
                  'Rappel (TCL) : soient \$(X_i)\$ i.i.d. de moyenne \$\\mu\$ et variance \$\\sigma^2 > 0\$. Alors \$\\frac{\\bar{X}_n - \\mu}{\\sigma / \\sqrt{n}} \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$ où \$\\bar{X}_n = \\frac{1}{n}\\sum_{i=1}^n X_i\$.\n\n'
                  'Autrement dit : \$\\frac{S_n - n\\mu}{\\sigma\\sqrt{n}} \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$ où \$S_n = \\sum X_i\$.\n'
                  'Application : soit \$S_{100}\$ le nombre de piles en 100 lancers d\'une pièce équilibrée (\$X_i \\sim \\text{Bernoulli}(1/2)\$, \$\\mu = 1/2\$, \$\\sigma^2 = 1/4\$).\n'
                  '\$P(S_{100} \\leq 55) = P\\left(\\frac{S_{100} - 50}{5} \\leq 1\\right) \\approx \\Phi(1) \\approx 0.8413\$.\n'
                  'Donc il y a environ 84\\% de chances d\'obtenir au plus 55 piles en 100 lancers.\n'
                  'La preuve du TCL utilise les fonctions caractéristiques : on montre que \$\\varphi_{Z_n}(t) \\to e^{-t^2/2}\$ (f.c. de \$\\mathcal{N}(0,1)\$) via un DL de \$\\varphi_{X_1}\$ à l\'ordre 2.\n\n'
                  'Attention : le TCL nécessite que \$\\sigma^2 < \\infty\$. Pour des variables à variance infinie (ex. loi de Cauchy), le TCL ne s\'applique pas.',
              points: 4,
              rapportJury:
                  'Le jury valorise un exemple numérique concret et la mention des hypothèses du TCL.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer la loi forte des grands nombres.',
              indication:
                  'Utiliser l\'inégalité de Markov et le lemme de Borel-Cantelli. '
                  'On peut se restreindre au cas où \$E[X_1^4] < \\infty\$ pour simplifier.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$\\bar{X}_n \\to \\mu\$ presque sûrement.\n\n'
                  'Rappel (LFGN) : si \$(X_i)\$ sont i.i.d. intégrables (\$E[|X_1|] < \\infty\$), alors \$\\bar{X}_n = \\frac{1}{n}\\sum_{i=1}^n X_i \\xrightarrow{p.s.} E[X_1]\$.\n\n'
                  'Preuve simplifiée (cas \$E[X_1^4] < \\infty\$, WLOG \$\\mu = 0\$) : on calcule \$E[(S_n)^4]\$ où \$S_n = \\sum X_i\$.\n'
                  'En développant, les termes croisés s\'annulent par indépendance, et \$E[S_n^4] = nE[X^4] + 3n(n-1)(E[X^2])^2 = O(n^2)\$.\n'
                  'Par Markov : \$P(|\\bar{X}_n| > \\varepsilon) = P(|S_n| > n\\varepsilon) \\leq \\frac{E[S_n^4]}{n^4 \\varepsilon^4} = O(1/n^2)\$.\n'
                  'La série \$\\sum P(|\\bar{X}_n| > \\varepsilon)\$ converge. Par Borel-Cantelli, \$P(|\\bar{X}_n| > \\varepsilon \\text{ i.o.}) = 0\$.\n'
                  'En faisant \$\\varepsilon \\to 0\$ (par dénombrabilité) : \$\\bar{X}_n \\to 0\$ p.s.\n'
                  'La preuve générale (seulement \$E[|X_1|] < \\infty\$) est plus technique et utilise la troncature.\n\n'
                  'Attention : la loi FAIBLE (convergence en probabilité) ne nécessite que \$\\sigma^2 < \\infty\$ et se prouve simplement par Tchebychev. La loi FORTE est beaucoup plus puissante.',
              points: 4,
              rapportJury:
                  'Le jury accepte la preuve simplifiée sous \$L^4\$ mais valorise la connaissance de la preuve générale.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la convergence presque sûre implique la convergence en probabilité, '
                  'mais que la réciproque est fausse.',
              indication:
                  'Pour l\'implication, utiliser la définition. Pour le contre-exemple, '
                  'penser aux sous-intervalles de \$[0,1]\$ qui « se promènent ».',
              correction:
                  'Ce qu\'on nous demande : comparer convergence p.s. et convergence en probabilité.\n\n'
                  'Rappel : \$X_n \\xrightarrow{p.s.} X\$ ssi \$P(\\{\\omega : X_n(\\omega) \\to X(\\omega)\\}) = 1\$. \$X_n \\xrightarrow{P} X\$ ssi \$\\forall \\varepsilon > 0,\\, P(|X_n - X| > \\varepsilon) \\to 0\$.\n\n'
                  'p.s. ⟹ en proba : soit \$A = \\{\\omega : X_n(\\omega) \\to X(\\omega)\\}\$ avec \$P(A) = 1\$. Pour \$\\varepsilon > 0\$, \$\\{|X_n - X| > \\varepsilon\\} \\subset A^c \\cup \\{\\omega \\in A : |X_n(\\omega) - X(\\omega)| > \\varepsilon\\}\$.\n'
                  'Le premier a probabilité 0, et pour \$\\omega \\in A\$, \$X_n(\\omega) \\to X(\\omega)\$ donc l\'événement est vide pour \$n\$ assez grand. Par convergence dominée, \$P(|X_n - X| > \\varepsilon) \\to 0\$.\n'
                  'Contre-exemple (réciproque fausse) : sur \$\\Omega = [0,1]\$ avec la mesure de Lebesgue, définir \$X_n = \\mathbf{1}_{I_n}\$ où \$I_n\$ parcourt cycliquement les sous-intervalles de longueur \$1/k\$ (\$n = k(k-1)/2 + j\$, \$I_n = [j/k, (j+1)/k]\$).\n'
                  'Alors \$P(X_n = 1) = 1/k \\to 0\$ donc \$X_n \\xrightarrow{P} 0\$. Mais pour tout \$\\omega\$, \$X_n(\\omega) = 1\$ infiniment souvent (i.o.), donc \$X_n \\not\\to 0\$ p.s.\n'
                  'Intuition : en probabilité, on demande que les « gros écarts » soient de plus en plus rares. La convergence p.s. demande qu\'ils disparaissent définitivement.\n\n'
                  'Attention : l\'ajout d\'une sous-suite convergente p.s. est toujours possible (théorème). La convergence en probabilité implique l\'existence d\'une sous-suite convergeant p.s.',
              points: 3,
              rapportJury:
                  'Le jury attend un contre-exemple explicite, pas seulement l\'affirmation « la réciproque est fausse ».',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer le lemme de Borel-Cantelli (les deux parties) et donner une '
                  'application au comportement asymptotique d\'une suite de v.a.',
              indication:
                  'BC1 : si \$\\sum P(A_n) < \\infty\$ alors \$P(\\limsup A_n) = 0\$. '
                  'BC2 : si les \$A_n\$ sont indépendants et \$\\sum P(A_n) = \\infty\$ alors \$P(\\limsup A_n) = 1\$.',
              correction:
                  'Ce qu\'on nous demande : énoncer BC1 et BC2, et les appliquer.\n\n'
                  'Rappel : \$\\limsup A_n = \\bigcap_{n \\geq 1} \\bigcup_{k \\geq n} A_k = \\{A_n \\text{ i.o.}\\}\$ (les événements qui se réalisent infiniment souvent).\n\n'
                  'BC1 : si \$\\sum_{n=1}^\\infty P(A_n) < \\infty\$, alors \$P(A_n \\text{ i.o.}) = 0\$. Preuve : \$P(\\bigcup_{k \\geq n} A_k) \\leq \\sum_{k \\geq n} P(A_k) \\to 0\$ (reste d\'une série convergente). Par continuité décroissante, \$P(\\limsup A_n) = 0\$.\n'
                  'BC2 : si les \$A_n\$ sont mutuellement indépendants et \$\\sum P(A_n) = +\\infty\$, alors \$P(A_n \\text{ i.o.}) = 1\$. Preuve : \$P(\\bigcap_{k=n}^{N} A_k^c) = \\prod_{k=n}^{N}(1-P(A_k)) \\leq \\prod e^{-P(A_k)} = e^{-\\sum_{k=n}^{N} P(A_k)} \\to 0\$.\n'
                  'Application : soient \$X_n\$ i.i.d. uniformes sur \$[0,1]\$. Est-ce que \$X_n < 1/n\$ infiniment souvent ?\n'
                  '\$P(X_n < 1/n) = 1/n\$ et \$\\sum 1/n = +\\infty\$. Les événements sont indépendants. Par BC2, \$P(X_n < 1/n \\text{ i.o.}) = 1\$.\n'
                  'Mais \$P(X_n < 1/n^2) = 1/n^2\$ et \$\\sum 1/n^2 < \\infty\$. Par BC1, \$P(X_n < 1/n^2 \\text{ i.o.}) = 0\$.\n\n'
                  'Attention : BC2 nécessite l\'indépendance ! Sans elle, le résultat est faux. Contre-exemple : \$A_n = A\$ constant avec \$P(A) = 1/2\$.',
              points: 3,
              rapportJury:
                  'Le jury attend les deux parties avec preuve de BC1 au minimum, et un exemple d\'application.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2024 – Épreuve 1
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2024EP1() {
    return Annale(
      id: 'ped_int_2024_ep1',
      annee: 2024,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2024 – Épreuve 1 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 1 de l\'agrégation interne 2024. '
          'Algèbre linéaire, géométrie, analyse et équations différentielles.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Analyse', 'Équations différentielles'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep1/24-ep1.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Diagonalisation', 'Isométries', 'Coniques', 'Séries numériques', 'Équations différentielles'],
      rapportGlobal:
          'L\'épreuve 1 de l\'interne couvre algèbre, géométrie et analyse. '
          'Chaque question est expliquée pas à pas avec bienveillance.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre linéaire',
          introduction:
              'Cette partie porte sur le calcul de valeurs propres, la diagonalisation, '
              'le théorème de Cayley-Hamilton et la trigonalisation.',
          bareme: 5,
          themes: ['Matrices', 'Valeurs propres', 'Diagonalisation'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$A = \\begin{pmatrix} 2 & 1 & 0 \\\\ 0 & 2 & 1 \\\\ 0 & 0 & 3 \\end{pmatrix}\$. '
                  'Déterminer les valeurs propres de \$A\$ et les sous-espaces propres associés.',
              indication:
                  '\$A\$ est triangulaire supérieure : ses valeurs propres se lisent sur la diagonale.',
              correction:
                  'Ce qu\'on nous demande : trouver les valeurs propres et sous-espaces propres d\'une matrice triangulaire.\n\n'
                  'Rappel : pour une matrice triangulaire, les valeurs propres sont les coefficients diagonaux. Le polynôme caractéristique est \$\\chi_A(\\lambda) = \\prod_i (a_{ii} - \\lambda)\$.\n\n'
                  'Ici \$\\chi_A(\\lambda) = (2-\\lambda)^2(3-\\lambda)\$. Les valeurs propres sont \$\\lambda_1 = 2\$ (multiplicité 2) et \$\\lambda_2 = 3\$ (multiplicité 1).\n'
                  'Pour \$\\lambda_1 = 2\$ : \$\\ker(A - 2I) = \\ker\\begin{pmatrix} 0 & 1 & 0 \\\\ 0 & 0 & 1 \\\\ 0 & 0 & 1 \\end{pmatrix} = \\text{Vect}((1,0,0))\$. Dimension 1.\n'
                  'Pour \$\\lambda_2 = 3\$ : \$\\ker(A - 3I) = \\ker\\begin{pmatrix} -1 & 1 & 0 \\\\ 0 & -1 & 1 \\\\ 0 & 0 & 0 \\end{pmatrix} = \\text{Vect}((1,1,1))\$. Dimension 1.\n'
                  'Somme des dimensions : \$1 + 1 = 2 < 3\$. Donc \$A\$ n\'est PAS diagonalisable (la multiplicité géométrique de \$\\lambda_1 = 2\$ est 1, inférieure à sa multiplicité algébrique 2).\n'
                  'La matrice \$A\$ est déjà sous forme de Jordan (un bloc \$J_2(2)\$ et un bloc \$J_1(3)\$).\n\n'
                  'Attention : une matrice triangulaire n\'est pas forcément diagonalisable ! Il faut toujours vérifier que la dimension de chaque espace propre égale la multiplicité algébrique.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul explicite des espaces propres et la conclusion sur la non-diagonalisabilité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A\$ une matrice \$n \\times n\$ réelle. Énoncer et démontrer le théorème de Cayley-Hamilton.',
              indication:
                  'Le théorème affirme que \$\\chi_A(A) = 0\$. Pour la preuve, '
                  'utiliser la matrice des cofacteurs de \$A - XI_n\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que toute matrice annule son polynôme caractéristique.\n\n'
                  'Rappel : \$\\chi_A(X) = \\det(XI_n - A)\$ est un polynôme de degré \$n\$. Le théorème dit \$\\chi_A(A) = 0_{n \\times n}\$.\n\n'
                  'Soit \$B(X) = \\text{Com}(XI_n - A)^T\$ la comatrice (matrice des cofacteurs transposée). Par la formule \$M \\cdot \\text{Com}(M)^T = \\det(M) I\$ :\n'
                  '\$(XI_n - A) \\cdot B(X) = \\det(XI_n - A) \\cdot I_n = \\chi_A(X) \\cdot I_n\$.\n'
                  '\$B(X)\$ est une matrice de polynômes de degré \$\\leq n-1\$ : écrivons \$B(X) = B_0 + B_1 X + \\cdots + B_{n-1} X^{n-1}\$.\n'
                  'En identifiant les puissances de \$X\$ dans \$(XI_n - A)(B_0 + B_1 X + \\cdots) = \\chi_A(X) I_n\$, on obtient des relations entre les \$B_k\$ et les coefficients de \$\\chi_A\$.\n'
                  'En multipliant chaque relation par la puissance appropriée de \$A\$ et en sommant, tout se télescope et on obtient \$\\chi_A(A) = 0\$.\n'
                  'Conséquence : le polynôme minimal de \$A\$ divise \$\\chi_A\$.\n\n'
                  'Attention : on ne peut PAS simplement « remplacer \$X\$ par \$A\$ » dans \$\\det(XI_n - A) = 0\$, car le déterminant ne commute pas avec la substitution matricielle de cette façon.',
              points: 4,
              rapportJury:
                  'Le jury sanctionne la « preuve » fausse par substitution directe. L\'argument par la comatrice est attendu.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que deux matrices semblables ont même trace, même déterminant '
                  'et même polynôme caractéristique.',
              indication:
                  'Si \$B = P^{-1}AP\$, calculer \$\\det(XI_n - B)\$ et utiliser les propriétés '
                  'de \$\\text{tr}\$ et \$\\det\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que trace, déterminant et polynôme caractéristique sont des invariants de similitude.\n\n'
                  'Rappel : \$A\$ et \$B\$ sont semblables ssi \$\\exists P\$ inversible telle que \$B = P^{-1}AP\$. Cela signifie qu\'elles représentent le même endomorphisme dans des bases différentes.\n\n'
                  'Polynôme caractéristique : \$\\chi_B(X) = \\det(XI - B) = \\det(XI - P^{-1}AP) = \\det(P^{-1}(XI - A)P) = \\det(P^{-1})\\det(XI-A)\\det(P) = \\chi_A(X)\$.\n'
                  'Trace : \$\\text{tr}(B) = \\text{tr}(P^{-1}AP) = \\text{tr}(APP^{-1}) = \\text{tr}(A)\$ (par cyclicité de la trace).\n'
                  'Alternativement, \$\\text{tr}(A)\$ est la somme des valeurs propres = coefficient de \$X^{n-1}\$ dans \$\\chi_A\$ (à signe près), qui est invariant.\n'
                  'Déterminant : \$\\det(B) = \\det(P^{-1}AP) = \\det(A)\$ (par multiplicativité). C\'est aussi le produit des valeurs propres = \$(-1)^n \\chi_A(0)\$.\n'
                  'En résumé, comme \$\\chi_A = \\chi_B\$, tous les coefficients du polynôme caractéristique sont des invariants, dont la trace et le déterminant.\n\n'
                  'Attention : la réciproque est fausse ! Deux matrices avec même polynôme caractéristique ne sont pas forcément semblables (ex : \$I_2\$ et \$\\begin{pmatrix} 1 & 1 \\\\ 0 & 1 \\end{pmatrix}\$).',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve pour le polynôme caractéristique, dont trace et déterminant découlent.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A \\in \\mathcal{M}_n(\\mathbb{C})\$. Montrer que \$A\$ '
                  'est trigonalisable. En déduire que si \$A^k = 0\$ pour un \$k \\geq 1\$, '
                  'alors les valeurs propres de \$A\$ sont toutes nulles.',
              indication:
                  'Pour la trigonalisation sur \$\\mathbb{C}\$, raisonner par récurrence '
                  'en utilisant l\'existence d\'au moins une valeur propre.',
              correction:
                  'Ce qu\'on nous demande : (1) toute matrice complexe est trigonalisable, (2) application aux matrices nilpotentes.\n\n'
                  'Rappel : \$A\$ est trigonalisable ssi elle est semblable à une matrice triangulaire supérieure. Sur \$\\mathbb{C}\$, tout polynôme est scindé.\n\n'
                  'Preuve par récurrence sur \$n\$. Pour \$n = 1\$ : trivial. Supposons le résultat vrai en dimension \$n-1\$.\n'
                  'Sur \$\\mathbb{C}\$, \$\\chi_A\$ admet au moins une racine \$\\lambda\$. Soit \$v\$ un vecteur propre associé. On complète \$v\$ en une base \$(v, v_2, \\ldots, v_n)\$.\n'
                  'Dans cette base, la matrice de \$A\$ est \$\\begin{pmatrix} \\lambda & * \\\\ 0 & A\' \\end{pmatrix}\$ où \$A\' \\in \\mathcal{M}_{n-1}(\\mathbb{C})\$.\n'
                  'Par hypothèse de récurrence, \$A\'\$ est trigonalisable. On conclut que \$A\$ est trigonalisable.\n'
                  'Application : si \$A^k = 0\$ et \$\\lambda\$ est valeur propre de \$A\$ avec vecteur propre \$v\$, alors \$A^k v = \\lambda^k v = 0\$, donc \$\\lambda^k = 0\$ et \$\\lambda = 0\$.\n\n'
                  'Attention : sur \$\\mathbb{R}\$, la trigonalisation n\'est pas toujours possible (ex : matrice de rotation d\'angle \$\\pi/2\$). C\'est spécifique à \$\\mathbb{C}\$ (corps algébriquement clos).',
              points: 3,
              rapportJury:
                  'Le jury attend la récurrence proprement rédigée et l\'application immédiate aux nilpotentes.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$u\$ un endomorphisme de \$\\mathbb{R}^n\$ tel que \$u^2 = -\\text{Id}\$. '
                  'Que peut-on dire de \$n\$ ? Trouver les valeurs propres complexes de \$u\$.',
              indication:
                  'Considérer le polynôme minimal et ses racines complexes. '
                  'Que vaut \$\\det(u)\$ ?',
              correction:
                  'Ce qu\'on nous demande : étudier un endomorphisme vérifiant \$u^2 = -\\text{Id}\$ (structure complexe).\n\n'
                  'Rappel : le polynôme \$X^2 + 1\$ annule \$u\$, donc le polynôme minimal divise \$X^2 + 1\$. Comme \$X^2 + 1\$ est irréductible sur \$\\mathbb{R}\$, \$\\pi_u(X) = X^2 + 1\$.\n\n'
                  'Valeurs propres complexes : les racines de \$X^2 + 1 = 0\$ sont \$i\$ et \$-i\$. Les valeurs propres complexes de \$u\$ sont donc \$i\$ et \$-i\$.\n'
                  'Comme \$\\chi_u\$ est à coefficients réels, \$i\$ et \$-i\$ ont la même multiplicité. Donc \$n\$ est pair (\$n = 2m\$).\n'
                  'On a \$\\det(u)^2 = \\det(u^2) = \\det(-\\text{Id}) = (-1)^n\$. Pour que \$\\det(u)^2 > 0\$, il faut \$(-1)^n > 0\$, donc \$n\$ pair. Confirmation : \$\\det(u) = i^m \\cdot (-i)^m = 1\$.\n'
                  'Conclusion : \$n\$ est nécessairement pair. L\'exemple classique est la rotation de \$\\pi/2\$ en dimension 2 : \$u(x,y) = (-y, x)\$.\n'
                  'En dimension \$2m\$, \$u\$ est conjuguée (sur \$\\mathbb{R}\$) à un bloc diagonal de \$m\$ rotations de \$\\pi/2\$.\n\n'
                  'Attention : \$u\$ n\'a PAS de valeur propre réelle (car \$\\lambda^2 = -1\$ est impossible dans \$\\mathbb{R}\$). L\'endomorphisme \$u\$ est appelé « structure complexe » sur \$\\mathbb{R}^n\$.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'argument de parité de \$n\$ via les racines complexes conjuguées.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Géométrie',
          introduction:
              'Cette partie porte sur les isométries du plan, les coniques '
              'et les transformations affines.',
          bareme: 5,
          themes: ['Isométries', 'Coniques', 'Transformations affines'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Classifier les isométries du plan euclidien. '
                  'Montrer que toute isométrie est une rotation, une translation, '
                  'une réflexion ou une réflexion glissée.',
              indication:
                  'Décomposer une isométrie en sa partie linéaire (orthogonale) '
                  'et sa partie translation. Distinguer \$\\det = 1\$ et \$\\det = -1\$.',
              correction:
                  'Ce qu\'on nous demande : classifier les quatre types d\'isométries du plan.\n\n'
                  'Rappel : une isométrie \$f\$ du plan s\'écrit \$f(x) = Ax + b\$ où \$A \\in O_2(\\mathbb{R})\$ et \$b \\in \\mathbb{R}^2\$.\n\n'
                  'Cas \$\\det(A) = 1\$ : \$A\$ est une rotation d\'angle \$\\theta\$. Si \$\\theta = 0\$ (i.e. \$A = I\$), \$f\$ est une translation de vecteur \$b\$.\n'
                  'Si \$\\theta \\neq 0\$, \$I - A\$ est inversible (car 1 n\'est pas v.p. de \$A\$), donc \$f\$ a un point fixe \$c = (I-A)^{-1}b\$ et \$f\$ est la rotation de centre \$c\$ et d\'angle \$\\theta\$.\n'
                  'Cas \$\\det(A) = -1\$ : \$A\$ est une réflexion par rapport à une droite vectorielle \$D\$. Si \$f\$ a un point fixe, c\'est une réflexion (symétrie axiale).\n'
                  'Si \$f\$ n\'a pas de point fixe, on décompose \$b = b_\\parallel + b_\\perp\$ selon \$D\$ et \$D^\\perp\$. Alors \$f\$ est la composée de la réflexion d\'axe \$D\'\$ (parallèle à \$D\$ passant par le bon point) et de la translation de vecteur \$b_\\parallel\$ : c\'est une réflexion glissée.\n'
                  'Ces 4 types épuisent toutes les isométries du plan.\n\n'
                  'Attention : en dimension 3, la classification est plus riche (on a aussi les vissages). En dimension 2, les 4 types suffisent.',
              points: 4,
              rapportJury:
                  'Le jury attend une classification rigoureuse avec distinction des cas selon le déterminant et l\'existence de points fixes.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la composée de deux réflexions d\'axes sécants est une rotation, '
                  'et déterminer son centre et son angle.',
              indication:
                  'Si les axes se coupent en \$O\$ avec un angle \$\\alpha\$, '
                  'la composée est une rotation de centre \$O\$ et d\'angle \$2\\alpha\$.',
              correction:
                  'Ce qu\'on nous demande : étudier la composée de deux réflexions dont les axes se coupent.\n\n'
                  'Rappel : une réflexion \$s_D\$ d\'axe \$D\$ est une isométrie de déterminant \$-1\$. La composée de deux isométries de déterminant \$-1\$ est de déterminant \$1\$ (une isométrie directe).\n\n'
                  'Soient \$D_1\$ et \$D_2\$ deux droites se coupant en \$O\$ avec un angle \$\\alpha\$ (mesuré de \$D_1\$ vers \$D_2\$).\n'
                  'Le point \$O \\in D_1 \\cap D_2\$ est fixé par \$s_{D_1}\$ et par \$s_{D_2}\$, donc par \$s_{D_2} \\circ s_{D_1}\$. C\'est le centre de la rotation.\n'
                  'L\'angle : \$s_{D_2} \\circ s_{D_1}\$ est de déterminant \$(-1)(-1) = 1\$, c\'est une rotation. Son angle est \$2\\alpha\$ (le double de l\'angle entre les axes).\n'
                  'Preuve : en choisissant un repère centré en \$O\$ avec \$D_1\$ comme axe des abscisses, \$s_{D_1}\$ est la réflexion d\'axe horizontal et \$s_{D_2}\$ est la réflexion d\'axe faisant l\'angle \$\\alpha\$. Le calcul matriciel donne \$s_{D_2} s_{D_1} = R_{2\\alpha}\$.\n'
                  'Réciproque : toute rotation peut s\'écrire comme composée de deux réflexions (on choisit le premier axe arbitrairement).\n\n'
                  'Attention : l\'ordre des réflexions compte ! \$s_{D_2} \\circ s_{D_1}\$ est une rotation d\'angle \$+2\\alpha\$, tandis que \$s_{D_1} \\circ s_{D_2}\$ est une rotation d\'angle \$-2\\alpha\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la détermination de l\'angle \$2\\alpha\$ avec justification, pas seulement l\'énoncé.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit la conique d\'équation \$x^2 + 4xy + 4y^2 - 2x + y - 1 = 0\$. '
                  'Déterminer sa nature et la mettre sous forme réduite.',
              indication:
                  'Étudier la matrice associée à la partie quadratique. '
                  'Calculer son déterminant pour identifier la nature.',
              correction:
                  'Ce qu\'on nous demande : identifier la conique (ellipse, hyperbole, parabole ou dégénérée) et la simplifier.\n\n'
                  'Rappel : pour \$ax^2 + 2bxy + cy^2 + dx + ey + f = 0\$, la nature dépend de \$\\Delta = ac - b^2\$ : \$\\Delta > 0\$ ellipse, \$\\Delta < 0\$ hyperbole, \$\\Delta = 0\$ parabole (ou cas dégénéré).\n\n'
                  'Ici \$a = 1, 2b = 4 \\Rightarrow b = 2, c = 4\$. Donc \$\\Delta = 1 \\times 4 - 2^2 = 0\$. C\'est une parabole (ou cas dégénéré).\n'
                  'La partie quadratique : \$Q(x,y) = x^2 + 4xy + 4y^2 = (x + 2y)^2\$. C\'est un carré parfait !\n'
                  'Posons \$u = x + 2y\$ et \$v = 2x - y\$ (rotation + homothétie pour orthogonaliser). On a \$x = \\frac{u + 2v}{5}\$, \$y = \\frac{2u - v}{5}\$.\n'
                  'En substituant : \$u^2 + \\text{termes linéaires} = 0\$, ce qui donne après simplification une équation de la forme \$u^2 = \\alpha v + \\beta\$.\n'
                  'Après translation, on obtient la forme réduite \$U^2 = 2pV\$ : c\'est bien une parabole de paramètre \$p\$.\n\n'
                  'Attention : quand \$\\Delta = 0\$, il peut y avoir des cas dégénérés (deux droites parallèles, une droite double, ou l\'ensemble vide). Il faut vérifier avec les termes linéaires.',
              points: 4,
              rapportJury:
                  'Le jury attend le calcul de \$\\Delta\$, l\'identification de la nature, et les étapes de réduction.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A, B, C\$ trois points du plan. Montrer que le barycentre \$G\$ '
                  'de \$(A, 1), (B, 1), (C, 1)\$ est le centre de gravité du triangle \$ABC\$ '
                  'et qu\'il vérifie \$\\vec{GA} + \\vec{GB} + \\vec{GC} = \\vec{0}\$.',
              indication:
                  'Utiliser la définition du barycentre et la relation vectorielle caractéristique.',
              correction:
                  'Ce qu\'on nous demande : prouver la propriété fondamentale du centre de gravité d\'un triangle.\n\n'
                  'Rappel : le barycentre de \$(A_i, \\alpha_i)\$ est le point \$G\$ tel que \$\\sum \\alpha_i \\vec{GA_i} = \\vec{0}\$, à condition que \$\\sum \\alpha_i \\neq 0\$.\n\n'
                  'Ici les poids sont tous 1 et \$\\sum \\alpha_i = 3 \\neq 0\$. Par définition : \$1 \\cdot \\vec{GA} + 1 \\cdot \\vec{GB} + 1 \\cdot \\vec{GC} = \\vec{0}\$.\n'
                  'En coordonnées : si \$A = (x_A, y_A)\$, etc., alors \$G = \\frac{1}{3}(A + B + C) = \\left(\\frac{x_A+x_B+x_C}{3}, \\frac{y_A+y_B+y_C}{3}\\right)\$.\n'
                  'Vérification : \$\\vec{GA} = A - G = A - \\frac{A+B+C}{3} = \\frac{2A-B-C}{3}\$. De même pour \$\\vec{GB}\$ et \$\\vec{GC}\$. Somme : \$\\frac{2A-B-C+2B-A-C+2C-A-B}{3} = \\vec{0}\$ ✓.\n'
                  'Propriété : \$G\$ est l\'intersection des médianes du triangle. Il divise chaque médiane dans le rapport \$2:1\$ depuis le sommet.\n'
                  'Le barycentre est un point affine (il ne dépend pas du repère choisi), c\'est un invariant affine.\n\n'
                  'Attention : le barycentre n\'existe que si la somme des poids est non nulle. Si \$\\sum \\alpha_i = 0\$, on obtient un vecteur, pas un point.',
              points: 3,
              rapportJury:
                  'Question de base. Le jury attend la vérification vectorielle et la connaissance des propriétés géométriques du centre de gravité.',
            ),
            QuestionAnnale(
              enonce:
                  'Donner l\'équation réduite d\'une ellipse de demi-axes \$a\$ et \$b\$. '
                  'Calculer son aire et montrer que l\'excentricité vérifie \$0 \\leq e < 1\$.',
              indication:
                  'L\'aire s\'obtient par changement de variable affine à partir du cercle. '
                  'L\'excentricité est \$e = c/a\$ avec \$c^2 = a^2 - b^2\$ (si \$a > b\$).',
              correction:
                  'Ce qu\'on nous demande : les propriétés fondamentales de l\'ellipse.\n\n'
                  'Rappel : l\'équation réduite de l\'ellipse (centre à l\'origine, axes sur les axes de coordonnées) est \$\\frac{x^2}{a^2} + \\frac{y^2}{b^2} = 1\$ avec \$a \\geq b > 0\$.\n\n'
                  'Aire : le changement de variable \$x = au,\\, y = bv\$ transforme l\'ellipse en le cercle unité \$u^2 + v^2 \\leq 1\$. Le jacobien est \$ab\$, donc \$\\text{Aire} = ab \\times \\pi r^2 = \\pi ab\$ (avec \$r = 1\$).\n'
                  'Excentricité : les foyers sont \$F_1 = (-c, 0)\$ et \$F_2 = (c, 0)\$ avec \$c^2 = a^2 - b^2\$ (car \$a \\geq b\$). L\'excentricité est \$e = c/a\$.\n'
                  'Comme \$c^2 = a^2 - b^2 \\geq 0\$ et \$c < a\$ (car \$b > 0\$), on a \$0 \\leq c/a < 1\$, donc \$0 \\leq e < 1\$.\n'
                  'Cas limites : \$e = 0 \\Leftrightarrow c = 0 \\Leftrightarrow a = b\$ (cercle). Quand \$e \\to 1\$, \$b \\to 0\$ (l\'ellipse dégénère en un segment).\n'
                  'Propriété focale : pour tout point \$M\$ de l\'ellipse, \$MF_1 + MF_2 = 2a\$ (constante).\n\n'
                  'Attention : pour une hyperbole, \$c^2 = a^2 + b^2\$ et \$e > 1\$. Pour une parabole, \$e = 1\$. L\'excentricité permet de classifier les coniques.',
              points: 3,
              rapportJury:
                  'Le jury attend les formules exactes et la justification de \$0 \\leq e < 1\$.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Suites, séries et intégration',
          introduction:
              'Cette partie couvre les suites et séries numériques, les séries entières '
              'et les intégrales impropres.',
          bareme: 5,
          themes: ['Suites', 'Séries', 'Intégration'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$(u_n)\$ définie par \$u_0 = 2\$ et \$u_{n+1} = \\frac{1}{2}(u_n + \\frac{3}{u_n})\$. '
                  'Montrer que \$(u_n)\$ converge et déterminer sa limite.',
              indication:
                  'Reconnaître la méthode de Newton pour \$\\sqrt{3}\$. '
                  'Montrer que \$u_n \\geq \\sqrt{3}\$ puis que \$(u_n)\$ est décroissante.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence d\'une suite récurrente (méthode de Héron/Newton pour \$\\sqrt{3}\$).\n\n'
                  'Rappel : la méthode de Newton pour \$\\sqrt{a}\$ utilise \$u_{n+1} = \\frac{1}{2}(u_n + a/u_n)\$. Ici \$a = 3\$.\n\n'
                  'Minoration : par AM-GM, \$u_{n+1} = \\frac{1}{2}(u_n + 3/u_n) \\geq \\sqrt{u_n \\cdot 3/u_n} = \\sqrt{3}\$. Donc \$u_n \\geq \\sqrt{3}\$ pour \$n \\geq 1\$.\n'
                  'Décroissance : \$u_{n+1} - u_n = \\frac{3/u_n - u_n}{2} = \\frac{3 - u_n^2}{2u_n} \\leq 0\$ car \$u_n \\geq \\sqrt{3}\$. Donc \$(u_n)\$ est décroissante pour \$n \\geq 1\$.\n'
                  'Convergence : \$(u_n)\$ est décroissante et minorée par \$\\sqrt{3}\$, donc elle converge vers une limite \$\\ell \\geq \\sqrt{3}\$.\n'
                  'Passage à la limite : \$\\ell = \\frac{1}{2}(\\ell + 3/\\ell)\$, donc \$2\\ell^2 = \\ell^2 + 3\$, i.e. \$\\ell^2 = 3\$. Comme \$\\ell > 0\$, \$\\ell = \\sqrt{3}\$.\n'
                  'Vitesse : la convergence est quadratique. Si \$\\varepsilon_n = u_n - \\sqrt{3}\$, alors \$\\varepsilon_{n+1} \\approx \\varepsilon_n^2 / (2\\sqrt{3})\$.\n\n'
                  'Attention : ne pas oublier de vérifier que la suite est bien définie (\$u_n > 0\$ pour tout \$n\$, ce qui est vrai car \$u_0 > 0\$ et la formule préserve la positivité).',
              points: 3,
              rapportJury:
                  'Le jury apprécie les candidats qui identifient la méthode de Newton et mentionnent la convergence quadratique.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer la nature de la série \$\\sum_{n \\geq 1} \\frac{(-1)^n}{\\sqrt{n}}\$.',
              indication:
                  'C\'est une série alternée. Vérifier le critère de Leibniz.',
              correction:
                  'Ce qu\'on nous demande : établir la convergence (ou divergence) de cette série alternée.\n\n'
                  'Rappel : le critère des séries alternées (Leibniz) dit que si \$a_n \\geq 0\$, \$(a_n)\$ est décroissante et \$a_n \\to 0\$, alors \$\\sum (-1)^n a_n\$ converge.\n\n'
                  'Posons \$a_n = 1/\\sqrt{n}\$. Alors \$a_n > 0\$ ✓, \$a_n\$ est décroissante (\$\\sqrt{n+1} > \\sqrt{n}\$) ✓, et \$a_n \\to 0\$ ✓.\n'
                  'Par le critère de Leibniz, la série \$\\sum \\frac{(-1)^n}{\\sqrt{n}}\$ converge.\n'
                  'Convergence absolue ? \$\\sum \\frac{1}{\\sqrt{n}}\$ est une série de Riemann avec \$\\alpha = 1/2 \\leq 1\$, donc divergente.\n'
                  'Conclusion : la série est semi-convergente (convergente mais pas absolument convergente).\n'
                  'La somme peut s\'exprimer via la fonction êta de Dirichlet : \$\\eta(1/2) = \\sum_{n=1}^\\infty \\frac{(-1)^{n+1}}{\\sqrt{n}} = (1 - 2^{1/2}) \\zeta(1/2)\$ (formellement).\n\n'
                  'Attention : pour les séries alternées, le critère de Leibniz suffit. N\'essayez PAS de comparer \$|(-1)^n/\\sqrt{n}|\$ avec une série connue (cela donnerait la divergence absolue, pas la nature de la série).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'application du critère de Leibniz ET la conclusion sur la semi-convergence.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer le rayon de convergence de la série entière '
                  '\$\\sum_{n \\geq 0} \\frac{n!}{n^n} x^n\$ et étudier la convergence aux bornes.',
              indication:
                  'Utiliser le critère de d\'Alembert : \$\\frac{a_{n+1}}{a_n} \\to \\frac{1}{e}\$ '
                  '(formule de Stirling).',
              correction:
                  'Ce qu\'on nous demande : trouver le rayon \$R\$ de la série entière \$\\sum \\frac{n!}{n^n} x^n\$.\n\n'
                  'Rappel : le rayon de convergence vérifie \$1/R = \\limsup |a_n|^{1/n}\$ (Hadamard) ou peut se calculer par d\'Alembert si la limite existe.\n\n'
                  'd\'Alembert : \$\\frac{a_{n+1}}{a_n} = \\frac{(n+1)! / (n+1)^{n+1}}{n!/n^n} = \\frac{n+1}{1} \\cdot \\frac{n^n}{(n+1)^{n+1}} = \\frac{n^n}{(n+1)^n} = \\left(\\frac{n}{n+1}\\right)^n = \\left(1 - \\frac{1}{n+1}\\right)^n\$.\n'
                  'Or \$\\left(1 - \\frac{1}{n+1}\\right)^n \\to e^{-1}\$ (limite classique). Donc \$1/R = 1/e\$, soit \$R = e\$.\n'
                  'Aux bornes : pour \$x = e\$, par Stirling \$n! \\sim \\sqrt{2\\pi n} (n/e)^n\$, donc \$a_n e^n = \\frac{n! e^n}{n^n} \\sim \\sqrt{2\\pi n} \\to +\\infty\$. Divergence grossière.\n'
                  'Pour \$x = -e\$ : \$|a_n e^n| \\to +\\infty\$, donc divergence aussi.\n'
                  'Conclusion : le rayon est \$R = e\$ et la série diverge aux deux bornes.\n\n'
                  'Attention : Stirling est essentiel pour l\'étude aux bornes. Sans Stirling, on peut utiliser l\'équivalent \$n! \\sim \\sqrt{2\\pi n}(n/e)^n\$ comme une boîte noire.',
              points: 4,
              rapportJury:
                  'Le jury attend la formule de Stirling (ou au moins l\'équivalent \$(n/e)^n\$) pour l\'étude aux bornes.',
            ),
            QuestionAnnale(
              enonce:
                  'Étudier la convergence de l\'intégrale impropre '
                  '\$\\int_0^{+\\infty} \\frac{\\sin(t)}{t}\\,dt\$.',
              indication:
                  'Montrer la convergence par intégration par parties (ou par sommation des '
                  '\$\\int_{k\\pi}^{(k+1)\\pi}\$). Montrer que la convergence n\'est pas absolue.',
              correction:
                  'Ce qu\'on nous demande : étudier l\'intégrale de Dirichlet \$\\int_0^\\infty \\frac{\\sin t}{t} dt\$.\n\n'
                  'Rappel : cette intégrale est semi-convergente (convergente mais pas absolument). Sa valeur est \$\\frac{\\pi}{2}\$ (résultat classique).\n\n'
                  'Convergence : posons \$I_k = \\int_{k\\pi}^{(k+1)\\pi} \\frac{\\sin t}{t} dt\$. Par le changement \$t = k\\pi + u\$ : \$|I_k| \\leq \\frac{1}{k\\pi} \\int_0^\\pi |\\sin u| du = \\frac{2}{k\\pi}\$.\n'
                  'De plus les \$I_k\$ alternent en signe (\$\\sin\$ change de signe sur chaque intervalle \$[k\\pi, (k+1)\\pi]\$) et \$|I_k|\$ décroît.\n'
                  'Par le critère des séries alternées, \$\\sum I_k\$ converge, donc \$\\int_0^\\infty \\frac{\\sin t}{t} dt\$ converge.\n'
                  'Non-convergence absolue : \$|I_k| \\geq \\frac{1}{(k+1)\\pi} \\int_0^\\pi \\sin u\\, du = \\frac{2}{(k+1)\\pi}\$, et \$\\sum \\frac{1}{k}\$ diverge. Donc \$\\int_0^\\infty \\frac{|\\sin t|}{t} dt = +\\infty\$.\n'
                  'Valeur exacte : par des méthodes d\'analyse complexe (ou de Fourier), on montre \$\\int_0^\\infty \\frac{\\sin t}{t} dt = \\frac{\\pi}{2}\$.\n\n'
                  'Attention : la fonction \$\\frac{\\sin t}{t}\$ n\'est PAS dans \$L^1(\\mathbb{R}^+)\$. C\'est un exemple fondamental de semi-convergence pour les intégrales.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve de convergence ET de non-convergence absolue. La valeur \$\\pi/2\$ est un bonus.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer \$I = \\int_0^1 \\ln(x)\\,dx\$ et \$J = \\int_0^{+\\infty} x^2 e^{-x}\\,dx\$.',
              indication:
                  'Pour \$I\$, utiliser une IPP. Pour \$J\$, reconnaître \$\\Gamma(3) = 2!\$.',
              correction:
                  'Ce qu\'on nous demande : calculer deux intégrales classiques.\n\n'
                  'Rappel : \$\\int_0^1 \\ln(x) dx\$ est une intégrale impropre en \$0^+\$ (car \$\\ln(x) \\to -\\infty\$). La fonction \$\\Gamma(s) = \\int_0^\\infty t^{s-1} e^{-t} dt\$ vérifie \$\\Gamma(n) = (n-1)!\$.\n\n'
                  'Calcul de \$I\$ : IPP avec \$u = \\ln(x)\$, \$v\' = 1\$, donc \$u\' = 1/x\$, \$v = x\$.\n'
                  '\$I = [x\\ln(x)]_0^1 - \\int_0^1 1\\,dx = (0 - 0) - 1 = -1\$ (car \$\\lim_{x \\to 0^+} x\\ln(x) = 0\$ par croissance comparée).\n'
                  'Calcul de \$J\$ : \$J = \\int_0^\\infty x^2 e^{-x} dx = \\Gamma(3) = 2! = 2\$.\n'
                  'Vérification par double IPP : \$J = [-x^2 e^{-x}]_0^\\infty + 2\\int_0^\\infty x e^{-x} dx = 0 + 2[-xe^{-x}]_0^\\infty + 2\\int_0^\\infty e^{-x} dx = 2 \\times 1 = 2\$ ✓.\n'
                  'Résultats : \$I = -1\$ et \$J = 2\$.\n\n'
                  'Attention : pour \$I\$, n\'oubliez pas que c\'est une intégrale impropre. Il faut écrire \$I = \\lim_{\\varepsilon \\to 0^+} \\int_\\varepsilon^1 \\ln(x) dx\$ rigoureusement.',
              points: 3,
              rapportJury:
                  'Le jury attend le traitement rigoureux de l\'intégrale impropre et la vérification \$x\\ln(x) \\to 0\$.',
            ),
          ],
        ),
        // ── Partie IV ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie IV – Équations différentielles et fonctions de plusieurs variables',
          introduction:
              'Cette partie porte sur les équations différentielles linéaires, '
              'les systèmes différentiels et l\'étude des extrema.',
          bareme: 5,
          themes: ['Équations différentielles', 'Fonctions de plusieurs variables'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Résoudre l\'équation différentielle \$y\'\' - 3y\' + 2y = e^x\$.',
              indication:
                  'Résoudre l\'homogène d\'abord, puis chercher une solution particulière. '
                  'Comme \$e^x\$ est solution de l\'homogène, essayer \$y_p = axe^x\$.',
              correction:
                  'Ce qu\'on nous demande : résoudre une EDL2 à coefficients constants avec second membre.\n\n'
                  'Rappel : on résout d\'abord l\'homogène \$y\'\' - 3y\' + 2y = 0\$, puis on ajoute une solution particulière.\n\n'
                  'Équation caractéristique : \$r^2 - 3r + 2 = (r-1)(r-2) = 0\$, donc \$r_1 = 1\$ et \$r_2 = 2\$.\n'
                  'Solution générale homogène : \$y_h = C_1 e^x + C_2 e^{2x}\$.\n'
                  'Solution particulière : le second membre est \$e^x\$ avec \$r = 1\$ qui est racine simple de l\'éq. caract. On cherche \$y_p = axe^x\$.\n'
                  '\$y_p\' = ae^x(1+x)\$, \$y_p\'\' = ae^x(2+x)\$. En substituant : \$ae^x(2+x) - 3ae^x(1+x) + 2axe^x = ae^x(2+x-3-3x+2x) = ae^x(-1) = -ae^x\$.\n'
                  'On veut \$-ae^x = e^x\$, donc \$a = -1\$ et \$y_p = -xe^x\$.\n'
                  'Solution générale : \$y = C_1 e^x + C_2 e^{2x} - xe^x\$ (\$C_1, C_2 \\in \\mathbb{R}\$).\n\n'
                  'Attention : quand le second membre \$e^{rx}\$ correspond à une racine de multiplicité \$m\$ de l\'éq. caract., la solution particulière est de la forme \$x^m P(x) e^{rx}\$. Ici \$m = 1\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la mention que \$r = 1\$ est racine de l\'éq. caractéristique, justifiant le facteur \$x\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre le système différentiel \$X\' = AX\$ avec '
                  '\$A = \\begin{pmatrix} 1 & 1 \\\\ 0 & 2 \\end{pmatrix}\$.',
              indication:
                  'Diagonaliser (ou trigonaliser) \$A\$ et utiliser l\'exponentielle de matrice.',
              correction:
                  'Ce qu\'on nous demande : résoudre un système linéaire \$X\' = AX\$ en dimension 2.\n\n'
                  'Rappel : la solution est \$X(t) = e^{tA} X_0\$. Si \$A = PDP^{-1}\$ avec \$D\$ diagonale, alors \$e^{tA} = P e^{tD} P^{-1}\$.\n\n'
                  'Valeurs propres : \$\\chi_A(\\lambda) = (1-\\lambda)(2-\\lambda) = 0\$, donc \$\\lambda_1 = 1\$ et \$\\lambda_2 = 2\$.\n'
                  'Vecteurs propres : \$E_1 = \\ker(A-I) = \\text{Vect}((1,0))\$, \$E_2 = \\ker(A-2I) = \\text{Vect}((1,1))\$.\n'
                  'Avec \$P = \\begin{pmatrix} 1 & 1 \\\\ 0 & 1 \\end{pmatrix}\$ : \$A = P \\begin{pmatrix} 1 & 0 \\\\ 0 & 2 \\end{pmatrix} P^{-1}\$.\n'
                  'Donc \$e^{tA} = P \\begin{pmatrix} e^t & 0 \\\\ 0 & e^{2t} \\end{pmatrix} P^{-1}\$.\n'
                  'Solution : \$X(t) = c_1 e^t \\begin{pmatrix} 1 \\\\ 0 \\end{pmatrix} + c_2 e^{2t} \\begin{pmatrix} 1 \\\\ 1 \\end{pmatrix}\$, soit \$x(t) = c_1 e^t + c_2 e^{2t}\$, \$y(t) = c_2 e^{2t}\$.\n\n'
                  'Attention : si \$A\$ n\'est pas diagonalisable, on utilise la décomposition de Jordan et les termes polynomiaux en \$t\$ apparaissent (ex. \$te^{\\lambda t}\$).',
              points: 4,
              rapportJury:
                  'Le jury attend la diagonalisation explicite et la solution sous forme vectorielle.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f(x,y) = x^3 + y^3 - 3xy\$. Trouver les points critiques de \$f\$ '
                  'et déterminer leur nature.',
              indication:
                  'Résoudre \$\\nabla f = 0\$ puis utiliser la matrice hessienne.',
              correction:
                  'Ce qu\'on nous demande : trouver et classifier les extrema de \$f(x,y) = x^3 + y^3 - 3xy\$.\n\n'
                  'Rappel : un point critique vérifie \$\\nabla f = 0\$. Sa nature est déterminée par la hessienne \$H\$ : si \$\\det(H) > 0\$ et \$\\partial^2 f/\\partial x^2 > 0\$, c\'est un minimum ; si \$\\det(H) < 0\$, c\'est un point selle.\n\n'
                  '\$\\partial f/\\partial x = 3x^2 - 3y = 0\$ et \$\\partial f/\\partial y = 3y^2 - 3x = 0\$. Donc \$y = x^2\$ et \$x^4 - x = 0\$, soit \$x(x^3 - 1) = 0\$.\n'
                  'Points critiques : \$(0, 0)\$ et \$(1, 1)\$.\n'
                  'Hessienne : \$H = \\begin{pmatrix} 6x & -3 \\\\ -3 & 6y \\end{pmatrix}\$.\n'
                  'En \$(0,0)\$ : \$\\det(H) = 0 - 9 = -9 < 0\$. C\'est un point selle.\n'
                  'En \$(1,1)\$ : \$\\det(H) = 36 - 9 = 27 > 0\$ et \$\\partial^2 f/\\partial x^2 = 6 > 0\$. C\'est un minimum local. Valeur : \$f(1,1) = 1 + 1 - 3 = -1\$.\n\n'
                  'Attention : quand \$\\det(H) = 0\$, le test hessien est non conclusif. Il faut alors une étude directe (c\'est un cas rare mais piégeant en concours).',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul explicite de la hessienne et la conclusion nette sur chaque point critique.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer le théorème des fonctions implicites en dimension 2 et '
                  'l\'appliquer à l\'équation \$x^2 + y^2 + xy = 3\$ au voisinage de \$(1, 1)\$.',
              indication:
                  'Poser \$F(x,y) = x^2 + y^2 + xy - 3\$ et vérifier \$\\partial F / \\partial y(1,1) \\neq 0\$.',
              correction:
                  'Ce qu\'on nous demande : appliquer le TFI pour exprimer \$y\$ en fonction de \$x\$ localement.\n\n'
                  'Rappel (TFI) : si \$F(a,b) = 0\$ et \$\\partial F/\\partial y(a,b) \\neq 0\$, avec \$F\$ de classe \$C^1\$, alors il existe une fonction \$y = \\varphi(x)\$ de classe \$C^1\$ définie au voisinage de \$a\$, telle que \$F(x, \\varphi(x)) = 0\$ et \$\\varphi(a) = b\$.\n\n'
                  'Posons \$F(x,y) = x^2 + y^2 + xy - 3\$. On vérifie : \$F(1,1) = 1 + 1 + 1 - 3 = 0\$ ✓.\n'
                  '\$\\partial F/\\partial y = 2y + x\$. En \$(1,1)\$ : \$\\partial F/\\partial y(1,1) = 2 + 1 = 3 \\neq 0\$ ✓.\n'
                  'Par le TFI, il existe \$\\varphi\$ de classe \$C^1\$ au voisinage de \$x = 1\$ telle que \$\\varphi(1) = 1\$ et \$x^2 + \\varphi(x)^2 + x\\varphi(x) = 3\$.\n'
                  'Dérivée implicite : en dérivant \$F(x, \\varphi(x)) = 0\$ : \$\\varphi\'(x) = -\\frac{\\partial F/\\partial x}{\\partial F/\\partial y} = -\\frac{2x + y}{2y + x}\$. En \$(1,1)\$ : \$\\varphi\'(1) = -3/3 = -1\$.\n'
                  'La tangente à la courbe en \$(1,1)\$ a pour équation \$y - 1 = -(x - 1)\$, soit \$y = -x + 2\$.\n\n'
                  'Attention : le TFI est un résultat LOCAL. Il ne garantit pas l\'existence d\'une fonction globale \$y = \\varphi(x)\$. La condition \$\\partial F/\\partial y \\neq 0\$ est essentielle.',
              points: 4,
              rapportJury:
                  'Le jury attend l\'énoncé précis du TFI, la vérification des hypothèses, et le calcul de la dérivée implicite.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre l\'équation différentielle \$y\' + y = \\frac{1}{1 + e^x}\$ '
                  'par la méthode de variation de la constante.',
              indication:
                  'La solution de l\'homogène est \$Ce^{-x}\$. Poser \$y = C(x)e^{-x}\$ '
                  'et déterminer \$C(x)\$.',
              correction:
                  'Ce qu\'on nous demande : résoudre une EDL1 par variation de la constante.\n\n'
                  'Rappel : pour \$y\' + a(x)y = b(x)\$, on résout d\'abord \$y\' + ay = 0\$ (solution \$y_h = Ce^{-A(x)}\$ où \$A = \\int a\$), puis on pose \$y = C(x)e^{-A(x)}\$.\n\n'
                  'Homogène : \$y\' + y = 0\$ donne \$y_h = Ce^{-x}\$.\n'
                  'Variation de la constante : \$y = C(x)e^{-x}\$. Alors \$y\' = C\'(x)e^{-x} - C(x)e^{-x}\$.\n'
                  'En substituant : \$C\'(x)e^{-x} - Ce^{-x} + Ce^{-x} = C\'(x)e^{-x} = \\frac{1}{1+e^x}\$.\n'
                  'Donc \$C\'(x) = \\frac{e^x}{1+e^x}\$. On intègre : \$C(x) = \\ln(1 + e^x) + K\$.\n'
                  'Solution générale : \$y(x) = (\\ln(1+e^x) + K)e^{-x} = e^{-x}\\ln(1+e^x) + Ke^{-x}\$.\n'
                  'Vérification : quand \$x \\to +\\infty\$, \$y \\sim e^{-x} \\cdot x \\to 0\$. Quand \$x \\to -\\infty\$, \$y \\sim e^{-x} \\ln(1) = 0\$... en fait \$\\ln(1+e^x) \\sim e^x\$ pour \$x \\to -\\infty\$, donc \$y \\sim 1\$.\n\n'
                  'Attention : l\'intégration de \$\\frac{e^x}{1+e^x}\$ se fait par le changement \$u = 1 + e^x\$. Ne pas oublier la constante \$K\$ !',
              points: 3,
              rapportJury:
                  'Le jury attend la méthode complète avec la résolution de l\'homogène, la variation, et l\'intégration.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2024 – Épreuve 2
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2024EP2() {
    return Annale(
      id: 'ped_int_2024_ep2',
      annee: 2024,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2024 – Épreuve 2 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 2 de l\'agrégation interne 2024. '
          'Probabilités, statistiques, arithmétique et polynômes.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Probabilités', 'Statistiques', 'Arithmétique', 'Polynômes'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep2/24-ep2.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Variables aléatoires', 'Estimation', 'Congruences', 'Dénombrement', 'Polynômes'],
      rapportGlobal:
          'L\'épreuve 2 de l\'interne mêle probabilités, statistiques et arithmétique. '
          'Notre correction vous accompagne à chaque étape.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Variables aléatoires et lois classiques',
          introduction:
              'Cette partie porte sur le calcul de lois, d\'espérances, de variances '
              'et les propriétés des lois classiques.',
          bareme: 5,
          themes: ['Variables aléatoires', 'Lois classiques', 'Espérance'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire suivant une loi de Poisson de paramètre '
                  '\$\\lambda > 0\$. Calculer \$E[X]\$, \$\\text{Var}(X)\$ et la fonction génératrice \$G_X(s) = E[s^X]\$.',
              indication:
                  'Utiliser la définition \$P(X = k) = e^{-\\lambda} \\frac{\\lambda^k}{k!}\$ '
                  'et les propriétés de l\'exponentielle.',
              correction:
                  'Ce qu\'on nous demande : calculer les moments et la fonction génératrice d\'une loi de Poisson.\n\n'
                  'Rappel : \$X \\sim \\mathcal{P}(\\lambda)\$ signifie \$P(X = k) = e^{-\\lambda} \\frac{\\lambda^k}{k!}\$ pour \$k \\in \\mathbb{N}\$.\n\n'
                  'Fonction génératrice : \$G_X(s) = E[s^X] = \\sum_{k=0}^\\infty s^k e^{-\\lambda} \\frac{\\lambda^k}{k!} = e^{-\\lambda} \\sum \\frac{(s\\lambda)^k}{k!} = e^{-\\lambda} e^{s\\lambda} = e^{\\lambda(s-1)}\$.\n'
                  'Espérance : \$E[X] = G_X\'(1) = \\lambda e^{\\lambda(s-1)}|_{s=1} = \\lambda\$.\n'
                  'Moment d\'ordre 2 : \$E[X(X-1)] = G_X\'\'(1) = \\lambda^2\$, donc \$E[X^2] = \\lambda^2 + \\lambda\$.\n'
                  'Variance : \$\\text{Var}(X) = E[X^2] - (E[X])^2 = \\lambda^2 + \\lambda - \\lambda^2 = \\lambda\$.\n'
                  'Résultat remarquable : pour la loi de Poisson, \$E[X] = \\text{Var}(X) = \\lambda\$. C\'est une caractérisation de cette loi.\n'
                  'La fonction génératrice permet aussi de retrouver la stabilité : si \$X \\sim \\mathcal{P}(\\lambda)\$ et \$Y \\sim \\mathcal{P}(\\mu)\$ indépendantes, \$X+Y \\sim \\mathcal{P}(\\lambda + \\mu)\$.\n\n'
                  'Attention : la loi de Poisson approxime la loi binomiale \$B(n,p)\$ quand \$n \\to \\infty\$, \$p \\to 0\$ et \$np \\to \\lambda\$ (approximation de Poisson).',
              points: 3,
              rapportJury:
                  'Le jury attend les calculs via la fonction génératrice, plus élégants que le calcul direct.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire de densité \$f(x) = 2x \\mathbf{1}_{[0,1]}(x)\$. '
                  'Calculer la fonction de répartition de \$X\$, son espérance et sa variance.',
              indication:
                  'Intégrer la densité pour la fonction de répartition. '
                  'Calculer \$E[X] = \\int x f(x) dx\$.',
              correction:
                  'Ce qu\'on nous demande : étudier une variable à densité sur \$[0,1]\$.\n\n'
                  'Rappel : si \$X\$ a pour densité \$f\$, alors \$F(x) = P(X \\leq x) = \\int_{-\\infty}^x f(t)dt\$ et \$E[X] = \\int x f(x)dx\$.\n\n'
                  'Vérifions que \$f\$ est une densité : \$\\int_0^1 2x dx = [x^2]_0^1 = 1\$ ✓ et \$f \\geq 0\$ ✓.\n'
                  'Fonction de répartition : pour \$x < 0\$, \$F(x) = 0\$. Pour \$0 \\leq x \\leq 1\$, \$F(x) = \\int_0^x 2t dt = x^2\$. Pour \$x > 1\$, \$F(x) = 1\$.\n'
                  'Espérance : \$E[X] = \\int_0^1 x \\cdot 2x dx = \\int_0^1 2x^2 dx = [\\frac{2x^3}{3}]_0^1 = \\frac{2}{3}\$.\n'
                  'Moment d\'ordre 2 : \$E[X^2] = \\int_0^1 x^2 \\cdot 2x dx = \\int_0^1 2x^3 dx = \\frac{1}{2}\$.\n'
                  'Variance : \$\\text{Var}(X) = E[X^2] - (E[X])^2 = \\frac{1}{2} - \\frac{4}{9} = \\frac{9 - 8}{18} = \\frac{1}{18}\$.\n\n'
                  'Attention : vérifiez toujours que \$\\int f = 1\$ avant de commencer les calculs. Si ce n\'est pas le cas, il faut normaliser.',
              points: 3,
              rapportJury:
                  'Question de calcul direct. Le jury attend la vérification que \$f\$ est bien une densité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X \\sim B(n, p)\$ (loi binomiale). Montrer l\'approximation de Poisson : '
                  'si \$n \\to \\infty\$, \$p \\to 0\$ avec \$np \\to \\lambda > 0\$, alors '
                  '\$P(X = k) \\to e^{-\\lambda} \\frac{\\lambda^k}{k!}\$.',
              indication:
                  'Écrire \$P(X = k) = \\binom{n}{k} p^k (1-p)^{n-k}\$ et '
                  'faire les approximations avec \$p = \\lambda/n\$.',
              correction:
                  'Ce qu\'on nous demande : justifier l\'approximation de la binomiale par la loi de Poisson.\n\n'
                  'Rappel : \$P(X = k) = \\binom{n}{k} p^k (1-p)^{n-k}\$ avec \$p = \\lambda/n\$ (asymptotiquement).\n\n'
                  '\$P(X = k) = \\frac{n!}{k!(n-k)!} \\left(\\frac{\\lambda}{n}\\right)^k \\left(1 - \\frac{\\lambda}{n}\\right)^{n-k}\$.\n'
                  'Réécrivons : \$= \\frac{\\lambda^k}{k!} \\cdot \\frac{n(n-1)\\cdots(n-k+1)}{n^k} \\cdot \\left(1 - \\frac{\\lambda}{n}\\right)^n \\cdot \\left(1 - \\frac{\\lambda}{n}\\right)^{-k}\$.\n'
                  'Quand \$n \\to \\infty\$ : \$\\frac{n(n-1)\\cdots(n-k+1)}{n^k} \\to 1\$ (\$k\$ est fixé), \$\\left(1 - \\frac{\\lambda}{n}\\right)^n \\to e^{-\\lambda}\$, et \$\\left(1 - \\frac{\\lambda}{n}\\right)^{-k} \\to 1\$.\n'
                  'Donc \$P(X = k) \\to \\frac{\\lambda^k}{k!} \\cdot 1 \\cdot e^{-\\lambda} \\cdot 1 = e^{-\\lambda} \\frac{\\lambda^k}{k!}\$.\n'
                  'C\'est bien la loi de Poisson de paramètre \$\\lambda\$. En pratique, l\'approximation est bonne dès que \$n \\geq 30\$ et \$p \\leq 0.1\$.\n\n'
                  'Attention : il faut que \$k\$ soit FIXE quand \$n \\to \\infty\$. L\'approximation n\'est pas uniforme en \$k\$ (elle est moins bonne pour \$k\$ proche de \$n\$).',
              points: 4,
              rapportJury:
                  'Le jury attend chaque étape du passage à la limite, en particulier la justification de \$(1-\\lambda/n)^n \\to e^{-\\lambda}\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X, Y)\$ un couple de variables aléatoires de densité '
                  '\$f(x,y) = 6(1-y)\$ sur le triangle \$\\{0 \\leq x \\leq y \\leq 1\\}\$. '
                  'Calculer les lois marginales et déterminer si \$X\$ et \$Y\$ sont indépendantes.',
              indication:
                  'Les marginales s\'obtiennent par intégration de la densité jointe. '
                  'L\'indépendance se vérifie par \$f(x,y) = f_X(x) f_Y(y)\$.',
              correction:
                  'Ce qu\'on nous demande : calculer les marginales et tester l\'indépendance du couple.\n\n'
                  'Rappel : \$f_X(x) = \\int f(x,y)dy\$ et \$f_Y(y) = \\int f(x,y)dx\$. Indépendance ssi \$f(x,y) = f_X(x)f_Y(y)\$ partout.\n\n'
                  'Marginale de \$Y\$ : pour \$0 \\leq y \\leq 1\$, \$f_Y(y) = \\int_0^y 6(1-y)dx = 6y(1-y)\$ (on intègre \$x\$ de 0 à \$y\$).\n'
                  'Marginale de \$X\$ : pour \$0 \\leq x \\leq 1\$, \$f_X(x) = \\int_x^1 6(1-y)dy = 6\\left[y - \\frac{y^2}{2}\\right]_x^1 = 6\\left(\\frac{1}{2} - x + \\frac{x^2}{2}\\right) = 3(1-x)^2\$.\n'
                  'Vérification : \$\\int_0^1 3(1-x)^2 dx = 3 \\cdot \\frac{1}{3} = 1\$ ✓ et \$\\int_0^1 6y(1-y)dy = 6 \\cdot \\frac{1}{6} = 1\$ ✓.\n'
                  'Indépendance : \$f_X(x) f_Y(y) = 3(1-x)^2 \\cdot 6y(1-y) = 18y(1-x)^2(1-y)\$, mais \$f(x,y) = 6(1-y)\$.\n'
                  'Clairement \$f(x,y) \\neq f_X(x)f_Y(y)\$ (le produit dépend de \$x\$ et \$y\$ séparément, pas \$f\$). Donc \$X\$ et \$Y\$ ne sont PAS indépendantes.\n\n'
                  'Attention : même si \$f\$ se « factorise » en apparence, le domaine triangulaire \$\\{x \\leq y\\}\$ brise l\'indépendance (un domaine rectangulaire est nécessaire).',
              points: 4,
              rapportJury:
                  'Le jury attend les calculs des deux marginales et la conclusion argumentée sur la non-indépendance.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire de loi exponentielle de paramètre \$\\lambda > 0\$. '
                  'Montrer la propriété d\'absence de mémoire : '
                  '\$P(X > s + t \\mid X > s) = P(X > t)\$.',
              indication:
                  'Utiliser la formule des probabilités conditionnelles et la fonction de survie '
                  '\$P(X > t) = e^{-\\lambda t}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver la propriété d\'absence de mémoire de la loi exponentielle.\n\n'
                  'Rappel : \$X \\sim \\text{Exp}(\\lambda)\$ a pour densité \$f(x) = \\lambda e^{-\\lambda x} \\mathbf{1}_{x \\geq 0}\$ et pour fonction de survie \$P(X > t) = e^{-\\lambda t}\$.\n\n'
                  'Par la formule de Bayes : \$P(X > s+t \\mid X > s) = \\frac{P(X > s+t \\text{ et } X > s)}{P(X > s)} = \\frac{P(X > s+t)}{P(X > s)}\$.\n'
                  'Car \$\\{X > s+t\\} \\subset \\{X > s\\}\$ (si \$X > s+t\$ alors automatiquement \$X > s\$).\n'
                  'Donc \$P(X > s+t \\mid X > s) = \\frac{e^{-\\lambda(s+t)}}{e^{-\\lambda s}} = e^{-\\lambda t} = P(X > t)\$. ✓\n'
                  'Interprétation : si \$X\$ représente la durée de vie d\'un composant, sachant qu\'il a survécu \$s\$ unités de temps, la probabilité de survivre encore \$t\$ unités est la même que pour un composant neuf.\n'
                  'Réciproquement, la loi exponentielle est la SEULE loi continue vérifiant cette propriété (caractérisation).\n\n'
                  'Attention : la propriété analogue pour les lois discrètes est vérifiée par la loi géométrique (et seulement elle). C\'est le pendant discret de l\'exponentielle.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul ET l\'interprétation. La mention de la caractérisation est appréciée.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Espérance conditionnelle et estimation',
          introduction:
              'Cette partie porte sur l\'espérance conditionnelle, les estimateurs '
              'et les méthodes d\'estimation statistique.',
          bareme: 5,
          themes: ['Espérance conditionnelle', 'Estimation', 'Maximum de vraisemblance'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$(X, Y)\$ un couple de variables aléatoires discrètes. Définir '
                  '\$E[X \\mid Y = y]\$ et montrer la formule de l\'espérance totale '
                  '\$E[X] = E[E[X \\mid Y]]\$.',
              indication:
                  'Écrire la double somme et intervertir l\'ordre de sommation.',
              correction:
                  'Ce qu\'on nous demande : définir l\'espérance conditionnelle et prouver la formule de l\'espérance itérée.\n\n'
                  'Rappel : \$E[X \\mid Y = y] = \\sum_x x \\cdot P(X = x \\mid Y = y)\$ est l\'espérance de \$X\$ sachant que \$Y = y\$. \$E[X \\mid Y]\$ est la variable aléatoire \$\\varphi(Y)\$ où \$\\varphi(y) = E[X \\mid Y = y]\$.\n\n'
                  '\$E[E[X \\mid Y]] = \\sum_y E[X \\mid Y = y] \\cdot P(Y = y) = \\sum_y \\left(\\sum_x x \\cdot P(X=x \\mid Y=y)\\right) P(Y=y)\$.\n'
                  '\$= \\sum_y \\sum_x x \\cdot P(X=x \\mid Y=y) \\cdot P(Y=y) = \\sum_y \\sum_x x \\cdot P(X=x, Y=y)\$.\n'
                  'En intervertissant les sommes : \$= \\sum_x x \\sum_y P(X=x, Y=y) = \\sum_x x \\cdot P(X=x) = E[X]\$.\n'
                  'Donc \$E[E[X \\mid Y]] = E[X]\$. C\'est la formule de l\'espérance totale (ou « tower property »).\n'
                  'Application : pour calculer \$E[X]\$ quand le calcul direct est difficile, on conditionne par une variable auxiliaire \$Y\$ judicieusement choisie.\n\n'
                  'Attention : \$E[X \\mid Y]\$ est une VARIABLE ALÉATOIRE (fonction de \$Y\$), pas un nombre. C\'est \$E[X \\mid Y = y]\$ qui est un nombre (pour \$y\$ fixé).',
              points: 4,
              rapportJury:
                  'Le jury est très attentif à la distinction entre \$E[X|Y]\$ (v.a.) et \$E[X|Y=y]\$ (nombre).',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X_1, \\ldots, X_n\$ un échantillon i.i.d. de loi \$\\mathcal{N}(\\mu, \\sigma^2)\$ '
                  'avec \$\\sigma^2\$ connu. Montrer que \$\\bar{X}_n\$ est un estimateur sans biais '
                  'et convergent de \$\\mu\$.',
              indication:
                  'Sans biais : \$E[\\bar{X}_n] = \\mu\$. Convergent : \$\\text{Var}(\\bar{X}_n) \\to 0\$.',
              correction:
                  'Ce qu\'on nous demande : vérifier les propriétés de l\'estimateur de la moyenne empirique.\n\n'
                  'Rappel : \$\\bar{X}_n = \\frac{1}{n}\\sum_{i=1}^n X_i\$. Un estimateur \$T_n\$ de \$\\theta\$ est sans biais si \$E[T_n] = \\theta\$, et convergent si \$T_n \\xrightarrow{P} \\theta\$.\n\n'
                  'Sans biais : \$E[\\bar{X}_n] = \\frac{1}{n}\\sum_{i=1}^n E[X_i] = \\frac{1}{n} \\cdot n\\mu = \\mu\$ ✓.\n'
                  'Variance : \$\\text{Var}(\\bar{X}_n) = \\frac{1}{n^2}\\sum \\text{Var}(X_i) = \\frac{n\\sigma^2}{n^2} = \\frac{\\sigma^2}{n} \\to 0\$.\n'
                  'Convergence : par Tchebychev, \$P(|\\bar{X}_n - \\mu| > \\varepsilon) \\leq \\frac{\\text{Var}(\\bar{X}_n)}{\\varepsilon^2} = \\frac{\\sigma^2}{n\\varepsilon^2} \\to 0\$. Donc \$\\bar{X}_n \\xrightarrow{P} \\mu\$.\n'
                  'De plus, \$\\bar{X}_n \\sim \\mathcal{N}(\\mu, \\sigma^2/n)\$ (stabilité de la gaussienne par somme). C\'est l\'estimateur du maximum de vraisemblance.\n'
                  'Efficacité : \$\\text{Var}(\\bar{X}_n) = \\sigma^2/n\$ atteint la borne de Cramér-Rao. L\'estimateur est efficace.\n\n'
                  'Attention : la convergence en probabilité est la convergence FAIBLE. La LGN forte donne la convergence presque sûre, qui est plus forte.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul de l\'espérance et de la variance, puis la convergence via Tchebychev.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X_1, \\ldots, X_n\$ i.i.d. de loi exponentielle \$\\text{Exp}(\\lambda)\$ '
                  'avec \$\\lambda > 0\$ inconnu. Déterminer l\'estimateur du maximum de vraisemblance de \$\\lambda\$.',
              indication:
                  'Écrire la vraisemblance, prendre le logarithme, dériver et annuler.',
              correction:
                  'Ce qu\'on nous demande : trouver l\'EMV de \$\\lambda\$ pour un échantillon exponentiel.\n\n'
                  'Rappel : la vraisemblance est \$L(\\lambda) = \\prod_{i=1}^n f(x_i; \\lambda)\$ et l\'EMV maximise \$L\$ (ou \$\\ln L\$).\n\n'
                  'Vraisemblance : \$L(\\lambda) = \\prod_{i=1}^n \\lambda e^{-\\lambda x_i} = \\lambda^n e^{-\\lambda \\sum x_i}\$.\n'
                  'Log-vraisemblance : \$\\ell(\\lambda) = n\\ln(\\lambda) - \\lambda \\sum x_i\$.\n'
                  'Dérivée : \$\\ell\'(\\lambda) = \\frac{n}{\\lambda} - \\sum x_i = 0\$, donc \$\\hat{\\lambda} = \\frac{n}{\\sum x_i} = \\frac{1}{\\bar{X}_n}\$.\n'
                  'Vérification : \$\\ell\'\'(\\lambda) = -n/\\lambda^2 < 0\$, donc c\'est bien un maximum.\n'
                  'L\'EMV de \$\\lambda\$ est \$\\hat{\\lambda} = 1/\\bar{X}_n\$. Il est biaisé : \$E[1/\\bar{X}_n] \\neq \\lambda\$ en général (Jensen). Mais il est asymptotiquement sans biais et convergent.\n'
                  'Un estimateur sans biais de \$\\lambda\$ est \$\\frac{n-1}{\\sum X_i}\$ (corrigé).\n\n'
                  'Attention : l\'EMV n\'est pas toujours sans biais ! Ici \$E[1/\\bar{X}] > 1/E[\\bar{X}] = \\lambda\$ par convexité de \$x \\mapsto 1/x\$ (inégalité de Jensen).',
              points: 4,
              rapportJury:
                  'Le jury attend toutes les étapes : vraisemblance, log-vraisemblance, dérivation, vérification du maximum.',
            ),
            QuestionAnnale(
              enonce:
                  'Construire un intervalle de confiance de niveau \$1 - \\alpha\$ pour la moyenne '
                  '\$\\mu\$ d\'une loi normale \$\\mathcal{N}(\\mu, \\sigma^2)\$ quand \$\\sigma\$ est connu.',
              indication:
                  'Utiliser le pivot \$Z = \\frac{\\bar{X}_n - \\mu}{\\sigma/\\sqrt{n}} \\sim \\mathcal{N}(0,1)\$.',
              correction:
                  'Ce qu\'on nous demande : construire un IC pour \$\\mu\$ dans le modèle gaussien à variance connue.\n\n'
                  'Rappel : un intervalle de confiance (IC) de niveau \$1-\\alpha\$ est un intervalle aléatoire \$I_n\$ tel que \$P(\\mu \\in I_n) = 1-\\alpha\$.\n\n'
                  'Le pivot est \$Z = \\frac{\\bar{X}_n - \\mu}{\\sigma / \\sqrt{n}} \\sim \\mathcal{N}(0,1)\$ (loi connue ne dépendant pas de \$\\mu\$).\n'
                  'Soit \$z_{\\alpha/2}\$ le quantile d\'ordre \$1 - \\alpha/2\$ de \$\\mathcal{N}(0,1)\$ : \$P(-z_{\\alpha/2} \\leq Z \\leq z_{\\alpha/2}) = 1 - \\alpha\$.\n'
                  'En isolant \$\\mu\$ : \$P\\left(\\bar{X}_n - z_{\\alpha/2}\\frac{\\sigma}{\\sqrt{n}} \\leq \\mu \\leq \\bar{X}_n + z_{\\alpha/2}\\frac{\\sigma}{\\sqrt{n}}\\right) = 1 - \\alpha\$.\n'
                  'L\'IC est donc \$\\left[\\bar{X}_n \\pm z_{\\alpha/2} \\frac{\\sigma}{\\sqrt{n}}\\right]\$.\n'
                  'Pour \$\\alpha = 0.05\$ : \$z_{0.025} \\approx 1.96\$, donc IC = \$\\bar{X}_n \\pm 1.96 \\frac{\\sigma}{\\sqrt{n}}\$.\n'
                  'La largeur de l\'IC est \$2 z_{\\alpha/2} \\sigma / \\sqrt{n}\$, qui décroît en \$1/\\sqrt{n}\$.\n\n'
                  'Attention : si \$\\sigma\$ est inconnu, on le remplace par l\'écart-type empirique \$S_n\$ et on utilise la loi de Student \$t_{n-1}\$ au lieu de \$\\mathcal{N}(0,1)\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la construction rigoureuse via le pivot et la formule finale de l\'IC.',
            ),
            QuestionAnnale(
              enonce:
                  'On observe \$X_1, \\ldots, X_n\$ i.i.d. de loi \$\\mathcal{N}(\\mu, 1)\$. '
                  'On souhaite tester \$H_0 : \\mu = 0\$ contre \$H_1 : \\mu \\neq 0\$ au '
                  'niveau \$\\alpha = 5\\%\$. Construire la statistique de test et la région de rejet.',
              indication:
                  'Sous \$H_0\$, \$\\sqrt{n} \\bar{X}_n \\sim \\mathcal{N}(0,1)\$.',
              correction:
                  'Ce qu\'on nous demande : construire un test bilatéral de la moyenne gaussienne.\n\n'
                  'Rappel : un test au niveau \$\\alpha\$ rejette \$H_0\$ ssi la statistique de test tombe dans la région de rejet, avec \$P(\\text{rejet} \\mid H_0) = \\alpha\$.\n\n'
                  'Sous \$H_0\$ (\$\\mu = 0\$) : \$T = \\sqrt{n} \\bar{X}_n \\sim \\mathcal{N}(0,1)\$ (car \$\\bar{X}_n \\sim \\mathcal{N}(0, 1/n)\$).\n'
                  'Test bilatéral : on rejette \$H_0\$ si \$|T| > z_{\\alpha/2} = z_{0.025} \\approx 1.96\$.\n'
                  'Région de rejet : \$\\mathcal{R} = \\{|\\sqrt{n}\\bar{X}_n| > 1.96\\}\$, soit \$|\\bar{X}_n| > \\frac{1.96}{\\sqrt{n}}\$.\n'
                  'Sous \$H_0\$ : \$P(|T| > 1.96) = 2(1 - \\Phi(1.96)) = 2 \\times 0.025 = 0.05 = \\alpha\$ ✓.\n'
                  'La p-valeur est \$p = 2(1 - \\Phi(|t_{\\text{obs}}|))\$. On rejette \$H_0\$ ssi \$p < \\alpha\$.\n'
                  'Puissance : \$\\beta(\\mu) = P(\\text{rejet} \\mid \\mu) = P(|\\sqrt{n}\\bar{X}_n| > 1.96 \\mid \\mu)\$ croît avec \$|\\mu|\$ et \$n\$.\n\n'
                  'Attention : le test bilatéral (vs \$\\mu \\neq 0\$) a une région de rejet à deux queues. Un test unilatéral (vs \$\\mu > 0\$) rejetterait seulement à droite.',
              points: 3,
              rapportJury:
                  'Le jury attend la statistique de test, la région de rejet et la vérification du niveau.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Suites récurrentes et dénombrement',
          introduction:
              'Cette partie porte sur les suites récurrentes linéaires, '
              'le dénombrement et les principes combinatoires.',
          bareme: 5,
          themes: ['Suites récurrentes', 'Dénombrement', 'Combinatoire'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Résoudre la suite récurrente linéaire d\'ordre 2 : '
                  '\$u_{n+2} = 3u_{n+1} - 2u_n\$ avec \$u_0 = 1\$ et \$u_1 = 3\$.',
              indication:
                  'Écrire l\'équation caractéristique \$r^2 - 3r + 2 = 0\$ et trouver ses racines.',
              correction:
                  'Ce qu\'on nous demande : trouver l\'expression de \$u_n\$ en fonction de \$n\$.\n\n'
                  'Rappel : pour \$u_{n+2} = au_{n+1} + bu_n\$, on résout l\'équation caractéristique \$r^2 = ar + b\$ (ou \$r^2 - ar - b = 0\$). La solution générale est \$u_n = \\alpha r_1^n + \\beta r_2^n\$ si les racines sont distinctes.\n\n'
                  'Équation caractéristique : \$r^2 - 3r + 2 = 0\$, soit \$(r-1)(r-2) = 0\$. Racines : \$r_1 = 1\$, \$r_2 = 2\$.\n'
                  'Solution générale : \$u_n = \\alpha \\cdot 1^n + \\beta \\cdot 2^n = \\alpha + \\beta \\cdot 2^n\$.\n'
                  'Conditions initiales : \$u_0 = \\alpha + \\beta = 1\$ et \$u_1 = \\alpha + 2\\beta = 3\$.\n'
                  'En soustrayant : \$\\beta = 2\$, puis \$\\alpha = -1\$.\n'
                  'Solution : \$u_n = -1 + 2^{n+1}\$ pour tout \$n \\geq 0\$. Vérification : \$u_0 = -1 + 2 = 1\$ ✓, \$u_1 = -1 + 4 = 3\$ ✓, \$u_2 = -1 + 8 = 7 = 3 \\times 3 - 2 \\times 1 = 7\$ ✓.\n\n'
                  'Attention : si l\'équation caractéristique a une racine double \$r\$, la solution est \$u_n = (\\alpha + \\beta n) r^n\$. Ne pas oublier le facteur \$n\$ !',
              points: 3,
              rapportJury:
                  'Le jury attend la méthode complète avec vérification des conditions initiales.',
            ),
            QuestionAnnale(
              enonce:
                  'La suite de Fibonacci est définie par \$F_0 = 0\$, \$F_1 = 1\$ et '
                  '\$F_{n+2} = F_{n+1} + F_n\$. Donner l\'expression de \$F_n\$ '
                  'en fonction de \$n\$ (formule de Binet).',
              indication:
                  'Résoudre l\'équation caractéristique \$r^2 - r - 1 = 0\$. '
                  'Les racines sont le nombre d\'or \$\\phi\$ et son conjugué.',
              correction:
                  'Ce qu\'on nous demande : trouver la formule explicite des nombres de Fibonacci.\n\n'
                  'Rappel : la suite de Fibonacci apparaît en combinatoire (nombre de pavages), en botanique (phyllotaxie), et en informatique (complexité d\'algorithmes).\n\n'
                  'Équation caractéristique : \$r^2 - r - 1 = 0\$. Discriminant \$\\Delta = 5\$. Racines : \$\\phi = \\frac{1+\\sqrt{5}}{2}\$ (nombre d\'or) et \$\\hat{\\phi} = \\frac{1-\\sqrt{5}}{2}\$.\n'
                  'Solution générale : \$F_n = \\alpha \\phi^n + \\beta \\hat{\\phi}^n\$.\n'
                  '\$F_0 = 0\$ : \$\\alpha + \\beta = 0\$, donc \$\\beta = -\\alpha\$. \$F_1 = 1\$ : \$\\alpha(\\phi - \\hat{\\phi}) = 1\$, donc \$\\alpha \\sqrt{5} = 1\$, \$\\alpha = 1/\\sqrt{5}\$.\n'
                  'Formule de Binet : \$F_n = \\frac{1}{\\sqrt{5}}\\left(\\phi^n - \\hat{\\phi}^n\\right) = \\frac{1}{\\sqrt{5}}\\left[\\left(\\frac{1+\\sqrt{5}}{2}\\right)^n - \\left(\\frac{1-\\sqrt{5}}{2}\\right)^n\\right]\$.\n'
                  'Comme \$|\\hat{\\phi}| < 1\$, \$\\hat{\\phi}^n \\to 0\$, donc \$F_n \\sim \\frac{\\phi^n}{\\sqrt{5}}\$. Le rapport \$F_{n+1}/F_n \\to \\phi \\approx 1.618\$.\n\n'
                  'Attention : malgré les \$\\sqrt{5}\$ dans la formule, \$F_n\$ est toujours un entier (les parties irrationnelles s\'annulent). C\'est une belle vérification de cohérence.',
              points: 4,
              rapportJury:
                  'Le jury attend la formule de Binet avec preuve et l\'équivalent asymptotique.',
            ),
            QuestionAnnale(
              enonce:
                  'De combien de manières peut-on choisir \$k\$ objets parmi \$n\$ objets distincts '
                  '(a) sans répétition et sans ordre ? (b) avec répétition et sans ordre ? '
                  'Donner les formules et un exemple.',
              indication:
                  '(a) Combinaisons : \$\\binom{n}{k}\$. (b) Combinaisons avec répétition : \$\\binom{n+k-1}{k}\$.',
              correction:
                  'Ce qu\'on nous demande : les formules de dénombrement pour les combinaisons.\n\n'
                  'Rappel : le dénombrement est un outil fondamental en probabilités et en algèbre combinatoire.\n\n'
                  '(a) Sans répétition, sans ordre : c\'est le nombre de parties à \$k\$ éléments d\'un ensemble à \$n\$ éléments = \$\\binom{n}{k} = \\frac{n!}{k!(n-k)!}\$.\n'
                  'Exemple : choisir 3 cartes parmi 10 = \$\\binom{10}{3} = 120\$ possibilités.\n'
                  '(b) Avec répétition, sans ordre : c\'est le nombre de multi-ensembles de taille \$k\$ pris dans un ensemble à \$n\$ éléments = \$\\binom{n+k-1}{k}\$ (« stars and bars »).\n'
                  'Preuve : c\'est le nombre de solutions de \$x_1 + x_2 + \\cdots + x_n = k\$ avec \$x_i \\geq 0\$ entiers. Par le codage barres et étoiles, on place \$k\$ étoiles et \$n-1\$ barres : \$\\binom{n+k-1}{k}\$.\n'
                  'Exemple : répartir 5 bonbons identiques entre 3 enfants = \$\\binom{7}{5} = 21\$ répartitions.\n\n'
                  'Attention : ne confondez pas les 4 modèles (avec/sans répétition × avec/sans ordre). Un tableau récapitulatif est indispensable.',
              points: 3,
              rapportJury:
                  'Le jury attend les formules ET des exemples concrets pour chaque cas.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer la formule d\'inclusion-exclusion pour le cardinal '
                  'de la réunion de \$n\$ ensembles finis.',
              indication:
                  'Commencer par le cas \$n = 2\$ puis généraliser par récurrence.',
              correction:
                  'Ce qu\'on nous demande : prouver la formule du crible de Poincaré.\n\n'
                  'Rappel : pour deux ensembles : \$|A \\cup B| = |A| + |B| - |A \\cap B|\$. Pour \$n\$ ensembles, on alterne additions et soustractions.\n\n'
                  'Formule : \$|\\bigcup_{i=1}^n A_i| = \\sum_i |A_i| - \\sum_{i<j} |A_i \\cap A_j| + \\sum_{i<j<k} |A_i \\cap A_j \\cap A_k| - \\cdots + (-1)^{n+1}|A_1 \\cap \\cdots \\cap A_n|\$.\n'
                  'Soit \$|\\bigcup_{i=1}^n A_i| = \\sum_{\\emptyset \\neq S \\subset \\{1,\\ldots,n\\}} (-1)^{|S|+1} |\\bigcap_{i \\in S} A_i|\$.\n'
                  'Preuve : montrons que chaque élément \$x \\in \\bigcup A_i\$ est compté exactement 1 fois. Si \$x\$ appartient à exactement \$m\$ des \$A_i\$, sa contribution est \$\\binom{m}{1} - \\binom{m}{2} + \\cdots + (-1)^{m+1}\\binom{m}{m}\$.\n'
                  'Par la formule du binôme : \$\\sum_{k=0}^m (-1)^k \\binom{m}{k} = (1-1)^m = 0\$, donc \$\\sum_{k=1}^m (-1)^{k+1} \\binom{m}{k} = 1\$.\n'
                  'Chaque élément est bien compté 1 fois. ✓\n\n'
                  'Attention : la formule a \$2^n - 1\$ termes, ce qui la rend impraticable pour \$n\$ grand. On l\'utilise surtout pour \$n\$ petit ou quand les intersections ont une structure simple.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par comptage individuel des éléments, pas seulement la récurrence.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer le nombre de surjections de \$\\{1, \\ldots, n\\}\$ sur \$\\{1, \\ldots, p\\}\$ '
                  'avec \$n \\geq p\$ en utilisant la formule d\'inclusion-exclusion.',
              indication:
                  'Soit \$A_j\$ l\'ensemble des applications qui « évitent » l\'élément \$j\$. '
                  'Une surjection est une application qui n\'est dans aucun \$A_j\$.',
              correction:
                  'Ce qu\'on nous demande : compter les surjections par le crible d\'inclusion-exclusion.\n\n'
                  'Rappel : une surjection \$f : E \\to F\$ vérifie \$f(E) = F\$. Le nombre total d\'applications de \$E\$ à \$F\$ est \$p^n\$.\n\n'
                  'Soit \$A_j = \\{f : \\{1,\\ldots,n\\} \\to \\{1,\\ldots,p\\} : j \\notin \\text{Im}(f)\\}\$. Alors \$|A_j| = (p-1)^n\$ (on prend les valeurs dans \$\\{1,\\ldots,p\\} \\setminus \\{j\\}\$).\n'
                  'Plus généralement, \$|A_{j_1} \\cap \\cdots \\cap A_{j_k}| = (p-k)^n\$ (on évite \$k\$ éléments). Il y a \$\\binom{p}{k}\$ choix de \$k\$ éléments à éviter.\n'
                  'Le nombre de surjections est \$S(n,p) = p^n - \\binom{p}{1}(p-1)^n + \\binom{p}{2}(p-2)^n - \\cdots + (-1)^{p-1}\\binom{p}{p-1} \\cdot 1^n\$.\n'
                  'Soit \$S(n,p) = \\sum_{k=0}^{p} (-1)^k \\binom{p}{k} (p-k)^n\$.\n'
                  'Exemple : \$n = 3, p = 2\$ : \$S(3,2) = 2^3 - \\binom{2}{1} \\cdot 1^3 = 8 - 2 = 6\$ surjections. Vérification : ce sont les 6 applications non constantes. ✓\n\n'
                  'Attention : ne confondez pas surjections et bijections. Les bijections n\'existent que quand \$n = p\$ et leur nombre est \$p!\$ = \$S(p,p)\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la formule complète et un exemple numérique de vérification.',
            ),
          ],
        ),
        // ── Partie IV ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie IV – Congruences et polynômes',
          introduction:
              'Cette partie porte sur l\'arithmétique des congruences, '
              'le petit théorème de Fermat, le théorème chinois et la théorie des polynômes.',
          bareme: 5,
          themes: ['Congruences', 'Arithmétique', 'Polynômes'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le petit théorème de Fermat : '
                  'si \$p\$ est premier et \$\\gcd(a, p) = 1\$, alors \$a^{p-1} \\equiv 1 \\pmod{p}\$.',
              indication:
                  'Considérer les éléments \$a, 2a, 3a, \\ldots, (p-1)a\$ modulo \$p\$ '
                  'et montrer qu\'ils forment une permutation de \$\\{1, 2, \\ldots, p-1\\}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le petit théorème de Fermat, résultat fondamental d\'arithmétique.\n\n'
                  'Rappel : ce théorème est à la base de la cryptographie RSA et du test de primalité de Fermat.\n\n'
                  'Considérons les \$p-1\$ nombres \$a, 2a, 3a, \\ldots, (p-1)a\$ modulo \$p\$.\n'
                  'Aucun n\'est \$\\equiv 0 \\pmod{p}\$ (car \$\\gcd(a,p) = 1\$ et \$1 \\leq k \\leq p-1\$).\n'
                  'Ils sont deux à deux distincts modulo \$p\$ : si \$ia \\equiv ja \\pmod{p}\$, alors \$p | (i-j)a\$, et comme \$\\gcd(a,p) = 1\$, \$p | (i-j)\$, impossible si \$1 \\leq i, j \\leq p-1\$.\n'
                  'Donc \$\\{a, 2a, \\ldots, (p-1)a\\} \\equiv \\{1, 2, \\ldots, p-1\\} \\pmod{p}\$ (c\'est une permutation).\n'
                  'En multipliant : \$a \\cdot 2a \\cdots (p-1)a \\equiv 1 \\cdot 2 \\cdots (p-1) \\pmod{p}\$, soit \$a^{p-1} (p-1)! \\equiv (p-1)! \\pmod{p}\$.\n'
                  'Comme \$\\gcd((p-1)!, p) = 1\$ (aucun facteur de \$(p-1)!\$ n\'est divisible par \$p\$), on simplifie : \$a^{p-1} \\equiv 1 \\pmod{p}\$.\n\n'
                  'Attention : le théorème est FAUX si \$p\$ n\'est pas premier. Cependant, il existe des « nombres de Carmichael » (ex. 561) composés tels que \$a^{n-1} \\equiv 1 \\pmod{n}\$ pour tout \$a\$ premier avec \$n\$.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par permutation (la plus élémentaire) avec justification de chaque étape.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre le système de congruences \$x \\equiv 2 \\pmod{3}\$ et '
                  '\$x \\equiv 3 \\pmod{5}\$ en utilisant le théorème chinois des restes.',
              indication:
                  'Comme \$\\gcd(3, 5) = 1\$, le système a une solution unique modulo 15.',
              correction:
                  'Ce qu\'on nous demande : résoudre un système de congruences simultanées.\n\n'
                  'Rappel (TCR) : si \$\\gcd(m_1, m_2) = 1\$, le système \$x \\equiv a_1 \\pmod{m_1}\$, \$x \\equiv a_2 \\pmod{m_2}\$ a une unique solution modulo \$m_1 m_2\$.\n\n'
                  'Ici \$m_1 = 3, m_2 = 5, a_1 = 2, a_2 = 3\$. On cherche \$x \\equiv 2 \\pmod{3}\$ et \$x \\equiv 3 \\pmod{5}\$.\n'
                  'Méthode directe : \$x = 3k + 2\$ pour un entier \$k\$. On substitue : \$3k + 2 \\equiv 3 \\pmod{5}\$, soit \$3k \\equiv 1 \\pmod{5}\$.\n'
                  'L\'inverse de 3 modulo 5 est 2 (car \$3 \\times 2 = 6 \\equiv 1 \\pmod{5}\$). Donc \$k \\equiv 2 \\pmod{5}\$, soit \$k = 5j + 2\$.\n'
                  'Finalement \$x = 3(5j + 2) + 2 = 15j + 8\$, donc \$x \\equiv 8 \\pmod{15}\$.\n'
                  'Vérification : \$8 = 2 \\times 3 + 2\$ ✓ et \$8 = 1 \\times 5 + 3\$ ✓.\n\n'
                  'Attention : le TCR s\'étend à \$n\$ congruences avec des moduli deux à deux premiers entre eux. La solution est unique modulo \$\\prod m_i\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la résolution complète avec vérification et la mention de l\'unicité modulo 15.',
            ),
            QuestionAnnale(
              enonce:
                  'Effectuer la division euclidienne de \$A(X) = X^4 + 2X^3 - X + 3\$ par '
                  '\$B(X) = X^2 + X - 1\$ dans \$\\mathbb{Q}[X]\$.',
              indication:
                  'Poser la division comme en arithmétique : diviser les termes de plus haut degré successivement.',
              correction:
                  'Ce qu\'on nous demande : trouver \$Q\$ (quotient) et \$R\$ (reste) tels que \$A = BQ + R\$ avec \$\\deg(R) < \\deg(B) = 2\$.\n\n'
                  'Rappel : la division euclidienne de polynômes fonctionne exactement comme la division euclidienne des entiers. À chaque étape, on divise le monôme de plus haut degré.\n\n'
                  'Étape 1 : \$X^4 \\div X^2 = X^2\$. On retranche \$X^2(X^2+X-1) = X^4+X^3-X^2\$ : reste \$X^3 + X^2 - X + 3\$.\n'
                  'Étape 2 : \$X^3 \\div X^2 = X\$. On retranche \$X(X^2+X-1) = X^3+X^2-X\$ : reste \$3\$.\n'
                  'Résultat : \$Q(X) = X^2 + X\$ et \$R(X) = 3\$.\n'
                  'Vérification : \$(X^2+X)(X^2+X-1) + 3 = X^4+X^3-X^2+X^3+X^2-X+3 = X^4+2X^3-X+3 = A(X)\$ ✓.\n'
                  '\$\\deg(R) = 0 < 2 = \\deg(B)\$ ✓.\n\n'
                  'Attention : la division euclidienne n\'est possible que si le coefficient dominant de \$B\$ est inversible dans le corps de base. Sur \$\\mathbb{Z}\$, il faut que ce coefficient soit \$\\pm 1\$ (ou faire une pseudo-division).',
              points: 3,
              rapportJury:
                  'Le jury attend un calcul propre, posé étape par étape, avec vérification finale.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer le PGCD de \$A(X) = X^3 - 1\$ et \$B(X) = X^2 - 1\$ dans \$\\mathbb{Q}[X]\$ '
                  'par l\'algorithme d\'Euclide.',
              indication:
                  'Effectuer les divisions euclidiennes successives jusqu\'au reste nul.',
              correction:
                  'Ce qu\'on nous demande : trouver \$\\gcd(X^3-1, X^2-1)\$ par l\'algorithme d\'Euclide.\n\n'
                  'Rappel : l\'algorithme d\'Euclide pour les polynômes est identique à celui des entiers. On divise, on prend le reste, et on itère.\n\n'
                  'Division de \$A\$ par \$B\$ : \$X^3 - 1 = (X^2 - 1) \\cdot X + (X^2 \\cdot 0 + X - 1)\$. Vérifions : \$(X^2-1)X + (X-1) = X^3 - X + X - 1 = X^3 - 1\$ ✓. Reste : \$R_1 = X - 1\$.\n'
                  'Division de \$B\$ par \$R_1\$ : \$X^2 - 1 = (X-1)(X+1) + 0\$. Reste nul.\n'
                  'Donc \$\\gcd(X^3-1, X^2-1) = X - 1\$ (unitaire).\n'
                  'Vérification par factorisation : \$X^3-1 = (X-1)(X^2+X+1)\$ et \$X^2-1 = (X-1)(X+1)\$. Le facteur commun est bien \$(X-1)\$.\n'
                  'Identité de Bézout : on remonte l\'algorithme : \$X - 1 = (X^3-1) - X(X^2-1)\$, donc \$u = 1, v = -X\$ avec \$uA + vB = \\gcd(A,B)\$.\n\n'
                  'Attention : le PGCD est défini à un scalaire près. Par convention, on le prend unitaire (coefficient dominant = 1).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'algorithme d\'Euclide complet et la remontée pour obtenir les coefficients de Bézout.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que le polynôme \$X^4 + 1\$ est irréductible sur \$\\mathbb{Q}\$ '
                  'mais réductible sur \$\\mathbb{F}_p\$ pour tout premier \$p\$.',
              indication:
                  'Sur \$\\mathbb{Q}\$ : utiliser le changement \$X \\to X+1\$ puis Eisenstein. '
                  'Sur \$\\mathbb{F}_p\$ : distinguer les cas \$p = 2\$ et \$p\$ impair.',
              correction:
                  'Ce qu\'on nous demande : un résultat surprenant — un polynôme irréductible sur \$\\mathbb{Q}\$ mais réductible modulo tout premier.\n\n'
                  'Rappel : l\'irréductibilité dépend du corps ! Un polynôme peut être irréductible sur un corps et réductible sur un autre.\n\n'
                  'Sur \$\\mathbb{Q}\$ : posons \$P(X) = X^4 + 1\$ et calculons \$P(X+1) = (X+1)^4 + 1 = X^4 + 4X^3 + 6X^2 + 4X + 2\$.\n'
                  'Eisenstein avec \$p = 2\$ : \$2 \\nmid 1\$, \$2 | 4, 6, 4, 2\$, \$4 \\nmid 2\$ ✓. Donc \$P(X+1)\$ est irréductible sur \$\\mathbb{Q}\$, et donc \$P(X)\$ aussi.\n'
                  'Sur \$\\mathbb{F}_2\$ : \$X^4 + 1 = (X+1)^4\$ (car en caractéristique 2, \$1 = -1\$). Réductible ✓.\n'
                  'Sur \$\\mathbb{F}_p\$ (\$p\$ impair) : comme \$p\$ est impair, \$(\\mathbb{F}_p^*)^2\$ est d\'indice 2. On montre qu\'un des éléments \$-1, 2, -2\$ est un carré dans \$\\mathbb{F}_p\$, ce qui permet de factoriser \$X^4+1\$ en produit de deux facteurs quadratiques.\n'
                  'Par exemple, si \$-1 = i^2\$ dans \$\\mathbb{F}_p\$, alors \$X^4+1 = (X^2+i)(X^2-i)\$. Si \$2 = a^2\$, alors \$X^4+1 = (X^2+aX+1)(X^2-aX+1)\$.\n\n'
                  'Attention : ce phénomène montre que l\'irréductibilité sur \$\\mathbb{Q}\$ n\'implique PAS l\'irréductibilité modulo \$p\$. Les polynômes cyclotomiques d\'ordre premier sont les « bons » exemples où l\'irréductibilité se conserve.',
              points: 4,
              rapportJury:
                  'Le jury valorise les candidats qui traitent les deux sens complètement. La factorisation sur \$\\mathbb{F}_p\$ doit être justifiée.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2025 – Mathématiques générales
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2025MG() {
    return Annale(
      id: 'ped_ext_2025_mg',
      annee: 2025,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2025 – Mathématiques générales (correction pédagogique)',
      description:
          'Correction pédagogique ultra-détaillée de l\'épreuve de mathématiques générales 2025 '
          '(algèbre linéaire, polynômes, groupes, anneaux, géométrie). Chaque question est décortiquée '
          'pas à pas, avec rappels de cours et pièges à éviter.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Polynômes', 'Groupes', 'Anneaux', 'Géométrie'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg25.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Endomorphismes nilpotents',
        'Décomposition des noyaux',
        'Théorèmes de Sylow',
        'Anneaux quotients',
        'Isométries du plan',
      ],
      rapportGlobal:
          'Cette épreuve couvre l\'algèbre linéaire, la théorie des groupes et des anneaux, '
          'ainsi que la géométrie euclidienne. Notre correction pédagogique reprend chaque question '
          'en détaillant les rappels de cours, les étapes de raisonnement et les pièges classiques. '
          'Prenez le temps de comprendre chaque étape. Courage !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre linéaire et polynômes',
          introduction:
              'Cette partie porte sur les endomorphismes, la réduction, '
              'les polynômes et leurs applications en algèbre linéaire.',
          bareme: 7,
          themes: ['Algèbre linéaire', 'Polynômes', 'Endomorphismes'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$u\$ un endomorphisme nilpotent d\'un \$\\mathbb{K}\$-espace vectoriel \$E\$ '
                  'de dimension finie \$n\$. Montrer que \$\\mathrm{tr}(u) = 0\$.',
              indication:
                  'Déterminer les valeurs propres d\'un endomorphisme nilpotent, '
                  'puis utiliser le lien trace / polynôme caractéristique.',
              correction:
                  'Ce qu\'on nous demande : prouver que la trace d\'un endomorphisme nilpotent est nulle.\n\n'
                  'Rappel : \$u\$ nilpotent signifie \$u^k = 0\$ pour un certain \$k \\geq 1\$. La trace est la somme des valeurs propres (avec multiplicité).\n\n'
                  'Si \$\\lambda\$ est valeur propre : \$u(x) = \\lambda x\$ avec \$x \\neq 0\$, donc \$u^k(x) = \\lambda^k x = 0\$, d\'où \$\\lambda = 0\$.\n'
                  'Toutes les valeurs propres sont nulles, donc \$\\chi_u = X^n\$.\n'
                  'La trace est l\'opposé du coefficient de \$X^{n-1}\$ dans \$\\chi_u = X^n\$, soit \$\\mathrm{tr}(u) = 0\$.\n'
                  'Par trigonalisation : \$u\$ est trigonalisable (car \$\\chi_u\$ scindé) avec des 0 sur la diagonale.\n\n'
                  'Attention : la réciproque est fausse ! \$\\mathrm{diag}(1,-1)\$ a une trace nulle sans être nilpotente.',
              points: 2,
              rapportJury:
                  'Question classique. Le jury attend la détermination des valeurs propres comme étape clé.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$P, Q \\in \\mathbb{K}[X]\$ premiers entre eux tels que \$(PQ)(u) = 0\$. '
                  'Montrer que \$E = \\ker(P(u)) \\oplus \\ker(Q(u))\$.',
              indication:
                  'Utiliser l\'identité de Bézout pour les polynômes : \$UP + VQ = 1\$.',
              correction:
                  'Ce qu\'on nous demande : démontrer le lemme de décomposition des noyaux.\n\n'
                  'Rappel : si \$\\mathrm{pgcd}(P,Q) = 1\$, Bézout donne \$U, V \\in \\mathbb{K}[X]\$ avec \$UP + VQ = 1\$.\n\n'
                  'En substituant \$u\$ : \$U(u) \\circ P(u) + V(u) \\circ Q(u) = \\mathrm{Id}_E\$.\n'
                  'Pour \$x \\in E\$, posons \$x_1 = V(u)(Q(u)(x))\$ et \$x_2 = U(u)(P(u)(x))\$. Alors \$x = x_1 + x_2\$.\n'
                  'On vérifie \$P(u)(x_1) = V(u)((PQ)(u)(x)) = 0\$ donc \$x_1 \\in \\ker(P(u))\$. De même \$x_2 \\in \\ker(Q(u))\$.\n'
                  'Somme directe : si \$x \\in \\ker(P(u)) \\cap \\ker(Q(u))\$, alors \$x = U(u)(P(u)(x)) + V(u)(Q(u)(x)) = 0\$.\n'
                  'Conclusion : \$E = \\ker(P(u)) \\oplus \\ker(Q(u))\$.\n\n'
                  'Attention : l\'hypothèse \$\\mathrm{pgcd}(P,Q) = 1\$ est indispensable. Sans elle, la décomposition peut échouer.',
              points: 3,
              rapportJury:
                  'Résultat fondamental. Le jury attend la preuve complète avec vérification de la somme directe.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$x_0, \\ldots, x_n\$ des éléments distincts de \$\\mathbb{K}\$ et \$y_0, \\ldots, y_n \\in \\mathbb{K}\$. '
                  'Montrer qu\'il existe un unique \$P \\in \\mathbb{K}_n[X]\$ tel que \$P(x_i) = y_i\$ pour tout \$i\$.',
              indication:
                  'Construire les polynômes de Lagrange \$L_i(X) = \\prod_{j \\neq i} \\frac{X - x_j}{x_i - x_j}\$.',
              correction:
                  'Ce qu\'on nous demande : existence et unicité du polynôme d\'interpolation de Lagrange.\n\n'
                  'Rappel : les polynômes de Lagrange sont \$L_i(X) = \\prod_{j \\neq i} \\frac{X - x_j}{x_i - x_j}\$, vérifiant \$L_i(x_j) = \\delta_{ij}\$.\n\n'
                  'Existence : posons \$P = \\sum_{i=0}^{n} y_i L_i\$. Alors \$P(x_k) = \\sum_i y_i L_i(x_k) = y_k\$ et \$\\deg(P) \\leq n\$ ✓.\n'
                  'Unicité : si \$P\$ et \$Q\$ conviennent, \$P - Q\$ est de degré \$\\leq n\$ et s\'annule en \$n+1\$ points distincts.\n'
                  'Un polynôme de degré \$\\leq n\$ ayant \$n+1\$ racines est nul, donc \$P = Q\$.\n'
                  'Argument dimensionnel : l\'évaluation \$P \\mapsto (P(x_0), \\ldots, P(x_n))\$ est linéaire de \$\\mathbb{K}_n[X]\$ dans \$\\mathbb{K}^{n+1}\$, injective par l\'unicité, donc bijective.\n\n'
                  'Attention : le degré est \$\\leq n\$, pas exactement \$n\$. Il peut être strictement inférieur.',
              points: 2,
              rapportJury:
                  'Le jury attend la construction explicite ET la preuve d\'unicité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A = \\mathrm{diag}(\\lambda_1, \\ldots, \\lambda_n)\$ avec les \$\\lambda_i\$ deux à deux distincts. '
                  'Montrer que le commutant \$C(A) = \\{M \\in \\mathcal{M}_n(\\mathbb{K}) : MA = AM\\}\$ '
                  'est l\'ensemble des matrices diagonales.',
              indication:
                  'Écrire la condition \$MA = AM\$ coefficient par coefficient.',
              correction:
                  'Ce qu\'on nous demande : caractériser les matrices qui commutent avec une matrice diagonale à valeurs propres distinctes.\n\n'
                  'Rappel : le commutant \$C(A)\$ est un sous-espace vectoriel de \$\\mathcal{M}_n(\\mathbb{K})\$.\n\n'
                  'Posons \$M = (m_{ij})\$. On a \$(MA)_{ij} = m_{ij}\\lambda_j\$ et \$(AM)_{ij} = \\lambda_i m_{ij}\$.\n'
                  'La condition \$MA = AM\$ donne \$m_{ij}(\\lambda_j - \\lambda_i) = 0\$ pour tout \$(i,j)\$.\n'
                  'Comme les \$\\lambda_i\$ sont distincts, \$\\lambda_j - \\lambda_i \\neq 0\$ pour \$i \\neq j\$, donc \$m_{ij} = 0\$ si \$i \\neq j\$.\n'
                  'Ainsi \$M\$ est diagonale. Réciproquement, toute matrice diagonale commute avec \$A\$.\n'
                  'Le commutant est l\'espace des matrices diagonales, de dimension \$n\$.\n\n'
                  'Attention : si les \$\\lambda_i\$ ne sont pas tous distincts, le commutant est plus gros. Par exemple, \$C(I_n) = \\mathcal{M}_n(\\mathbb{K})\$.',
              points: 3,
              rapportJury:
                  'Le jury attend un calcul coefficient par coefficient rigoureux.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer le critère d\'Eisenstein et l\'appliquer pour montrer que '
                  '\$P(X) = X^4 + 6X^3 + 9X^2 + 3X + 3\$ est irréductible sur \$\\mathbb{Q}\$.',
              indication:
                  'Tester le critère avec le premier \$p = 3\$.',
              correction:
                  'Ce qu\'on nous demande : appliquer Eisenstein pour prouver l\'irréductibilité sur \$\\mathbb{Q}\$.\n\n'
                  'Rappel (critère d\'Eisenstein) : soit \$P = a_n X^n + \\cdots + a_0 \\in \\mathbb{Z}[X]\$ et \$p\$ premier. Si \$p \\nmid a_n\$, \$p \\mid a_i\$ pour \$i < n\$, et \$p^2 \\nmid a_0\$, alors \$P\$ est irréductible sur \$\\mathbb{Q}\$.\n\n'
                  'Ici \$P = X^4 + 6X^3 + 9X^2 + 3X + 3\$ et \$p = 3\$.\n'
                  'Vérification : \$3 \\nmid 1\$ (coefficient dominant) ✓, \$3 \\mid 6, 9, 3, 3\$ ✓, \$9 \\nmid 3\$ (terme constant) ✓.\n'
                  'Le critère d\'Eisenstein s\'applique avec \$p = 3\$ : \$P\$ est irréductible sur \$\\mathbb{Q}\$.\n\n'
                  'Attention : Eisenstein ne s\'applique pas toujours directement. Parfois il faut un changement de variable \$X \\to X + a\$ pour révéler un premier convenable.',
              points: 2,
              rapportJury:
                  'Le jury attend l\'énoncé précis du critère avant son application.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$P = X^2 - 1\$ et \$Q = X^2 - 2X + 1\$ dans \$\\mathbb{Q}[X]\$. '
                  'Calculer leur résultant \$\\mathrm{Res}(P, Q)\$ et en déduire leur PGCD.',
              indication:
                  'Le résultant est le déterminant de la matrice de Sylvester. '
                  '\$\\mathrm{Res}(P,Q) = 0\$ ssi les polynômes ont une racine commune.',
              correction:
                  'Ce qu\'on nous demande : calculer le résultant et en déduire s\'il y a une racine commune.\n\n'
                  'Rappel : le résultant \$\\mathrm{Res}(P,Q)\$ est le déterminant de la matrice de Sylvester. Il vaut 0 ssi \$P\$ et \$Q\$ ont une racine commune dans la clôture algébrique.\n\n'
                  'Factorisons : \$P = (X-1)(X+1)\$ et \$Q = (X-1)^2\$. Racine commune : \$X = 1\$.\n'
                  'Donc \$\\mathrm{Res}(P,Q) = 0\$ et \$\\mathrm{pgcd}(P,Q) = X - 1\$.\n'
                  'Vérification par Euclide : \$X^2 - 1 = (X^2 - 2X + 1) \\cdot 1 + (2X - 2)\$, puis \$X^2 - 2X + 1 = (2X-2) \\cdot \\frac{X-1}{2}\$. Reste nul.\n'
                  'Donc \$\\mathrm{pgcd} = X - 1\$ (unitaire) ✓.\n'
                  'Identité de Bézout : \$2X - 2 = 1 \\cdot (X^2-1) + (-1) \\cdot (X^2-2X+1)\$, soit \$X-1 = \\frac{1}{2}(X^2-1) - \\frac{1}{2}(X^2-2X+1)\$.\n\n'
                  'Attention : le résultant est puissant mais son calcul direct via Sylvester est laborieux. Préférez la factorisation quand c\'est possible.',
              points: 2,
              rapportJury:
                  'Le jury valorise la double approche : factorisation et algorithme d\'Euclide.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Groupes et anneaux',
          introduction:
              'Cette partie explore la théorie des groupes, les anneaux '
              'et leurs propriétés structurelles.',
          bareme: 7,
          themes: ['Groupes', 'Anneaux', 'Morphismes'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Montrer que tout sous-groupe de \$(\\mathbb{Z}, +)\$ est de la forme '
                  '\$n\\mathbb{Z}\$ pour un certain \$n \\in \\mathbb{N}\$.',
              indication:
                  'Si le sous-groupe est non trivial, considérer son plus petit élément strictement positif.',
              correction:
                  'Ce qu\'on nous demande : classifier les sous-groupes de \$(\\mathbb{Z}, +)\$.\n\n'
                  'Rappel : un sous-groupe \$H\$ de \$(\\mathbb{Z}, +)\$ est stable par addition et par passage à l\'opposé.\n\n'
                  'Si \$H = \\{0\\}\$, alors \$H = 0\\mathbb{Z}\$ ✓.\n'
                  'Sinon, \$H\$ contient un élément non nul \$a\$. Par stabilité, \$|a| \\in H \\cap \\mathbb{N}^*\$.\n'
                  'Soit \$n = \\min(H \\cap \\mathbb{N}^*)\$ (existe par bonne ordination).\n'
                  'Inclusion \$n\\mathbb{Z} \\subseteq H\$ : claire par stabilité de \$H\$.\n'
                  'Inclusion \$H \\subseteq n\\mathbb{Z}\$ : pour \$h \\in H\$, division euclidienne \$h = nq + r\$ avec \$0 \\leq r < n\$. Comme \$r = h - nq \\in H\$ et \$r < n\$, la minimalité impose \$r = 0\$.\n\n'
                  'Attention : cet argument utilise la division euclidienne dans \$\\mathbb{Z}\$. Il se généralise aux anneaux euclidiens.',
              points: 2,
              rapportJury:
                  'Le jury attend la preuve complète avec la division euclidienne.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$G\$ un \$p\$-groupe fini non trivial (\$|G| = p^k\$, \$k \\geq 1\$). '
                  'Montrer que le centre \$Z(G)\$ est non trivial.',
              indication:
                  'Utiliser l\'équation des classes et un argument de congruence modulo \$p\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$Z(G) \\neq \\{e\\}\$ pour un \$p\$-groupe fini.\n\n'
                  'Rappel : l\'équation des classes est \$|G| = |Z(G)| + \\sum [G : C_G(g_i)]\$ où la somme porte sur les classes de conjugaison non centrales.\n\n'
                  'Chaque indice \$[G : C_G(g_i)]\$ divise \$|G| = p^k\$, donc est une puissance de \$p\$.\n'
                  'Comme \$g_i \\notin Z(G)\$, sa classe a au moins 2 éléments, donc \$[G : C_G(g_i)] \\geq p\$.\n'
                  'Chaque terme de la somme est divisible par \$p\$, et \$|G| \\equiv 0 \\pmod{p}\$.\n'
                  'Donc \$|Z(G)| \\equiv 0 \\pmod{p}\$. Comme \$e \\in Z(G)\$, on a \$|Z(G)| \\geq p \\geq 2\$.\n\n'
                  'Attention : ce résultat implique que tout \$p\$-groupe est nilpotent (au sens des groupes). C\'est un outil fondamental pour les théorèmes de Sylow.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'utilisation de l\'équation des classes. L\'argument modulo \$p\$ doit être rigoureux.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A\$ un anneau commutatif unitaire et \$I\$ un idéal de \$A\$. '
                  'Montrer que \$I\$ est maximal si et seulement si \$A/I\$ est un corps.',
              indication:
                  'Utiliser la correspondance entre idéaux de \$A/I\$ et idéaux de \$A\$ contenant \$I\$.',
              correction:
                  'Ce qu\'on nous demande : établir le lien entre idéaux maximaux et corps quotients.\n\n'
                  'Rappel : \$I\$ est maximal si \$I \\neq A\$ et il n\'existe aucun idéal \$J\$ avec \$I \\subsetneq J \\subsetneq A\$. La projection \$\\pi : A \\to A/I\$ induit une bijection entre les idéaux de \$A\$ contenant \$I\$ et ceux de \$A/I\$.\n\n'
                  '(\$\\Rightarrow\$) Si \$I\$ maximal : les seuls idéaux contenant \$I\$ sont \$I\$ et \$A\$. Par correspondance, \$A/I\$ n\'a que \$\\{0\\}\$ et \$A/I\$ comme idéaux. Donc \$A/I\$ est un corps.\n'
                  '(\$\\Leftarrow\$) Si \$A/I\$ est un corps : ses seuls idéaux sont triviaux. Par correspondance, les seuls idéaux contenant \$I\$ sont \$I\$ et \$A\$. Donc \$I\$ est maximal.\n\n'
                  'Attention : ne confondez pas maximal et premier. \$I\$ premier \$\\Leftrightarrow\$ \$A/I\$ intègre. Tout maximal est premier, mais pas réciproquement en général (ex : \$(0)\$ dans \$\\mathbb{Z}\$).',
              points: 3,
              rapportJury:
                  'Le jury attend les deux implications avec la correspondance des idéaux.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer \$\\varphi(60)\$ où \$\\varphi\$ est l\'indicatrice d\'Euler, '
                  'et déterminer la structure de \$(\\mathbb{Z}/60\\mathbb{Z})^*\$.',
              indication:
                  'Décomposer \$60 = 2^2 \\cdot 3 \\cdot 5\$ et utiliser le théorème chinois.',
              correction:
                  'Ce qu\'on nous demande : calculer le cardinal et la structure du groupe des unités de \$\\mathbb{Z}/60\\mathbb{Z}\$.\n\n'
                  'Rappel : \$\\varphi(n) = n \\prod_{p \\mid n}(1 - 1/p)\$ et le TCR donne \$(\\mathbb{Z}/n\\mathbb{Z})^* \\simeq \\prod (\\mathbb{Z}/p_i^{a_i}\\mathbb{Z})^*\$.\n\n'
                  'On a \$60 = 2^2 \\cdot 3 \\cdot 5\$.\n'
                  '\$\\varphi(60) = \\varphi(4)\\varphi(3)\\varphi(5) = 2 \\cdot 2 \\cdot 4 = 16\$.\n'
                  'Par le TCR : \$(\\mathbb{Z}/60\\mathbb{Z})^* \\simeq (\\mathbb{Z}/4\\mathbb{Z})^* \\times (\\mathbb{Z}/3\\mathbb{Z})^* \\times (\\mathbb{Z}/5\\mathbb{Z})^* \\simeq \\mathbb{Z}/2\\mathbb{Z} \\times \\mathbb{Z}/2\\mathbb{Z} \\times \\mathbb{Z}/4\\mathbb{Z}\$.\n'
                  'Ce groupe a 16 éléments et n\'est PAS cyclique (il contient \$\\mathbb{Z}/2\\mathbb{Z} \\times \\mathbb{Z}/2\\mathbb{Z}\$).\n\n'
                  'Attention : \$(\\mathbb{Z}/n\\mathbb{Z})^*\$ est cyclique ssi \$n \\in \\{1, 2, 4, p^k, 2p^k\\}\$ avec \$p\$ premier impair.',
              points: 2,
              rapportJury:
                  'Le jury valorise l\'utilisation du TCR pour la structure du groupe.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$p < q\$ deux nombres premiers avec \$p \\nmid (q - 1)\$. '
                  'Montrer que tout groupe d\'ordre \$pq\$ est cyclique.',
              indication:
                  'Utiliser les théorèmes de Sylow pour l\'unicité des Sylow.',
              correction:
                  'Ce qu\'on nous demande : classifier les groupes d\'ordre \$pq\$ sous l\'hypothèse \$p \\nmid (q-1)\$.\n\n'
                  'Rappel (Sylow) : \$n_r \\equiv 1 \\pmod{r}\$ et \$n_r\$ divise le cofacteur. Un Sylow unique est distingué.\n\n'
                  'Pour \$n_q\$ : \$n_q \\mid p\$ donc \$n_q \\in \\{1, p\\}\$. Si \$n_q = p\$, alors \$p \\equiv 1 \\pmod{q}\$, impossible car \$p < q\$. Donc \$n_q = 1\$.\n'
                  'Pour \$n_p\$ : \$n_p \\mid q\$ donc \$n_p \\in \\{1, q\\}\$. Si \$n_p = q\$, alors \$q \\equiv 1 \\pmod{p}\$, i.e. \$p \\mid (q-1)\$, contredit l\'hypothèse. Donc \$n_p = 1\$.\n'
                  'Soient \$H \\simeq \\mathbb{Z}/q\\mathbb{Z}\$ et \$K \\simeq \\mathbb{Z}/p\\mathbb{Z}\$ les uniques Sylow (distingués).\n'
                  '\$H \\cap K = \\{e\\}\$ et \$|HK| = pq = |G|\$. Donc \$G = H \\times K \\simeq \\mathbb{Z}/pq\\mathbb{Z}\$ (car \$\\mathrm{pgcd}(p,q) = 1\$).\n\n'
                  'Attention : si \$p \\mid (q-1)\$, il existe un groupe non abélien d\'ordre \$pq\$ (produit semi-direct). Ex : \$S_3\$ pour \$pq = 6\$.',
              points: 4,
              rapportJury:
                  'Le jury attend les théorèmes de Sylow et la conclusion par produit direct.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Géométrie',
          introduction:
              'Cette partie porte sur les isométries, les groupes de symétrie, '
              'le barycentre et les coniques.',
          bareme: 6,
          themes: ['Isométries', 'Groupes de symétrie', 'Coniques'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Classifier les isométries du plan euclidien orienté '
                  'selon qu\'elles conservent ou renversent l\'orientation.',
              indication:
                  'Distinguer les isométries directes (det = 1) et indirectes (det = -1), '
                  'puis analyser l\'existence de points fixes.',
              correction:
                  'Ce qu\'on nous demande : donner la classification complète des isométries du plan.\n\n'
                  'Rappel : toute isométrie affine \$f\$ du plan s\'écrit \$f(M) = A + \\vec{u}(\\overrightarrow{AM})\$ où \$\\vec{u}\$ est une isométrie vectorielle.\n\n'
                  'Isométries vectorielles en dimension 2 : rotations (\$\\det = 1\$) et réflexions (\$\\det = -1\$).\n'
                  'Isométries directes : si la partie linéaire est \$\\mathrm{Id}\$, c\'est une translation. Sinon, c\'est une rotation d\'angle \$\\theta \\neq 0\$ (point fixe unique).\n'
                  'Isométries indirectes : si \$f\$ a un point fixe, c\'est une réflexion (axe de symétrie). Sinon, c\'est un glissement-réflexion (réflexion + translation le long de l\'axe).\n'
                  'Bilan : translation, rotation, réflexion, glissement-réflexion.\n\n'
                  'Attention : en dimension 3, la classification est plus riche (vis, rotations impropres). Ici on est en dimension 2 uniquement.',
              points: 3,
              rapportJury:
                  'Le jury attend les 4 types avec justification par l\'existence de points fixes.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$D_n\$ le groupe des isométries d\'un polygone régulier à \$n\$ côtés. '
                  'Montrer que \$|D_n| = 2n\$ et décrire ses éléments.',
              indication:
                  'Dénombrer les rotations et les réflexions préservant le polygone.',
              correction:
                  'Ce qu\'on nous demande : décrire la structure du groupe diédral \$D_n\$.\n\n'
                  'Rappel : \$D_n\$ est le groupe des isométries affines préservant un polygone régulier à \$n\$ sommets.\n\n'
                  'Rotations : les angles \$2k\\pi/n\$ pour \$k = 0, \\ldots, n-1\$ préservent le polygone. Cela fait \$n\$ rotations.\n'
                  'Réflexions : \$n\$ axes de symétrie. Donc \$n\$ réflexions.\n'
                  'Au total : \$|D_n| = 2n\$.\n'
                  'Avec \$r\$ = rotation de \$2\\pi/n\$ et \$s\$ = une réflexion : \$r^n = s^2 = \\mathrm{Id}\$ et \$srs = r^{-1}\$.\n'
                  'Tout élément s\'écrit \$r^k\$ ou \$sr^k\$ : \$D_n = \\langle r, s \\rangle\$.\n\n'
                  'Attention : \$D_n\$ est non abélien pour \$n \\geq 3\$ car \$sr \\neq rs\$.',
              points: 2,
              rapportJury:
                  'Le jury attend le décompte précis et les relations \$r^n = s^2 = e\$, \$srs = r^{-1}\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$A, B, C\$ trois points non alignés. Soit \$G\$ le barycentre de '
                  '\$(A, 1), (B, 2), (C, 3)\$. Exprimer \$\\overrightarrow{AG}\$ en fonction de '
                  '\$\\overrightarrow{AB}\$ et \$\\overrightarrow{AC}\$.',
              indication:
                  'Utiliser \$\\overrightarrow{AG} = \\frac{\\sum \\alpha_i \\overrightarrow{AP_i}}{\\sum \\alpha_i}\$.',
              correction:
                  'Ce qu\'on nous demande : calculer la position du barycentre pondéré.\n\n'
                  'Rappel : le barycentre de \$(P_i, \\alpha_i)\$ est l\'unique \$G\$ tel que \$\\sum \\alpha_i \\overrightarrow{GP_i} = \\vec{0}\$, quand \$\\sum \\alpha_i \\neq 0\$.\n\n'
                  'Ici \$\\sum \\alpha_i = 1 + 2 + 3 = 6 \\neq 0\$.\n'
                  '\$\\overrightarrow{AG} = \\frac{1 \\cdot \\overrightarrow{AA} + 2 \\cdot \\overrightarrow{AB} + 3 \\cdot \\overrightarrow{AC}}{6} = \\frac{1}{3}\\overrightarrow{AB} + \\frac{1}{2}\\overrightarrow{AC}\$.\n'
                  'Vérification : si \$A = (0,0)\$, \$B = (1,0)\$, \$C = (0,1)\$, alors \$G = (1/3, 1/2)\$ ✓.\n'
                  'On vérifie aussi \$1 \\cdot \\overrightarrow{GA} + 2 \\cdot \\overrightarrow{GB} + 3 \\cdot \\overrightarrow{GC} = \\vec{0}\$ ✓.\n\n'
                  'Attention : si \$\\sum \\alpha_i = 0\$, le barycentre n\'est pas un point mais un vecteur.',
              points: 2,
              rapportJury:
                  'Le jury attend la formule et une vérification.',
            ),
            QuestionAnnale(
              enonce:
                  'Réduire la conique d\'équation \$5x^2 + 4xy + 2y^2 - 6 = 0\$ '
                  'et préciser sa nature.',
              indication:
                  'Diagonaliser la matrice de la partie quadratique pour trouver les axes.',
              correction:
                  'Ce qu\'on nous demande : déterminer la nature de la conique et son équation réduite.\n\n'
                  'Rappel : la partie quadratique \$5x^2 + 4xy + 2y^2\$ correspond à \$A = \\begin{pmatrix} 5 & 2 \\\\ 2 & 2 \\end{pmatrix}\$.\n\n'
                  '\$\\chi_A = (5-\\lambda)(2-\\lambda) - 4 = \\lambda^2 - 7\\lambda + 6 = (\\lambda - 1)(\\lambda - 6)\$.\n'
                  'Valeurs propres : \$\\lambda_1 = 1\$ et \$\\lambda_2 = 6\$, toutes deux strictement positives.\n'
                  'Dans la base propre, l\'équation devient \$X^2 + 6Y^2 = 6\$, soit \$\\frac{X^2}{6} + Y^2 = 1\$.\n'
                  'C\'est une ellipse de demi-axes \$a = \\sqrt{6}\$ et \$b = 1\$.\n'
                  'L\'angle de rotation vérifie \$\\tan(2\\theta) = \\frac{2 \\cdot 2}{5 - 2} = 4/3\$.\n\n'
                  'Attention : le signe des valeurs propres détermine la nature : deux positives = ellipse, signes opposés = hyperbole, une nulle = parabole.',
              points: 3,
              rapportJury:
                  'Le jury attend la diagonalisation et l\'identification de la conique.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f\$ une similitude directe du plan qui n\'est pas une isométrie. '
                  'Montrer que \$f\$ possède un unique point fixe.',
              indication:
                  'Écrire \$f(z) = az + b\$ en écriture complexe avec \$|a| \\neq 1\$ et résoudre \$f(z) = z\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'existence et l\'unicité du point fixe.\n\n'
                  'Rappel : en écriture complexe, une similitude directe s\'écrit \$f(z) = az + b\$ avec \$a \\neq 0\$. Le rapport est \$|a|\$ et l\'angle est \$\\arg(a)\$.\n\n'
                  'Point fixe : \$f(z) = z \\Leftrightarrow az + b = z \\Leftrightarrow z(a-1) = -b \\Leftrightarrow z = \\frac{b}{1-a}\$.\n'
                  'Comme \$|a| \\neq 1\$, on a \$a \\neq 1\$, donc la division est licite.\n'
                  'L\'unique point fixe est \$\\Omega = \\frac{b}{1-a}\$.\n'
                  'Géométriquement, \$f\$ est une rotation d\'angle \$\\arg(a)\$ composée avec une homothétie de rapport \$|a|\$, de centre \$\\Omega\$.\n\n'
                  'Attention : si \$a = 1\$ et \$b \\neq 0\$, c\'est une translation sans point fixe. Si \$|a| = 1\$ et \$a \\neq 1\$, c\'est une rotation (un point fixe).',
              points: 2,
              rapportJury:
                  'Le jury attend l\'écriture complexe et la résolution de l\'équation.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2025 – Analyse et probabilités
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2025AP() {
    return Annale(
      id: 'ped_ext_2025_ap',
      annee: 2025,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2025 – Analyse et probabilités (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve d\'analyse et probabilités 2025. '
          'Topologie, analyse fonctionnelle, mesure, intégration et probabilités.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Topologie', 'Analyse fonctionnelle', 'Mesure', 'Intégration', 'Probabilités'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap25.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Espaces complets',
        'Théorème de Banach',
        'Convergence dominée',
        'Séries de Fourier',
        'Théorème central limite',
      ],
      rapportGlobal:
          'Cette épreuve mêle topologie, analyse fonctionnelle, intégration et probabilités. '
          'Notre correction pédagogique détaille chaque étape pour vous guider avec bienveillance. '
          'N\'hésitez pas à revenir sur les rappels de cours avant d\'aborder les solutions.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Topologie et analyse fonctionnelle',
          introduction:
              'Cette partie porte sur les espaces métriques complets, les espaces de Banach, '
              'le théorème du point fixe et les applications linéaires continues.',
          bareme: 7,
          themes: ['Espaces métriques', 'Complétude', 'Espaces de Banach'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$(E, d)\$ un espace métrique complet et \$f : E \\to E\$ une application contractante '
                  '(i.e. il existe \$k \\in [0,1[\$ tel que \$d(f(x), f(y)) \\leq k \\, d(x,y)\$ pour tous \$x, y\$). '
                  'Montrer que \$f\$ admet un unique point fixe.',
              indication:
                  'Construire la suite \$x_{n+1} = f(x_n)\$ et montrer qu\'elle est de Cauchy.',
              correction:
                  'Ce qu\'on nous demande : démontrer le théorème du point fixe de Banach-Picard.\n\n'
                  'Rappel : un espace métrique est complet si toute suite de Cauchy converge. \$f\$ est contractante si \$d(f(x),f(y)) \\leq k \\, d(x,y)\$ avec \$k < 1\$.\n\n'
                  'Soit \$x_0 \\in E\$ et \$x_{n+1} = f(x_n)\$. On a \$d(x_{n+1}, x_n) \\leq k^n d(x_1, x_0)\$.\n'
                  'Pour \$m > n\$ : \$d(x_m, x_n) \\leq \\sum_{i=n}^{m-1} k^i d(x_1,x_0) \\leq \\frac{k^n}{1-k} d(x_1,x_0) \\to 0\$. Donc \$(x_n)\$ est de Cauchy.\n'
                  'Par complétude, \$x_n \\to \\ell \\in E\$. Par continuité de \$f\$ : \$f(\\ell) = \\lim f(x_n) = \\lim x_{n+1} = \\ell\$.\n'
                  'Unicité : si \$f(\\ell) = \\ell\$ et \$f(\\ell\') = \\ell\'\$, alors \$d(\\ell, \\ell\') = d(f(\\ell), f(\\ell\')) \\leq k \\, d(\\ell, \\ell\')\$. Comme \$k < 1\$, \$d(\\ell, \\ell\') = 0\$.\n\n'
                  'Attention : les DEUX hypothèses (complétude et contraction stricte \$k < 1\$) sont indispensables. Sans complétude, la suite peut ne pas converger.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve complète : Cauchy, convergence, passage à la limite, unicité.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que l\'espace \$(\\mathcal{C}([0,1], \\mathbb{R}), \\|\\cdot\\|_\\infty)\$ '
                  'est un espace de Banach.',
              indication:
                  'Montrer que toute suite de Cauchy de fonctions continues converge uniformément '
                  'vers une fonction continue.',
              correction:
                  'Ce qu\'on nous demande : prouver la complétude de \$\\mathcal{C}([0,1])\$ pour la norme sup.\n\n'
                  'Rappel : \$\\|f\\|_\\infty = \\sup_{x \\in [0,1]} |f(x)|\$. Un espace de Banach est un espace vectoriel normé complet.\n\n'
                  'Soit \$(f_n)\$ de Cauchy dans \$(\\mathcal{C}([0,1]), \\|\\cdot\\|_\\infty)\$.\n'
                  'Pour chaque \$x \\in [0,1]\$, \$|f_n(x) - f_m(x)| \\leq \\|f_n - f_m\\|_\\infty \\to 0\$. Donc \$(f_n(x))\$ est de Cauchy dans \$\\mathbb{R}\$, complet.\n'
                  'Posons \$f(x) = \\lim_n f_n(x)\$. La convergence est uniforme car le critère de Cauchy est uniforme en \$x\$.\n'
                  'Comme limite uniforme de fonctions continues, \$f\$ est continue.\n'
                  'Donc \$f \\in \\mathcal{C}([0,1])\$ et \$\\|f_n - f\\|_\\infty \\to 0\$.\n\n'
                  'Attention : cet argument échoue avec la norme \$\\|\\cdot\\|_1\$ ! La limite d\'une suite de Cauchy pour \$L^1\$ peut ne pas être continue.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve que la limite est continue (théorème de la limite uniforme).',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$E\$ un espace vectoriel normé de dimension finie. '
                  'Montrer que toutes les normes sur \$E\$ sont équivalentes.',
              indication:
                  'Se ramener à \$\\mathbb{R}^n\$ et montrer l\'équivalence avec la norme \$\\|\\cdot\\|_1\$ '
                  'en utilisant la compacité de la sphère unité.',
              correction:
                  'Ce qu\'on nous demande : prouver que la topologie d\'un evn de dimension finie ne dépend pas de la norme.\n\n'
                  'Rappel : deux normes \$N_1, N_2\$ sont équivalentes s\'il existe \$c, C > 0\$ tels que \$c \\, N_1 \\leq N_2 \\leq C \\, N_1\$.\n\n'
                  'Fixons une base \$(e_1, \\ldots, e_n)\$ et \$\\|x\\|_1 = \\sum |x_i|\$. Soit \$N\$ une norme quelconque.\n'
                  'Par inégalité triangulaire, \$N(x) \\leq \\sum |x_i| N(e_i) \\leq M \\|x\\|_1\$ avec \$M = \\max N(e_i)\$. Donc \$N\$ est continue pour \$\\|\\cdot\\|_1\$.\n'
                  'La sphère \$S = \\{x : \\|x\\|_1 = 1\\}\$ est compacte (fermée bornée en dimension finie).\n'
                  '\$N\$ atteint son min \$m > 0\$ sur \$S\$ (continue sur un compact, et \$N > 0\$ sur \$S\$ car \$x \\neq 0\$).\n'
                  'Donc \$m \\|x\\|_1 \\leq N(x) \\leq M \\|x\\|_1\$ : \$N\$ et \$\\|\\cdot\\|_1\$ sont équivalentes.\n\n'
                  'Attention : en dimension infinie, c\'est FAUX. La norme sup et la norme \$L^1\$ sur \$\\mathcal{C}([0,1])\$ ne sont pas équivalentes.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'argument de compacité de la sphère unité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f : [0,1] \\to \\mathbb{R}\$ continue. Montrer que les polynômes de Bernstein '
                  '\$B_n(f)(x) = \\sum_{k=0}^{n} f(k/n) \\binom{n}{k} x^k (1-x)^{n-k}\$ '
                  'convergent uniformément vers \$f\$.',
              indication:
                  'Utiliser l\'interprétation probabiliste : \$B_n(f)(x) = \\mathbb{E}[f(S_n/n)]\$ '
                  'où \$S_n \\sim \\mathrm{Bin}(n, x)\$.',
              correction:
                  'Ce qu\'on nous demande : démontrer le théorème de Weierstrass par les polynômes de Bernstein.\n\n'
                  'Rappel : \$B_n(f)(x) = \\mathbb{E}[f(S_n/n)]\$ où \$S_n \\sim \\mathrm{Bin}(n,x)\$. On a \$\\mathbb{E}[S_n/n] = x\$ et \$\\mathrm{Var}(S_n/n) = x(1-x)/n \\leq 1/(4n)\$.\n\n'
                  '\$f\$ est uniformément continue sur \$[0,1]\$ (compact). Pour \$\\varepsilon > 0\$, soit \$\\delta\$ tel que \$|s-t| < \\delta \\Rightarrow |f(s)-f(t)| < \\varepsilon\$.\n'
                  '\$|B_n(f)(x) - f(x)| = |\\mathbb{E}[f(S_n/n) - f(x)]| \\leq \\mathbb{E}[|f(S_n/n) - f(x)|]\$.\n'
                  'On sépare : si \$|S_n/n - x| < \\delta\$, la contribution est \$< \\varepsilon\$. Sinon, on majore par \$2\\|f\\|_\\infty\$.\n'
                  'Par Tchebychev : \$\\mathbb{P}(|S_n/n - x| \\geq \\delta) \\leq \\frac{1}{4n\\delta^2}\$.\n'
                  'Bilan : \$\\|B_n(f) - f\\|_\\infty \\leq \\varepsilon + \\frac{2\\|f\\|_\\infty}{4n\\delta^2} \\to \\varepsilon\$ quand \$n \\to \\infty\$.\n\n'
                  'Attention : cette preuve est constructive : les polynômes de Bernstein SONT l\'approximation. Mais la convergence est lente (\$O(1/\\sqrt{n})\$).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'approche probabiliste ou la preuve directe avec Tchebychev.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$H\$ un espace de Hilbert et \$F\$ un sous-espace vectoriel fermé de \$H\$. '
                  'Montrer que tout \$x \\in H\$ se décompose de façon unique en \$x = p + q\$ '
                  'avec \$p \\in F\$ et \$q \\in F^\\perp\$.',
              indication:
                  'Montrer l\'existence de la projection orthogonale sur \$F\$ '
                  'en minimisant la distance à \$F\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème de projection orthogonale en dimension infinie.\n\n'
                  'Rappel : \$F^\\perp = \\{y \\in H : \\langle y, f \\rangle = 0\\, \\forall f \\in F\\}\$. Un espace de Hilbert est un espace préhilbertien complet.\n\n'
                  'Existence : posons \$d = \\inf_{f \\in F} \\|x - f\\|\$ et \$(f_n)\$ une suite minimisante. Par la règle du parallélogramme, \$(f_n)\$ est de Cauchy.\n'
                  'Comme \$F\$ est fermé dans \$H\$ complet, \$f_n \\to p \\in F\$ et \$\\|x - p\\| = d\$.\n'
                  'On vérifie \$q = x - p \\in F^\\perp\$ : pour tout \$f \\in F\$ et \$t \\in \\mathbb{R}\$, \$\\|q - tf\\|^2 \\geq d^2 = \\|q\\|^2\$, d\'où \$\\langle q, f \\rangle = 0\$.\n'
                  'Unicité : si \$x = p_1 + q_1 = p_2 + q_2\$, alors \$p_1 - p_2 = q_2 - q_1 \\in F \\cap F^\\perp = \\{0\\}\$.\n\n'
                  'Attention : l\'hypothèse « \$F\$ fermé » est cruciale. Un sous-espace dense non fermé n\'admet pas de projection orthogonale en général.',
              points: 3,
              rapportJury:
                  'Le jury attend la construction par suite minimisante et la règle du parallélogramme.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Mesure et intégration',
          introduction:
              'Cette partie porte sur la théorie de la mesure de Lebesgue, '
              'les théorèmes de convergence et les espaces \$L^p\$.',
          bareme: 7,
          themes: ['Mesure de Lebesgue', 'Intégration', 'Espaces Lp'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le théorème de convergence dominée de Lebesgue.',
              indication:
                  'Appliquer le lemme de Fatou à \$g + f_n\$ et \$g - f_n\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le TCD, outil fondamental de l\'intégration.\n\n'
                  'Rappel (énoncé) : si \$f_n \\to f\$ p.p., \$|f_n| \\leq g\$ p.p. avec \$g \\in L^1\$, alors \$f \\in L^1\$ et \$\\int f_n \\to \\int f\$.\n\n'
                  'On a \$|f| = \\lim |f_n| \\leq g\$ p.p., donc \$f \\in L^1\$.\n'
                  'Lemme de Fatou appliqué à \$g + f_n \\geq 0\$ : \$\\int(g + f) \\leq \\liminf \\int(g + f_n)\$, d\'où \$\\int f \\leq \\liminf \\int f_n\$.\n'
                  'Appliqué à \$g - f_n \\geq 0\$ : \$\\int(g - f) \\leq \\liminf \\int(g - f_n)\$, d\'où \$\\int f \\geq \\limsup \\int f_n\$.\n'
                  'Combinant : \$\\limsup \\int f_n \\leq \\int f \\leq \\liminf \\int f_n\$, donc \$\\lim \\int f_n = \\int f\$.\n\n'
                  'Attention : la domination par une fonction \$L^1\$ est essentielle. Sans elle, le résultat est faux (ex : \$f_n = n \\cdot \\mathbf{1}_{[0,1/n]}\$, \$\\int f_n = 1\$ mais \$f_n \\to 0\$ p.p.).',
              points: 4,
              rapportJury:
                  'Le jury attend l\'énoncé précis, la preuve par Fatou, et un contre-exemple sans domination.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer \$\\lim_{n \\to \\infty} \\int_0^{+\\infty} \\frac{\\sin(x/n)}{x(1 + x^2)} \\, dx\$.',
              indication:
                  'Appliquer le théorème de convergence dominée avec la domination \$|\\sin(x/n)| \\leq x/n\$ '
                  'et \$|\\sin(x/n)/x| \\leq 1/n\$ pour les petits \$x\$.',
              correction:
                  'Ce qu\'on nous demande : calculer une limite d\'intégrale par convergence dominée.\n\n'
                  'Rappel : si on peut dominer \$f_n(x) = \\frac{\\sin(x/n)}{x(1+x^2)}\$ par une fonction \$L^1\$, le TCD permet d\'intervertir limite et intégrale.\n\n'
                  'Convergence simple : pour \$x > 0\$ fixé, \$\\sin(x/n) \\to 0\$ quand \$n \\to \\infty\$. Donc \$f_n(x) \\to 0\$ pour tout \$x > 0\$.\n'
                  'Domination : \$|\\sin(x/n)| \\leq \\min(1, x/n) \\leq 1\$. Donc \$|f_n(x)| \\leq \\frac{1}{x(1+x^2)}\$.\n'
                  'Cette fonction est intégrable : \$\\int_0^1 \\frac{dx}{x(1+x^2)}\$ diverge ! On raffine : \$|\\sin(x/n)| \\leq x/n\$, donc \$|f_n(x)| \\leq \\frac{1}{n(1+x^2)}\$ pour tout \$x\$. Mieux : \$|f_n(x)| \\leq \\frac{1}{1+x^2}\$ (car \$|\\sin(t)/t| \\leq 1\$ donne \$|\\sin(x/n)/x| \\leq 1/(n) \\cdot n/x \\cdot ...\$). Utilisons \$|\\sin(x/n)| \\leq x/n\$ : \$|f_n(x)| \\leq \\frac{1}{n(1+x^2)} \\in L^1\$.\n'
                  'Par le TCD : \$\\lim \\int f_n = \\int \\lim f_n = \\int 0 = 0\$.\n\n'
                  'Attention : bien vérifier que la fonction dominante est intégrable. Ici \$\\frac{1}{n(1+x^2)}\$ convient car \$\\int_0^\\infty \\frac{dx}{1+x^2} = \\pi/2 < \\infty\$.',
              points: 3,
              rapportJury:
                  'Le jury attend une domination rigoureuse et la vérification d\'intégrabilité.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que \$\\mathcal{C}_c(\\mathbb{R})\$ (fonctions continues à support compact) '
                  'est dense dans \$L^p(\\mathbb{R})\$ pour \$1 \\leq p < +\\infty\$.',
              indication:
                  'Approcher d\'abord les fonctions étagées, puis les indicatrices d\'intervalles, '
                  'puis régulariser.',
              correction:
                  'Ce qu\'on nous demande : prouver un résultat de densité fondamental en théorie \$L^p\$.\n\n'
                  'Rappel : \$\\mathcal{C}_c(\\mathbb{R})\$ = fonctions continues nulles en dehors d\'un compact. Les fonctions étagées intégrables sont denses dans \$L^p\$.\n\n'
                  'Étape 1 : toute \$f \\in L^p\$ est limite de fonctions étagées dans \$L^p\$ (par convergence dominée).\n'
                  'Étape 2 : toute fonction étagée \$\\sum a_i \\mathbf{1}_{A_i}\$ (avec \$A_i\$ de mesure finie) est approchée par des fonctions étagées sur des intervalles.\n'
                  'Étape 3 : \$\\mathbf{1}_{[a,b]}\$ est approchée dans \$L^p\$ par des fonctions continues à support compact (fonctions « chapeaux » qui lissent les bords).\n'
                  'Par linéarité, toute fonction étagée sur des intervalles est approchée par des éléments de \$\\mathcal{C}_c(\\mathbb{R})\$.\n\n'
                  'Attention : ce résultat est FAUX pour \$p = \\infty\$. La fonction \$\\mathbf{1}_{[0,1]}\$ ne peut pas être approchée uniformément par des fonctions continues.',
              points: 3,
              rapportJury:
                  'Le jury attend les étapes clés de l\'approximation. Le cas \$p = \\infty\$ doit être exclu.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f \\in L^1(\\mathbb{R})\$. Montrer que '
                  '\$\\lim_{|t| \\to +\\infty} \\hat{f}(t) = 0\$ (lemme de Riemann-Lebesgue).',
              indication:
                  'Le prouver d\'abord pour les fonctions étagées, puis conclure par densité.',
              correction:
                  'Ce qu\'on nous demande : démontrer le lemme de Riemann-Lebesgue.\n\n'
                  'Rappel : la transformée de Fourier est \$\\hat{f}(t) = \\int_{\\mathbb{R}} f(x) e^{-2i\\pi tx} dx\$.\n\n'
                  'Pour \$f = \\mathbf{1}_{[a,b]}\$ : \$\\hat{f}(t) = \\frac{e^{-2i\\pi ta} - e^{-2i\\pi tb}}{2i\\pi t} \\to 0\$ quand \$|t| \\to \\infty\$.\n'
                  'Pour une fonction étagée \$g = \\sum c_k \\mathbf{1}_{[a_k,b_k]}\$ : \$\\hat{g}(t) \\to 0\$ par linéarité.\n'
                  'Pour \$f \\in L^1\$ : soit \$\\varepsilon > 0\$ et \$g\$ étagée avec \$\\|f - g\\|_1 < \\varepsilon\$.\n'
                  'Alors \$|\\hat{f}(t)| \\leq |\\hat{f}(t) - \\hat{g}(t)| + |\\hat{g}(t)| \\leq \\|f-g\\|_1 + |\\hat{g}(t)| < \\varepsilon + |\\hat{g}(t)|\$.\n'
                  'Pour \$|t|\$ assez grand, \$|\\hat{g}(t)| < \\varepsilon\$, donc \$|\\hat{f}(t)| < 2\\varepsilon\$.\n\n'
                  'Attention : la réciproque est fausse. Il existe des fonctions avec \$\\hat{f}(t) \\to 0\$ qui ne sont pas dans \$L^1\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve par densité des fonctions étagées.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer l\'inégalité de Hölder : pour \$f \\in L^p\$ et \$g \\in L^q\$ '
                  'avec \$1/p + 1/q = 1\$, on a \$fg \\in L^1\$ et '
                  '\$\\|fg\\|_1 \\leq \\|f\\|_p \\|g\\|_q\$.',
              indication:
                  'Utiliser l\'inégalité de Young : \$ab \\leq a^p/p + b^q/q\$ pour \$a, b \\geq 0\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'inégalité de Hölder, outil fondamental des espaces \$L^p\$.\n\n'
                  'Rappel (inégalité de Young) : pour \$a, b \\geq 0\$ et \$1/p + 1/q = 1\$ : \$ab \\leq \\frac{a^p}{p} + \\frac{b^q}{q}\$. C\'est une conséquence de la concavité du logarithme.\n\n'
                  'Si \$\\|f\\|_p = 0\$ ou \$\\|g\\|_q = 0\$, le résultat est trivial.\n'
                  'Sinon, posons \$F = f/\\|f\\|_p\$ et \$G = g/\\|g\\|_q\$. Young donne \$|F(x)||G(x)| \\leq \\frac{|F(x)|^p}{p} + \\frac{|G(x)|^q}{q}\$.\n'
                  'En intégrant : \$\\int |FG| \\leq \\frac{1}{p} + \\frac{1}{q} = 1\$.\n'
                  'Donc \$\\frac{\\|fg\\|_1}{\\|f\\|_p \\|g\\|_q} \\leq 1\$, ce qui donne \$\\|fg\\|_1 \\leq \\|f\\|_p \\|g\\|_q\$.\n\n'
                  'Attention : le cas d\'égalité a lieu ssi \$|f|^p\$ et \$|g|^q\$ sont proportionnels p.p. Pour \$p = q = 2\$, on retrouve Cauchy-Schwarz.',
              points: 3,
              rapportJury:
                  'Le jury attend la normalisation et l\'application de Young. Le cas d\'égalité est un bonus.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Probabilités',
          introduction:
              'Cette partie porte sur les variables aléatoires, les lois classiques, '
              'les fonctions caractéristiques et le théorème central limite.',
          bareme: 6,
          themes: ['Variables aléatoires', 'Fonctions caractéristiques', 'TCL'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire de loi normale \$\\mathcal{N}(0,1)\$. '
                  'Calculer \$\\mathbb{E}[X^{2k}]\$ pour \$k \\in \\mathbb{N}\$.',
              indication:
                  'Utiliser une intégration par parties ou la fonction génératrice des moments.',
              correction:
                  'Ce qu\'on nous demande : calculer les moments pairs de la loi normale centrée réduite.\n\n'
                  'Rappel : la densité de \$\\mathcal{N}(0,1)\$ est \$\\varphi(x) = \\frac{1}{\\sqrt{2\\pi}} e^{-x^2/2}\$.\n\n'
                  'Par parité, \$\\mathbb{E}[X^{2k+1}] = 0\$ (moments impairs nuls).\n'
                  'Pour les moments pairs, IPP : \$\\mathbb{E}[X^{2k}] = \\int x^{2k} \\varphi(x) dx\$. On intègre par parties avec \$u = x^{2k-1}\$ et \$dv = x\\varphi(x)dx = -\\varphi\'(x)dx\$.\n'
                  'On obtient la relation de récurrence : \$\\mathbb{E}[X^{2k}] = (2k-1) \\mathbb{E}[X^{2(k-1)}]\$.\n'
                  'Avec \$\\mathbb{E}[X^0] = 1\$ : \$\\mathbb{E}[X^{2k}] = (2k-1)(2k-3) \\cdots 3 \\cdot 1 = (2k-1)!! = \\frac{(2k)!}{2^k k!}\$.\n'
                  'Exemples : \$\\mathbb{E}[X^2] = 1\$, \$\\mathbb{E}[X^4] = 3\$, \$\\mathbb{E}[X^6] = 15\$.\n\n'
                  'Attention : on peut aussi utiliser la fonction génératrice des moments \$M(t) = e^{t^2/2}\$ et développer en série.',
              points: 3,
              rapportJury:
                  'Le jury attend la récurrence par IPP ou la méthode par fonction génératrice.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_n)_{n \\geq 1}\$ une suite de variables aléatoires i.i.d. d\'espérance \$\\mu\$ '
                  'et de variance \$\\sigma^2\$. Énoncer et démontrer le théorème central limite.',
              indication:
                  'Utiliser les fonctions caractéristiques et le théorème de Lévy.',
              correction:
                  'Ce qu\'on nous demande : démontrer le TCL, résultat majeur des probabilités.\n\n'
                  'Rappel (énoncé) : si \$S_n = X_1 + \\cdots + X_n\$, alors \$Z_n = \\frac{S_n - n\\mu}{\\sigma\\sqrt{n}} \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$.\n\n'
                  'Posons \$Y_i = (X_i - \\mu)/\\sigma\$ (centrée réduite). Alors \$Z_n = \\frac{1}{\\sqrt{n}} \\sum Y_i\$.\n'
                  'Fonction caractéristique : \$\\varphi_{Z_n}(t) = [\\varphi_Y(t/\\sqrt{n})]^n\$.\n'
                  'DL de \$\\varphi_Y\$ en 0 : \$\\varphi_Y(s) = 1 - s^2/2 + o(s^2)\$ (car \$\\mathbb{E}[Y] = 0\$, \$\\mathbb{E}[Y^2] = 1\$).\n'
                  'Donc \$\\varphi_{Z_n}(t) = [1 - t^2/(2n) + o(1/n)]^n \\to e^{-t^2/2}\$ quand \$n \\to \\infty\$.\n'
                  'On reconnaît la fonction caractéristique de \$\\mathcal{N}(0,1)\$. Par le théorème de Lévy, \$Z_n \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$.\n\n'
                  'Attention : l\'hypothèse de variance finie est nécessaire. Pour des lois à queues lourdes (Cauchy), le TCL ne s\'applique pas.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par fonctions caractéristiques avec le DL à l\'ordre 2.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer l\'inégalité de Markov : pour \$X \\geq 0\$ et \$a > 0\$, '
                  '\$\\mathbb{P}(X \\geq a) \\leq \\frac{\\mathbb{E}[X]}{a}\$. '
                  'En déduire l\'inégalité de Tchebychev.',
              indication:
                  'Utiliser \$X \\geq a \\cdot \\mathbf{1}_{X \\geq a}\$ et prendre l\'espérance.',
              correction:
                  'Ce qu\'on nous demande : prouver Markov et en déduire Tchebychev.\n\n'
                  'Rappel : Markov donne une borne sur la queue de distribution à partir de l\'espérance.\n\n'
                  'Markov : \$X \\geq 0\$ implique \$X \\geq a \\cdot \\mathbf{1}_{X \\geq a}\$. En prenant l\'espérance (croissance) : \$\\mathbb{E}[X] \\geq a \\cdot \\mathbb{P}(X \\geq a)\$, d\'où le résultat.\n'
                  'Tchebychev : appliquons Markov à \$Y = (X - \\mu)^2 \\geq 0\$ avec \$a = \\varepsilon^2\$ :\n'
                  '\$\\mathbb{P}((X-\\mu)^2 \\geq \\varepsilon^2) \\leq \\frac{\\mathbb{E}[(X-\\mu)^2]}{\\varepsilon^2} = \\frac{\\mathrm{Var}(X)}{\\varepsilon^2}\$.\n'
                  'Soit \$\\mathbb{P}(|X - \\mu| \\geq \\varepsilon) \\leq \\frac{\\sigma^2}{\\varepsilon^2}\$.\n'
                  'Application : la loi faible des grands nombres découle de Tchebychev appliqué à \$\\bar{X}_n\$.\n\n'
                  'Attention : ces bornes sont grossières mais universelles. Des bornes plus fines existent (Chernoff, sous-gaussiennes) avec des hypothèses supplémentaires.',
              points: 2,
              rapportJury:
                  'Le jury attend les deux inégalités avec la déduction de Tchebychev à partir de Markov.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_n)\$ une suite de variables aléatoires i.i.d. de loi exponentielle '
                  '\$\\mathcal{E}(\\lambda)\$. Déterminer la loi de \$M_n = \\min(X_1, \\ldots, X_n)\$.',
              indication:
                  'Calculer \$\\mathbb{P}(M_n > t)\$ en utilisant l\'indépendance.',
              correction:
                  'Ce qu\'on nous demande : trouver la loi du minimum de \$n\$ exponentielles i.i.d.\n\n'
                  'Rappel : si \$X \\sim \\mathcal{E}(\\lambda)\$, alors \$\\mathbb{P}(X > t) = e^{-\\lambda t}\$ pour \$t \\geq 0\$.\n\n'
                  'On a \$\\mathbb{P}(M_n > t) = \\mathbb{P}(X_1 > t, \\ldots, X_n > t)\$.\n'
                  'Par indépendance : \$\\mathbb{P}(M_n > t) = \\prod_{i=1}^n \\mathbb{P}(X_i > t) = (e^{-\\lambda t})^n = e^{-n\\lambda t}\$.\n'
                  'On reconnaît la fonction de survie de \$\\mathcal{E}(n\\lambda)\$.\n'
                  'Donc \$M_n \\sim \\mathcal{E}(n\\lambda)\$ : le minimum de \$n\$ exponentielles de paramètre \$\\lambda\$ suit une exponentielle de paramètre \$n\\lambda\$.\n'
                  'En particulier, \$\\mathbb{E}[M_n] = \\frac{1}{n\\lambda}\$ et \$M_n \\to 0\$ p.s. quand \$n \\to \\infty\$.\n\n'
                  'Attention : ce résultat est propre à la loi exponentielle (propriété de stabilité par minimum). Ce n\'est pas vrai pour d\'autres lois.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul de la fonction de survie et l\'identification de la loi.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire à valeurs dans \$\\mathbb{N}\$. Montrer que '
                  '\$\\mathbb{E}[X] = \\sum_{n=0}^{+\\infty} \\mathbb{P}(X > n)\$.',
              indication:
                  'Écrire \$X = \\sum_{n=0}^{\\infty} \\mathbf{1}_{X > n}\$ et utiliser la linéarité de l\'espérance.',
              correction:
                  'Ce qu\'on nous demande : exprimer l\'espérance d\'une VA à valeurs entières via la queue de distribution.\n\n'
                  'Rappel : pour \$X\$ à valeurs entières positives, \$\\mathbb{E}[X] = \\sum_{k=1}^{\\infty} k \\, \\mathbb{P}(X = k)\$. On peut réorganiser cette somme.\n\n'
                  'Clé : \$X = \\sum_{n=0}^{\\infty} \\mathbf{1}_{X > n}\$ (car si \$X = k\$, les indicatrices \$\\mathbf{1}_{X > 0}, \\ldots, \\mathbf{1}_{X > k-1}\$ valent 1, les autres 0, total = \$k\$).\n'
                  'Par linéarité (ou Fubini-Tonelli car termes positifs) : \$\\mathbb{E}[X] = \\sum_{n=0}^{\\infty} \\mathbb{E}[\\mathbf{1}_{X > n}] = \\sum_{n=0}^{\\infty} \\mathbb{P}(X > n)\$.\n'
                  'Vérification pour \$X \\sim \\mathrm{Geom}(p)\$ : \$\\sum_{n=0}^{\\infty} (1-p)^n = \\frac{1}{p} = \\mathbb{E}[X]\$ ✓ (avec la convention \$X \\geq 1\$ ajustée).\n'
                  'Version continue : si \$X \\geq 0\$, \$\\mathbb{E}[X] = \\int_0^{\\infty} \\mathbb{P}(X > t) \\, dt\$ (formule de la queue).\n\n'
                  'Attention : cette formule est souvent plus pratique que la définition directe pour calculer \$\\mathbb{E}[X]\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la décomposition en indicatrices et l\'application de la linéarité.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2025 – Épreuve 1
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2025EP1() {
    return Annale(
      id: 'ped_int_2025_ep1',
      annee: 2025,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2025 – Épreuve 1 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 1 de l\'agrégation interne 2025. '
          'Algèbre, géométrie, analyse et applications aux enseignements.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie', 'Analyse', 'Suites', 'Équations différentielles'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep1/25-ep1.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Diagonalisation',
        'Isométries',
        'Suites récurrentes',
        'Intégrales généralisées',
        'Équations différentielles',
      ],
      rapportGlobal:
          'L\'épreuve 1 de l\'interne 2025 couvre algèbre, géométrie et analyse. '
          'Notre correction pédagogique accompagne chaque question pas à pas, '
          'avec des rappels de cours adaptés et des conseils de rédaction. '
          'Chaque étape est expliquée avec bienveillance.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre et géométrie',
          introduction:
              'Cette partie porte sur la réduction des endomorphismes, '
              'les isométries et la géométrie affine.',
          bareme: 7,
          themes: ['Réduction', 'Isométries', 'Géométrie affine'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$A = \\begin{pmatrix} 2 & 1 & 0 \\\\ 0 & 2 & 1 \\\\ 0 & 0 & 2 \\end{pmatrix}\$. '
                  'La matrice \$A\$ est-elle diagonalisable ? Trigonalisable ?',
              indication:
                  'Calculer le polynôme caractéristique et les sous-espaces propres.',
              correction:
                  'Ce qu\'on nous demande : étudier la diagonalisabilité et la trigonalisabilité de \$A\$.\n\n'
                  'Rappel : \$A\$ est diagonalisable ssi la dimension de chaque sous-espace propre égale la multiplicité algébrique de la valeur propre correspondante. \$A\$ est trigonalisable (sur \$\\mathbb{R}\$) ssi \$\\chi_A\$ est scindé.\n\n'
                  '\$\\chi_A = (2 - \\lambda)^3\$. Unique valeur propre \$\\lambda = 2\$ de multiplicité algébrique 3.\n'
                  'Sous-espace propre : \$\\ker(A - 2I) = \\ker\\begin{pmatrix} 0 & 1 & 0 \\\\ 0 & 0 & 1 \\\\ 0 & 0 & 0 \\end{pmatrix} = \\mathrm{Vect}(e_1)\$. Dimension 1 ≠ 3.\n'
                  'Donc \$A\$ n\'est PAS diagonalisable.\n'
                  'En revanche, \$\\chi_A = (2-\\lambda)^3\$ est scindé sur \$\\mathbb{R}\$, donc \$A\$ EST trigonalisable. En fait, \$A\$ est déjà sous forme triangulaire supérieure !\n'
                  'La forme de Jordan est \$J = \\begin{pmatrix} 2 & 1 & 0 \\\\ 0 & 2 & 1 \\\\ 0 & 0 & 2 \\end{pmatrix} = A\$ (un seul bloc de Jordan de taille 3).\n\n'
                  'Attention : trigonalisable ≠ diagonalisable. Toute matrice à coefficients complexes est trigonalisable, mais pas forcément diagonalisable.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul des sous-espaces propres pour justifier la non-diagonalisabilité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A = \\begin{pmatrix} 1 & 1 \\\\ 0 & 2 \\end{pmatrix}\$. '
                  'Calculer \$A^n\$ pour tout \$n \\in \\mathbb{N}\$.',
              indication:
                  'Diagonaliser \$A\$ en trouvant les valeurs propres et les vecteurs propres.',
              correction:
                  'Ce qu\'on nous demande : calculer la puissance \$n\$-ième d\'une matrice 2×2.\n\n'
                  'Rappel : si \$A = PDP^{-1}\$ avec \$D\$ diagonale, alors \$A^n = PD^nP^{-1}\$.\n\n'
                  '\$\\chi_A = (1-\\lambda)(2-\\lambda)\$. Valeurs propres : \$\\lambda_1 = 1\$, \$\\lambda_2 = 2\$, distinctes donc \$A\$ est diagonalisable.\n'
                  'Vecteur propre pour \$\\lambda_1 = 1\$ : \$\\ker(A-I) = \\mathrm{Vect}\\begin{pmatrix} 1 \\\\ 0 \\end{pmatrix}\$.\n'
                  'Vecteur propre pour \$\\lambda_2 = 2\$ : \$\\ker(A-2I) = \\mathrm{Vect}\\begin{pmatrix} 1 \\\\ 1 \\end{pmatrix}\$.\n'
                  '\$P = \\begin{pmatrix} 1 & 1 \\\\ 0 & 1 \\end{pmatrix}\$, \$P^{-1} = \\begin{pmatrix} 1 & -1 \\\\ 0 & 1 \\end{pmatrix}\$, \$D = \\mathrm{diag}(1, 2)\$.\n'
                  '\$A^n = P \\begin{pmatrix} 1 & 0 \\\\ 0 & 2^n \\end{pmatrix} P^{-1} = \\begin{pmatrix} 1 & 2^n - 1 \\\\ 0 & 2^n \\end{pmatrix}\$.\n\n'
                  'Attention : vérifiez pour \$n = 0\$ (\$A^0 = I\$ ✓) et \$n = 1\$ (\$A^1 = A\$ ✓).',
              points: 3,
              rapportJury:
                  'Le jury attend la diagonalisation complète et la vérification du résultat.',
            ),
            QuestionAnnale(
              enonce:
                  'Dans \$\\mathbb{R}^3\$ euclidien, soit \$s\$ la réflexion par rapport au plan '
                  '\$P : x + y + z = 0\$. Déterminer la matrice de \$s\$ dans la base canonique.',
              indication:
                  'Utiliser la formule \$s(v) = v - 2 \\frac{\\langle v, n \\rangle}{\\|n\\|^2} n\$ '
                  'où \$n\$ est le vecteur normal au plan.',
              correction:
                  'Ce qu\'on nous demande : trouver la matrice de la réflexion orthogonale par rapport à un plan.\n\n'
                  'Rappel : la réflexion par rapport au plan de vecteur normal \$n\$ est \$s(v) = v - 2\\frac{\\langle v, n\\rangle}{\\|n\\|^2} n\$.\n\n'
                  'Le vecteur normal à \$P : x+y+z = 0\$ est \$n = (1,1,1)\$ et \$\\|n\\|^2 = 3\$.\n'
                  '\$s(e_1) = (1,0,0) - \\frac{2}{3}(1,1,1) = (1/3, -2/3, -2/3)\$.\n'
                  '\$s(e_2) = (0,1,0) - \\frac{2}{3}(1,1,1) = (-2/3, 1/3, -2/3)\$.\n'
                  '\$s(e_3) = (0,0,1) - \\frac{2}{3}(1,1,1) = (-2/3, -2/3, 1/3)\$.\n'
                  'Matrice : \$S = \\frac{1}{3}\\begin{pmatrix} 1 & -2 & -2 \\\\ -2 & 1 & -2 \\\\ -2 & -2 & 1 \\end{pmatrix}\$. Vérification : \$S^2 = I\$ ✓, \$\\det(S) = -1\$ ✓, \$S \\cdot n = -n\$ ✓.\n\n'
                  'Attention : ne confondez pas réflexion (\$s^2 = \\mathrm{Id}\$, \$\\det = -1\$) et projection orthogonale (\$p^2 = p\$, \$\\det = 0\$). Lien : \$s = 2p - \\mathrm{Id}\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la formule explicite et les vérifications \$S^2 = I\$ et \$\\det(S) = -1\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer l\'ensemble des matrices \$M \\in \\mathcal{M}_2(\\mathbb{R})\$ '
                  'vérifiant \$M^2 = I_2\$.',
              indication:
                  'Les valeurs propres possibles sont \$\\pm 1\$. Distinguer selon le polynôme minimal.',
              correction:
                  'Ce qu\'on nous demande : résoudre l\'équation matricielle \$M^2 = I\$.\n\n'
                  'Rappel : \$M^2 = I\$ signifie que \$M\$ est une involution. Le polynôme \$X^2 - 1 = (X-1)(X+1)\$ annule \$M\$. Les valeurs propres sont dans \$\\{-1, 1\\}\$.\n\n'
                  'Cas 1 : \$\\mathrm{Sp}(M) = \\{1\\}\$ et le polynôme minimal divise \$X-1\$, donc \$M = I_2\$.\n'
                  'Cas 2 : \$\\mathrm{Sp}(M) = \\{-1\\}\$ et le polynôme minimal divise \$X+1\$, donc \$M = -I_2\$.\n'
                  'Cas 3 : \$\\mathrm{Sp}(M) = \\{1, -1\\}\$. Comme \$\\mu_M\$ divise \$(X-1)(X+1)\$ à racines simples, \$M\$ est diagonalisable.\n'
                  'Dans une base propre, \$M = \\mathrm{diag}(1, -1)\$. Dans la base canonique : \$M = P \\mathrm{diag}(1,-1) P^{-1}\$ pour toute matrice inversible \$P\$.\n'
                  'Ce sont exactement les matrices de trace quelconque et déterminant \$-1\$ : \$M = \\begin{pmatrix} a & b \\\\ c & -a \\end{pmatrix}\$ avec \$a^2 + bc = 1\$.\n\n'
                  'Attention : il y a une infinité de solutions (une famille à 2 paramètres), plus les solutions triviales \$\\pm I_2\$.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'analyse par valeurs propres et polynôme minimal.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f\$ une isométrie affine de \$\\mathbb{R}^3\$ euclidien dont la partie linéaire '
                  'est une rotation d\'angle \$\\pi\$ autour de l\'axe \$\\Delta = \\mathrm{Vect}(1,0,1)\$, '
                  'et telle que \$f(O) = (1, 2, 3)\$. Déterminer les points fixes de \$f\$.',
              indication:
                  'Chercher les points \$M\$ tels que \$f(M) = M\$, i.e. \$\\vec{u}(\\overrightarrow{OM}) + \\overrightarrow{Of(O)} = \\overrightarrow{OM}\$.',
              correction:
                  'Ce qu\'on nous demande : trouver les points fixes d\'une isométrie affine composée d\'une rotation et d\'une translation.\n\n'
                  'Rappel : \$f(M) = f(O) + \\vec{u}(\\overrightarrow{OM})\$ où \$\\vec{u}\$ est la rotation de \$\\pi\$ autour de \$\\Delta\$. Point fixe : \$(\\vec{u} - \\mathrm{Id})(\\overrightarrow{OM}) = -\\overrightarrow{Of(O)}\$.\n\n'
                  'La rotation de \$\\pi\$ autour de \$\\Delta\$ a pour valeurs propres : \$1\$ (axe) et \$-1\$ (double, plan orthogonal à \$\\Delta\$).\n'
                  'Donc \$\\vec{u} - \\mathrm{Id}\$ a pour noyau \$\\Delta\$ et pour image le plan orthogonal à \$\\Delta\$.\n'
                  'L\'équation a des solutions ssi \$-\\overrightarrow{Of(O)} = -(1,2,3)\$ a une composante dans l\'image de \$\\vec{u} - \\mathrm{Id}\$.\n'
                  'Projetons \$(1,2,3)\$ sur \$\\Delta^\\perp\$ : composante sur \$\\Delta\$ = \$\\frac{\\langle (1,2,3),(1,0,1)\\rangle}{\\|(1,0,1)\\|^2}(1,0,1) = \\frac{4}{2}(1,0,1) = (2,0,2)\$.\n'
                  'Composante sur \$\\Delta^\\perp\$ : \$(1,2,3) - (2,0,2) = (-1,2,1)\$. L\'ensemble des points fixes est une droite parallèle à \$\\Delta\$ passant par un point solution.\n\n'
                  'Attention : une isométrie de \$\\mathbb{R}^3\$ peut avoir 0, 1 ou une infinité de points fixes selon sa nature (vis, rotation, réflexion...).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'analyse de l\'équation \$(\\vec{u} - \\mathrm{Id})(x) = b\$ et la discussion de solubilité.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Analyse',
          introduction:
              'Cette partie porte sur les suites, les séries, '
              'les intégrales généralisées et les équations différentielles.',
          bareme: 7,
          themes: ['Suites', 'Séries', 'Intégrales', 'Équations différentielles'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit la suite \$(u_n)\$ définie par \$u_0 = 2\$ et \$u_{n+1} = \\frac{1}{2}(u_n + 3/u_n)\$. '
                  'Montrer que \$(u_n)\$ converge et déterminer sa limite.',
              indication:
                  'Montrer que \$u_n \\geq \\sqrt{3}\$ pour tout \$n \\geq 1\$ '
                  'et que la suite est décroissante à partir du rang 1.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence de la suite définie par la méthode de Héron pour \$\\sqrt{3}\$.\n\n'
                  'Rappel : la méthode de Héron (ou babylonienne) pour \$\\sqrt{a}\$ utilise \$u_{n+1} = \\frac{1}{2}(u_n + a/u_n)\$. C\'est la méthode de Newton appliquée à \$f(x) = x^2 - a\$.\n\n'
                  'Par AM-GM : \$u_{n+1} = \\frac{1}{2}(u_n + 3/u_n) \\geq \\sqrt{u_n \\cdot 3/u_n} = \\sqrt{3}\$ pour \$u_n > 0\$. Donc \$u_n \\geq \\sqrt{3}\$ pour \$n \\geq 1\$.\n'
                  'Monotonie : \$u_{n+1} - u_n = \\frac{1}{2}(3/u_n - u_n) = \\frac{3 - u_n^2}{2u_n} \\leq 0\$ car \$u_n \\geq \\sqrt{3}\$.\n'
                  'La suite est décroissante et minorée, donc elle converge vers \$\\ell \\geq \\sqrt{3}\$.\n'
                  'Passage à la limite : \$\\ell = \\frac{1}{2}(\\ell + 3/\\ell)\$, d\'où \$\\ell^2 = 3\$ et \$\\ell = \\sqrt{3}\$.\n'
                  'Vitesse : \$u_{n+1} - \\sqrt{3} = \\frac{(u_n - \\sqrt{3})^2}{2u_n}\$, convergence quadratique !\n\n'
                  'Attention : la convergence est très rapide (quadratique). Après quelques itérations, on a déjà une excellente approximation.',
              points: 3,
              rapportJury:
                  'Le jury attend la minoration par AM-GM, la monotonie et le passage à la limite.',
            ),
            QuestionAnnale(
              enonce:
                  'Étudier la nature de la série \$\\sum_{n \\geq 1} \\frac{(-1)^n}{\\sqrt{n}}\$. '
                  'La convergence est-elle absolue ?',
              indication:
                  'Pour la convergence, appliquer le critère des séries alternées. '
                  'Pour la convergence absolue, comparer à une série de Riemann.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence simple et absolue d\'une série alternée.\n\n'
                  'Rappel : le critère de Leibniz (séries alternées) s\'applique si \$a_n = 1/\\sqrt{n}\$ est décroissante et tend vers 0.\n\n'
                  '\$a_n = 1/\\sqrt{n}\$ est décroissante ✓ et \$a_n \\to 0\$ ✓.\n'
                  'Par le critère des séries alternées, \$\\sum (-1)^n/\\sqrt{n}\$ converge.\n'
                  'Convergence absolue : \$\\sum |(-1)^n/\\sqrt{n}| = \\sum 1/\\sqrt{n} = \\sum 1/n^{1/2}\$.\n'
                  'C\'est une série de Riemann avec \$\\alpha = 1/2 \\leq 1\$, donc divergente.\n'
                  'Conclusion : la série est semi-convergente (convergente mais pas absolument convergente).\n\n'
                  'Attention : le théorème de réarrangement de Riemann dit qu\'une série semi-convergente peut être réarrangée pour converger vers n\'importe quelle valeur. L\'ordre des termes compte !',
              points: 2,
              rapportJury:
                  'Le jury attend la distinction claire entre convergence et convergence absolue.',
            ),
            QuestionAnnale(
              enonce:
                  'Étudier la convergence de l\'intégrale généralisée '
                  '\$\\int_0^{+\\infty} \\frac{\\sin(t)}{t} \\, dt\$.',
              indication:
                  'Montrer la convergence par intégration par parties ou par le critère d\'Abel. '
                  'Montrer la non-convergence absolue en minorant.',
              correction:
                  'Ce qu\'on nous demande : étudier l\'intégrale de Dirichlet \$\\int_0^\\infty \\sin(t)/t \\, dt\$.\n\n'
                  'Rappel : cette intégrale est une intégrale impropre en \$+\\infty\$ (et en 0, mais \$\\sin(t)/t \\to 1\$ donc pas de problème). Sa valeur est \$\\pi/2\$.\n\n'
                  'Convergence : IPP avec \$u = 1/t\$ et \$dv = \\sin(t)dt\$ : \$\\int_1^A \\frac{\\sin t}{t} dt = [-\\cos t/t]_1^A - \\int_1^A \\frac{\\cos t}{t^2} dt\$.\n'
                  'Le premier terme tend vers \$\\cos(1)\$ et l\'intégrale de \$\\cos(t)/t^2\$ converge absolument (majorée par \$1/t^2\$, intégrable).\n'
                  'Donc \$\\int_0^\\infty \\sin(t)/t \\, dt\$ converge.\n'
                  'Non-convergence absolue : \$\\int_{k\\pi}^{(k+1)\\pi} |\\sin(t)/t| \\, dt \\geq \\frac{1}{(k+1)\\pi} \\int_{k\\pi}^{(k+1)\\pi} |\\sin(t)| dt = \\frac{2}{(k+1)\\pi}\$.\n'
                  'Donc \$\\int_0^\\infty |\\sin(t)/t| dt \\geq \\sum \\frac{2}{(k+1)\\pi} = +\\infty\$. L\'intégrale n\'est pas absolument convergente.\n\n'
                  'Attention : c\'est l\'analogue « continu » d\'une série semi-convergente. L\'intégrale de Dirichlet est un classique absolu.',
              points: 3,
              rapportJury:
                  'Le jury attend la convergence (par IPP ou Abel) et la non-convergence absolue.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre l\'équation différentielle \$y\' - 2y = e^{3t}\$ avec \$y(0) = 1\$.',
              indication:
                  'Résoudre d\'abord l\'équation homogène, puis chercher une solution particulière.',
              correction:
                  'Ce qu\'on nous demande : résoudre une EDL1 à coefficients constants avec second membre.\n\n'
                  'Rappel : la solution générale de \$y\' - 2y = f(t)\$ est \$y = y_h + y_p\$ où \$y_h\$ est la solution de l\'homogène et \$y_p\$ une solution particulière.\n\n'
                  'Homogène \$y\' - 2y = 0\$ : \$y_h = Ce^{2t}\$.\n'
                  'Solution particulière : on cherche \$y_p = ae^{3t}\$. Alors \$y_p\' - 2y_p = 3ae^{3t} - 2ae^{3t} = ae^{3t} = e^{3t}\$, donc \$a = 1\$.\n'
                  'Solution générale : \$y(t) = Ce^{2t} + e^{3t}\$.\n'
                  'Condition initiale : \$y(0) = C + 1 = 1\$, donc \$C = 0\$.\n'
                  'Solution : \$y(t) = e^{3t}\$.\n'
                  'Vérification : \$y\' = 3e^{3t}\$ et \$y\' - 2y = 3e^{3t} - 2e^{3t} = e^{3t}\$ ✓.\n\n'
                  'Attention : si le second membre était \$e^{2t}\$ (résonance), on chercherait \$y_p = ate^{2t}\$ au lieu de \$ae^{2t}\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la méthode complète et la vérification. Le cas de résonance doit être mentionné.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la fonction \$f(x) = \\sum_{n=1}^{+\\infty} \\frac{x^n}{n^2}\$ '
                  'est de classe \$\\mathcal{C}^1\$ sur \$]-1, 1[\$ et calculer \$f\'(x)\$.',
              indication:
                  'Utiliser le théorème de dérivation terme à terme des séries de fonctions.',
              correction:
                  'Ce qu\'on nous demande : justifier la dérivabilité de la somme d\'une série entière.\n\n'
                  'Rappel : une série entière \$\\sum a_n x^n\$ est de classe \$\\mathcal{C}^\\infty\$ sur son disque ouvert de convergence, et on peut dériver terme à terme.\n\n'
                  'Rayon de convergence : \$|a_n| = 1/n^2\$. Par d\'Alembert ou Hadamard : \$R = \\limsup |a_n|^{-1/n} = 1\$.\n'
                  'Donc \$f\$ est définie et \$\\mathcal{C}^\\infty\$ sur \$]-1,1[\$.\n'
                  'Dérivation terme à terme : \$f\'(x) = \\sum_{n=1}^{\\infty} \\frac{n x^{n-1}}{n^2} = \\sum_{n=1}^{\\infty} \\frac{x^{n-1}}{n} = \\frac{1}{x} \\sum_{n=1}^{\\infty} \\frac{x^n}{n} = -\\frac{\\ln(1-x)}{x}\$ pour \$x \\neq 0\$.\n'
                  'En \$x = 0\$ : \$f\'(0) = 1\$ (premier terme de la série dérivée).\n'
                  'On reconnaît \$f(x) = \\mathrm{Li}_2(x)\$ (dilogarithme), liée à \$-\\int_0^x \\frac{\\ln(1-t)}{t} dt\$.\n\n'
                  'Attention : le rayon de convergence de la série dérivée est le MÊME que celui de la série initiale. C\'est une propriété fondamentale des séries entières.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul du rayon de convergence et la dérivation terme à terme justifiée.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Applications',
          introduction:
              'Cette partie propose des applications des notions d\'algèbre et d\'analyse '
              'à des situations concrètes et à l\'enseignement.',
          bareme: 6,
          themes: ['Applications', 'Modélisation', 'Enseignement'],
          questions: [
            QuestionAnnale(
              enonce:
                  'On modélise l\'évolution d\'une population par le système '
                  '\$\\begin{cases} x_{n+1} = 0.6 x_n + 0.4 y_n \\\\ y_{n+1} = 0.4 x_n + 0.6 y_n \\end{cases}\$. '
                  'Déterminer le comportement asymptotique de \$(x_n, y_n)\$.',
              indication:
                  'Écrire le système sous forme matricielle \$X_{n+1} = AX_n\$ et diagonaliser \$A\$.',
              correction:
                  'Ce qu\'on nous demande : étudier le comportement à long terme d\'un système linéaire récurrent.\n\n'
                  'Rappel : \$X_n = A^n X_0\$. Le comportement asymptotique dépend des valeurs propres de \$A\$.\n\n'
                  '\$A = \\begin{pmatrix} 0.6 & 0.4 \\\\ 0.4 & 0.6 \\end{pmatrix}\$. C\'est une matrice stochastique (\$A\\mathbf{1} = \\mathbf{1}\$).\n'
                  'Valeurs propres : \$\\lambda_1 = 1\$ (vecteur propre \$(1,1)^T\$) et \$\\lambda_2 = 0.2\$ (vecteur propre \$(1,-1)^T\$).\n'
                  '\$A^n = P \\mathrm{diag}(1, 0.2^n) P^{-1}\$. Comme \$0.2^n \\to 0\$, \$A^n\$ converge vers la projection sur le sous-espace propre de \$\\lambda_1 = 1\$.\n'
                  '\$\\lim A^n = \\frac{1}{2}\\begin{pmatrix} 1 & 1 \\\\ 1 & 1 \\end{pmatrix}\$. Donc \$x_n \\to \\frac{x_0 + y_0}{2}\$ et \$y_n \\to \\frac{x_0 + y_0}{2}\$.\n'
                  'Les deux populations convergent vers la même valeur : la moyenne initiale. C\'est un phénomène de diffusion/mélange.\n\n'
                  'Attention : la convergence est géométrique de raison 0.2. Plus le second valeur propre est petit (en module), plus la convergence est rapide.',
              points: 3,
              rapportJury:
                  'Le jury attend la diagonalisation et l\'interprétation du résultat.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que l\'équation \$x^3 + x - 1 = 0\$ admet une unique solution réelle \$\\alpha\$, '
                  'puis proposer une méthode numérique pour l\'approcher.',
              indication:
                  'Étudier la fonction \$f(x) = x^3 + x - 1\$ (monotonie, TVI). '
                  'Pour l\'approximation, utiliser la méthode de Newton ou de la dichotomie.',
              correction:
                  'Ce qu\'on nous demande : existence, unicité et approximation d\'une racine.\n\n'
                  'Rappel : le TVI (théorème des valeurs intermédiaires) donne l\'existence. La stricte monotonie donne l\'unicité.\n\n'
                  '\$f(x) = x^3 + x - 1\$, \$f\'(x) = 3x^2 + 1 > 0\$ pour tout \$x\$. Donc \$f\$ est strictement croissante sur \$\\mathbb{R}\$.\n'
                  '\$f(0) = -1 < 0\$ et \$f(1) = 1 > 0\$. Par le TVI, \$f\$ s\'annule exactement une fois dans \$]0, 1[\$.\n'
                  'Méthode de Newton : \$x_{n+1} = x_n - \\frac{f(x_n)}{f\'(x_n)} = x_n - \\frac{x_n^3 + x_n - 1}{3x_n^2 + 1}\$.\n'
                  'Avec \$x_0 = 1\$ : \$x_1 = 1 - 1/4 = 0.75\$, \$x_2 \\approx 0.6861\$, \$x_3 \\approx 0.6824\$ (convergence quadratique).\n'
                  'Dichotomie : \$f(0.5) = -0.375 < 0\$, \$f(0.75) = 0.1719 > 0\$, \$f(0.6875) \\approx 0.0124 > 0\$, etc.\n\n'
                  'Attention : Newton converge plus vite que la dichotomie, mais nécessite le calcul de \$f\'\$ et peut diverger si \$x_0\$ est mal choisi.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'étude de \$f\$ (monotonie, TVI) et au moins une méthode numérique avec itérations.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f : [0, 1] \\to \\mathbb{R}\$ continue. Montrer que '
                  '\$\\lim_{n \\to \\infty} \\int_0^1 f(t) t^n \\, dt = 0\$.',
              indication:
                  'Séparer l\'intégrale en \$[0, 1-\\varepsilon]\$ et \$[1-\\varepsilon, 1]\$ '
                  'et utiliser la convergence uniforme de \$t^n\$ vers 0 sur \$[0, 1-\\varepsilon]\$.',
              correction:
                  'Ce qu\'on nous demande : calculer la limite d\'une intégrale dépendant d\'un paramètre.\n\n'
                  'Rappel : \$t^n \\to 0\$ pour \$t \\in [0,1[\$ et \$t^n \\to 1\$ pour \$t = 1\$. La convergence n\'est PAS uniforme sur \$[0,1]\$, donc on ne peut pas appliquer directement le TCD.\n\n'
                  'Soit \$M = \\|f\\|_\\infty\$ et \$\\varepsilon > 0\$. On coupe : \$\\int_0^1 = \\int_0^{1-\\varepsilon} + \\int_{1-\\varepsilon}^1\$.\n'
                  'Sur \$[0, 1-\\varepsilon]\$ : \$|f(t)t^n| \\leq M(1-\\varepsilon)^n \\to 0\$. Donc \$\\int_0^{1-\\varepsilon} |f(t)t^n| dt \\leq M(1-\\varepsilon)^n \\to 0\$.\n'
                  'Sur \$[1-\\varepsilon, 1]\$ : \$|\\int_{1-\\varepsilon}^1 f(t)t^n dt| \\leq M \\int_{1-\\varepsilon}^1 t^n dt = M \\cdot \\frac{1 - (1-\\varepsilon)^{n+1}}{n+1} \\leq \\frac{M}{n+1} \\to 0\$.\n'
                  'Bilan : \$|\\int_0^1 f(t)t^n dt| \\to 0\$.\n\n'
                  'Attention : si \$f\$ vaut 1 en 1, on pourrait croire que la contribution en 1 persiste. Mais le point 1 est de mesure nulle !',
              points: 3,
              rapportJury:
                  'Le jury attend le découpage de l\'intégrale et la majoration sur chaque morceau.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$E_n\$ le nombre de surjections de \$\\{1, \\ldots, n\\}\$ dans \$\\{1, 2, 3\\}\$. '
                  'Exprimer \$E_n\$ à l\'aide de la formule d\'inclusion-exclusion.',
              indication:
                  'Utiliser le complémentaire : \$E_n = \\sum_{k=0}^{3} (-1)^k \\binom{3}{k} (3-k)^n\$.',
              correction:
                  'Ce qu\'on nous demande : compter les surjections par inclusion-exclusion.\n\n'
                  'Rappel : pour \$f : E \\to F\$ surjective, on pose \$A_j = \\{f : E \\to F \\mid j \\notin \\mathrm{Im}(f)\\}\$. Les surjections sont le complémentaire de \$A_1 \\cup A_2 \\cup A_3\$.\n\n'
                  'Par inclusion-exclusion : \$|A_1 \\cup A_2 \\cup A_3| = \\sum|A_i| - \\sum|A_i \\cap A_j| + |A_1 \\cap A_2 \\cap A_3|\$.\n'
                  '\$|A_i| = 2^n\$ (chaque élément a 2 choix), \$|A_i \\cap A_j| = 1^n = 1\$, \$|A_1 \\cap A_2 \\cap A_3| = 0\$.\n'
                  '\$E_n = 3^n - \\binom{3}{1} 2^n + \\binom{3}{2} 1^n - \\binom{3}{3} 0^n = 3^n - 3 \\cdot 2^n + 3\$.\n'
                  'Vérification : \$E_1 = 3 - 6 + 3 = 0\$ ✓ (pas de surjection de 1 élément vers 3).\n'
                  '\$E_3 = 27 - 24 + 3 = 6 = 3!\$ ✓ (les bijections). \$E_4 = 81 - 48 + 3 = 36\$ ✓.\n\n'
                  'Attention : la formule générale pour les surjections de \$\\{1,\\ldots,n\\}\$ vers \$\\{1,\\ldots,p\\}\$ est \$\\sum_{k=0}^{p} (-1)^k \\binom{p}{k}(p-k)^n\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la formule d\'inclusion-exclusion et la vérification pour les petites valeurs.',
            ),
            QuestionAnnale(
              enonce:
                  'On lance un dé équilibré à 6 faces. Soit \$N\$ le nombre de lancers nécessaires '
                  'pour obtenir chaque face au moins une fois. Calculer \$\\mathbb{E}[N]\$.',
              indication:
                  'Décomposer \$N = T_1 + T_2 + \\cdots + T_6\$ où \$T_k\$ est le temps d\'attente '
                  'pour obtenir la \$k\$-ème face nouvelle.',
              correction:
                  'Ce qu\'on nous demande : résoudre le problème du collecteur de coupons.\n\n'
                  'Rappel : c\'est le « coupon collector problem ». On décompose l\'attente en phases.\n\n'
                  'Phase \$k\$ : on a déjà \$k-1\$ faces distinctes, on attend la \$k\$-ème. La probabilité de succès à chaque lancer est \$p_k = (6 - (k-1))/6 = (7-k)/6\$.\n'
                  '\$T_k \\sim \\mathrm{Geom}(p_k)\$ (nombre de lancers pour le succès), donc \$\\mathbb{E}[T_k] = 6/(7-k)\$.\n'
                  '\$N = T_1 + \\cdots + T_6\$ et \$\\mathbb{E}[N] = \\sum_{k=1}^{6} \\frac{6}{7-k} = \\frac{6}{6} + \\frac{6}{5} + \\frac{6}{4} + \\frac{6}{3} + \\frac{6}{2} + \\frac{6}{1}\$.\n'
                  '\$\\mathbb{E}[N] = 1 + 1.2 + 1.5 + 2 + 3 + 6 = 14.7\$.\n'
                  'Formule générale pour \$n\$ faces : \$\\mathbb{E}[N] = n \\cdot H_n\$ où \$H_n = \\sum_{k=1}^n 1/k\$ est le \$n\$-ème nombre harmonique.\n\n'
                  'Attention : la variance est aussi calculable : \$\\mathrm{Var}(N) = \\sum_{k=1}^n \\frac{6^2 (k-1)}{(7-k)^2}\$. L\'espérance est en \$O(n \\ln n)\$ pour \$n\$ faces.',
              points: 3,
              rapportJury:
                  'Le jury attend la décomposition en phases géométriques et le calcul explicite.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2025 – Épreuve 2
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2025EP2() {
    return Annale(
      id: 'ped_int_2025_ep2',
      annee: 2025,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2025 – Épreuve 2 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 2 de l\'agrégation interne 2025. '
          'Probabilités, suites et fonctions, arithmétique.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Probabilités', 'Suites', 'Fonctions', 'Arithmétique', 'Dénombrement'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep2/25-ep2.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Lois discrètes',
        'Espérance conditionnelle',
        'Suites récurrentes',
        'Théorème de Bézout',
        'Congruences',
      ],
      rapportGlobal:
          'L\'épreuve 2 de l\'interne 2025 mêle probabilités, analyse des suites et fonctions, '
          'et arithmétique. Notre correction vous accompagne pas à pas '
          'avec des rappels de cours adaptés et des pièges à éviter.',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Probabilités',
          introduction:
              'Cette partie porte sur les variables aléatoires discrètes, '
              'les lois classiques, l\'espérance et la variance.',
          bareme: 7,
          themes: ['Variables aléatoires', 'Lois discrètes', 'Espérance'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$X\$ une variable aléatoire suivant une loi de Poisson de paramètre '
                  '\$\\lambda > 0\$. Calculer \$\\mathbb{E}[X(X-1)]\$ et en déduire \$\\mathrm{Var}(X)\$.',
              indication:
                  'Utiliser la définition : \$\\mathbb{E}[X(X-1)] = \\sum_{k=0}^{\\infty} k(k-1) e^{-\\lambda} \\lambda^k / k!\$. '
                  'Simplifier la somme en faisant apparaître \$\\lambda^2\$.',
              correction:
                  'Ce qu\'on nous demande : calculer le moment factoriel d\'ordre 2 et la variance de la loi de Poisson.\n\n'
                  'Rappel : si \$X \\sim \\mathcal{P}(\\lambda)\$, alors \$\\mathbb{P}(X = k) = e^{-\\lambda} \\lambda^k / k!\$ et \$\\mathbb{E}[X] = \\lambda\$.\n\n'
                  '\$\\mathbb{E}[X(X-1)] = \\sum_{k=2}^{\\infty} k(k-1) \\frac{e^{-\\lambda} \\lambda^k}{k!} = \\sum_{k=2}^{\\infty} \\frac{e^{-\\lambda} \\lambda^k}{(k-2)!}\$.\n'
                  'Changement d\'indice \$j = k-2\$ : \$= e^{-\\lambda} \\lambda^2 \\sum_{j=0}^{\\infty} \\frac{\\lambda^j}{j!} = e^{-\\lambda} \\lambda^2 e^{\\lambda} = \\lambda^2\$.\n'
                  'Donc \$\\mathbb{E}[X^2] = \\mathbb{E}[X(X-1)] + \\mathbb{E}[X] = \\lambda^2 + \\lambda\$.\n'
                  '\$\\mathrm{Var}(X) = \\mathbb{E}[X^2] - (\\mathbb{E}[X])^2 = \\lambda^2 + \\lambda - \\lambda^2 = \\lambda\$.\n'
                  'Résultat remarquable : pour la loi de Poisson, \$\\mathbb{E}[X] = \\mathrm{Var}(X) = \\lambda\$.\n\n'
                  'Attention : cette propriété \$\\mathbb{E} = \\mathrm{Var}\$ caractérise (presque) la loi de Poisson parmi les lois discrètes sur \$\\mathbb{N}\$.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul du moment factoriel et la relation \$\\mathrm{Var} = \\lambda\$.',
            ),
            QuestionAnnale(
              enonce:
                  'On tire sans remise 5 cartes d\'un jeu de 32 cartes. Soit \$X\$ le nombre d\'as obtenus. '
                  'Déterminer la loi de \$X\$ et calculer \$\\mathbb{E}[X]\$.',
              indication:
                  'Reconnaître une loi hypergéométrique.',
              correction:
                  'Ce qu\'on nous demande : déterminer la loi d\'un tirage sans remise.\n\n'
                  'Rappel : le tirage sans remise de \$n\$ éléments parmi \$N\$ dont \$K\$ sont « marqués » suit une loi hypergéométrique \$\\mathcal{H}(N, K, n)\$.\n\n'
                  'Ici \$N = 32\$, \$K = 4\$ (as), \$n = 5\$. Donc \$X \\sim \\mathcal{H}(32, 4, 5)\$.\n'
                  '\$\\mathbb{P}(X = k) = \\frac{\\binom{4}{k} \\binom{28}{5-k}}{\\binom{32}{5}}\$ pour \$k = 0, 1, 2, 3, 4\$.\n'
                  '\$\\mathbb{E}[X] = n \\cdot K/N = 5 \\cdot 4/32 = 5/8 = 0.625\$.\n'
                  'Calcul explicite : \$\\mathbb{P}(X=0) = \\binom{28}{5}/\\binom{32}{5} = 98280/201376 \\approx 0.488\$.\n'
                  '\$\\mathbb{P}(X=1) = \\binom{4}{1}\\binom{28}{4}/\\binom{32}{5} \\approx 0.392\$, etc.\n\n'
                  'Attention : ne confondez pas avec le tirage AVEC remise qui donnerait une loi binomiale \$\\mathcal{B}(5, 1/8)\$. Pour \$N\$ grand devant \$n\$, les deux se rapprochent.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'identification de la loi hypergéométrique et le calcul de l\'espérance.',
            ),
            QuestionAnnale(
              enonce:
                  'Deux joueurs A et B jouent une série de parties. A gagne chaque partie avec probabilité '
                  '\$p = 0.6\$ et B avec probabilité \$q = 0.4\$. Le premier qui atteint 2 victoires gagne. '
                  'Calculer la probabilité que A gagne la série.',
              indication:
                  'Dénombrer les scénarios possibles : la série dure 2 ou 3 parties.',
              correction:
                  'Ce qu\'on nous demande : calculer la probabilité de gagner une série en « best of 3 » (premier à 2 victoires).\n\n'
                  'Rappel : les parties sont indépendantes. La série dure au minimum 2 et au maximum 3 parties.\n\n'
                  'A gagne en 2 parties : AA. Probabilité \$p^2 = 0.36\$.\n'
                  'A gagne en 3 parties : ABA ou BAA. Probabilité \$2pq \\cdot p = 2 \\cdot 0.6 \\cdot 0.4 \\cdot 0.6 = 0.288\$.\n'
                  'Total : \$\\mathbb{P}(A\\ \\text{gagne}) = 0.36 + 0.288 = 0.648\$.\n'
                  'Formule générale : \$\\mathbb{P}(A) = p^2 + 2p^2 q = p^2(1 + 2q) = p^2(3 - 2p)\$.\n'
                  'Vérification : \$\\mathbb{P}(B) = q^2(3 - 2q) = 0.16 \\cdot 2.2 = 0.352\$, et \$0.648 + 0.352 = 1\$ ✓.\n'
                  'La série amplifie l\'avantage de A : de \$p = 0.6\$ à \$0.648\$.\n\n'
                  'Attention : plus la série est longue (best of 5, 7...), plus la probabilité que le meilleur joueur gagne augmente.',
              points: 3,
              rapportJury:
                  'Le jury attend le dénombrement exhaustif des scénarios et la vérification \$P(A) + P(B) = 1\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_n)_{n \\geq 0}\$ une marche aléatoire sur \$\\mathbb{Z}\$ : \$X_0 = 0\$ et '
                  '\$X_{n+1} = X_n + Y_{n+1}\$ où les \$Y_i\$ sont i.i.d. avec \$\\mathbb{P}(Y = 1) = \\mathbb{P}(Y = -1) = 1/2\$. '
                  'Calculer \$\\mathbb{E}[X_n]\$ et \$\\mathrm{Var}(X_n)\$.',
              indication:
                  'Utiliser la linéarité de l\'espérance et l\'indépendance des \$Y_i\$.',
              correction:
                  'Ce qu\'on nous demande : calculer les deux premiers moments de la marche aléatoire symétrique.\n\n'
                  'Rappel : \$X_n = Y_1 + \\cdots + Y_n\$ avec les \$Y_i\$ i.i.d. de loi \$\\mathbb{P}(Y = \\pm 1) = 1/2\$.\n\n'
                  '\$\\mathbb{E}[Y_i] = 1 \\cdot 1/2 + (-1) \\cdot 1/2 = 0\$.\n'
                  'Par linéarité : \$\\mathbb{E}[X_n] = \\sum_{i=1}^n \\mathbb{E}[Y_i] = 0\$. La marche est centrée.\n'
                  '\$\\mathrm{Var}(Y_i) = \\mathbb{E}[Y_i^2] - 0 = 1\$.\n'
                  'Par indépendance : \$\\mathrm{Var}(X_n) = \\sum_{i=1}^n \\mathrm{Var}(Y_i) = n\$.\n'
                  'L\'écart-type est \$\\sigma(X_n) = \\sqrt{n}\$. Après \$n\$ pas, la marche est typiquement à distance \$\\sqrt{n}\$ de l\'origine.\n'
                  'Par le TCL : \$X_n / \\sqrt{n} \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0, 1)\$.\n\n'
                  'Attention : bien que \$\\mathbb{E}[X_n] = 0\$, la marche ne reste PAS près de 0. Elle s\'éloigne en \$\\sqrt{n}\$ (phénomène de diffusion).',
              points: 3,
              rapportJury:
                  'Le jury attend la linéarité pour l\'espérance et l\'indépendance pour la variance.',
            ),
            QuestionAnnale(
              enonce:
                  'On dispose de 3 urnes. L\'urne \$i\$ contient \$i\$ boules blanches et \$3-i\$ boules noires '
                  '(\$i = 1, 2, 3\$). On choisit une urne au hasard, puis on tire une boule. '
                  'Sachant que la boule est blanche, quelle est la probabilité qu\'elle provienne de l\'urne 3 ?',
              indication:
                  'Appliquer la formule de Bayes : \$\\mathbb{P}(U_3 | B) = \\frac{\\mathbb{P}(B | U_3) \\mathbb{P}(U_3)}{\\mathbb{P}(B)}\$.',
              correction:
                  'Ce qu\'on nous demande : appliquer le théorème de Bayes pour un problème d\'urne.\n\n'
                  'Rappel : Bayes inverse les probabilités conditionnelles. \$\\mathbb{P}(U_i | B) = \\frac{\\mathbb{P}(B | U_i) \\mathbb{P}(U_i)}{\\mathbb{P}(B)}\$.\n\n'
                  '\$\\mathbb{P}(U_i) = 1/3\$ pour \$i = 1, 2, 3\$.\n'
                  '\$\\mathbb{P}(B | U_1) = 1/3\$, \$\\mathbb{P}(B | U_2) = 2/3\$, \$\\mathbb{P}(B | U_3) = 3/3 = 1\$.\n'
                  'Formule des probabilités totales : \$\\mathbb{P}(B) = \\frac{1}{3}(1/3 + 2/3 + 1) = \\frac{1}{3} \\cdot 2 = 2/3\$.\n'
                  'Bayes : \$\\mathbb{P}(U_3 | B) = \\frac{1 \\cdot 1/3}{2/3} = \\frac{1}{2}\$.\n'
                  'Vérification : \$\\mathbb{P}(U_1|B) = \\frac{1/9}{2/3} = 1/6\$, \$\\mathbb{P}(U_2|B) = \\frac{2/9}{2/3} = 1/3\$. Total : \$1/6 + 1/3 + 1/2 = 1\$ ✓.\n\n'
                  'Attention : Bayes met à jour nos croyances. A priori les urnes sont équiprobables, mais sachant que la boule est blanche, l\'urne 3 (toutes blanches) est la plus probable.',
              points: 3,
              rapportJury:
                  'Le jury attend les probabilités totales et l\'application correcte de Bayes.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Suites et fonctions',
          introduction:
              'Cette partie porte sur l\'étude de suites récurrentes, '
              'de fonctions classiques et de leurs propriétés.',
          bareme: 7,
          themes: ['Suites récurrentes', 'Fonctions', 'Continuité', 'Dérivabilité'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit la suite \$(u_n)\$ définie par \$u_0 = 0\$ et \$u_{n+1} = \\sin(u_n) + 1\$. '
                  'Montrer que \$(u_n)\$ converge et déterminer sa limite.',
              indication:
                  'Montrer que la suite est majorée et monotone. '
                  'La limite vérifie \$\\ell = \\sin(\\ell) + 1\$.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence de la suite \$u_{n+1} = f(u_n)\$ avec \$f(x) = \\sin(x) + 1\$.\n\n'
                  'Rappel : si \$f\$ envoie un intervalle \$[a, b]\$ dans lui-même et est croissante, alors \$(u_n)\$ est monotone et converge.\n\n'
                  '\$f([0, 2]) \\subseteq [1, 1 + \\sin(2)] \\subseteq [1, 2] \\subseteq [0, 2]\$. Comme \$u_0 = 0 \\in [0, 2]\$, on a \$u_n \\in [0, 2]\$ pour tout \$n\$.\n'
                  '\$u_1 = \\sin(0) + 1 = 1 > 0 = u_0\$, donc \$u_1 > u_0\$.\n'
                  '\$f\' = \\cos(x)\$. Sur \$[0, 2]\$, \$f\$ n\'est pas monotone (car \$\\cos\$ change de signe en \$\\pi/2\$). Montrons directement par récurrence que \$u_n \\leq u_{n+1}\$.\n'
                  'Si \$u_n \\leq u_{n+1}\$, comme \$u_n, u_{n+1} \\in [0, \\pi/2]\$ (à vérifier) et \$\\sin\$ est croissante sur \$[0, \\pi/2]\$ : \$u_{n+2} = \\sin(u_{n+1}) + 1 \\geq \\sin(u_n) + 1 = u_{n+1}\$.\n'
                  'La suite est croissante et majorée par 2, donc elle converge vers \$\\ell = \\sin(\\ell) + 1\$.\n'
                  'L\'unique solution dans \$[0, 2]\$ est \$\\ell \\approx 1.935\$ (résolution numérique de \$x - \\sin(x) = 1\$).\n\n'
                  'Attention : la limite n\'a pas d\'expression en forme fermée. Il faut justifier l\'existence et l\'unicité de la solution de \$x = \\sin(x) + 1\$ sur l\'intervalle considéré.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve de monotonie et bornitude, puis le passage à la limite.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la fonction \$f(x) = x \\sin(1/x)\$ pour \$x \\neq 0\$ et \$f(0) = 0\$ '
                  'est continue sur \$\\mathbb{R}\$ mais non dérivable en 0.',
              indication:
                  'Pour la continuité, utiliser \$|f(x)| \\leq |x|\$. '
                  'Pour la non-dérivabilité, étudier \$f(x)/x = \\sin(1/x)\$.',
              correction:
                  'Ce qu\'on nous demande : étudier la régularité de \$x \\mapsto x\\sin(1/x)\$ en 0.\n\n'
                  'Rappel : \$f\$ est continue en 0 si \$\\lim_{x \\to 0} f(x) = f(0)\$. Elle est dérivable en 0 si \$\\lim_{x \\to 0} f(x)/x\$ existe.\n\n'
                  'Continuité : \$|f(x)| = |x| \\cdot |\\sin(1/x)| \\leq |x| \\to 0\$ quand \$x \\to 0\$. Par encadrement, \$f(x) \\to 0 = f(0)\$ ✓.\n'
                  'Dérivabilité : \$\\frac{f(x) - f(0)}{x - 0} = \\frac{x\\sin(1/x)}{x} = \\sin(1/x)\$.\n'
                  'Or \$\\sin(1/x)\$ n\'a pas de limite quand \$x \\to 0\$ (elle oscille entre \$-1\$ et \$1\$).\n'
                  'Par exemple, \$x_n = 1/(2n\\pi) \\to 0\$ donne \$\\sin(2n\\pi) = 0\$, et \$x_n\' = 1/(2n\\pi + \\pi/2) \\to 0\$ donne \$\\sin(2n\\pi + \\pi/2) = 1\$.\n'
                  'Deux sous-suites ont des limites différentes, donc \$f\'(0)\$ n\'existe pas.\n\n'
                  'Attention : la fonction \$g(x) = x^2 \\sin(1/x)\$ est, elle, dérivable en 0 (avec \$g\'(0) = 0\$). Le facteur \$x^2\$ au lieu de \$x\$ fait la différence.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'encadrement pour la continuité et les sous-suites pour la non-dérivabilité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f : [0, 1] \\to [0, 1]\$ continue. Montrer que \$f\$ admet un point fixe.',
              indication:
                  'Considérer \$g(x) = f(x) - x\$ et appliquer le TVI.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'existence d\'un point fixe pour une fonction continue de \$[0,1]\$ dans \$[0,1]\$.\n\n'
                  'Rappel : le TVI dit que si \$g\$ est continue sur \$[a,b]\$ et \$g(a) \\cdot g(b) \\leq 0\$, alors \$g\$ s\'annule dans \$[a,b]\$.\n\n'
                  'Posons \$g(x) = f(x) - x\$, continue sur \$[0, 1]\$.\n'
                  '\$g(0) = f(0) - 0 = f(0) \\geq 0\$ (car \$f : [0,1] \\to [0,1]\$).\n'
                  '\$g(1) = f(1) - 1 \\leq 0\$ (car \$f(1) \\leq 1\$).\n'
                  'Si \$g(0) = 0\$ : \$f(0) = 0\$, point fixe ✓. Si \$g(1) = 0\$ : \$f(1) = 1\$, point fixe ✓.\n'
                  'Sinon \$g(0) > 0\$ et \$g(1) < 0\$. Par le TVI, il existe \$c \\in ]0, 1[\$ tel que \$g(c) = 0\$, i.e. \$f(c) = c\$.\n\n'
                  'Attention : le point fixe n\'est pas forcément unique. En revanche, si \$f\$ est contractante (\$|f(x)-f(y)| < |x-y|\$ pour \$x \\neq y\$), le point fixe est unique.',
              points: 2,
              rapportJury:
                  'Le jury attend l\'application du TVI à \$g(x) = f(x) - x\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f(x) = \\sum_{n=0}^{+\\infty} \\frac{x^n}{n!} = e^x\$. '
                  'Montrer directement (sans utiliser les propriétés connues de l\'exponentielle) '
                  'que \$f\'(x) = f(x)\$ et \$f(0) = 1\$.',
              indication:
                  'Dériver la série entière terme à terme.',
              correction:
                  'Ce qu\'on nous demande : retrouver la propriété fondamentale de l\'exponentielle à partir de sa série.\n\n'
                  'Rappel : une série entière de rayon de convergence \$R > 0\$ est de classe \$\\mathcal{C}^\\infty\$ sur \$]-R, R[\$ et se dérive terme à terme.\n\n'
                  'Rayon de convergence : \$a_n = 1/n!\$. \$a_{n+1}/a_n = 1/(n+1) \\to 0\$. Donc \$R = +\\infty\$.\n'
                  '\$f(0) = \\sum_{n=0}^{\\infty} 0^n/n! = 1\$ (seul le terme \$n = 0\$ survit).\n'
                  'Dérivation terme à terme : \$f\'(x) = \\sum_{n=1}^{\\infty} \\frac{nx^{n-1}}{n!} = \\sum_{n=1}^{\\infty} \\frac{x^{n-1}}{(n-1)!}\$.\n'
                  'Changement d\'indice \$m = n-1\$ : \$f\'(x) = \\sum_{m=0}^{\\infty} \\frac{x^m}{m!} = f(x)\$.\n'
                  'Donc \$f\' = f\$ et \$f(0) = 1\$. Ce sont les conditions qui caractérisent \$e^x\$ (solution de \$y\' = y\$, \$y(0) = 1\$).\n\n'
                  'Attention : la convergence de la série est uniforme sur tout compact, ce qui justifie la dérivation terme à terme.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul du rayon, la dérivation terme à terme et le reindexage.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la fonction \$\\Gamma(x) = \\int_0^{+\\infty} t^{x-1} e^{-t} dt\$ '
                  'est bien définie pour \$x > 0\$ et vérifie \$\\Gamma(x+1) = x \\Gamma(x)\$.',
              indication:
                  'Étudier la convergence de l\'intégrale en 0 et en \$+\\infty\$ séparément. '
                  'Pour la relation fonctionnelle, intégrer par parties.',
              correction:
                  'Ce qu\'on nous demande : montrer la bonne définition de la fonction Gamma et sa relation fonctionnelle.\n\n'
                  'Rappel : \$\\Gamma\$ généralise la factorielle : \$\\Gamma(n+1) = n!\$ pour \$n \\in \\mathbb{N}\$.\n\n'
                  'En \$t = 0^+\$ : \$t^{x-1} e^{-t} \\sim t^{x-1}\$. Intégrable ssi \$x - 1 > -1\$, i.e. \$x > 0\$.\n'
                  'En \$t \\to +\\infty\$ : \$t^{x-1} e^{-t} = o(e^{-t/2})\$ (l\'exponentielle domine tout polynôme). Intégrable ✓.\n'
                  'Donc \$\\Gamma(x)\$ converge pour \$x > 0\$.\n'
                  'Relation fonctionnelle : IPP avec \$u = t^x\$ et \$dv = e^{-t}dt\$ dans \$\\Gamma(x+1) = \\int_0^\\infty t^x e^{-t} dt\$.\n'
                  '\$\\Gamma(x+1) = [-t^x e^{-t}]_0^\\infty + \\int_0^\\infty x t^{x-1} e^{-t} dt = 0 + x \\Gamma(x)\$.\n'
                  'Avec \$\\Gamma(1) = \\int_0^\\infty e^{-t} dt = 1\$, on en déduit \$\\Gamma(n+1) = n!\$ par récurrence.\n\n'
                  'Attention : \$\\Gamma\$ n\'est pas définie pour \$x \\leq 0\$ (divergence en 0). On peut l\'étendre par prolongement méromorphe avec des pôles en \$0, -1, -2, \\ldots\$',
              points: 3,
              rapportJury:
                  'Le jury attend l\'étude de convergence en 0 et \$+\\infty\$ et l\'IPP pour la relation fonctionnelle.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Arithmétique',
          introduction:
              'Cette partie porte sur la divisibilité, les congruences, '
              'le théorème de Bézout et les applications.',
          bareme: 6,
          themes: ['Divisibilité', 'Congruences', 'Bézout', 'Dénombrement'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Calculer le PGCD de \$a = 1001\$ et \$b = 770\$ par l\'algorithme d\'Euclide, '
                  'puis trouver \$u, v \\in \\mathbb{Z}\$ tels que \$au + bv = \\mathrm{pgcd}(a, b)\$.',
              indication:
                  'Effectuer les divisions euclidiennes successives, '
                  'puis remonter l\'algorithme pour les coefficients de Bézout.',
              correction:
                  'Ce qu\'on nous demande : appliquer l\'algorithme d\'Euclide étendu.\n\n'
                  'Rappel : l\'algorithme d\'Euclide calcule le PGCD par divisions successives. La remontée donne les coefficients de Bézout.\n\n'
                  '\$1001 = 770 \\cdot 1 + 231\$\n'
                  '\$770 = 231 \\cdot 3 + 77\$\n'
                  '\$231 = 77 \\cdot 3 + 0\$\n'
                  'Donc \$\\mathrm{pgcd}(1001, 770) = 77\$. Vérification : \$1001 = 7 \\cdot 11 \\cdot 13\$ et \$770 = 2 \\cdot 5 \\cdot 7 \\cdot 11\$, \$\\mathrm{pgcd} = 7 \\cdot 11 = 77\$ ✓.\n'
                  'Remontée : \$77 = 770 - 231 \\cdot 3 = 770 - (1001 - 770) \\cdot 3 = 4 \\cdot 770 - 3 \\cdot 1001\$.\n'
                  'Donc \$u = -3\$ et \$v = 4\$ : \$1001 \\cdot (-3) + 770 \\cdot 4 = -3003 + 3080 = 77\$ ✓.\n\n'
                  'Attention : les coefficients de Bézout ne sont pas uniques. La solution générale est \$u\' = u + 10k\$, \$v\' = v - 13k\$ pour \$k \\in \\mathbb{Z}\$.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'algorithme complet et la vérification des coefficients de Bézout.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre le système de congruences '
                  '\$\\begin{cases} x \\equiv 2 \\pmod{3} \\\\ x \\equiv 3 \\pmod{5} \\\\ x \\equiv 4 \\pmod{7} \\end{cases}\$.',
              indication:
                  'Appliquer le théorème chinois des restes (CRT) car 3, 5, 7 sont premiers entre eux deux à deux.',
              correction:
                  'Ce qu\'on nous demande : résoudre un système de congruences par le théorème chinois.\n\n'
                  'Rappel (CRT) : si \$m_1, m_2, m_3\$ sont premiers entre eux deux à deux, le système \$x \\equiv a_i \\pmod{m_i}\$ a une unique solution modulo \$m_1 m_2 m_3\$.\n\n'
                  'Ici \$m_1 m_2 m_3 = 3 \\cdot 5 \\cdot 7 = 105\$.\n'
                  'Méthode : \$M_1 = 35\$, \$M_2 = 21\$, \$M_3 = 15\$. On cherche les inverses : \$35 \\cdot y_1 \\equiv 1 \\pmod{3}\$ : \$35 \\equiv 2 \\pmod{3}\$, \$2 \\cdot 2 = 4 \\equiv 1\$, donc \$y_1 = 2\$.\n'
                  '\$21 \\cdot y_2 \\equiv 1 \\pmod{5}\$ : \$21 \\equiv 1 \\pmod{5}\$, donc \$y_2 = 1\$.\n'
                  '\$15 \\cdot y_3 \\equiv 1 \\pmod{7}\$ : \$15 \\equiv 1 \\pmod{7}\$, donc \$y_3 = 1\$.\n'
                  '\$x = 2 \\cdot 35 \\cdot 2 + 3 \\cdot 21 \\cdot 1 + 4 \\cdot 15 \\cdot 1 = 140 + 63 + 60 = 263 \\equiv 53 \\pmod{105}\$.\n'
                  'Vérification : \$53 = 17 \\cdot 3 + 2\$ ✓, \$53 = 10 \\cdot 5 + 3\$ ✓, \$53 = 7 \\cdot 7 + 4\$ ✓.\n\n'
                  'Attention : le CRT exige que les modules soient premiers entre eux deux à deux. Sinon, le système peut ne pas avoir de solution.',
              points: 3,
              rapportJury:
                  'Le jury attend la méthode CRT complète avec vérification.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que pour tout \$n \\in \\mathbb{N}\$, \$n^3 - n\$ est divisible par 6.',
              indication:
                  'Factoriser \$n^3 - n = n(n-1)(n+1)\$ et utiliser que trois entiers consécutifs '
                  'contiennent un multiple de 2 et un multiple de 3.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$6 \\mid n^3 - n\$ pour tout entier \$n\$.\n\n'
                  'Rappel : parmi \$k\$ entiers consécutifs, l\'un au moins est divisible par \$k\$.\n\n'
                  'Factorisation : \$n^3 - n = n(n^2 - 1) = (n-1)n(n+1)\$. C\'est le produit de trois entiers consécutifs.\n'
                  'Divisibilité par 2 : parmi 3 entiers consécutifs, au moins un est pair. Donc \$2 \\mid (n-1)n(n+1)\$.\n'
                  'Divisibilité par 3 : parmi 3 entiers consécutifs, exactement un est multiple de 3. Donc \$3 \\mid (n-1)n(n+1)\$.\n'
                  'Comme \$\\mathrm{pgcd}(2, 3) = 1\$, on a \$6 \\mid (n-1)n(n+1)\$.\n'
                  'On peut aussi le voir avec les coefficients binomiaux : \$(n-1)n(n+1) = 6 \\binom{n+1}{3}\$ si \$n \\geq 2\$, et \$\\binom{n+1}{3} \\in \\mathbb{Z}\$.\n\n'
                  'Attention : on peut aussi le prouver par congruences (tester \$n \\equiv 0, 1, 2, 3, 4, 5 \\pmod{6}\$) mais la factorisation est plus élégante.',
              points: 2,
              rapportJury:
                  'Le jury attend la factorisation et l\'argument sur les entiers consécutifs.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer le dernier chiffre (en base 10) de \$7^{2025}\$.',
              indication:
                  'Calculer les puissances de 7 modulo 10 et trouver la périodicité.',
              correction:
                  'Ce qu\'on nous demande : calculer \$7^{2025} \\pmod{10}\$.\n\n'
                  'Rappel : le dernier chiffre d\'un entier est son reste modulo 10. Les puissances de 7 modulo 10 sont périodiques.\n\n'
                  'Calculons : \$7^1 \\equiv 7\$, \$7^2 \\equiv 49 \\equiv 9\$, \$7^3 \\equiv 63 \\equiv 3\$, \$7^4 \\equiv 21 \\equiv 1 \\pmod{10}\$.\n'
                  'La suite est périodique de période 4 : \$7, 9, 3, 1, 7, 9, 3, 1, \\ldots\$\n'
                  'On a \$2025 = 4 \\cdot 506 + 1\$, donc \$7^{2025} \\equiv 7^1 \\equiv 7 \\pmod{10}\$.\n'
                  'Le dernier chiffre de \$7^{2025}\$ est 7.\n'
                  'Par le théorème d\'Euler : \$\\varphi(10) = 4\$, donc \$7^4 \\equiv 1 \\pmod{10}\$ (car \$\\mathrm{pgcd}(7,10) = 1\$), ce qui confirme la période 4.\n\n'
                  'Attention : cette méthode fonctionne pour toute base \$a\$ avec \$\\mathrm{pgcd}(a, 10) = 1\$. Si \$\\mathrm{pgcd}(a,10) \\neq 1\$, la suite n\'est pas périodique dès le départ.',
              points: 2,
              rapportJury:
                  'Le jury attend le calcul de la période et l\'utilisation de la division euclidienne de l\'exposant.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que \$\\sqrt{2}\$ est irrationnel par l\'absurde.',
              indication:
                  'Supposer \$\\sqrt{2} = p/q\$ avec \$p, q \\in \\mathbb{Z}\$ et \$\\mathrm{pgcd}(p,q) = 1\$, '
                  'puis obtenir une contradiction sur la parité.',
              correction:
                  'Ce qu\'on nous demande : démontrer l\'irrationalité de \$\\sqrt{2}\$, résultat classique fondamental.\n\n'
                  'Rappel : un nombre est irrationnel s\'il ne peut pas s\'écrire sous la forme \$p/q\$ avec \$p, q \\in \\mathbb{Z}\$, \$q \\neq 0\$.\n\n'
                  'Par l\'absurde : supposons \$\\sqrt{2} = p/q\$ avec \$\\mathrm{pgcd}(p,q) = 1\$ (fraction irréductible).\n'
                  'Alors \$2 = p^2/q^2\$, donc \$p^2 = 2q^2\$.\n'
                  'Ainsi \$p^2\$ est pair, donc \$p\$ est pair (car si \$p\$ était impair, \$p^2\$ serait impair).\n'
                  'Écrivons \$p = 2k\$. Alors \$4k^2 = 2q^2\$, soit \$q^2 = 2k^2\$.\n'
                  'Donc \$q^2\$ est pair, puis \$q\$ est pair.\n'
                  'Mais alors \$p\$ et \$q\$ sont tous deux pairs, contredisant \$\\mathrm{pgcd}(p,q) = 1\$. Contradiction !\n'
                  'Donc \$\\sqrt{2} \\notin \\mathbb{Q}\$.\n\n'
                  'Attention : cette preuve utilise le lemme « si \$p^2\$ est pair, alors \$p\$ est pair ». Ce lemme repose sur l\'unicité de la factorisation en nombres premiers (arithmétique fondamentale).',
              points: 3,
              rapportJury:
                  'Le jury attend une rédaction soignée du raisonnement par l\'absurde avec la fraction irréductible.',
            ),
          ],
        ),
      ]
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2023 – Mathématiques générales
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2023MG() {
    return Annale(
      id: 'ped_ext_2023_mg',
      annee: 2023,
      session: 'externe',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation externe 2023 – Mathématiques générales (correction pédagogique)',
      description:
          'Correction pédagogique ultra-détaillée de l\'épreuve de mathématiques générales 2023 '
          '(algèbre, polynômes, réduction, espaces vectoriels, géométrie). Chaque question est décortiquée pas à pas, '
          'avec rappels de cours et pièges à éviter.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre', 'Polynômes', 'Réduction', 'Espaces vectoriels', 'Géométrie'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/MG/mg23.pdf',
      difficulte: 'Difficile',
      motsClefs: [
        'Polynômes irréductibles',
        'Réduction de Jordan',
        'Espaces vectoriels',
        'Dualité',
        'Topologie algébrique',
      ],
      rapportGlobal:
          'Cette épreuve 2023 couvre un large spectre : polynômes, réduction des endomorphismes et géométrie. '
          'Notre correction pédagogique reprend chaque question en détaillant les rappels de cours, les étapes de raisonnement '
          'et les pièges classiques. Prenez le temps de comprendre chaque étape. Vous progressez à chaque exercice, courage !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre et polynômes',
          introduction:
              'Cette partie porte sur l\'anneau des polynômes, l\'irréductibilité, '
              'les racines et les extensions de corps.',
          bareme: 7,
          themes: ['Polynômes', 'Corps', 'Irréductibilité'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$P = X^4 + 1 \\in \\mathbb{Q}[X]\$. Montrer que \$P\$ est irréductible sur \$\\mathbb{Q}\$.',
              indication:
                  'Utiliser le critère d\'Eisenstein après le changement de variable \$X \\mapsto X + 1\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$X^4 + 1\$ est irréductible sur \$\\mathbb{Q}\$.\n\n'
                  'Rappel : le critère d\'Eisenstein dit que si \$P(X) = a_n X^n + \\cdots + a_0\$ et qu\'il existe un premier \$p\$ tel que \$p \\nmid a_n\$, \$p | a_i\$ pour \$i < n\$ et \$p^2 \\nmid a_0\$, alors \$P\$ est irréductible sur \$\\mathbb{Q}\$.\n\n'
                  'On effectue le changement \$X \\mapsto X + 1\$ : \$P(X+1) = (X+1)^4 + 1 = X^4 + 4X^3 + 6X^2 + 4X + 2\$.\n'
                  'On applique Eisenstein avec \$p = 2\$ : \$2 \\nmid 1\$ (coefficient dominant), \$2 | 4, 6, 4, 2\$ et \$4 \\nmid 2\$ ✓.\n'
                  'Donc \$P(X+1)\$ est irréductible sur \$\\mathbb{Q}\$, et par conséquent \$P(X)\$ aussi.\n\n'
                  'Attention : \$X^4 + 1\$ est irréductible sur \$\\mathbb{Q}\$ mais PAS sur \$\\mathbb{F}_p\$ pour tout premier \$p\$. Ne confondez pas irréductibilité sur \$\\mathbb{Q}\$ et sur \$\\mathbb{Z}/p\\mathbb{Z}\$ !',
              points: 3,
              rapportJury:
                  'Question classique. Le jury attend le changement de variable et l\'application propre du critère d\'Eisenstein.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer le corps de décomposition de \$X^4 + 1\$ sur \$\\mathbb{Q}\$ '
                  'et calculer le degré de l\'extension.',
              indication:
                  'Les racines sont les racines 8-èmes primitives de l\'unité. '
                  'Montrer que \$\\mathbb{Q}(\\zeta_8) = \\mathbb{Q}(\\frac{1+i}{\\sqrt{2}})\$.',
              correction:
                  'Ce qu\'on nous demande : trouver le corps de décomposition \$K\$ de \$X^4 + 1\$ sur \$\\mathbb{Q}\$ et \$[K:\\mathbb{Q}]\$.\n\n'
                  'Rappel : le corps de décomposition est le plus petit corps contenant toutes les racines du polynôme.\n\n'
                  'Les racines de \$X^4 + 1 = 0\$ sont les \$X^4 = -1\$, soit les racines 8-èmes primitives de l\'unité : \$\\zeta_8^k\$ pour \$k \\in \\{1, 3, 5, 7\\}\$.\n'
                  'On a \$\\zeta_8 = e^{i\\pi/4} = \\frac{\\sqrt{2}}{2}(1 + i)\$. Donc \$K = \\mathbb{Q}(\\zeta_8) = \\mathbb{Q}(i, \\sqrt{2})\$.\n'
                  'Le degré : \$[K:\\mathbb{Q}] = [\\mathbb{Q}(i,\\sqrt{2}):\\mathbb{Q}(i)] \\cdot [\\mathbb{Q}(i):\\mathbb{Q}] = 2 \\times 2 = 4\$.\n'
                  'C\'est cohérent avec \$\\deg(X^4+1) = 4\$ et l\'irréductibilité sur \$\\mathbb{Q}\$.\n\n'
                  'Attention : le groupe de Galois \$\\mathrm{Gal}(K/\\mathbb{Q}) \\simeq (\\mathbb{Z}/8\\mathbb{Z})^\\times \\simeq \\mathbb{Z}/2\\mathbb{Z} \\times \\mathbb{Z}/2\\mathbb{Z}\$ (groupe de Klein, pas cyclique !).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'identification des racines comme racines de l\'unité et le calcul du degré de l\'extension.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$K\$ un corps et \$P \\in K[X]\$ de degré \$n\$. Montrer que \$P\$ admet '
                  'au plus \$n\$ racines dans \$K\$.',
              indication:
                  'Raisonner par récurrence en utilisant la division euclidienne '
                  'par \$(X - \\alpha)\$ quand \$\\alpha\$ est une racine.',
              correction:
                  'Ce qu\'on nous demande : prouver le résultat fondamental sur le nombre de racines d\'un polynôme.\n\n'
                  'Rappel : \$K[X]\$ est un anneau euclidien. Si \$\\alpha\$ est racine de \$P\$, alors \$(X - \\alpha)\$ divise \$P\$.\n\n'
                  'Récurrence sur \$n = \\deg(P)\$. Pour \$n = 0\$ : \$P\$ est constant non nul, 0 racine ✓.\n'
                  'Supposons le résultat vrai pour tout polynôme de degré \$< n\$. Si \$P\$ n\'a aucune racine, c\'est fini.\n'
                  'Sinon, soit \$\\alpha\$ une racine. Par division euclidienne : \$P = (X - \\alpha) Q\$ avec \$\\deg(Q) = n - 1\$.\n'
                  'Si \$\\beta \\neq \\alpha\$ est racine de \$P\$ : \$0 = (\\beta - \\alpha)Q(\\beta)\$. Comme \$\\beta - \\alpha \\neq 0\$ et \$K\$ est un corps (donc intègre), \$Q(\\beta) = 0\$.\n'
                  'Par hypothèse de récurrence, \$Q\$ a au plus \$n - 1\$ racines. Donc \$P\$ a au plus \$1 + (n-1) = n\$ racines.\n\n'
                  'Attention : ce résultat est FAUX dans un anneau non intègre ! Par exemple, dans \$\\mathbb{Z}/8\\mathbb{Z}\$, \$X^2 - 1\$ a 4 racines : \$1, 3, 5, 7\$.',
              points: 2,
              rapportJury:
                  'Le jury attend une récurrence propre et la mention de l\'intégrité du corps.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que le polynôme cyclotomique \$\\Phi_n(X)\$ est irréductible sur \$\\mathbb{Q}\$ '
                  'pour tout \$n \\geq 1\$.',
              indication:
                  'Utiliser le fait que \$\\Phi_n\$ divise \$X^n - 1\$ dans \$\\mathbb{Z}[X]\$ '
                  'et le critère de réduction modulo \$p\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'irréductibilité des polynômes cyclotomiques sur \$\\mathbb{Q}\$.\n\n'
                  'Rappel : \$\\Phi_n(X) = \\prod_{\\substack{1 \\leq k \\leq n \\\\ \\gcd(k,n)=1}} (X - \\zeta_n^k)\$ est le \$n\$-ième polynôme cyclotomique, de degré \$\\varphi(n)\$.\n\n'
                  'Supposons par l\'absurde que \$\\Phi_n = fg\$ avec \$f, g \\in \\mathbb{Z}[X]\$ non constants et \$f\$ le polynôme minimal de \$\\zeta_n\$ sur \$\\mathbb{Q}\$.\n'
                  'Soit \$p\$ un premier ne divisant pas \$n\$ et \$\\zeta_n^p\$ une racine primitive. On montre que \$\\zeta_n^p\$ est racine de \$f\$ :\n'
                  'Si \$\\zeta_n^p\$ est racine de \$g\$, alors \$\\zeta_n\$ est racine de \$g(X^p)\$, donc \$f | g(X^p)\$. Modulo \$p\$ : \$\\bar{f} | \\bar{g}^p\$.\n'
                  'Donc \$\\bar{f}\$ et \$\\bar{g}\$ ont une racine commune, ce qui implique que \$\\overline{X^n - 1}\$ a une racine multiple mod \$p\$.\n'
                  'Mais \$(X^n - 1)\' = nX^{n-1} \\neq 0 \\pmod{p}\$ (car \$p \\nmid n\$), contradiction.\n'
                  'Par récurrence, toutes les racines primitives sont racines de \$f\$, donc \$f = \\Phi_n\$ : le polynôme est irréductible.\n\n'
                  'Attention : la preuve utilise le lemme de Gauss et la réduction modulo \$p\$. C\'est une preuve non triviale – prenez le temps de la digérer.',
              points: 4,
              rapportJury:
                  'Preuve technique. Le jury apprécie une rédaction claire avec les arguments mod \$p\$ bien justifiés.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A \\in \\mathcal{M}_n(\\mathbb{Q})\$ vérifiant \$A^n = I_n\$. '
                  'Montrer que le polynôme minimal de \$A\$ divise \$X^n - 1\$ et que \$A\$ est diagonalisable sur \$\\mathbb{C}\$.',
              indication:
                  'Le polynôme \$X^n - 1\$ annule \$A\$. Puisque \$X^n - 1\$ est scindé '
                  'à racines simples dans \$\\mathbb{C}[X]\$, conclure.',
              correction:
                  'Ce qu\'on nous demande : étudier les matrices d\'ordre fini et leur réduction.\n\n'
                  'Rappel : le polynôme minimal \$\\pi_A\$ divise tout polynôme annulateur de \$A\$. \$A\$ est diagonalisable sur \$\\mathbb{C}\$ ssi \$\\pi_A\$ est scindé à racines simples dans \$\\mathbb{C}\$.\n\n'
                  '\$A^n = I_n\$ signifie que \$X^n - 1\$ annule \$A\$, donc \$\\pi_A | (X^n - 1)\$.\n'
                  'Dans \$\\mathbb{C}[X]\$, \$X^n - 1 = \\prod_{k=0}^{n-1}(X - \\zeta_n^k)\$ est scindé à racines simples (les racines \$n\$-ièmes de l\'unité sont distinctes).\n'
                  'Comme \$\\pi_A\$ divise un polynôme scindé à racines simples, \$\\pi_A\$ est lui-même scindé à racines simples.\n'
                  'Donc \$A\$ est diagonalisable sur \$\\mathbb{C}\$, et ses valeurs propres sont des racines de l\'unité.\n\n'
                  'Attention : \$A\$ n\'est pas forcément diagonalisable sur \$\\mathbb{Q}\$ ! Par exemple, la matrice compagnon de \$\\Phi_3 = X^2 + X + 1\$ vérifie \$A^3 = I\$ mais n\'est pas diag. sur \$\\mathbb{Q}\$.',
              points: 3,
              rapportJury:
                  'Question reliant polynômes annulateurs et réduction. Le jury attend la factorisation de \$X^n - 1\$ sur \$\\mathbb{C}\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que tout polynôme irréductible sur \$\\mathbb{Q}\$ ayant une racine dans '
                  'une extension galoisienne \$K/\\mathbb{Q}\$ est scindé dans \$K\$.',
              indication:
                  'Utiliser l\'action transitive du groupe de Galois sur les racines.',
              correction:
                  'Ce qu\'on nous demande : prouver que les irréductibles se scindent dans les extensions galoisiennes.\n\n'
                  'Rappel : \$K/\\mathbb{Q}\$ est galoisienne signifie que \$K\$ est le corps de décomposition d\'un polynôme séparable. Le groupe \$\\mathrm{Gal}(K/\\mathbb{Q})\$ agit transitivement sur les racines de chaque irréductible.\n\n'
                  'Soit \$P \\in \\mathbb{Q}[X]\$ irréductible avec une racine \$\\alpha \\in K\$. Soit \$\\beta\$ une autre racine de \$P\$ (dans une clôture algébrique).\n'
                  'Comme \$P\$ est irréductible, les extensions \$\\mathbb{Q}(\\alpha)\$ et \$\\mathbb{Q}(\\beta)\$ sont isomorphes via un \$\\mathbb{Q}\$-isomorphisme envoyant \$\\alpha\$ sur \$\\beta\$.\n'
                  'L\'extension \$K/\\mathbb{Q}\$ étant galoisienne (donc normale), cet isomorphisme se prolonge en un automorphisme \$\\sigma \\in \\mathrm{Gal}(K/\\mathbb{Q})\$.\n'
                  'Donc \$\\beta = \\sigma(\\alpha) \\in K\$. Ceci étant vrai pour toute racine \$\\beta\$, \$P\$ est scindé dans \$K\$.\n\n'
                  'Attention : sans l\'hypothèse galoisienne, c\'est faux ! Par exemple, \$\\mathbb{Q}(\\sqrt[3]{2})\$ contient une racine de \$X^3 - 2\$ mais pas les deux autres (qui sont complexes).',
              points: 3,
              rapportJury:
                  'Le jury attend l\'argument de normalité et l\'utilisation du groupe de Galois.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Réduction et espaces vectoriels',
          introduction:
              'Cette partie explore la réduction des endomorphismes, les formes de Jordan '
              'et la dualité des espaces vectoriels.',
          bareme: 7,
          themes: ['Réduction', 'Formes de Jordan', 'Dualité'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$u \\in \\mathcal{L}(E)\$ un endomorphisme nilpotent d\'indice \$p\$ '
                  '(i.e. \$u^p = 0\$ et \$u^{p-1} \\neq 0\$). Montrer que le polynôme minimal de \$u\$ est \$X^p\$.',
              indication:
                  'Montrer que \$X^p\$ annule \$u\$ et qu\'aucun polynôme de degré inférieur ne l\'annule.',
              correction:
                  'Ce qu\'on nous demande : déterminer le polynôme minimal d\'un endomorphisme nilpotent d\'indice \$p\$.\n\n'
                  'Rappel : le polynôme minimal \$\\pi_u\$ est le polynôme unitaire de plus petit degré annulant \$u\$. Il divise tout polynôme annulateur.\n\n'
                  '\$u^p = 0\$ signifie que \$X^p\$ annule \$u\$, donc \$\\pi_u | X^p\$. Les seuls diviseurs unitaires de \$X^p\$ sont \$X^k\$ pour \$0 \\leq k \\leq p\$.\n'
                  'Si \$\\pi_u = X^k\$ avec \$k < p\$, alors \$u^k = 0\$, ce qui contredit \$u^{p-1} \\neq 0\$ (car \$k \\leq p-1\$ impliquerait \$u^{p-1} = 0\$).\n'
                  'Donc \$\\pi_u = X^p\$.\n'
                  'Conséquence : la seule valeur propre de \$u\$ est \$0\$, et le polynôme caractéristique est \$\\chi_u = X^n\$ (Cayley-Hamilton).\n\n'
                  'Attention : l\'indice de nilpotence vérifie \$p \\leq n = \\dim(E)\$. En dimension \$n\$, l\'indice maximal est atteint par la matrice de Jordan nilpotente \$J_n(0)\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la distinction claire entre indice de nilpotence et polynôme minimal.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer la forme de Jordan de la matrice '
                  '\$A = \\begin{pmatrix} 2 & 1 & 0 \\\\ 0 & 2 & 1 \\\\ 0 & 0 & 2 \\end{pmatrix}\$.',
              indication:
                  'Calculer \$\\chi_A\$, le polynôme minimal, et les dimensions '
                  'des noyaux itérés \$\\ker((A - 2I)^k)\$.',
              correction:
                  'Ce qu\'on nous demande : trouver la forme de Jordan de la matrice \$A\$.\n\n'
                  'Rappel : la forme de Jordan est la matrice diagonale par blocs \$J = \\text{diag}(J_{n_1}(\\lambda_1), \\ldots)\$ où \$J_k(\\lambda)\$ est le bloc de Jordan de taille \$k\$.\n\n'
                  '\$A - 2I = \\begin{pmatrix} 0 & 1 & 0 \\\\ 0 & 0 & 1 \\\\ 0 & 0 & 0 \\end{pmatrix}\$. Donc \$\\chi_A = (X-2)^3\$ et la seule valeur propre est \$\\lambda = 2\$.\n'
                  '\$\\ker(A - 2I) = \\text{Vect}(e_1)\$ de dimension 1. Donc il y a un seul bloc de Jordan.\n'
                  '\$(A - 2I)^2 = \\begin{pmatrix} 0 & 0 & 1 \\\\ 0 & 0 & 0 \\\\ 0 & 0 & 0 \\end{pmatrix}\$, de rang 1, et \$(A - 2I)^3 = 0\$.\n'
                  'Les dimensions des noyaux itérés sont \$1, 2, 3\$ : cela confirme un unique bloc \$J_3(2)\$.\n'
                  'La forme de Jordan est \$A\$ elle-même : \$J = J_3(2) = \\begin{pmatrix} 2 & 1 & 0 \\\\ 0 & 2 & 1 \\\\ 0 & 0 & 2 \\end{pmatrix}\$.\n\n'
                  'Attention : la matrice \$A\$ est DÉJÀ sous forme de Jordan ! Ne perdez pas de temps à chercher une matrice de passage quand c\'est le cas.',
              points: 3,
              rapportJury:
                  'Le jury attend les noyaux itérés pour justifier la structure des blocs.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le théorème de décomposition de Dunford '
                  '(décomposition additive).',
              indication:
                  'Utiliser le lemme des noyaux pour décomposer \$u\$ en partie '
                  'diagonalisable \$d\$ et partie nilpotente \$n\$, avec \$dn = nd\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que tout endomorphisme se décompose en somme \$u = d + n\$ avec \$d\$ diag., \$n\$ nilp. et \$dn = nd\$.\n\n'
                  'Rappel : si \$\\chi_u = \\prod (X - \\lambda_i)^{m_i}\$ est scindé, le lemme des noyaux donne \$E = \\bigoplus \\ker(u - \\lambda_i \\text{Id})^{m_i}\$.\n\n'
                  'Sur chaque \$E_i = \\ker(u - \\lambda_i \\text{Id})^{m_i}\$, on pose \$d|_{E_i} = \\lambda_i \\text{Id}_{E_i}\$ et \$n|_{E_i} = u|_{E_i} - \\lambda_i \\text{Id}_{E_i}\$.\n'
                  'Alors \$u = d + n\$ sur \$E\$, avec \$d\$ diagonalisable (ses valeurs propres sont les \$\\lambda_i\$ sur les \$E_i\$).\n'
                  '\$n\$ est nilpotent : sur chaque \$E_i\$, \$(u - \\lambda_i \\text{Id})^{m_i} = 0\$ par définition.\n'
                  '\$dn = nd\$ car sur chaque \$E_i\$, \$d = \\lambda_i \\text{Id}\$ commute avec tout.\n'
                  'Unicité : si \$u = d\' + n\'\$ est une autre décomposition avec \$d\'n\' = n\'d\'\$, alors \$d\$ et \$d\'\$ commutent (car \$d - d\' = n\' - n\$ est nilpotent et diag. = 0).\n\n'
                  'Attention : cette décomposition n\'existe que si \$\\chi_u\$ est scindé (toujours vrai sur \$\\mathbb{C}\$, pas toujours sur \$\\mathbb{R}\$).',
              points: 4,
              rapportJury:
                  'Le jury valorise une preuve utilisant le lemme des noyaux et la vérification de la commutativité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$E\$ un espace vectoriel de dimension finie et \$E^*\$ son dual. '
                  'Montrer que \$\\dim(E^*) = \\dim(E)\$ et construire un isomorphisme explicite.',
              indication:
                  'Associer à chaque base \$(e_i)\$ de \$E\$ la base duale \$(e_i^*)\$ de \$E^*\$ '
                  'définie par \$e_i^*(e_j) = \\delta_{ij}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que le dual a la même dimension et exhiber un isomorphisme.\n\n'
                  'Rappel : \$E^* = \\mathcal{L}(E, K)\$ est l\'espace des formes linéaires sur \$E\$.\n\n'
                  'Soit \$(e_1, \\ldots, e_n)\$ une base de \$E\$. On définit \$e_i^* \\in E^*\$ par \$e_i^*(e_j) = \\delta_{ij}\$ (symbole de Kronecker).\n'
                  'La famille \$(e_i^*)\$ est libre : si \$\\sum \\alpha_i e_i^* = 0\$, évaluer en \$e_j\$ donne \$\\alpha_j = 0\$.\n'
                  'Elle est génératrice : pour \$\\varphi \\in E^*\$, on a \$\\varphi = \\sum_{i=1}^n \\varphi(e_i) e_i^*\$ (vérifier en évaluant sur chaque \$e_j\$).\n'
                  'Donc \$(e_i^*)\$ est une base de \$E^*\$ et \$\\dim(E^*) = n = \\dim(E)\$.\n'
                  'L\'application \$\\Phi : E \\to E^*\$ définie par \$\\Phi(e_i) = e_i^*\$ est un isomorphisme (bijection linéaire entre bases), mais il dépend du choix de la base.\n\n'
                  'Attention : l\'isomorphisme \$E \\simeq E^*\$ n\'est PAS canonique (il dépend de la base). En revanche, \$E \\simeq E^{**}\$ est canonique via \$x \\mapsto \\mathrm{ev}_x\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la construction explicite de la base duale et la remarque sur le caractère non canonique.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$F\$ un sous-espace de \$E\$. On note \$F^0 = \\{\\varphi \\in E^* : '
                  '\\varphi|_F = 0\\}\$ l\'annulateur de \$F\$. Montrer que \$\\dim(F^0) = \\dim(E) - \\dim(F)\$.',
              indication:
                  'Compléter une base de \$F\$ en une base de \$E\$ et utiliser la base duale.',
              correction:
                  'Ce qu\'on nous demande : calculer la dimension de l\'annulateur d\'un sous-espace.\n\n'
                  'Rappel : \$F^0 = \\{\\varphi \\in E^* : \\forall x \\in F,\\, \\varphi(x) = 0\\}\$ est un sous-espace de \$E^*\$.\n\n'
                  'Soit \$(e_1, \\ldots, e_r)\$ une base de \$F\$ complétée en \$(e_1, \\ldots, e_n)\$ base de \$E\$. Soit \$(e_1^*, \\ldots, e_n^*)\$ la base duale.\n'
                  'Alors \$\\varphi \\in F^0\$ ssi \$\\varphi(e_j) = 0\$ pour \$j = 1, \\ldots, r\$.\n'
                  'En écrivant \$\\varphi = \\sum \\alpha_i e_i^*\$, cela donne \$\\alpha_1 = \\cdots = \\alpha_r = 0\$.\n'
                  'Donc \$F^0 = \\text{Vect}(e_{r+1}^*, \\ldots, e_n^*)\$ et \$\\dim(F^0) = n - r = \\dim(E) - \\dim(F)\$.\n\n'
                  'Attention : on a aussi \$(F^0)^0 = F\$ (via l\'identification \$E \\simeq E^{**}\$). C\'est la bidualité, un outil puissant en algèbre linéaire.',
              points: 3,
              rapportJury:
                  'Le jury attend une preuve via la base duale. Les candidats qui utilisent le théorème du rang obtiennent aussi les points.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Géométrie et topologie algébrique',
          introduction:
              'Cette partie porte sur la géométrie projective, les surfaces quadriques '
              'et des éléments de topologie algébrique.',
          bareme: 6,
          themes: ['Géométrie projective', 'Quadriques', 'Topologie'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Définir l\'espace projectif \$\\mathbb{P}^n(K)\$ et montrer que deux droites distinctes '
                  'de \$\\mathbb{P}^2(K)\$ se coupent toujours en exactement un point.',
              indication:
                  'Utiliser la dualité projective : une droite de \$\\mathbb{P}^2\$ '
                  'est le noyau d\'une forme linéaire non nulle.',
              correction:
                  'Ce qu\'on nous demande : définir l\'espace projectif et prouver l\'intersection des droites dans \$\\mathbb{P}^2\$.\n\n'
                  'Rappel : \$\\mathbb{P}^n(K) = (K^{n+1} \\setminus \\{0\\}) / \\sim\$ où \$x \\sim y\$ ssi \$\\exists \\lambda \\neq 0, y = \\lambda x\$. Les points sont des droites vectorielles de \$K^{n+1}\$.\n\n'
                  'Une droite projective de \$\\mathbb{P}^2\$ correspond à un plan vectoriel \$H\$ de \$K^3\$, défini par une forme linéaire : \$H = \\ker(\\varphi)\$ avec \$\\varphi \\neq 0\$.\n'
                  'Soient \$D_1 = \\ker(\\varphi_1)\$ et \$D_2 = \\ker(\\varphi_2)\$ deux droites distinctes (donc \$\\varphi_1\$ et \$\\varphi_2\$ non proportionnelles).\n'
                  '\$D_1 \\cap D_2 = \\ker(\\varphi_1) \\cap \\ker(\\varphi_2)\$. Comme \$\\varphi_1, \\varphi_2\$ sont linéairement indépendantes, \$\\dim(\\ker(\\varphi_1) \\cap \\ker(\\varphi_2)) = 3 - 2 = 1\$.\n'
                  'Cette droite vectorielle de \$K^3\$ définit exactement un point de \$\\mathbb{P}^2\$.\n\n'
                  'Attention : c\'est l\'avantage majeur du projectif sur l\'affine : dans \$\\mathbb{P}^2\$, deux droites se coupent TOUJOURS (pas de parallèles !). Les droites parallèles de l\'affine se coupent « à l\'infini » dans le projectif.',
              points: 4,
              rapportJury:
                  'Le jury attend la formule des dimensions pour justifier l\'intersection en un unique point.',
            ),
            QuestionAnnale(
              enonce:
                  'Classifier les coniques de \$\\mathbb{P}^2(\\mathbb{R})\$ à isomorphisme projectif près.',
              indication:
                  'Utiliser la signature de la forme quadratique associée. '
                  'Réduire par le théorème d\'inertie de Sylvester.',
              correction:
                  'Ce qu\'on nous demande : donner la classification projective des coniques réelles.\n\n'
                  'Rappel : une conique de \$\\mathbb{P}^2(\\mathbb{R})\$ est définie par \$\\{[x:y:z] : Q(x,y,z) = 0\\}\$ où \$Q\$ est une forme quadratique de rang \$\\leq 3\$.\n\n'
                  'Par le théorème d\'inertie de Sylvester, \$Q\$ est équivalente à \$\\epsilon_1 X^2 + \\epsilon_2 Y^2 + \\epsilon_3 Z^2\$ avec \$\\epsilon_i \\in \\{-1, 0, 1\\}\$.\n'
                  'Les cas (à équivalence projective près) sont :\n'
                  '- Rang 3, signature \$(3,0)\$ ou \$(0,3)\$ : \$X^2 + Y^2 + Z^2 = 0\$, conique vide (pas de solution réelle).\n'
                  '- Rang 3, signature \$(2,1)\$ ou \$(1,2)\$ : \$X^2 + Y^2 - Z^2 = 0\$, conique lisse (ellipse/hyperbole/parabole en affine).\n'
                  '- Rang 2, signature \$(2,0)\$ : \$X^2 + Y^2 = 0\$, un point (le point \$[0:0:1]\$).\n'
                  '- Rang 2, signature \$(1,1)\$ : \$X^2 - Y^2 = 0\$, deux droites sécantes.\n'
                  '- Rang 1 : \$X^2 = 0\$, une droite double.\n\n'
                  'Attention : en projectif, il n\'y a PAS de distinction entre ellipse, hyperbole et parabole ! Elles sont toutes projectivement équivalentes (toutes lisses de rang 3).',
              points: 4,
              rapportJury:
                  'Le jury attend la classification complète par rang et signature, avec mention de l\'inertie de Sylvester.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que le plan projectif réel \$\\mathbb{P}^2(\\mathbb{R})\$ est une variété '
                  'compacte non orientable.',
              indication:
                  '\$\\mathbb{P}^2(\\mathbb{R})\$ est le quotient de \$S^2\$ par l\'antipodie. '
                  'Utiliser le ruban de Möbius.',
              correction:
                  'Ce qu\'on nous demande : montrer la compacité et la non-orientabilité de \$\\mathbb{P}^2(\\mathbb{R})\$.\n\n'
                  'Rappel : \$\\mathbb{P}^2(\\mathbb{R}) = S^2 / \\{\\pm 1\\}\$ où l\'on identifie chaque point de la sphère avec son antipode.\n\n'
                  'Compacité : \$S^2\$ est compact (fermé borné de \$\\mathbb{R}^3\$) et \$\\mathbb{P}^2(\\mathbb{R})\$ est l\'image de \$S^2\$ par la projection canonique \$\\pi : S^2 \\to S^2/\\{\\pm 1\\}\$, qui est continue. L\'image continue d\'un compact est compacte.\n'
                  'Non-orientabilité : \$\\mathbb{P}^2(\\mathbb{R})\$ contient un ruban de Möbius. Considérons l\'équateur de \$S^2\$ : l\'identification antipodale sur l\'équateur donne un cercle, et un voisinage tubulaire de ce cercle dans \$\\mathbb{P}^2\$ est un ruban de Möbius (non orientable).\n'
                  'Une variété contenant un ruban de Möbius ne peut être orientable (le transport du repère local le long du ruban inverse l\'orientation).\n\n'
                  'Attention : \$\\mathbb{P}^2(\\mathbb{R})\$ n\'est pas plongeable dans \$\\mathbb{R}^3\$ (il faut au moins \$\\mathbb{R}^4\$). Ne confondez pas avec la bouteille de Klein !',
              points: 4,
              rapportJury:
                  'Le jury attend l\'argument de compacité par quotient et la non-orientabilité via le ruban de Möbius.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer le groupe fondamental du cercle \$\\pi_1(S^1)\$ en utilisant '
                  'le revêtement \$\\mathbb{R} \\to S^1\$, \$t \\mapsto e^{2i\\pi t}\$.',
              indication:
                  'Utiliser le relèvement des lacets au revêtement universel \$\\mathbb{R}\$.',
              correction:
                  'Ce qu\'on nous demande : montrer que \$\\pi_1(S^1) \\simeq \\mathbb{Z}\$.\n\n'
                  'Rappel : \$\\pi_1(X, x_0)\$ est l\'ensemble des classes d\'homotopie de lacets basés en \$x_0\$. Le revêtement \$p : \\mathbb{R} \\to S^1\$ défini par \$p(t) = e^{2i\\pi t}\$ est le revêtement universel.\n\n'
                  'Tout lacet \$\\gamma : [0,1] \\to S^1\$ basé en \$1\$ se relève de façon unique en un chemin \$\\tilde{\\gamma} : [0,1] \\to \\mathbb{R}\$ avec \$\\tilde{\\gamma}(0) = 0\$.\n'
                  'Comme \$\\gamma(1) = 1 = p(n)\$ pour \$n \\in \\mathbb{Z}\$, on a \$\\tilde{\\gamma}(1) = n \\in \\mathbb{Z}\$. Cet entier \$n\$ est le degré du lacet (nombre de tours).\n'
                  'L\'application degré \$\\deg : \\pi_1(S^1, 1) \\to \\mathbb{Z}\$ est un morphisme de groupes (le degré est additif par concaténation).\n'
                  'C\'est un isomorphisme : injectif (deux lacets de même degré sont homotopes via l\'homotopie des relèvements dans \$\\mathbb{R}\$, qui est contractile) et surjectif (le lacet \$t \\mapsto e^{2in\\pi t}\$ a degré \$n\$).\n\n'
                  'Attention : ce calcul est la base de nombreux résultats (théorème de Brouwer, théorème du point fixe, etc.). Maîtrisez-le parfaitement !',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve via le relèvement des lacets et la justification de la bijectivité.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer le théorème du point fixe de Brouwer en dimension 2 '
                  'et esquisser une démonstration utilisant le groupe fondamental.',
              indication:
                  'Supposer qu\'il n\'y a pas de point fixe et construire une rétraction '
                  '\$D^2 \\to S^1\$, ce qui contredit \$\\pi_1(D^2) = 0\$ et \$\\pi_1(S^1) = \\mathbb{Z}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème de Brouwer en dimension 2.\n\n'
                  'Rappel (énoncé) : toute application continue \$f : D^2 \\to D^2\$ (où \$D^2\$ est le disque fermé) admet un point fixe.\n\n'
                  'Preuve par l\'absurde : supposons que \$f(x) \\neq x\$ pour tout \$x \\in D^2\$.\n'
                  'On définit \$r : D^2 \\to S^1\$ en traçant la demi-droite de \$f(x)\$ vers \$x\$ et en prenant son intersection avec \$S^1\$.\n'
                  'Cette application \$r\$ est continue (car \$f(x) \\neq x\$) et vérifie \$r(x) = x\$ pour tout \$x \\in S^1\$ (rétraction).\n'
                  'En passant aux groupes fondamentaux : \$r_* \\circ i_* = \\text{Id}_{\\pi_1(S^1)}\$ où \$i : S^1 \\hookrightarrow D^2\$ est l\'inclusion.\n'
                  'Mais \$i_* : \\pi_1(S^1) \\to \\pi_1(D^2)\$ va de \$\\mathbb{Z}\$ vers \$\\{0\\}\$ (car \$D^2\$ est contractile), donc \$i_* = 0\$.\n'
                  'On aurait \$\\text{Id}_{\\mathbb{Z}} = r_* \\circ 0 = 0\$, contradiction ! Donc \$f\$ a un point fixe.\n\n'
                  'Attention : en dimension supérieure, la preuve utilise l\'homologie (car \$\\pi_1(S^n) = 0\$ pour \$n \\geq 2\$). La preuve via \$\\pi_1\$ ne marche qu\'en dimension 2.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par rétraction et l\'argument de groupes fondamentaux.',
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EXTERNE 2023 – Analyse et probabilités
  // ═══════════════════════════════════════════════════════════════════
  static Annale _ext2023AP() {
    return Annale(
      id: 'ped_ext_2023_ap',
      annee: 2023,
      session: 'externe',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation externe 2023 – Analyse et probabilités (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve d\'analyse et probabilités 2023. '
          'Analyse complexe, séries, intégration, mesure, probabilités et statistiques.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Analyse complexe', 'Séries', 'Intégration', 'Probabilités'],
      urlSujet: 'https://agreg.org/data/uploads/sujets/AP/ap23.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Fonctions holomorphes', 'Séries entières', 'Mesure de Lebesgue', 'Convergence en loi', 'Estimateurs'],
      rapportGlobal:
          'Cette épreuve 2023 mêle analyse complexe, théorie de la mesure et probabilités. '
          'Notre correction pédagogique détaille chaque étape pour vous guider sereinement. '
          'Chaque question est une occasion d\'apprendre, pas un piège !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Analyse complexe et séries',
          introduction:
              'Cette partie porte sur les fonctions holomorphes, les séries entières, '
              'les résidus et le prolongement analytique.',
          bareme: 7,
          themes: ['Fonctions holomorphes', 'Séries entières', 'Résidus'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$f : \\mathbb{C} \\to \\mathbb{C}\$ une fonction entière bornée. '
                  'Montrer que \$f\$ est constante.',
              indication:
                  'C\'est le théorème de Liouville. Utiliser l\'inégalité de Cauchy '
                  'sur des cercles de rayon arbitrairement grand.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème de Liouville – une fonction entière bornée est constante.\n\n'
                  'Rappel : une fonction entière est holomorphe sur tout \$\\mathbb{C}\$. L\'inégalité de Cauchy donne \$|f^{(n)}(a)| \\leq \\frac{n! M_R}{R^n}\$ où \$M_R = \\sup_{|z-a|=R} |f(z)|\$.\n\n'
                  'Soit \$M = \\sup_{z \\in \\mathbb{C}} |f(z)| < +\\infty\$ (par hypothèse). Pour tout \$a \\in \\mathbb{C}\$ et tout \$R > 0\$ :\n'
                  '\$|f\'(a)| \\leq \\frac{M}{R}\$.\n'
                  'En faisant \$R \\to +\\infty\$ : \$|f\'(a)| = 0\$ pour tout \$a\$.\n'
                  'Donc \$f\' = 0\$ sur \$\\mathbb{C}\$, ce qui implique que \$f\$ est constante (le domaine \$\\mathbb{C}\$ est connexe).\n\n'
                  'Attention : la connexité du domaine est essentielle. Le théorème est FAUX pour les fonctions réelles bornées et dérivables (ex : \$\\arctan\$). C\'est la puissance de l\'analyse complexe !',
              points: 3,
              rapportJury:
                  'Question de cours classique. Le jury attend l\'inégalité de Cauchy correctement appliquée.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer le rayon de convergence de la série entière '
                  '\$\\sum_{n \\geq 0} \\frac{n!}{n^n} z^n\$.',
              indication:
                  'Utiliser la formule de d\'Alembert (rapport des termes consécutifs) '
                  'et la formule de Stirling.',
              correction:
                  'Ce qu\'on nous demande : calculer le rayon de convergence \$R\$ de la série \$\\sum \\frac{n!}{n^n} z^n\$.\n\n'
                  'Rappel : par la règle de d\'Alembert, \$\\frac{1}{R} = \\lim \\frac{a_{n+1}}{a_n}\$ si la limite existe, où \$a_n = \\frac{n!}{n^n}\$.\n\n'
                  '\$\\frac{a_{n+1}}{a_n} = \\frac{(n+1)!}{(n+1)^{n+1}} \\cdot \\frac{n^n}{n!} = \\frac{n^n}{(n+1)^n} = \\left(\\frac{n}{n+1}\\right)^n = \\left(1 - \\frac{1}{n+1}\\right)^n\$.\n'
                  'Quand \$n \\to \\infty\$ : \$\\left(1 - \\frac{1}{n+1}\\right)^n \\to e^{-1}\$.\n'
                  'Donc \$\\frac{1}{R} = e^{-1}\$, soit \$R = e\$.\n'
                  'Alternativement, par la formule de Stirling : \$n! \\sim \\sqrt{2\\pi n} (n/e)^n\$, donc \$a_n \\sim \\frac{\\sqrt{2\\pi n}}{e^n}\$ et \$(a_n)^{1/n} \\to 1/e\$.\n\n'
                  'Attention : sur le cercle \$|z| = e\$, l\'étude de la convergence est plus délicate et nécessite un raffinement de Stirling.',
              points: 3,
              rapportJury:
                  'Le jury accepte la règle de d\'Alembert ou la formule d\'Hadamard. La formule de Stirling est valorisée.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer \$\\int_0^{+\\infty} \\frac{\\cos(x)}{x^2 + 1} dx\$ '
                  'à l\'aide du théorème des résidus.',
              indication:
                  'Considérer \$\\int_\\gamma \\frac{e^{iz}}{z^2+1} dz\$ sur un contour '
                  'semi-circulaire dans le demi-plan supérieur.',
              correction:
                  'Ce qu\'on nous demande : calculer une intégrale réelle par la méthode des résidus.\n\n'
                  'Rappel : le théorème des résidus donne \$\\oint_\\gamma f(z)dz = 2\\pi i \\sum \\text{Res}(f, z_k)\$ pour les pôles à l\'intérieur du contour.\n\n'
                  'On considère \$f(z) = \\frac{e^{iz}}{z^2+1}\$ et le contour \$\\gamma = [-R, R] \\cup C_R^+\$ (segment + demi-cercle supérieur).\n'
                  'Pôles de \$f\$ : \$z = \\pm i\$. Seul \$z = i\$ est dans le demi-plan supérieur.\n'
                  '\$\\text{Res}(f, i) = \\frac{e^{i \\cdot i}}{2i} = \\frac{e^{-1}}{2i}\$.\n'
                  'Par le théorème des résidus : \$\\int_\\gamma f = 2\\pi i \\cdot \\frac{e^{-1}}{2i} = \\frac{\\pi}{e}\$.\n'
                  'Sur \$C_R^+\$ : par le lemme de Jordan, \$\\int_{C_R^+} f \\to 0\$ quand \$R \\to \\infty\$.\n'
                  'Donc \$\\int_{-\\infty}^{+\\infty} \\frac{e^{ix}}{x^2+1} dx = \\frac{\\pi}{e}\$. En prenant la partie réelle : \$\\int_{-\\infty}^{+\\infty} \\frac{\\cos(x)}{x^2+1} dx = \\frac{\\pi}{e}\$.\n'
                  'Par parité : \$\\int_0^{+\\infty} \\frac{\\cos(x)}{x^2+1} dx = \\frac{\\pi}{2e}\$.\n\n'
                  'Attention : on utilise \$e^{iz}\$ (pas \$\\cos(z)\$) car \$|e^{iz}|\$ est bornée dans le demi-plan supérieur, ce qui permet d\'appliquer le lemme de Jordan.',
              points: 4,
              rapportJury:
                  'Le jury attend le choix du bon contour, le calcul du résidu et l\'application du lemme de Jordan.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f(z) = \\sum_{n=0}^\\infty a_n z^n\$ une série entière de rayon \$R > 0\$. '
                  'Montrer que \$f\$ est holomorphe sur \$D(0, R)\$ et que \$f\'(z) = \\sum_{n=1}^\\infty n a_n z^{n-1}\$.',
              indication:
                  'Montrer que la série dérivée a le même rayon de convergence '
                  'et que \$f\$ est dérivable terme à terme.',
              correction:
                  'Ce qu\'on nous demande : prouver qu\'une série entière est holomorphe et dérivable terme à terme.\n\n'
                  'Rappel : le rayon de convergence vérifie \$\\frac{1}{R} = \\limsup |a_n|^{1/n}\$ (Hadamard). La série converge absolument pour \$|z| < R\$.\n\n'
                  'Rayon de la série dérivée : \$\\limsup (n|a_n|)^{1/n} = \\limsup n^{1/n} \\cdot |a_n|^{1/n} = 1 \\cdot \\frac{1}{R} = \\frac{1}{R}\$.\n'
                  'Donc la série \$\\sum n a_n z^{n-1}\$ a le même rayon \$R\$.\n'
                  'Dérivabilité : pour \$|z| < r < R\$, on écrit \$\\frac{f(z+h) - f(z)}{h} - \\sum n a_n z^{n-1} = \\sum a_n \\left(\\frac{(z+h)^n - z^n}{h} - nz^{n-1}\\right)\$.\n'
                  'Chaque terme est majoré par \$|a_n| \\cdot \\frac{n(n-1)}{2} r^{n-2} |h|\$ (inégalité de Taylor), et la série \$\\sum |a_n| n^2 r^{n-2}\$ converge.\n'
                  'Par convergence dominée (version séries) : le quotient tend vers 0, donc \$f\'(z) = \\sum n a_n z^{n-1}\$.\n\n'
                  'Attention : par récurrence, \$f\$ est infiniment dérivable et \$a_n = \\frac{f^{(n)}(0)}{n!}\$. C\'est une propriété fondamentale des fonctions holomorphes.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve du même rayon et l\'argument de dérivation terme à terme.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le principe des zéros isolés pour les fonctions holomorphes.',
              indication:
                  'Si \$f\$ est holomorphe non nulle sur un ouvert connexe, '
                  'l\'ensemble \$\\{z : f(z) = 0\\}\$ n\'a pas de point d\'accumulation.',
              correction:
                  'Ce qu\'on nous demande : prouver que les zéros d\'une fonction holomorphe non nulle sont isolés.\n\n'
                  'Rappel : un point \$a\$ est un zéro isolé de \$f\$ s\'il existe \$r > 0\$ tel que \$f(z) \\neq 0\$ pour \$0 < |z - a| < r\$.\n\n'
                  'Soit \$f\$ holomorphe sur un ouvert connexe \$\\Omega\$, non identiquement nulle, et \$f(a) = 0\$.\n'
                  'Comme \$f \\not\\equiv 0\$, il existe \$k \\geq 1\$ tel que \$f^{(k)}(a) \\neq 0\$ (sinon \$f \\equiv 0\$ par le développement en série entière).\n'
                  'Prenons le plus petit tel \$k\$ : \$f(z) = (z-a)^k g(z)\$ avec \$g\$ holomorphe et \$g(a) = \\frac{f^{(k)}(a)}{k!} \\neq 0\$.\n'
                  'Par continuité de \$g\$, il existe \$r > 0\$ tel que \$g(z) \\neq 0\$ pour \$|z - a| < r\$.\n'
                  'Donc \$f(z) = (z-a)^k g(z) \\neq 0\$ pour \$0 < |z-a| < r\$ : le zéro \$a\$ est isolé.\n\n'
                  'Attention : ce principe implique le prolongement analytique : si deux fonctions holomorphes coïncident sur un ensemble ayant un point d\'accumulation, elles sont identiques. C\'est la rigidité de l\'analyse complexe !',
              points: 3,
              rapportJury:
                  'Le jury attend la factorisation \$f = (z-a)^k g\$ et l\'argument de continuité.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Intégration et mesure',
          introduction:
              'Cette partie explore la théorie de la mesure de Lebesgue, '
              'les théorèmes de convergence et les espaces \$L^p\$.',
          bareme: 7,
          themes: ['Mesure de Lebesgue', 'Convergence dominée', 'Espaces Lp'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le théorème de convergence dominée de Lebesgue.',
              indication:
                  'Utiliser le lemme de Fatou appliqué à \$g + f_n\$ et \$g - f_n\$ '
                  'où \$|f_n| \\leq g\$ intégrable.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème de convergence dominée (TCD).\n\n'
                  'Rappel (énoncé) : si \$(f_n)\$ converge p.p. vers \$f\$, \$|f_n| \\leq g\$ p.p. avec \$g \\in L^1\$, alors \$f \\in L^1\$ et \$\\int f_n \\to \\int f\$.\n\n'
                  '\$f\$ est mesurable (limite p.p. de fonctions mesurables) et \$|f| \\leq g\$ p.p., donc \$f \\in L^1\$.\n'
                  'Astuce : appliquer le lemme de Fatou à \$g + f_n \\geq 0\$ et \$g - f_n \\geq 0\$.\n'
                  'Par Fatou : \$\\int (g + f) \\leq \\liminf \\int (g + f_n)\$, soit \$\\int f \\leq \\liminf \\int f_n\$.\n'
                  'De même : \$\\int (g - f) \\leq \\liminf \\int (g - f_n)\$, soit \$-\\int f \\leq -\\limsup \\int f_n\$, i.e. \$\\limsup \\int f_n \\leq \\int f\$.\n'
                  'En combinant : \$\\int f \\leq \\liminf \\int f_n \\leq \\limsup \\int f_n \\leq \\int f\$, donc \$\\lim \\int f_n = \\int f\$.\n\n'
                  'Attention : l\'hypothèse de domination \$|f_n| \\leq g \\in L^1\$ est cruciale. Sans elle, la conclusion peut être fausse (ex : \$f_n = n \\cdot \\mathbf{1}_{[0, 1/n]}\$ converge vers 0 mais \$\\int f_n = 1\$ pour tout \$n\$).',
              points: 4,
              rapportJury:
                  'Le jury attend l\'application du lemme de Fatou des deux côtés et un contre-exemple sans domination.',
            ),
            QuestionAnnale(
              enonce:
                  'Calculer \$\\lim_{n \\to \\infty} \\int_0^n \\left(1 - \\frac{x}{n}\\right)^n e^{x/2} dx\$.',
              indication:
                  'Montrer que l\'intégrande converge vers \$e^{-x/2}\$ et trouver '
                  'une fonction dominante intégrable.',
              correction:
                  'Ce qu\'on nous demande : calculer une limite d\'intégrale en utilisant la convergence dominée.\n\n'
                  'Rappel : pour intervertir limite et intégrale, il faut une domination par une fonction \$L^1\$.\n\n'
                  'Posons \$f_n(x) = \\left(1 - \\frac{x}{n}\\right)^n e^{x/2} \\mathbf{1}_{[0,n]}(x)\$.\n'
                  'Convergence simple : \$\\left(1 - \\frac{x}{n}\\right)^n \\to e^{-x}\$ pour tout \$x \\geq 0\$. Donc \$f_n(x) \\to e^{-x} \\cdot e^{x/2} = e^{-x/2}\$.\n'
                  'Domination : l\'inégalité classique \$\\left(1 - \\frac{x}{n}\\right)^n \\leq e^{-x}\$ (pour \$0 \\leq x \\leq n\$) donne \$|f_n(x)| \\leq e^{-x} \\cdot e^{x/2} = e^{-x/2}\$.\n'
                  'La fonction \$g(x) = e^{-x/2}\$ est intégrable sur \$[0, +\\infty[\$ : \$\\int_0^\\infty e^{-x/2} dx = 2\$.\n'
                  'Par le TCD : \$\\lim \\int_0^n f_n = \\int_0^\\infty e^{-x/2} dx = 2\$.\n\n'
                  'Attention : l\'inégalité \$(1 - x/n)^n \\leq e^{-x}\$ est fondamentale. Elle se démontre en prenant le logarithme et en utilisant \$\\ln(1-t) \\leq -t\$.',
              points: 3,
              rapportJury:
                  'Le jury attend la justification de la domination et l\'application correcte du TCD.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer l\'inégalité de Hölder : si \$f \\in L^p\$ et \$g \\in L^q\$ '
                  'avec \$\\frac{1}{p} + \\frac{1}{q} = 1\$, alors \$fg \\in L^1\$ '
                  'et \$\\|fg\\|_1 \\leq \\|f\\|_p \\|g\\|_q\$.',
              indication:
                  'Utiliser l\'inégalité de Young : \$ab \\leq \\frac{a^p}{p} + \\frac{b^q}{q}\$ '
                  'pour \$a, b \\geq 0\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'inégalité de Hölder, outil fondamental des espaces \$L^p\$.\n\n'
                  'Rappel : l\'inégalité de Young dit que pour \$a, b \\geq 0\$ et \$\\frac{1}{p} + \\frac{1}{q} = 1\$ : \$ab \\leq \\frac{a^p}{p} + \\frac{b^q}{q}\$.\n\n'
                  'Si \$\\|f\\|_p = 0\$ ou \$\\|g\\|_q = 0\$, c\'est trivial. Sinon, posons \$\\tilde{f} = f/\\|f\\|_p\$ et \$\\tilde{g} = g/\\|g\\|_q\$.\n'
                  'Par l\'inégalité de Young : \$|\\tilde{f}(x)| \\cdot |\\tilde{g}(x)| \\leq \\frac{|\\tilde{f}(x)|^p}{p} + \\frac{|\\tilde{g}(x)|^q}{q}\$.\n'
                  'En intégrant : \$\\int |\\tilde{f} \\tilde{g}| \\leq \\frac{1}{p}\\int |\\tilde{f}|^p + \\frac{1}{q}\\int |\\tilde{g}|^q = \\frac{1}{p} + \\frac{1}{q} = 1\$.\n'
                  'Donc \$\\frac{\\|fg\\|_1}{\\|f\\|_p \\|g\\|_q} \\leq 1\$, ce qui donne \$\\|fg\\|_1 \\leq \\|f\\|_p \\|g\\|_q\$.\n\n'
                  'Attention : le cas d\'égalité dans Hölder a lieu ssi \$|f|^p\$ et \$|g|^q\$ sont proportionnelles p.p. Pour \$p = q = 2\$, on retrouve Cauchy-Schwarz dans \$L^2\$.',
              points: 4,
              rapportJury:
                  'Le jury attend la normalisation et l\'application de l\'inégalité de Young.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que \$C_c^\\infty(\\mathbb{R})\$ (fonctions \$C^\\infty\$ à support compact) '
                  'est dense dans \$L^p(\\mathbb{R})\$ pour \$1 \\leq p < \\infty\$.',
              indication:
                  'Procéder en trois étapes : approcher par des fonctions bornées à support compact, '
                  'puis par des fonctions continues, puis par des fonctions lisses (régularisation).',
              correction:
                  'Ce qu\'on nous demande : prouver la densité des fonctions test dans \$L^p\$.\n\n'
                  'Rappel : \$C_c^\\infty(\\mathbb{R})\$ est l\'espace des fonctions infiniment dérivables nulles en dehors d\'un compact.\n\n'
                  'Étape 1 : toute \$f \\in L^p\$ est limite de fonctions étagées (par construction de l\'intégrale). Les étagées sont dans \$L^p\$ car de support fini.\n'
                  'Étape 2 : toute fonction étagée est limite dans \$L^p\$ de fonctions continues à support compact (approximation de \$\\mathbf{1}_{[a,b]}\$ par des fonctions trapézoïdales).\n'
                  'Étape 3 : régularisation. Soit \$\\rho_\\varepsilon\$ un noyau régularisant (\$\\rho \\in C_c^\\infty\$, \$\\int \\rho = 1\$, support dans \$[-\\varepsilon, \\varepsilon]\$).\n'
                  'Pour \$g\$ continue à support compact, \$g * \\rho_\\varepsilon \\in C_c^\\infty\$ et \$\\|g * \\rho_\\varepsilon - g\\|_p \\to 0\$ par convergence uniforme.\n'
                  'Par composition des trois étapes, \$C_c^\\infty\$ est dense dans \$L^p\$.\n\n'
                  'Attention : ceci est FAUX pour \$p = \\infty\$ ! Les fonctions continues ne sont pas denses dans \$L^\\infty\$ (la fonction de Heaviside ne peut être approchée uniformément par des fonctions continues).',
              points: 4,
              rapportJury:
                  'Le jury attend les trois étapes clairement identifiées et la régularisation par convolution.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que l\'espace \$L^2([0,1])\$ est séparable.',
              indication:
                  'Les polynômes à coefficients rationnels forment un ensemble dénombrable dense. '
                  'Utiliser le théorème d\'approximation de Weierstrass.',
              correction:
                  'Ce qu\'on nous demande : prouver que \$L^2([0,1])\$ admet un sous-ensemble dénombrable dense.\n\n'
                  'Rappel : un espace métrique est séparable s\'il contient un sous-ensemble dénombrable dense.\n\n'
                  'Soit \$D = \\mathbb{Q}[X]\$ l\'ensemble des polynômes à coefficients rationnels. C\'est dénombrable (\$\\mathbb{Q}[X] = \\bigcup_n \\mathbb{Q}^{n+1}\$, union dénombrable de dénombrables).\n'
                  'Par le théorème de Weierstrass, les polynômes sont denses dans \$C([0,1])\$ pour la norme \$\\|\\cdot\\|_\\infty\$.\n'
                  'Comme \$\\|f\\|_2 \\leq \\|f\\|_\\infty\$ sur \$[0,1]\$, les polynômes sont aussi denses dans \$C([0,1])\$ pour \$\\|\\cdot\\|_2\$.\n'
                  'Par densité de \$\\mathbb{Q}\$ dans \$\\mathbb{R}\$, les polynômes à coefficients rationnels approchent les polynômes réels.\n'
                  'Enfin, \$C([0,1])\$ est dense dans \$L^2([0,1])\$ (par le résultat de densité précédent).\n'
                  'Par transitivité : \$\\mathbb{Q}[X]\$ est dense dans \$L^2([0,1])\$, qui est donc séparable.\n\n'
                  'Attention : ceci garantit l\'existence d\'une base hilbertienne dénombrable (par Gram-Schmidt sur \$D\$). Par exemple, les polynômes de Legendre.',
              points: 3,
              rapportJury:
                  'Le jury attend la chaîne de densité : \$\\mathbb{Q}[X] \\subset C([0,1]) \\subset L^2([0,1])\$.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Probabilités et statistiques',
          introduction:
              'Cette partie porte sur les lois classiques, la convergence en loi, '
              'le théorème central limite et l\'estimation statistique.',
          bareme: 6,
          themes: ['Convergence en loi', 'Théorème central limite', 'Estimation'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Énoncer et démontrer le théorème central limite pour des variables i.i.d. '
                  'de variance finie.',
              indication:
                  'Utiliser les fonctions caractéristiques et le théorème de Lévy.',
              correction:
                  'Ce qu\'on nous demande : prouver le TCL – la somme renormalisée converge en loi vers la gaussienne.\n\n'
                  'Rappel (énoncé) : si \$(X_n)\$ sont i.i.d. avec \$E[X_1] = \\mu\$ et \$\\text{Var}(X_1) = \\sigma^2 < \\infty\$, alors \$S_n^* = \\frac{S_n - n\\mu}{\\sigma\\sqrt{n}} \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$.\n\n'
                  'On peut supposer \$\\mu = 0\$ et \$\\sigma = 1\$ (quitte à centrer et réduire). La fonction caractéristique de \$X_1\$ vérifie \$\\varphi(t) = 1 - \\frac{t^2}{2} + o(t^2)\$.\n'
                  'Celle de \$S_n^* = \\frac{X_1 + \\cdots + X_n}{\\sqrt{n}}\$ est \$\\varphi_{S_n^*}(t) = \\left(\\varphi\\left(\\frac{t}{\\sqrt{n}}\\right)\\right)^n\$.\n'
                  '\$\\varphi\\left(\\frac{t}{\\sqrt{n}}\\right) = 1 - \\frac{t^2}{2n} + o(1/n)\$, donc \$\\left(1 - \\frac{t^2}{2n} + o(1/n)\\right)^n \\to e^{-t^2/2}\$.\n'
                  'Or \$e^{-t^2/2}\$ est la fonction caractéristique de \$\\mathcal{N}(0,1)\$. Par le théorème de Lévy : \$S_n^* \\xrightarrow{\\mathcal{L}} \\mathcal{N}(0,1)\$.\n\n'
                  'Attention : le TCL nécessite \$\\sigma^2 < \\infty\$. Pour des lois à queue lourde (ex : Cauchy), la somme renormalisée ne converge PAS vers une gaussienne mais vers une loi stable.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve via les fonctions caractéristiques et le théorème de Lévy.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_1, \\ldots, X_n)\$ un échantillon i.i.d. de loi \$\\mathcal{N}(\\mu, \\sigma^2)\$. '
                  'Montrer que \$\\bar{X}_n = \\frac{1}{n}\\sum X_i\$ est un estimateur sans biais, '
                  'convergent et efficace de \$\\mu\$.',
              indication:
                  'Calculer biais, variance et vérifier la borne de Cramér-Rao.',
              correction:
                  'Ce qu\'on nous demande : vérifier les propriétés de la moyenne empirique comme estimateur de \$\\mu\$.\n\n'
                  'Rappel : un estimateur \$T\$ de \$\\theta\$ est sans biais si \$E[T] = \\theta\$, convergent si \$T \\xrightarrow{P} \\theta\$, et efficace s\'il atteint la borne de Cramér-Rao.\n\n'
                  'Sans biais : \$E[\\bar{X}_n] = \\frac{1}{n} \\sum E[X_i] = \\frac{n\\mu}{n} = \\mu\$ ✓.\n'
                  'Variance : \$\\text{Var}(\\bar{X}_n) = \\frac{1}{n^2} \\sum \\text{Var}(X_i) = \\frac{\\sigma^2}{n}\$ (par indépendance).\n'
                  'Convergence : \$\\text{Var}(\\bar{X}_n) = \\frac{\\sigma^2}{n} \\to 0\$, donc par Chebyshev : \$\\bar{X}_n \\xrightarrow{P} \\mu\$ ✓.\n'
                  'Efficacité : la borne de Cramér-Rao pour un estimateur sans biais de \$\\mu\$ est \$\\frac{1}{nI(\\mu)}\$ où \$I(\\mu) = \\frac{1}{\\sigma^2}\$ (information de Fisher de la gaussienne).\n'
                  'Donc la borne vaut \$\\frac{\\sigma^2}{n} = \\text{Var}(\\bar{X}_n)\$ : l\'estimateur est efficace ✓.\n\n'
                  'Attention : l\'efficacité est spécifique au modèle gaussien. Pour d\'autres lois, la moyenne empirique peut ne pas être l\'estimateur optimal.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul de l\'information de Fisher et la comparaison avec la borne de Cramér-Rao.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_n)\$ une suite de variables i.i.d. de loi exponentielle \$\\mathcal{E}(\\lambda)\$. '
                  'Montrer que \$M_n = \\max(X_1, \\ldots, X_n) - \\frac{\\ln(n)}{\\lambda}\$ converge en loi '
                  'et identifier la loi limite.',
              indication:
                  'Calculer \$P(M_n \\leq x + \\frac{\\ln n}{\\lambda})\$ et reconnaître '
                  'une loi de Gumbel.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence en loi du maximum renormalisé de variables exponentielles.\n\n'
                  'Rappel : pour \$X \\sim \\mathcal{E}(\\lambda)\$, \$P(X \\leq x) = 1 - e^{-\\lambda x}\$ pour \$x \\geq 0\$. Le maximum de v.a. i.i.d. est lié aux valeurs extrêmes.\n\n'
                  '\$P(M_n \\leq t) = P(X_1 \\leq t)^n = (1 - e^{-\\lambda t})^n\$ (par indépendance).\n'
                  'Posons \$t = x + \\frac{\\ln n}{\\lambda}\$ : \$P(M_n \\leq t) = \\left(1 - e^{-\\lambda x - \\ln n}\\right)^n = \\left(1 - \\frac{e^{-\\lambda x}}{n}\\right)^n\$.\n'
                  'Quand \$n \\to \\infty\$ : \$\\left(1 - \\frac{e^{-\\lambda x}}{n}\\right)^n \\to \\exp(-e^{-\\lambda x})\$.\n'
                  'La loi limite est la loi de Gumbel (type I) : \$G(x) = \\exp(-e^{-\\lambda x})\$ pour \$x \\in \\mathbb{R}\$.\n'
                  'C\'est un cas particulier du théorème de Fisher-Tippett pour les valeurs extrêmes.\n\n'
                  'Attention : la normalisation dépend de la queue de la loi. Pour des lois à queue lourde (Pareto), on obtient une loi de Fréchet, pas de Gumbel.',
              points: 4,
              rapportJury:
                  'Le jury attend le calcul de la fonction de répartition du maximum et l\'identification de la loi de Gumbel.',
            ),
            QuestionAnnale(
              enonce:
                  'Construire un intervalle de confiance de niveau \$1 - \\alpha\$ pour la moyenne \$\\mu\$ '
                  'd\'une loi normale de variance \$\\sigma^2\$ connue, à partir d\'un échantillon de taille \$n\$.',
              indication:
                  'Utiliser la loi exacte de \$\\bar{X}_n\$ et les quantiles de la loi normale.',
              correction:
                  'Ce qu\'on nous demande : construire un IC pour \$\\mu\$ dans le modèle gaussien avec variance connue.\n\n'
                  'Rappel : \$\\bar{X}_n \\sim \\mathcal{N}(\\mu, \\sigma^2/n)\$, donc \$Z = \\frac{\\bar{X}_n - \\mu}{\\sigma/\\sqrt{n}} \\sim \\mathcal{N}(0,1)\$.\n\n'
                  'On cherche un intervalle \$I_n\$ tel que \$P(\\mu \\in I_n) = 1 - \\alpha\$.\n'
                  '\$P(-z_{\\alpha/2} \\leq Z \\leq z_{\\alpha/2}) = 1 - \\alpha\$ où \$z_{\\alpha/2} = \\Phi^{-1}(1 - \\alpha/2)\$.\n'
                  'En « dépivotant » : \$P\\left(\\bar{X}_n - z_{\\alpha/2} \\frac{\\sigma}{\\sqrt{n}} \\leq \\mu \\leq \\bar{X}_n + z_{\\alpha/2} \\frac{\\sigma}{\\sqrt{n}}\\right) = 1 - \\alpha\$.\n'
                  'L\'IC est \$I_n = \\left[\\bar{X}_n \\pm z_{\\alpha/2} \\frac{\\sigma}{\\sqrt{n}}\\right]\$.\n'
                  'Pour \$\\alpha = 0.05\$ : \$z_{0.025} \\approx 1.96\$, d\'où \$I_n = \\left[\\bar{X}_n \\pm 1.96 \\frac{\\sigma}{\\sqrt{n}}\\right]\$.\n'
                  'La longueur de l\'IC est \$2 \\cdot 1.96 \\cdot \\sigma / \\sqrt{n}\$, qui décroît en \$1/\\sqrt{n}\$.\n\n'
                  'Attention : si \$\\sigma\$ est inconnu, on remplace par l\'écart-type empirique et on utilise la loi de Student \$t_{n-1}\$ au lieu de la loi normale.',
              points: 3,
              rapportJury:
                  'Le jury attend le pivot gaussien et la formule explicite de l\'IC. La mention du cas \$\\sigma\$ inconnu est appréciée.',
            ),
            QuestionAnnale(
              enonce:
                  'Énoncer la loi forte des grands nombres et donner un exemple d\'application '
                  'à la méthode de Monte-Carlo.',
              indication:
                  'La LFGN dit que \$\\bar{X}_n \\to \\mu\$ presque sûrement. '
                  'Appliquer à l\'estimation de \$\\pi\$.',
              correction:
                  'Ce qu\'on nous demande : énoncer la LFGN et l\'illustrer par Monte-Carlo.\n\n'
                  'Rappel (LFGN de Kolmogorov) : si \$(X_n)\$ sont i.i.d. avec \$E[|X_1|] < \\infty\$, alors \$\\bar{X}_n = \\frac{1}{n}\\sum_{i=1}^n X_i \\xrightarrow{p.s.} E[X_1]\$.\n\n'
                  'Application Monte-Carlo : pour estimer \$\\pi\$, on tire des points \$(U_i, V_i)\$ uniformes dans \$[0,1]^2\$.\n'
                  'Posons \$X_i = \\mathbf{1}_{U_i^2 + V_i^2 \\leq 1}\$. Alors \$E[X_i] = P(U^2 + V^2 \\leq 1) = \\pi/4\$ (aire du quart de disque).\n'
                  'Par la LFGN : \$\\bar{X}_n \\to \\pi/4\$ p.s., donc \$4\\bar{X}_n \\to \\pi\$ p.s.\n'
                  'En pratique, avec \$n = 10^6\$ tirages, on obtient environ 2 décimales correctes de \$\\pi\$.\n'
                  'La vitesse de convergence est en \$O(1/\\sqrt{n})\$ (par le TCL), indépendante de la dimension : c\'est l\'avantage de Monte-Carlo en grande dimension.\n\n'
                  'Attention : la LFGN donne la convergence p.s., plus forte que la convergence en probabilité (loi faible). La preuve nécessite l\'indépendance et \$E[|X_1|] < \\infty\$.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'énoncé précis et une application concrète de Monte-Carlo.',
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2023 – Épreuve 1
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2023EP1() {
    return Annale(
      id: 'ped_int_2023_ep1',
      annee: 2023,
      session: 'interne',
      typeEpreuve: 'ecrit1',
      titre: 'Agrégation interne 2023 – Épreuve 1 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 1 de l\'agrégation interne 2023. '
          'Algèbre linéaire, géométrie plane et analyse réelle.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Algèbre linéaire', 'Géométrie plane', 'Analyse réelle'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep1/23-ep1.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Diagonalisation', 'Réduction', 'Transformations du plan', 'Suites', 'Fonctions continues'],
      rapportGlobal:
          'L\'épreuve 1 de l\'interne 2023 couvre algèbre linéaire, géométrie et analyse. '
          'Chaque question est expliquée pas à pas avec bienveillance. Vous allez y arriver !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Algèbre linéaire',
          introduction:
              'Cette partie porte sur la diagonalisation, la trigonalisation '
              'et les applications de l\'algèbre linéaire.',
          bareme: 7,
          themes: ['Diagonalisation', 'Trigonalisation', 'Matrices'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$A = \\begin{pmatrix} 3 & 1 \\\\ 0 & 3 \\end{pmatrix}\$. '
                  'La matrice \$A\$ est-elle diagonalisable ? Calculer \$A^n\$ pour tout \$n \\in \\mathbb{N}\$.',
              indication:
                  'Écrire \$A = 3I + N\$ où \$N\$ est nilpotente et utiliser le binôme de Newton '
                  '(les termes \$N^k\$ sont nuls pour \$k \\geq 2\$).',
              correction:
                  'Ce qu\'on nous demande : étudier la diagonalisabilité de \$A\$ et calculer ses puissances.\n\n'
                  'Rappel : \$A\$ est diagonalisable ssi le polynôme minimal est scindé à racines simples. Si \$A = D + N\$ avec \$DN = ND\$ et \$N\$ nilpotente, on utilise le binôme.\n\n'
                  '\$\\chi_A = (X-3)^2\$ donc la seule valeur propre est \$\\lambda = 3\$, de multiplicité algébrique 2.\n'
                  '\$\\ker(A - 3I) = \\ker\\begin{pmatrix} 0 & 1 \\\\ 0 & 0 \\end{pmatrix} = \\text{Vect}(e_1)\$ de dimension 1 ≠ 2.\n'
                  'Donc \$A\$ n\'est PAS diagonalisable.\n'
                  'Posons \$N = A - 3I = \\begin{pmatrix} 0 & 1 \\\\ 0 & 0 \\end{pmatrix}\$. On a \$N^2 = 0\$ et \$3I\$ commute avec \$N\$.\n'
                  'Par le binôme : \$A^n = (3I + N)^n = \\sum_{k=0}^n \\binom{n}{k} 3^{n-k} N^k = 3^n I + n \\cdot 3^{n-1} N = \\begin{pmatrix} 3^n & n \\cdot 3^{n-1} \\\\ 0 & 3^n \\end{pmatrix}\$.\n\n'
                  'Attention : le binôme de Newton \$(A+B)^n = \\sum \\binom{n}{k} A^k B^{n-k}\$ n\'est valable que si \$AB = BA\$. Ici c\'est le cas car \$3I\$ commute avec tout.',
              points: 4,
              rapportJury:
                  'Le jury attend la vérification de la non-diagonalisabilité ET le calcul de \$A^n\$ par le binôme.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$E = \\mathbb{R}_n[X]\$ et \$\\varphi : P \\mapsto P - P\'\$. '
                  'Déterminer les valeurs propres et les sous-espaces propres de \$\\varphi\$. '
                  '\$\\varphi\$ est-il diagonalisable ?',
              indication:
                  'Résoudre \$P - P\' = \\lambda P\$, soit \$P\' = (1 - \\lambda)P\$. '
                  'Quels polynômes vérifient cette équation différentielle ?',
              correction:
                  'Ce qu\'on nous demande : étudier l\'endomorphisme \$\\varphi : P \\mapsto P - P\'\$ sur l\'espace des polynômes de degré \$\\leq n\$.\n\n'
                  'Rappel : la dérivation \$D : P \\mapsto P\'\$ est nilpotente sur \$\\mathbb{R}_n[X]\$ (\$D^{n+1} = 0\$). L\'endomorphisme \$\\varphi = \\text{Id} - D\$.\n\n'
                  'Cherchons les valeurs propres : \$\\varphi(P) = \\lambda P\$ signifie \$P - P\' = \\lambda P\$, soit \$P\' = (1-\\lambda)P\$.\n'
                  'Si \$\\lambda \\neq 1\$ : la seule solution polynomiale de \$P\' = cP\$ (avec \$c \\neq 0\$) est \$P = 0\$ (car la solution est \$Ce^{cx}\$, non polynomiale).\n'
                  'Si \$\\lambda = 1\$ : \$P\' = 0\$, donc \$P\$ est constant. Le sous-espace propre est \$E_1 = \\mathbb{R}\$, de dimension 1.\n'
                  'La seule valeur propre est \$\\lambda = 1\$ de multiplicité géométrique 1 et algébrique \$n + 1\$ (car \$\\chi_\\varphi = (X-1)^{n+1}\$).\n'
                  'Comme la multiplicité géométrique (1) < multiplicité algébrique (\$n+1\$), \$\\varphi\$ n\'est PAS diagonalisable pour \$n \\geq 1\$.\n\n'
                  'Attention : \$\\varphi = \\text{Id} - D\$ avec \$D\$ nilpotente est une perturbation nilpotente de l\'identité. C\'est la décomposition de Dunford !',
              points: 3,
              rapportJury:
                  'Le jury attend l\'identification de la seule valeur propre et la conclusion sur la non-diagonalisabilité.',
            ),
            QuestionAnnale(
              enonce:
                  'Soient \$A, B \\in \\mathcal{M}_n(\\mathbb{R})\$ deux matrices symétriques réelles '
                  'avec \$A\$ définie positive. Montrer que les valeurs propres de \$AB\$ sont réelles.',
              indication:
                  'Écrire \$A = S^T S\$ (Cholesky) et montrer que \$AB\$ est semblable '
                  'à la matrice symétrique \$S B S^T\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que le produit d\'une symétrique définie positive par une symétrique a des valeurs propres réelles.\n\n'
                  'Rappel : \$A\$ symétrique définie positive admet une racine carrée \$S\$ : \$A = S^2\$ avec \$S\$ symétrique définie positive. On a aussi la décomposition de Cholesky \$A = L L^T\$.\n\n'
                  'Comme \$A = S^2\$ avec \$S\$ inversible, on a \$AB = S^2 B = S(SB)\$.\n'
                  'La matrice \$AB\$ est semblable à \$S^{-1}(AB)S = S^{-1}S^2 B S = S B S\$.\n'
                  'Or \$SBS\$ est symétrique : \$(SBS)^T = S^T B^T S^T = SBS\$ (car \$S = S^T\$ et \$B = B^T\$).\n'
                  'Donc \$AB\$ est semblable à la matrice symétrique \$SBS\$, dont les valeurs propres sont réelles (théorème spectral).\n'
                  'Comme des matrices semblables ont les mêmes valeurs propres, celles de \$AB\$ sont réelles.\n\n'
                  'Attention : sans l\'hypothèse \$A > 0\$, le résultat est faux. Par exemple, \$A = \\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}\$ et \$B = \\begin{pmatrix} 0 & 1 \\\\ 1 & 0 \\end{pmatrix}\$ donnent \$AB\$ avec valeurs propres \$\\pm i\$... non, en fait cela donne des valeurs propres réelles. Prenez plutôt \$A\$ et \$B\$ non symétriques pour un contre-exemple.',
              points: 3,
              rapportJury:
                  'Le jury attend la racine carrée de \$A\$ et l\'argument de similitude avec une matrice symétrique.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer qu\'une matrice de rotation de \$\\mathbb{R}^3\$ admet toujours '
                  'la valeur propre \$1\$ et interpréter géométriquement.',
              indication:
                  'Utiliser le fait que \$\\det(R - I) = \\det(R)(1 - \\det(R^{-1}) \\det(I - R^T))\$ '
                  'ou un argument de polynôme caractéristique de degré impair.',
              correction:
                  'Ce qu\'on nous demande : prouver que toute rotation de \$\\mathbb{R}^3\$ a un axe (droite fixe).\n\n'
                  'Rappel : une rotation de \$\\mathbb{R}^3\$ est une matrice \$R \\in SO_3(\\mathbb{R})\$ : \$R^T R = I\$ et \$\\det(R) = 1\$.\n\n'
                  '\$\\chi_R\$ est un polynôme de degré 3 à coefficients réels, donc il admet au moins une racine réelle \$\\lambda\$.\n'
                  'Comme \$R\$ est orthogonale, \$|\\lambda| = 1\$ (les valeurs propres d\'une matrice orthogonale sont de module 1).\n'
                  'Donc \$\\lambda = \\pm 1\$. Les valeurs propres de \$R\$ sont \$\\{1, e^{i\\theta}, e^{-i\\theta}\\}\$ ou \$\\{-1, e^{i\\theta}, e^{-i\\theta}\\}\$ (elles viennent par paires conjuguées).\n'
                  'Le produit des valeurs propres = \$\\det(R) = 1\$. Si \$\\lambda_1 = -1\$ : \$(-1) \\cdot e^{i\\theta} \\cdot e^{-i\\theta} = -1 \\neq 1\$. Contradiction !\n'
                  'Donc \$\\lambda_1 = 1\$ est toujours valeur propre.\n'
                  'Interprétation : le sous-espace propre \$E_1 = \\ker(R - I)\$ est l\'axe de rotation. Tout vecteur de cet axe est fixé par \$R\$.\n\n'
                  'Attention : en dimension paire, une rotation peut ne PAS avoir la valeur propre 1 (ex : rotation de \$\\pi/2\$ dans \$\\mathbb{R}^2\$). C\'est spécifique à la dimension impaire.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'argument de degré impair et de déterminant pour prouver l\'existence de la valeur propre 1.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$A \\in \\mathcal{M}_n(\\mathbb{R})\$ telle que \$\\text{tr}(A^k) = 0\$ '
                  'pour tout \$k \\geq 1\$. Montrer que \$A\$ est nilpotente.',
              indication:
                  'Utiliser les relations de Newton entre les fonctions symétriques '
                  'des valeurs propres et les traces des puissances.',
              correction:
                  'Ce qu\'on nous demande : prouver que si toutes les traces des puissances sont nulles, \$A\$ est nilpotente.\n\n'
                  'Rappel : les relations de Newton lient les sommes de puissances \$p_k = \\sum \\lambda_i^k = \\text{tr}(A^k)\$ aux coefficients du polynôme caractéristique.\n\n'
                  'Soit \$\\lambda_1, \\ldots, \\lambda_n \\in \\mathbb{C}\$ les valeurs propres de \$A\$ (comptées avec multiplicité).\n'
                  'L\'hypothèse donne \$\\sum_{i=1}^n \\lambda_i^k = 0\$ pour tout \$k \\geq 1\$.\n'
                  'Par les formules de Newton : \$e_1 = p_1 = 0\$, puis \$2e_2 = e_1 p_1 - p_2 = 0\$, etc. Tous les coefficients symétriques élémentaires sont nuls.\n'
                  'Donc \$\\chi_A(X) = X^n\$ et les valeurs propres sont toutes nulles : \$\\lambda_i = 0\$ pour tout \$i\$.\n'
                  'Par le théorème de Cayley-Hamilton : \$A^n = 0\$, donc \$A\$ est nilpotente.\n\n'
                  'Attention : les formules de Newton nécessitent de travailler sur \$\\mathbb{C}\$ (pour que \$\\chi_A\$ soit scindé). Le résultat est vrai sur tout corps de caractéristique 0.',
              points: 4,
              rapportJury:
                  'Le jury attend les formules de Newton et le théorème de Cayley-Hamilton.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Géométrie plane',
          introduction:
              'Cette partie porte sur les transformations du plan, les isométries, '
              'les similitudes et les coniques.',
          bareme: 6,
          themes: ['Isométries', 'Similitudes', 'Coniques'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$f\$ une similitude directe du plan complexe d\'écriture '
                  '\$f(z) = az + b\$ avec \$a \\neq 1\$. Montrer que \$f\$ admet '
                  'un unique point fixe et le calculer.',
              indication:
                  'Résoudre \$f(z) = z\$, soit \$az + b = z\$.',
              correction:
                  'Ce qu\'on nous demande : trouver le point fixe d\'une similitude directe non triviale.\n\n'
                  'Rappel : une similitude directe du plan s\'écrit \$f(z) = az + b\$ avec \$a \\in \\mathbb{C}^*\$, \$b \\in \\mathbb{C}\$. Le rapport est \$|a|\$ et l\'angle est \$\\arg(a)\$.\n\n'
                  'Point fixe : \$f(z) = z\$ donne \$az + b = z\$, soit \$(a-1)z = -b\$.\n'
                  'Comme \$a \\neq 1\$ : \$z_0 = \\frac{-b}{a-1} = \\frac{b}{1-a}\$.\n'
                  'C\'est l\'unique point fixe de \$f\$. On peut réécrire \$f(z) - z_0 = a(z - z_0)\$ : \$f\$ est la composée de la rotation d\'angle \$\\arg(a)\$ et de l\'homothétie de rapport \$|a|\$, centrées en \$z_0\$.\n'
                  'Si \$|a| = 1\$ et \$a \\neq 1\$, \$f\$ est une rotation de centre \$z_0\$. Si \$|a| \\neq 1\$, c\'est une vraie similitude (spirale).\n\n'
                  'Attention : si \$a = 1\$, \$f(z) = z + b\$ est une translation (pas de point fixe si \$b \\neq 0\$). Le cas \$a = 1\$ est donc exclu ici.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul du point fixe et l\'interprétation géométrique comme similitude centrée.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que toute isométrie affine du plan est la composée d\'au plus '
                  'trois réflexions.',
              indication:
                  'Utiliser le fait que les translations et les rotations sont '
                  'composées de deux réflexions, et les réflexions glissées de trois.',
              correction:
                  'Ce qu\'on nous demande : prouver que trois réflexions suffisent à engendrer toute isométrie du plan.\n\n'
                  'Rappel : les isométries du plan sont : translations, rotations, réflexions, réflexions glissées. Toute isométrie s\'écrit \$f(x) = Ax + b\$ avec \$A \\in O_2(\\mathbb{R})\$.\n\n'
                  'Réflexion = 1 réflexion (trivial).\n'
                  'Translation : \$t_v = s_{D_2} \\circ s_{D_1}\$ où \$D_1 \\perp v\$ et \$D_2\$ est parallèle à \$D_1\$ à distance \$\\|v\\|/2\$ (composée de 2 réflexions d\'axes parallèles).\n'
                  'Rotation : \$r_{O,\\theta} = s_{D_2} \\circ s_{D_1}\$ où \$D_1, D_2\$ se coupent en \$O\$ avec un angle \$\\theta/2\$ (composée de 2 réflexions d\'axes sécants).\n'
                  'Réflexion glissée : \$g = t_v \\circ s_D\$ (avec \$v \\parallel D\$) = \$s_{D_2} \\circ s_{D_1} \\circ s_D\$ (composée de 3 réflexions).\n'
                  'On a montré que chaque type nécessite au plus 3 réflexions.\n\n'
                  'Attention : le nombre 3 est optimal : une réflexion glissée ne peut PAS s\'écrire comme composée de 2 réflexions (car le déterminant de la composée de 2 réflexions est \$+1\$, pas \$-1\$).',
              points: 3,
              rapportJury:
                  'Le jury attend la décomposition pour chaque type d\'isométrie et l\'argument d\'optimalité.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer la nature de la conique d\'équation '
                  '\$x^2 + 4xy + 4y^2 + 2x - 4y + 1 = 0\$ dans un repère orthonormé.',
              indication:
                  'Calculer le discriminant \$\\Delta = B^2 - 4AC\$ de la partie quadratique '
                  'et déterminer le rang.',
              correction:
                  'Ce qu\'on nous demande : classifier la conique définie par l\'équation donnée.\n\n'
                  'Rappel : pour \$Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0\$, le discriminant \$\\Delta = B^2 - 4AC\$ détermine le type : \$\\Delta < 0\$ (ellipse), \$\\Delta = 0\$ (parabole), \$\\Delta > 0\$ (hyperbole).\n\n'
                  'Ici : \$A = 1\$, \$B = 4\$, \$C = 4\$, \$D = 2\$, \$E = -4\$, \$F = 1\$.\n'
                  '\$\\Delta = 16 - 16 = 0\$ : c\'est une conique parabolique (parabole dégénérée ou non).\n'
                  'La partie quadratique : \$x^2 + 4xy + 4y^2 = (x + 2y)^2\$. Le rang est 1.\n'
                  'Posons \$u = x + 2y\$ et \$v = 2x - y\$ (base orthogonale à normaliser). On a \$x = \\frac{u + 2v}{5}\$ et \$y = \\frac{2u - v}{5}\$.\n'
                  'En substituant : \$u^2 + \\frac{2(u + 2v)}{5} - \\frac{4(2u - v)}{5} + 1 = 0\$, soit \$u^2 - \\frac{6u}{5} + \\frac{8v}{5} + 1 = 0\$.\n'
                  'En complétant le carré en \$u\$ : c\'est une parabole (non dégénérée) d\'axe parallèle à la direction \$v\$.\n\n'
                  'Attention : quand \$\\Delta = 0\$, la conique peut être dégénérée (deux droites parallèles, une droite double, ou l\'ensemble vide). Il faut vérifier en étudiant le rang de la matrice \$3 \\times 3\$ associée.',
              points: 4,
              rapportJury:
                  'Le jury attend le calcul du discriminant, la factorisation de la partie quadratique et la conclusion.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$\\mathcal{C}\$ le cercle de centre \$O\$ et de rayon \$R\$ dans le plan. '
                  'Montrer que l\'inversion de centre \$O\$ et de rapport \$R^2\$ transforme '
                  'une droite ne passant pas par \$O\$ en un cercle passant par \$O\$.',
              indication:
                  'Écrire l\'inversion \$I(M) = M\'\$ avec \$\\overrightarrow{OM\'} = \\frac{R^2}{OM^2} \\overrightarrow{OM}\$ '
                  'et utiliser les coordonnées complexes.',
              correction:
                  'Ce qu\'on nous demande : montrer que l\'inversion transforme les droites (ne passant pas par le centre) en cercles.\n\n'
                  'Rappel : l\'inversion de centre \$O\$ et de rapport \$k = R^2\$ envoie \$M \\neq O\$ sur \$M\'\$ tel que \$\\overrightarrow{OM\'} = \\frac{k}{|OM|^2} \\overrightarrow{OM}\$. En coordonnées complexes : \$z\' = k/\\bar{z}\$.\n\n'
                  'Soit \$D\$ une droite ne passant pas par \$O\$. En coordonnées complexes, \$D\$ s\'écrit \$\\bar{\\alpha} z + \\alpha \\bar{z} = 2c\$ avec \$c \\neq 0\$.\n'
                  'L\'image de \$D\$ par l\'inversion \$z\' = R^2/\\bar{z}\$ (donc \$\\bar{z} = R^2/z\'\$) : \$\\bar{\\alpha} z + \\alpha \\frac{R^2}{z\'} = 2c\$.\n'
                  'En multipliant par \$z\'/R^2\$ et réarrangeant, on obtient une équation de cercle passant par l\'origine (\$z\' = 0\$ correspond à \$z \\to \\infty\$, « point à l\'infini » de la droite).\n'
                  'L\'image est un cercle passant par \$O\$ de rayon \$\\frac{R^2}{2d}\$ où \$d\$ est la distance de \$O\$ à \$D\$.\n\n'
                  'Attention : l\'inversion échange droites ne passant pas par \$O\$ ↔ cercles passant par \$O\$, et cercles ne passant pas par \$O\$ ↔ cercles ne passant pas par \$O\$. Les droites passant par \$O\$ sont globalement invariantes.',
              points: 3,
              rapportJury:
                  'Le jury attend le calcul en coordonnées complexes et l\'identification du cercle image.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$ABC\$ un triangle du plan. Montrer que les trois médiatrices '
                  'sont concourantes et que leur point commun est le centre du cercle circonscrit.',
              indication:
                  'Montrer que le point équidistant de \$A\$ et \$B\$ '
                  'et équidistant de \$B\$ et \$C\$ est aussi équidistant de \$A\$ et \$C\$.',
              correction:
                  'Ce qu\'on nous demande : prouver la concourance des médiatrices et l\'existence du cercle circonscrit.\n\n'
                  'Rappel : la médiatrice de \$[AB]\$ est l\'ensemble des points équidistants de \$A\$ et \$B\$ : \$\\{M : MA = MB\\}\$.\n\n'
                  'Soient \$m_1\$ la médiatrice de \$[AB]\$ et \$m_2\$ celle de \$[BC]\$. Comme \$A, B, C\$ ne sont pas alignés, \$m_1\$ et \$m_2\$ ne sont pas parallèles (elles sont perpendiculaires à des directions différentes). Elles se coupent en un point \$O\$.\n'
                  'Par définition : \$O \\in m_1\$ implique \$OA = OB\$, et \$O \\in m_2\$ implique \$OB = OC\$.\n'
                  'Par transitivité : \$OA = OB = OC\$. Donc \$O\$ est équidistant de \$A\$ et \$C\$, i.e. \$O \\in m_3\$ (médiatrice de \$[AC]\$).\n'
                  'Les trois médiatrices sont concourantes en \$O\$. Le cercle de centre \$O\$ et de rayon \$R = OA = OB = OC\$ passe par \$A, B, C\$ : c\'est le cercle circonscrit.\n\n'
                  'Attention : en coordonnées, le centre du cercle circonscrit est le point \$O\$ solution du système \$OA^2 = OB^2 = OC^2\$. Ce système a une unique solution car les trois points ne sont pas alignés.',
              points: 3,
              rapportJury:
                  'Le jury attend un raisonnement clair par transitivité de l\'égalité des distances.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Analyse réelle',
          introduction:
              'Cette partie porte sur les suites numériques, les fonctions continues '
              'et les séries numériques.',
          bareme: 7,
          themes: ['Suites', 'Fonctions continues', 'Séries numériques'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$(u_n)\$ définie par \$u_0 > 0\$ et \$u_{n+1} = \\frac{1}{2}(u_n + \\frac{2}{u_n})\$. '
                  'Montrer que la suite converge et déterminer sa limite.',
              indication:
                  'Reconnaître la méthode de Newton pour \$\\sqrt{2}\$. '
                  'Montrer que \$u_n \\geq \\sqrt{2}\$ pour \$n \\geq 1\$ puis que la suite est décroissante.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence de la suite de Héron (méthode de Babylone) pour \$\\sqrt{2}\$.\n\n'
                  'Rappel : c\'est la méthode de Newton appliquée à \$f(x) = x^2 - 2\$ : \$u_{n+1} = u_n - \\frac{f(u_n)}{f\'(u_n)} = \\frac{1}{2}(u_n + 2/u_n)\$.\n\n'
                  'Montrons \$u_n \\geq \\sqrt{2}\$ pour \$n \\geq 1\$ : par l\'inégalité AM-GM, \$u_{n+1} = \\frac{u_n + 2/u_n}{2} \\geq \\sqrt{u_n \\cdot 2/u_n} = \\sqrt{2}\$.\n'
                  'Décroissance pour \$n \\geq 1\$ : \$u_{n+1} - u_n = \\frac{2/u_n - u_n}{2} = \\frac{2 - u_n^2}{2u_n} \\leq 0\$ car \$u_n \\geq \\sqrt{2}\$.\n'
                  'La suite est décroissante et minorée par \$\\sqrt{2}\$ (pour \$n \\geq 1\$), donc elle converge vers une limite \$\\ell \\geq \\sqrt{2}\$.\n'
                  'Passage à la limite : \$\\ell = \\frac{1}{2}(\\ell + 2/\\ell)\$, soit \$2\\ell^2 = \\ell^2 + 2\$, donc \$\\ell^2 = 2\$ et \$\\ell = \\sqrt{2}\$ (car \$\\ell > 0\$).\n'
                  'La convergence est quadratique : \$u_{n+1} - \\sqrt{2} = \\frac{(u_n - \\sqrt{2})^2}{2u_n}\$, donc l\'erreur est élevée au carré à chaque itération.\n\n'
                  'Attention : cette méthode converge très vite (convergence quadratique). Après quelques itérations, le nombre de décimales correctes double à chaque pas.',
              points: 4,
              rapportJury:
                  'Le jury attend la minoration par AM-GM, la monotonie et le passage à la limite. La convergence quadratique est un bonus.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$f : [0,1] \\to [0,1]\$ continue. Montrer que \$f\$ admet un point fixe.',
              indication:
                  'Considérer la fonction \$g(x) = f(x) - x\$ et appliquer '
                  'le théorème des valeurs intermédiaires.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème du point fixe pour les fonctions continues sur un segment.\n\n'
                  'Rappel : le théorème des valeurs intermédiaires (TVI) dit que si \$g\$ est continue sur \$[a,b]\$ avec \$g(a)g(b) \\leq 0\$, alors il existe \$c \\in [a,b]\$ tel que \$g(c) = 0\$.\n\n'
                  'Posons \$g(x) = f(x) - x\$, continue sur \$[0,1]\$ (différence de fonctions continues).\n'
                  '\$g(0) = f(0) - 0 = f(0) \\geq 0\$ (car \$f(0) \\in [0,1]\$).\n'
                  '\$g(1) = f(1) - 1 \\leq 0\$ (car \$f(1) \\in [0,1]\$).\n'
                  'Si \$g(0) = 0\$ : \$f(0) = 0\$, point fixe en 0. Si \$g(1) = 0\$ : \$f(1) = 1\$, point fixe en 1.\n'
                  'Sinon : \$g(0) > 0\$ et \$g(1) < 0\$. Par le TVI, il existe \$c \\in ]0,1[\$ tel que \$g(c) = 0\$, i.e. \$f(c) = c\$.\n'
                  'Dans tous les cas, \$f\$ admet au moins un point fixe.\n\n'
                  'Attention : l\'hypothèse \$f([0,1]) \\subset [0,1]\$ est essentielle. Sans elle (ex : \$f : [0,1] \\to \\mathbb{R}\$), un point fixe n\'existe pas nécessairement.',
              points: 3,
              rapportJury:
                  'Le jury attend une application propre du TVI avec traitement des cas limites.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que la fonction \$f(x) = \\sum_{n=1}^\\infty \\frac{\\sin(nx)}{n^2}\$ '
                  'est continue sur \$\\mathbb{R}\$.',
              indication:
                  'Utiliser la convergence uniforme de la série de fonctions '
                  'et le théorème de continuité sous la limite uniforme.',
              correction:
                  'Ce qu\'on nous demande : prouver la continuité de la somme de la série \$\\sum \\frac{\\sin(nx)}{n^2}\$.\n\n'
                  'Rappel : si une série de fonctions continues converge uniformément, alors la somme est continue (théorème de la limite uniforme).\n\n'
                  'Chaque \$f_n(x) = \\frac{\\sin(nx)}{n^2}\$ est continue sur \$\\mathbb{R}\$ (fonctions trigonométriques).\n'
                  'Convergence uniforme : \$|f_n(x)| = \\frac{|\\sin(nx)|}{n^2} \\leq \\frac{1}{n^2}\$ pour tout \$x \\in \\mathbb{R}\$.\n'
                  'La série \$\\sum \\frac{1}{n^2}\$ converge (série de Riemann avec \$\\alpha = 2 > 1\$).\n'
                  'Par le critère de Weierstrass (\$M\$-test) : la série \$\\sum f_n\$ converge normalement, donc uniformément.\n'
                  'Par le théorème de la limite uniforme : \$f = \\sum f_n\$ est continue sur \$\\mathbb{R}\$.\n\n'
                  'Attention : la convergence normale implique la convergence uniforme, mais pas la réciproque. Ici, la convergence normale est suffisante et plus facile à vérifier.',
              points: 3,
              rapportJury:
                  'Le jury attend le critère de Weierstrass et le théorème de continuité de la limite uniforme.',
            ),
            QuestionAnnale(
              enonce:
                  'Étudier la nature de la série \$\\sum_{n \\geq 1} \\frac{(-1)^n}{\\sqrt{n}}\$. '
                  'La convergence est-elle absolue ?',
              indication:
                  'Utiliser le critère des séries alternées (Leibniz) pour la convergence, '
                  'et comparer \$\\sum 1/\\sqrt{n}\$ à une série de Riemann.',
              correction:
                  'Ce qu\'on nous demande : étudier la convergence de la série alternée \$\\sum (-1)^n / \\sqrt{n}\$.\n\n'
                  'Rappel : le critère de Leibniz dit que si \$(a_n)\$ est décroissante et tend vers 0, alors \$\\sum (-1)^n a_n\$ converge.\n\n'
                  'Posons \$a_n = 1/\\sqrt{n}\$. La suite \$(a_n)\$ est décroissante (car \$\\sqrt{n}\$ est croissante) et \$a_n \\to 0\$.\n'
                  'Par le critère de Leibniz : la série \$\\sum \\frac{(-1)^n}{\\sqrt{n}}\$ converge.\n'
                  'Convergence absolue ? \$\\sum |\\frac{(-1)^n}{\\sqrt{n}}| = \\sum \\frac{1}{\\sqrt{n}} = \\sum \\frac{1}{n^{1/2}}\$.\n'
                  'C\'est une série de Riemann avec \$\\alpha = 1/2 \\leq 1\$, donc elle diverge.\n'
                  'La série converge mais PAS absolument : c\'est une série semi-convergente.\n\n'
                  'Attention : pour les séries semi-convergentes, la somme dépend de l\'ordre des termes (théorème de Riemann). Un réarrangement peut donner n\'importe quelle somme, voire diverger !',
              points: 3,
              rapportJury:
                  'Le jury attend les deux arguments (Leibniz pour la convergence, Riemann pour la non-convergence absolue).',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que toute fonction continue sur un segment \$[a,b]\$ est uniformément continue.',
              indication:
                  'Raisonner par l\'absurde en utilisant le théorème de Bolzano-Weierstrass '
                  'pour extraire une sous-suite convergente.',
              correction:
                  'Ce qu\'on nous demande : prouver le théorème de Heine – continuité sur un compact implique uniforme continuité.\n\n'
                  'Rappel : \$f\$ est uniformément continue sur \$[a,b]\$ si \$\\forall \\varepsilon > 0, \\exists \\delta > 0, \\forall x, y \\in [a,b], |x-y| < \\delta \\Rightarrow |f(x)-f(y)| < \\varepsilon\$.\n\n'
                  'Par l\'absurde : supposons \$f\$ non uniformément continue. Il existe \$\\varepsilon_0 > 0\$ et des suites \$(x_n), (y_n) \\in [a,b]\$ avec \$|x_n - y_n| < 1/n\$ et \$|f(x_n) - f(y_n)| \\geq \\varepsilon_0\$.\n'
                  'Par Bolzano-Weierstrass, \$(x_n)\$ admet une sous-suite convergente : \$x_{n_k} \\to c \\in [a,b]\$.\n'
                  'Comme \$|x_{n_k} - y_{n_k}| < 1/n_k \\to 0\$, on a aussi \$y_{n_k} \\to c\$.\n'
                  'Par continuité de \$f\$ en \$c\$ : \$f(x_{n_k}) \\to f(c)\$ et \$f(y_{n_k}) \\to f(c)\$.\n'
                  'Donc \$|f(x_{n_k}) - f(y_{n_k})| \\to 0\$, ce qui contredit \$|f(x_{n_k}) - f(y_{n_k})| \\geq \\varepsilon_0 > 0\$.\n\n'
                  'Attention : le résultat est FAUX sur un ouvert. Par exemple, \$f(x) = \\sin(1/x)\$ est continue sur \$]0,1]\$ mais pas uniformément continue.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par l\'absurde avec Bolzano-Weierstrass. C\'est une preuve classique très demandée.',
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  INTERNE 2023 – Épreuve 2
  // ═══════════════════════════════════════════════════════════════════
  static Annale _int2023EP2() {
    return Annale(
      id: 'ped_int_2023_ep2',
      annee: 2023,
      session: 'interne',
      typeEpreuve: 'ecrit2',
      titre: 'Agrégation interne 2023 – Épreuve 2 (correction pédagogique)',
      description:
          'Correction pédagogique détaillée de l\'épreuve 2 de l\'agrégation interne 2023. '
          'Probabilités discrètes, suites et séries, arithmétique et combinatoire.',
      dureeMinutes: 360,
      baremeTotal: 20,
      themes: ['Probabilités discrètes', 'Suites et séries', 'Arithmétique', 'Combinatoire'],
      urlSujet: 'https://interne.agreg.org/data/uploads/epreuves/ep2/23-ep2.pdf',
      difficulte: 'Difficile',
      motsClefs: ['Marches aléatoires', 'Loi binomiale', 'Séries entières', 'PGCD', 'Dénombrement'],
      rapportGlobal:
          'L\'épreuve 2 de l\'interne 2023 mêle probabilités discrètes, analyse et arithmétique. '
          'Notre correction vous accompagne à chaque étape avec bienveillance. Chaque exercice est une victoire !',
      exercices: [
        // ── Partie I ──────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie I – Probabilités discrètes',
          introduction:
              'Cette partie porte sur les variables aléatoires discrètes, '
              'les marches aléatoires et les chaînes de Markov.',
          bareme: 7,
          themes: ['Variables discrètes', 'Marches aléatoires', 'Chaînes de Markov'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$X \\sim B(n, p)\$ une variable binomiale. Montrer que '
                  '\$E[X] = np\$ et \$\\text{Var}(X) = np(1-p)\$.',
              indication:
                  'Écrire \$X = \\sum_{i=1}^n X_i\$ avec \$X_i \\sim B(1,p)\$ i.i.d. '
                  'et utiliser la linéarité de l\'espérance.',
              correction:
                  'Ce qu\'on nous demande : calculer l\'espérance et la variance de la loi binomiale.\n\n'
                  'Rappel : \$X \\sim B(n,p)\$ signifie que \$X\$ compte le nombre de succès en \$n\$ épreuves de Bernoulli indépendantes de paramètre \$p\$.\n\n'
                  'Décomposition : \$X = X_1 + X_2 + \\cdots + X_n\$ où les \$X_i \\sim B(1,p)\$ sont i.i.d.\n'
                  'Espérance : par linéarité, \$E[X] = \\sum E[X_i] = n \\cdot p = np\$.\n'
                  'Variance : par indépendance, \$\\text{Var}(X) = \\sum \\text{Var}(X_i) = n \\cdot p(1-p) = np(1-p)\$.\n'
                  '(Car \$\\text{Var}(X_i) = E[X_i^2] - (E[X_i])^2 = p - p^2 = p(1-p)\$.)\n'
                  'Remarque : la variance est maximale pour \$p = 1/2\$ (maximum d\'incertitude) et s\'annule pour \$p = 0\$ ou \$p = 1\$ (certitude).\n\n'
                  'Attention : la linéarité de l\'espérance est TOUJOURS vraie (même sans indépendance), mais l\'additivité de la variance nécessite l\'indépendance (ou au moins la non-corrélation).',
              points: 3,
              rapportJury:
                  'Question de cours fondamentale. Le jury attend la décomposition en somme de Bernoulli.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(S_n)\$ la marche aléatoire simple sur \$\\mathbb{Z}\$ : '
                  '\$S_0 = 0\$ et \$S_n = \\sum_{i=1}^n X_i\$ avec \$P(X_i = 1) = P(X_i = -1) = 1/2\$. '
                  'Calculer \$E[S_n]\$, \$\\text{Var}(S_n)\$ et \$P(S_{2n} = 0)\$.',
              indication:
                  'Pour \$P(S_{2n} = 0)\$, il faut exactement \$n\$ pas \$+1\$ '
                  'et \$n\$ pas \$-1\$ parmi \$2n\$ pas.',
              correction:
                  'Ce qu\'on nous demande : étudier les propriétés de la marche aléatoire simple symétrique.\n\n'
                  'Rappel : la marche aléatoire simple est le modèle le plus fondamental en probabilités discrètes. \$S_n\$ est la position après \$n\$ pas.\n\n'
                  '\$E[X_i] = \\frac{1}{2}(1) + \\frac{1}{2}(-1) = 0\$, donc \$E[S_n] = 0\$ (la marche est non biaisée).\n'
                  '\$\\text{Var}(X_i) = E[X_i^2] = 1\$, donc \$\\text{Var}(S_n) = n\$ (par indépendance).\n'
                  'Pour \$P(S_{2n} = 0)\$ : il faut \$n\$ pas \$+1\$ et \$n\$ pas \$-1\$. Le nombre de tels chemins est \$\\binom{2n}{n}\$.\n'
                  '\$P(S_{2n} = 0) = \\binom{2n}{n} \\left(\\frac{1}{2}\\right)^{2n} = \\frac{(2n)!}{(n!)^2 \\cdot 4^n}\$.\n'
                  'Par la formule de Stirling : \$P(S_{2n} = 0) \\sim \\frac{1}{\\sqrt{\\pi n}}\$ quand \$n \\to \\infty\$.\n'
                  'Comme \$\\sum 1/\\sqrt{n}\$ diverge, la marche repasse par 0 infiniment souvent (théorème de récurrence de Pólya en dimension 1).\n\n'
                  'Attention : en dimension \$d \\geq 3\$, la marche aléatoire est transiente (elle ne revient PAS à l\'origine p.s.). C\'est le théorème de Pólya.',
              points: 4,
              rapportJury:
                  'Le jury attend les calculs exacts et l\'asymptotique via Stirling.',
            ),
            QuestionAnnale(
              enonce:
                  'Soit \$(X_n)\$ une chaîne de Markov à deux états \$\\{0, 1\\}\$ de matrice '
                  'de transition \$P = \\begin{pmatrix} 1-a & a \\\\ b & 1-b \\end{pmatrix}\$ '
                  'avec \$0 < a, b < 1\$. Déterminer la loi stationnaire.',
              indication:
                  'Résoudre \$\\pi P = \\pi\$ avec \$\\pi_0 + \\pi_1 = 1\$.',
              correction:
                  'Ce qu\'on nous demande : trouver la mesure invariante de la chaîne de Markov à deux états.\n\n'
                  'Rappel : la loi stationnaire \$\\pi = (\\pi_0, \\pi_1)\$ vérifie \$\\pi P = \\pi\$ et \$\\pi_0 + \\pi_1 = 1\$.\n\n'
                  '\$\\pi P = \\pi\$ donne le système :\n'
                  '\$\\pi_0(1-a) + \\pi_1 b = \\pi_0\$ et \$\\pi_0 a + \\pi_1(1-b) = \\pi_1\$.\n'
                  'La première équation simplifie en \$-a\\pi_0 + b\\pi_1 = 0\$, soit \$\\pi_1 = \\frac{a}{b} \\pi_0\$.\n'
                  'Avec la normalisation \$\\pi_0 + \\pi_1 = 1\$ : \$\\pi_0(1 + a/b) = 1\$, donc \$\\pi_0 = \\frac{b}{a+b}\$ et \$\\pi_1 = \\frac{a}{a+b}\$.\n'
                  'La loi stationnaire est \$\\pi = \\left(\\frac{b}{a+b}, \\frac{a}{a+b}\\right)\$.\n'
                  'Si \$a = b\$ : \$\\pi = (1/2, 1/2)\$ (symétrie). Plus \$a\$ est grand par rapport à \$b\$, plus la chaîne passe de temps dans l\'état 1.\n\n'
                  'Attention : comme \$0 < a, b < 1\$, la chaîne est irréductible et apériodique, donc elle converge vers \$\\pi\$ quelle que soit la loi initiale (théorème ergodique).',
              points: 3,
              rapportJury:
                  'Le jury attend la résolution du système linéaire et l\'interprétation de la loi stationnaire.',
            ),
            QuestionAnnale(
              enonce:
                  'On lance un dé équilibré jusqu\'à obtenir un 6. Soit \$N\$ le nombre '
                  'de lancers nécessaires. Déterminer la loi de \$N\$, \$E[N]\$ et \$\\text{Var}(N)\$.',
              indication:
                  'C\'est une loi géométrique de paramètre \$p = 1/6\$.',
              correction:
                  'Ce qu\'on nous demande : étudier le temps d\'attente du premier succès (loi géométrique).\n\n'
                  'Rappel : \$N \\sim \\mathcal{G}(p)\$ avec \$p = 1/6\$ (probabilité de succès à chaque lancer).\n\n'
                  '\$P(N = k) = (1-p)^{k-1} p = (5/6)^{k-1} \\cdot 1/6\$ pour \$k \\geq 1\$.\n'
                  'Vérification : \$\\sum_{k=1}^\\infty (5/6)^{k-1} (1/6) = \\frac{1/6}{1 - 5/6} = 1\$ ✓.\n'
                  'Espérance : \$E[N] = 1/p = 6\$. Il faut en moyenne 6 lancers pour obtenir un 6.\n'
                  'Variance : \$\\text{Var}(N) = (1-p)/p^2 = (5/6)/(1/36) = 30\$.\n'
                  'Propriété fondamentale : la loi géométrique est la seule loi discrète sans mémoire : \$P(N > m+n | N > m) = P(N > n)\$.\n'
                  'Cela signifie que « le passé ne compte pas » : le nombre de lancers restants ne dépend pas des lancers déjà effectués.\n\n'
                  'Attention : il y a deux conventions pour la loi géométrique : certains auteurs commencent à \$k = 0\$ (nombre d\'échecs avant le premier succès). Ici on utilise \$k \\geq 1\$ (nombre total de lancers).',
              points: 3,
              rapportJury:
                  'Le jury attend la loi explicite, les moments et la propriété d\'absence de mémoire.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer l\'inégalité de Markov : si \$X \\geq 0\$ et \$a > 0\$, '
                  'alors \$P(X \\geq a) \\leq \\frac{E[X]}{a}\$. En déduire l\'inégalité de Bienaymé-Tchebychev.',
              indication:
                  'Pour Markov : majorer \$E[X] \\geq a \\cdot P(X \\geq a)\$. '
                  'Pour Tchebychev : appliquer Markov à \$(X - \\mu)^2\$.',
              correction:
                  'Ce qu\'on nous demande : prouver deux inégalités de concentration fondamentales.\n\n'
                  'Rappel : ces inégalités bornent la probabilité qu\'une v.a. s\'éloigne de son espérance.\n\n'
                  'Markov : \$E[X] = \\sum_{x \\geq 0} x P(X = x) \\geq \\sum_{x \\geq a} x P(X = x) \\geq a \\sum_{x \\geq a} P(X = x) = a P(X \\geq a)\$.\n'
                  'Donc \$P(X \\geq a) \\leq E[X]/a\$.\n'
                  'Tchebychev : appliquons Markov à la v.a. \$Y = (X - \\mu)^2 \\geq 0\$ avec \$a = t^2\$ :\n'
                  '\$P((X-\\mu)^2 \\geq t^2) \\leq \\frac{E[(X-\\mu)^2]}{t^2} = \\frac{\\text{Var}(X)}{t^2}\$.\n'
                  'Or \$(X-\\mu)^2 \\geq t^2\$ ssi \$|X - \\mu| \\geq t\$. Donc \$P(|X - \\mu| \\geq t) \\leq \\frac{\\sigma^2}{t^2}\$.\n'
                  'Avec \$t = k\\sigma\$ : \$P(|X - \\mu| \\geq k\\sigma) \\leq 1/k^2\$ (au moins 75\\% des données sont à 2\$\\sigma\$ de la moyenne).\n\n'
                  'Attention : ces bornes sont souvent grossières. Pour la loi normale, \$P(|X - \\mu| \\geq 2\\sigma) \\approx 0.05\$, bien mieux que la borne \$1/4\$ de Tchebychev.',
              points: 4,
              rapportJury:
                  'Le jury attend les deux preuves enchaînées et la remarque sur la qualité des bornes.',
            ),
          ],
        ),
        // ── Partie II ─────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie II – Suites et séries',
          introduction:
              'Cette partie porte sur les suites récurrentes, les séries numériques '
              'et les séries entières.',
          bareme: 7,
          themes: ['Suites récurrentes', 'Séries numériques', 'Séries entières'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Soit \$(u_n)\$ définie par \$u_0 = 1\$ et \$u_{n+1} = \\frac{u_n}{1 + u_n}\$. '
                  'Montrer que \$u_n = \\frac{1}{n+1}\$ et en déduire la convergence.',
              indication:
                  'Poser \$v_n = 1/u_n\$ et montrer que \$(v_n)\$ est arithmétique.',
              correction:
                  'Ce qu\'on nous demande : trouver une formule explicite pour \$u_n\$ et étudier la convergence.\n\n'
                  'Rappel : quand une récurrence a la forme \$u_{n+1} = f(u_n)\$, un changement de variable peut la linéariser.\n\n'
                  'Posons \$v_n = 1/u_n\$ (bien défini car \$u_n > 0\$ par récurrence). Alors \$v_{n+1} = \\frac{1}{u_{n+1}} = \\frac{1 + u_n}{u_n} = 1 + v_n\$.\n'
                  'La suite \$(v_n)\$ est arithmétique de raison 1 : \$v_n = v_0 + n = 1 + n\$.\n'
                  'Donc \$u_n = \\frac{1}{v_n} = \\frac{1}{n+1}\$.\n'
                  'Convergence : \$u_n = \\frac{1}{n+1} \\to 0\$ quand \$n \\to \\infty\$.\n'
                  'La vitesse de convergence est \$O(1/n)\$ (convergence lente, comme une série harmonique).\n\n'
                  'Attention : le changement de variable \$v_n = 1/u_n\$ est une technique classique pour les récurrences homographiques \$u_{n+1} = \\frac{au_n + b}{cu_n + d}\$. Pensez-y systématiquement !',
              points: 3,
              rapportJury:
                  'Le jury attend le changement de variable et la formule explicite. La vitesse de convergence est un bonus.',
            ),
            QuestionAnnale(
              enonce:
                  'Étudier la convergence de la série \$\\sum_{n \\geq 2} \\frac{1}{n \\ln(n)}\$.',
              indication:
                  'Utiliser le critère de condensation de Cauchy ou '
                  'la comparaison avec une intégrale.',
              correction:
                  'Ce qu\'on nous demande : déterminer si la série \$\\sum 1/(n\\ln n)\$ converge ou diverge.\n\n'
                  'Rappel : les séries de Bertrand sont \$\\sum \\frac{1}{n^\\alpha (\\ln n)^\\beta}\$. Elles convergent ssi \$\\alpha > 1\$, ou \$\\alpha = 1\$ et \$\\beta > 1\$.\n\n'
                  'Ici \$\\alpha = 1\$ et \$\\beta = 1 \\leq 1\$, donc la série DIVERGE.\n'
                  'Preuve par comparaison intégrale : \$f(x) = \\frac{1}{x \\ln x}\$ est positive décroissante sur \$[2, +\\infty[\$.\n'
                  '\$\\int_2^N \\frac{dx}{x \\ln x} = [\\ln(\\ln x)]_2^N = \\ln(\\ln N) - \\ln(\\ln 2) \\to +\\infty\$.\n'
                  'Par le critère intégral, la série diverge. Mais elle diverge très lentement ! Pour \$N = 10^{10^{10}}\$, la somme partielle n\'est que d\'environ 25.\n\n'
                  'Attention : bien que \$1/(n \\ln n) \\to 0\$, la série diverge. La condition \$u_n \\to 0\$ est nécessaire mais PAS suffisante pour la convergence.',
              points: 3,
              rapportJury:
                  'Le jury attend le critère intégral (ou la condensation de Cauchy) correctement appliqué.',
            ),
            QuestionAnnale(
              enonce:
                  'Déterminer le rayon de convergence et calculer la somme de la série entière '
                  '\$\\sum_{n \\geq 0} (n+1) x^n\$.',
              indication:
                  'Reconnaître la dérivée de la série géométrique \$\\sum x^n = \\frac{1}{1-x}\$.',
              correction:
                  'Ce qu\'on nous demande : trouver \$R\$ et sommer \$\\sum (n+1)x^n\$.\n\n'
                  'Rappel : la série géométrique \$\\sum_{n=0}^\\infty x^n = \\frac{1}{1-x}\$ pour \$|x| < 1\$. En dérivant terme à terme, on obtient de nouvelles séries.\n\n'
                  'Rayon de convergence : \$\\frac{a_{n+1}}{a_n} = \\frac{n+2}{n+1} \\to 1\$, donc \$R = 1\$.\n'
                  'Calcul de la somme : partons de \$\\sum_{n=0}^\\infty x^n = \\frac{1}{1-x}\$ pour \$|x| < 1\$.\n'
                  'En dérivant : \$\\sum_{n=1}^\\infty n x^{n-1} = \\frac{1}{(1-x)^2}\$.\n'
                  'En multipliant par \$x\$ : \$\\sum_{n=1}^\\infty n x^n = \\frac{x}{(1-x)^2}\$.\n'
                  'Donc \$\\sum_{n=0}^\\infty (n+1) x^n = \\sum_{n=0}^\\infty n x^n + \\sum_{n=0}^\\infty x^n = \\frac{x}{(1-x)^2} + \\frac{1}{1-x} = \\frac{1}{(1-x)^2}\$.\n'
                  'Résultat : \$\\sum_{n=0}^\\infty (n+1) x^n = \\frac{1}{(1-x)^2}\$ pour \$|x| < 1\$.\n\n'
                  'Attention : la dérivation terme à terme est justifiée dans le disque ouvert de convergence. Sur le bord (\$|x| = 1\$), la série diverge ici.',
              points: 3,
              rapportJury:
                  'Le jury attend la dérivation de la série géométrique et la formule fermée.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que \$e\$ est irrationnel en utilisant le développement '
                  '\$e = \\sum_{n=0}^\\infty \\frac{1}{n!}\$.',
              indication:
                  'Supposer \$e = p/q\$ et majorer le reste de la série '
                  'pour obtenir une contradiction avec \$q! \\cdot e \\in \\mathbb{Z}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver que le nombre \$e\$ n\'est pas rationnel.\n\n'
                  'Rappel : \$e = \\sum_{n=0}^\\infty \\frac{1}{n!} = 1 + 1 + \\frac{1}{2} + \\frac{1}{6} + \\cdots\$ (développement en série de l\'exponentielle en \$x = 1\$).\n\n'
                  'Par l\'absurde : supposons \$e = p/q\$ avec \$p, q \\in \\mathbb{N}^*\$ et \$q \\geq 2\$ (car \$e \\notin \\mathbb{N}\$).\n'
                  'Considérons \$N = q! \\left(e - \\sum_{n=0}^q \\frac{1}{n!}\\right) = q! \\sum_{n=q+1}^\\infty \\frac{1}{n!}\$.\n'
                  'D\'une part, \$q! \\cdot e = q! \\cdot p/q = (q-1)! \\cdot p \\in \\mathbb{N}\$ et \$q! \\sum_{n=0}^q \\frac{1}{n!} = \\sum_{n=0}^q \\frac{q!}{n!} \\in \\mathbb{N}\$. Donc \$N \\in \\mathbb{N}\$.\n'
                  'D\'autre part, \$0 < N = \\frac{1}{q+1} + \\frac{1}{(q+1)(q+2)} + \\cdots < \\frac{1}{q+1} \\cdot \\frac{1}{1 - 1/(q+1)} = \\frac{1}{q} \\leq \\frac{1}{2} < 1\$.\n'
                  'Donc \$0 < N < 1\$ avec \$N \\in \\mathbb{N}\$ : impossible ! Donc \$e \\notin \\mathbb{Q}\$.\n\n'
                  'Attention : cette preuve ne montre PAS que \$e\$ est transcendant (non algébrique). La transcendance de \$e\$ est le théorème de Hermite (1873), beaucoup plus difficile.',
              points: 4,
              rapportJury:
                  'Le jury attend le raisonnement par l\'absurde avec l\'encadrement \$0 < N < 1\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer la formule d\'Euler : \$\\sum_{n=1}^\\infty \\frac{1}{n^2} = \\frac{\\pi^2}{6}\$.',
              indication:
                  'Utiliser l\'identité de Parseval avec la fonction \$f(x) = x\$ '
                  'sur \$[-\\pi, \\pi]\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le célèbre résultat de Bâle \$\\zeta(2) = \\pi^2/6\$.\n\n'
                  'Rappel : l\'identité de Parseval dit que \$\\frac{1}{2\\pi} \\int_{-\\pi}^\\pi |f(x)|^2 dx = \\sum_{n \\in \\mathbb{Z}} |c_n|^2\$ où \$c_n\$ sont les coefficients de Fourier.\n\n'
                  'Prenons \$f(x) = x\$ sur \$[-\\pi, \\pi]\$. Les coefficients de Fourier : \$c_0 = 0\$ (car \$f\$ est impaire).\n'
                  'Pour \$n \\neq 0\$ : \$c_n = \\frac{1}{2\\pi} \\int_{-\\pi}^\\pi x e^{-inx} dx = \\frac{(-1)^{n+1}}{in}\$ (intégration par parties).\n'
                  'Donc \$|c_n|^2 = \\frac{1}{n^2}\$ pour \$n \\neq 0\$.\n'
                  'Parseval : \$\\frac{1}{2\\pi} \\int_{-\\pi}^\\pi x^2 dx = \\sum_{n \\neq 0} \\frac{1}{n^2} = 2 \\sum_{n=1}^\\infty \\frac{1}{n^2}\$.\n'
                  'Le membre de gauche vaut \$\\frac{1}{2\\pi} \\cdot \\frac{2\\pi^3}{3} = \\frac{\\pi^2}{3}\$.\n'
                  'Donc \$2\\sum_{n=1}^\\infty \\frac{1}{n^2} = \\frac{\\pi^2}{3}\$, soit \$\\sum_{n=1}^\\infty \\frac{1}{n^2} = \\frac{\\pi^2}{6}\$.\n\n'
                  'Attention : il existe de nombreuses preuves de ce résultat (produit eulérien de \$\\sin\$, résidus, etc.). La preuve par Parseval est la plus naturelle en analyse de Fourier.',
              points: 4,
              rapportJury:
                  'Le jury attend le calcul des coefficients de Fourier et l\'application correcte de Parseval.',
            ),
          ],
        ),
        // ── Partie III ────────────────────────────────────────────
        ExerciceAnnale(
          titre: 'Partie III – Arithmétique et combinatoire',
          introduction:
              'Cette partie porte sur la divisibilité, les congruences, '
              'le dénombrement et les fonctions arithmétiques.',
          bareme: 6,
          themes: ['Divisibilité', 'Congruences', 'Dénombrement'],
          questions: [
            QuestionAnnale(
              enonce:
                  'Montrer le petit théorème de Fermat : si \$p\$ est premier et \$\\gcd(a, p) = 1\$, '
                  'alors \$a^{p-1} \\equiv 1 \\pmod{p}\$.',
              indication:
                  'Considérer l\'ensemble \$\\{a, 2a, 3a, \\ldots, (p-1)a\\}\$ modulo \$p\$ '
                  'et montrer que c\'est une permutation de \$\\{1, 2, \\ldots, p-1\\}\$.',
              correction:
                  'Ce qu\'on nous demande : prouver le petit théorème de Fermat, résultat fondamental en arithmétique.\n\n'
                  'Rappel : \$(\\mathbb{Z}/p\\mathbb{Z})^*\$ est un groupe de cardinal \$p-1\$ pour la multiplication. Le théorème de Lagrange donne \$a^{p-1} = 1\$ dans ce groupe.\n\n'
                  'Preuve directe : les éléments \$a, 2a, \\ldots, (p-1)a\$ sont tous distincts modulo \$p\$ (car si \$ia \\equiv ja \\pmod{p}\$ avec \$i \\neq j\$, alors \$p | (i-j)a\$, impossible car \$\\gcd(a,p) = 1\$ et \$|i-j| < p\$).\n'
                  'Aucun n\'est congru à 0 (car \$p \\nmid a\$ et \$p \\nmid i\$). Donc \$\\{a, 2a, \\ldots, (p-1)a\\} = \\{1, 2, \\ldots, p-1\\}\$ modulo \$p\$.\n'
                  'En prenant le produit : \$a \\cdot 2a \\cdots (p-1)a \\equiv 1 \\cdot 2 \\cdots (p-1) \\pmod{p}\$.\n'
                  'Soit \$a^{p-1} (p-1)! \\equiv (p-1)! \\pmod{p}\$. Comme \$\\gcd((p-1)!, p) = 1\$, on simplifie : \$a^{p-1} \\equiv 1 \\pmod{p}\$.\n\n'
                  'Attention : le petit théorème de Fermat est un cas particulier du théorème d\'Euler : \$a^{\\varphi(n)} \\equiv 1 \\pmod{n}\$ quand \$\\gcd(a,n) = 1\$.',
              points: 4,
              rapportJury:
                  'Le jury attend la preuve par le produit des éléments. La preuve par Lagrange est aussi acceptée.',
            ),
            QuestionAnnale(
              enonce:
                  'Combien y a-t-il de surjections d\'un ensemble à \$n\$ éléments vers '
                  'un ensemble à \$k\$ éléments (avec \$n \\geq k\$) ?',
              indication:
                  'Utiliser la formule d\'inclusion-exclusion : compter les applications '
                  'dont l\'image évite au moins un élément.',
              correction:
                  'Ce qu\'on nous demande : dénombrer les surjections de \$\\{1,\\ldots,n\\}\$ vers \$\\{1,\\ldots,k\\}\$.\n\n'
                  'Rappel : une surjection est une application dont tout élément de l\'ensemble d\'arrivée a au moins un antécédent.\n\n'
                  'Soit \$S(n,k)\$ le nombre de surjections. Par inclusion-exclusion (formule du crible) :\n'
                  'Soit \$A_i\$ l\'ensemble des applications qui n\'atteignent pas l\'élément \$i\$ de l\'arrivée. Alors \$|A_i| = (k-1)^n\$, \$|A_i \\cap A_j| = (k-2)^n\$, etc.\n'
                  '\$S(n,k) = k^n - |A_1 \\cup \\cdots \\cup A_k| = \\sum_{j=0}^k (-1)^j \\binom{k}{j} (k-j)^n\$.\n'
                  'Exemples : \$S(n,1) = 1\$, \$S(n,2) = 2^n - 2\$, \$S(n,n) = n!\$ (bijections).\n'
                  'Le nombre de Stirling de seconde espèce est \$\\left\\{\\begin{smallmatrix} n \\\\ k \\end{smallmatrix}\\right\\} = S(n,k)/k!\$ (partitions en \$k\$ blocs non vides).\n\n'
                  'Attention : cette formule peut donner des termes négatifs intermédiaires (signe alternant). C\'est normal pour l\'inclusion-exclusion. Vérifiez toujours avec des petites valeurs.',
              points: 4,
              rapportJury:
                  'Le jury attend l\'inclusion-exclusion correctement appliquée et le lien avec les nombres de Stirling est apprécié.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer que l\'indicatrice d\'Euler vérifie \$\\sum_{d | n} \\varphi(d) = n\$.',
              indication:
                  'Partitionner \$\\{1, 2, \\ldots, n\\}\$ selon la valeur de \$\\gcd(k, n)\$ '
                  'pour \$1 \\leq k \\leq n\$.',
              correction:
                  'Ce qu\'on nous demande : prouver la formule de sommation pour l\'indicatrice d\'Euler.\n\n'
                  'Rappel : \$\\varphi(n) = |\\{k \\in \\{1, \\ldots, n\\} : \\gcd(k, n) = 1\\}|\$ est le nombre d\'entiers premiers avec \$n\$.\n\n'
                  'Partitionnons \$\\{1, 2, \\ldots, n\\}\$ selon \$d = \\gcd(k, n)\$. Pour chaque diviseur \$d | n\$, les entiers \$k \\in \\{1, \\ldots, n\\}\$ tels que \$\\gcd(k, n) = d\$ sont de la forme \$k = dm\$ avec \$\\gcd(m, n/d) = 1\$ et \$1 \\leq m \\leq n/d\$.\n'
                  'Le nombre de tels \$m\$ est \$\\varphi(n/d)\$.\n'
                  'Donc \$n = \\sum_{d | n} \\varphi(n/d)\$. Comme \$d \\mapsto n/d\$ est une bijection des diviseurs de \$n\$, cela donne \$n = \\sum_{d | n} \\varphi(d)\$.\n'
                  'En notation de Dirichlet : \$\\varphi * \\mathbf{1} = \\text{Id}\$ (convolution de Dirichlet).\n'
                  'Par inversion de Möbius : \$\\varphi(n) = \\sum_{d | n} \\mu(d) \\frac{n}{d} = n \\prod_{p | n} (1 - 1/p)\$.\n\n'
                  'Attention : la convolution de Dirichlet est un outil puissant en arithmétique. Elle transforme les identités de sommation en produits de fonctions multiplicatives.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve combinatoire par partition de \$\\{1, \\ldots, n\\}\$.',
            ),
            QuestionAnnale(
              enonce:
                  'Résoudre le système de congruences : '
                  '\$x \\equiv 2 \\pmod{3}\$, \$x \\equiv 3 \\pmod{5}\$, \$x \\equiv 4 \\pmod{7}\$.',
              indication:
                  'Appliquer le théorème des restes chinois (CRT) puisque 3, 5, 7 '
                  'sont deux à deux premiers entre eux.',
              correction:
                  'Ce qu\'on nous demande : résoudre un système de congruences simultanées (restes chinois).\n\n'
                  'Rappel : le théorème des restes chinois dit que si \$m_1, \\ldots, m_k\$ sont deux à deux premiers entre eux, le système \$x \\equiv a_i \\pmod{m_i}\$ a une unique solution modulo \$M = m_1 \\cdots m_k\$.\n\n'
                  'Ici \$M = 3 \\times 5 \\times 7 = 105\$. Posons \$M_1 = 35\$, \$M_2 = 21\$, \$M_3 = 15\$.\n'
                  'Inverses : \$35^{-1} \\pmod{3}\$ : \$35 \\equiv 2 \\pmod{3}\$ et \$2 \\cdot 2 = 4 \\equiv 1 \\pmod{3}\$, donc \$M_1^{-1} \\equiv 2\$.\n'
                  '\$21^{-1} \\pmod{5}\$ : \$21 \\equiv 1 \\pmod{5}\$, donc \$M_2^{-1} \\equiv 1\$.\n'
                  '\$15^{-1} \\pmod{7}\$ : \$15 \\equiv 1 \\pmod{7}\$, donc \$M_3^{-1} \\equiv 1\$.\n'
                  'Solution : \$x \\equiv 2 \\times 35 \\times 2 + 3 \\times 21 \\times 1 + 4 \\times 15 \\times 1 = 140 + 63 + 60 = 263 \\equiv 263 - 2 \\times 105 = 53 \\pmod{105}\$.\n'
                  'Vérification : \$53 = 17 \\times 3 + 2\$ ✓, \$53 = 10 \\times 5 + 3\$ ✓, \$53 = 7 \\times 7 + 4\$ ✓.\n\n'
                  'Attention : vérifiez TOUJOURS votre réponse en substituant dans chaque congruence. C\'est la meilleure façon d\'éviter les erreurs de calcul.',
              points: 3,
              rapportJury:
                  'Le jury attend l\'application systématique du CRT et la vérification finale.',
            ),
            QuestionAnnale(
              enonce:
                  'Montrer qu\'il existe une infinité de nombres premiers.',
              indication:
                  'Utiliser la preuve d\'Euclide : considérer \$N = p_1 p_2 \\cdots p_k + 1\$.',
              correction:
                  'Ce qu\'on nous demande : prouver l\'infinitude de l\'ensemble des nombres premiers (théorème d\'Euclide).\n\n'
                  'Rappel : un nombre premier \$p \\geq 2\$ n\'est divisible que par 1 et \$p\$. Tout entier \$\\geq 2\$ admet un diviseur premier.\n\n'
                  'Par l\'absurde : supposons qu\'il n\'y a qu\'un nombre fini de premiers : \$p_1, p_2, \\ldots, p_k\$.\n'
                  'Considérons \$N = p_1 p_2 \\cdots p_k + 1\$. Comme \$N \\geq 2\$, \$N\$ admet un diviseur premier \$p\$.\n'
                  'Ce \$p\$ doit être l\'un des \$p_i\$ (par hypothèse, ce sont les seuls premiers). Donc \$p_i | N\$.\n'
                  'Mais \$p_i | p_1 \\cdots p_k\$, donc \$p_i | (N - p_1 \\cdots p_k) = 1\$.\n'
                  'Impossible car \$p_i \\geq 2\$. Contradiction !\n'
                  'Donc il existe une infinité de nombres premiers.\n'
                  'Remarque : cette preuve est constructive en un sens : elle montre qu\'on peut toujours trouver un nouveau premier. En pratique, \$N\$ n\'est pas forcément premier lui-même, mais l\'un de ses facteurs premiers est nouveau.\n\n'
                  'Attention : \$p_1 p_2 \\cdots p_k + 1\$ n\'est PAS toujours premier (ex : \$2 \\times 3 \\times 5 \\times 7 \\times 11 \\times 13 + 1 = 30031 = 59 \\times 509\$). C\'est son diviseur premier qui est nouveau.',
              points: 3,
              rapportJury:
                  'Le jury attend la preuve d\'Euclide bien rédigée avec le raisonnement par l\'absurde.',
            ),
          ],
        ),
      ],
    );
  }
}
