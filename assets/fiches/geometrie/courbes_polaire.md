# Courbes en Coordonnées Polaires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une **courbe polaire** est définie par $r = f(\theta)$ où $(r, \theta)$ sont les coordonnées polaires.
> * **Conversion cartésienne :** $x = r\cos\theta$, $y = r\sin\theta$.
> * **Tangente :** L'angle $V$ entre le rayon vecteur et la tangente vérifie $\tan V = \frac{r}{r'}$.
> * **Longueur d'arc :** $L = \int_{\theta_1}^{\theta_2} \sqrt{r^2 + r'^2} \, d\theta$.
> * **Aire balayée :** $A = \frac{1}{2} \int_{\theta_1}^{\theta_2} r^2 \, d\theta$.
> * **[Courbure](def:courbure) :** $\kappa = \frac{|r^2 + 2r'^2 - rr''|}{(r^2 + r'^2)^{3/2}}$.
> * **Symétries :** $f(-\theta) = f(\theta)$ (axe polaire), $f(\pi - \theta) = f(\theta)$ (axe perpendiculaire).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Signe de $r$ :** $r < 0$ signifie que le point est dans la direction opposée.
> * **Périodicité :** Vérifier si $f(\theta + 2\pi) = f(\theta)$ ou $f(\theta + \pi) = -f(\theta)$.
> * **Origine :** La courbe passe par l'origine si $r = 0$ pour certains $\theta$.
> * **Branches infinies :** Étudier $r \to \infty$ et les asymptotes.

> [!TIP]
> ### 3. Exercice Type : Cardioïde
> **Énoncé :** Étudier la courbe $r = 1 + \cos\theta$.
>
> **Solution Détaillée :**
> 1. **Domaine et symétrie :** $f(-\theta) = f(\theta)$, symétrie/axe polaire. Étude sur $[0, \pi]$.
> 2. **Variations :**
>    - $r' = -\sin\theta \leq 0$ sur $[0, \pi]$.
>    - $r(0) = 2$, $r(\pi) = 0$.
> 3. **Point à l'origine :** Pour $\theta = \pi$, $r = 0$. Tangente : direction $\theta = \pi$.
> 4. **Angle $V$ :** $\tan V = \frac{1 + \cos\theta}{-\sin\theta} = -\cot(\theta/2)$.
>    En $\theta = 0$ : $V = \pi/2$ (tangente perpendiculaire au rayon).
> 5. **Aire :** $A = \frac{1}{2}\int_0^{2\pi} (1+\cos\theta)^2 d\theta = \frac{3\pi}{2}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Comment trouver la tangente à l'origine ?
>   * **Rép :** La tangente a pour direction les $\theta$ tels que $r(\theta) = 0$.
> * **Q2 :** Quelle est la signification de $\tan V = r/r'$ ?
>   * **Rép :** $V$ est l'angle entre le rayon vecteur et la tangente. Si $r' = 0$, la tangente est perpendiculaire au rayon.
> * **Q3 :** Comment calculer la longueur d'une cardioïde ?
>   * **Rép :** $L = \int_0^{2\pi} \sqrt{(1+\cos\theta)^2 + \sin^2\theta} \, d\theta = 8$.

### 5. Références Bibliographiques
* **F. Liret, D. Martinais**, *Géométrie* — Niveau classes préparatoires, très clair sur les coordonnées polaires.
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects des courbes.
