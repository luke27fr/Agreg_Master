# Séries de Fourier

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les séries de Fourier décomposent une fonction périodique en somme de sinus et cosinus.
> * **Coefficients :** Pour $f$ de période $2\pi$ : $a_n = \frac{1}{\pi}\int_{-\pi}^{\pi} f(t)\cos(nt)dt$, $b_n = \frac{1}{\pi}\int_{-\pi}^{\pi} f(t)\sin(nt)dt$.
> * **Forme exponentielle :** $c_n = \frac{1}{2\pi}\int_{-\pi}^{\pi} f(t)e^{-int}dt$. Série : $\sum c_n e^{int}$.
> * **Relation :** $c_0 = a_0/2$, $c_n = (a_n - ib_n)/2$, $c_{-n} = \bar{c_n}$ si $f$ réelle.
> * **Parseval :** $\frac{1}{2\pi}\int |f|^2 = \sum |c_n|^2$ pour $f \in L^2$.
> * **Convergence $L^2$ :** La série de Fourier converge vers $f$ dans $L^2$.
> * **Convergence ponctuelle :** Si $f$ est [$C^1$](def:c1) par morceaux, convergence vers $\frac{f(x^+) + f(x^-)}{2}$.
> * **Phénomène de Gibbs :** Oscillations près des discontinuités (dépassement d'environ 9%).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Convergence uniforme :** Pas toujours ! Faux si $f$ discontinue.
> * **Parité :** $f$ paire $\Rightarrow b_n = 0$ (série en cosinus). $f$ impaire $\Rightarrow a_n = 0$ (série en sinus).
> * **Période :** Attention au facteur d'échelle si la période n'est pas $2\pi$.
> * $f \in L^2$ **:** Nécessaire pour Parseval, mais pas suffisant pour la convergence ponctuelle.
> * **Continuité ≠ convergence uniforme :** Même une fonction continue peut avoir une série non uniformément convergente.

> [!TIP]
> ### 3. Exercice Type : Identité de Parseval
> **Énoncé :** Calculer $\sum_{n=1}^{+\infty} \frac{1}{n^2}$ via la série de Fourier de $f(x) = x$ sur $[-\pi, \pi]$.
>
> **Solution Détaillée :**
> 1. **Coefficients :** $f$ impaire donc $a_n = 0$.
>    $b_n = \frac{1}{\pi}\int_{-\pi}^{\pi} x \sin(nx) dx = \frac{2}{\pi}\int_0^{\pi} x \sin(nx) dx = \frac{2(-1)^{n+1}}{n}$.
> 2. **Parseval :** $\frac{1}{2\pi}\int_{-\pi}^{\pi} x^2 dx = \frac{a_0^2}{4} + \frac{1}{2}\sum (a_n^2 + b_n^2)$.
>    $\frac{1}{2\pi} \cdot \frac{2\pi^3}{3} = \frac{1}{2}\sum \frac{4}{n^2}$.
>    $\frac{\pi^2}{3} = 2\sum \frac{1}{n^2}$.
> 3. **Conclusion :** $\sum_{n=1}^{+\infty} \frac{1}{n^2} = \frac{\pi^2}{6}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Dirichlet pour les séries de Fourier.
>   * **Rép :** Si $f$ est $C^1$ par morceaux et de période $2\pi$, sa série de Fourier converge vers $\frac{f(x^+)+f(x^-)}{2}$ en tout point.
> * **Q2 :** Qu'est-ce que la convergence en moyenne quadratique ?
>   * **Rép :** $\|S_n - f\|_2 \to 0$. Vraie pour toute $f \in L^2$.
> * **Q3 :** Calculer $\sum_{n=1}^{+\infty} \frac{1}{n^4}$.
>   * **Rép :** $\frac{\pi^4}{90}$ (via Parseval avec $f(x) = x^2$).

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
