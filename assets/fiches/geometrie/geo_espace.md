# Géométrie de l'Espace

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La **géométrie de l'espace** étudie les figures de l'espace affine ou euclidien $\mathbb{R}^3$.
> * **Droite :** $\{A + t\vec{u} : t \in \mathbb{R}\}$, représentation paramétrique.
> * **Plan :** $ax + by + cz + d = 0$, vecteur normal $\vec{n} = (a, b, c)$.
> * **Distance point-plan :** $d(M_0, \mathcal{P}) = \frac{|ax_0 + by_0 + cz_0 + d|}{\sqrt{a^2 + b^2 + c^2}}$.
> * **Positions relatives :**
>   - Deux droites : sécantes, parallèles (strictement ou confondues), ou non coplanaires.
>   - Droite et plan : sécants, parallèles (droite dans le plan ou strictement parallèle).
> * **Produit mixte :** $[\vec{u}, \vec{v}, \vec{w}] = \vec{u} \cdot (\vec{v} \wedge \vec{w}) = \det(\vec{u}, \vec{v}, \vec{w})$.
> * **Volume tétraèdre :** $V = \frac{1}{6}|[\overrightarrow{AB}, \overrightarrow{AC}, \overrightarrow{AD}]|$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Non coplanarité :** En 3D, deux droites peuvent ne pas se couper sans être parallèles.
> * **Produit vectoriel :** $\vec{u} \wedge \vec{v}$ n'est défini qu'en dimension 3.
> * **Orientation :** Le produit mixte change de signe si on permute deux vecteurs.
> * **Perpendiculaire commune :** Unique entre deux droites non coplanaires.

> [!TIP]
> ### 3. Exercice Type : Distance entre droites
> **Énoncé :** Calculer la distance entre les droites $\mathcal{D}_1 : (1,0,0) + t(1,1,0)$ et $\mathcal{D}_2 : (0,1,1) + s(0,1,1)$.
>
> **Solution Détaillée :**
> 1. **Vecteurs directeurs :** $\vec{u}_1 = (1,1,0)$, $\vec{u}_2 = (0,1,1)$.
> 2. **Coplanarité ?** $\vec{u}_1 \wedge \vec{u}_2 = (1,-1,1) \neq \vec{0}$, donc non parallèles.
> 3. **Un point par droite :** $A = (1,0,0)$ sur $\mathcal{D}_1$, $B = (0,1,1)$ sur $\mathcal{D}_2$.
> 4. **Formule :** $d = \frac{|[\overrightarrow{AB}, \vec{u}_1, \vec{u}_2]|}{\|\vec{u}_1 \wedge \vec{u}_2\|}$.
> 5. **Calcul :** $\overrightarrow{AB} = (-1,1,1)$, produit mixte $= (-1)(1) + (1)(-1) + (1)(1) = -1$.
>    $\|\vec{u}_1 \wedge \vec{u}_2\| = \sqrt{3}$. Donc $d = \frac{1}{\sqrt{3}}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment montrer que deux droites sont coplanaires ?
>   * **Rép :** Le produit mixte $[\overrightarrow{AB}, \vec{u}_1, \vec{u}_2] = 0$ où $A \in \mathcal{D}_1$, $B \in \mathcal{D}_2$.
> * **Q2 :** Quelle est la perpendiculaire commune à deux droites non coplanaires ?
>   * **Rép :** Unique droite perpendiculaire aux deux, sa direction est $\vec{u}_1 \wedge \vec{u}_2$.
> * **Q3 :** Comment calculer le volume d'un parallélépipède ?
>   * **Rép :** $V = |[\vec{a}, \vec{b}, \vec{c}]|$ (valeur absolue du produit mixte des arêtes).

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (Volume 2 : Espaces euclidiens).
* **J. Dieudonné**, *Algèbre linéaire et géométrie élémentaire*.
