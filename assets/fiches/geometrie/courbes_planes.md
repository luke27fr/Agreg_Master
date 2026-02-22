# Courbes Planes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une courbe plane est définie par une équation $F(x, y) = 0$ ou paramétriquement $(x(t), y(t))$.
> * **Courbe paramétrée :** $\gamma : I \to \mathbb{R}^2$, $t \mapsto (x(t), y(t))$.
> * **Régulière :** $\gamma'(t) \neq 0$ pour tout $t$.
> * **Tangente :** Dirigée par $\gamma'(t)$.
> * **Courbure :** $\kappa = \frac{x'y'' - y'x''}{(x'^2 + y'^2)^{3/2}}$.
> * **Rayon de courbure :** $R = 1/|\kappa|$.
> * **Repère de Frenet :** $(\vec{T}, \vec{N})$ avec $\vec{T} = \gamma'/\|\gamma'\|$ et $\vec{N}$ normal direct.
> * **Longueur d'arc :** $s(t) = \int_{t_0}^{t} \|\gamma'(u)\| du$.
> * **Abscisse curviligne :** Paramétrage par la longueur d'arc, alors $\|\gamma'(s)\| = 1$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Point singulier :** Si $\gamma'(t) = 0$, la tangente peut ne pas être définie ou être verticale.
> * **Courbure signée :** Le signe dépend de l'orientation. $\kappa > 0$ = tourne vers $\vec{N}$.
> * **Changement de paramètre :** La courbure est intrinsèque (ne dépend pas du paramétrage).
> * **Point d'inflexion :** Point où $\kappa$ change de signe, i.e. $\kappa = 0$.
> * **Branches infinies :** Asymptotes à étudier quand $t \to \pm\infty$ ou vers une singularité.

> [!TIP]
> ### 3. Exercice Type : Courbure du cercle
> **Énoncé :** Calculer la courbure du cercle de rayon $R$ paramétré par $\gamma(t) = (R\cos t, R\sin t)$.
>
> **Solution Détaillée :**
> 1. **Dérivées :** $\gamma'(t) = (-R\sin t, R\cos t)$, $\gamma''(t) = (-R\cos t, -R\sin t)$.
> 2. **Numérateur :** $x'y'' - y'x'' = (-R\sin t)(-R\sin t) - (R\cos t)(-R\cos t) = R^2(\sin^2 t + \cos^2 t) = R^2$.
> 3. **Dénominateur :** $(x'^2 + y'^2)^{3/2} = (R^2\sin^2 t + R^2\cos^2 t)^{3/2} = R^3$.
> 4. **Courbure :** $\kappa = \frac{R^2}{R^3} = \frac{1}{R}$.
> 5. **Interprétation :** Courbure constante, rayon de courbure $= R$ (le rayon du cercle).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce que le centre de courbure ?
>   * **Rép :** Point $\Omega = M + R\vec{N}$ où $R = 1/|\kappa|$. Limite des intersections de normales voisines.
> * **Q2 :** Quelle est la courbe de courbure constante non nulle ?
>   * **Rép :** Le cercle (en géométrie euclidienne du plan).
> * **Q3 :** Qu'est-ce que l'enveloppe d'une famille de courbes ?
>   * **Rép :** Courbe tangente à toutes les courbes de la famille. Ex : la développée est l'enveloppe des normales.

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects des courbes planes.
* **F. Liret, D. Martinais**, *Géométrie* — Niveau classes préparatoires, très clair sur les courbes.
