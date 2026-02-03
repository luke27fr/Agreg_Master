# Géométrie Affine

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La géométrie affine étudie les propriétés préservées par les transformations affines.
> * **Espace affine :** Ensemble $E$ muni d'un [espace vectoriel](def:espace vectoriel) $\vec{E}$ et d'une action libre transitive : $\vec{AB} \in \vec{E}$.
> * **Relation de Chasles :** $\vec{AB} + \vec{BC} = \vec{AC}$.
> * **[Barycentre](def:barycentre) :** Point $G$ tel que $\sum \alpha_i \vec{GA_i} = \vec{0}$ avec $\sum \alpha_i \neq 0$.
> * **Sous-espace affine :** $F = A + \vec{F}$ où $\vec{F}$ est un sous-espace vectoriel (direction de $F$).
> * **Application affine :** $f(A + \vec{v}) = f(A) + \vec{f}(\vec{v})$ où $\vec{f}$ est linéaire (partie linéaire).
> * **Parallélisme :** Deux sous-espaces sont parallèles si leurs directions sont incluses l'une dans l'autre.
> * **Théorème de Thalès :** Des parallèles coupent des sécantes en segments proportionnels.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Pas d'origine :** Un espace affine n'a pas de point privilégié (pas de "0").
> * **Barycentre :** Les coefficients doivent avoir une somme non nulle.
> * **Affine ≠ linéaire :** Une translation n'est pas linéaire (pas de point fixe).
> * **Direction :** La direction d'une droite affine est une droite vectorielle, pas un vecteur.
> * **Intersection :** L'intersection de deux sous-espaces affines peut être vide (droites parallèles).

> [!TIP]
> ### 3. Exercice Type : Barycentre
> **Énoncé :** Soit $G$ le barycentre de $(A, 1), (B, 2), (C, 3)$. Exprimer $\vec{AG}$.
>
> **Solution Détaillée :**
> 1. **Définition :** $1 \cdot \vec{GA} + 2 \cdot \vec{GB} + 3 \cdot \vec{GC} = \vec{0}$.
> 2. **Avec $\vec{GA}$ :** $\vec{GA} + 2(\vec{GA} + \vec{AB}) + 3(\vec{GA} + \vec{AC}) = \vec{0}$.
> 3. **Simplification :** $6\vec{GA} + 2\vec{AB} + 3\vec{AC} = \vec{0}$.
> 4. **Donc :** $\vec{GA} = -\frac{1}{6}(2\vec{AB} + 3\vec{AC})$.
> 5. **Conclusion :** $\vec{AG} = \frac{1}{6}(2\vec{AB} + 3\vec{AC}) = \frac{1}{3}\vec{AB} + \frac{1}{2}\vec{AC}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'un repère affine ?
>   * **Rép :** Un point $O$ (origine) et une [base](def:base) de $\vec{E}$. Les coordonnées de $M$ sont celles de $\vec{OM}$.
> * **Q2 :** Une application affine bijective est-elle toujours inversible comme application affine ?
>   * **Rép :** Oui, et l'inverse est aussi affine (partie linéaire = inverse de la partie linéaire).
> * **Q3 :** Qu'est-ce qu'une homothétie ?
>   * **Rép :** Application affine $h$ telle que $\vec{h} = \lambda \text{Id}$. Centre : unique point fixe si $\lambda \neq 1$.

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne de la géométrie affine.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Classique complet sur la géométrie affine.
