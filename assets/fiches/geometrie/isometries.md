# Isométries Affines

> [!NOTE]
> ### 1. Définitions et Propriétés
> Une application affine $f$ d'un espace affine euclidien $\mathcal{E}$ dans lui-même est une **isométrie affine** si elle conserve les distances :
> $\forall (M, N) \in \mathcal{E}^2, \quad d(f(M), f(N)) = d(M, N)$.
> * **Partie Linéaire :** Sa partie linéaire $\vec{f}$ est une isométrie vectorielle (un élément du groupe orthogonal $O(\vec{E})$ ).
> * **Structure de Groupe :** L'ensemble des isométries forme un groupe, noté $Isom(\mathcal{E})$.
> * **Conservation :** Elle conserve le produit scalaire, les angles géométriques, les aires et les volumes (au signe près).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Points Fixes :** Contrairement aux isométries vectorielles, une isométrie affine ne possède pas toujours de points fixes (Exemple : une translation de vecteur non nul, ou une symétrie glissée).
> * **Déplacement vs Antidéplacement :** Ne pas confondre !
>   * **Déplacement :** $\det(\vec{f}) = 1$ (consèrve l'orientation, ex: rotation, translation).
>   * **Antidéplacement :** $\det(\vec{f}) = -1$ (renverse l'orientation, ex: réflexion).

> [!TIP]
> ### 3. Exercice : Théorème des 3 miroirs
> **Énoncé :** Soit $f$ une isométrie du plan affine euclidien. Montrer que $f$ peut s'écrire comme la composée d'au plus 3 réflexions (symétries orthogonales par rapport à une droite).
>
> #### Solution Détaillée :
> **1. Cas où $f$ a 3 points fixes non alignés :**
> Si $A, B, C$ sont fixes non alignés, alors $f$ est l'identité. (0 réflexion).
>
> **2. Cas où $f$ a au moins 1 point fixe $A$ :**
> Si $f(A)=A$, alors $f$ est une isométrie vectorielle. C'est soit une rotation, soit une réflexion.
> * Si c'est une réflexion : 1 réflexion.
> * Si c'est une rotation, elle se décompose en 2 réflexions (dont les axes passent par $A$ ).
>
> **3. Cas général (pas de point fixe) :**
> Soit $A$ un point quelconque et $A' = f(A)$.
> Soit $s$ la réflexion d'axe la médiatrice de $[AA']$. Alors $s(A) = A'$.
> On considère $g = s \circ f$. On a $g(A) = s(f(A)) = s(A') = A$.
> Donc $g$ a un point fixe ($A$ ). D'après le cas 2, $g$ est composée de 1 ou 2 réflexions ($r_1 \circ r_2$ ou $r_1$ ).
> Comme $f = s \circ g$ (car $s^{-1} = s$ ), alors $f$ est composée de $1+1=2$ ou $1+2=3$ réflexions.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quels sont les générateurs du groupe des isométries affines ?
>   * **Rép :** Les réflexions (symétries orthogonales par rapport à un hyperplan). C'est le théorème de Cartan-Dieudonné affine.
> * **Q2 :** Comment reconnaître une symétrie glissée en dimension 2 ?
>   * **Rép :** C'est un antidéplacement ($\det(\vec{f}) = -1$ ) qui n'a pas de point fixe. Sa forme canonique est $t_{\vec{u}} \circ s_D$ avec $\vec{u}$ vecteur directeur de $D$.
> * **Q3 :** Le centre du groupe orthogonal $O(E)$ est-il toujours réduit à $\{Id, -Id\}$ ?
>   * **Rép :** Oui, pour $n \ge 2$. Si $n$ est impair, $-Id$ est un antidéplacement (symétrie centrale).

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne des isométries.
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects des isométries.