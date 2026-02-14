import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../models/examen_blanc_model.dart';

class ExamenBlancService extends ChangeNotifier {
  static final ExamenBlancService _instance = ExamenBlancService._internal();
  factory ExamenBlancService() => _instance;
  ExamenBlancService._internal();

  List<ExamenBlanc> _examens = [];
  List<ExamenBlancResult> _results = [];

  List<ExamenBlanc> get examens => _examens;
  List<ExamenBlancResult> get results => _results;

  /// Charge les examens depuis les assets
  Future<void> loadExamens() async {
    try {
      // Pour l'instant, on crée des examens de démonstration
      _examens = _createDemoExamens();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement examens: $e');
    }
  }

  /// Sauvegarde un résultat d'examen
  Future<void> saveResult(ExamenBlancResult result) async {
    _results.insert(0, result);
    if (_results.length > 50) {
      _results = _results.take(50).toList();
    }
    await _saveResults();
    notifyListeners();
  }

  /// Obtient les statistiques
  ExamenBlancStatistics getStatistics() {
    if (_results.isEmpty) {
      return ExamenBlancStatistics(
        totalExamens: 0,
        examensTermines: 0,
        noteMoyenne: 0,
        tempsMoyen: 0,
        repartitionNotes: {},
        meilleurs: [],
      );
    }

    final termines = _results.where((r) => r.termine).toList();
    final noteMoyenne = termines.isEmpty
        ? 0.0
        : termines.map((r) => r.note).reduce((a, b) => a + b) / termines.length;
    final tempsMoyen = termines.isEmpty
        ? 0.0
        : termines.map((r) => r.dureeEffective).reduce((a, b) => a + b) / termines.length;

    // Répartition par tranche
    final repartition = <String, int>{
      '0-5': 0,
      '5-10': 0,
      '10-12': 0,
      '12-14': 0,
      '14-16': 0,
      '16-20': 0,
    };

    for (var result in termines) {
      if (result.note < 5) {
        repartition['0-5'] = repartition['0-5']! + 1;
      } else if (result.note < 10) {
        repartition['5-10'] = repartition['5-10']! + 1;
      } else if (result.note < 12) {
        repartition['10-12'] = repartition['10-12']! + 1;
      } else if (result.note < 14) {
        repartition['12-14'] = repartition['12-14']! + 1;
      } else if (result.note < 16) {
        repartition['14-16'] = repartition['14-16']! + 1;
      } else {
        repartition['16-20'] = repartition['16-20']! + 1;
      }
    }

    // Meilleurs résultats
    final meilleurs = List<ExamenBlancResult>.from(termines)
      ..sort((a, b) => b.note.compareTo(a.note));

    return ExamenBlancStatistics(
      totalExamens: _results.length,
      examensTermines: termines.length,
      noteMoyenne: noteMoyenne,
      tempsMoyen: tempsMoyen,
      repartitionNotes: repartition,
      meilleurs: meilleurs.take(5).toList(),
    );
  }

