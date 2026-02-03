# Géométrie Matricielle

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> L'espace $\mathcal{M}_n(\mathbb{K})$ des matrices carrées est un espace vectoriel de dimension $n^2$.
> * **Trace :** $\text{Tr}(A) = \sum a_{ii}$. Forme linéaire, invariante par similitude.
> * **[Déterminant](def:determinant) :** Forme $n$-linéaire alternée. $\det(AB) = \det(A)\det(B)$.
> * **$GL_n(\mathbb{K})$ :** Matrices inversibles, $= \{A : \det(A) \neq 0\}$. Ouvert [dense](def:dense) dans $\mathcal{M}_n$.
> * **$SL_n(\mathbb{K})$ :** Matrices de déterminant 1. Sous-groupe de $GL_n$.
> * **Similitude :** $A \sim B$ si $B = P^{-1}AP$. Mêmes valeurs propres, trace, déterminant, polynômes caractéristique et minimal.
> * **Congruence :** $A \equiv B$ si $B = P^T A P$. Pour les formes quadratiques.
> * **Rang :** $\text{rg}(A) = \dim(\text{Im}(A))$. Invariant par multiplication par matrice inversible.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Similitude ≠ égalité :** Deux matrices semblables ne sont pas égales en général.
> * **Commutativité :** $AB \neq BA$ en général. Mais $\text{Tr}(AB) = \text{Tr}(BA)$.
> * **Inversibilité :** $AB$ inversible n'implique pas $A$ ou $B$ inversible (sauf si l'un est carré).
> * **$GL_n$ non connexe sur $\mathbb{R}$ :** Deux composantes connexes : $\det > 0$ et $\det < 0$.
> * **Exponentielle :** $e^{A+B} = e^A e^B$ seulement si $AB = BA$.

> [!TIP]
> ### 3. Exercice Type : Densité des diagonalisables
> **Énoncé :** Montrer que les matrices diagonalisables sont denses dans $\mathcal{M}_n(\mathbb{C})$.
>
> **Solution Détaillée :**
> 1. **Matrices à valeurs propres distinctes :** Si $A$ a $n$ valeurs propres distinctes, elle est [diagonalisable](def:diagonalisable).
> 2. **Discriminant :** Le discriminant $\Delta$ de $\chi_A$ est un polynôme en les coefficients de $A$.
> 3. **Non-nullité :** L'ensemble $\{\Delta \neq 0\}$ est un ouvert de Zariski, donc dense.
> 4. **Approximation :** Toute matrice $A$ est limite de matrices $A_\epsilon$ avec valeurs propres distinctes.
> 5. **Conclusion :** Les matrices diagonalisables (sur $\mathbb{C}$) sont denses dans $\mathcal{M}_n(\mathbb{C})$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** $GL_n(\mathbb{R})$ est-il connexe ?
>   * **Rép :** Non, il a deux composantes connexes : $GL_n^+$ (où $\det > 0$) et $GL_n^-$ (où $\det < 0$).
> * **Q2 :** Quelle est la dimension de $SL_n(\mathbb{K})$ comme variété ?
>   * **Rép :** $n^2 - 1$ (une équation $\det = 1$ en dimension $n^2$).
> * **Q3 :** Qu'est-ce que le commutant d'une matrice ?
>   * **Rép :** $\text{Com}(A) = \{B : AB = BA\}$. Si $A$ est diagonalisable à valeurs propres distinctes, $\text{Com}(A)$ est l'ensemble des polynômes en $A$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Matrices).
* **R. Music**, *Algèbre MPSI-MP* (Géométrie des matrices).
