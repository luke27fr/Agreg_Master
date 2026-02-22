# Géométrie Projective

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La géométrie projective ajoute des points à l'infini pour uniformiser les résultats.
> * **Espace projectif :** $\mathbb{P}^n(\mathbb{K}) = (\mathbb{K}^{n+1} \setminus \{0\}) / \sim$ où $x \sim \lambda x$.
> * **Coordonnées homogènes :** $[x_0 : x_1 : \cdots : x_n]$ avec au moins un $x_i \neq 0$.
> * **Points à l'infini :** Ceux avec $x_0 = 0$ — dans le modèle où l'affine est $x_0 = 1$.
> * **Droite projective :** Sous-espace de dimension 1 de $\mathbb{P}^n$, i.e., plan vectoriel quotienté.
> * **Dualité :** Points $\leftrightarrow$ hyperplans. Incidence préservée.
> * **Birapport :** $(A, B; C, D) = \frac{\overrightarrow{CA}/\overrightarrow{CB}}{\overrightarrow{DA}/\overrightarrow{DB}}$. Invariant projectif.
> * **Homographie :** Application projective bijective, induite par un isomorphisme linéaire de $\mathbb{K}^{n+1}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Coordonnées :** $[1:2:3] = [2:4:6]$ sont le même point !
> * **Droites parallèles :** Se coupent à l'infini en géométrie projective.
> * **Birapport :** Dépend de l'ordre des 4 points. Permuter change la valeur.
> * **Homographie ≠ affinité :** Une homographie n'a pas de sens affine en général (envoie des points finis à l'infini).
> * **Théorème de Desargues :** Vrai en dimension $\geq 3$ ou sur un corps, peut être faux sur certains anneaux.

> [!TIP]
> ### 3. Exercice Type : Birapport
> **Énoncé :** Calculer le birapport $(A, B; C, D)$ avec $A = 0$, $B = 1$, $C = 2$, $D = \infty$ sur $\mathbb{P}^1$.
>
> **Solution Détaillée :**
> 1. **Formule :** $(A, B; C, D) = \frac{(C-A)(D-B)}{(C-B)(D-A)}$.
> 2. **Avec $D = \infty$ :** On passe à la limite, les termes en $D$ dominent.
>    $\lim_{D \to \infty} \frac{(C-A)D}{(C-B)D} = \frac{C-A}{C-B} = \frac{2-0}{2-1} = 2$.
> 3. **Vérification :** En coordonnées homogènes : $A = [1:0]$, $B = [1:1]$, $C = [1:2]$, $D = [0:1]$.
> 4. **Conclusion :** $(A, B; C, D) = 2$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Pappus.
>   * **Rép :** Si $A, B, C$ sont alignés et $A', B', C'$ alignés, alors $AB' \cap A'B$, $AC' \cap A'C$, $BC' \cap B'C$ sont alignés.
> * **Q2 :** Qu'est-ce qu'une conique projective ?
>   * **Rép :** Ensemble des points $[x:y:z]$ annulant une forme quadratique homogène de degré 2.
> * **Q3 :** Pourquoi le birapport est-il un invariant projectif ?
>   * **Rép :** Il est préservé par toute homographie (application projective bijective).

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne de la géométrie projective.
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects de la géométrie projective.
