# Couples de Variables Aléatoires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un couple $(X, Y)$ de variables aléatoires est caractérisé par sa loi jointe.
> * **Loi jointe :** $\mathbb{P}((X, Y) \in A)$ pour $A \subset \mathbb{R}^2$.
> * **Lois marginales :** $\mathbb{P}(X \in B) = \mathbb{P}((X, Y) \in B \times \mathbb{R})$.
> * **Densité jointe :** $f_{X,Y}(x, y)$ telle que $\mathbb{P}((X, Y) \in A) = \iint_A f_{X,Y}(x, y) dx dy$.
> * **Marginales :** $f_X(x) = \int f_{X,Y}(x, y) dy$.
> * **[Indépendance](def:independance) :** $f_{X,Y}(x, y) = f_X(x) f_Y(y)$, ou $\mathbb{P}(X \in A, Y \in B) = \mathbb{P}(X \in A)\mathbb{P}(Y \in B)$.
> * **[Covariance](def:covariance) :** $\text{Cov}(X, Y) = \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y]$.
> * **Corrélation :** $\rho(X, Y) = \frac{\text{Cov}(X, Y)}{\sigma_X \sigma_Y} \in [-1, 1]$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Marginales ne déterminent pas la jointe :** Infinité de lois jointes pour des marginales fixées.
> * **Non corrélées ≠ indépendantes :** $\text{Cov}(X, Y) = 0$ n'implique pas l'indépendance.
> * **Contre-exemple :** $X \sim \mathcal{U}([-1, 1])$, $Y = X^2$. $\text{Cov}(X, Y) = 0$ mais pas indépendantes.
> * $\text{Var}(X + Y)$ **:** $= \text{Var}(X) + \text{Var}(Y) + 2\text{Cov}(X, Y)$.
> * **Loi conditionnelle :** $f_{Y|X=x}(y) = \frac{f_{X,Y}(x, y)}{f_X(x)}$.

> [!TIP]
> ### 3. Exercice Type : Indépendance et corrélation
> **Énoncé :** Soit $(X, Y)$ uniformément réparti sur le disque unité. Sont-ils indépendants ? Corrélés ?
>
> **Solution Détaillée :**
> 1. **Densité jointe :** $f_{X,Y}(x, y) = \frac{1}{\pi}$ si $x^2 + y^2 \leq 1$, 0 sinon.
> 2. **Indépendance :** Les marginales ne sont pas uniformes. $f_X(x) = \frac{2\sqrt{1-x^2}}{\pi}$.
>    $f_{X,Y}(x, y) \neq f_X(x) f_Y(y)$ car le support n'est pas un rectangle.
>    **Pas indépendants.**
> 3. **Corrélation :** Par symétrie, $\mathbb{E}[X] = \mathbb{E}[Y] = 0$.
>    $\mathbb{E}[XY] = \frac{1}{\pi}\iint_{x^2+y^2 \leq 1} xy \, dx\, dy = 0$ (intégrale impaire).
>    $\text{Cov}(X, Y) = 0$. **Non corrélés.**
> 4. **Conclusion :** Non corrélés mais dépendants !

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner un exemple de variables non corrélées mais dépendantes.
>   * **Rép :** $X$ uniforme sur $\{-1, 0, 1\}$, $Y = X^2$. $\text{Cov}(X, Y) = 0$ mais $Y$ est fonction de $X$.
> * **Q2 :** Qu'est-ce que la formule de transfert ?
>   * **Rép :** $\mathbb{E}[g(X, Y)] = \iint g(x, y) f_{X,Y}(x, y) dx dy$.
> * **Q3 :** Comment calculer la loi de $X + Y$ ?
>   * **Rép :** Convolution : $f_{X+Y}(z) = \int f_X(x) f_Y(z - x) dx$ si $X, Y$ indépendantes.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Lois marginales, conditionnelles et indépendance.
* **C. Deschamps**, *Probabilités* — Exercices sur les couples de variables aléatoires.
