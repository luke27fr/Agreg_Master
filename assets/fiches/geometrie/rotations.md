# Rotations

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une rotation est une isométrie directe (déterminant $+1$) qui fixe un point ou un axe.
> * **Rotation plane :** $R_\theta = \begin{pmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{pmatrix}$.
> * **Groupe $SO_2(\mathbb{R})$ :** Rotations du plan, isomorphe à $\mathbb{R}/2\pi\mathbb{Z}$ ou au cercle $\mathbb{S}^1$.
> * **Rotation 3D :** Matrice $\in SO_3(\mathbb{R})$. Admet un axe (droite de points fixes).
> * **Formule de Rodrigues :** $R_{\vec{u}, \theta}(v) = v\cos\theta + (\vec{u} \times v)\sin\theta + \vec{u}(\vec{u} \cdot v)(1-\cos\theta)$.
> * **Angles d'Euler :** Trois rotations successives autour de $z$, $x'$, $z''$ (ou autre convention).
> * **Quaternions :** $q = \cos(\theta/2) + \sin(\theta/2)(u_x i + u_y j + u_z k)$ représente la rotation d'angle $\theta$ autour de $\vec{u}$.
> * **Groupe $SO_3(\mathbb{R})$ :** Connexe, non simplement connexe. Revêtement universel : $SU_2 \simeq \mathbb{S}^3$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Non-commutativité :** Les rotations 3D ne commutent pas en général (sauf même axe).
> * **Angle orienté :** En dimension 2, l'angle est orienté. En dimension 3, l'axe est orienté.
> * **Quaternions unitaires :** $q$ et $-q$ représentent la **même** rotation.
> * **Gimbal lock :** Les angles d'Euler ont une singularité (perte d'un degré de liberté).
> * **[Valeurs propres](def:valeur_propre) :** Une rotation 3D a pour valeurs propres $1$, $e^{i\theta}$, $e^{-i\theta}$ (sur $\mathbb{C}$).

> [!TIP]
> ### 3. Exercice Type : Rotation 3D
> **Énoncé :** Trouver la matrice de la rotation d'angle $\pi/2$ autour de l'axe $(Oz)$.
>
> **Solution Détaillée :**
> 1. **Action :** $\vec{e_1} \mapsto \vec{e_2}$, $\vec{e_2} \mapsto -\vec{e_1}$, $\vec{e_3} \mapsto \vec{e_3}$.
> 2. **Matrice :**
>    $$R = \begin{pmatrix} 0 & -1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 1 \end{pmatrix}$$
> 3. **Vérification :** $\det(R) = 1$ ✓, $R^T R = I$ ✓.
> 4. **Axe :** Le vecteur $(0, 0, 1)$ est fixé, donc axe = $(Oz)$ ✓.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment reconnaître qu'une matrice orthogonale est une rotation ?
>   * **Rép :** $\det = +1$ (matrice de $SO_n$).
> * **Q2 :** Quelle est la composée de deux rotations d'axes différents ?
>   * **Rép :** Une rotation (en dimension 3, pour des rotations qui ne sont pas demi-tours d'axes parallèles).
> * **Q3 :** Pourquoi les quaternions sont-ils utiles pour les rotations ?
>   * **Rép :** Évitent le gimbal lock, interpolation naturelle (slerp), composition par multiplication.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (Rotations).
* **J. Gallier**, *Geometric Methods and Applications* (Quaternions).
