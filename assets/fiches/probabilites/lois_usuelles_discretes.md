# Lois Usuelles Discrètes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> * **[Bernoulli](def:loi de bernoulli) $\mathcal{B}(p)$ :** $\mathbb{P}(X=1)=p$, $\mathbb{P}(X=0)=1-p$. $\mathbb{E}[X]=p$, $\text{Var}(X)=p(1-p)$.
> * **[Binomiale](def:loi binomiale) $\mathcal{B}(n,p)$ :** $\mathbb{P}(X=k)=\binom{n}{k}p^k(1-p)^{n-k}$. $\mathbb{E}[X]=np$, $\text{Var}(X)=np(1-p)$.
> * **[Géométrique](def:loi geometrique) $\mathcal{G}(p)$ :** $\mathbb{P}(X=k)=(1-p)^{k-1}p$ pour $k \geq 1$. $\mathbb{E}[X]=1/p$, $\text{Var}(X)=(1-p)/p^2$.
> * **[Poisson](def:loi de poisson) $\mathcal{P}(\lambda)$ :** $\mathbb{P}(X=k)=e^{-\lambda}\frac{\lambda^k}{k!}$. $\mathbb{E}[X]=\text{Var}(X)=\lambda$.
> * **Uniforme $\mathcal{U}(\{1,...,n\})$ :** $\mathbb{P}(X=k)=1/n$. $\mathbb{E}[X]=(n+1)/2$, $\text{Var}(X)=(n^2-1)/12$.
> * **Hypergéométrique :** Tirage sans remise, $\mathbb{P}(X=k)=\frac{\binom{K}{k}\binom{N-K}{n-k}}{\binom{N}{n}}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Binomiale :** Somme de Bernoulli **indépendantes**.
> * **Géométrique :** Attention à la convention : rang du 1er succès (commence à 1) ou nombre d'échecs (commence à 0).
> * **Poisson :** Approximation de $\mathcal{B}(n,p)$ quand $n \to \infty$, $p \to 0$, $np \to \lambda$.
> * **Sans mémoire :** Seule la loi géométrique est sans mémoire parmi les discrètes.

> [!TIP]
> ### 3. Exercice Type : Somme de Poisson
> **Énoncé :** Si $X \sim \mathcal{P}(\lambda)$ et $Y \sim \mathcal{P}(\mu)$ indépendantes, quelle est la loi de $X + Y$ ?
>
> **Solution Détaillée :**
> 1. **Calcul direct :** $\mathbb{P}(X+Y=n) = \sum_{k=0}^n \mathbb{P}(X=k)\mathbb{P}(Y=n-k)$.
> 2. **Développement :** $= \sum_{k=0}^n e^{-\lambda}\frac{\lambda^k}{k!} \cdot e^{-\mu}\frac{\mu^{n-k}}{(n-k)!}$.
> 3. **Factorisation :** $= e^{-(\lambda+\mu)} \frac{1}{n!} \sum_{k=0}^n \binom{n}{k}\lambda^k \mu^{n-k}$.
> 4. **Binôme de Newton :** $= e^{-(\lambda+\mu)} \frac{(\lambda+\mu)^n}{n!}$.
> 5. **Conclusion :** $X + Y \sim \mathcal{P}(\lambda + \mu)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quel est le lien entre binomiale et Poisson ?
>   * **Rép :** $\mathcal{B}(n, \lambda/n) \to \mathcal{P}(\lambda)$ quand $n \to \infty$ (loi des événements rares).
> * **Q2 :** Montrer que la géométrique est sans mémoire.
>   * **Rép :** $\mathbb{P}(X > m+n | X > m) = \mathbb{P}(X > n)$ car $(1-p)^{m+n}/(1-p)^m = (1-p)^n$.
> * **Q3 :** Quelle est la fonction génératrice de la binomiale ?
>   * **Rép :** $G_X(s) = \mathbb{E}[s^X] = (1-p+ps)^n$.

### 5. Références Bibliographiques
* **C. Deschamps**, *Probabilités pour la Licence*.
* **J. Jacod, P. Protter**, *Probability Essentials*.
