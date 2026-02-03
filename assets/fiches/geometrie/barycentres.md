# Barycentres

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le **[barycentre](def:barycentre)** d'un système de points pondérés $(A_i, \alpha_i)$ est l'unique point $G$ tel que :
> $$\sum_{i=1}^n \alpha_i \overrightarrow{GA_i} = \vec{0}$$
> * **Existence :** Le barycentre existe si et seulement si $\sum \alpha_i \neq 0$.
> * **Formule vectorielle :** Pour tout point $O$, $\overrightarrow{OG} = \frac{\sum \alpha_i \overrightarrow{OA_i}}{\sum \alpha_i}$.
> * **Associativité :** On peut regrouper des points : $G = \text{bar}(G_1, \alpha_1 + \alpha_2 ; A_3, \alpha_3)$.
> * **Centre de gravité :** Barycentre à coefficients égaux — tous les $\alpha_i = 1$.
> * **Milieu :** Barycentre de deux points avec poids égaux.
> * **Centre d'inertie :** En mécanique, barycentre pondéré par les masses.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Somme nulle :** Si $\sum \alpha_i = 0$, le barycentre n'existe pas (on obtient un vecteur, pas un point).
> * **Signe des coefficients :** Le barycentre n'est pas nécessairement "entre" les points si les poids sont de signes différents.
> * **Invariance affine :** Le barycentre est préservé par les applications affines, mais pas nécessairement par d'autres transformations.
> * **Coordonnées barycentriques :** $(\alpha_1 : \alpha_2 : \alpha_3)$ sont définies à un facteur près.

> [!TIP]
> ### 3. Exercice Type : Médiane et centroïde
> **Énoncé :** Soit $ABC$ un triangle. Montrer que les trois médianes sont concourantes et trouver le point de concours.
>
> **Solution Détaillée :**
> 1. **Médiane issue de $A$ :** Elle passe par $A$ et $M = \text{milieu}(BC)$.
> 2. **Centre de gravité :** Le centroïde $G$ est le barycentre $(A,1), (B,1), (C,1)$.
> 3. **Position sur la médiane :** $G = \text{bar}(A, 1; M, 2)$ car $M = \text{bar}(B,1; C,1)$.
>    Donc $\overrightarrow{AG} = \frac{2}{3}\overrightarrow{AM}$ : $G$ divise $[AM]$ dans le rapport $2:1$.
> 4. **Conclusion :** Par symétrie des rôles, $G$ appartient aux trois médianes.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce que les coordonnées barycentriques ?
>   * **Rép :** Ce sont les coefficients $(\alpha, \beta, \gamma)$ tels que $P = \alpha A + \beta B + \gamma C$ avec $\alpha + \beta + \gamma = 1$.
> * **Q2 :** Le barycentre est-il conservé par une application affine ?
>   * **Rép :** Oui, c'est une propriété fondamentale des applications affines.
> * **Q3 :** Que se passe-t-il si la somme des poids est nulle ?
>   * **Rép :** On n'obtient pas un point mais un vecteur (bipoint de masse nulle).

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne de la géométrie affine et des barycentres.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Classique complet sur les barycentres.
