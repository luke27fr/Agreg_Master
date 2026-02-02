# Géométrie Euclidienne

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La géométrie euclidienne ajoute la notion de distance et d'angle à la géométrie affine.
> * **[Espace euclidien](def:espace euclidien) :** Espace affine dont la direction est munie d'un [produit scalaire](def:produit scalaire).
> * **Distance :** $d(A, B) = \|\vec{AB}\|$.
> * **[Orthogonalité](def:orthogonal) :** Droites orthogonales si leurs directions sont orthogonales.
> * **[Projection](def:projection) orthogonale :** Sur un sous-espace affine : point le plus proche.
> * **Distance point-droite :** $d(M, D) = \|MH\|$ où $H$ est le projeté orthogonal.
> * **Cercle :** Ensemble des points à distance fixe $r$ d'un centre $O$.
> * **Isométrie :** Application affine préservant les distances.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Droites orthogonales ≠ perpendiculaires :** "Perpendiculaires" implique souvent l'intersection.
> * **Projection :** La projection orthogonale sur une droite affine n'est pas linéaire.
> * **Isométrie :** Composée de translations, rotations, réflexions (et éventuellement réflexion glissée).
> * **Médiatrice :** Ensemble des points équidistants de $A$ et $B$ : hyperplan orthogonal à $\vec{AB}$ passant par le milieu.
> * **Angle orienté :** Attention au sens et à la définition modulo $2\pi$.

> [!TIP]
> ### 3. Exercice Type : Distance point-plan
> **Énoncé :** Calculer la distance de $M(1, 2, 3)$ au plan $P : x + y + z = 0$ dans $\mathbb{R}^3$.
>
> **Solution Détaillée :**
> 1. **Vecteur normal :** $\vec{n} = (1, 1, 1)$.
> 2. **Point du plan :** $A = (0, 0, 0) \in P$.
> 3. **Vecteur $\vec{AM}$ :** $\vec{AM} = (1, 2, 3)$.
> 4. **Distance :** $d = \frac{|\vec{AM} \cdot \vec{n}|}{\|\vec{n}\|} = \frac{|1 + 2 + 3|}{\sqrt{3}} = \frac{6}{\sqrt{3}} = 2\sqrt{3}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Classifier les isométries du plan.
>   * **Rép :** Translations, rotations, réflexions, réflexions glissées (composée d'une réflexion et d'une translation parallèle à l'axe).
> * **Q2 :** Qu'est-ce que le cercle circonscrit à un triangle ?
>   * **Rép :** Cercle passant par les 3 sommets. Centre = intersection des médiatrices.
> * **Q3 :** Énoncer le théorème de Pythagore.
>   * **Rép :** Dans un triangle rectangle en $C$ : $AB^2 = AC^2 + BC^2$.

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie*.
* **M. Berger**, *Géométrie* (Tomes 1-2).
