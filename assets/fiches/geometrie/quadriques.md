# Quadriques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une quadrique est une surface définie par une équation du second degré dans $\mathbb{R}^3$.
> * **Équation générale :** $\sum a_{ij}x_i x_j + \sum b_i x_i + c = 0$.
> * **Ellipsoïde :** $\frac{x^2}{a^2} + \frac{y^2}{b^2} + \frac{z^2}{c^2} = 1$.
> * **Hyperboloïde à une nappe :** $\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} = 1$ (surface réglée).
> * **Hyperboloïde à deux nappes :** $\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} = -1$.
> * **Paraboloïde elliptique :** $z = \frac{x^2}{a^2} + \frac{y^2}{b^2}$.
> * **Paraboloïde hyperbolique (selle) :** $z = \frac{x^2}{a^2} - \frac{y^2}{b^2}$ (surface réglée).
> * **Cône :** $\frac{x^2}{a^2} + \frac{y^2}{b^2} - \frac{z^2}{c^2} = 0$ (quadrique dégénérée).
> * **Cylindre :** Quadrique dont l'équation ne dépend que de 2 variables.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Signature :** La classification dépend de la signature de la forme quadratique associée.
> * **Surfaces réglées :** L'hyperboloïde à une nappe et le paraboloïde hyperbolique sont réglés (deux familles de droites).
> * **Sections :** Les sections d'une quadrique par un plan sont des coniques.
> * **Axes :** Les axes de symétrie correspondent aux [vecteurs propres](def:vecteur_propre) de la partie quadratique.
> * **Centre :** Certaines quadriques n'ont pas de centre (paraboloïdes, cylindres paraboliques).

> [!TIP]
> ### 3. Exercice Type : Identification
> **Énoncé :** Identifier la quadrique $x^2 + y^2 - z^2 + 2x - 4y + 6z - 2 = 0$.
>
> **Solution Détaillée :**
> 1. **Complétion :** $(x+1)^2 - 1 + (y-2)^2 - 4 - (z-3)^2 + 9 - 2 = 0$.
> 2. **Simplification :** $(x+1)^2 + (y-2)^2 - (z-3)^2 = -2$.
> 3. **Division :** $\frac{(x+1)^2}{2} + \frac{(y-2)^2}{2} - \frac{(z-3)^2}{2} = -1$.
> 4. **Réarrangement :** $\frac{(z-3)^2}{2} - \frac{(x+1)^2}{2} - \frac{(y-2)^2}{2} = 1$.
> 5. **Type :** Hyperboloïde à deux nappes, d'axe parallèle à $Oz$, centré en $(-1, 2, 3)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'une surface réglée ?
>   * **Rép :** Surface engendrée par une famille de droites (génératrices). Ex : hyperboloïde à une nappe, cône.
> * **Q2 :** Comment classifier les quadriques ?
>   * **Rép :** Par la signature de la forme quadratique $(p, q)$ et le rang. Ex : signature $(3, 0)$ = ellipsoïde.
> * **Q3 :** Quelle est la section d'un paraboloïde elliptique par un plan horizontal ?
>   * **Rép :** Une ellipse (ou un point ou vide selon la hauteur du plan).

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (Quadriques).
* **F. Apéry**, *Géométrie* (Surfaces algébriques).
