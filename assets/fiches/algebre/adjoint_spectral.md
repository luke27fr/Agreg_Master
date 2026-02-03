# Adjoint et Théorème Spectral

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Dans un [espace euclidien](def:espace euclidien) ou hermitien, l'adjoint $f^*$ de $f$ est défini par $\langle f(x), y \rangle = \langle x, f^*(y) \rangle$.
> * **Existence :** En dimension finie, $f^*$ existe toujours et est unique.
> * **Matrice :** Si $M$ est la matrice de $f$ dans une BON, alors $M^* = \bar{M}^T$ (transconjuguée).
> * **Autoadjoint :** $f = f^*$. En réel : matrice symétrique. En complexe : matrice hermitienne.
> * **Normal :** $f f^* = f^* f$. Inclut les autoadjoints, les unitaires, les antisymétriques.
> * **Théorème spectral :** Tout endomorphisme normal d'un espace hermitien est [diagonalisable](def:diagonalisable) dans une BON.
> * **Cas réel :** Tout endomorphisme symétrique d'un espace euclidien est diagonalisable dans une BON avec valeurs propres réelles.
> * **Décomposition polaire :** $f = u \circ s$ avec $u$ unitaire et $s$ autoadjoint positif.

> [!WARNING]
> ### 2. Pièges à éviter
> * **BON obligatoire :** L'adjoint dépend du [produit scalaire](def:produit scalaire). La matrice de $f^*$ n'est $M^T$ que dans une BON !
> * **Normal ≠ diagonalisable sur $\mathbb{R}$ :** Une rotation non triviale est normale mais pas diagonalisable sur $\mathbb{R}$.
> * **Autoadjoint ≠ symétrique :** "Symétrique" concerne la matrice, "autoadjoint" l'endomorphisme.
> * **Valeurs propres :** Autoadjoint $\Rightarrow$ valeurs propres réelles. Unitaire $\Rightarrow$ valeurs propres de module 1.
> * **Sous-espaces propres :** Pour un endomorphisme normal, les sous-espaces propres sont **orthogonaux**.

> [!TIP]
> ### 3. Exercice Type : Diagonalisation orthogonale
> **Énoncé :** Diagonaliser $A = \begin{pmatrix} 2 & 1 \\ 1 & 2 \end{pmatrix}$ dans une base orthonormée.
>
> **Solution Détaillée :**
> 1. **Valeurs propres :** $\det(A - \lambda I) = (2-\lambda)^2 - 1 = \lambda^2 - 4\lambda + 3 = (\lambda - 1)(\lambda - 3)$.
>    $\lambda_1 = 1$, $\lambda_2 = 3$.
> 2. **Vecteurs propres :**
>    - $\lambda = 1$ : $(A - I)v = 0 \Rightarrow v_1 = (1, -1)$.
>    - $\lambda = 3$ : $(A - 3I)v = 0 \Rightarrow v_2 = (1, 1)$.
> 3. **Normalisation :** $e_1 = \frac{1}{\sqrt{2}}(1, -1)$, $e_2 = \frac{1}{\sqrt{2}}(1, 1)$.
> 4. **Vérification :** $\langle e_1, e_2 \rangle = \frac{1}{2}(1 - 1) = 0$ ✓

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème spectral.
>   * **Rép :** Tout endomorphisme autoadjoint d'un espace euclidien est diagonalisable dans une BON, avec valeurs propres réelles.
> * **Q2 :** Qu'est-ce qu'un endomorphisme positif ?
>   * **Rép :** Autoadjoint avec toutes ses valeurs propres $\geq 0$. Équivalent à $\langle f(x), x \rangle \geq 0$ pour tout $x$.
> * **Q3 :** Comment montrer qu'une matrice symétrique réelle a des valeurs propres réelles ?
>   * **Rép :** Si $Av = \lambda v$ avec $v \neq 0$, alors $\lambda \|v\|^2 = \bar{v}^T A v = v^T A v = \bar{\lambda} \|v\|^2$, donc $\lambda = \bar{\lambda}$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet sur le théorème spectral.
* **J. Grifone**, *Algèbre linéaire* — Clair sur l'aspect géométrique des endomorphismes autoadjoints.
