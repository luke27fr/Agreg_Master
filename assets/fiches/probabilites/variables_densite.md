# Variables Aléatoires à Densité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une [variable aléatoire](def:va) $X$ est **à densité** s'il existe $f : \mathbb{R} \to \mathbb{R}^+$ intégrable telle que :
> $$\mathbb{P}(X \in A) = \int_A f(x) dx$$
> * **Conditions :** $f \geq 0$ et $\int_{-\infty}^{+\infty} f(x) dx = 1$.
> * **Fonction de répartition :** $F(x) = \int_{-\infty}^x f(t) dt$, et $f = F'$ p.p.
> * **Espérance :** $\mathbb{E}[X] = \int x f(x) dx$ si l'intégrale converge absolument.
> * **Transfert :** $\mathbb{E}[g(X)] = \int g(x) f(x) dx$.
> * **Changement de variable :** Si $Y = g(X)$ avec $g$ bijective $\mathcal{C}^1$, $f_Y(y) = f_X(g^{-1}(y)) |{(g^{-1})}'(y)|$.
> * **Singletons de mesure nulle :** $\mathbb{P}(X = a) = 0$ pour tout $a$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Densité non unique :** On peut modifier $f$ sur un ensemble de mesure nulle.
> * **Existence de l'espérance :** L'intégrale $\int |x| f(x) dx$ doit converger.
> * **Changement de variable :** Ne pas oublier le Jacobien $|g'|^{-1}$.
> * **Mélange discret/continu :** Une v.a. peut être ni discrète ni à densité.

> [!TIP]
> ### 3. Exercice Type : Loi de $X^2$
> **Énoncé :** Soit $X \sim \mathcal{N}(0,1)$. Trouver la loi de $Y = X^2$.
>
> **Solution Détaillée :**
> 1. **Fonction de répartition :** Pour $y > 0$,
>    $F_Y(y) = \mathbb{P}(X^2 \leq y) = \mathbb{P}(-\sqrt{y} \leq X \leq \sqrt{y})$.
> 2. **Calcul :** $= F_X(\sqrt{y}) - F_X(-\sqrt{y}) = 2F_X(\sqrt{y}) - 1$.
> 3. **Densité :** $f_Y(y) = F'_Y(y) = 2 f_X(\sqrt{y}) \cdot \frac{1}{2\sqrt{y}}$.
> 4. **Simplification :** $f_Y(y) = \frac{1}{\sqrt{2\pi y}} e^{-y/2}$ pour $y > 0$.
> 5. **Reconnaissance :** C'est $\chi^2(1) = \Gamma(1/2, 1/2)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment trouver la densité de $Y = g(X)$ ?
>   * **Rép :** Méthode de la fonction de répartition : calculer $F_Y(y) = \mathbb{P}(g(X) \leq y)$ puis dériver.
> * **Q2 :** Si $X$ a une densité, $2X$ aussi ?
>   * **Rép :** Oui, $f_{2X}(y) = \frac{1}{2} f_X(y/2)$.
> * **Q3 :** Quelle est la densité de $-X$ si $X$ a densité $f$ ?
>   * **Rép :** $f_{-X}(y) = f(-y)$. Si $f$ est symétrique, $-X$ a même loi que $X$.

### 5. Références Bibliographiques
* **J. Jacod, P. Protter**, *Probability Essentials*.
* **P. Billingsley**, *Probability and Measure*.
