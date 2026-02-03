# Limites et Continuité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La [continuité](def:continuite) est la propriété fondamentale liant les valeurs d'une fonction à ses valeurs voisines.
> * **Limite :** $\lim_{x \to a} f(x) = \ell$ si $\forall \varepsilon > 0, \exists \delta > 0, |x - a| < \delta \Rightarrow |f(x) - \ell| < \varepsilon$.
> * **Continuité en $a$ :** $\lim_{x \to a} f(x) = f(a)$.
> * **Continuité sur $I$ :** Continue en tout point de $I$.
> * **Théorème des valeurs intermédiaires (TVI) :** $f$ continue sur $[a,b]$, $f(a) < 0 < f(b) \Rightarrow \exists c \in ]a,b[, f(c) = 0$.
> * **Image d'un segment :** $f$ continue sur $[a,b]$ $\Rightarrow$ $f([a,b])$ est un segment.
> * **[Uniforme continuité](def:uniforme continuite) :** $\forall \varepsilon > 0, \exists \delta > 0, \forall x, y, |x-y| < \delta \Rightarrow |f(x) - f(y)| < \varepsilon$.
> * **Théorème de Heine :** $f$ continue sur un [compact](def:compact) $\Rightarrow$ $f$ uniformément continue.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Limite ≠ valeur :** Une limite peut exister sans que $f(a)$ soit défini.
> * **Continue ≠ dérivable :** $|x|$ est continue en 0 mais pas dérivable.
> * **Uniforme ≠ simple :** $x \mapsto x^2$ est continue sur $\mathbb{R}$ mais pas uniformément continue.
> * **TVI :** Ne donne pas l'unicité ! Il peut y avoir plusieurs zéros.
> * **Composition :** La composée de fonctions continues est continue.

> [!TIP]
> ### 3. Exercice Type : Application du TVI
> **Énoncé :** Montrer que $x^3 + x - 1 = 0$ admet une unique solution dans $[0, 1]$.
>
> **Solution Détaillée :**
> 1. **Existence :** Soit $f(x) = x^3 + x - 1$.
>    - $f(0) = -1 < 0$
>    - $f(1) = 1 > 0$
>    - $f$ continue sur $[0, 1]$
>    - Par le TVI, $\exists c \in ]0, 1[$ tel que $f(c) = 0$.
> 2. **Unicité :** $f'(x) = 3x^2 + 1 > 0$ sur $\mathbb{R}$.
>    - $f$ strictement croissante sur $[0, 1]$.
>    - Donc au plus un zéro.
> 3. **Conclusion :** Unique solution $c \approx 0.6824$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner une fonction continue sur $\mathbb{R}$ non uniformément continue.
>   * **Rép :** $f(x) = x^2$. Pour $\varepsilon = 1$, quelque soit $\delta$, on peut trouver $x, y$ avec $|x - y| < \delta$ mais $|x^2 - y^2| > 1$ (prendre $x$ grand).
> * **Q2 :** Qu'est-ce qu'une fonction [lipschitzienne](def:lipschitzienne) ?
>   * **Rép :** $|f(x) - f(y)| \leq k|x - y|$ pour une constante $k$. Implique l'uniforme continuité.
> * **Q3 :** L'image d'un ouvert par une fonction continue est-elle un ouvert ?
>   * **Rép :** Non en général. Contre-exemple : $f(x) = x^2$, $f(\mathbb{R}) = [0, +\infty[$ n'est pas ouvert.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
