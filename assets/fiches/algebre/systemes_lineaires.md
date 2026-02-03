# Systèmes Linéaires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **système linéaire** est un ensemble d'équations linéaires : $AX = B$ avec $A \in \mathcal{M}_{n,p}(\mathbb{K})$.
> * **Système homogène :** $AX = 0$. L'ensemble des solutions est $\ker(A)$, un [espace vectoriel](def:espace vectoriel).
> * **Pivot de Gauss :** Algorithme pour échelonner la matrice et résoudre le système.
> * **[Rang](def:rang) :** $\text{rg}(A) = \dim(\text{Im}(A))$. Détermine le nombre de pivots.
> * **Théorème de Rouché-Fontené :** $AX = B$ a des solutions ssi $\text{rg}(A) = \text{rg}(A|B)$.
> * **Structure des solutions :** $\mathcal{S} = x_0 + \ker(A)$ où $x_0$ est une solution particulière.
> * **Système de Cramer :** Système carré (i.e. $n = p$) avec $\det(A) \neq 0$. Solution unique $X = A^{-1}B$.
> * **Formules de Cramer :** $x_i = \frac{\det(A_i)}{\det(A)}$ où $A_i$ est $A$ avec la colonne $i$ remplacée par $B$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Système incompatible :** Si $\text{rg}(A) \neq \text{rg}(A|B)$, pas de solution.
> * **Infinité de solutions :** Si $\text{rg}(A) < p$ et le système est compatible, infinité de solutions.
> * **Pivots nuls :** Lors du pivot de Gauss, échanger les lignes si le pivot est nul.
> * **Ordre des opérations :** Les opérations élémentaires sur les lignes ne changent pas les solutions.
> * **Cramer :** N'utiliser que pour les systèmes carrés inversibles (coûteux sinon).

> [!TIP]
> ### 3. Exercice Type : Résolution par Gauss
> **Énoncé :** Résoudre $\begin{cases} x + y + z = 1 \\ 2x + y - z = 0 \\ x - y + 2z = 3 \end{cases}$
>
> **Solution Détaillée :**
> 1. **Matrice augmentée :**
>    $\begin{pmatrix} 1 & 1 & 1 & | & 1 \\ 2 & 1 & -1 & | & 0 \\ 1 & -1 & 2 & | & 3 \end{pmatrix}$
> 2. **$L_2 \leftarrow L_2 - 2L_1$, $L_3 \leftarrow L_3 - L_1$ :**
>    $\begin{pmatrix} 1 & 1 & 1 & | & 1 \\ 0 & -1 & -3 & | & -2 \\ 0 & -2 & 1 & | & 2 \end{pmatrix}$
> 3. **$L_3 \leftarrow L_3 - 2L_2$ :**
>    $\begin{pmatrix} 1 & 1 & 1 & | & 1 \\ 0 & -1 & -3 & | & -2 \\ 0 & 0 & 7 & | & 6 \end{pmatrix}$
> 4. **Remontée :** $z = 6/7$, $y = 2 - 3z = -4/7$, $x = 1 - y - z = 5/7$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Quelle est la complexité du pivot de Gauss ?
>   * **Rép :** $O(n^3)$ pour un système $n \times n$.
> * **Q2 :** Comment interpréter géométriquement un système de 2 équations à 2 inconnues ?
>   * **Rép :** Deux droites dans le plan. Solution unique si sécantes, infinité si confondues, aucune si parallèles.
> * **Q3 :** Qu'est-ce que la factorisation LU ?
>   * **Rép :** $A = LU$ où $L$ est triangulaire inférieure et $U$ triangulaire supérieure. Utile pour résoudre $AX = B$ rapidement.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet sur les systèmes.
* **R. Music**, *Algèbre linéaire* — Très bon pour les méthodes de résolution et le rang.
