# Variables Aléatoires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une [variable aléatoire](def:variable aleatoire) est une fonction mesurable $X : \Omega \to E$.
> * **Discrète :** Prend un nombre fini ou dénombrable de valeurs. Loi : $\mathbb{P}(X = x_i) = p_i$.
> * **Continue :** Loi définie par une densité $f$ : $\mathbb{P}(X \in A) = \int_A f(x)dx$.
> * **Fonction de répartition :** $F_X(x) = \mathbb{P}(X \leq x)$. Croissante, continue à droite, $F(-\infty) = 0$, $F(+\infty) = 1$.
> * **[Espérance](def:esperance) :** $\mathbb{E}[X] = \sum x_i p_i$ (discret) ou $\int x f(x) dx$ (continu).
> * **[Variance](def:variance) :** $\text{Var}(X) = \mathbb{E}[(X - \mathbb{E}[X])^2] = \mathbb{E}[X^2] - \mathbb{E}[X]^2$.
> * **Écart-type :** $\sigma(X) = \sqrt{\text{Var}(X)}$.
> * **Moments :** $\mathbb{E}[X^n]$ est le moment d'ordre $n$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Espérance non définie :** Peut ne pas exister (ex : loi de Cauchy).
> * **$\mathbb{E}[XY] \neq \mathbb{E}[X]\mathbb{E}[Y]$ :** Vrai seulement si $X, Y$ indépendantes.
> * **$\text{Var}(X + Y) \neq \text{Var}(X) + \text{Var}(Y)$ :** Vrai seulement si $X, Y$ non corrélées.
> * **Fonction de répartition :** Les sauts correspondent aux atomes (masses ponctuelles).
> * **Densité :** Non unique (on peut la modifier sur un ensemble de mesure nulle).

> [!TIP]
> ### 3. Exercice Type : Calcul d'espérance
> **Énoncé :** Soit $X \sim \text{Exp}(\lambda)$ de densité $f(x) = \lambda e^{-\lambda x} \mathbf{1}_{x \geq 0}$. Calculer $\mathbb{E}[X]$ et $\text{Var}(X)$.
>
> **Solution Détaillée :**
> 1. **Espérance :** $\mathbb{E}[X] = \int_0^{+\infty} x \lambda e^{-\lambda x} dx$.
>    IPP : $= [-xe^{-\lambda x}]_0^{+\infty} + \int_0^{+\infty} e^{-\lambda x} dx = 0 + \frac{1}{\lambda} = \frac{1}{\lambda}$.
> 2. **$\mathbb{E}[X^2]$ :** $\int_0^{+\infty} x^2 \lambda e^{-\lambda x} dx$. Double IPP $\Rightarrow \frac{2}{\lambda^2}$.
> 3. **Variance :** $\text{Var}(X) = \frac{2}{\lambda^2} - \frac{1}{\lambda^2} = \frac{1}{\lambda^2}$.
> 4. **Écart-type :** $\sigma(X) = \frac{1}{\lambda}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'une variable aléatoire ?
>   * **Rép :** Application mesurable de $(\Omega, \mathcal{A})$ vers $(E, \mathcal{E})$.
> * **Q2 :** Donner une variable aléatoire sans espérance.
>   * **Rép :** $X$ de loi de Cauchy : $f(x) = \frac{1}{\pi(1+x^2)}$. L'intégrale $\int |x| f(x) dx$ diverge.
> * **Q3 :** Qu'est-ce que la loi d'une variable aléatoire ?
>   * **Rép :** La mesure image $\mathbb{P}_X = \mathbb{P} \circ X^{-1}$ sur $(E, \mathcal{E})$.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Définitions rigoureuses et exemples variés.
* **J.-Y. Ouvrard**, *Probabilités 1* — Introduction progressive aux variables aléatoires.
