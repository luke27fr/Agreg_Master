import 'package:agreg_master/services/latex_helper.dart';

void main() {
  final tests = [
    "Par Sylow, n₃ ≡ 1 (mod 3) et n₃ | 5, donc n₃ = 1.",
    "Donc G ≅ ℤ/3ℤ × ℤ/5ℤ ≅ ℤ/15ℤ.",
    "Soit A = [[1,1],[0,1]]. Calculer A¹⁰⁰.",
    "Binôme : Aⁿ = (I+N)ⁿ = I + nN (termes Nᵏ nuls pour k ≥ 2).",
    "Donc A¹⁰⁰ = I + 100N = [[1,100],[0,1]].",
    "Soit fₙ(x) = nx·e^(-nx²) pour x ∈ [0,1].",
    "‖fₙ‖∞ = fₙ(1/√(2n)) = √(n/(2e)) → +∞.",
    "Trouver u, v ∈ ℤ tels que 17u + 23v = 1.",
    "∑(n≥1) xⁿ/(n(n+1)).",
    "∃c ∈ ]a,b[ tel que f'(c) = 0.",
    "fₙ(x) = xⁿ sur [0,1]",
    "f = 𝟙_ℚ (indicatrice des rationnels)",
    "χ_A(X) = (X-1)²(X-4).",
    "P(X ≥ a) ≤ E[X]/a.",
    "TCL : Z = (S - 500)/15.81 ≈ N(0,1).",
    "Les classes partitionnent G, donc |G| = [G:H] · |H|.",
    "λ₁ = 1 (double), λ₂ = 4 (simple).",
    "E₁ = {x+y+z=0}, E₄ = Vect(1,1,1).",
    "N² = 0, donc A = I + N avec N nilpotent.",
    "Wₙ = (n-1)/n × Wₙ₋₂ pour n ≥ 2.",
    "∫₀¹ fₙ = ½(1 - e⁻ⁿ) → ½ ≠ 0 = ∫f.",
    "Aⁿ = (I+N)ⁿ = I + nN",
    "Convergence : |xₙ − x*| ≤ kⁿ|x₀ − x*| → 0.",
    "360 = 2³·3²·5.",
    "φ(360) = 360·(1 - 1/2)·(1 - 1/3)·(1 - 1/5).",
  ];

  for (final t in tests) {
    print('IN:  $t');
    print('OUT: ${toLatex(t)}');
    print('');
  }
}
