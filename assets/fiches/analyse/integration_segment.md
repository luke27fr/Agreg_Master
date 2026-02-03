# Intégration sur un Segment

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> L'intégrale de Riemann donne un sens à l'aire sous la courbe d'une fonction.
> * **Subdivision :** $\sigma = (a = x_0 < x_1 < \cdots < x_n = b)$ de $[a, b]$.
> * **Sommes de Darboux :** $s(\sigma, f) = \sum m_i (x_{i+1} - x_i)$ et $S(\sigma, f) = \sum M_i (x_{i+1} - x_i)$.
> * **Intégrable Riemann :** $\sup s(\sigma, f) = \inf S(\sigma, f)$.
> * **Fonctions continues :** Toute fonction continue sur $[a, b]$ est intégrable.
> * **Fonctions monotones :** Toute fonction monotone sur $[a, b]$ est intégrable.
> * **Linéarité :** $\int (af + bg) = a\int f + b\int g$.
> * **Relation de Chasles :** $\int_a^b f = \int_a^c f + \int_c^b f$.
> * **Théorème fondamental :** Si $f$ continue, $F(x) = \int_a^x f(t) dt$ est dérivable et $F' = f$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Continue par morceaux :** Intégrable, mais attention aux points de discontinuité.
> * **Intégrale et signe :** $\int_a^b f \geq 0$ si $f \geq 0$ et $a \leq b$.
> * **Bornes inversées :** $\int_b^a f = -\int_a^b f$ par convention.
> * **Fonction de Dirichlet :** $\mathbf{1}_\mathbb{Q}$ n'est pas Riemann-intégrable (mais Lebesgue-intégrable).
> * **Primitive ≠ intégrale :** $F' = f$ n'implique pas $F(x) = \int_a^x f$ si $f$ n'est pas continue.

> [!TIP]
> ### 3. Exercice Type : Intégration par parties
> **Énoncé :** Calculer $\int_0^1 x e^x dx$.
>
> **Solution Détaillée :**
> 1. **IPP :** $\int u dv = [uv] - \int v du$ avec $u = x$, $dv = e^x dx$.
> 2. $u = x$, $v = e^x$, $du = dx$, $dv = e^x dx$.
> 3. $\int_0^1 x e^x dx = [x e^x]_0^1 - \int_0^1 e^x dx = e - [e^x]_0^1 = e - (e - 1) = 1$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème fondamental de l'analyse.
>   * **Rép :** Si $f$ est continue sur $[a, b]$, alors $F(x) = \int_a^x f(t) dt$ est $C^1$ et $F' = f$.
> * **Q2 :** Formule du changement de variable ?
>   * **Rép :** $\int_a^b f(\varphi(t)) \varphi'(t) dt = \int_{\varphi(a)}^{\varphi(b)} f(u) du$ si $\varphi$ est $C^1$.
> * **Q3 :** Qu'est-ce que l'intégrale de Lebesgue ?
>   * **Rép :** Extension de Riemann qui intègre plus de fonctions (limites de fonctions simples).

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
