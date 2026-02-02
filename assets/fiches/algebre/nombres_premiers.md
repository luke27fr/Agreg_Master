# Nombres Premiers

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **nombre premier** $p$ est un entier $> 1$ dont les seuls diviseurs positifs sont $1$ et $p$.
> * **Lemme d'Euclide :** Si $p$ premier et $p | ab$, alors $p | a$ ou $p | b$.
> * **Crible d'Ératosthène :** Algorithme pour lister les premiers jusqu'à $n$.
> * **Théorème des nombres premiers :** $\pi(x) \sim \frac{x}{\ln x}$ où $\pi(x) = |\{p \leq x : p \text{ premier}\}|$.
> * **Postulat de Bertrand :** Pour tout $n \geq 1$, il existe un premier $p$ tel que $n < p \leq 2n$.
> * **Petits premiers :** $2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, \ldots$
> * **Test de primalité :** Pour tester si $n$ est premier, il suffit de vérifier la divisibilité par les $p \leq \sqrt{n}$.
> * **Nombres de Mersenne :** $M_p = 2^p - 1$. Si $M_p$ est premier, alors $p$ est premier (réciproque fausse).

> [!WARNING]
> ### 2. Pièges à éviter
> * **1 n'est pas premier :** Par convention, pour préserver l'unicité de la décomposition.
> * **2 est le seul premier pair :** Tous les autres premiers sont impairs.
> * **$n! + k$ :** Pour $2 \leq k \leq n$, $n! + k$ est divisible par $k$, donc non premier.
> * **Primalité vs décomposition :** Tester si $n$ est premier est plus facile que factoriser $n$.
> * **Infinité :** Il y a une infinité de premiers, mais leur répartition est irrégulière.

> [!TIP]
> ### 3. Exercice Type : Infinité des premiers $\equiv 3 \pmod{4}$
> **Énoncé :** Montrer qu'il existe une infinité de nombres premiers congrus à $3$ modulo $4$.
>
> **Solution Détaillée :**
> 1. Supposons qu'il n'y ait qu'un nombre fini de tels premiers : $p_1, \ldots, p_k$ (tous $\equiv 3 \pmod{4}$).
> 2. Posons $N = 4p_1 \cdots p_k - 1 \equiv -1 \equiv 3 \pmod{4}$.
> 3. $N$ est impair. S'il n'avait que des facteurs premiers $\equiv 1 \pmod{4}$, alors $N \equiv 1 \pmod{4}$. Contradiction.
> 4. Donc $N$ a un facteur premier $q \equiv 3 \pmod{4}$.
> 5. $q \neq p_i$ car $q | N$ et $q \nmid 4p_1 \cdots p_k$, donc $q \nmid 1$. Mais $N = 4p_1 \cdots p_k - 1$.
> 6. Contradiction : on a trouvé un nouveau premier $\equiv 3 \pmod{4}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Dirichlet sur les progressions arithmétiques.
>   * **Rép :** Si $\gcd(a, b) = 1$, il y a une infinité de premiers de la forme $a + nb$.
> * **Q2 :** Qu'est-ce que l'hypothèse de Riemann ?
>   * **Rép :** Les zéros non triviaux de $\zeta(s)$ ont tous pour partie réelle $1/2$. Non démontrée.
> * **Q3 :** $2^{11} - 1 = 2047$ est-il premier ?
>   * **Rép :** Non, $2047 = 23 \times 89$. Bien que $11$ soit premier, $M_{11}$ ne l'est pas.

### 5. Références Bibliographiques
* **G.H. Hardy, E.M. Wright**, *An Introduction to the Theory of Numbers*.
* **J.-P. Serre**, *Cours d'arithmétique*.
