# Similitudes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une similitude est une transformation qui conserve les angles et multiplie les distances par un facteur constant.
> * **Définition :** $f$ similitude de rapport $k > 0$ si $d(f(A), f(B)) = k \cdot d(A, B)$.
> * **Directe :** Conserve l'orientation. **Indirecte :** Inverse l'orientation.
> * **Structure :** $f = h_{O,k} \circ \sigma$ où $h$ est une homothétie et $\sigma$ une isométrie.
> * **Similitude directe plane :** $z \mapsto az + b$ avec $a \in \mathbb{C}^*$, $|a| = k$ (rapport), $\arg(a) = \theta$ (angle).
> * **Point fixe :** Une similitude directe plane non triviale a un unique point fixe (centre).
> * **Similitude indirecte plane :** $z \mapsto a\bar{z} + b$.
> * **Groupe :** Les similitudes forment un groupe. Les similitudes directes forment un sous-groupe distingué.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Homothétie ≠ similitude :** L'homothétie est une similitude particulière (angle = 0 ou $\pi$).
> * **Centre :** Le centre d'une similitude n'est pas forcément le centre de l'homothétie dans la décomposition.
> * **Rapport 1 :** Similitude de rapport 1 = isométrie.
> * **Composition :** Le rapport de $f \circ g$ est le produit des rapports.
> * **Similitude ≠ affinité :** Toute similitude est affine, mais pas toute affinité (ex : cisaillement).

> [!TIP]
> ### 3. Exercice Type : Centre d'une similitude
> **Énoncé :** Trouver le centre et le rapport de $f(z) = (1+i)z + 2$.
>
> **Solution Détaillée :**
> 1. **Point fixe :** $z = (1+i)z + 2 \Rightarrow z(1 - 1 - i) = 2 \Rightarrow -iz = 2 \Rightarrow z = -2/i = 2i$.
> 2. **Centre :** $\Omega = 2i$.
> 3. **Rapport :** $k = |1 + i| = \sqrt{2}$.
> 4. **Angle :** $\theta = \arg(1+i) = \pi/4$.
> 5. **Conclusion :** Similitude directe de centre $2i$, rapport $\sqrt{2}$, angle $\pi/4$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment caractériser les similitudes parmi les transformations affines ?
>   * **Rép :** La partie linéaire est de la forme $\lambda R$ avec $R$ orthogonale et $\lambda > 0$.
> * **Q2 :** Qu'est-ce qu'une similitude spirale ?
>   * **Rép :** Similitude directe plane de rapport $\neq 1$ : composée d'une homothétie et d'une rotation de même centre.
> * **Q3 :** Les triangles semblables ont-ils les mêmes angles ?
>   * **Rép :** Oui, c'est la définition de la similitude : conservation des angles.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects des similitudes.
* **M. Audin**, *Géométrie* — Excellente approche moderne des similitudes.
