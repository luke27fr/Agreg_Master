# Vecteurs Aléatoires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **vecteur aléatoire** est une application mesurable $X : \Omega \to \mathbb{R}^n$.
> * **Loi conjointe :** $\mathbb{P}_{(X,Y)}(A \times B) = \mathbb{P}(X \in A, Y \in B)$.
> * **Lois marginales :** $\mathbb{P}_X(A) = \mathbb{P}_{(X,Y)}(A \times \mathbb{R})$.
> * **Densité conjointe :** $f_{X,Y}(x,y)$ telle que $\mathbb{P}((X,Y) \in D) = \iint_D f_{X,Y} dx dy$.
> * **Marginales :** $f_X(x) = \int f_{X,Y}(x,y) dy$.
> * **[Indépendance](def:independance) :** $f_{X,Y}(x,y) = f_X(x) f_Y(y)$ pour presque tout $(x,y)$.
> * **Espérance vectorielle :** $\mathbb{E}[X] = (\mathbb{E}[X_1], ..., \mathbb{E}[X_n])$.
> * **Matrice de covariance :** $\Sigma_{ij} = \text{Cov}(X_i, X_j)$, matrice symétrique positive.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Marginales $\not\Rightarrow$ conjointe :** Connaître les marginales ne détermine pas la loi conjointe.
> * **Non corrélées $\neq$ indépendantes :** $\text{Cov}(X,Y) = 0$ n'implique pas l'indépendance.
> * **Densité conditionnelle :** $f_{Y|X=x}(y) = \frac{f_{X,Y}(x,y)}{f_X(x)}$ n'est définie que si $f_X(x) > 0$.
> * **Vecteur gaussien :** Toutes les combinaisons linéaires sont gaussiennes (pas juste les marginales !).

> [!TIP]
> ### 3. Exercice Type : Somme de v.a. indépendantes
> **Énoncé :** Si $X, Y$ indépendantes de densités $f_X, f_Y$, trouver la densité de $Z = X + Y$.
>
> **Solution Détaillée :**
> 1. **Fonction de répartition :** $F_Z(z) = \mathbb{P}(X + Y \leq z)$.
> 2. **Intégrale double :** $= \iint_{x+y \leq z} f_X(x) f_Y(y) dx dy$.
> 3. **Changement d'ordre :** $= \int_{-\infty}^{+\infty} f_X(x) \left( \int_{-\infty}^{z-x} f_Y(y) dy \right) dx$.
> 4. **Dérivation :** $f_Z(z) = \int_{-\infty}^{+\infty} f_X(x) f_Y(z-x) dx$.
> 5. **Conclusion :** $f_Z = f_X * f_Y$ (produit de convolution).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'un vecteur gaussien ?
>   * **Rép :** Vecteur dont toute combinaison linéaire des composantes est gaussienne.
> * **Q2 :** Deux gaussiennes non corrélées sont-elles indépendantes ?
>   * **Rép :** Oui, **si** elles font partie d'un même vecteur gaussien.
> * **Q3 :** Quelle est la densité de $(X, Y)$ uniformes sur le disque unité ?
>   * **Rép :** $f(x,y) = \frac{1}{\pi} \mathbf{1}_{x^2+y^2 \leq 1}$.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Chapitre complet sur les vecteurs gaussiens.
* **C. Deschamps**, *Probabilités* — Approche pédagogique des couples de variables.
