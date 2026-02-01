# Théorème Spectral

> [!NOTE]
> ### 1. Énoncé (Cas Réel)
> Soit $E$ un [espace euclidien](def:euclidien) et $u$ un endomorphisme [symétrique](def:symetrique) de $E$.
> Alors :
> * **Spectre :** Les [valeurs propres](def:valeur_propre) de $u$ sont toutes réelles.
> * **Orthogonalité :** Les sous-espaces propres sont deux à deux orthogonaux.
> * **Conclusion :** $u$ est [diagonalisable](def:diagonalisable) dans une base orthonormée.
>
> **Matriciellement :** Toute matrice symétrique réelle $S \in \mathcal{S}_n(\mathbb{R})$ est diagonalisable via une [matrice orthogonale](def:matrice_orthogonale) :
> $$S = P D P^T \quad \text{avec } P \in O_n(\mathbb{R})$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Le corps de base :** Attention, une matrice symétrique **complexe** n'est pas forcément diagonalisable. Le théorème spectral exige un produit scalaire.
> * **Symétrique vs Auto-adjoint :** Ne pas confondre. En dimension finie et base orthonormée, c'est pareil.

> [!TIP]
> ### 3. Exercice : Racine carrée
> **Énoncé :** Soit $A \in \mathcal{S}_n^{++}(\mathbb{R})$. Montrer qu'il existe une unique matrice $R \in \mathcal{S}_n^{++}(\mathbb{R})$ telle que $R^2 = A$.
>
> #### Solution Détaillée :
> **1. Existence :**
> D'après le théorème spectral, $A$ est diagonalisable dans une base orthonormée. Il existe $P \in O_n(\mathbb{R})$ et $D = \text{diag}(\lambda_i)$ tels que $A = P D P^T$.
> Comme $A \in \mathcal{S}_n^{++}$, les valeurs propres $\lambda_i$ sont strictement positives.
> On pose $\Delta = \text{diag}(\sqrt{\lambda_i})$ et on construit $R = P \Delta P^T$.
> On vérifie que $R$ est symétrique (évident), définie positive (ses valeurs propres sont $\sqrt{\lambda_i} > 0$ ) et que $R^2 = P \Delta^2 P^T = A$.
>
> **2. Unicité :**
> Soit $M \in \mathcal{S}_n^{++}$ une autre solution telle que $M^2 = A$.
> * Comme $M^2 = A$, $M$ commute avec $A$ (car $MA = M^3 = AM$ ).
> * Donc $M$ stabilise les sous-espaces propres de $A$.
> * La restriction de $M$ à chaque espace propre $E_{\lambda}(A)$ est une matrice symétrique positive dont le carré vaut $\lambda I$.
> * Sur cet espace, $M$ est donc l'homothétie de rapport $\sqrt{\lambda}$.
> * Conclusion : $M$ coïncide nécessairement avec $R$ sur chaque sous-espace propre, donc $M = R$.
> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** La décomposition de Dunford utilise-t-elle le théorème spectral ?
>   * **Rép :** Non. Dunford concerne la réduction via polynômes annulateurs sur un corps quelconque, sans besoin de produit scalaire.
> * **Q2 :** Peut-on diagonaliser une matrice antisymétrique réelle ?
>   * * **Rép :** Pas dans $\mathbb{R}$ (valeurs propres imaginaires pures), mais oui dans $\mathbb{C}$ car elle est normale (c'est-à-dire $A A^* = A^* A$ ).
> * **Q3 :** A-t-on toujours $\|Ax\| \le \|A\| \|x\|$ ?
>   * **Rép :** Oui par définition de la norme subordonnée. Pour une symétrique, $\|A\|_2 = \rho(A)$ (rayon spectral).

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (La référence incontournable pour les démos).
* **J. Grifone**, *Algèbre Linéaire* (Très clair sur l'aspect géométrique).
* **G. Peyré**, *L'algèbre discrète de la transformée de Fourier* (Pour des applications plus poussées).