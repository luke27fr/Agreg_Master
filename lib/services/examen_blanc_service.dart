import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
      if (result.note < 5) repartition['0-5'] = repartition['0-5']! + 1;
      else if (result.note < 10) repartition['5-10'] = repartition['5-10']! + 1;
      else if (result.note < 12) repartition['10-12'] = repartition['10-12']! + 1;
      else if (result.note < 14) repartition['12-14'] = repartition['12-14']! + 1;
      else if (result.note < 16) repartition['14-16'] = repartition['14-16']! + 1;
      else repartition['16-20'] = repartition['16-20']! + 1;
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
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/examen_blanc_results.json');
  }

  Future<void> loadResults() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
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
      final file = await _getFile();
      final data = _results.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
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
                correction: 'Équation caractéristique : r² - 2r + 1 = 0 ⟹ r = 1 (double). Solution homogène : y_h = (C₁ + C₂x)e^x. Pour une solution particulière, racine double ⟹ chercher y_p = (ax³)e^x. Dérivées : y\'_p = (3ax² + ax³)e^x, y\"_p = (6ax + 6ax² + ax³)e^x. Substitution : (6ax + 6ax² + ax³ - 6ax² - 2ax³ + ax³)e^x = xe^x ⟹ 6ax = x ⟹ a = 1/6. Solution générale : y = (C₁ + C₂x + x³/6)e^x.',
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
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Peut-on appliquer la convergence dominée ?',
                indication: 'Trouver une fonction dominante.',
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
                points: 4,
              ),
              QuestionExamen(
                enonce: 'Calculer F\'(t) puis F(t).',
                indication: 'F\'(t) = -∫e^{-tx}sin(x)dx.',
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
                points: 2,
              ),
              QuestionExamen(
                enonce: 'En déduire Γ(n+1) = n! pour n ∈ ℕ.',
                points: 1,
              ),
              QuestionExamen(
                enonce: 'Calculer Γ(1/2) = √π.',
                indication: 'Intégrale de Gauss.',
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
                points: 3,
              ),
              QuestionExamen(
                enonce: 'Quelle taille d\'échantillon pour une précision ±0.5 ?',
                points: 2,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
