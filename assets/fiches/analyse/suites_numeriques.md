# Suites Numériques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une suite $(u_n)$ est une application de $\mathbb{N}$ dans $\mathbb{R}$ (ou $\mathbb{C}$).
> * **Convergence :** $u_n \to \ell$ si $\forall \varepsilon > 0, \exists N, \forall n \geq N, |u_n - \ell| < \varepsilon$.
> * **Suite bornée :** $\exists M, \forall n, |u_n| \leq M$. Toute suite convergente est bornée.
> * **Suite monotone :** Croissante : $u_{n+1} \geq u_n$. Décroissante : $u_{n+1} \leq u_n$.
> * **Théorème de la limite monotone :** Suite monotone bornée $\Rightarrow$ convergente.
> * **Suites adjacentes :** $(u_n)$ croissante, $(v_n)$ décroissante, $v_n - u_n \to 0 \Rightarrow$ même limite.
> * **Bolzano-Weierstrass :** Toute suite bornée admet une sous-suite convergente.
> * **[Suite de Cauchy](def:suite de cauchy) :** $\forall \varepsilon > 0, \exists N, \forall m, n \geq N, |u_m - u_n| < \varepsilon$. Dans $\mathbb{R}$ : Cauchy $\Leftrightarrow$ convergente.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Bornée ≠ convergente :** $((-1)^n)$ est bornée mais ne converge pas.
> * **Unicité de la limite :** Une suite ne peut avoir qu'**une seule** limite.
> * **Limite de produit :** $u_n \to 0$ et $v_n \to +\infty$ : $u_n v_n$ peut avoir n'importe quel comportement.
> * **Sous-suite :** Si $(u_n)$ converge, toute sous-suite converge vers la **même** limite.
> * **Critère de Cauchy :** Utile quand on ne connaît pas la limite.

> [!TIP]
> ### 3. Exercice Type : Convergence par encadrement
> **Énoncé :** Montrer que $u_n = \sum_{k=1}^{n} \frac{1}{k^2}$ converge.
>
> **Solution Détaillée :**
> 1. **Monotonie :** $u_{n+1} = u_n + \frac{1}{(n+1)^2} > u_n$. Suite croissante.
> 2. **Majoration :** Pour $k \geq 2$, $\frac{1}{k^2} < \frac{1}{k(k-1)} = \frac{1}{k-1} - \frac{1}{k}$.
> 3. **Télescopage :** $u_n = 1 + \sum_{k=2}^{n} \frac{1}{k^2} < 1 + \sum_{k=2}^{n} \left(\frac{1}{k-1} - \frac{1}{k}\right) = 1 + 1 - \frac{1}{n} < 2$.
> 4. **Conclusion :** Suite croissante majorée par 2, donc convergente. (En fait, $\sum \frac{1}{k^2} = \frac{\pi^2}{6}$.)

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Bolzano-Weierstrass.
>   * **Rép :** Toute suite bornée de réels admet une sous-suite convergente.
> * **Q2 :** Qu'est-ce qu'une valeur d'adhérence ?
>   * **Rép :** Limite d'une sous-suite convergente. L'ensemble des valeurs d'adhérence est fermé.
> * **Q3 :** Donner un exemple de suite divergente dont une sous-suite converge.
>   * **Rép :** $((-1)^n)$ : $(u_{2n}) \to 1$ et $(u_{2n+1}) \to -1$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* (Suites).
* **W. Rudin**, *Principles of Mathematical Analysis*.
