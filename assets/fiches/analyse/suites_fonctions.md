# Suites de Fonctions

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> On étudie la convergence de suites $(f_n)$ de fonctions.
> * **Convergence simple :** $f_n(x) \to f(x)$ pour tout $x$ fixé.
> * **[Convergence uniforme](def:convergence uniforme) :** $\|f_n - f\|_\infty = \sup_x |f_n(x) - f(x)| \to 0$.
> * **Uniforme $\Rightarrow$ simple :** Mais la réciproque est fausse.
> * **Continuité :** Si $f_n$ continues et $f_n \to f$ uniformément, alors $f$ est continue.
> * **Interversion limite-intégrale :** Sous convergence uniforme sur un segment, $\int (\lim f_n) = \lim (\int f_n)$.
> * **Interversion limite-dérivée :** Si $f_n' \to g$ uniformément et $f_n(a) \to \ell$, alors $f_n \to f$ avec $f' = g$.
> * **Critère de Cauchy uniforme :** $\sup_x |f_n(x) - f_m(x)| \to 0$ quand $n, m \to \infty$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Simple ≠ uniforme :** $f_n(x) = x^n$ sur $[0, 1]$ converge simplement vers $\mathbf{1}_{\{1\}}$ mais pas uniformément.
> * **Limite discontinue :** La convergence simple ne préserve pas la continuité.
> * **Intégration :** On ne peut pas toujours intervertir $\lim$ et $\int$ sans uniformité.
> * **Dérivation :** Plus délicat : il faut l'uniformité de $(f_n')$ et la convergence ponctuelle de $(f_n)$.
> * **Uniforme sur un compact ≠ uniforme partout :** $f_n(x) = \frac{x}{n}$ converge uniformément sur tout $[a, b]$ mais pas sur $\mathbb{R}$.

> [!TIP]
> ### 3. Exercice Type : Non-uniformité
> **Énoncé :** Montrer que $f_n(x) = nx e^{-nx}$ converge simplement mais pas uniformément sur $[0, +\infty[$.
>
> **Solution Détaillée :**
> 1. **Convergence simple :** Pour $x = 0$ : $f_n(0) = 0 \to 0$.
>    Pour $x > 0$ : $f_n(x) = nx e^{-nx} \to 0$ (exponentielle l'emporte).
>    Donc $f_n \to 0$ simplement.
> 2. **Non-uniformité :** $f_n(\frac{1}{n}) = \frac{1}{n} \cdot n \cdot e^{-1} = \frac{1}{e}$.
>    Donc $\sup_x |f_n(x)| \geq \frac{1}{e} \not\to 0$.
> 3. **Conclusion :** La convergence n'est pas uniforme sur $[0, +\infty[$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Peut-on intervertir $\lim$ et $\int$ sans convergence uniforme ?
>   * **Rép :** Oui parfois, avec la convergence dominée (Lebesgue) ou monotone.
> * **Q2 :** Donner un exemple où $f_n$ continues, $f_n \to f$ simplement, mais $f$ discontinue.
>   * **Rép :** $f_n(x) = x^n$ sur $[0, 1]$. Limite = $0$ si $x < 1$, $1$ si $x = 1$.
> * **Q3 :** Qu'est-ce que la convergence localement uniforme ?
>   * **Rép :** Uniforme sur tout compact. Souvent suffisante pour préserver la continuité.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **C. Zuily, H. Queffélec**, *Analyse pour l'agrégation* — Cours et exercices.
