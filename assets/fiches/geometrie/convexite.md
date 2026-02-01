# Convexité

> [!NOTE]
> ### 1. Définitions Fondamentales
> Une partie $C$ d'un espace affine réel $E$ est dite **convexe** si pour tout couple de points $(x, y)$ de $C$, le segment $[x,y]$ est tout entier inclus dans $C$.
> * **Formellement :** $\forall (x, y) \in C^2, \forall t \in [0, 1], (1-t)x + ty \in C$.
> * **Enveloppe Convexe :** $\text{Conv}(A)$ est le plus petit convexe contenant $A$. C'est l'ensemble des barycentres à coefficients positifs des points de $A$.
> * **Fonction Convexe :** $f$ est convexe si son épigraphe est convexe.
> $$\forall x, y, \forall t \in [0,1], f((1-t)x + ty) \le (1-t)f(x) + tf(y)$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Connexité :** Tout convexe est connexe (par arcs), mais la réciproque est fausse (ex: un croissant de lune est connexe mais pas convexe).
> * **Séparation Stricte :** Deux convexes fermés disjoints ne sont pas toujours strictement séparables par un hyperplan (il faut que l'un soit **compact**).
> * **Dimension Infinie :** Dans un Banach quelconque, la projection sur un convexe fermé n'existe pas toujours (il faut être dans un Hilbert ou un espace réflexif strictement convexe).

> [!TIP]
> ### 3. Exercice : Ellipsoïde de John-Loewner
> **Énoncé :** Montrer que pour tout compact $K$ d'intérieur non vide de $\mathbb{R}^n$, il existe un unique ellipsoïde de volume minimal contenant $K$.
>
> #### Solution Détaillée :
> **1. Modélisation :**
> On paramètre les ellipsoïdes centrés en 0 par $E_S = \{ x \mid \langle Sx, x \rangle \le 1 \}$ avec $S$ symétrique définie positive. Minimiser le volume revient à maximiser $\det(S)$.
>
> **2. Compacité :**
> L'ensemble des matrices $S$ admissibles (telles que $K \subset E_S$) est un convexe fermé borné (compact) de l'espace des matrices.
>
> **3. Unicité par convexité :**
> La fonction à maximiser est $f(S) = \ln(\det(S))$.
> Cette fonction est **strictement concave** sur le cône des matrices définies positives (différentielle seconde négative).
> Le maximum sur un convexe compact existe (continuité) et est unique (stricte concavité).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la caractérisation variationnelle de la projection sur un convexe fermé $K$ dans un Hilbert ?
>   * **Rép :** $p = p_K(x) \iff \forall y \in K, \langle x-p, y-p \rangle \le 0$. (L'angle est obtus).
> * **Q2 :** Comment caractériser la convexité d'une fonction $\mathcal{C}^2$ ?
>   * **Rép :** Sa Hessienne $\nabla^2 f(x)$ doit être une matrice positive en tout point (valeurs propres $\ge 0$).
> * **Q3 :** Qu'est-ce que le théorème de Carathéodory ?
>   * **Rép :** Dans un espace affine de dimension $n$, tout point de l'enveloppe convexe de $A$ est barycentre positif d'au plus $n+1$ points de $A$.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (La référence pour l'enveloppe convexe et Carathéodory).
* **H. Brezis**, *Analyse Fonctionnelle* (Pour la projection et Hahn-Banach).
* **F. Rouvière**, *Petit guide de calcul différentiel* (Pour l'optimisation convexe).