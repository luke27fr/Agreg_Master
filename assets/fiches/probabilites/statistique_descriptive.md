# Statistique Descriptive

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La **statistique descriptive** résume et visualise des données observées.
> * **Moyenne empirique :** $\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i$.
> * **Variance empirique :** $s^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2$.
> * **Variance corrigée :** $s'^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i - \bar{x})^2$ (estimateur sans biais).
> * **Médiane :** Valeur telle que 50% des données sont en-dessous.
> * **Quantiles :** $q_\alpha$ tel que $\mathbb{P}(X \leq q_\alpha) = \alpha$.
> * **Quartiles :** $Q_1 = q_{0.25}$, $Q_2 = q_{0.5}$ (médiane), $Q_3 = q_{0.75}$.
> * **Écart interquartile :** $IQR = Q_3 - Q_1$.
> * **Covariance empirique :** $s_{xy} = \frac{1}{n}\sum (x_i - \bar{x})(y_i - \bar{y})$.
> * **Coefficient de corrélation :** $r = \frac{s_{xy}}{s_x s_y} \in [-1, 1]$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Biais :** $\frac{1}{n}$ pour la variance donne un estimateur biaisé; utiliser $\frac{1}{n-1}$.
> * **Valeurs aberrantes :** La moyenne est sensible aux outliers, la médiane est robuste.
> * **Corrélation $\neq$ causalité :** Une forte corrélation n'implique pas une relation causale.
> * **Échantillon vs population :** Ne pas confondre paramètres ($\mu$, $\sigma$ ) et estimateurs ($\bar{x}$, $s$ ).

> [!TIP]
> ### 3. Exercice Type : Régression linéaire
> **Énoncé :** Trouver la droite des moindres carrés $y = ax + b$ pour les points $(x_i, y_i)$.
>
> **Solution Détaillée :**
> 1. **Critère :** Minimiser $S(a,b) = \sum_{i=1}^n (y_i - ax_i - b)^2$.
> 2. **Conditions :** $\frac{\partial S}{\partial a} = 0$ et $\frac{\partial S}{\partial b} = 0$.
> 3. **Équation en $b$ :** $\sum (y_i - ax_i - b) = 0 \Rightarrow b = \bar{y} - a\bar{x}$.
> 4. **Équation en $a$ :** $\sum x_i(y_i - ax_i - b) = 0$.
>    Après simplification : $a = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sum (x_i - \bar{x})^2} = \frac{s_{xy}}{s_x^2}$.
> 5. **Coefficient de détermination :** $R^2 = r^2$ mesure la qualité de l'ajustement.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi diviser par $n-1$ pour la variance ?
>   * **Rép :** Pour obtenir un estimateur sans biais de $\sigma^2$ (on perd 1 degré de liberté en estimant $\mu$ par $\bar{x}$ ).
> * **Q2 :** Quelle différence entre moyenne et médiane ?
>   * **Rép :** La médiane est robuste aux outliers, pas la moyenne.
> * **Q3 :** Comment interpréter $r = 0.8$ ?
>   * **Rép :** Forte corrélation linéaire positive. $R^2 = 0.64$ : 64% de la variance de $Y$ est expliquée par $X$.

### 5. Références Bibliographiques
* **D. Freedman**, *Statistics*.
* **G. Saporta**, *Probabilités, analyse des données et statistique*.
