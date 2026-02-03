# Espérance et Variance

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Soit $X$ une [variable aléatoire](def:va) réelle.
> * **[Espérance](def:esperance) (cas discret) :** $\mathbb{E}[X] = \sum_{x} x \cdot \mathbb{P}(X = x)$ si la série converge absolument.
> * **Espérance (cas continu) :** $\mathbb{E}[X] = \int_{-\infty}^{+\infty} x f(x) dx$ si l'intégrale converge absolument.
> * **Linéarité :** $\mathbb{E}[aX + bY] = a\mathbb{E}[X] + b\mathbb{E}[Y]$ (toujours vraie).
> * **[Variance](def:variance) :** $\text{Var}(X) = \mathbb{E}[(X - \mathbb{E}[X])^2] = \mathbb{E}[X^2] - \mathbb{E}[X]^2$.
> * **Écart-type :** $\sigma(X) = \sqrt{\text{Var}(X)}$.
> * **Propriétés variance :** $\text{Var}(aX + b) = a^2 \text{Var}(X)$.
> * **[Covariance](def:covariance) :** $\text{Cov}(X, Y) = \mathbb{E}[XY] - \mathbb{E}[X]\mathbb{E}[Y]$.
> * **Variance de somme :** $\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y) + 2\text{Cov}(X,Y)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Existence :** L'espérance peut ne pas exister (ex : loi de Cauchy).
> * **Produit d'espérances :** $\mathbb{E}[XY] \neq \mathbb{E}[X]\mathbb{E}[Y]$ sauf si $X, Y$ indépendantes.
> * **Variance de somme :** $\text{Var}(X + Y) \neq \text{Var}(X) + \text{Var}(Y)$ sauf si non corrélées.
> * **Inégalité de Markov :** $\mathbb{P}(|X| \geq a) \leq \frac{\mathbb{E}[|X|]}{a}$ pour $a > 0$.
> * **Inégalité de Bienaymé-Tchebychev :** $\mathbb{P}(|X - \mathbb{E}[X]| \geq \varepsilon) \leq \frac{\text{Var}(X)}{\varepsilon^2}$.

> [!TIP]
> ### 3. Exercice Type : Espérance d'une géométrique
> **Énoncé :** Soit $X \sim \mathcal{G}(p)$ le rang du premier succès. Calculer $\mathbb{E}[X]$.
>
> **Solution Détaillée :**
> 1. **Loi :** $\mathbb{P}(X = k) = (1-p)^{k-1} p$ pour $k \geq 1$.
> 2. **Espérance :** $\mathbb{E}[X] = \sum_{k=1}^{\infty} k (1-p)^{k-1} p$.
> 3. **Astuce :** On pose $q = 1-p$ et on utilise $\sum_{k=1}^{\infty} k q^{k-1} = \frac{1}{(1-q)^2}$.
> 4. **Calcul :** $\mathbb{E}[X] = p \cdot \frac{1}{p^2} = \frac{1}{p}$.
> 5. **Interprétation :** En moyenne, il faut $1/p$ essais pour obtenir un succès.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner un exemple de v.a. sans espérance.
>   * **Rép :** Loi de Cauchy : $f(x) = \frac{1}{\pi(1+x^2)}$, $\int |x| f(x) dx = +\infty$.
> * **Q2 :** Montrer l'inégalité de Bienaymé-Tchebychev.
>   * **Rép :** Appliquer Markov à $(X - \mu)^2$ avec $a = \varepsilon^2$.
> * **Q3 :** Si $\text{Cov}(X,Y) = 0$, sont-elles indépendantes ?
>   * **Rép :** Non ! Contre-exemple : $X \sim U([-1,1])$, $Y = X^2$. Non corrélées mais dépendantes.

### 5. Références Bibliographiques
* **J. Jacod, P. Protter**, *Probability Essentials*.
* **W. Feller**, *An Introduction to Probability Theory*.
