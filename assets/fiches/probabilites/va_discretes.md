# Variables Aléatoires Discrètes

> [!NOTE]
> ### 1. Définitions et Moments
> Une [variable aléatoire](def:va) (V.A.) discrète est une application $X : \Omega \to E$ où $X(\Omega)$ est dénombrable.
> * **Loi de probabilité :** Caractérisée par la donnée des $p_x = P(X=x)$ pour tout $x \in X(\Omega)$. On a $\sum p_x = 1$.
> * **Espérance :** Si la série $\sum |x| P(X=x)$ converge, on définit l'[espérance](def:esperance) par :
> $$E[X] = \sum_{x \in X(\Omega)} x P(X=x)$$
> * **Formule de transfert :** Pour toute fonction $\varphi$, $E[\varphi(X)] = \sum \varphi(x) p_x$ (sous réserve de convergence absolue).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Existence de l'Espérance :** Ne jamais écrire $E[X]$ sans avoir prouvé la convergence absolue de la série (sauf si $X$ est bornée ou à support fini).
> * **Séries alternées :** La semi-convergence ne suffit pas pour définir l'espérance (car l'ordre de sommation dépendrait du résultat).
> * **Variance infinie :** Une V.A. peut avoir une espérance finie mais une variance infinie (exemple : Loi de Pareto).

> [!TIP]
> ### 3. Exercice : Loi Géométrique et "Sans Mémoire"
> **Énoncé :** Soit $X \sim \mathcal{G}(p)$ une loi géométrique (rang du premier succès). Montrer que $X$ est "sans mémoire". Caractériser les lois discrètes à valeurs dans $\mathbb{N}^*$ sans mémoire.
>
> #### Solution Détaillée :
> **1. Propriété "Sans mémoire" :**
> On calcule $P(X > n) = (1-p)^n$.
> On vérifie : $P(X > n+k \mid X > n) = \frac{P(X > n+k)}{P(X > n)} = \frac{q^{n+k}}{q^n} = q^k = P(X > k)$.
> Le fait d'avoir déjà attendu $n$ tours ne change pas la probabilité d'attendre encore $k$ tours.
>
> **2. Réciproque (Caractérisation) :**
> Soit $X$ à valeurs dans $\mathbb{N}^*$ telle que $P(X > n+k \mid X > n) = P(X > k)$.
> On pose $u_n = P(X > n)$. La relation devient $u_{n+k} = u_n u_k$.
> C'est une équation fonctionnelle classique sur $\mathbb{N}$. Comme $u_1 \in [0,1]$, on a $u_n = (u_1)^n$.
> On pose $q = u_1$. Alors $P(X=n) = u_{n-1} - u_n = q^{n-1} - q^n = q^{n-1}(1-q)$.
> On reconnaît une loi géométrique de paramètre $p = 1-q$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la différence entre convergence en probabilité et convergence presque sûre ?
>   * **Rép :** La convergence p.s. est plus forte. Elle implique la convergence en probabilité. (L'inverse est faux, sauf si on extrait une sous-suite).
> * **Q2 :** Citer une loi qui n'a pas d'espérance.
>   * **Rép :** La loi de Cauchy (densité en $1/(1+x^2)$ ) ou une loi discrète type $P(X=n) = \frac{c}{n^2}$ (la série harmonique diverge).
> * **Q3 :** Comment simuler une loi géométrique avec un générateur uniforme sur $[0,1]$ ?
>   * **Rép :** On utilise la méthode de l'inversion de la fonction de répartition : $X = \lceil \frac{\ln(U)}{\ln(1-p)} \rceil$.

### 5. Références Bibliographiques
* **J.-Y. Ouvrard**, *Probabilités 1* — Niveau adapté à l'agrégation, nombreux exercices.
* **P. Barbe, M. Ledoux**, *Probabilité* — Exercices corrigés et approfondissements.