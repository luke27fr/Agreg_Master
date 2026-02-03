# Géométrie Plane

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La **géométrie plane** étudie les figures du plan affine ou euclidien $\mathbb{R}^2$.
> * **Droite :** Ensemble $\{M : \overrightarrow{AM} = t\vec{u}, t \in \mathbb{R}\}$ ou équation $ax + by + c = 0$.
> * **Distance point-droite :** $d(M_0, \mathcal{D}) = \frac{|ax_0 + by_0 + c|}{\sqrt{a^2 + b^2}}$.
> * **Cercle :** $\{M : \|M - \Omega\| = R\}$, équation $(x-a)^2 + (y-b)^2 = R^2$.
> * **Puissance d'un point :** $\mathcal{P}(M) = d(M, \Omega)^2 - R^2$.
> * **Axe radical :** Lieu des points de même puissance par rapport à deux cercles.
> * **Triangle :** Points remarquables : centroïde $G$, orthocentre $H$, centre du cercle circonscrit $O$.
> * **Droite d'Euler :** $G$, $H$, $O$ sont alignés avec $\overrightarrow{OG} = \frac{1}{3}\overrightarrow{OH}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Orientation :** Dans le plan orienté, distinguer angles orientés et non orientés.
> * **Cercles tangents :** Tangence interne vs externe (somme ou différence des rayons).
> * **Alignement :** Trois points alignés $\Leftrightarrow$ déterminant nul $\Leftrightarrow$ vecteurs colinéaires.
> * **Concours :** Trois droites concourantes $\Leftrightarrow$ le système a une unique solution.

> [!TIP]
> ### 3. Exercice Type : Cercle d'Euler
> **Énoncé :** Montrer que les milieux des côtés, les pieds des hauteurs et les milieux de $[AH]$, $[BH]$, $[CH]$ sont sur un même cercle (9 points).
>
> **Solution Détaillée :**
> 1. **Notations :** $A', B', C'$ milieux des côtés, $H_A, H_B, H_C$ pieds des hauteurs.
> 2. **Centre du cercle d'Euler :** C'est le milieu $\omega$ de $[OH]$.
> 3. **Rayon :** $R/2$ où $R$ est le rayon du cercle circonscrit.
> 4. **Vérification :** L'homothétie de centre $G$ et de rapport $-1/2$ envoie le cercle circonscrit sur le cercle d'Euler.
> 5. **Les 9 points :** Cette homothétie envoie $A, B, C$ sur $A', B', C'$, et les propriétés des hauteurs donnent les 6 autres points.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce que la droite d'Euler ?
>   * **Rép :** Droite passant par $G$ (centroïde), $O$ (centre du cercle circonscrit) et $H$ (orthocentre).
> * **Q2 :** Comment caractériser la puissance d'un point ?
>   * **Rép :** $\mathcal{P}(M) = MA \cdot MB$ pour toute sécante passant par $M$ coupant le cercle en $A, B$.
> * **Q3 :** Combien de cercles passent par deux points ?
>   * **Rép :** Une infinité, leurs centres sont sur la médiatrice du segment.

### 5. Références Bibliographiques
* **H.S.M. Coxeter**, *Introduction to Geometry*.
* **M. Berger**, *Géométrie* (Volumes 1-5).
