# Équations Différentielles Linéaires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une équation différentielle linéaire d'ordre $n$ est de la forme $a_n(t)y^{(n)} + \cdots + a_1(t)y' + a_0(t)y = b(t)$.
> * **Homogène :** $b(t) = 0$. L'ensemble des solutions est un [espace vectoriel](def:espace vectoriel) de dimension $n$.
> * **Structure :** Solutions de $(E)$ = solution particulière + solutions de $(H)$.
> * **Wronskien :** $W(y_1, \ldots, y_n) = \det(y_i^{(j-1)})$. Non nul ssi famille libre de solutions.
> * **Ordre 1 :** $y' + a(t)y = b(t)$. Solution : $y(t) = e^{-A(t)}(C + \int b(t)e^{A(t)} dt)$ où $A' = a$.
> * **Ordre 2 à coefficients constants :** $y'' + py' + qy = 0$. Équation caractéristique : $r^2 + pr + q = 0$.
> * **Variation de la constante :** Méthode pour trouver une solution particulière.
> * **Cauchy-Lipschitz :** Existence et unicité de la solution au problème de Cauchy.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Domaine de définition :** Les solutions peuvent exploser en temps fini.
> * **Coefficients non constants :** Pas de méthode générale, sauf cas particuliers (Euler, etc.).
> * **Second membre :** Chercher une solution particulière de même forme que $b(t)$ (si pas résonance).
> * **Résonance :** Si $b(t) = e^{rt}$ et $r$ racine de l'équation caractéristique, multiplier par $t$.
> * **Wronskien nul :** Famille liée de solutions, mais le Wronskien peut être nul à certains points sans lien.

> [!TIP]
> ### 3. Exercice Type : Équation d'ordre 2
> **Énoncé :** Résoudre $y'' - 3y' + 2y = e^{3t}$.
>
> **Solution Détaillée :**
> 1. **Équation homogène :** $r^2 - 3r + 2 = 0 \Rightarrow r = 1$ ou $r = 2$.
>    Solution générale : $y_h = C_1 e^t + C_2 e^{2t}$.
> 2. **Solution particulière :** On cherche $y_p = A e^{3t}$.
>    $y_p' = 3Ae^{3t}$, $y_p'' = 9Ae^{3t}$.
>    $9A - 9A + 2A = 1 \Rightarrow 2A = 1 \Rightarrow A = \frac{1}{2}$.
> 3. **Solution générale :** $y = C_1 e^t + C_2 e^{2t} + \frac{1}{2}e^{3t}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Cauchy-Lipschitz linéaire.
>   * **Rép :** Pour $Y' = A(t)Y + B(t)$ avec $A, B$ continues, il existe une unique solution maximale pour toute condition initiale, définie sur tout l'intervalle.
> * **Q2 :** Quelle est la dimension de l'espace des solutions d'une EDL d'ordre $n$ ?
>   * **Rép :** $n$ (si les coefficients sont continus et $a_n \neq 0$ ).
> * **Q3 :** Comment résoudre une équation d'Euler $t^2 y'' + aty' + by = 0$ ?
>   * **Rép :** Changement $t = e^s$ ou $y = t^r$ ramène à coefficients constants.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **C. Zuily, H. Queffélec**, *Analyse pour l'agrégation* — Cours et exercices.
