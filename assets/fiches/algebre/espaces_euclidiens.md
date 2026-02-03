# Espaces Euclidiens

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **[espace euclidien](def:espace euclidien)** est un espace vectoriel réel de dimension finie muni d'un [produit scalaire](def:produit scalaire).
> * **Produit scalaire :** Forme bilinéaire symétrique définie positive : $\langle x, y \rangle$.
> * **[Norme](def:norme) :** $\|x\| = \sqrt{\langle x, x \rangle}$. Vérifie Cauchy-Schwarz : $|\langle x, y \rangle| \leq \|x\| \|y\|$.
> * **[Orthogonalité](def:orthogonal) :** $x \perp y$ si $\langle x, y \rangle = 0$. Base orthonormée (BON) : $\langle e_i, e_j \rangle = \delta_{ij}$.
> * **Procédé de Gram-Schmidt :** Orthonormalisation d'une famille libre.
> * **Supplémentaire orthogonal :** $E = F \oplus F^\perp$ pour tout sous-espace $F$.
> * **[Projection](def:projection) orthogonale :** $p_F(x)$ est l'unique point de $F$ minimisant $\|x - y\|$.
> * **Matrice orthogonale :** $P \in O_n(\mathbb{R})$ ssi $P^T P = I_n$ ssi les colonnes forment une BON.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Définie positive :** $\langle x, x \rangle \geq 0$ avec égalité ssi $x = 0$. Essentiel pour avoir une norme.
> * **Cauchy-Schwarz :** L'égalité a lieu ssi $x$ et $y$ sont colinéaires.
> * **Gram-Schmidt :** Ne pas oublier de normaliser après orthogonalisation !
> * **$F^{\perp\perp}$ :** En dimension finie, $F^{\perp\perp} = F$. En dimension infinie, ce n'est pas toujours vrai.
> * **Matrice de Gram :** $G_{ij} = \langle e_i, e_j \rangle$. Elle est définie positive ssi la famille est libre.

> [!TIP]
> ### 3. Exercice Type : Projection orthogonale
> **Énoncé :** Dans $\mathbb{R}^3$ euclidien canonique, projeter $v = (1, 2, 3)$ sur le plan $P : x + y + z = 0$.
>
> **Solution Détaillée :**
> 1. **Normale au plan :** $n = (1, 1, 1)$.
> 2. **Projection sur $n$ :** $p_n(v) = \frac{\langle v, n \rangle}{\|n\|^2} n = \frac{1+2+3}{3} (1,1,1) = 2(1,1,1) = (2,2,2)$.
> 3. **Projection sur $P$ :** $p_P(v) = v - p_n(v) = (1,2,3) - (2,2,2) = (-1, 0, 1)$.
> 4. **Vérification :** $(-1) + 0 + 1 = 0$ ✓

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème spectral pour les matrices symétriques réelles.
>   * **Rép :** Toute matrice symétrique réelle est [diagonalisable](def:diagonalisable) dans une base orthonormée. Ses valeurs propres sont réelles.
> * **Q2 :** Qu'est-ce qu'une isométrie vectorielle ?
>   * **Rép :** Application linéaire conservant le produit scalaire : $\langle f(x), f(y) \rangle = \langle x, y \rangle$. Équivalent à $\|f(x)\| = \|x\|$.
> * **Q3 :** Quel est le lien entre $O_n(\mathbb{R})$ et $SO_n(\mathbb{R})$ ?
>   * **Rép :** $SO_n(\mathbb{R}) = \{P \in O_n : \det(P) = 1\}$ (rotations). $O_n = SO_n \sqcup \{P : \det(P) = -1\}$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet sur les espaces euclidiens.
* **J. Grifone**, *Algèbre linéaire* — Clair sur l'aspect géométrique et les projections.
