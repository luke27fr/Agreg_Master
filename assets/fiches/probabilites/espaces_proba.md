# Espaces Probabilisés

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **[espace probabilisé](def:espace probabilise)** est un triplet $(\Omega, \mathcal{A}, \mathbb{P})$ où :
> * **[Univers](def:univers) $\Omega$ :** Ensemble de tous les résultats possibles.
> * **[Tribu](def:tribu) $\mathcal{A}$ :** Famille de parties de $\Omega$ stable par complémentaire et union dénombrable.
> * **[Probabilité](def:probabilite) $\mathbb{P}$ :** Mesure sur $\mathcal{A}$ avec $\mathbb{P}(\Omega) = 1$.
> * **Axiomes de Kolmogorov :**
>   - $\mathbb{P}(A) \geq 0$ pour tout $A \in \mathcal{A}$.
>   - $\mathbb{P}(\Omega) = 1$.
>   - $\sigma$-additivité : $\mathbb{P}(\bigcup_{n} A_n) = \sum_n \mathbb{P}(A_n)$ si $A_n$ disjoints.
> * **Tribu borélienne :** $\mathcal{B}(\mathbb{R})$ est la plus petite tribu contenant les ouverts.
> * **Événement négligeable :** $A$ tel que $\mathbb{P}(A) = 0$.
> * **Presque sûrement (p.s.) :** Propriété vraie sauf sur un ensemble négligeable.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Tribu $\neq$ ensemble des parties :** $\mathcal{A} \neq \mathcal{P}(\Omega)$ en général (pour $\Omega$ non dénombrable).
> * **Tribu :** Doit être stable par unions **dénombrables**, pas quelconques.
> * **Continuité :** $\mathbb{P}(\bigcup_n A_n) = \lim \mathbb{P}(A_n)$ si $A_n \uparrow$ (croissante).
> * **Événements indépendants :** $\mathbb{P}(A \cap B) = \mathbb{P}(A)\mathbb{P}(B)$, pas seulement pour deux !

> [!TIP]
> ### 3. Exercice Type : Probabilité d'une union
> **Énoncé :** Montrer $\mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B) - \mathbb{P}(A \cap B)$.
>
> **Solution Détaillée :**
> 1. **Partition :** $A \cup B = (A \setminus B) \sqcup (A \cap B) \sqcup (B \setminus A)$.
> 2. **Additivité :** $\mathbb{P}(A \cup B) = \mathbb{P}(A \setminus B) + \mathbb{P}(A \cap B) + \mathbb{P}(B \setminus A)$.
> 3. **Réécriture :** $A = (A \setminus B) \sqcup (A \cap B)$, donc $\mathbb{P}(A \setminus B) = \mathbb{P}(A) - \mathbb{P}(A \cap B)$.
> 4. **Idem pour B :** $\mathbb{P}(B \setminus A) = \mathbb{P}(B) - \mathbb{P}(A \cap B)$.
> 5. **Conclusion :** $\mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B) - \mathbb{P}(A \cap B)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi a-t-on besoin d'une tribu ?
>   * **Rép :** Pour garantir que les événements usuels (complémentaires, unions) sont mesurables.
> * **Q2 :** Qu'est-ce que la tribu engendrée par $X$ ?
>   * **Rép :** $\sigma(X) = \{X^{-1}(B) : B \in \mathcal{B}(\mathbb{R})\}$, la plus petite tribu rendant $X$ mesurable.
> * **Q3 :** Énoncer le lemme de Borel-Cantelli.
>   * **Rép :** Si $\sum \mathbb{P}(A_n) < \infty$, alors $\mathbb{P}(\limsup A_n) = 0$.

### 5. Références Bibliographiques
* **P. Billingsley**, *Probability and Measure*.
* **D. Williams**, *Probability with Martingales*.
