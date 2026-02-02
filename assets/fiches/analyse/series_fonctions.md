# Séries de Fonctions

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une série de fonctions $\sum f_n$ est définie par ses sommes partielles $S_n = \sum_{k=0}^{n} f_k$.
> * **Convergence simple :** $\sum f_n(x)$ converge pour tout $x$.
> * **[Convergence uniforme](def:convergence uniforme) :** $S_n \to S$ uniformément.
> * **[Convergence normale](def:convergence normale) :** $\sum \|f_n\|_\infty < +\infty$. Implique la convergence uniforme et absolue.
> * **Continuité :** Si $f_n$ continues et $\sum f_n$ converge uniformément, alors la somme est continue.
> * **Intégration terme à terme :** Sous convergence uniforme : $\int \sum f_n = \sum \int f_n$.
> * **Dérivation terme à terme :** Si $\sum f_n'$ converge uniformément et $\sum f_n(a)$ converge, alors $(\sum f_n)' = \sum f_n'$.
> * **Weierstrass :** Si $|f_n(x)| \leq M_n$ et $\sum M_n < +\infty$, alors convergence normale.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Normale $\Rightarrow$ uniforme :** Mais pas l'inverse ! $\sum \frac{(-1)^n}{n} x^n$ converge uniformément sur $[-1, 0]$ mais pas normalement.
> * **Dérivation :** Il faut l'uniformité de $\sum f_n'$, pas seulement de $\sum f_n$.
> * **Domaine :** La convergence peut être uniforme sur un compact mais pas sur tout le domaine.
> * **Absolue vs normale :** Absolue = $\sum |f_n(x)|$ converge pour tout $x$. Normale = $\sum \sup |f_n|$ converge.
> * **Série entière :** Cas particulier important avec $f_n(x) = a_n x^n$.

> [!TIP]
> ### 3. Exercice Type : Convergence normale
> **Énoncé :** Montrer que $\sum \frac{\sin(nx)}{n^2}$ converge normalement sur $\mathbb{R}$.
>
> **Solution Détaillée :**
> 1. **Majoration :** $|\frac{\sin(nx)}{n^2}| \leq \frac{1}{n^2}$ pour tout $x \in \mathbb{R}$.
> 2. **Série majorante :** $\sum \frac{1}{n^2}$ converge (Riemann, $\alpha = 2 > 1$).
> 3. **Weierstrass :** Donc $\sum \frac{\sin(nx)}{n^2}$ converge normalement sur $\mathbb{R}$.
> 4. **Conséquence :** La somme est continue sur $\mathbb{R}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Weierstrass pour les séries de fonctions.
>   * **Rép :** Si $|f_n(x)| \leq M_n$ avec $\sum M_n$ convergente, alors $\sum f_n$ converge normalement.
> * **Q2 :** Peut-on dériver terme à terme une [série entière](def:serie entiere) ?
>   * **Rép :** Oui, dans le disque ouvert de convergence. La série dérivée a le même [rayon de convergence](def:rayon de convergence).
> * **Q3 :** Donner un exemple de série uniformément convergente mais pas normalement.
>   * **Rép :** $\sum_{n \geq 1} \frac{(-1)^n}{n}$ (série constante, convergente par Leibniz, mais $\sum \frac{1}{n}$ diverge).

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* (Séries de fonctions).
* **W. Rudin**, *Principles of Mathematical Analysis*.
