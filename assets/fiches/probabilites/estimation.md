# Estimation

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> L'estimation consiste à inférer les paramètres d'une loi à partir d'observations.
> * **Statistique :** Fonction mesurable de l'échantillon $(X_1, \ldots, X_n)$.
> * **Estimateur :** Statistique servant à estimer un paramètre $\theta$.
> * **Biais :** $b(\hat{\theta}) = \mathbb{E}[\hat{\theta}] - \theta$. Sans biais si $b = 0$.
> * **Variance :** $\text{Var}(\hat{\theta})$. Erreur quadratique moyenne : $\text{MSE} = \text{Var} + b^2$.
> * **Convergent :** $\hat{\theta}_n \xrightarrow{\mathbb{P}} \theta$.
> * **Maximum de vraisemblance (MV) :** $\hat{\theta}_{MV} = \arg\max_\theta L(\theta; x_1, \ldots, x_n)$.
> * **Moments :** Égaliser moments empiriques et théoriques.
> * **Borne de Cramér-Rao :** $\text{Var}(\hat{\theta}) \geq \frac{1}{nI(\theta)}$ où $I(\theta)$ est l'information de Fisher.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Sans biais ≠ meilleur :** Un estimateur biaisé peut avoir un MSE plus petit.
> * **MV pas toujours sans biais :** Ex : $\hat{\sigma}^2 = \frac{1}{n}\sum(X_i - \bar{X})^2$ est biaisé (corriger par $n-1$).
> * **Efficace :** Atteint la borne de Cramér-Rao. N'existe pas toujours.
> * **Existence du MV :** Peut ne pas exister ou ne pas être unique.
> * **Asymptotique :** Les propriétés du MV sont souvent asymptotiques.

> [!TIP]
> ### 3. Exercice Type : EMV pour la loi exponentielle
> **Énoncé :** Soit $(X_1, \ldots, X_n)$ i.i.d. $\mathcal{E}(\lambda)$. Trouver l'EMV de $\lambda$.
>
> **Solution Détaillée :**
> 1. **Vraisemblance :** $L(\lambda) = \prod_{i=1}^{n} \lambda e^{-\lambda x_i} = \lambda^n e^{-\lambda \sum x_i}$.
> 2. **Log-vraisemblance :** $\ell(\lambda) = n\ln\lambda - \lambda \sum x_i$.
> 3. **Dérivée :** $\frac{d\ell}{d\lambda} = \frac{n}{\lambda} - \sum x_i = 0$.
> 4. **Solution :** $\hat{\lambda} = \frac{n}{\sum x_i} = \frac{1}{\bar{X}}$.
> 5. **Vérification :** $\frac{d^2\ell}{d\lambda^2} = -\frac{n}{\lambda^2} < 0$ : c'est un maximum.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce que l'information de Fisher ?
>   * **Rép :** $I(\theta) = \mathbb{E}\left[\left(\frac{\partial \ln f(X;\theta)}{\partial \theta}\right)^2\right] = -\mathbb{E}\left[\frac{\partial^2 \ln f}{\partial \theta^2}\right]$.
> * **Q2 :** Quelles sont les propriétés asymptotiques du MV ?
>   * **Rép :** Sous conditions : consistant, asymptotiquement normal, asymptotiquement efficace.
> * **Q3 :** Qu'est-ce qu'une statistique exhaustive ?
>   * **Rép :** Statistique $T$ telle que $\mathbb{P}(X|T)$ ne dépend pas de $\theta$. Contient toute l'info sur $\theta$.

### 5. Références Bibliographiques
* **G. Saporta**, *Probabilités, analyse des données et statistique* — Théorie de l'estimation avec applications.
* **J.-J. Droesbeke**, *Éléments de statistique* — Méthodes d'estimation et propriétés des estimateurs.
