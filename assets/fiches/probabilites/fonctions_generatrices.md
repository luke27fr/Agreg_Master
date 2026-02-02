# Fonctions Génératrices

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les fonctions génératrices caractérisent les lois de variables aléatoires.
> * **Fonction génératrice :** $G_X(s) = \mathbb{E}[s^X] = \sum_{k=0}^{\infty} \mathbb{P}(X = k) s^k$ pour $X$ à valeurs dans $\mathbb{N}$.
> * **Caractérisation :** $G_X$ caractérise la loi de $X$ sur $\mathbb{N}$.
> * **Moments :** $G_X'(1) = \mathbb{E}[X]$, $G_X''(1) + G_X'(1) - G_X'(1)^2 = \text{Var}(X)$.
> * **Somme indépendante :** $G_{X+Y}(s) = G_X(s) G_Y(s)$.
> * **Fonction caractéristique :** $\varphi_X(t) = \mathbb{E}[e^{itX}]$ (définie pour toute v.a.).
> * **Transformée de Laplace :** $\mathcal{L}_X(s) = \mathbb{E}[e^{-sX}]$ pour $X \geq 0$.
> * **Fonction génératrice des moments :** $M_X(t) = \mathbb{E}[e^{tX}]$ si elle existe.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Rayon de convergence :** $G_X(s)$ converge au moins pour $|s| \leq 1$.
> * **Pas toujours définie :** La MGF $M_X(t)$ peut ne pas exister (ex : Cauchy).
> * **Unicité :** La fonction caractéristique existe toujours et caractérise la loi.
> * **Inversion :** Récupérer la loi à partir de $\varphi_X$ peut être difficile en pratique.
> * **Dérivées en 1 :** Pour $G_X$, les dérivées en $s = 1$ donnent les moments factoriels.

> [!TIP]
> ### 3. Exercice Type : Somme de Poisson
> **Énoncé :** Montrer que si $X \sim \mathcal{P}(\lambda)$, $Y \sim \mathcal{P}(\mu)$ indépendantes, alors $X + Y \sim \mathcal{P}(\lambda + \mu)$.
>
> **Solution Détaillée :**
> 1. **FG de Poisson :** $G_X(s) = \sum_{k=0}^{\infty} \frac{(\lambda s)^k e^{-\lambda}}{k!} = e^{-\lambda} e^{\lambda s} = e^{\lambda(s-1)}$.
> 2. **Idem pour $Y$ :** $G_Y(s) = e^{\mu(s-1)}$.
> 3. **Produit :** $G_{X+Y}(s) = G_X(s) G_Y(s) = e^{\lambda(s-1)} e^{\mu(s-1)} = e^{(\lambda+\mu)(s-1)}$.
> 4. **Reconnaissance :** C'est la FG de $\mathcal{P}(\lambda + \mu)$.
> 5. **Conclusion :** $X + Y \sim \mathcal{P}(\lambda + \mu)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi la fonction caractéristique est-elle préférée ?
>   * **Rép :** Elle existe toujours ($|e^{itX}| = 1$), caractérise la loi, et est utile pour le TCL.
> * **Q2 :** Quelle est la fonction caractéristique de $\mathcal{N}(0, 1)$ ?
>   * **Rép :** $\varphi(t) = e^{-t^2/2}$.
> * **Q3 :** Comment utiliser les fonctions génératrices pour les processus de branchement ?
>   * **Rép :** Si $Z_{n+1} = \sum_{i=1}^{Z_n} X_i$, alors $G_{Z_{n+1}}(s) = G_{Z_n}(G_X(s))$.

### 5. Références Bibliographiques
* **W. Feller**, *An Introduction to Probability Theory*.
* **G. Grimmett, D. Stirzaker**, *Probability and Random Processes*.
