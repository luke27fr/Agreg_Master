# Courbes Paramétrées

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une **courbe paramétrée** est une application $\gamma : I \subset \mathbb{R} \to \mathbb{R}^n$, $t \mapsto \gamma(t)$.
> * **Support :** L'ensemble $\gamma(I)$, qui est l'image de la courbe.
> * **Point régulier :** Point où $\gamma'(t) \neq \vec{0}$.
> * **Point singulier (stationnaire) :** Point où $\gamma'(t) = \vec{0}$.
> * **Tangente :** Au point régulier $\gamma(t_0)$, la tangente est dirigée par $\gamma'(t_0)$.
> * **[Courbure](def:courbure) :** $\kappa(t) = \frac{\|\gamma'(t) \wedge \gamma''(t)\|}{\|\gamma'(t)\|^3}$ (en dimension 2/3).
> * **Rayon de courbure :** $R = 1/\kappa$ quand $\kappa \neq 0$.
> * **Repère de Frenet :** $(\vec{T}, \vec{N}, \vec{B})$ avec $\vec{T} = \gamma'/\|\gamma'\|$, $\vec{N}$ normal principal, $\vec{B}$ binormal.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Régularité :** Un point stationnaire n'est pas forcément un point de rebroussement !
> * **Paramétrage :** Deux paramétrisations différentes donnent la même courbe mais des vitesses différentes.
> * **Tangente en point singulier :** Il faut développer à l'ordre supérieur pour trouver la tangente.
> * **Orientation :** Changer $t$ en $-t$ inverse l'orientation de la courbe.

> [!TIP]
> ### 3. Exercice Type : Cycloïde
> **Énoncé :** Étudier la courbe $\gamma(t) = (t - \sin t, 1 - \cos t)$ pour $t \in [0, 2\pi]$.
>
> **Solution Détaillée :**
> 1. **Dérivée :** $\gamma'(t) = (1 - \cos t, \sin t)$.
> 2. **Points singuliers :** $\gamma'(t) = 0 \Leftrightarrow \cos t = 1$ et $\sin t = 0$, soit $t = 0, 2\pi$.
> 3. **En $t = 0$ :** $\gamma(0) = (0, 0)$ et $\gamma''(0) = (\sin 0, \cos 0) = (0, 1)$.
>    La tangente est verticale (rebroussement de première espèce).
> 4. **Tableau de variations :** Pour $t \in ]0, 2\pi[$, la courbe est régulière.
> 5. **Courbure :** $\kappa = \frac{1}{4\sin(t/2)}$ pour $t \neq 0, 2\pi$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment trouver la tangente en un point singulier ?
>   * **Rép :** On développe $\gamma(t_0 + h)$ et on prend le premier terme non nul.
> * **Q2 :** Qu'est-ce qu'un point de rebroussement ?
>   * **Rép :** Point singulier où la courbe revient sur elle-même (tangente bien définie).
> * **Q3 :** La courbure dépend-elle du paramétrage ?
>   * **Rép :** Non, c'est une propriété intrinsèque de la courbe (invariant géométrique).

### 5. Références Bibliographiques
* **M. Berger, B. Gostiaux**, *Géométrie différentielle*.
* **J. Dieudonné**, *Éléments d'analyse* (Tome 4).
