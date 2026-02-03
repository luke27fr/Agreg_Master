# Lois Usuelles à Densité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> * **Uniforme $\mathcal{U}([a,b])$ :** $f(x)=\frac{1}{b-a}\mathbf{1}_{[a,b]}$. $\mathbb{E}[X]=\frac{a+b}{2}$, $\text{Var}(X)=\frac{(b-a)^2}{12}$.
> * **[Exponentielle](def:loi exponentielle) $\mathcal{E}(\lambda)$ :** $f(x)=\lambda e^{-\lambda x}\mathbf{1}_{x \geq 0}$. $\mathbb{E}[X]=1/\lambda$, $\text{Var}(X)=1/\lambda^2$.
> * **[Normale](def:loi normale) $\mathcal{N}(\mu, \sigma^2)$ :** $f(x)=\frac{1}{\sigma\sqrt{2\pi}}e^{-\frac{(x-\mu)^2}{2\sigma^2}}$. $\mathbb{E}[X]=\mu$, $\text{Var}(X)=\sigma^2$.
> * **Gamma $\Gamma(\alpha, \lambda)$ :** $f(x)=\frac{\lambda^\alpha}{\Gamma(\alpha)}x^{\alpha-1}e^{-\lambda x}\mathbf{1}_{x > 0}$. $\mathbb{E}[X]=\alpha/\lambda$.
> * **Chi-deux $\chi^2(n)$ :** $\Gamma(n/2, 1/2)$. Loi de $\sum_{i=1}^n Z_i^2$ où $Z_i \sim \mathcal{N}(0,1)$ i.i.d.
> * **Student $t(n)$ :** $Z/\sqrt{V/n}$ où $Z \sim \mathcal{N}(0,1)$, $V \sim \chi^2(n)$ indépendants.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Exponentielle :** Seule loi continue sans mémoire.
> * **Normale :** $\mathcal{N}(0,1)$ est la loi normale **centrée réduite**.
> * **Paramétrisation :** Attention à $\mathcal{N}(\mu, \sigma^2)$ vs $\mathcal{N}(\mu, \sigma)$ selon les auteurs.
> * **Somme de normales :** Indépendantes $\Rightarrow$ normale. La réciproque est fausse sans indépendance !

> [!TIP]
> ### 3. Exercice Type : Loi du maximum
> **Énoncé :** Soient $X_1, ..., X_n$ i.i.d. de loi $\mathcal{E}(1)$. Trouver la loi de $M_n = \max(X_1, ..., X_n)$.
>
> **Solution Détaillée :**
> 1. **Fonction de répartition :** $F_{M_n}(x) = \mathbb{P}(M_n \leq x) = \mathbb{P}(X_1 \leq x, ..., X_n \leq x)$.
> 2. **Indépendance :** $= \prod_{i=1}^n \mathbb{P}(X_i \leq x) = (1 - e^{-x})^n$ pour $x \geq 0$.
> 3. **Densité :** $f_{M_n}(x) = n(1-e^{-x})^{n-1} e^{-x} \mathbf{1}_{x \geq 0}$.
> 4. **Espérance :** $\mathbb{E}[M_n] = \sum_{k=1}^n \frac{1}{k} = H_n$ (nombre harmonique).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Montrer que l'exponentielle est sans mémoire.
>   * **Rép :** $\mathbb{P}(X > s+t | X > s) = e^{-\lambda t} = \mathbb{P}(X > t)$ par calcul direct.
> * **Q2 :** Quelle est la loi de $aX + b$ si $X \sim \mathcal{N}(\mu, \sigma^2)$ ?
>   * **Rép :** $\mathcal{N}(a\mu + b, a^2\sigma^2)$.
> * **Q3 :** Pourquoi la loi normale est-elle si importante ?
>   * **Rép :** Théorème central limite : somme de v.a. i.i.d. tend vers une normale.

### 5. Références Bibliographiques
* **W. Feller**, *An Introduction to Probability Theory* (Vol. 2).
* **G. Grimmett, D. Stirzaker**, *Probability and Random Processes*.
