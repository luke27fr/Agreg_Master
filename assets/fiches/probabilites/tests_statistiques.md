# Tests Statistiques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un test statistique permet de décider entre deux hypothèses à partir de données.
> * **Hypothèse nulle $H_0$ :** Hypothèse à tester (souvent "pas d'effet").
> * **Hypothèse alternative $H_1$ :** Hypothèse concurrente.
> * **Région critique $W$ :** Ensemble des valeurs de la statistique qui conduisent à rejeter $H_0$.
> * **Erreur de type I** risque $\alpha$ **:** Rejeter $H_0$ alors qu'elle est vraie. $\alpha = \mathbb{P}(W | H_0)$.
> * **Erreur de type II** risque $\beta$ **:** Accepter $H_0$ alors qu'elle est fausse. $\beta = \mathbb{P}(W^c | H_1)$.
> * **Puissance :** $1 - \beta$ = probabilité de rejeter $H_0$ quand $H_1$ est vraie.
> * **p-valeur :** Plus petite valeur de $\alpha$ pour laquelle on rejette $H_0$ avec les données observées.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Non rejet ≠ acceptation :** On ne "prouve" pas $H_0$, on échoue seulement à la rejeter.
> * **p-valeur ≠ proba de** $H_0$ **:** La p-valeur $= \mathbb{P}[\text{données aussi extrêmes} | H_0]$.
> * **Significatif ≠ important :** Un effet peut être statistiquement significatif mais pratiquement négligeable.
> * **Tests multiples :** Le risque d'erreur augmente (correction de Bonferroni, etc.).
> * **Unilatéral vs bilatéral :** Choisir avant de voir les données.

> [!TIP]
> ### 3. Exercice Type : Test de Student
> **Énoncé :** On mesure 25 valeurs de moyenne 102 et d'écart-type empirique 10. Tester si $\mu = 100$ au seuil 5%.
>
> **Solution Détaillée :**
> 1. **Hypothèses :** $H_0 : \mu = 100$ vs $H_1 : \mu \neq 100$ (bilatéral).
> 2. **Statistique de test :** $T = \frac{\bar{X} - \mu_0}{S/\sqrt{n}} = \frac{102 - 100}{10/\sqrt{25}} = \frac{2}{2} = 1$.
> 3. **Distribution sous $H_0$ :** $T \sim t_{24}$ (Student à 24 ddl).
> 4. **Valeur critique :** $t_{24, 0.975} \approx 2.064$ (table).
> 5. **Décision :** $|T| = 1 < 2.064$. On ne rejette pas $H_0$.
> 6. **Conclusion :** Pas de preuve que $\mu \neq 100$ au seuil 5%.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le lemme de Neyman-Pearson.
>   * **Rép :** Pour tester $H_0 : \theta = \theta_0$ vs $H_1 : \theta = \theta_1$, le test le plus puissant de niveau $\alpha$ rejette quand le rapport de vraisemblance dépasse un seuil.
> * **Q2 :** Qu'est-ce qu'un test du chi-deux ?
>   * **Rép :** Test d'adéquation ou d'indépendance. Statistique $\sum \frac{(O_i - E_i)^2}{E_i} \sim \chi^2$ sous $H_0$.
> * **Q3 :** Qu'est-ce que la correction de Bonferroni ?
>   * **Rép :** Pour $m$ tests, utiliser le seuil $\alpha/m$ pour chaque test individuel.

### 5. Références Bibliographiques
* **G. Saporta**, *Probabilités, analyse des données et statistique* — Chapitre complet sur les tests.
* **J.-J. Droesbeke**, *Éléments de statistique* — Approche pratique des tests d'hypothèses.
