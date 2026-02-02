# Convexité

> [!NOTE]
> ### 1. Définitions Fondamentales
> Une partie $C$ d'un [espace affine](def:espace affine) réel $E$ est dite **[convexe](def:convexe)** si pour tout couple de points $(x, y)$ de $C$, le segment $[x,y]$ est tout entier inclus dans $C$.
> * **Formellement :** $\forall (x, y) \in C^2, \forall t \in [0, 1], (1-t)x + ty \in C$.
> * **Enveloppe Convexe :** $\text{Conv}(A)$ est le plus petit convexe contenant $A$. C'est l'ensemble des [barycentres](def:barycentre) à coefficients positifs des points de $A$.
> * **Fonction Convexe :** $f$ est convexe si son épigraphe est convexe.
> $$\forall x, y, \forall t \in [0,1], f((1-t)x + ty) \le (1-t)f(x) + tf(y)$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Connexité :** Tout convexe est [connexe](def:connexe) (par arcs), mais la réciproque est fausse (ex: un croissant de lune est connexe mais pas convexe).
> * **Séparation Stricte :** Deux convexes fermés disjoints ne sont pas toujours strictement séparables par un hyperplan (il faut que l'un soit **[compact](def:compact)**).
> * **Dimension Infinie :** Dans un [Banach](def:banach) quelconque, la projection sur un convexe [fermé](def:ferme) n'existe pas toujours (il faut être dans un [Hilbert](def:hilbert) ou un espace réflexif strictement convexe).

> [!TIP] **Exercice Type : Ellipsoïde de John-Loewner**
> **Énoncé :** Montrer que pour tout [compact](def:compact) $K$ d'[intérieur](def:interieur) non vide de $\mathbb{R}^n$, il existe un unique ellipsoïde de volume minimal contenant $K$.
>
> **Solution détaillée :**
> 1.  **Modélisation :** On considère les ellipsoïdes $E_S = \{ x \mid \langle Sx, x \rangle \leq 1 \}$ avec $S \in \mathcal{S}_n^{++}$. Minimiser le volume revient à maximiser $f(S) = \det(S)$.
> 2.  **Existence (Compacité) :** On considère l'ensemble $\mathcal{C} = \{ S \in \mathcal{S}_n^+ \mid K \subset E_S \}$. Cet ensemble est convexe, fermé et **borné** (car $K$ contient une boule $B(0,r)$, donc les [valeurs propres](def:valeur_propre) de $S$ sont majorées par $1/r^2$ ). C'est donc un **compact**.
> 3.  **Maximum :** La fonction $\det$ est [continue](def:continuite) sur le compact $\mathcal{C}$, elle y atteint son maximum en $S_0$. Comme $K$ est borné, on ne peut pas "aplatir" l'ellipsoïde à l'infini, donc $\det(S_0) > 0$, ce qui prouve que $S_0 \in \mathcal{S}_n^{++}$.
> 4.  **Unicité :** Sur l'[ouvert](def:ouvert) convexe $\mathcal{S}_n^{++}$, la fonction $\ln(\det(S))$ est strictement concave, ce qui garantit l'unicité du point critique.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la caractérisation variationnelle de la projection sur un convexe fermé $K$ dans un Hilbert ?
>   * **Rép :** $p = p_K(x) \iff \forall y \in K, \langle x-p, y-p \rangle \le 0$. (L'angle est obtus).
> * **Q2 :** Comment caractériser la convexité d'une fonction $\mathcal{C}^2$ ?
>   * **Rép :** Sa Hessienne $\nabla^2 f(x)$ doit être une matrice positive en tout point ([valeurs propres](def:valeur_propre) $\geq 0$ ).
> * **Q3 :** Qu'est-ce que le théorème de Carathéodory ?
>   * **Rép :** Dans un espace affine de dimension $n$, tout point de l'enveloppe convexe de $A$ est barycentre à coefficients positifs d'au plus $n+1$ points de $A$.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (La référence pour l'enveloppe convexe et Carathéodory).
* **H. Brezis**, *Analyse Fonctionnelle* (Pour la projection et Hahn-Banach).
* **F. Rouvière**, *Petit guide de calcul différentiel* (Pour l'optimisation convexe).