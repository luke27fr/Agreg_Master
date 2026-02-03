# Séries Numériques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une [série numérique](def:serie numerique) $\sum u_n$ est définie par ses sommes partielles $S_n = \sum_{k=0}^{n} u_k$.
> * **Convergence :** $\sum u_n$ converge si $(S_n)$ converge. On note $\sum_{n=0}^{+\infty} u_n$ la limite.
> * **Terme général :** Si $\sum u_n$ converge, alors $u_n \to 0$ (condition nécessaire).
> * **[Convergence absolue](def:convergence absolue) :** $\sum |u_n|$ converge $\Rightarrow$ $\sum u_n$ converge.
> * **Série géométrique :** $\sum q^n$ converge ssi $|q| < 1$, et vaut $\frac{1}{1-q}$.
> * **Critère de d'Alembert :** Si $|\frac{u_{n+1}}{u_n}| \to \ell$, converge si $\ell < 1$, diverge si $\ell > 1$.
> * **Comparaison :** $0 \leq u_n \leq v_n$ et $\sum v_n$ converge $\Rightarrow$ $\sum u_n$ converge.
> * **Séries alternées :** $\sum (-1)^n a_n$ avec $(a_n)$ positive, décroissante, $\to 0$ : converge.

> [!WARNING]
> ### 2. Pièges à éviter
> * **$u_n \to 0$ ne suffit pas :** $\sum \frac{1}{n}$ diverge (série harmonique).
> * **d'Alembert indécis :** $\ell = 1$ ne conclut pas (ni convergence ni divergence).
> * **Absolue ≠ simple :** $\sum \frac{(-1)^n}{n}$ converge mais pas absolument.
> * **Réarrangement :** Une série conditionnellement convergente peut être réarrangée vers n'importe quelle valeur (Riemann).
> * **Reste :** $R_n = \sum_{k=n+1}^{+\infty} u_k$ pour une série convergente.

> [!TIP]
> ### 3. Exercice Type : Série de Riemann
> **Énoncé :** Étudier la convergence de $\sum \frac{1}{n^\alpha}$ selon $\alpha$.
>
> **Solution Détaillée :**
> 1. **$\alpha \leq 0$ :** $\frac{1}{n^\alpha} \geq 1 \not\to 0$. Diverge.
> 2. **$0 < \alpha \leq 1$ :** Comparaison avec l'intégrale $\int_1^{+\infty} \frac{dx}{x^\alpha}$.
>    - Si $\alpha = 1$ : $\int \frac{dx}{x} = \ln(x) \to +\infty$. Diverge.
>    - Si $\alpha < 1$ : $\int \frac{dx}{x^\alpha} = \frac{x^{1-\alpha}}{1-\alpha} \to +\infty$. Diverge.
> 3. **$\alpha > 1$ :** $\int_1^{+\infty} \frac{dx}{x^\alpha} = \frac{1}{\alpha - 1} < +\infty$. Converge.
> 4. **Conclusion :** $\sum \frac{1}{n^\alpha}$ converge ssi $\alpha > 1$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Calculer $\sum_{n=1}^{+\infty} \frac{1}{n^2}$.
>   * **Rép :** $\frac{\pi^2}{6}$ (problème de Bâle, Euler).
> * **Q2 :** Énoncer le critère de Cauchy pour les séries.
>   * **Rép :** $\sum u_n$ converge ssi $\forall \varepsilon > 0, \exists N, \forall n \geq m \geq N, |\sum_{k=m}^{n} u_k| < \varepsilon$.
> * **Q3 :** Qu'est-ce que le produit de Cauchy de deux séries ?
>   * **Rép :** $(\sum a_n)(\sum b_n) = \sum c_n$ avec $c_n = \sum_{k=0}^{n} a_k b_{n-k}$ (valide si absolument convergentes).

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **C. Zuily, H. Queffélec**, *Analyse pour l'agrégation* — Cours et exercices.
