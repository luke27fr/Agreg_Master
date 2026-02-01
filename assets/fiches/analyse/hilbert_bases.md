# Bases Hilbertiennes

> [!NOTE]
> ### 1. Définitions et Propriétés
> Une famille $(e_n)_{n \in \mathbb{N}}$ d'un espace de Hilbert $H$ est une **base hilbertienne** si elle est orthonormée et si l'espace vectoriel engendré est dense dans $H$.
> * **Orthonormale :** $\forall (i, j), \langle e_i, e_j \rangle = \delta_{i,j}$.
> * **Identité de Parseval :** Condition nécessaire et suffisante pour être une base :
> $$\forall x \in H, \quad \|x\|^2 = \sum_{n=0}^{+\infty} |\langle x, e_n \rangle|^2$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Base Algébrique :** Ne jamais confondre avec une base de Hamel (algébrique). Une base hilbertienne permet d'écrire $x$ comme somme d'une **série** convergente, pas d'une combinaison linéaire finie.
> * **Séparabilité :** L'existence d'une base hilbertienne **dénombrable** n'est garantie que si l'espace est **séparable**. Sinon, la famille est indénombrable (ex: espaces de fonctions presque-périodiques).

> [!TIP]
> ### 3. Exercice : Orthogonalisation (Legendre)
> **Énoncé :** Dans $E = L^2([-1, 1])$ muni du produit scalaire canonique, construire les deux premiers éléments de la base orthonormée issue de la famille $(1, X, X^2)$ par le procédé de Gram-Schmidt.
>
> #### Solution Détaillée :
> **1. Premier vecteur $e_0$ :**
> On pose $u_0 = 1$. La norme est $\|u_0\|^2 = \int_{-1}^1 1^2 dt = 2$.
> Donc $e_0 = \frac{1}{\sqrt{2}}$.
>
> **2. Deuxième vecteur $e_1$ :**
> On cherche $v_1 = X - \langle X, e_0 \rangle e_0$.
> Produit scalaire : $\langle X, e_0 \rangle = \int_{-1}^1 t \cdot \frac{1}{\sqrt{2}} dt = 0$ (imparité).
> Donc $v_1 = X$. Norme : $\|X\|^2 = \int_{-1}^1 t^2 dt = [\frac{t^3}{3}]_{-1}^1 = \frac{2}{3}$.
> On normalise : $e_1 = \frac{X}{\|X\|} = \sqrt{\frac{3}{2}} X$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donnez un exemple de base hilbertienne classique.
>   * **Rép :** La famille des exponentielles $(e_n)_{n \in \mathbb{Z}}$ définie par $e_n(t) = \frac{1}{\sqrt{2\pi}}e^{int}$ dans l'espace $L^2([0, 2\pi])$.
> * **Q2 :** Quel est le lien avec les Séries de Fourier ?
>   * **Rép :** Les coefficients de Fourier $c_n(f)$ sont exactement les produits scalaires $\langle f, e_n \rangle$. La convergence en moyenne quadratique de la série de Fourier est l'application directe de la théorie des bases hilbertiennes.
> * **Q3 :** Que se passe-t-il si on enlève un vecteur à une base hilbertienne ?
>   * **Rép :** Elle reste orthonormée, mais n'est plus totale. L'orthogonal de l'espace engendré n'est plus réduit à $\{0\}$ (il contient le vecteur retiré).

### 5. Références Bibliographiques
* **H. Brezis**, *Analyse Fonctionnelle* (Théorie générale).
* **X. Gourdon**, *Les maths en tête - Analyse* (Pour les polynômes orthogonaux).
* **H. Queffélec**, *Éléments d'analyse pour l'agrégation* (Exemples concrets).