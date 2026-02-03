# Intervalles de Confiance

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un intervalle de confiance (IC) fournit une fourchette de valeurs plausibles pour un paramètre.
> * **Définition :** IC de niveau $1 - \alpha$ : $\mathbb{P}(\theta \in [L, U]) \geq 1 - \alpha$ pour tout $\theta$.
> * **Interprétation fréquentiste :** Sur $100$ échantillons, environ $100(1-\alpha)$ IC contiennent $\theta$.
> * **IC pour la moyenne (variance connue) :** $\bar{X} \pm z_{\alpha/2} \frac{\sigma}{\sqrt{n}}$.
> * **IC pour la moyenne (variance inconnue) :** $\bar{X} \pm t_{n-1, \alpha/2} \frac{S}{\sqrt{n}}$.
> * **IC pour une proportion :** $\hat{p} \pm z_{\alpha/2} \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}$ (approx. normale).
> * **IC pour la variance :** Basé sur la loi du chi-deux : $\frac{(n-1)S^2}{\chi^2_{n-1, \alpha/2}}$ à $\frac{(n-1)S^2}{\chi^2_{n-1, 1-\alpha/2}}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **$\theta$ n'est pas aléatoire :** L'IC est aléatoire (dépend des données), pas $\theta$.
> * **"Contient $\theta$ avec proba 95%" :** Faux pour un IC observé (il contient ou pas).
> * **Largeur :** Diminue en $1/\sqrt{n}$. Doubler la précision nécessite $4\times$ plus de données.
> * **Approximations :** L'IC normal pour une proportion est mauvais si $n\hat{p}$ petit.
> * **IC vs test :** Dualité : $\theta_0 \notin IC_{1-\alpha}$ ssi on rejette $H_0 : \theta = \theta_0$ au seuil $\alpha$.

> [!TIP]
> ### 3. Exercice Type : IC pour la moyenne
> **Énoncé :** Sur 36 mesures, $\bar{x} = 50$ et $s = 6$. Construire un IC à 95% pour $\mu$.
>
> **Solution Détaillée :**
> 1. **Paramètres :** $n = 36$, $\bar{x} = 50$, $s = 6$, $\alpha = 0.05$.
> 2. **Quantile :** $t_{35, 0.975} \approx 2.03$ (ou $z_{0.975} \approx 1.96$ si $n$ grand).
> 3. **Marge d'erreur :** $ME = t \cdot \frac{s}{\sqrt{n}} = 2.03 \cdot \frac{6}{6} = 2.03$.
> 4. **IC :** $[50 - 2.03, 50 + 2.03] = [47.97, 52.03]$.
> 5. **Interprétation :** On est confiant à 95% que $\mu \in [47.97, 52.03]$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment l'IC évolue-t-il avec le niveau de confiance ?
>   * **Rép :** Plus le niveau est élevé, plus l'IC est large (trade-off précision/confiance).
> * **Q2 :** Qu'est-ce que l'intervalle de Clopper-Pearson ?
>   * **Rép :** IC exact pour une proportion, basé sur la loi binomiale (pas d'approximation normale).
> * **Q3 :** Qu'est-ce que le bootstrap ?
>   * **Rép :** Méthode de rééchantillonnage pour estimer la distribution d'un estimateur et construire des IC.

### 5. Références Bibliographiques
* **G. Saporta**, *Probabilités, analyse des données et statistique* — Construction et interprétation des IC.
* **J.-J. Droesbeke**, *Éléments de statistique* — Nombreux exemples d'intervalles de confiance.
