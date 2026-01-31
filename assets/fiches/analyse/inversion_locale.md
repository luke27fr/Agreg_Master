# Théorème de l'Inversion Locale

### 1. Énoncé du Théorème
Soit $f : U \subset E \to F$ une application de classe $\mathcal{C}^1$, où $E$ et $F$ sont des espaces de Banach.
Soit $a \in U$. Si la différentielle $df_a$ est un **isomorphisme bicontinu**, alors :
Il existe un voisinage ouvert $V$ de $a$ et un voisinage ouvert $W$ de $f(a)$ tels que :
1. $f$ réalise un $\mathcal{C}^1$-difféomorphisme de $V$ sur $W$.
2. Pour tout $y \in W$, en posant $x = f^{-1}(y)$, on a :
$$d(f^{-1})_y = (df_x)^{-1}$$

---

> **⚠️ Pièges à Éviter**
> * **Caractère Local :** Le théorème garantit que $f$ est injective **au voisinage** de $a$, mais pas sur $U$ tout entier. (Penser à l'exponentielle complexe $\exp : \mathbb{C} \to \mathbb{C}^*$).
> * **Différentielle inversible vs Difféomorphisme :** L'inversibilité de $df_x$ en tout point n'implique pas que $f$ est un difféomorphisme global (ex: $x \mapsto e^x$ sur $\mathbb{C}$).
> * **Régularité :** Si $f$ est de classe $\mathcal{C}^k$ ($k \geq 1$), alors son inverse locale est aussi de classe $\mathcal{C}^k$. Ne pas oublier de le préciser à l'oral.
> * **Dimension finie :** En dimension finie, $df_a$ est un isomorphisme si et seulement si le déterminant de la Jacobienne $J_f(a)$ est non nul.

---

### 2. Application : Fonctions Implicites
Le TIL est l'outil fondamental pour démontrer le **Théorème des Fonctions Implicites**. Il permet de "résoudre" localement une équation du type $f(x, y) = 0$ sous la forme $y = \phi(x)$.