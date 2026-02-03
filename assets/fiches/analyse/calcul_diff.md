# Calcul Différentiel

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le calcul différentiel étend la notion de dérivée aux fonctions de plusieurs variables.
> * **Différentielle :** $f : \mathbb{R}^n \to \mathbb{R}^m$ est différentiable en $a$ si $f(a+h) = f(a) + L(h) + o(\|h\|)$ avec $L$ linéaire.
> * **Gradient :** $\nabla f = (\frac{\partial f}{\partial x_1}, \ldots, \frac{\partial f}{\partial x_n})$ pour $f : \mathbb{R}^n \to \mathbb{R}$.
> * **Jacobienne :** Matrice $J_f = (\frac{\partial f_i}{\partial x_j})$ pour $f : \mathbb{R}^n \to \mathbb{R}^m$.
> * **Règle de la chaîne :** $d(g \circ f)_a = dg_{f(a)} \circ df_a$.
> * **Théorème d'inversion locale :** Si $df_a$ est inversible, $f$ est un [difféomorphisme](def:diffeomorphisme) local près de $a$.
> * **Théorème des fonctions implicites :** Sous conditions, $F(x, y) = 0$ définit $y$ comme fonction de $x$.
> * **$C^k$ :** Toutes les dérivées partielles jusqu'à l'ordre $k$ existent et sont continues.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Dérivées partielles ≠ différentiable :** L'existence des dérivées partielles ne suffit pas pour la différentiabilité.
> * **Contre-exemple :** $f(x,y) = \frac{xy}{x^2+y^2}$ (et 0 en 0) a des dérivées partielles en 0 mais n'est pas continue.
> * **Schwarz :** $\frac{\partial^2 f}{\partial x \partial y} = \frac{\partial^2 f}{\partial y \partial x}$ si $f$ est [$C^2$](def:c1).
> * **Inversion locale :** Résultat **local**, pas global.
> * **Jacobienne :** C'est la matrice de $df$ dans les bases canoniques.

> [!TIP]
> ### 3. Exercice Type : Fonctions implicites
> **Énoncé :** Soit $F(x, y) = x^2 + y^2 - 1$. Près de $(0, 1)$, peut-on exprimer $y$ en fonction de $x$ ?
>
> **Solution Détaillée :**
> 1. **Vérification :** $F(0, 1) = 0 + 1 - 1 = 0$ ✓
> 2. **Dérivée partielle :** $\frac{\partial F}{\partial y} = 2y$. En $(0, 1)$ : $\frac{\partial F}{\partial y} = 2 \neq 0$.
> 3. **Th. des fonctions implicites :** Il existe $\varphi$ définie au voisinage de 0 telle que $F(x, \varphi(x)) = 0$.
> 4. **Explicitement :** $y = \sqrt{1 - x^2}$ près de $(0, 1)$.
> 5. **Dérivée :** $\varphi'(x) = -\frac{\partial F/\partial x}{\partial F/\partial y} = -\frac{2x}{2y} = -\frac{x}{y}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème d'inversion locale.
>   * **Rép :** Si $f$ est $C^1$ et $df_a$ inversible, alors $f$ est un $C^1$-difféomorphisme d'un voisinage de $a$ sur un voisinage de $f(a)$.
> * **Q2 :** Quelle est la différence entre dérivées partielles et différentiabilité ?
>   * **Rép :** Les dérivées partielles mesurent la variation dans les directions des axes. La différentiabilité assure une approximation linéaire dans **toutes** les directions.
> * **Q3 :** Application de l'inversion locale : pourquoi $\exp : M_n(\mathbb{R}) \to GL_n(\mathbb{R})$ est-elle surjective près de $I$ ?
>   * **Rép :** $d\exp_0 = \text{Id}$ est inversible, donc $\exp$ est un difféo local en 0, son image contient un voisinage de $I$.

### 5. Références Bibliographiques
* **F. Rouvière**, *Petit guide de calcul différentiel* — Très pédagogique sur le calcul différentiel.
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
