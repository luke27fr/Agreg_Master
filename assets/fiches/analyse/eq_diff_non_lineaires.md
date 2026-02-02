# Équations Différentielles Non Linéaires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une EDO non linéaire $y' = f(t, y)$ n'a pas de formule générale de résolution.
> * **Cauchy-Lipschitz :** Si $f$ est continue et localement lipschitzienne en $y$, existence et unicité locale.
> * **Solution maximale :** Solution définie sur le plus grand intervalle possible.
> * **Explosion en temps fini :** $y' = y^2$ avec $y(0) = 1$ : $y(t) = \frac{1}{1-t}$, explose en $t = 1$.
> * **Variables séparables :** $y' = g(t)h(y)$ : $\int \frac{dy}{h(y)} = \int g(t) dt$.
> * **Équation autonome :** $y' = f(y)$. Portrait de phase sur la droite réelle.
> * **Équation de Bernoulli :** $y' + p(t)y = q(t)y^n$. Changement $z = y^{1-n}$ ramène à linéaire.
> * **Équation de Riccati :** $y' = a(t)y^2 + b(t)y + c(t)$. Si on connaît une solution particulière, on peut résoudre.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Unicité :** $y' = \sqrt{|y|}$ avec $y(0) = 0$ a plusieurs solutions (pas lipschitzienne en 0).
> * **Solution maximale :** Peut ne pas être définie sur $\mathbb{R}$ tout entier.
> * **Division par zéro :** Dans les variables séparables, attention si $h(y) = 0$ (solutions constantes).
> * **Domaine :** La solution reste dans le domaine de définition de $f$.
> * **Comportement asymptotique :** Même si la solution existe pour tout $t > 0$, peut diverger.

> [!TIP]
> ### 3. Exercice Type : Variables séparables
> **Énoncé :** Résoudre $y' = y(1 - y)$ avec $y(0) = y_0 \in ]0, 1[$.
>
> **Solution Détaillée :**
> 1. **Séparation :** $\frac{dy}{y(1-y)} = dt$.
> 2. **Décomposition :** $\frac{1}{y(1-y)} = \frac{1}{y} + \frac{1}{1-y}$.
> 3. **Intégration :** $\ln|y| - \ln|1-y| = t + C \Rightarrow \ln\frac{y}{1-y} = t + C$.
> 4. **Solution :** $\frac{y}{1-y} = Ke^t \Rightarrow y = \frac{Ke^t}{1 + Ke^t} = \frac{1}{1 + K^{-1}e^{-t}}$.
> 5. **Condition initiale :** $y_0 = \frac{K}{1+K} \Rightarrow K = \frac{y_0}{1-y_0}$.
> 6. **Comportement :** $y(t) \to 1$ quand $t \to +\infty$ (équation logistique).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner un exemple d'équation sans unicité.
>   * **Rép :** $y' = 3y^{2/3}$ avec $y(0) = 0$. Solutions : $y = 0$ et $y = (t-c)^3$ pour $c \leq 0$.
> * **Q2 :** Qu'est-ce qu'un point d'équilibre stable ?
>   * **Rép :** Pour $y' = f(y)$, $y_0$ est équilibre si $f(y_0) = 0$. Stable si $f'(y_0) < 0$.
> * **Q3 :** Comment montrer qu'une solution est globale ?
>   * **Rép :** Montrer qu'elle reste bornée sur tout intervalle borné (évite l'explosion).

### 5. Références Bibliographiques
* **V. Arnold**, *Équations différentielles ordinaires*.
* **J. Hale**, *Ordinary Differential Equations*.
