# Convergences en Probabilités

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Plusieurs notions de convergence pour les suites de variables aléatoires.
> * **Presque sûre (p.s.) :** $\mathbb{P}(\lim X_n = X) = 1$.
> * **En probabilité :** $\forall \varepsilon > 0, \mathbb{P}(|X_n - X| > \varepsilon) \to 0$.
> * **En loi (notée $\mathcal{L}$) :** $F_{X_n}(x) \to F_X(x)$ en tout point de continuité de $F_X$.
> * **En moyenne d'ordre** $r$ **dans** $L^r$ **:** $\mathbb{E}[|X_n - X|^r] \to 0$.
> * **Implications :** p.s. $\Rightarrow$ proba $\Rightarrow$ loi. $L^r \Rightarrow$ proba.
> * **Lemme de Slutsky :** Si $X_n \xrightarrow{\mathcal{L}} X$ et $Y_n \xrightarrow{\mathbb{P}} c$ (constante), alors $X_n + Y_n \xrightarrow{\mathcal{L}} X + c$.
> * **Théorème de continuité :** $X_n \xrightarrow{\mathcal{L}} X$ ssi $\mathbb{E}[e^{itX_n}] \to \mathbb{E}[e^{itX}]$ pour tout $t$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Loi ≠ proba :** Convergence en loi n'implique pas convergence en probabilité.
> * **Proba ≠ p.s. :** Convergence en probabilité n'implique pas presque sûre en général.
> * **Extraction :** Convergence en probabilité implique existence d'une sous-suite qui converge p.s.
> * $L^r$ **:** Nécessite que les $X_n$ soient dans $L^r$ (moment d'ordre $r$ fini).
> * **Fonction continue :** Si $X_n \xrightarrow{\mathbb{P}} X$ et $g$ continue, alors $g(X_n) \xrightarrow{\mathbb{P}} g(X)$.

> [!TIP]
> ### 3. Exercice Type : Loi faible des grands nombres
> **Énoncé :** Montrer que $\bar{X}_n = \frac{1}{n}\sum_{i=1}^{n} X_i \xrightarrow{\mathbb{P}} \mu$ si $(X_i)$ i.i.d. de moyenne $\mu$.
>
> **Solution Détaillée :**
> 1. **Espérance :** $\mathbb{E}[\bar{X}_n] = \frac{1}{n}\sum \mathbb{E}[X_i] = \mu$.
> 2. **Variance :** $\text{Var}(\bar{X}_n) = \frac{1}{n^2}\sum \text{Var}(X_i) = \frac{\sigma^2}{n}$ (indépendance).
> 3. **Chebyshev :** $\mathbb{P}(|\bar{X}_n - \mu| > \varepsilon) \leq \frac{\text{Var}(\bar{X}_n)}{\varepsilon^2} = \frac{\sigma^2}{n\varepsilon^2} \to 0$.
> 4. **Conclusion :** $\bar{X}_n \xrightarrow{\mathbb{P}} \mu$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer la loi forte des grands nombres.
>   * **Rép :** Si $(X_n)$ i.i.d. avec $\mathbb{E}[|X_1|] < \infty$, alors $\bar{X}_n \xrightarrow{p.s.} \mathbb{E}[X_1]$.
> * **Q2 :** Donner un exemple où $X_n \to X$ en probabilité mais pas p.s.
>   * **Rép :** Machine à écrire : $X_n = \mathbf{1}_{[(k-1)/2^m, k/2^m[}$ où $n = 2^m + k - 1$. $X_n \to 0$ en proba mais pas p.s.
> * **Q3 :** Qu'est-ce que la fonction caractéristique ?
>   * **Rép :** $\varphi_X(t) = \mathbb{E}[e^{itX}]$. Caractérise la loi de $X$.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Présentation rigoureuse des modes de convergence.
* **J.-Y. Ouvrard**, *Probabilités 2* — Nombreux contre-exemples sur les implications.
