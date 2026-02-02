# Lois Continues

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les lois continues sont définies par une densité $f$ : $\mathbb{P}(X \in A) = \int_A f(x) dx$.
> * **Uniforme $\mathcal{U}([a, b])$ :** $f(x) = \frac{1}{b-a}$ sur $[a, b]$. $\mathbb{E}[X] = \frac{a+b}{2}$, $\text{Var}(X) = \frac{(b-a)^2}{12}$.
> * **[Exponentielle](def:loi exponentielle) $\mathcal{E}(\lambda)$ :** $f(x) = \lambda e^{-\lambda x}$ pour $x \geq 0$. $\mathbb{E}[X] = 1/\lambda$, $\text{Var}(X) = 1/\lambda^2$.
> * **[Normale](def:loi normale) $\mathcal{N}(\mu, \sigma^2)$ :** $f(x) = \frac{1}{\sigma\sqrt{2\pi}}e^{-\frac{(x-\mu)^2}{2\sigma^2}}$. $\mathbb{E}[X] = \mu$, $\text{Var}(X) = \sigma^2$.
> * **Gamma $\Gamma(\alpha, \lambda)$ :** $f(x) = \frac{\lambda^\alpha}{\Gamma(\alpha)}x^{\alpha-1}e^{-\lambda x}$ pour $x > 0$.
> * **Beta $\text{Beta}(\alpha, \beta)$ :** $f(x) = \frac{x^{\alpha-1}(1-x)^{\beta-1}}{B(\alpha, \beta)}$ sur $[0, 1]$.
> * **Cauchy :** $f(x) = \frac{1}{\pi(1+x^2)}$. Pas d'espérance.

> [!WARNING]
> ### 2. Pièges à éviter
> * **$\mathbb{P}(X = x) = 0$ :** Pour une loi continue, la probabilité d'une valeur exacte est nulle.
> * **Exponentielle sans mémoire :** $\mathbb{P}(X > t + s | X > t) = \mathbb{P}(X > s)$.
> * **Normale :** $aX + b \sim \mathcal{N}(a\mu + b, a^2\sigma^2)$ (combinaison linéaire).
> * **Somme de normales indépendantes :** Reste normale.
> * **Cauchy :** Pas d'espérance, pas de variance, pas de convergence de la moyenne empirique.

> [!TIP]
> ### 3. Exercice Type : Loi normale standard
> **Énoncé :** Soit $Z \sim \mathcal{N}(0, 1)$. Calculer $\mathbb{P}(|Z| \leq 1.96)$.
>
> **Solution Détaillée :**
> 1. **Symétrie :** $\mathbb{P}(|Z| \leq 1.96) = \mathbb{P}(-1.96 \leq Z \leq 1.96) = 2\mathbb{P}(Z \leq 1.96) - 1$.
> 2. **Table :** $\Phi(1.96) \approx 0.975$.
> 3. **Calcul :** $\mathbb{P}(|Z| \leq 1.96) = 2 \times 0.975 - 1 = 0.95$.
> 4. **Interprétation :** 95% des valeurs d'une normale standard sont dans $[-1.96, 1.96]$.
>    C'est la base des intervalles de confiance à 95%.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi la loi normale est-elle si importante ?
>   * **Rép :** Théorème central limite : la somme de v.a. i.i.d. (de variance finie) converge en loi vers une normale.
> * **Q2 :** Quelle est la relation entre loi exponentielle et loi de Poisson ?
>   * **Rép :** Si les temps inter-arrivées sont $\mathcal{E}(\lambda)$, le nombre d'arrivées en temps $t$ est $\mathcal{P}(\lambda t)$.
> * **Q3 :** Quelle loi est conjuguée de la binomiale en inférence bayésienne ?
>   * **Rép :** La loi Beta. Si prior Beta et vraisemblance binomiale, le posterior est Beta.

### 5. Références Bibliographiques
* **W. Feller**, *An Introduction to Probability Theory*.
* **J. Jacod, P. Protter**, *Probability Essentials*.
