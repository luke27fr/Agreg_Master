# Isométries Vectorielles

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une isométrie vectorielle conserve le [produit scalaire](def:produit scalaire) : $\langle f(x), f(y) \rangle = \langle x, y \rangle$.
> * **Groupe orthogonal :** $O_n(\mathbb{R}) = \{P \in M_n(\mathbb{R}) : P^T P = I_n\}$.
> * **Groupe spécial orthogonal :** $SO_n(\mathbb{R}) = \{P \in O_n : \det(P) = 1\}$ (rotations).
> * **Caractérisation :** Isométrie $\Leftrightarrow$ préserve la [norme](def:norme) $\Leftrightarrow$ envoie une BON sur une BON.
> * **[Valeurs propres](def:valeur_propre) :** De module 1. Réelles : $\pm 1$.
> * **Réduction (dim 2) :** Rotation $R_\theta$ ou réflexion (symétrie orthogonale).
> * **Réduction (dim 3) :** $SO_3$ : rotation d'axe et angle. $O_3 \setminus SO_3$ : produit rotation × réflexion.
> * **Théorème de Cartan-Dieudonné :** Toute isométrie de $\mathbb{R}^n$ est produit d'au plus $n$ réflexions.

> [!WARNING]
> ### 2. Pièges à éviter
> * **$O_n$ non connexe :** Deux composantes connexes : $SO_n$ ($\det = 1$) et $\det = -1$.
> * **Réflexion ≠ rotation :** La réflexion n'est pas dans $SO_n$ (déterminant $-1$).
> * **Axe de rotation en 3D :** Existe toujours pour une rotation non triviale (espace propre de 1).
> * **Matrice orthogonale ≠ symétrique :** $P^T P = I$ mais $P \neq P^T$ en général.
> * **Sous-espaces stables :** Les sous-espaces propres d'une isométrie sont orthogonaux.

> [!TIP]
> ### 3. Exercice Type : Décomposition d'une isométrie
> **Énoncé :** Soit $f \in O_3(\mathbb{R})$ de matrice $A = \begin{pmatrix} 0 & 1 & 0 \\ -1 & 0 & 0 \\ 0 & 0 & -1 \end{pmatrix}$. Décrire $f$.
>
> **Solution Détaillée :**
> 1. **Déterminant :** $\det(A) = -1 \cdot (0 \cdot 0 - 1 \cdot (-1)) = -1$. Donc $f \in O_3 \setminus SO_3$.
> 2. **Valeurs propres :** $\chi_A(\lambda) = -(\lambda + 1)((\lambda)^2 + 1) = -(\lambda + 1)(\lambda - i)(\lambda + i)$.
>    Valeurs propres : $-1, i, -i$.
> 3. **Vecteur propre pour $\lambda = -1$ :** $A \vec{v} = -\vec{v}$. On trouve $\vec{v} = (0, 0, 1)$.
> 4. **Interprétation :** Dans le plan $(x, y)$, c'est une rotation d'angle $\pi/2$. Selon $z$, c'est la réflexion.
> 5. **Conclusion :** $f$ = rotation de $\pi/2$ autour de $Oz$ composée avec la réflexion par rapport au plan $(x, y)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Cartan-Dieudonné.
>   * **Rép :** Toute isométrie de $E$ euclidien de dimension $n$ est produit d'au plus $n$ réflexions.
> * **Q2 :** $SO_n(\mathbb{R})$ est-il connexe ?
>   * **Rép :** Oui, pour tout $n \geq 1$.
> * **Q3 :** Quelles sont les isométries de $\mathbb{R}^2$ ?
>   * **Rép :** Rotations ($SO_2$) et réflexions (symétries par rapport à une droite).

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Réduction, groupes).
* **M. Berger**, *Géométrie* (Isométries).
