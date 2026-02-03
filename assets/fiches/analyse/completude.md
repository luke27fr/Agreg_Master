# Complétude

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un espace métrique est [complet](def:complet) si toute [suite de Cauchy](def:suite de cauchy) converge.
> * **Suite de Cauchy :** $(x_n)$ telle que $\forall \varepsilon > 0, \exists N, \forall m, n \geq N, d(x_m, x_n) < \varepsilon$.
> * **Exemples complets :** $\mathbb{R}$, $\mathbb{R}^n$, espaces de [Banach](def:banach), espaces de [Hilbert](def:hilbert).
> * **Contre-exemple :** $\mathbb{Q}$ n'est pas complet — suite de rationnels $\to \sqrt{2}$.
> * **Fermé d'un complet :** Un fermé d'un espace complet est complet.
> * **Complétion :** Tout espace métrique se plonge densément dans un espace complet unique (à isométrie près).
> * **Théorème du point fixe de Banach :** $f : E \to E$ contractante ($d(f(x), f(y)) \leq k \cdot d(x, y)$, $k < 1$) sur un complet $\Rightarrow$ unique point fixe.
> * **Théorème de Baire :** Dans un complet, l'intersection dénombrable d'ouverts denses est dense.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Complet ≠ compact :** $\mathbb{R}$ est complet mais pas compact.
> * **Cauchy ≠ convergente :** Dans un espace non complet, une suite de Cauchy peut ne pas converger.
> * **Sous-espace :** Un sous-espace d'un complet n'est complet que s'il est **fermé**.
> * **Dimension infinie :** Vérifier la complétude est plus délicat (normes non équivalentes).
> * **Contraction :** Le rapport $k$ doit être **strictement** inférieur à 1.

> [!TIP]
> ### 3. Exercice Type : Point fixe de Banach
> **Énoncé :** Montrer que $f(x) = \frac{1}{2}(x + \frac{2}{x})$ admet un unique point fixe dans $[1, 2]$.
>
> **Solution Détaillée :**
> 1. **Point fixe :** $f(x) = x \Leftrightarrow x = \frac{1}{2}(x + \frac{2}{x}) \Leftrightarrow x^2 = 2 \Leftrightarrow x = \sqrt{2}$.
> 2. $f([1,2]) \subset [1,2]$ **:** $f(1) = 1.5$, $f(2) = 1.5$. $f$ décroît puis croît, min en $\sqrt{2} \approx 1.414$.
> 3. **Contraction :** $f'(x) = \frac{1}{2}(1 - \frac{2}{x^2})$. Sur $[1, 2]$ : $|f'(x)| \leq \frac{1}{2}$.
>    Par le TAF : $|f(x) - f(y)| \leq \frac{1}{2}|x - y|$.
> 4. **Conclusion :** Par Banach, unique point fixe $\sqrt{2}$ dans $[1, 2]$ — complet car fermé de $\mathbb{R}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Baire.
>   * **Rép :** Dans un espace métrique complet, l'intersection dénombrable d'ouverts denses est dense.
> * **Q2 :** Application de Baire : $\mathbb{R}$ est-il dénombrable ?
>   * **Rép :** Non. Si $\mathbb{R} = \bigcup \{r_n\}$, alors $\mathbb{R} = \bigcup F_n$ avec $F_n$ fermés d'intérieur vide. Contradiction avec Baire.
> * **Q3 :** Qu'est-ce que la complétion de $\mathbb{Q}$ ?
>   * **Rép :** $\mathbb{R}$ (pour la distance usuelle). C'est le plus petit complet contenant $\mathbb{Q}$ densément.

### 5. Références Bibliographiques
* **J. Dixmier**, *Topologie générale* — Référence pour la topologie.
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
