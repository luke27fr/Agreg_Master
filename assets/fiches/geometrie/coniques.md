# Coniques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les coniques sont les courbes intersection d'un cône et d'un plan.
> * **Définition bifocale (ellipse) :** $\{M : MF + MF' = 2a\}$ avec $F, F'$ foyers.
> * **Définition bifocale (hyperbole) :** $\{M : |MF - MF'| = 2a\}$.
> * **Définition foyer-directrice :** $\{M : \frac{MF}{MH} = e\}$ où $H$ est le projeté sur la directrice, $e$ l'excentricité.
> * **Excentricité :** $e < 1$ (ellipse), $e = 1$ (parabole), $e > 1$ (hyperbole).
> * **Équation réduite (ellipse) :** $\frac{x^2}{a^2} + \frac{y^2}{b^2} = 1$ avec $a \geq b > 0$.
> * **Équation réduite (hyperbole) :** $\frac{x^2}{a^2} - \frac{y^2}{b^2} = 1$.
> * **Équation réduite (parabole) :** $y^2 = 4px$ où $p$ est le paramètre.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Foyers de l'ellipse :** $c = \sqrt{a^2 - b^2}$ sur le grand axe. $e = c/a < 1$.
> * **Foyers de l'hyperbole :** $c = \sqrt{a^2 + b^2}$. $e = c/a > 1$.
> * **Asymptotes :** L'hyperbole a des asymptotes $y = \pm \frac{b}{a}x$. L'ellipse et la parabole n'en ont pas.
> * **Équation générale :** $ax^2 + bxy + cy^2 + dx + ey + f = 0$. Le discriminant $b^2 - 4ac$ détermine le type.
> * **Dégénérées :** Droites, point, ensemble vide.

> [!TIP]
> ### 3. Exercice Type : Réduction d'une conique
> **Énoncé :** Identifier et réduire $x^2 + 4y^2 - 2x + 8y + 1 = 0$.
>
> **Solution Détaillée :**
> 1. **Regroupement :** $(x^2 - 2x) + 4(y^2 + 2y) + 1 = 0$.
> 2. **Complétion :** $(x - 1)^2 - 1 + 4((y + 1)^2 - 1) + 1 = 0$.
> 3. **Simplification :** $(x - 1)^2 + 4(y + 1)^2 = 4$.
> 4. **Forme réduite :** $\frac{(x-1)^2}{4} + \frac{(y+1)^2}{1} = 1$.
> 5. **Type :** Ellipse de centre $(1, -1)$, $a = 2$, $b = 1$.
> 6. **Excentricité :** $c = \sqrt{4-1} = \sqrt{3}$, $e = \frac{\sqrt{3}}{2}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la propriété de réflexion de l'ellipse ?
>   * **Rép :** Un rayon issu d'un foyer se réfléchit vers l'autre foyer.
> * **Q2 :** Comment reconnaître une conique à partir de son équation générale ?
>   * **Rép :** $\Delta = b^2 - 4ac$ : $\Delta < 0$ ellipse, $\Delta = 0$ parabole, $\Delta > 0$ hyperbole.
> * **Q3 :** Qu'est-ce que la directrice d'une parabole ?
>   * **Rép :** Droite telle que pour tout point $M$ de la parabole, $MF = MH$ ($e = 1$).

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* (Coniques).
* **X. Gourdon**, *Algèbre* (Formes quadratiques et coniques).
