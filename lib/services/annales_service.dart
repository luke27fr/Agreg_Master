import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/annale_model.dart';

class AnnalesService extends ChangeNotifier {
  List<Annale> _annales = [];
  bool _isLoading = false;
  String? _error;

  List<Annale> get annales => _annales;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtres
  List<Annale> getByYear(int year) {
    return _annales.where((a) => a.annee == year).toList();
  }

  List<Annale> getBySession(String session) {
    return _annales.where((a) => a.session == session).toList();
  }

  List<Annale> getByType(String typeEpreuve) {
    return _annales.where((a) => a.typeEpreuve == typeEpreuve).toList();
  }

  List<Annale> getByTheme(String theme) {
    return _annales.where((a) => a.themes.contains(theme)).toList();
  }

  List<Annale> getRecent({int limit = 5}) {
    final sorted = List<Annale>.from(_annales)
      ..sort((a, b) => b.annee.compareTo(a.annee));
    return sorted.take(limit).toList();
  }

  List<int> getAvailableYears() {
    return _annales.map((a) => a.annee).toSet().toList()..sort((a, b) => b.compareTo(a));
  }

  Future<void> loadAnnales() async {
    if (_annales.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Créer les annales de démonstration
      _annales = _createDemoAnnales();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Annale> _createDemoAnnales() {
    return [
      // 2024
      Annale(
        id: 'externe_2024_ecrit1',
        annee: 2024,
        session: 'externe',
        typeEpreuve: 'ecrit1',
        titre: 'Agrégation Externe 2024 - Épreuve écrite d\'Algèbre et Géométrie',
        description: 'Sujet portant sur les groupes finis, la réduction d\'endomorphismes et la géométrie euclidienne.',
        dureeMinutes: 360,
        baremeTotal: 20,
        themes: ['Algèbre', 'Géométrie'],
        urlOfficielle: 'https://agreg.org/archives/2024/externe/algebre_geometrie.pdf',
        difficulte: 'Difficile',
        motsClefs: ['Groupes de Sylow', 'Réduction', 'Isométries'],
        exercices: [
          ExerciceAnnale(
            titre: 'Partie I - Groupes finis et actions',
            introduction: 'On étudie les propriétés des groupes finis via leurs actions sur des ensembles.',
            bareme: 8,
            themes: ['Algèbre'],
            questions: [
              QuestionAnnale(
                enonce: 'Soit G un groupe fini d\'ordre n et H un sous-groupe. Montrer que |H| divise n.',
                indication: 'Utiliser le théorème de Lagrange.',
                correction: 'Par le théorème de Lagrange, l\'ordre de tout sous-groupe divise l\'ordre du groupe. Démonstration : les classes à gauche modulo H partitionnent G et ont toutes le cardinal |H|. Donc |G| = [G:H]·|H|.',
                points: 2,
              ),
              QuestionAnnale(
                enonce: 'Soit G un groupe d\'ordre p², où p est premier. Montrer que G est abélien.',
                indication: 'Utiliser que le centre Z(G) est non trivial pour un p-groupe.',
                correction: 'Un p-groupe non trivial a un centre non trivial. Si Z(G) = G, c\'est fini. Sinon |Z(G)| = p. Le quotient G/Z(G) est cyclique d\'ordre p, donc G est abélien (contradiction). Donc Z(G) = G.',
                points: 3,
              ),
              QuestionAnnale(
                enonce: 'Application : classifier tous les groupes d\'ordre 15.',
                correction: 'Ordre 15 = 3·5. Par Sylow, n₃ ∈ {1} et n₅ ∈ {1}. Les sous-groupes de Sylow sont distingués. Comme (3,5)=1, G ≅ ℤ/3ℤ × ℤ/5ℤ ≅ ℤ/15ℤ (un seul groupe à isomorphisme près).',
                points: 3,
              ),
            ],
          ),
          ExerciceAnnale(
            titre: 'Partie II - Réduction d\'endomorphismes',
            introduction: 'Étude de la diagonalisation et de la réduction de Jordan.',
            bareme: 7,
            themes: ['Algèbre'],
            questions: [
              QuestionAnnale(
                enonce: 'Soit A ∈ M_n(ℝ) vérifiant A³ = A. Montrer que A est diagonalisable.',
                indication: 'Le polynôme minimal divise X³ - X.',
                correction: 'Le polynôme minimal μ_A divise X³-X = X(X-1)(X+1). Ce polynôme est scindé à racines simples, donc A est diagonalisable.',
                points: 3,
              ),
              QuestionAnnale(
                enonce: 'Déterminer les valeurs propres possibles et les sous-espaces propres.',
                correction: 'Les valeurs propres sont dans {0, 1, -1}. E_0(A) = Ker(A), E_1(A) = Ker(A-I), E_{-1}(A) = Ker(A+I). On a ℝⁿ = E_0 ⊕ E_1 ⊕ E_{-1}.',
                points: 4,
              ),
            ],
          ),
          ExerciceAnnale(
            titre: 'Partie III - Géométrie euclidienne',
            introduction: 'Isométries du plan et de l\'espace.',
            bareme: 5,
            themes: ['Géométrie'],
            questions: [
              QuestionAnnale(
                enonce: 'Classifier toutes les isométries du plan euclidien.',
                indication: 'Distinguer les cas : orientation et points fixes.',
                correction: 'Isométries directes : translations et rotations. Isométries indirectes : symétries axiales et glissées. Démonstration par l\'étude du déterminant et des points fixes.',
                points: 5,
              ),
            ],
          ),
        ],
      ),

      Annale(
        id: 'externe_2024_ecrit2',
        annee: 2024,
        session: 'externe',
        typeEpreuve: 'ecrit2',
        titre: 'Agrégation Externe 2024 - Épreuve écrite d\'Analyse et Probabilités',
        description: 'Problème d\'analyse fonctionnelle et probabilités (TCL, convergences).',
        dureeMinutes: 360,
        baremeTotal: 20,
        themes: ['Analyse', 'Probabilités'],
        urlOfficielle: 'https://agreg.org/archives/2024/externe/analyse_probabilites.pdf',
        difficulte: 'Très difficile',
        motsClefs: ['Espaces de Hilbert', 'TCL', 'Convergence en loi'],
        exercices: [
          ExerciceAnnale(
            titre: 'Partie I - Espaces de Hilbert',
            bareme: 10,
            themes: ['Analyse'],
            questions: [
              QuestionAnnale(
                enonce: 'Montrer le théorème de projection sur un convexe fermé dans un espace de Hilbert.',
                indication: 'Minimiser ‖x - y‖ pour y ∈ C.',
                correction: 'Soit x ∈ H, C convexe fermé. Soit d = inf_{y∈C} ‖x-y‖. Il existe une suite (yₙ) dans C telle que ‖x-yₙ‖ → d. On montre que (yₙ) est de Cauchy par l\'identité du parallélogramme appliquée au convexe. Comme H est complet, yₙ → y ∈ C. L\'unicité vient de la stricte convexité de la norme.',
                points: 5,
              ),
              QuestionAnnale(
                enonce: 'Application : bases hilbertiennes et égalité de Parseval.',
                correction: '(eₙ) base hilbertienne ⟺ Vect(eₙ) dense ⟺ ‖x‖² = Σ|⟨x,eₙ⟩|² pour tout x. Démonstration via projection orthogonale sur Vect(e₁,...,eₙ).',
                points: 5,
              ),
            ],
          ),
          ExerciceAnnale(
            titre: 'Partie II - Théorème central limite',
            bareme: 10,
            themes: ['Probabilités'],
            questions: [
              QuestionAnnale(
                enonce: 'Énoncer et démontrer le TCL pour des v.a. i.i.d. de variance finie.',
                indication: 'Fonctions caractéristiques et DL.',
                correction: 'Soit (Xₙ) i.i.d., E[X₁]=μ, Var(X₁)=σ². Alors (Sₙ-nμ)/(σ√n) ⇒ N(0,1). Preuve : φ_{Zₙ}(t) = [φ_{(X-μ)/σ}(t/√n)]ⁿ. DL : φ(u) = 1 - u²/2 + o(u²). Donc φ_{Zₙ}(t) = [1 - t²/(2n) + o(1/n)]ⁿ → e^(-t²/2).',
                points: 6,
              ),
              QuestionAnnale(
                enonce: 'Application à l\'estimation d\'une proportion.',
                correction: 'Pour estimer p avec précision ε et niveau 95%, il faut n ≥ (1.96)²·p(1-p)/ε². Pire cas : p=1/2 donne n ≥ 9604 pour ε=0.01.',
                points: 4,
              ),
            ],
          ),
        ],
      ),

      // 2023
      Annale(
        id: 'externe_2023_ecrit1',
        annee: 2023,
        session: 'externe',
        typeEpreuve: 'ecrit1',
        titre: 'Agrégation Externe 2023 - Algèbre : Polynômes et Réduction',
        description: 'Problème sur les polynômes d\'endomorphismes et la réduction simultanée.',
        dureeMinutes: 360,
        baremeTotal: 20,
        themes: ['Algèbre'],
        urlOfficielle: 'https://agreg.org/archives/2023/externe/algebre.pdf',
        difficulte: 'Difficile',
        motsClefs: ['Polynômes', 'Réduction', 'Commutants'],
        exercices: [
          ExerciceAnnale(
            titre: 'Polynômes d\'endomorphismes',
            bareme: 12,
            questions: [
              QuestionAnnale(
                enonce: 'Soit u endomorphisme tel que u² - 3u + 2I = 0. Montrer que u est inversible et exprimer u⁻¹.',
                correction: 'u² - 3u + 2I = 0 ⟹ u(u-3I) = -2I ⟹ u·[-(u-3I)/2] = I. Donc u⁻¹ = (3I-u)/2.',
                points: 2,
              ),
              QuestionAnnale(
                enonce: 'Théorème de Cayley-Hamilton : Montrer que tout endomorphisme annule son polynôme caractéristique.',
                indication: 'Utiliser la comatrice.',
                correction: 'Soit χ_u(X) = det(XI-u). On a Com(XI-u)·(XI-u) = χ_u(X)I. En substituant X=u et utilisant Com(uI-u)=0 (matrice nulle), on obtient χ_u(u)=0.',
                points: 5,
              ),
              QuestionAnnale(
                enonce: 'Application : calculer A¹⁰⁰ pour A = [[2,1],[0,2]].',
                correction: 'χ_A = (X-2)². Par Cayley-Hamilton, (A-2I)²=0. Donc A = 2I + N avec N nilpotent d\'ordre 2. A¹⁰⁰ = (2I+N)¹⁰⁰ = Σ₀¹ C(100,k)·2^(100-k)·Nᵏ = 2¹⁰⁰I + 100·2⁹⁹N.',
                points: 5,
              ),
            ],
          ),
        ],
      ),

      // 2022
      Annale(
        id: 'externe_2022_ecrit2',
        annee: 2022,
        session: 'externe',
        typeEpreuve: 'ecrit2',
        titre: 'Agrégation Externe 2022 - Analyse : Séries de Fourier',
        description: 'Étude approfondie des séries de Fourier et convergence.',
        dureeMinutes: 360,
        baremeTotal: 20,
        themes: ['Analyse'],
        urlOfficielle: 'https://agreg.org/archives/2022/externe/fourier.pdf',
        difficulte: 'Moyen',
        motsClefs: ['Fourier', 'Convergence uniforme', 'Parseval'],
        exercices: [
          ExerciceAnnale(
            titre: 'Convergence des séries de Fourier',
            bareme: 15,
            questions: [
              QuestionAnnale(
                enonce: 'Calculer les coefficients de Fourier de f(x) = x sur [-π,π].',
                correction: 'f impaire ⟹ aₙ = 0. bₙ = (2/π)∫₀^π x sin(nx)dx. IPP : bₙ = 2(-1)^(n+1)/n. Donc f(x) = 2Σ[(-1)^(n+1)/n]sin(nx).',
                points: 4,
              ),
              QuestionAnnale(
                enonce: 'Montrer la convergence uniforme pour f continue C¹ par morceaux.',
                indication: 'Utiliser la majoration |cₙ| = O(1/n²).',
                correction: 'Si f ∈ C¹ par morceaux, intégration par parties donne |cₙ| ≤ K/n². La série ΣK/n² converge, donc convergence normale et uniforme.',
                points: 6,
              ),
              QuestionAnnale(
                enonce: 'Égalité de Parseval : En déduire Σ 1/n² = π²/6.',
                correction: 'Parseval : ‖f‖² = Σ|cₙ|². Pour f(x)=x : (1/π)∫₋π^π x²dx = π²/3. Et Σ|bₙ|² = 4Σ1/n² = π²/3. Donc Σ1/n² = π²/6 (Problème de Bâle).',
                points: 5,
              ),
            ],
          ),
        ],
      ),

      // Interne 2024
      Annale(
        id: 'interne_2024_ecrit1',
        annee: 2024,
        session: 'interne',
        typeEpreuve: 'ecrit1',
        titre: 'Agrégation Interne 2024 - Algèbre linéaire',
        description: 'Matrices, déterminants et applications.',
        dureeMinutes: 300,
        baremeTotal: 20,
        themes: ['Algèbre'],
        urlOfficielle: 'https://agreg.org/archives/2024/interne/algebre.pdf',
        difficulte: 'Moyen',
        motsClefs: ['Matrices', 'Déterminants', 'Rang'],
        exercices: [
          ExerciceAnnale(
            titre: 'Matrices et rang',
            bareme: 10,
            questions: [
              QuestionAnnale(
                enonce: 'Calculer le rang de la matrice A = [[1,2,3],[2,4,6],[3,6,9]].',
                correction: 'Les lignes sont colinéaires : L₂ = 2L₁, L₃ = 3L₁. Donc rg(A) = 1.',
                points: 2,
              ),
              QuestionAnnale(
                enonce: 'Soit A ∈ M_n(ℝ) de rang r. Montrer que A peut s\'écrire comme somme de r matrices de rang 1.',
                indication: 'Décomposition en valeurs singulières ou produit.',
                correction: 'Si rg(A)=r, alors A = BC où B ∈ M_{n,r} et C ∈ M_{r,n}. Écrire A = Σᵢ₌₁ʳ bᵢcᵢᵀ où bᵢ colonnes de B, cᵢᵀ lignes de C. Chaque bᵢcᵢᵀ est de rang ≤ 1.',
                points: 5,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
