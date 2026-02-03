# Produit Scalaire et Applications Géométriques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le **[produit scalaire](def:produit scalaire)** sur $\mathbb{R}^n$ est la forme bilinéaire $\langle \vec{u}, \vec{v} \rangle = \sum u_i v_i$.
> * **Norme euclidienne :** $\|\vec{u}\| = \sqrt{\langle \vec{u}, \vec{u} \rangle}$.
> * **Angle :** $\cos \theta = \frac{\langle \vec{u}, \vec{v} \rangle}{\|\vec{u}\| \|\vec{v}\|}$ pour $\vec{u}, \vec{v} \neq \vec{0}$.
> * **Orthogonalité :** $\vec{u} \perp \vec{v} \Leftrightarrow \langle \vec{u}, \vec{v} \rangle = 0$.
> * **Inégalité de Cauchy-Schwarz :** $|\langle \vec{u}, \vec{v} \rangle| \leq \|\vec{u}\| \|\vec{v}\|$.
> * **Projection orthogonale :** $\text{proj}_{\vec{v}}(\vec{u}) = \frac{\langle \vec{u}, \vec{v} \rangle}{\|\vec{v}\|^2} \vec{v}$.
> * **Formule d'Al-Kashi :** $c^2 = a^2 + b^2 - 2ab\cos C$ (généralisation de Pythagore).
> * **Identité du parallélogramme :** $\|\vec{u}+\vec{v}\|^2 + \|\vec{u}-\vec{v}\|^2 = 2(\|\vec{u}\|^2 + \|\vec{v}\|^2)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Base non orthonormée :** La formule $\sum u_i v_i$ n'est valable qu'en BON.
> * **Cauchy-Schwarz :** L'égalité a lieu ssi les vecteurs sont colinéaires.
> * **Projection :** Ne pas confondre projection sur un vecteur et sur un sous-espace.
> * **Angle orienté vs non orienté :** Le produit scalaire donne $\cos\theta$, pas l'angle orienté.

> [!TIP]
> ### 3. Exercice Type : Théorème de la médiane
> **Énoncé :** Soit $ABC$ un triangle et $M$ le milieu de $[BC]$. Montrer : $AB^2 + AC^2 = 2AM^2 + 2BM^2$.
>
> **Solution Détaillée :**
> 1. **Notations vectorielles :** Posons $\vec{b} = \overrightarrow{AB}$, $\vec{c} = \overrightarrow{AC}$.
> 2. **Milieu :** $\overrightarrow{AM} = \frac{\vec{b} + \vec{c}}{2}$.
> 3. $\overrightarrow{BM}$ **:** $\overrightarrow{BM} = \overrightarrow{BC}/2 = (\vec{c} - \vec{b})/2$.
> 4. **Calcul de $AM^2$ :** $AM^2 = \frac{1}{4}\|\vec{b}+\vec{c}\|^2 = \frac{1}{4}(b^2 + 2\vec{b}\cdot\vec{c} + c^2)$.
> 5. **Calcul de $BM^2$ :** $BM^2 = \frac{1}{4}\|\vec{c}-\vec{b}\|^2 = \frac{1}{4}(c^2 - 2\vec{b}\cdot\vec{c} + b^2)$.
> 6. **Somme :** $2AM^2 + 2BM^2 = b^2 + c^2 = AB^2 + AC^2$. CQFD.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment calculer un angle entre deux droites dans l'espace ?
>   * **Rép :** $\cos\theta = \frac{|\vec{u}\cdot\vec{v}|}{\|\vec{u}\|\|\vec{v}\|}$ (valeur absolue car angle non orienté entre droites).
> * **Q2 :** Qu'est-ce que l'identité de polarisation ?
>   * **Rép :** $\langle \vec{u}, \vec{v} \rangle = \frac{1}{4}(\|\vec{u}+\vec{v}\|^2 - \|\vec{u}-\vec{v}\|^2)$.
> * **Q3 :** Comment prouver Cauchy-Schwarz ?
>   * **Rép :** Étudier $P(t) = \|\vec{u} + t\vec{v}\|^2 \geq 0$ et son discriminant.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects du produit scalaire.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Classique complet sur la géométrie euclidienne.