  // Persistance
  Future<void> loadResults() async {
    try {
      final content = await StorageService.instance.read('examen_blanc_results.json');
      if (content != null) {
        final data = jsonDecode(content) as List<dynamic>;
        _results = data
            .map((e) => ExamenBlancResult.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement résultats: $e');
    }
  }

  Future<void> _saveResults() async {
    try {
      final data = _results.map((e) => e.toJson()).toList();
      await StorageService.instance.write('examen_blanc_results.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde résultats: $e');
    }
  }

  /// Crée des examens de démonstration
  List<ExamenBlanc> _createDemoExamens() {
    return [
      // ========== ALGÈBRE ==========
      ExamenBlanc(
        id: 'algebre_1',
        titre: 'Composition Algèbre et Géométrie - Sujet 1',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Espaces vectoriels et applications linéaires',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit E un espace vectoriel de dimension finie. Montrer qu\'un endomorphisme u est injectif si et seulement si il est surjectif.',
                indication: 'Utilisez le théorème du rang.',
                correction: 'Si u est injectif, alors dim(Ker(u)) = 0. Par le théorème du rang, dim(Im(u)) = dim(E), donc u est surjectif.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer la matrice de l\'application linéaire f: R³ → R² définie par f(x,y,z) = (x+y, 2y-z).',
                correction: 'Dans les bases canoniques, la matrice est Mat(f) = [[1,1,0],[0,2,-1]]. En effet, f(1,0,0) = (1,0), f(0,1,0) = (1,2), f(0,0,1) = (0,-1).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le rang de cette application.',
                correction: 'Les deux lignes de la matrice sont indépendantes donc rg(f) = 2. On peut aussi voir que Im(f) = R² donc rg(f) = dim(Im(f)) = 2.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Réduction des endomorphismes',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit A la matrice [[2,1],[0,2]]. Calculer les valeurs propres de A.',
                correction: 'χ_A(X) = det(A - XI) = det([[2-X,1],[0,2-X]]) = (2-X)² = 0. Donc λ = 2 est valeur propre double.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'A est-elle diagonalisable ? Justifier.',
                indication: 'Vérifiez la dimension des espaces propres.',
                correction: 'E_2 = ker(A-2I) = ker([[0,1],[0,0]]) = Vect((1,0)). Donc dim(E_2) = 1 < 2 (multiplicité). A n\'est pas diagonalisable.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer la forme de Jordan de A.',
                correction: 'A est déjà en forme de Jordan : J = [[2,1],[0,2]]. C\'est un bloc de Jordan de taille 2 pour λ=2.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Produit scalaire et orthogonalité',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Soit E = R³ muni du produit scalaire canonique. Déterminer le projeté orthogonal du vecteur (1,2,3) sur le plan x+y+z=0.',
                correction: 'P⊥ = Vect(n) où n = (1,1,1). proj_n(v) = ⟨v,n⟩/‖n‖² · n = 6/3 · (1,1,1) = (2,2,2). Donc proj_P(v) = v - proj_n(v) = (1,2,3) - (2,2,2) = (-1,0,1). Vérif : -1+0+1 = 0 ✓',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer la distance de ce vecteur au plan.',
                correction: 'd(v,P) = ‖proj_n(v)‖ = ‖(2,2,2)‖ = 2√3.',
                points: 2,
              ),
            ],
          ),
        ],
      ),
      ExamenBlanc(
        id: 'analyse_1',
        titre: 'Composition Analyse et Probabilités - Sujet 1',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Suites et séries',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Étudier la convergence de la série ∑(1/n²).',
                indication: 'Comparez avec une série de Riemann.',
                correction: 'C\'est une série de Riemann avec α = 2 > 1, donc elle converge. On peut aussi comparer avec ∫₁^∞ dx/x² = 1 (convergent).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Montrer que la suite u_n = ∑_{k=1}^n 1/k - ln(n) converge.',
                correction: 'u_{n+1} - u_n = 1/(n+1) - ln((n+1)/n) = 1/(n+1) - ln(1 + 1/n) > 0 par concavité de ln. Donc (u_n) croissante. De plus, ∫ₖ^{k+1} dx/x ≤ 1/k ≤ ∫_{k-1}^k dx/x donne ln(n) ≤ u_n ≤ 1 + ln(n), donc (u_n) bornée. Par théorème de convergence monotone, u_n → γ (constante d\'Euler ≈ 0.577).',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Fonctions de plusieurs variables',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x,y) = x²y + y³. Calculer le gradient de f.',
                correction: '∇f = (∂f/∂x, ∂f/∂y) = (2xy, x² + 3y²).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Déterminer les points critiques de f.',
                correction: '∇f = 0 ⟺ 2xy = 0 et x² + 3y² = 0. Donc x = 0 et y = 0. Point critique : (0,0).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Étudier leur nature (minimum, maximum, point selle).',
                indication: 'Utilisez la matrice hessienne.',
                correction: 'Hessienne : H = [[2y, 2x],[2x, 6y]]. En (0,0) : H = [[0,0],[0,0]]. det(H) = 0, test non conclusif. Étude directe : f(x,0) = 0, f(0,y) = y³ change de signe. Donc (0,0) est un point selle.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Intégration',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Calculer ∫₀^∞ e^(-x²) dx.',
                indication: 'Utilisez une intégrale double.',
                correction: 'Posons I = ∫₀^∞ e^(-x²)dx. Alors I² = (∫₀^∞ e^(-x²)dx)(∫₀^∞ e^(-y²)dy) = ∫∫_{ℝ₊²} e^(-(x²+y²))dxdy. En coordonnées polaires (r,θ) avec x²+y²=r², on obtient I² = ∫₀^(π/2) ∫₀^∞ e^(-r²)r dr dθ = (π/2)·(1/2) = π/4. Donc I = √(π/4) = √π/2.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'En déduire la valeur de ∫₀^∞ x²e^(-x²) dx.',
                correction: 'Par intégration par parties avec u=x et v\'=xe^(-x²), on a ∫₀^∞ x²e^(-x²)dx = [-x·e^(-x²)/2]₀^∞ + (1/2)∫₀^∞ e^(-x²)dx = 0 + (1/2)·(√π/2) = √π/4.',
                points: 3,
              ),
            ],
          ),
        ],
      ),
      
      // ALGÈBRE 2
      ExamenBlanc(
        id: 'algebre_2',
        titre: 'Composition Algèbre et Géométrie - Sujet 2',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Théorie des groupes',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit G un groupe d\'ordre 28. Montrer que G possède un sous-groupe distingué non trivial.',
                indication: 'Utiliser les théorèmes de Sylow.',
                pointsCles: ['n₇ = 1 ou 8', 'Si n₇=1, le 7-Sylow est distingué'],
                correction: '28 = 4×7 = 2²×7. Par Sylow, n₇ ≡ 1 (mod 7) et n₇ | 4. Donc n₇ ∈ {1,8}. Si n₇=8, il y aurait 8×6=48 éléments d\'ordre 7 (impossible car |G|=28). Donc n₇=1, et l\'unique 7-Sylow est distingué (normalisé par tout G).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'En déduire que G n\'est pas simple.',
                correction: 'G possède un sous-groupe distingué H d\'ordre 7 (le 7-Sylow). Comme {e} ⊊ H ⊊ G, G n\'est pas simple (définition : un groupe simple n\'a pas de sous-groupe distingué non trivial).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Polynômes et réduction',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Déterminer le polynôme minimal de A = [[0,1,0],[0,0,1],[1,0,0]].',
                indication: 'Calculer A², A³.',
                correction: 'A² = [[0,0,1],[1,0,0],[0,1,0]] et A³ = I₃. Donc A³ - I = 0, et X³-1 annule A. Comme A ≠ I, le polynôme minimal divise X³-1 et deg ≥ 2. Vérifions A²+A+I : [[1,1,1],[1,1,1],[1,1,1]] ≠ 0. Donc πₐ(X) = X³-1.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'A est-elle diagonalisable sur ℝ ? Sur ℂ ?',
                correction: 'Sur ℝ : χₐ(X) = X³-1 = (X-1)(X²+X+1). X²+X+1 n\'a pas de racines réelles (Δ=-3<0). Donc A a une seule valeur propre réelle (λ=1) de multiplicité 1. A n\'est PAS diagonalisable sur ℝ. Sur ℂ : X³-1 = (X-1)(X-j)(X-j²) où j=e^(2iπ/3). Trois valeurs propres distinctes, donc A est diagonalisable sur ℂ.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Interpréter géométriquement A.',
                indication: 'Permutation circulaire des coordonnées.',
                correction: 'A(x,y,z) = (y,z,x). C\'est une permutation circulaire : x→y, y→z, z→x. Géométriquement, c\'est une rotation d\'ordre 3 autour de l\'axe (1,1,1) (grande diagonale du cube). A³ = I car 3 rotations de 120° = tour complet.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Formes quadratiques',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Déterminer la signature de q(x,y,z) = x² + 2xy + 2y² - 2yz + z².',
                indication: 'Diagonaliser ou Gauss.',
                correction: 'Méthode de Gauss : q(x,y,z) = (x+y)² + (y-z)² = X² + Y² avec X=x+y, Y=y-z. Signature (2,0,1) : 2 termes positifs, 0 négatif, 1 variable manquante (z n\'apparaît qu\'après changement). Autre méthode : matrice M = [[1,1,0],[1,2,-1],[0,-1,1]], calculer valeurs propres.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'La forme est-elle définie positive ?',
                correction: 'Non. Signature (2,0,1) signifie qu\'il y a une direction dégénérée (noyau non trivial). Pour être définie positive, il faudrait signature (3,0,0). Contre-exemple : si z = y-x, alors q(x,y,z) = (x+y)² + 0 = (x+y)², qui s\'annule pour x=-y ≠ 0.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // ALGÈBRE 3
      ExamenBlanc(
        id: 'algebre_3',
        titre: 'Problème d\'Algèbre - Matrices de Hankel',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Partie A - Propriétés générales',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Soit H_n la matrice de Hankel : H[i,j] = a_{i+j}. Montrer que H est symétrique si aₖ = a₋ₖ.',
                correction: 'H[i,j] = a_{i+j} et H[j,i] = a_{j+i} = a_{i+j} (addition commutative). Donc H^T = H, la matrice est symétrique sans condition sur les aₖ. (La condition aₖ = a₋ₖ est en fait toujours vérifiée pour les indices positifs d\'une matrice de Hankel standard.)',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le rang de H₃ = [[1,2,3],[2,3,4],[3,4,5]].',
                indication: 'Les lignes sont liées.',
                correction: 'Observons que L₂ - L₁ = [1,1,1] et L₃ - L₂ = [1,1,1]. Donc L₃ = 2L₂ - L₁. Les lignes sont liées linéairement. De plus, L₁ et L₂ sont indépendantes (non proportionnelles). Donc rg(H₃) = 2. Vérification : det(H₃) = 1(15-16) - 2(10-12) + 3(8-9) = -1+4-3 = 0, confirmant rg < 3.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Partie B - Diagonalisation',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Pour la suite aₖ = 1/(k+1), étudier la diagonalisabilité de H_n.',
                correction: 'H_n est une matrice de Hankel symétrique réelle, donc diagonalisable (théorème spectral). Les valeurs propres sont toutes réelles et il existe une base orthonormée de vecteurs propres. Pour calculer explicitement les valeurs propres, on peut utiliser la décomposition H = VDV^T où V est une matrice de Vandermonde associée.',
                points: 5,
              ),
              QuestionExamen(
                enonce: 'Calculer det(H_n) pour n = 2, 3, 4.',
                indication: 'Remarquer une structure récurrente.',
                correction: 'H₂ = [[1,1/2],[1/2,1/3]], det = 1/3 - 1/4 = 1/12. H₃ (calculé précédemment) : det = 0 car rg=2<3. H₄ : En développant (calculs longs), det(H₄) ≈ 0. Structure : les matrices de Hankel pour aₖ=1/(k+1) ont souvent un rang déficient pour n grand (suite harmonique décroît lentement).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Partie C - Applications',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que toute matrice de Hankel peut s\'écrire comme produit de Vandermonde.',
                indication: 'H = VDV^T où V est Vandermonde.',
                correction: 'Soit H[i,j] = a_{i+j}. On peut décomposer H = VDV^T où V est la matrice de Vandermonde V[i,j] = xⱼⁱ et D est diagonale. Les coefficients aₖ sont liés aux moments μₖ = Σ dᵢxᵢᵏ. Cette décomposition relie les matrices de Hankel à l\'interpolation et aux moments de mesures.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Application à l\'interpolation polynomiale.',
                correction: 'Les matrices de Hankel apparaissent dans les problèmes de moments : étant donnés μ₀, μ₁, ..., μ₂ₙ, existe-t-il une mesure telle que μₖ = ∫xᵏdμ(x) ? La condition nécessaire et suffisante est que la matrice de Hankel H[i,j]=μ_{i+j} soit semi-définie positive (critère de positivité des moments).',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // ANALYSE 2
      ExamenBlanc(
        id: 'analyse_2',
        titre: 'Composition Analyse et Probabilités - Sujet 2',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Séries de Fourier',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Calculer les coefficients de Fourier de f(x) = |x| sur [-π,π].',
                indication: 'Fonction paire, donc bₙ = 0.',
                correction: 'f paire ⟹ bₙ = 0. a₀ = (1/π)∫₀^π x dx = π/2. aₙ = (2/π)∫₀^π x cos(nx)dx. IPP : aₙ = (2/π)[x sin(nx)/n]₀^π - (2/πn)∫₀^π sin(nx)dx = 0 + (2/πn²)[cos(nx)]₀^π = (2/πn²)(cos(nπ)-1). Si n pair : aₙ=0. Si n impair : aₙ = -4/(πn²).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Montrer que la série de Fourier converge uniformément vers f.',
                indication: 'f est C¹ par morceaux.',
                correction: 'f est continue sur [-π,π] et C¹ par morceaux (dérivable sauf en 0). Par le théorème de Dirichlet, la série de Fourier converge ponctuellement vers f. De plus, |aₙ| = 4/(πn²) = O(1/n²), série absolument convergente. Par convergence normale, la série converge uniformément vers f.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'En déduire que ∑_{k impair} 1/k² = π²/8.',
                correction: 'f(x) = π/2 + Σ_{n impair} [-4/(πn²)]cos(nx). En x=0 : |0| = 0 = π/2 - (4/π)Σ_{n impair} 1/n². Donc Σ_{n impair} 1/n² = π²/8. (Formule classique : ζ(2) = π²/6, et Σ_{pair} 1/n² = (1/4)ζ(2) = π²/24, donc Σ_{impair} = π²/6 - π²/24 = π²/8.)',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Équations différentielles',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Résoudre y\'\' - 2y\' + y = x·e^x.',
                indication: 'Racine double r=1.',
                correction: 'Équation caractéristique : r² - 2r + 1 = 0 ⟹ r = 1 (double). Solution homogène : y_h = (C₁ + C₂x)e^x. Pour une solution particulière, racine double ⟹ chercher y_p = (ax³)e^x. Dérivées : y\'_p = (3ax² + ax³)e^x, y"_p = (6ax + 6ax² + ax³)e^x. Substitution : (6ax + 6ax² + ax³ - 6ax² - 2ax³ + ax³)e^x = xe^x ⟹ 6ax = x ⟹ a = 1/6. Solution générale : y = (C₁ + C₂x + x³/6)e^x.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Résoudre le problème de Cauchy avec y(0)=1, y\'(0)=0.',
                correction: 'y(0) = C₁ = 1. y\'(x) = [C₂ + C₂x + x²/2 + (C₁ + C₂x + x³/6)]e^x. y\'(0) = C₂ + C₁ = C₂ + 1 = 0 ⟹ C₂ = -1. Solution : y(x) = (1 - x + x³/6)e^x.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Probabilités - Loi normale',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'X ~ N(μ,σ²). Calculer E[(X-μ)⁴].',
                indication: 'Utiliser la fonction génératrice des moments.',
                correction: 'Posons Z = (X-μ)/σ ~ N(0,1). Alors E[(X-μ)⁴] = σ⁴E[Z⁴]. Pour Z ~ N(0,1), E[Z⁴] = ∫ z⁴ (1/√2π)e^(-z²/2)dz. Par IPP répétées ou formule des moments : E[Z^(2k)] = (2k-1)!! = (2k)!/(2^k k!). Donc E[Z⁴] = 3. Résultat : E[(X-μ)⁴] = 3σ⁴.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Application : coefficient d\'aplatissement (kurtosis).',
                correction: 'Le coefficient d\'aplatissement (kurtosis) est défini par Kurt(X) = E[(X-μ)⁴]/σ⁴ - 3. Pour X ~ N(μ,σ²), Kurt(X) = 3σ⁴/σ⁴ - 3 = 0. La loi normale a un kurtosis nul (référence). Kurtosis > 0 : distribution leptokurtique (queues épaisses, pic étroit). Kurtosis < 0 : platykurtique (queues fines, pic aplati).',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // ANALYSE 3
      ExamenBlanc(
        id: 'analyse_3',
        titre: 'Problème d\'Analyse - Espaces de Hilbert',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Partie I - Projection orthogonale',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit H espace de Hilbert, F sous-espace fermé. Montrer que tout x ∈ H s\'écrit uniquement x = y + z avec y ∈ F, z ∈ F⊥.',
                indication: 'Minimiser ‖x - y‖ pour y ∈ F.',
                correction: 'Existence : Soit y = proj_F(x) le projeté orthogonal (minimise ‖x-y‖). Alors z = x - y vérifie ⟨z, f⟩ = 0 pour tout f ∈ F (condition d\'orthogonalité), donc z ∈ F⊥. Unicité : Si x = y₁ + z₁ = y₂ + z₂, alors y₁-y₂ = z₂-z₁ ∈ F ∩ F⊥ = {0}. Donc y₁=y₂ et z₁=z₂.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Montrer que P_F : x ↦ y est une application linéaire continue.',
                correction: 'Linéarité : P_F(αx + βx\') = αP_F(x) + βP_F(x\') car la projection minimise une norme (fonction convexe). Continuité : ‖P_F(x)‖ ≤ ‖x‖ (la projection ne peut qu\'augmenter la distance à 0 ou la diminuer). Donc ‖P_F‖ ≤ 1, P_F est continue.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Partie II - Bases hilbertiennes',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit (eₙ) système orthonormal. Montrer que pour tout x, ∑|⟨x,eₙ⟩|² ≤ ‖x‖² (Bessel).',
                correction: 'Soit S_N = Σ_{n=1}^N ⟨x,eₙ⟩eₙ la somme partielle. C\'est le projeté de x sur Vect(e₁,...,e_N). Par Pythagore : ‖x‖² = ‖S_N‖² + ‖x-S_N‖² ≥ ‖S_N‖² = Σ_{n=1}^N |⟨x,eₙ⟩|². En passant à la limite N→∞ : Σ|⟨x,eₙ⟩|² ≤ ‖x‖² (inégalité de Bessel).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Caractériser les bases hilbertiennes via l\'égalité de Parseval.',
                correction: '(eₙ) est une base hilbertienne ⟺ Vect(eₙ) est dense dans H ⟺ égalité de Parseval : ‖x‖² = Σ|⟨x,eₙ⟩|² pour tout x. Autrement dit, l\'inégalité de Bessel devient une égalité ⟺ le projeté orthogonal sur Vect(eₙ) = x lui-même ⟺ densité.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Partie III - Application aux séries de Fourier',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que (e^{inx})_{n∈ℤ} est une base hilbertienne de L²([-π,π]).',
                correction: 'Produit scalaire : ⟨f,g⟩ = (1/2π)∫_{-π}^π f(x)g̅(x)dx. Orthonormalité : ⟨e^{imx}, e^{inx}⟩ = (1/2π)∫_{-π}^π e^{i(m-n)x}dx = δ_{mn}. Densité : Les polynômes trigonométriques (combinaisons finies de e^{inx}) sont denses dans C([-π,π]) par théorème de Weierstrass trigonométrique, et C dense dans L². Donc Vect(e^{inx}) dense dans L², c\'est une base hilbertienne.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'En déduire Parseval pour les séries de Fourier.',
                correction: 'Égalité de Parseval : ‖f‖²_{L²} = Σ_{n∈ℤ} |cₙ|² où cₙ = ⟨f, e^{inx}⟩. En termes de coefficients réels : (1/π)∫_{-π}^π |f(x)|²dx = a₀²/2 + Σ_{n≥1} (aₙ² + bₙ²). Identité fondamentale pour les séries de Fourier.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // MODÉLISATION A
      ExamenBlanc(
        id: 'modelisation_a_1',
        titre: 'Modélisation Option A - Probabilités et Statistiques',
        type: 'modelisation',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Modélisation d\'un processus de files d\'attente',
            bareme: 10,
            questions: [
              QuestionExamen(
                enonce: 'Modéliser une file M/M/1 : arrivées Poisson(λ), service Exp(μ).',
                indication: 'Chaîne de Markov à temps continu.',
                correction: 'État = nombre de clients dans le système (N(t) ∈ ℕ). Transitions : N(t) → N(t)+1 avec taux λ (arrivée), N(t) → N(t)-1 avec taux μ (service si N>0). Équations de balance détaillée en régime stationnaire πₙ : λπₙ = μπₙ₊₁ pour n≥0. Solution : πₙ = ρⁿπ₀ où ρ=λ/μ. Normalisation Σπₙ=1 donne π₀=1-ρ (si ρ<1).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer la condition de stabilité ρ = λ/μ < 1.',
                correction: 'Pour que Σπₙ < ∞, il faut Σρⁿ < ∞, soit ρ < 1. Interprétation : λ/μ < 1 ⟺ taux d\'arrivée < taux de service. Si ρ ≥ 1, la file explose (pas de loi stationnaire). Condition nécessaire et suffisante : ρ = λ/μ < 1.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le nombre moyen de clients dans le système.',
                indication: 'Loi stationnaire géométrique.',
                correction: 'E[N] = Σ n·πₙ = Σ n·ρⁿ(1-ρ) = (1-ρ)·ρ·Σ n·ρⁿ⁻¹ = (1-ρ)·ρ/(1-ρ)² = ρ/(1-ρ) = λ/(μ-λ). Résultat classique pour M/M/1.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Temps moyen d\'attente (formule de Little).',
                correction: 'Formule de Little : E[N] = λ·E[T] où E[T] = temps moyen dans le système. Donc E[T] = E[N]/λ = [λ/(μ-λ)]/λ = 1/(μ-λ). Temps moyen d\'attente dans la queue : E[W] = E[T] - 1/μ = λ/(μ(μ-λ)).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Régression linéaire',
            bareme: 10,
            questions: [
              QuestionExamen(
                enonce: 'Données (xᵢ,yᵢ) pour i=1..n. Déterminer a,b minimisant ∑(yᵢ - axᵢ - b)².',
                indication: 'Dériver par rapport à a et b.',
                correction: 'Posons S(a,b) = Σ(yᵢ - axᵢ - b)². ∂S/∂b = -2Σ(yᵢ - axᵢ - b) = 0 ⟹ nb = Σyᵢ - aΣxᵢ ⟹ b = ȳ - ax̄. ∂S/∂a = -2Σxᵢ(yᵢ - axᵢ - b) = 0 ⟹ aΣxᵢ² + b Σxᵢ = Σxᵢyᵢ. En substituant b : a = [Σxᵢyᵢ - nx̄ȳ]/[Σxᵢ² - nx̄²] = Cov(X,Y)/Var(X).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Calculer le coefficient de corrélation R².',
                correction: 'R² = 1 - SSR/SST où SSR = Σ(yᵢ - ŷᵢ)² (résidus), SST = Σ(yᵢ - ȳ)² (variance totale). Équivalent : R² = [Cov(X,Y)]²/(Var(X)Var(Y)) = r² (carré du coefficient de corrélation linéaire de Pearson). R² ∈ [0,1], proche de 1 = bon ajustement.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Application numérique : données fournies.',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // ALGÈBRE 4 - Groupes finis
      ExamenBlanc(
        id: 'algebre_4',
        titre: 'Problème - Groupes Finis et Actions',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Actions de groupes',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit G groupe fini agissant sur X. Montrer la formule des classes : |X| = |X^G| + ∑[G:G_x].',
                indication: 'Partitionner X en orbites.',
                correction: 'X se partitionne en orbites disjointes : X = ⊔ Orb(x). Pour x ∉ X^G (points non fixes), |Orb(x)| = [G:G_x] (théorème orbite-stabilisateur). Pour x ∈ X^G, |Orb(x)| = 1. Donc |X| = |X^G| + Σ_{x∉X^G} [G:G_x]. En regroupant par orbites distinctes : |X| = |X^G| + Σ_{orbites non triviales} [G:G_x].',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Application : montrer qu\'un p-groupe non trivial a un centre non trivial.',
                indication: 'Action par conjugaison.',
                correction: 'Action par conjugaison : g·x = gxg⁻¹. X^G = Z(G) (centre). G_x = {g : gx=xg} (centralisateur). Formule : |G| = |Z(G)| + Σ[G:G_x]. Chaque [G:G_x] divise |G| = pⁿ (Lagrange), donc [G:G_x] = p^k avec k≥1 (orbites non triviales). Comme |G| ≡ 0 (mod p), on a |Z(G)| ≡ 0 (mod p). Or e ∈ Z(G), donc |Z(G)| ≥ p. Centre non trivial.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Groupes simples',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Montrer qu\'il n\'existe pas de groupe simple d\'ordre 30.',
                indication: 'Sylow : n₅ = 1 ou 6, n₃ = 1 ou 10.',
                correction: '30 = 2·3·5. Par Sylow : n₅ ≡ 1 (mod 5) et n₅ | 6, donc n₅ ∈ {1,6}. n₃ ≡ 1 (mod 3) et n₃ | 10, donc n₃ ∈ {1,10}. Si n₅=1, le 5-Sylow est distingué ⟹ G non simple. Si n₅=6 et n₃=10 : 6·4=24 éléments d\'ordre 5 (6 Sylow de cardinal 5), 10·2=20 éléments d\'ordre 3. Total 24+20+1=45 > 30 : contradiction. Donc n₃=1 ou n₅=1 ⟹ sous-groupe distingué non trivial.',
                points: 5,
              ),
              QuestionExamen(
                enonce: 'Même question pour l\'ordre 56.',
                correction: '56 = 8·7 = 2³·7. n₇ ≡ 1 (mod 7) et n₇ | 8, donc n₇ ∈ {1,8}. Si n₇=1, le 7-Sylow est distingué. Si n₇=8 : 8·6=48 éléments d\'ordre 7. Reste 56-48=8 places. Le 2-Sylow (ordre 8) est unique ⟹ distingué. Donc G toujours non simple.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Produits semi-directs',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Combien y a-t-il de groupes non isomorphes d\'ordre 6 ?',
                indication: 'ℤ/6ℤ et S₃ = ℤ/3ℤ ⋊ ℤ/2ℤ.',
                correction: 'Deux groupes à isomorphisme près : (1) ℤ/6ℤ (cyclique, abélien). (2) S₃ (groupe symétrique, non abélien). S₃ ≅ ℤ/3ℤ ⋊ ℤ/2ℤ (produit semi-direct) avec action φ: ℤ/2ℤ → Aut(ℤ/3ℤ) non triviale (φ(1) = inversion).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Décrire explicitement le produit semi-direct.',
                correction: 'G = N ⋊_φ H avec N = ℤ/3ℤ = ⟨a⟩, H = ℤ/2ℤ = ⟨b⟩. Loi : (n₁,h₁)·(n₂,h₂) = (n₁ + φ(h₁)(n₂), h₁+h₂). Ici φ(b)(a) = a⁻¹ = −a. Donc ba = a²b. Présentation : S₃ = ⟨a,b | a³=b²=1, bab=a²⟩.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // ANALYSE 4 - Calcul différentiel
      ExamenBlanc(
        id: 'analyse_4',
        titre: 'Problème - Calcul Différentiel et Optimisation',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Différentiabilité',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x,y) = xy²/(x²+y²) si (x,y) ≠ (0,0), f(0,0) = 0. f est-elle différentiable en (0,0) ?',
                indication: 'Calculer les dérivées partielles puis vérifier la définition.',
                correction: '∂f/∂x(0,0) = lim_{h→0} [f(h,0)-f(0,0)]/h = 0. ∂f/∂y(0,0) = lim_{h→0} [f(0,h)-f(0,0)]/h = 0. Reste : [f(h,k) - f(0,0) - 0·h - 0·k]/√(h²+k²) = hk²/[(h²+k²)^(3/2)]. Sur y=x : |x³|/|x|³ = 1 ↛ 0. Donc f NON différentiable en (0,0).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'f est-elle de classe C¹ ?',
                indication: 'Les dérivées partielles sont-elles continues ?',
                correction: 'Non, car si f n\'est pas différentiable en (0,0), elle ne peut pas être C¹. (Rappel : C¹ ⟹ différentiable). De plus, on peut vérifier que ∂f/∂x n\'est pas continue en (0,0) en calculant explicitement ∂f/∂x(x,y) pour (x,y) ≠ (0,0).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Extrema liés',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Minimiser f(x,y,z) = x² + y² + z² sous la contrainte x + 2y + 3z = 6.',
                indication: 'Multiplicateurs de Lagrange.',
                correction: 'Lagrangien : L = x²+y²+z² - λ(x+2y+3z-6). ∇L = 0 : 2x=λ, 2y=2λ, 2z=3λ, x+2y+3z=6. Donc x=λ/2, y=λ, z=3λ/2. Contrainte : λ/2 + 2λ + 9λ/2 = 6 ⟹ 7λ = 6 ⟹ λ = 6/7. Solution : (x,y,z) = (3/7, 6/7, 9/7). Valeur min : f = 9/49 + 36/49 + 81/49 = 126/49 = 18/7.',
                points: 5,
              ),
              QuestionExamen(
                enonce: 'Vérifier que c\'est bien un minimum.',
                indication: 'Hessienne restreinte.',
                correction: 'La hessienne de f est H = 2I (définie positive). Sur la contrainte (sous-espace affine), la restriction est encore définie positive. Donc c\'est un minimum local. Comme f(x,y,z) → +∞ quand ‖(x,y,z)‖ → ∞, c\'est un minimum global sur la contrainte.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème d\'inversion locale',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit F(x,y) = (e^x cos y, e^x sin y). Montrer que F est un difféomorphisme local en tout point.',
                indication: 'Jacobienne inversible.',
                correction: 'JF = [[e^x cos y, −e^x sin y], [e^x sin y, e^x cos y]]. det(JF) = e^(2x)(cos²y + sin²y) = e^(2x) > 0. F est C^∞ et det(JF) ≠ 0 partout. Par le théorème d\'inversion locale, F est un difféomorphisme local en tout point.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'F est-il un difféomorphisme global ?',
                correction: 'Non. F n\'est pas injective : F(x,y) = F(x,y+2π) car cos et sin sont 2π-périodiques. Donc F n\'est pas un difféomorphisme global sur ℝ². (C\'est un revêtement universel : ℝ² → ℝ²\\{0} via coordonnées polaires.)',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // ANALYSE 5 - Séries
      ExamenBlanc(
        id: 'analyse_5',
        titre: 'Problème - Séries Entières et Fonctions Analytiques',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Rayon de convergence',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Déterminer le rayon de convergence de ∑(n!)²/(2n)! · x^n.',
                indication: 'D\'Alembert ou formule de Stirling.',
                correction: 'Posons uₙ = (n!)²/(2n)!. uₙ₊₁/uₙ = [(n+1)!]²/(2n+2)! · (2n)!/(n!)² = (n+1)²/[(2n+2)(2n+1)] → 1/4 quand n→∞. Par d\'Alembert, R = 4. (Vérification Stirling : uₙ ~ 1/(πn) · (1/4)ⁿ, confirme R=4.)',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Que se passe-t-il sur le bord du disque de convergence ?',
                correction: 'Sur |x|=4, série ∑uₙ·4ⁿ = ∑(n!)²/(2n)!·4ⁿ ~ ∑1/(πn) (par Stirling). Cette série diverge (série harmonique). Donc convergence seulement pour |x| < 4, divergence pour |x| ≥ 4.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Équations fonctionnelles',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x) = ∑aₙx^n vérifiant f(x) = x + f(x)². Déterminer les aₙ.',
                indication: 'Identifier les coefficients.',
                correction: 'f = x + f² ⟹ a₀ + a₁x + a₂x² + ... = x + (a₀ + a₁x + ...)². Identification : a₀=a₀², a₁=1+2a₀a₁, a₂=a₁²+2a₀a₂, aₙ=Σaᵢaⱼ (i+j=n). a₀=0 ou 1. Si a₀=0 : a₁=1, a₂=1, aₙ = Cₙ = n-ième nombre de Catalan = (2n)!/[n!(n+1)!]. (Nombres de Catalan : C₀=1, Cₙ₊₁=ΣCᵢCₙ₋ᵢ.)',
                points: 5,
              ),
              QuestionExamen(
                enonce: 'Montrer que f(x) = (1 - √(1-4x))/2.',
                indication: 'Résoudre l\'équation du second degré.',
                correction: 'f = x + f² ⟹ f² - f + x = 0. Solutions : f = [1 ± √(1-4x)]/2. Comme f(0)=0 (série sans terme constant), on prend f = [1 - √(1-4x)]/2. Développement en série : √(1-4x) = 1 - 2x - 2x² - ... donne f(x) = x + x² + 2x³ + 5x⁴ + ... (Catalan).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Développement en série entière',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Développer arctan(x) en série entière.',
                indication: 'Intégrer 1/(1+t²).',
                correction: '1/(1+t²) = Σ(-1)ⁿt^(2n) pour |t|<1. Intégration terme à terme : arctan(x) = ∫₀ˣ dt/(1+t²) = Σ(-1)ⁿ∫₀ˣ t^(2n)dt = Σ(-1)ⁿx^(2n+1)/(2n+1). Rayon : R=1 (rayon de 1/(1+t²)).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'En déduire que π/4 = ∑(-1)^n/(2n+1).',
                correction: 'arctan(1) = π/4. La série converge en x=1 par critère de Leibniz (série alternée décroissante). Donc π/4 = Σ_{n=0}^∞ (-1)ⁿ/(2n+1) = 1 - 1/3 + 1/5 - 1/7 + ... (Formule de Leibniz).',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // PROBABILITÉS 1
      ExamenBlanc(
        id: 'proba_1',
        titre: 'Problème - Lois et Convergences',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Lois usuelles',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que si X ~ Poisson(λ) et Y ~ Poisson(μ) indépendantes, alors X+Y ~ Poisson(λ+μ).',
                indication: 'Fonction génératrice.',
                correction: 'Fonction génératrice : G_X(s) = E[s^X] = e^(λ(s-1)), G_Y(s) = e^(μ(s-1)). Par indépendance : G_{X+Y}(s) = G_X(s)·G_Y(s) = e^(λ(s-1))·e^(μ(s-1)) = e^((λ+μ)(s-1)). C\'est la fonction génératrice de Poisson(λ+μ). Donc X+Y ~ Poisson(λ+μ).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Généraliser à n variables de Poisson.',
                correction: 'Si X₁,...,Xₙ indépendantes avec Xᵢ ~ Poisson(λᵢ), alors X₁+...+Xₙ ~ Poisson(λ₁+...+λₙ). Preuve par récurrence ou fonction génératrice : G(s) = ∏e^(λᵢ(s-1)) = e^((Σλᵢ)(s-1)).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème central limite',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit (Xₙ) iid, E[X₁]=μ, Var(X₁)=σ². Montrer que (Sₙ-nμ)/(σ√n) ⇒ N(0,1).',
                indication: 'TCL classique.',
                correction: 'Sₙ = X₁+...+Xₙ, E[Sₙ]=nμ, Var(Sₙ)=nσ². Posons Zₙ = (Sₙ-nμ)/(σ√n). Par le TCL (Lindeberg-Lévy), Zₙ converge en loi vers N(0,1) quand n→∞. Preuve : fonctions caractéristiques φ_Zₙ(t) → e^(-t²/2).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Application : estimer le nombre de lancers nécessaires pour que P(|S_n/n - 1/2| < 0.01) ≥ 0.95.',
                indication: 'Utiliser l\'approximation normale.',
                correction: 'Lancers équilibrés : μ=1/2, σ²=1/4. P(|Sₙ/n - 1/2| < 0.01) = P(|(Sₙ-n/2)/(√n/2)| < 0.02√n). Par TCL : (Sₙ-n/2)/(√n/2) ≈ N(0,1). Donc P ≈ P(|Z| < 0.02√n) ≥ 0.95 ⟹ 0.02√n ≥ 1.96 ⟹ n ≥ 9604. Il faut environ 10000 lancers.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Loi des grands nombres',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Montrer la LGN forte pour des v.a. bornées.',
                indication: 'Lemme de Borel-Cantelli.',
                correction: 'Pour v.a. bornées |Xᵢ| ≤ M : par Borel-Cantelli, si Σ P(|Sₙ/n - μ| > ε) < ∞, alors P(|Sₙ/n - μ| > ε i.o.) = 0. Par inégalité de Tchebychev : P(|Sₙ/n - μ| > ε) ≤ σ²/(n ε²) ⟹ Σ 1/n < ∞ (faux). Preuve complète via moments d\'ordre 4 et lemme de Kronecker. Résultat : Sₙ/n → μ p.s.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Que peut-on dire de (Sₙ/n - μ) ?',
                correction: 'Par LGN forte, Sₙ/n → μ p.s. Donc Sₙ/n - μ → 0 p.s. (convergence presque sûre). Plus fort que convergence en probabilité (LGN faible).',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // GÉOMÉTRIE 1
      ExamenBlanc(
        id: 'geometrie_1',
        titre: 'Problème - Géométrie Affine et Euclidienne',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Isométries du cube',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Déterminer toutes les isométries du cube qui laissent le centre fixe.',
                indication: 'Groupe octaédral.',
                correction: 'Groupe des isométries du cube = groupe octaédral O. Ordre : 48 (24 rotations + 24 réflexions). Rotations : identité, rotations d\'ordre 2 (6 axes arêtes), d\'ordre 3 (4 axes diagonales), d\'ordre 4 (3 axes faces). Total : 1 + 6·1 + 4·2 + 3·2 = 24 rotations. Avec réflexions : |O| = 48.',
                points: 5,
              ),
              QuestionExamen(
                enonce: 'Montrer que ce groupe est isomorphe à S₄.',
                indication: 'Action sur les grandes diagonales.',
                correction: 'Le cube a 4 grandes diagonales (reliant sommets opposés). Toute isométrie permute ces diagonales. On a un morphisme O → S₄. Le noyau contient seulement l\'identité et la symétrie centrale (−Id), d\'ordre 2. Donc O/{±Id} ≅ S₄. Comme |O|=48 et |S₄|=24, on a |O/{±Id}|=24=|S₄|.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Quadriques',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Réduire la quadrique x² + y² - z² = 1.',
                indication: 'Hyperboloïde à une nappe.',
                correction: 'Forme quadratique q = x² + y² - z². Signature (2,1). Type : hyperboloïde à une nappe (surface réglée). Sections : z=k donne x²+y²=1+k² (cercles), x=k donne y²−z²=1−k² (hyperboles). Surface de révolution autour de l\'axe Oz.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Déterminer les génératrices rectilignes.',
                indication: 'Deux familles de droites.',
                correction: 'Factorisation : x²+y²−z² = (x+iy+z)(x−iy−z) sur ℂ. Réel : (x+z)²−y² = (x+z+y)(x+z−y). Paramétrage : D₁(s,t) : (x,y,z) = (1,0,0) + s(−1,1,1) + t(−1,−1,1). D₂(s,t) symétrique. Deux familles de droites sur la surface.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Convexité',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que l\'enveloppe convexe de points est l\'intersection de tous les convexes les contenant.',
                correction: 'Soit A ensemble de points, Conv(A) l\'enveloppe convexe. Conv(A) est convexe et contient A (par définition : plus petit convexe contenant A). Si C convexe avec A ⊆ C, alors Conv(A) ⊆ C (définition du plus petit). Donc Conv(A) = ⋂{C convexe : A ⊆ C}.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Application : enveloppe convexe de {(0,0), (1,0), (0,1)}.',
                correction: 'Conv({(0,0), (1,0), (0,1)}) = triangle de sommets (0,0), (1,0), (0,1). Points : {λ₁(0,0) + λ₂(1,0) + λ₃(0,1) : λᵢ≥0, Σλᵢ=1} = {(x,y) : x,y≥0, x+y≤1}. C\'est le triangle rectangle.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // MIXTE - Algèbre/Analyse
      ExamenBlanc(
        id: 'mixte_1',
        titre: 'Composition Mixte - Polynômes Orthogonaux',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Polynômes de Legendre',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Définir les polynômes de Legendre Pₙ par Gram-Schmidt sur [-1,1] avec ⟨f,g⟩ = ∫₋₁¹ fg.',
                correction: 'Appliquer Gram-Schmidt à (1, x, x², ...). P₀=1, P₁=x, P₂ orthogonal à {1,x}. P₂ = x² + a·x + b avec ⟨P₂,1⟩=0 et ⟨P₂,x⟩=0. Normalisation : Pₙ(1)=1. Récurrence : Pₙ₊₁ = xPₙ - αₙPₙ₋₁ avec αₙ déterminé par orthogonalité.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Montrer que Pₙ vérifie l\'équation (1-x²)P\'\' - 2xP\' + n(n+1)P = 0.',
                indication: 'Formule de Rodrigues.',
                correction: 'Formule de Rodrigues : Pₙ(x) = (1/(2ⁿn!))·(dⁿ/dxⁿ)[(x²-1)ⁿ]. Soit u=(x²-1)ⁿ. u vérifie : (x²-1)u\' = 2nxu. Dériver n fois : (x²-1)v^(n+2) + 2xv^(n+1) - n(n+1)v^n = 0 où v=u^(n). Donc Pₙ vérifie l\'équation différentielle de Legendre.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer P₀, P₁, P₂, P₃.',
                correction: 'P₀(x) = 1, P₁(x) = x, P₂(x) = (3x²-1)/2, P₃(x) = (5x³-3x)/2. Vérification : ⟨P₂,P₀⟩ = ∫(3x²-1)/2 = 0 ✓, ⟨P₂,P₁⟩ = ∫x(3x²-1)/2 = 0 ✓.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Approximation L²',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que les (Pₙ) forment une base orthogonale de L²([-1,1]).',
                correction: 'Les polynômes sont denses dans C([-1,1]) (Weierstrass), donc dans L². (Pₙ) est une famille orthogonale de polynômes de degrés 0,1,2,... Vect(P₀,...,Pₙ) = Vect(1,x,...,xⁿ) = ℝₙ[X]. Par densité et orthogonalité, (Pₙ) forme une base orthogonale de L²([-1,1]).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Approximer f(x) = |x| par un polynôme de degré ≤ 3.',
                indication: 'Projection sur Vect(P₀,P₁,P₂,P₃).',
                correction: 'Projection : p = Σ₀³ cₙPₙ avec cₙ = ⟨f,Pₙ⟩/‖Pₙ‖². ⟨|x|,P₀⟩ = ∫₀¹ x dx ·2 = 1, ⟨|x|,P₁⟩ = 0 (parité), ⟨|x|,P₂⟩ = ..., ⟨|x|,P₃⟩=0. Calculs donnent p(x) ≈ a₀P₀ + a₂P₂ = ... (symétrie : termes pairs seulement).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Zéros et propriétés',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que Pₙ a exactement n racines réelles distinctes dans ]-1,1[.',
                indication: 'Rolle itéré.',
                correction: 'Pₙ est orthogonal à tous les polynômes de degré < n. En particulier, ∫₋₁¹ Pₙ(x)·1 dx = 0. Donc Pₙ change de signe au moins une fois dans ]-1,1[. De même avec xᵏ pour k<n : Pₙ a au moins n changements de signe. Comme deg(Pₙ)=n, Pₙ a exactement n racines réelles distinctes dans ]-1,1[.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Application à la quadrature de Gauss.',
                correction: 'Quadrature de Gauss-Legendre : ∫₋₁¹ f(x)dx ≈ Σwᵢf(xᵢ) où xᵢ sont les racines de Pₙ. Cette formule est exacte pour les polynômes de degré ≤ 2n-1 (théorème : meilleure précision possible avec n points).',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // ANALYSE 6 - Intégration avancée
      ExamenBlanc(
        id: 'analyse_6',
        titre: 'Problème - Intégration et Mesure',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Convergence dominée',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit fₙ(x) = n·sin(x/n) sur [0,π]. Montrer que fₙ → f simplement et calculer lim ∫fₙ.',
                indication: 'sin(u)/u → 1.',
                correction: 'fₙ(x) = n·sin(x/n) = x·[sin(x/n)/(x/n)] → x (car sin(u)/u → 1 quand u→0). Donc fₙ → f(x)=x simplement. ∫₀^π fₙ : par changement u=x/n, ∫₀^π n sin(x/n)dx = n²∫₀^(π/n) sin(u)du = n²[1-cos(π/n)] → π²/2 quand n→∞. ∫f = π²/2.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Peut-on appliquer la convergence dominée ?',
                indication: 'Trouver une fonction dominante.',
                correction: 'Oui. |fₙ(x)| = n|sin(x/n)| ≤ n·|x/n| = x (car |sin(u)| ≤ |u|). Donc |fₙ(x)| ≤ x pour tout n, x. La fonction g(x)=x est intégrable sur [0,π]. Par convergence dominée, lim∫fₙ = ∫f = π²/2.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Intégrales à paramètre',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit F(t) = ∫₀^∞ e^{-tx}·sin(x)/x dx pour t > 0. Montrer que F est C¹.',
                indication: 'Dérivation sous l\'intégrale.',
                correction: '∂/∂t[e^{-tx}sin(x)/x] = -e^{-tx}sin(x). |−e^{-tx}sin(x)| ≤ e^{-tx} intégrable sur [0,∞[ pour t>0. Par théorème de dérivation sous l\'intégrale (Lebesgue), F est C¹ et F\'(t) = -∫₀^∞ e^{-tx}sin(x)dx.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Calculer F\'(t) puis F(t).',
                indication: 'F\'(t) = -∫e^{-tx}sin(x)dx.',
                correction: 'F\'(t) = -∫₀^∞ e^{-tx}sin(x)dx. IPP : = -1/(1+t²) (formule standard). F\'(t) = -1/(1+t²). Intégration : F(t) = -arctan(t) + C. Quand t→∞, F(t)→0, donc C=π/2. Résultat : F(t) = π/2 - arctan(t) = arctan(1/t).',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Fonction Gamma',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que Γ(x+1) = x·Γ(x) pour x > 0.',
                indication: 'IPP.',
                correction: 'Γ(x) = ∫₀^∞ t^{x-1}e^{-t}dt. IPP : Γ(x+1) = ∫₀^∞ t^x e^{-t}dt = [-t^x e^{-t}]₀^∞ + x∫₀^∞ t^{x-1}e^{-t}dt = 0 + x·Γ(x). Formule de récurrence fondamentale.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'En déduire Γ(n+1) = n! pour n ∈ ℕ.',
                correction: 'Γ(1) = ∫₀^∞ e^{-t}dt = 1. Par récurrence : Γ(n+1) = n·Γ(n) = n·(n-1)·...·1·Γ(1) = n!. La fonction Gamma prolonge la factorielle aux réels.',
                points: 1,
              ),
              QuestionExamen(
                enonce: 'Calculer Γ(1/2) = √π.',
                indication: 'Intégrale de Gauss.',
                correction: 'Γ(1/2) = ∫₀^∞ t^{-1/2}e^{-t}dt. Changement u=√t : = 2∫₀^∞ e^{-u²}du = ∫_{-∞}^∞ e^{-u²}du = √π (intégrale de Gauss). Donc Γ(1/2) = √π.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // ALGÈBRE 5 - Arithmétique avancée
      ExamenBlanc(
        id: 'algebre_5',
        titre: 'Problème - Arithmétique et Corps Finis',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Congruences',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Résoudre x² ≡ 1 (mod 8).',
                indication: 'Tester toutes les classes.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Généraliser : pour quels n, x² ≡ 1 (mod n) a-t-il plus de 2 solutions ?',
                indication: 'Théorème chinois.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Petit théorème de Fermat',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Calculer 2^{100} (mod 13).',
                indication: 'Fermat : a^{p-1} ≡ 1 (mod p).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Montrer que si p premier, alors (p-1)! ≡ -1 (mod p) (Wilson).',
                indication: 'Regrouper k et k^{-1}.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Corps finis',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que 𝔽_p* est cyclique.',
                indication: 'Un groupe abélien fini d\'exposant maximum.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Combien y a-t-il de générateurs de 𝔽₁₁* ?',
                indication: 'φ(10) = 4.',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // PROBABILITÉS 2
      ExamenBlanc(
        id: 'proba_2',
        titre: 'Composition - Statistiques et Estimation',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Estimateurs',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Échantillon (X₁,...,Xₙ) de loi U([0,θ]). Proposer un estimateur de θ.',
                indication: 'Maximum de vraisemblance : θ̂ = max Xᵢ.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Cet estimateur est-il sans biais ? Calculer son biais.',
                indication: 'E[max Xᵢ] = n·θ/(n+1).',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Tests d\'hypothèses',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Test H₀: μ = μ₀ vs H₁: μ ≠ μ₀ pour X ~ N(μ,σ²) avec σ connu.',
                indication: 'Statistique Z = (X̄-μ₀)/(σ/√n).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Déterminer la région critique au seuil 5%.',
                indication: '|Z| > 1.96.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Application numérique : n=25, X̄=102, σ=10, μ₀=100.',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Intervalle de confiance',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Construire un IC à 95% pour μ quand σ est inconnu.',
                indication: 'Loi de Student.',
                correction: 'On utilise la statistique T = (X̄ - μ)/(S/√n) ~ Student(n-1). IC à 95% : X̄ ± t_{n-1;0.025} · S/√n où t_{n-1;0.025} est le quantile de Student à (n-1) degrés de liberté tel que P(|T| ≤ t) = 0.95. Pour n=30, t_{29;0.025} ≈ 2.045.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Quelle taille d\'échantillon pour une précision ±0.5 ?',
                correction: 'On veut d = t·σ/√n ≤ 0.5. Donc n ≥ (t·σ/0.5)². Avec σ estimé et t≈2 (grande taille), n ≥ (2σ/0.5)² = 16σ². Par exemple, si σ=1, n ≥ 16. Si σ=2, n ≥ 64.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - ALGÈBRE 6 - Groupes et Actions de Groupes
      ExamenBlanc(
        id: 'algebre_6',
        titre: 'Composition Algèbre - Actions de Groupes',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Actions de groupes - Définitions',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit G un groupe agissant sur un ensemble X. Définir l\'orbite de x ∈ X et le stabilisateur Stab(x).',
                correction: 'L\'orbite de x est O(x) = {g·x | g ∈ G} = l\'ensemble des éléments de X atteignables depuis x par l\'action de G. Le stabilisateur de x est Stab(x) = {g ∈ G | g·x = x} = le sous-groupe des éléments qui fixent x. C\'est un sous-groupe de G.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Montrer que |O(x)| · |Stab(x)| = |G| (formule des classes).',
                indication: 'Considérer l\'application φ: G/Stab(x) → O(x).',
                correction: 'Soit φ: G/Stab(x) → O(x) définie par φ(gStab(x)) = g·x. φ est bien définie car si g\'∈gStab(x), alors g\'=gh avec h∈Stab(x), donc g\'·x = g·(h·x) = g·x. φ est injective : φ(g₁Stab(x)) = φ(g₂Stab(x)) ⇒ g₁·x = g₂·x ⇒ g₂⁻¹g₁·x = x ⇒ g₂⁻¹g₁ ∈ Stab(x) ⇒ g₁Stab(x) = g₂Stab(x). φ est surjective par définition de O(x). Donc |G/Stab(x)| = |O(x)|, d\'où |G|/|Stab(x)| = |O(x)|.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Application - Théorèmes de Sylow',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Soit G un groupe d\'ordre 12. Montrer qu\'il existe un sous-groupe d\'ordre 3.',
                indication: 'Premier théorème de Sylow.',
                correction: '12 = 2² · 3. Par le 1er théorème de Sylow, pour chaque diviseur premier p^α de |G|, il existe un sous-groupe d\'ordre p^α. Donc il existe un 3-Sylow d\'ordre 3. De même, il existe un 2-Sylow d\'ordre 4.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Soit n₃ le nombre de 3-Sylow. Montrer que n₃ ∈ {1,4}.',
                indication: 'Théorèmes de Sylow : n₃ ≡ 1 (mod 3) et n₃ | 4.',
                correction: 'Par le 3ème théorème de Sylow : n₃ ≡ 1 (mod 3) et n₃ | [G:P] = 12/3 = 4. Les diviseurs de 4 sont {1,2,4}. Parmi eux, ceux qui sont ≡ 1 (mod 3) : 1 ≡ 1 (mod 3) ✓, 2 ≡ 2 (mod 3) ✗, 4 ≡ 1 (mod 3) ✓. Donc n₃ ∈ {1,4}.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Si n₃ = 1, que peut-on dire du 3-Sylow ?',
                correction: 'Si n₃ = 1, le 3-Sylow P est unique. Tout conjugué gPg⁻¹ est aussi un 3-Sylow (même ordre). Comme il n\'y en a qu\'un seul, gPg⁻¹ = P pour tout g ∈ G. Donc P est distingué dans G (P ⊴ G).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Action sur les parties',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit G = S₄ agissant sur X = {1,2,3,4}. Décrire l\'action induite sur P(X) = l\'ensemble des parties de X.',
                correction: 'Pour σ ∈ S₄ et A ⊆ X, on définit σ·A = {σ(a) | a ∈ A}. C\'est une action de groupe : e·A = A et (στ)·A = σ·(τ·A). Par exemple, si σ = (12) et A = {1,3}, alors σ·A = {2,3}.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le stabilisateur de A = {1,2} dans S₄.',
                indication: 'Quelles permutations laissent {1,2} globalement invariant ?',
                correction: 'Stab({1,2}) = {σ ∈ S₄ | σ({1,2}) = {1,2}}. Ces permutations échangent {1,2} entre eux et {3,4} entre eux. Stab({1,2}) = {e, (12), (34), (12)(34)} ≃ (ℤ/2ℤ)². |Stab({1,2})| = 4.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'En déduire la taille de l\'orbite de {1,2}.',
                correction: 'Par la formule des classes : |O({1,2})| = |S₄|/|Stab({1,2})| = 24/4 = 6. Effectivement, les parties à 2 éléments sont : {1,2}, {1,3}, {1,4}, {2,3}, {2,4}, {3,4}, soit C₄² = 6 parties.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - ANALYSE 7 - Séries de Fourier
      ExamenBlanc(
        id: 'analyse_7',
        titre: 'Problème - Séries de Fourier',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Coefficients de Fourier',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x) = |x| sur [-π,π] (prolongée par 2π-périodicité). Calculer les coefficients de Fourier aₙ et bₙ.',
                indication: 'Utiliser la parité de f.',
                correction: 'f est paire donc bₙ = 0 pour tout n ≥ 1. a₀ = (1/π)∫_{-π}^π |x|dx = (2/π)∫₀^π x dx = (2/π)·π²/2 = π. Pour n ≥ 1 : aₙ = (2/π)∫₀^π x cos(nx)dx. IPP : = (2/π)[x·sin(nx)/n]₀^π - (2/π)∫₀^π sin(nx)/n dx = 0 + (2/π)·[cos(nx)/n²]₀^π = (2/πn²)[cos(nπ) - 1] = (2/πn²)[(-1)ⁿ - 1]. Donc aₙ = -4/(πn²) si n impair, aₙ = 0 si n pair.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Écrire la série de Fourier de f.',
                correction: 'f(x) ~ π/2 + Σ_{n impair} (-4/πn²)cos(nx) = π/2 - (4/π)Σₖ₌₀^∞ cos((2k+1)x)/(2k+1)². Série trigonométrique avec uniquement des termes en cosinus (fonction paire).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'La série converge-t-elle ? Vers quelle fonction ?',
                indication: 'Théorème de Dirichlet.',
                correction: 'f est C¹ par morceaux, 2π-périodique. Par le théorème de Dirichlet, la série converge en tout point vers (f(x⁺)+f(x⁻))/2. Comme f est continue partout, la série converge vers f(x) = |x| pour tout x. La convergence est uniforme car f est continue.',
                points: 1,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Égalité de Parseval',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Énoncer l\'égalité de Parseval pour une fonction 2π-périodique.',
                correction: '(1/π)∫_{-π}^π |f(x)|²dx = a₀²/2 + Σₙ₌₁^∞ (aₙ² + bₙ²). C\'est une égalité d\'énergie : l\'énergie dans le domaine temporel égale la somme des énergies des modes de Fourier.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Appliquer Parseval à f(x) = |x| pour calculer Σ 1/n⁴ (n impair).',
                indication: 'Utiliser les coefficients calculés précédemment.',
                correction: '∫_{-π}^π x²dx = 2∫₀^π x²dx = 2π³/3. Donc (1/π)·2π³/3 = 2π²/3. Parseval : 2π²/3 = (π/2)² + Σ_{n impair} (4/πn²)² = π²/4 + (16/π²)Σ_{k=0}^∞ 1/(2k+1)⁴. Donc Σ_{k=0}^∞ 1/(2k+1)⁴ = (π²/16)(2π²/3 - π²/4) = (π²/16)·5π²/12 = 5π⁴/192. Or Σ_{n≥1} 1/n⁴ = π⁴/90, donc Σ_{n pair} 1/n⁴ = (1/16)Σ 1/n⁴ = π⁴/1440.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Convergence et dérivation',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit g(x) = x sur ]-π,π[ prolongée par 2π-périodicité (g(π) = 0). Montrer que g(x) = 2Σ_{n≥1} (-1)^{n+1}·sin(nx)/n.',
                indication: 'g est impaire.',
                correction: 'g est impaire donc aₙ = 0. bₙ = (2/π)∫₀^π x sin(nx)dx. IPP : = (2/π)[-x cos(nx)/n]₀^π + (2/π)∫₀^π cos(nx)/n dx = (2/π)·(-π cos(nπ)/n) + 0 = -2 cos(nπ)/n = 2(-1)^{n+1}/n. Donc g(x) = Σ 2(-1)^{n+1}sin(nx)/n.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Peut-on dériver terme à terme la série de Fourier de g ?',
                indication: 'g\' = 1 sur ]-π,π[ sauf en 0.',
                correction: 'Non en général. g\' n\'existe pas en 0, π, -π (discontinuités). De plus, g\'(x) = 1 sur ]-π,π[\\ {0} a pour série de Fourier : Σ 2(-1)^{n+1}cos(nx), mais cette série ne converge pas (terme général ne tend pas vers 0). Théorème : on peut dériver terme à terme si f est C¹ par morceaux ET la série des dérivées converge.',
                points: 4,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - GÉOMÉTRIE 2 - Courbes et Surfaces
      ExamenBlanc(
        id: 'geometrie_2',
        titre: 'Composition Géométrie - Courbes Paramétrées',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Étude locale d\'une courbe',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit γ(t) = (t², t³) pour t ∈ ℝ. Montrer que γ est birégulière sauf en t=0.',
                indication: 'Calculer γ\'(t).',
                correction: 'γ\'(t) = (2t, 3t²). γ\'(t) = 0 ⇔ 2t = 0 et 3t² = 0 ⇔ t = 0. Donc γ est régulière (γ\' ≠ 0) pour tout t ≠ 0. En t=0, γ\'(0) = 0, c\'est un point singulier.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Déterminer la nature du point singulier en t=0.',
                indication: 'Développer en série.',
                correction: 'γ(t) = (t², t³) = t²(1, t). Pour t→0⁺, le vecteur tangent est dirigé par (1,t)→(1,0). Pour t→0⁻, même limite. C\'est un point de rebroussement de première espèce (les deux demi-tangentes coïncident). Courbe : y² = x³ (cubique semicubique).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer la courbure κ(t) pour t ≠ 0.',
                correction: 'γ\'(t) = (2t, 3t²), γ\'\'(t) = (2, 6t). κ(t) = |γ\' ∧ γ\'\'| / ‖γ\'‖³. γ\' ∧ γ\'\' = det([[2t, 3t²],[2, 6t]]) = 12t² - 6t² = 6t². ‖γ\'‖ = √(4t² + 9t⁴) = t√(4 + 9t²). κ(t) = 6t² / (t√(4+9t²))³ = 6t² / (t³(4+9t²)^{3/2}) = 6 / (t(4+9t²)^{3/2}).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Cycloïde',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'La cycloïde est définie par γ(θ) = (θ - sin θ, 1 - cos θ). Montrer que la longueur d\'une arche (0 ≤ θ ≤ 2π) est 8.',
                indication: 'L = ∫ ‖γ\'‖ dθ.',
                correction: 'γ\'(θ) = (1 - cos θ, sin θ). ‖γ\'‖² = (1-cos θ)² + sin²θ = 1 - 2cos θ + cos²θ + sin²θ = 2 - 2cos θ = 2(1-cos θ) = 4sin²(θ/2). Donc ‖γ\'‖ = 2|sin(θ/2)| = 2sin(θ/2) pour θ ∈ [0,2π]. L = ∫₀^{2π} 2sin(θ/2)dθ = 2·[-2cos(θ/2)]₀^{2π} = -4[cos(π) - cos(0)] = -4[-1-1] = 8.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Montrer que la cycloïde est la brachistochrone.',
                indication: 'Problème variationnel.',
                correction: 'La brachistochrone est la courbe de descente la plus rapide sous gravité. Calcul variationnel : minimiser T = ∫ ds/v où v² = 2gy. Équation d\'Euler-Lagrange donne y(1 + (y\')²) = C (constante). Solution : la cycloïde. Historique : problème posé par Jean Bernoulli (1696), résolu par Newton, Leibniz, etc.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Surfaces de révolution',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Calculer l\'aire de la sphère de rayon R en la considérant comme surface de révolution de y = √(R² - x²).',
                indication: 'Aire = 2π∫ y√(1+(y\')²) dx.',
                correction: 'y\' = -x/√(R²-x²). 1+(y\')² = 1 + x²/(R²-x²) = R²/(R²-x²). √(1+(y\')²) = R/√(R²-x²). Aire = 2π∫_{-R}^R √(R²-x²) · R/√(R²-x²) dx = 2π∫_{-R}^R R dx = 2π·R·2R = 4πR². Formule classique de l\'aire de la sphère.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer le volume de la boule.',
                correction: 'Volume = π∫_{-R}^R y² dx = π∫_{-R}^R (R²-x²)dx = π[R²x - x³/3]_{-R}^R = π[(R³ - R³/3) - (-R³ + R³/3)] = π·4R³/3 = 4πR³/3.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - ANALYSE 8 - Équations Différentielles
      ExamenBlanc(
        id: 'analyse_8',
        titre: 'Problème - Équations Différentielles',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Équation linéaire d\'ordre 2',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Résoudre y\'\' + y = 0 avec conditions initiales y(0) = 1, y\'(0) = 0.',
                correction: 'Équation caractéristique : r² + 1 = 0, racines r = ±i. Solution générale : y(t) = A cos(t) + B sin(t). Conditions : y(0) = A = 1, y\'(0) = B = 0. Solution : y(t) = cos(t).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Résoudre y\'\' + 2y\' + 2y = e^{-t}.',
                indication: 'Solution particulière par variation des constantes.',
                correction: 'Équation homogène : r² + 2r + 2 = 0, Δ = -4, r = -1 ± i. Sol. homogène : y_h = e^{-t}(A cos t + B sin t). Pour sol. particulière, essayer y_p = Ce^{-t}. y_p\' = -Ce^{-t}, y_p\'\' = Ce^{-t}. Substitution : Ce^{-t} - 2Ce^{-t} + 2Ce^{-t} = e^{-t} ⇒ Ce^{-t} = e^{-t} ⇒ C = 1. Solution générale : y = e^{-t}(A cos t + B sin t + 1).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Montrer que les solutions sont bornées sur [0,+∞[.',
                correction: '|y(t)| ≤ e^{-t}(|A|·1 + |B|·1 + 1) ≤ e^{-t}·K où K = |A| + |B| + 1. Comme e^{-t} → 0 quand t → ∞, y(t) → 0. Toutes les solutions tendent vers 0 (système stable).',
                points: 2,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Système différentiel',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Résoudre le système X\' = AX avec A = [[1,1],[0,2]] et X(0) = [[1],[0]].',
                indication: 'Diagonaliser A.',
                correction: 'Valeurs propres : det(A-λI) = (1-λ)(2-λ) = 0, λ₁ = 1, λ₂ = 2. Vecteurs propres : E₁ = Vect([[1],[0]]), E₂ = Vect([[1],[1]]). A n\'est pas diagonale mais triangulaire. Solution : X(t) = e^{At}X(0). e^{At} = [[e^t, (e^{2t}-e^t)],[0, e^{2t}]]. X(t) = [[e^t], [0]].',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Étudier le portrait de phase du système.',
                correction: 'Les valeurs propres sont positives donc l\'origine est un nœud instable. Les trajectoires s\'éloignent de l\'origine selon les directions propres. Direction propre [[1],[0]] (λ=1) : croissance en e^t. Direction [[1],[1]] (λ=2) : croissance plus rapide en e^{2t}.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème de Cauchy-Lipschitz',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Énoncer le théorème de Cauchy-Lipschitz pour y\' = f(t,y), y(t₀) = y₀.',
                correction: 'Si f : U ⊆ ℝ×ℝⁿ → ℝⁿ est continue et localement lipschitzienne en y (∃L : ‖f(t,y₁)-f(t,y₂)‖ ≤ L‖y₁-y₂‖), alors le problème de Cauchy y\'=f(t,y), y(t₀)=y₀ admet une unique solution maximale définie sur un intervalle ouvert contenant t₀.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Montrer que f(y) = y² est lipschitzienne sur tout compact mais pas globalement sur ℝ.',
                indication: '|y₁² - y₂²| = |y₁ + y₂|·|y₁ - y₂|.',
                correction: 'Sur K = [-M,M], |f(y₁)-f(y₂)| = |y₁²-y₂²| = |y₁+y₂|·|y₁-y₂| ≤ 2M·|y₁-y₂|. Donc f est L-lipschitzienne avec L=2M. Sur ℝ, pas de constante L globale : pour y₁=0, y₂=n, |n²-0|/|n-0| = n → ∞. Conséquence : y\'=y², y(0)=1 explose en temps fini.',
                points: 3,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - ALGÈBRE 7 - Anneaux et Corps
      ExamenBlanc(
        id: 'algebre_7',
        titre: 'Composition Algèbre - Anneaux et Idéaux',
        type: 'composition_algebre',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Idéaux dans ℤ[i]',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que ℤ[i] = {a + bi | a,b ∈ ℤ} est un anneau euclidien pour la norme N(a+bi) = a² + b².',
                indication: 'Division euclidienne.',
                correction: 'Soient α, β ∈ ℤ[i], β ≠ 0. On cherche q, r tels que α = βq + r avec N(r) < N(β). Dans ℂ, α/β = u + iv avec u,v ∈ ℚ. Choisir m,n ∈ ℤ proches : |u-m| ≤ 1/2, |v-n| ≤ 1/2. Poser q = m + ni, r = α - βq. Alors r/β = (u-m) + i(v-n), N(r/β) ≤ 1/4 + 1/4 = 1/2 < 1. Donc N(r) < N(β).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Décomposer 5 en produit d\'irréductibles dans ℤ[i].',
                correction: 'N(5) = 25. Chercher α = a+bi avec N(α) | 25. N(2+i) = 5, donc (2+i)(2-i) = 4+1 = 5. Vérifier que 2+i est irréductible : si 2+i = αβ, alors 5 = N(α)N(β). Donc N(α) ∈ {1,5}. Si N(α)=1, α unité. Si N(α)=5, β unité. Conclusion : 5 = (1+2i)(1-2i) avec 1±2i irréductibles (à unité près).',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Extension de corps',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que ℚ(√2) = {a + b√2 | a,b ∈ ℚ} est un corps.',
                correction: 'Clairement ℚ(√2) est stable par +, ×. Montrer que tout élément non nul est inversible : soit α = a + b√2 ≠ 0. Chercher α⁻¹ = x + y√2 tel que (a+b√2)(x+y√2) = 1. ax + 2by = 1 et ay + bx = 0. Système : x = a/(a²-2b²), y = -b/(a²-2b²). Comme α ≠ 0, a²-2b² ≠ 0 (sinon √2 = a/b ∈ ℚ, contradiction). Donc α⁻¹ existe.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Calculer [ℚ(√2) : ℚ], le degré de l\'extension.',
                indication: 'Polynôme minimal de √2.',
                correction: 'Le polynôme minimal de √2 sur ℚ est X² - 2 (irréductible par Eisenstein avec p=2). Donc [ℚ(√2):ℚ] = deg(X²-2) = 2. Base : {1, √2}. Dimension en tant qu\'espace vectoriel sur ℚ est 2.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème chinois',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Résoudre le système x ≡ 2 (mod 3), x ≡ 3 (mod 5), x ≡ 2 (mod 7).',
                indication: 'Théorème des restes chinois.',
                correction: 'Les modules sont premiers entre eux deux à deux. Par TRC, il existe une unique solution modulo 3·5·7 = 105. Méthode : x = 2·(5·7)·u + 3·(3·7)·v + 2·(3·5)·w où 35u ≡ 1 (mod 3), 21v ≡ 1 (mod 5), 15w ≡ 1 (mod 7). 35 ≡ 2 (mod 3), donc u = 2. 21 ≡ 1 (mod 5), donc v = 1. 15 ≡ 1 (mod 7), donc w = 1. x = 2·35·2 + 3·21·1 + 2·15·1 = 140 + 63 + 30 = 233 ≡ 23 (mod 105).',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Généraliser : énoncer le théorème des restes chinois pour des anneaux.',
                correction: 'Soit A un anneau, I₁,...,Iₙ des idéaux deux à deux copremiers (Iᵢ + Iⱼ = A pour i≠j). Alors A/(I₁∩...∩Iₙ) ≃ A/I₁ × ... × A/Iₙ (isomorphisme d\'anneaux). Cas particulier : ℤ/nℤ ≃ ℤ/p₁^{α₁}ℤ × ... × ℤ/pₖ^{αₖ}ℤ si n = p₁^{α₁}...pₖ^{αₖ}.',
                points: 1,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - ANALYSE 9 - Calcul Différentiel
      ExamenBlanc(
        id: 'analyse_9',
        titre: 'Problème - Fonctions de Plusieurs Variables',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Différentiabilité',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Soit f(x,y) = xy/(x²+y²) si (x,y) ≠ (0,0), f(0,0) = 0. Montrer que f admet des dérivées partielles en (0,0) mais n\'est pas continue en (0,0).',
                correction: '∂f/∂x(0,0) = lim_{h→0} [f(h,0)-f(0,0)]/h = 0/h = 0. De même ∂f/∂y(0,0) = 0. Mais f(t,t) = t²/(2t²) = 1/2 → 1/2 ≠ 0 quand t→0. Donc f n\'est pas continue en (0,0). Conclusion : l\'existence des dérivées partielles n\'implique pas la continuité.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Soit g(x,y) = (x²+y²)sin(1/√(x²+y²)) si (x,y) ≠ (0,0), g(0,0) = 0. g est-elle différentiable en (0,0) ?',
                indication: 'Utiliser |g(x,y)| ≤ x²+y².',
                correction: '|g(x,y)| ≤ x²+y² car |sin(u)| ≤ 1. Donc |g(x,y)-g(0,0)|/‖(x,y)‖ = |g(x,y)|/√(x²+y²) ≤ √(x²+y²) → 0. La différentielle en (0,0) est dg₀ = 0 (application linéaire nulle). g est différentiable en (0,0).',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Extrema',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Déterminer les points critiques de f(x,y) = x² + y² - xy + x.',
                correction: '∇f = (2x - y + 1, 2y - x). Points critiques : 2x - y + 1 = 0 et 2y - x = 0. De la 2ème : x = 2y. Substitution dans la 1ère : 4y - y + 1 = 0 ⇒ y = -1/3, x = -2/3. Point critique : (-2/3, -1/3).',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Déterminer la nature de ce point critique.',
                indication: 'Matrice hessienne.',
                correction: 'H = [[∂²f/∂x², ∂²f/∂x∂y],[∂²f/∂y∂x, ∂²f/∂y²]] = [[2,-1],[-1,2]]. det(H) = 4 - 1 = 3 > 0 et tr(H) = 4 > 0. Donc H est définie positive : c\'est un minimum local. Valeur : f(-2/3,-1/3) = 4/9 + 1/9 + 2/9 - 2/3 = 7/9 - 6/9 = 1/9. Correction calcul : f = 4/9 + 1/9 + 2/9 - 2/3 = (4+1+2)/9 - 6/9 = 1/9.',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Y a-t-il un extremum global ?',
                indication: 'Étudier le comportement à l\'infini.',
                correction: 'f(x,y) = x² + y² - xy + x = (x²-xy) + y² + x. Pour ||(x,y)|| → ∞, le terme dominant est x²+y² → +∞. Donc f(x,y) → +∞. Le point critique est donc un minimum global. f(x,y) ≥ 1/9 pour tout (x,y).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème des fonctions implicites',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Soit F(x,y) = x² + y² - 1. Montrer qu\'au voisinage de (1,0), l\'équation F(x,y) = 0 définit y comme fonction implicite de x.',
                indication: '∂F/∂y ≠ 0 en (1,0).',
                correction: 'F(1,0) = 0 ✓. ∂F/∂y = 2y. ∂F/∂y(1,0) = 0 ✗. Mais ∂F/∂x(1,0) = 2x|_{(1,0)} = 2 ≠ 0. Donc on peut exprimer x en fonction de y : x = √(1-y²) au voisinage de (1,0). Pour y(x), considérer un autre point : en (0,1), ∂F/∂y = 2 ≠ 0, donc localement y = √(1-x²).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Calculer dy/dx au point (0,1).',
                correction: 'Par dérivation implicite : ∂F/∂x + ∂F/∂y · dy/dx = 0. dy/dx = -(∂F/∂x)/(∂F/∂y). En (0,1) : dy/dx = -0/2 = 0. Géométriquement : la tangente au cercle en (0,1) est horizontale.',
                points: 2,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - PROBABILITÉS 3 - Variables Aléatoires
      ExamenBlanc(
        id: 'proba_3',
        titre: 'Composition Probabilités - Lois et Convergence',
        type: 'composition_analyse',
        dureeMinutes: 300,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Loi exponentielle',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Soit X ~ Exp(λ). Montrer que X est sans mémoire : P(X > s+t | X > s) = P(X > t).',
                indication: 'Utiliser P(X > x) = e^{-λx}.',
                correction: 'P(X > s+t | X > s) = P(X > s+t ∩ X > s)/P(X > s) = P(X > s+t)/P(X > s) = e^{-λ(s+t)}/e^{-λs} = e^{-λt} = P(X > t). Propriété fondamentale de la loi exponentielle : "l\'âge n\'a pas d\'effet sur la durée de vie restante".',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Si X,Y indépendantes ~ Exp(λ), calculer P(X < Y).',
                correction: 'P(X < Y) = ∫∫_{x<y} f_X(x)f_Y(y)dxdy = ∫₀^∞ ∫₀^y λe^{-λx}·λe^{-λy}dx dy = ∫₀^∞ λe^{-λy}[1-e^{-λy}]dy = ∫₀^∞ λe^{-λy}dy - ∫₀^∞ λe^{-2λy}dy = 1 - 1/2 = 1/2. Par symétrie entre X et Y, résultat attendu.',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Théorème central limite',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Énoncer le théorème central limite (TCL).',
                correction: 'Soit (Xₙ) suite de v.a. i.i.d. d\'espérance μ et variance σ² < ∞. Alors (X̄ₙ - μ)/(σ/√n) converge en loi vers N(0,1) quand n → ∞. Équivalent : √n(X̄ₙ - μ)/σ ⇝ N(0,1). Approximation : pour n grand, X̄ₙ ≈ N(μ, σ²/n).',
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Soient Xᵢ ~ Bernoulli(1/2) i.i.d. Approcher P(Sₙ ≥ 60) où Sₙ = X₁ + ... + X₁₀₀.',
                indication: 'TCL avec correction de continuité.',
                correction: 'E[Xᵢ] = 1/2, Var(Xᵢ) = 1/4. Sₙ ~ Bin(100,1/2), E[Sₙ] = 50, σ(Sₙ) = 5. Par TCL, (Sₙ-50)/5 ≈ N(0,1). P(Sₙ ≥ 60) ≈ P((Sₙ-50)/5 ≥ 2) = P(Z ≥ 2) ≈ 1 - Φ(2) ≈ 0.023. Avec correction de continuité : P(Sₙ ≥ 59.5) ≈ P(Z ≥ 1.9) ≈ 0.029.',
                points: 5,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Inégalités',
            bareme: 6,
            questions: [
              QuestionExamen(
                enonce: 'Énoncer l\'inégalité de Markov et l\'inégalité de Bienaymé-Tchebychev.',
                correction: 'Markov : Si X ≥ 0, alors P(X ≥ a) ≤ E[X]/a pour tout a > 0. Bienaymé-Tchebychev : P(|X - μ| ≥ ε) ≤ σ²/ε² où μ = E[X], σ² = Var(X). Conséquence : la probabilité d\'être loin de la moyenne décroît comme 1/ε².',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Soit X ~ Exp(1). Majorer P(X ≥ 10) par Markov puis calculer la valeur exacte.',
                correction: 'Markov : P(X ≥ 10) ≤ E[X]/10 = 1/10 = 0.1. Valeur exacte : P(X ≥ 10) = e^{-10} ≈ 0.000045. Markov donne une borne très large (2200 fois trop grande). Les inégalités sont souvent très pessimistes mais universelles.',
                points: 4,
              ),
            ],
          ),
        ],
      ),

      // NOUVEAU - MODÉLISATION 2 - Graphes et Optimisation
      ExamenBlanc(
        id: 'modelisation_2',
        titre: 'Problème - Théorie des Graphes',
        type: 'probleme',
        dureeMinutes: 240,
        baremeTotal: 20,
        exercices: [
          ExerciceExamen(
            titre: 'Graphes eulériens',
            bareme: 7,
            questions: [
              QuestionExamen(
                enonce: 'Énoncer le théorème d\'Euler sur les graphes eulériens (qui admettent un cycle eulérien).',
                correction: 'Un graphe connexe G admet un cycle eulérien (passant par chaque arête exactement une fois) si et seulement si tous ses sommets sont de degré pair. Un graphe connexe admet une chaîne eulérienne (mais pas de cycle) ssi il a exactement deux sommets de degré impair.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Le graphe K₅ (complet à 5 sommets) est-il eulérien ?',
                correction: 'Dans K₅, chaque sommet est relié aux 4 autres, donc deg(v) = 4 pour tout sommet. Tous les sommets ont un degré pair. K₅ est connexe. Donc K₅ est eulérien. Un cycle eulérien existe.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Donner un algorithme pour construire un cycle eulérien.',
                indication: 'Algorithme de Hierholzer.',
                correction: 'Algorithme de Hierholzer : (1) Partir d\'un sommet arbitraire, construire un cycle en suivant des arêtes non utilisées jusqu\'à revenir au point de départ. (2) S\'il reste des arêtes non visitées, choisir un sommet sur le cycle actuel ayant des arêtes non visitées, construire un nouveau cycle depuis ce sommet. (3) Fusionner les cycles. Complexité : O(|E|).',
                points: 3,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Plus court chemin',
            bareme: 8,
            questions: [
              QuestionExamen(
                enonce: 'Décrire l\'algorithme de Dijkstra pour calculer le plus court chemin depuis un sommet source s.',
                correction: 'Initialisation : d[s] = 0, d[v] = ∞ pour v ≠ s. File prioritaire Q = tous les sommets. Tant que Q non vide : (1) Extraire u avec d[u] minimal. (2) Pour chaque voisin v de u : si d[u] + poids(u,v) < d[v], alors d[v] = d[u] + poids(u,v). Complexité : O((|V|+|E|)log|V|) avec tas binaire. Fonctionne avec poids positifs uniquement.',
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Appliquer Dijkstra au graphe : A -5→ B -2→ C, A -1→ D -3→ C, depuis A.',
                correction: 'Init : d[A]=0, d[B]=d[C]=d[D]=∞. Étape 1 : Traiter A, d[B]=5, d[D]=1. Étape 2 : Traiter D (d[D]=1 minimal), d[C] = min(∞, 1+3) = 4. Étape 3 : Traiter C (d[C]=4), déjà optimal. Étape 4 : Traiter B (d[B]=5), d[C] = min(4, 5+2) = 4. Résultat : d[A]=0, d[D]=1, d[C]=4, d[B]=5. Chemin A→D→C est optimal.',
                points: 4,
              ),
            ],
          ),
          ExerciceExamen(
            titre: 'Coloration',
            bareme: 5,
            questions: [
              QuestionExamen(
                enonce: 'Montrer que tout graphe planaire admet une coloration avec au plus 4 couleurs (admettre le théorème des 4 couleurs).',
                correction: 'Théorème des 4 couleurs (Appel & Haken, 1976) : χ(G) ≤ 4 pour tout graphe planaire G. La preuve originale utilise des milliers de cas vérifiés par ordinateur. Théorème plus faible (5 couleurs) a une preuve élémentaire par récurrence.',
                points: 2,
              ),
              QuestionExamen(
                enonce: 'Calculer le nombre chromatique χ(K₅) du graphe complet K₅.',
                indication: 'Deux sommets adjacents doivent avoir des couleurs différentes.',
                correction: 'Dans K₅, tous les sommets sont adjacents deux à deux. Donc on ne peut pas donner la même couleur à deux sommets. Il faut 5 couleurs différentes. χ(K₅) = 5. En général, χ(Kₙ) = n.',
                points: 3,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
