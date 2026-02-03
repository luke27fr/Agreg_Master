# Probabilités Conditionnelles

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La [probabilité conditionnelle](def:probabilite conditionnelle) mesure la probabilité d'un événement sachant qu'un autre s'est réalisé.
> * **Définition :** $\mathbb{P}(A|B) = \frac{\mathbb{P}(A \cap B)}{\mathbb{P}(B)}$ si $\mathbb{P}(B) > 0$.
> * **Formule des probabilités composées :** $\mathbb{P}(A \cap B) = \mathbb{P}(A|B) \mathbb{P}(B)$.
> * **Formule des probabilités totales :** Si $(B_i)$ partition, $\mathbb{P}(A) = \sum \mathbb{P}(A|B_i)\mathbb{P}(B_i)$.
> * **Formule de Bayes :** $\mathbb{P}(B_j|A) = \frac{\mathbb{P}(A|B_j)\mathbb{P}(B_j)}{\sum_i \mathbb{P}(A|B_i)\mathbb{P}(B_i)}$.
> * **Événements [indépendants](def:independance) :** $\mathbb{P}(A \cap B) = \mathbb{P}(A)\mathbb{P}(B)$.
> * **Indépendance mutuelle :** Pour tout sous-ensemble fini $I$, $\mathbb{P}(\cap_{i \in I} A_i) = \prod_{i \in I} \mathbb{P}(A_i)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Conditionner par $\mathbb{P}(B) = 0$ :** Non défini directement (mais généralisations existent).
> * **Deux à deux ≠ mutuellement :** L'indépendance deux à deux n'implique pas l'indépendance mutuelle.
> * **$\mathbb{P}(A|B) \neq \mathbb{P}(B|A)$ :** Confusion fréquente (erreur du procureur).
> * **Bayes :** Inverse le sens du conditionnement. Utile pour les causes sachant les effets.
> * **Indépendance et exclusivité :** Si $A \cap B = \emptyset$ avec $\mathbb{P}(A), \mathbb{P}(B) > 0$, alors $A$ et $B$ ne sont **pas** indépendants.

> [!TIP]
> ### 3. Exercice Type : Bayes et diagnostic
> **Énoncé :** Un test détecte une maladie (prévalence 1%) avec sensibilité 95% et spécificité 90%. Si le test est positif, quelle est la probabilité d'être malade ?
>
> **Solution Détaillée :**
> 1. **Données :** $\mathbb{P}(M) = 0.01$, $\mathbb{P}(+|M) = 0.95$, $\mathbb{P}(-|\bar{M}) = 0.90$ donc $\mathbb{P}(+|\bar{M}) = 0.10$.
> 2. **Probabilité totale :** $\mathbb{P}(+) = \mathbb{P}(+|M)\mathbb{P}(M) + \mathbb{P}(+|\bar{M})\mathbb{P}(\bar{M})$
>    $= 0.95 \times 0.01 + 0.10 \times 0.99 = 0.0095 + 0.099 = 0.1085$.
> 3. **Bayes :** $\mathbb{P}(M|+) = \frac{\mathbb{P}(+|M)\mathbb{P}(M)}{\mathbb{P}(+)} = \frac{0.0095}{0.1085} \approx 8.8\%$.
> 4. **Conclusion :** Même avec un test positif, seulement ~9% de chance d'être malade !

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer la formule de Bayes.
>   * **Rép :** $\mathbb{P}(B|A) = \frac{\mathbb{P}(A|B)\mathbb{P}(B)}{\mathbb{P}(A)}$.
> * **Q2 :** Donner un exemple d'événements deux à deux indépendants mais pas mutuellement.
>   * **Rép :** Deux lancers de pièce équilibrée. $A$ = "1er Pile", $B$ = "2ème Pile", $C$ = "parité égale". Deux à deux indépendants, mais pas mutuellement.
> * **Q3 :** Qu'est-ce que le paradoxe de Simpson ?
>   * **Rép :** Une tendance présente dans plusieurs groupes peut s'inverser quand on combine les groupes.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Chapitre complet sur le conditionnement.
* **C. Deschamps**, *Probabilités* — Nombreux exercices sur Bayes et probabilités totales.
