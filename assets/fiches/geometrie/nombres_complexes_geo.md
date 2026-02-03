# Nombres Complexes et Géométrie

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les nombres complexes fournissent un outil puissant pour la géométrie plane.
> * **Identification :** $z = x + iy \leftrightarrow M(x, y)$ dans le plan.
> * **Module :** $|z| = $ distance à l'origine = $\sqrt{x^2 + y^2}$.
> * **Argument :** $\arg(z) = $ angle avec l'axe des réels positifs.
> * **Distance :** $d(z_1, z_2) = |z_1 - z_2|$.
> * **Alignement :** $A, B, C$ alignés ssi $\frac{z_C - z_A}{z_B - z_A} \in \mathbb{R}$.
> * **Angle :** $\widehat{(\vec{AB}, \vec{AC})} = \arg\left(\frac{z_C - z_A}{z_B - z_A}\right)$.
> * **Cercle :** Équation $|z - z_0| = R$ (centre $z_0$, rayon $R$).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Argument non défini :** $\arg(0)$ n'existe pas.
> * **Modulo $2\pi$ :** Les arguments sont définis modulo $2\pi$.
> * **Conjugaison :** Réflexion par rapport à l'axe réel : $z \mapsto \bar{z}$.
> * **Produit :** $z_1 z_2$ : modules se multiplient, arguments s'additionnent.
> * **Division :** $z_1/z_2$ : rotation de $-\arg(z_2)$ et division par $|z_2|$.

> [!TIP]
> ### 3. Exercice Type : Cocyclicité
> **Énoncé :** Montrer que $A, B, C, D$ sont cocycliques ssi $\frac{(z_A - z_C)(z_B - z_D)}{(z_A - z_D)(z_B - z_C)} \in \mathbb{R}$.
>
> **Solution Détaillée :**
> 1. **Birapport :** Le birapport $(A, B; C, D) = \frac{(z_C - z_A)(z_D - z_B)}{(z_D - z_A)(z_C - z_B)}$.
> 2. **Réel ssi :** $\arg\left(\frac{(z_C - z_A)(z_D - z_B)}{(z_D - z_A)(z_C - z_B)}\right) = 0$ ou $\pi$.
> 3. **Angles :** $\arg(z_C - z_A) - \arg(z_D - z_A) = \widehat{(\vec{AC}, \vec{AD})}$ (angle inscrit en $A$).
>    Idem pour l'angle en $B$.
> 4. **Cocyclicité :** Les angles inscrits sont égaux ou supplémentaires ssi les 4 points sont sur un même cercle (ou alignés).
> 5. **Conclusion :** Birapport réel $\Leftrightarrow$ cocycliques ou alignés.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment exprimer une rotation en termes complexes ?
>   * **Rép :** $z \mapsto e^{i\theta}(z - z_0) + z_0$ pour une rotation de centre $z_0$ et d'angle $\theta$.
> * **Q2 :** Qu'est-ce qu'une transformation de Möbius ?
>   * **Rép :** $z \mapsto \frac{az + b}{cz + d}$ avec $ad - bc \neq 0$. Préserve les cercles et les droites (cercles passant par $\infty$).
> * **Q3 :** Comment caractériser l'orthogonalité de deux droites en complexes ?
>   * **Rép :** Les directions sont orthogonales ssi le quotient des nombres directeurs est imaginaire pur.

### 5. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne des nombres complexes en géométrie.
* **F. Liret, D. Martinais**, *Géométrie* — Niveau classes préparatoires, très clair sur les complexes.
