# Espaces Probabilisés

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un [espace probabilisé](def:espace probabilise) $(\Omega, \mathcal{A}, \mathbb{P})$ modélise une expérience aléatoire.
> * **Univers $\Omega$ :** Ensemble de tous les résultats possibles.
> * **Tribu $\mathcal{A}$ :** Famille d'événements, stable par complémentaire et union dénombrable.
> * **Probabilité $\mathbb{P}$ :** Mesure sur $(\Omega, \mathcal{A})$ avec $\mathbb{P}(\Omega) = 1$.
> * **Axiomes de Kolmogorov :** $\mathbb{P}(\Omega) = 1$, $\mathbb{P}(A) \geq 0$, $\sigma$-additivité.
> * **Événement certain :** $\Omega$. **Événement impossible :** $\emptyset$.
> * **Événements incompatibles :** $A \cap B = \emptyset$.
> * **Système complet :** $(A_i)$ partition de $\Omega$ : $\mathbb{P}(B) = \sum \mathbb{P}(B \cap A_i)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Tribu ≠ ensemble des parties :** Sur $\mathbb{R}$, on utilise la tribu borélienne, pas $\mathcal{P}(\mathbb{R})$.
> * **Probabilité nulle ≠ impossible :** Un événement de probabilité 0 peut se produire (ex : choisir un réel particulier).
> * **Additivité :** $\mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B) - \mathbb{P}(A \cap B)$ (pas de double comptage).
> * **Continuité :** $A_n \nearrow A \Rightarrow \mathbb{P}(A_n) \to \mathbb{P}(A)$ (continuité monotone).
> * **Presque sûr :** Événement de probabilité 1 (mais pas forcément certain).

> [!TIP]
> ### 3. Exercice Type : Formule d'inclusion-exclusion
> **Énoncé :** Calculer $\mathbb{P}(A \cup B \cup C)$ en fonction des probabilités des parties.
>
> **Solution Détaillée :**
> 1. **Formule :**
>    $$\mathbb{P}(A \cup B \cup C) = \mathbb{P}(A) + \mathbb{P}(B) + \mathbb{P}(C) - \mathbb{P}(A \cap B) - \mathbb{P}(A \cap C) - \mathbb{P}(B \cap C) + \mathbb{P}(A \cap B \cap C)$$
> 2. **Cas général (n événements) :**
>    $$\mathbb{P}\left(\bigcup_{i=1}^{n} A_i\right) = \sum_{k=1}^{n} (-1)^{k+1} \sum_{|I|=k} \mathbb{P}\left(\bigcap_{i \in I} A_i\right)$$
> 3. **Application :** Problème des rencontres, probabilité qu'au moins une personne récupère son chapeau.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'une tribu ?
>   * **Rép :** Famille de parties contenant $\Omega$, stable par complémentaire et union dénombrable.
> * **Q2 :** Pourquoi a-t-on besoin d'une tribu et pas de $\mathcal{P}(\Omega)$ ?
>   * **Rép :** Sur des espaces non dénombrables, il n'existe pas de mesure $\sigma$-additive définie sur toutes les parties (Vitali).
> * **Q3 :** Énoncer le lemme de Borel-Cantelli.
>   * **Rép :** Si $\sum \mathbb{P}(A_n) < +\infty$, alors $\mathbb{P}(\limsup A_n) = 0$ (p.s. un nombre fini d'événements se réalisent).

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Fondements axiomatiques des probabilités.
* **J.-Y. Ouvrard**, *Probabilités 1* — Introduction aux espaces probabilisés.
