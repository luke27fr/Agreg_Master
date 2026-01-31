# Espaces de Hilbert

> [!NOTE]
> ### 1. Définitions de base
> Un [espace de Hilbert](def:hilbert) est un espace [préhilbertien](def:prehilbertien) complet pour la norme induite.
> * **Produit scalaire :** Forme sesquilinéaire à droite, hermitienne définie positive $\langle \cdot, \cdot \rangle$.
> * **Identité du parallélogramme :** Caractérise les normes issues d'un produit scalaire :
> $$\|x+y\|^2 + \|x-y\|^2 = 2(\|x\|^2 + \|y\|^2)$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Complétude :** L'espace des fonctions continues sur $[0,1]$ muni de la norme $L^2$ n'est pas un Hilbert.
> * **Projection :** Sur un sous-espace vectoriel, la [projection orthogonale](def:projection) existe toujours si l'espace est de dimension finie. En dimension infinie, elle exige que le sous-espace soit **fermé**.

> [!TIP]
> ### 3. Exercice : Projection
> **Énoncé :** Soit $H$ un Hilbert et $K$ un [convexe](def:convexe) fermé non vide. Montrer qu'il existe un unique $p \in K$ réalisant la distance $d(x, K)$.
>
> #### Solution Détaillée :
> **1. Existence (Suite minimisante) :**
> Soit $\delta = d(x, K)$. Il existe une suite $(y_n) \in K$ telle que $\|x - y_n\| \to \delta$.
> On utilise l'identité du parallélogramme sur les vecteurs $x-y_n$ et $x-y_m$.
> Comme $K$ est convexe, le milieu $\frac{y_n+y_m}{2}$ est dans $K$. On en déduit alors que $\|y_n - y_m\|^2 \to 0$.
> La suite $(y_n)$ est de Cauchy dans $H$ complet, donc elle converge vers un $p$. Comme $K$ est fermé, $p \in K$.
>
> **2. Unicité :**
> Si $p_1$ et $p_2$ sont deux solutions, alors $\|x-p_1\|=\delta$ et $\|x-p_2\|=\delta$.
> Par stricte convexité de la boule, le milieu $\frac{p_1+p_2}{2}$ serait à une distance strictement inférieure à $\delta$, ce qui contredit la définition de l'infimum, sauf si $p_1 = p_2$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la différence entre une base hilbertienne et une base algébrique ?
>   * **Rép :** Une base algébrique (Hamel) génère l'espace par combinaisons linéaires **finies**. Une base hilbertienne le génère par séries (sommes infinies dénombrables).
> * **Q2 :** Tout espace préhilbertien admet-il une base orthonormée ?
>   * **Rép :** Oui (procédé de Gram-Schmidt si séparable, ou Zorn sinon), mais elle ne sera "base de Hilbert" que si l'espace est complet.
> * **Q3 :** Quel est le dual d'un espace de Hilbert ?
>   * **Rép :** Il est isomorphe à l'espace lui-même (Théorème de Riesz-Fréchet). Toute forme linéaire continue s'écrit $L(x) = \langle x, a \rangle$.