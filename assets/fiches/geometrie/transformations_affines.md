# Transformations Affines

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une transformation affine est une application $f : E \to E$ de la forme $f(M) = f(A) + \vec{f}(\vec{AM})$.
> * **Partie linéaire :** $\vec{f}$ est un endomorphisme de l'espace vectoriel directeur.
> * **Translation :** $\vec{f} = \text{Id}$ et $f(A) \neq A$. Pas de point fixe.
> * **Homothétie :** $\vec{f} = \lambda \text{Id}$ avec un centre — point fixe si $\lambda \neq 1$.
> * **Affinité orthogonale :** $\vec{f}$ est une isométrie vectorielle.
> * **Projection affine :** $\vec{f}$ est une [projection](def:projection), i.e. $\vec{f}^2 = \vec{f}$. Image = sous-espace fixé.
> * **Symétrie affine :** $\vec{f}$ est une symétrie, i.e. $\vec{f}^2 = \text{Id}$.
> * **Groupe affine :** $GA(E)$ est le groupe des bijections affines.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Points fixes :** Ensemble des points fixes = sous-espace affine de direction $\ker(\vec{f} - \text{Id})$.
> * **Translation :** Pas de point fixe, mais direction propre car $\vec{f} = \text{Id}$.
> * **Composition :** $\overrightarrow{g \circ f} = \vec{g} \circ \vec{f}$.
> * **Affinité ≠ application linéaire :** Une affinité qui ne fixe pas l'origine n'est pas linéaire.
> * **Bijectivité :** $f$ bijective ssi $\vec{f}$ bijective, ssi $\det(\vec{f}) \neq 0$.

> [!TIP]
> ### 3. Exercice Type : Points fixes
> **Énoncé :** Soit $f$ l'affinité du plan de partie linéaire $\vec{f}(x, y) = (x + y, x - y)$ et $f(O) = (1, 0)$. Trouver les points fixes.
>
> **Solution Détaillée :**
> 1. **Équation :** $f(M) = M \Leftrightarrow f(O) + \vec{f}(\vec{OM}) = M$.
>    Soit $M = (x, y)$ : $(1, 0) + (x + y, x - y) = (x, y)$.
> 2. **Système :** $\begin{cases} 1 + x + y = x \\ x - y = y \end{cases}$
>    $\Rightarrow \begin{cases} y = -1 \\ x = 2y = -2 \end{cases}$
> 3. **Vérification :** $f(-2, -1) = (1, 0) + (-2 - 1, -2 + 1) = (1, 0) + (-3, -1) = (-2, -1)$ ✓
> 4. **Conclusion :** Unique point fixe $(-2, -1)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Une affinité sans point fixe est-elle forcément une translation ?
>   * **Rép :** Non. Contre-exemple en dimension $\geq 2$ : une affinité dont la partie linéaire a 1 comme valeur propre mais dont le sous-espace propre associé ne contient pas le vecteur translation.
> * **Q2 :** Qu'est-ce qu'une transvection ?
>   * **Rép :** Affinité $f$ telle que $\vec{f} - \text{Id}$ est de rang 1 et $\text{Im}(\vec{f} - \text{Id}) \subset \ker(\vec{f} - \text{Id})$.
> * **Q3 :** Le groupe affine est-il un sous-groupe de $GL_n$ ?
>   * **Rép :** Non directement, mais on peut le plonger dans $GL_{n+1}$ via les coordonnées homogènes.

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne des transformations affines.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Classique complet sur les applications affines.
