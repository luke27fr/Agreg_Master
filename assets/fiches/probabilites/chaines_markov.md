# Chaînes de Markov

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une [chaîne de Markov](def:chaine de markov) est un processus stochastique vérifiant la propriété de Markov.
> * **Propriété de Markov :** $\mathbb{P}(X_{n+1} | X_n, \ldots, X_0) = \mathbb{P}(X_{n+1} | X_n)$.
> * **Matrice de transition :** $P = (p_{ij})$ avec $p_{ij} = \mathbb{P}(X_{n+1} = j | X_n = i)$.
> * **Homogène :** $P$ ne dépend pas de $n$.
> * **Distribution initiale :** $\mu_0 = (\mathbb{P}(X_0 = i))_i$.
> * **Distribution à l'instant $n$ :** $\mu_n = \mu_0 P^n$.
> * **Irréductible :** Tous les états communiquent (on peut aller de $i$ à $j$ pour tous $i, j$).
> * **Apériodique :** Le pgcd des longueurs de chemins de $i$ à $i$ est 1.
> * **Mesure invariante :** $\pi P = \pi$ avec $\sum \pi_i = 1$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Stochastique :** Les lignes de $P$ somment à 1, pas les colonnes.
> * **Réversibilité :** $\pi_i p_{ij} = \pi_j p_{ji}$ n'est pas toujours vraie (équilibre détaillé).
> * **Existence de $\pi$ :** Pas toujours unique si la chaîne n'est pas irréductible.
> * **Convergence :** Irréductible + apériodique + récurrente positive $\Rightarrow$ convergence vers $\pi$.
> * **Temps de retour :** $\mathbb{E}[T_i | X_0 = i] = 1/\pi_i$ pour une chaîne récurrente positive.

> [!TIP]
> ### 3. Exercice Type : Mesure invariante
> **Énoncé :** Trouver la mesure invariante de $P = \begin{pmatrix} 0.5 & 0.5 \\ 0.3 & 0.7 \end{pmatrix}$.
>
> **Solution Détaillée :**
> 1. **Équation :** $\pi P = \pi$ avec $\pi_1 + \pi_2 = 1$.
>    $\begin{cases} 0.5\pi_1 + 0.3\pi_2 = \pi_1 \\ 0.5\pi_1 + 0.7\pi_2 = \pi_2 \end{cases}$
> 2. **Simplification :** $-0.5\pi_1 + 0.3\pi_2 = 0 \Rightarrow \pi_2 = \frac{5}{3}\pi_1$.
> 3. **Normalisation :** $\pi_1 + \frac{5}{3}\pi_1 = 1 \Rightarrow \frac{8}{3}\pi_1 = 1 \Rightarrow \pi_1 = \frac{3}{8}$.
> 4. **Résultat :** $\pi = (\frac{3}{8}, \frac{5}{8})$.
> 5. **Interprétation :** À long terme, 37.5% du temps dans l'état 1, 62.5% dans l'état 2.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'un état récurrent ? Transient ?
>   * **Rép :** Récurrent : on revient p.s. en partant de cet état. Transient : probabilité de non-retour $> 0$.
> * **Q2 :** Énoncer le théorème ergodique pour les chaînes de Markov.
>   * **Rép :** Pour une chaîne irréductible, apériodique, récurrente positive : $\frac{1}{n}\sum_{k=0}^{n-1} f(X_k) \to \sum_i \pi_i f(i)$ p.s.
> * **Q3 :** Qu'est-ce que l'algorithme de Metropolis-Hastings ?
>   * **Rép :** Méthode MCMC pour échantillonner selon $\pi$ en construisant une chaîne de Markov avec $\pi$ invariante.

### 5. Références Bibliographiques
* **J. Norris**, *Markov Chains*.
* **G. Grimmett, D. Stirzaker**, *Probability and Random Processes*.
