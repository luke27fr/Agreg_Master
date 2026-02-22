# Lois Discrètes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les lois discrètes sont des distributions de probabilité sur un ensemble au plus dénombrable.
> * **[Bernoulli](def:loi de bernoulli) $\mathcal{B}(p)$ :** $\mathbb{P}(X=1) = p$, $\mathbb{P}(X=0) = 1-p$. $\mathbb{E}[X] = p$, $\text{Var}(X) = p(1-p)$.
> * **[Binomiale](def:loi binomiale) $\mathcal{B}(n, p)$ :** $\mathbb{P}(X=k) = \binom{n}{k}p^k(1-p)^{n-k}$. $\mathbb{E}[X] = np$, $\text{Var}(X) = np(1-p)$.
> * **[Poisson](def:loi de poisson) $\mathcal{P}(\lambda)$ :** $\mathbb{P}(X=k) = \frac{\lambda^k e^{-\lambda}}{k!}$. $\mathbb{E}[X] = \text{Var}(X) = \lambda$.
> * **Géométrique $\mathcal{G}(p)$ :** Premier succès. $\mathbb{P}(X=k) = p(1-p)^{k-1}$. $\mathbb{E}[X] = 1/p$.
> * **Uniforme $\mathcal{U}(\{1,\ldots,n\})$ :** $\mathbb{P}(X=k) = 1/n$. $\mathbb{E}[X] = (n+1)/2$.
> * **Hypergéométrique :** Tirage sans remise. $\mathbb{P}(X=k) = \frac{\binom{K}{k}\binom{N-K}{n-k}}{\binom{N}{n}}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Binomiale :** $n$ épreuves **indépendantes** de même probabilité $p$.
> * **Poisson :** Approximation de $\mathcal{B}(n, p)$ quand $n$ grand, $p$ petit, $np \approx \lambda$.
> * **Géométrique :** Deux conventions : $X \geq 1$ (premier succès) ou $X \geq 0$ (nombre d'échecs avant succès).
> * **Sans mémoire :** Seule la loi géométrique est sans mémoire parmi les discrètes.
> * **Somme de Poisson :** $X \sim \mathcal{P}(\lambda)$, $Y \sim \mathcal{P}(\mu)$ indépendantes $\Rightarrow X + Y \sim \mathcal{P}(\lambda + \mu)$.

> [!TIP]
> ### 3. Exercice Type : Approximation de Poisson
> **Énoncé :** On lance 1000 fois un dé équilibré. Approximer la probabilité d'obtenir exactement 10 fois le 6.
>
> **Solution Détaillée :**
> 1. **Loi exacte :** $X \sim \mathcal{B}(1000, 1/6)$ : $\mathbb{P}(X = 10) = \binom{1000}{10}(1/6)^{10}(5/6)^{990}$.
> 2. **Approximation :** $n = 1000$ grand, $p = 1/6$ pas très petit, $\lambda = np = 1000/6 \approx 166.7$.
>    Mais pour Poisson il faudrait $\lambda$ modéré. Ici, approximation normale serait meilleure.
> 3. **Exemple avec $p$ petit :** Si $p = 0.01$, $n = 1000$, $\lambda = 10$ :
>    $\mathbb{P}(X = 10) \approx \frac{10^{10} e^{-10}}{10!} \approx 0.125$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer l'approximation de Poisson de la binomiale.
>   * **Rép :** Si $n \to +\infty$, $p \to 0$, $np \to \lambda$, alors $\mathcal{B}(n, p) \to \mathcal{P}(\lambda)$.
> * **Q2 :** Quelle est la propriété de la loi géométrique ?
>   * **Rép :** Sans mémoire : $\mathbb{P}(X > m + n | X > m) = \mathbb{P}(X > n)$.
> * **Q3 :** Si $X \sim \mathcal{B}(n, p)$ et $Y \sim \mathcal{B}(m, p)$ indépendantes, quelle est la loi de $X + Y$ ?
>   * **Rép :** $X + Y \sim \mathcal{B}(n + m, p)$.

### 5. Références Bibliographiques
* **C. Deschamps**, *Probabilités* — Introduction claire aux lois discrètes classiques.
* **J.-Y. Ouvrard**, *Probabilités 1* — Exercices corrigés sur les lois discrètes.
