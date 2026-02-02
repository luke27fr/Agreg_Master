# Déterminant

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le **[déterminant](def:determinant)** est un outil fondamental en algèbre linéaire qui associe un scalaire à une famille de vecteurs ou à une matrice.
> * **Définition formelle :** C'est l'unique forme $n$ -linéaire alternée sur un espace vectoriel de dimension $n$, prenant la valeur 1 sur une [base](def:base) fixée.
> * **Volume :** Géométriquement, il mesure le volume orienté du parallélépipède engendré par les vecteurs colonnes.
> * **Caractérisation de l'inversibilité :** Une matrice $A$ est inversible si et seulement si $\det(A) \neq 0$. Cela signifie que ses colonnes forment une [famille libre](def:famille libre).
> * **Multiplicativité :** $\forall A, B \in \mathcal{M}_n(\mathbb{K}), \quad \det(AB) = \det(A)\det(B)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Scalaire et Dimension :** Attention à la multiplication par un scalaire !
>   $$\det(\lambda A) = \lambda^n \det(A)$$
>   (et non pas $\lambda \det(A)$ ). C'est une erreur très fréquente.
> * **Additivité :** Le déterminant n'est **pas** linéaire. En général :
>   $$\det(A + B) \neq \det(A) + \det(B)$$
> * **Blocs :** Pour une matrice par blocs, $\det \begin{pmatrix} A & B \\ C & D \end{pmatrix} \neq \det(A)\det(D) - \det(B)\det(C)$ en général.
>   * Cela n'est vrai que si $C=0$ (bloc triangulaire) ou si $C$ et $D$ commutent (sous conditions).

> [!TIP]
> ### 3. Exercice Type : Différentielle du Déterminant
> **Énoncé :** Montrer que l'application $\det : \mathcal{M}_n(\mathbb{R}) \to \mathbb{R}$ est différentiable et calculer sa différentielle en l'identité $I_n$, puis en toute matrice $A$ inversible.
>
> **Solution Détaillée :**
> 1.  **Au voisinage de l'Identité :**
>     Soit $H$ une matrice petite. On utilise la définition du [polynôme caractéristique](def:polynome caracteristique) :
>     $$\det(I_n + H) = \chi_{-H}(1) = 1 + \text{Tr}(H) + o(\|H\|)$$
>     L'application $H \mapsto \text{Tr}(H)$ est linéaire continue, c'est donc la différentielle en $I_n$.
>     $$d(\det)_{I_n}(H) = \text{Tr}(H)$$
> 2.  **En une matrice $A$ inversible :**
>     On factorise par $A$ : $\det(A+H) = \det(A(I_n + A^{-1}H)) = \det(A) \det(I_n + A^{-1}H)$.
>     En utilisant le résultat précédent :
>     $$\det(A+H) \approx \det(A) (1 + \text{Tr}(A^{-1}H))$$
>     D'où la formule de Jacobi :
>     $$d(\det)_A(H) = \det(A) \text{Tr}(A^{-1}H) = \text{Tr}(\text{Com}(A)^T H)$$

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** $GL_n(\mathbb{C})$ est-il dense dans $\mathcal{M}_n(\mathbb{C})$ ?
>   * **Rép :** Oui. Pour toute matrice $A$, le polynôme $\det(A - zI_n)$ n'a qu'un nombre fini de racines. On peut donc trouver une suite $A_k = A - \frac{1}{k}I_n$ qui converge vers $A$ et dont le déterminant est non nul.
> * **Q2 :** Qu'est-ce que le déterminant de Vandermonde ?
>   * **Rép :** C'est le déterminant d'une matrice formée par des puissances successives ($x_j^{i-1}$ ). Il vaut $\prod_{1 \le i < j \le n} (x_j - x_i)$. Il est non nul ssi les scalaires sont distincts deux à deux.
> * **Q3 :** Le déterminant est-il continu ?
>   * **Rép :** Oui, c'est une fonction polynomiale en les coefficients de la matrice. Elle est donc $C^\infty$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Pour la densité et les calculs classiques).
* **J. Grifone**, *Algèbre Linéaire* (Pour la vision géométrique du volume).