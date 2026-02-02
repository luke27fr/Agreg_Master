# Formes Quadratiques

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une **forme quadratique** sur un espace vectoriel $E$ est une application $q : E \to \mathbb{K}$ telle que $q(x) = \varphi(x, x)$ pour une forme bilinéaire symétrique $\varphi$.
> * **Forme polaire :** $\varphi(x, y) = \frac{1}{2}(q(x+y) - q(x) - q(y))$ (en caractéristique $\neq 2$).
> * **Matrice :** Dans une base, $q(x) = X^T A X$ où $A$ est symétrique.
> * **Signature :** $(p, q)$ où $p$ = nombre de valeurs propres $> 0$, $q$ = nombre de $< 0$.
> * **Définie positive :** $q(x) > 0$ pour tout $x \neq 0$. Équivalent à signature $(n, 0)$.
> * **Théorème de Sylvester :** La signature est invariante par changement de base.
> * **Réduction de Gauss :** Écrire $q$ comme somme de carrés de formes linéaires indépendantes.
> * **Isotrope :** Vecteur $x \neq 0$ tel que $q(x) = 0$. Un espace est isotrope s'il en contient.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Caractéristique 2 :** La formule de polarisation ne marche pas ! Les formes quadratiques ne sont pas équivalentes aux formes bilinéaires.
> * **Rang ≠ dimension :** Le rang de $q$ est le rang de $\varphi$, pas la dimension de $E$.
> * **Congruence :** Deux matrices sont congruentes ($B = P^T A P$) ssi elles représentent la même forme quadratique.
> * **Définie vs semi-définie :** Semi-définie positive : $q(x) \geq 0$ (le noyau peut être non trivial).
> * **Signature sur $\mathbb{C}$ :** Toute forme quadratique complexe de rang $r$ est congruente à $x_1^2 + \cdots + x_r^2$.

> [!TIP]
> ### 3. Exercice Type : Réduction de Gauss
> **Énoncé :** Réduire $q(x, y, z) = x^2 + 2xy + y^2 + z^2$.
>
> **Solution Détaillée :**
> 1. **Regroupement :** $q = x^2 + 2xy + y^2 + z^2 = (x + y)^2 + z^2$.
> 2. **Changement de variables :** $u = x + y$, $v = y$, $w = z$.
>    Inversible : $x = u - v$, $y = v$, $z = w$.
> 3. **Forme réduite :** $q = u^2 + w^2$.
> 4. **Signature :** $(2, 0)$ car deux carrés positifs, $v$ n'apparaît pas (rang 2 sur un espace de dim 3).
> 5. **Conclusion :** $q$ est semi-définie positive, de rang 2.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème d'inertie de Sylvester.
>   * **Rép :** La signature $(p, q)$ d'une forme quadratique réelle est un invariant : elle ne dépend pas de la base choisie.
> * **Q2 :** Quand une forme quadratique réelle est-elle définie positive ?
>   * **Rép :** Ssi toutes les [valeurs propres](def:valeur_propre) de sa matrice sont strictement positives, ou ssi tous les mineurs principaux sont $> 0$ (Sylvester).
> * **Q3 :** Qu'est-ce que le cône isotrope ?
>   * **Rép :** $\{x \in E : q(x) = 0\}$. C'est un cône (stable par multiplication scalaire).

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Formes quadratiques).
* **C. Deschamps**, *Maths MP* (Réduction).
