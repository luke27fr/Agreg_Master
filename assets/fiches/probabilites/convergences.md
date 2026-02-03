# Convergences de Variables Aléatoires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Soit $(X_n)$ une suite de v.a. et $X$ une v.a.
> * **Convergence presque sûre (p.s.) :** $\mathbb{P}(\lim_{n \to \infty} X_n = X) = 1$.
> * **Convergence en probabilité :** $\forall \varepsilon > 0$, $\mathbb{P}(|X_n - X| > \varepsilon) \to 0$.
> * **Convergence en moyenne d'ordre $p$ (dans $L^p$ ) :** $\mathbb{E}[|X_n - X|^p] \to 0$.
> * **Convergence en loi :** $F_{X_n}(x) \to F_X(x)$ aux points de continuité de $F_X$.
> * **Implications :**
>   - p.s. $\Rightarrow$ probabilité $\Rightarrow$ loi
>   - $L^p$ $\Rightarrow$ probabilité $\Rightarrow$ loi
>   - p.s. $\not\Leftrightarrow$ $L^p$ en général
> * **Convergence en loi vers constante :** $X_n \xrightarrow{\mathcal{L}} c \Leftrightarrow X_n \xrightarrow{\mathbb{P}} c$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Probabilité $\not\Rightarrow$ p.s. :** La réciproque est fausse !
> * **Loi $\not\Rightarrow$ probabilité :** Convergence en loi vers une v.a. non constante ne donne pas convergence en proba.
> * $L^1 \not\Rightarrow L^2$ **:** Pas d'implication entre convergences $L^p$ de degrés différents.
> * **Lemme de Fatou :** $\mathbb{E}[\liminf X_n] \leq \liminf \mathbb{E}[X_n]$ (inégalité !).

> [!TIP]
> ### 3. Exercice Type : Contre-exemple p.s. vs proba
> **Énoncé :** Construire $(X_n)$ convergeant en probabilité vers 0 mais pas p.s.
>
> **Solution Détaillée :**
> 1. **Construction :** Sur $[0,1]$ avec mesure de Lebesgue.
> 2. **Indicatrices glissantes :** $X_n = \mathbf{1}_{[k/2^m, (k+1)/2^m]}$ où $n = 2^m + k$.
> 3. **Convergence en proba :** $\mathbb{P}(X_n = 1) = 1/2^m \to 0$.
> 4. **Pas p.s. :** Pour tout $\omega \in [0,1]$, $X_n(\omega) = 1$ pour une infinité de $n$.
>    Donc $\limsup X_n(\omega) = 1 \neq 0$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de convergence dominée.
>   * **Rép :** Si $X_n \to X$ p.s. et $|X_n| \leq Y$ avec $\mathbb{E}[Y] < \infty$, alors $\mathbb{E}[X_n] \to \mathbb{E}[X]$.
> * **Q2 :** Quelle implication entre convergences est stricte ?
>   * **Rép :** Convergence en proba n'implique pas convergence p.s. (contre-exemple ci-dessus).
> * **Q3 :** Qu'est-ce que le lemme de Slutsky ?
>   * **Rép :** Si $X_n \xrightarrow{\mathcal{L}} X$ et $Y_n \xrightarrow{\mathbb{P}} c$, alors $(X_n, Y_n) \xrightarrow{\mathcal{L}} (X, c)$.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Chapitre détaillé sur les modes de convergence.
* **J.-Y. Ouvrard**, *Probabilités 2* — Contre-exemples et implications entre convergences.
