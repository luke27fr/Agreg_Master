const Map<String, String> glossaireData = {
  // --- Analyse : Inversion Locale & Séries ---
  'banach': 'Un espace de Banach est un espace vectoriel normé complet (toute suite de Cauchy converge dans cet espace).',
  'isomorphisme': 'Un isomorphisme bicontinu (ou homéomorphisme linéaire) est une application linéaire bijective continue dont la réciproque est continue.',
  'diffeomorphisme': 'Un difféomorphisme est une bijection différentiable dont la réciproque est également différentiable.',
  'jacobienne': 'La matrice jacobienne \$J_f(a)\$ regroupe les dérivées partielles. Son déterminant indique si la transformation préserve localement l\'orientation et le volume.',
  
  'serie_entiere': 'Série de fonctions de la forme \$\\sum a_n z^n\$. Elle converge sur un disque ouvert centré en 0.',
  'rayon': 'Le rayon de convergence \$R\$ est la distance au centre jusqu\'à la première singularité. Dans \$D(0,R)\$, la série converge absolument.',
  'cauchy_hadamard': 'Formule donnant le rayon de convergence : \$1/R = \\lim \\sup |a_n|^{1/n}\$.',
  'holomorphe': 'Une fonction est holomorphe si elle est dérivable au sens complexe en tout point d\'un ouvert (ce qui implique qu\'elle est analytique, donc \$\\mathcal{C}^\\infty\$).',
  'convergence_uniforme': 'La suite de fonctions \$(f_n)\$ converge uniformément vers \$f\$ si la borne supérieure de \$|f_n(x) - f(x)|\$ tend vers 0.',

  // --- Analyse : Hilbert ---
  'hilbert': 'Espace préhilbertien complet. C\'est le cadre idéal pour généraliser la géométrie euclidienne à la dimension infinie.',
  'prehilbertien': 'Espace vectoriel muni d\'un produit scalaire. S\'il n\'est pas complet, c\'est juste un préhilbertien.',
  'projection': 'Si \$F\$ est un sous-espace vectoriel FERMÉ de \$H\$, alors \$H = F \\oplus F^\\perp\$. La projection orthogonale sur \$F\$ est l\'application qui à \$x\$ associe son unique composante dans \$F\$.',
  'convexe': 'Un ensemble \$K\$ est convexe si pour tout \$x,y\$ dans \$K\$, le segment \$[x,y]\$ est entièrement inclus dans \$K\$.',

  // --- Algèbre : Théorème Spectral ---
  'euclidien': 'Espace vectoriel réel de dimension finie muni d\'un produit scalaire.',
  'symetrique': 'Un endomorphisme \$u\$ est symétrique (ou auto-adjoint) si pour tout \$x,y\$ : \$\\langle u(x), y \\rangle = \\langle x, u(y) \\rangle\$.',
  'valeur_propre': 'Un scalaire \$\\lambda\$ est valeur propre de \$u\$ s\'il existe un vecteur non nul \$x\$ tel que \$u(x) = \\lambda x\$.',
  'diagonalisable': 'Un endomorphisme est diagonalisable s\'il existe une base formée de vecteurs propres.',
  'matrice_orthogonale': 'Une matrice \$P\$ est orthogonale si \$P^T P = I_n\$. Ses colonnes forment une base orthonormée.',
};