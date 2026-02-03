# Théorèmes Limites

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les théorèmes limites décrivent le comportement asymptotique des sommes de variables aléatoires.
> * **Loi faible des grands nombres :** $\bar{X}_n \xrightarrow{\mathbb{P}} \mu$ pour $(X_i)$ i.i.d. de moyenne $\mu$.
> * **Loi forte des grands nombres :** $\bar{X}_n \xrightarrow{p.s.} \mu$ sous les mêmes hypothèses.
> * **Théorème central limite (TCL) :** $\frac{\sqrt{n}(\bar{X}_n - \mu)}{\sigma} \xrightarrow{\mathcal{L}} \mathcal{N}(0, 1)$.
> * **Version multidimensionnelle :** $\sqrt{n}(\bar{X}_n - \mu) \xrightarrow{\mathcal{L}} \mathcal{N}(0, \Sigma)$.
> * **Théorème de Berry-Esseen :** Vitesse de convergence dans le TCL : $O(1/\sqrt{n})$.
> * **Delta-method :** Si $\sqrt{n}(X_n - \mu) \xrightarrow{\mathcal{L}} \mathcal{N}(0, \sigma^2)$ et $g$ dérivable, $\sqrt{n}(g(X_n) - g(\mu)) \xrightarrow{\mathcal{L}} \mathcal{N}(0, g'(\mu)^2 \sigma^2)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Variance infinie :** Le TCL classique nécessite $\text{Var}(X_i) < \infty$.
> * **Indépendance :** Essentielle pour les versions classiques (extensions existent).
> * **Vitesse de convergence :** Le TCL ne dit rien sur la vitesse sans Berry-Esseen.
> * **Approximation :** Pour $n$ fini, l'approximation normale peut être mauvaise (surtout queues).
> * **Normalisation :** Attention au facteur $\sqrt{n}$ dans le TCL.

> [!TIP]
> ### 3. Exercice Type : Application du TCL
> **Énoncé :** On lance 10000 fois une pièce équilibrée. Approximer $\mathbb{P}(4900 \leq S_{10000} \leq 5100)$.
>
> **Solution Détaillée :**
> 1. **Paramètres :** $n = 10000$, $p = 1/2$. $\mu = np = 5000$, $\sigma = \sqrt{np(1-p)} = 50$.
> 2. **Normalisation :** $\frac{S_n - \mu}{\sigma} \approx Z \sim \mathcal{N}(0, 1)$.
> 3. **Calcul :** $\mathbb{P}(4900 \leq S \leq 5100) = \mathbb{P}\left(\frac{4900 - 5000}{50} \leq Z \leq \frac{5100 - 5000}{50}\right)$
>    $= \mathbb{P}(-2 \leq Z \leq 2) = 2\Phi(2) - 1 \approx 2 \times 0.9772 - 1 = 0.9544$.
> 4. **Conclusion :** Environ 95.4% de chances d'être entre 4900 et 5100 Pile.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème central limite.
>   * **Rép :** Si $(X_n)$ i.i.d. avec $\mathbb{E}[X_i] = \mu$, $\text{Var}(X_i) = \sigma^2 < \infty$, alors $\frac{S_n - n\mu}{\sigma\sqrt{n}} \xrightarrow{\mathcal{L}} \mathcal{N}(0, 1)$.
> * **Q2 :** Quand le TCL ne s'applique-t-il pas ?
>   * **Rép :** Variance infinie (ex : Cauchy), dépendance forte, non-identique distribution sans conditions.
> * **Q3 :** Qu'est-ce que le TCL de Lindeberg ?
>   * **Rép :** Version pour variables indépendantes non identiquement distribuées, sous condition de Lindeberg.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Démonstrations rigoureuses des théorèmes limites.
* **J.-Y. Ouvrard**, *Probabilités 2* — Applications du TCL et de la LGN.
