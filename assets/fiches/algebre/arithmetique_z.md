# Arithmétique dans $\mathbb{Z}$

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> L'arithmétique étudie les propriétés des entiers, notamment la divisibilité et les nombres premiers.
> * **Divisibilité :** $a | b$ si $\exists k \in \mathbb{Z}, b = ka$. Relations : réflexive, antisymétrique, transitive.
> * **PGCD :** $\gcd(a, b) = \max\{d > 0 : d|a \text{ et } d|b\}$. Calculable par Euclide.
> * **Théorème de Bézout :** $\gcd(a, b) = au + bv$ pour certains $u, v \in \mathbb{Z}$.
> * **PPCM :** $\text{lcm}(a, b) = \frac{|ab|}{\gcd(a, b)}$.
> * **Nombres premiers :** $p > 1$ dont les seuls diviseurs sont $1$ et $p$.
> * **Théorème fondamental :** Tout $n \geq 2$ se décompose de façon unique en produit de premiers.
> * **Congruences :** $a \equiv b \pmod{n}$ si $n | (a - b)$. Relation d'équivalence.
> * **Indicatrice d'Euler :** $\varphi(n) = |\{k \in \{1, \ldots, n\} : \gcd(k, n) = 1\}|$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Division euclidienne :** Le reste est **positif** : $a = bq + r$ avec $0 \leq r < |b|$.
> * **Bézout et PGCD :** $au + bv = d$ n'implique pas $d = \gcd(a,b)$ ! Il faut que $d$ soit le **plus petit** positif.
> * **Premiers entre eux :** $\gcd(a, b) = 1$ ne signifie pas que $a$ ou $b$ est premier.
> * **Valuation $p$-adique :** $v_p(ab) = v_p(a) + v_p(b)$ mais $v_p(a+b) \geq \min(v_p(a), v_p(b))$ avec égalité si $v_p(a) \neq v_p(b)$.
> * **Infinité des premiers :** La preuve d'Euclide ne dit pas que $p_1 \cdots p_n + 1$ est premier !

> [!TIP]
> ### 3. Exercice Type : Algorithme d'Euclide étendu
> **Énoncé :** Calculer $\gcd(120, 45)$ et trouver $u, v$ tels que $120u + 45v = \gcd(120, 45)$.
>
> **Solution Détaillée :**
> 1. **Euclide :**
>    - $120 = 45 \times 2 + 30$
>    - $45 = 30 \times 1 + 15$
>    - $30 = 15 \times 2 + 0$
>    Donc $\gcd(120, 45) = 15$.
> 2. **Remontée :**
>    - $15 = 45 - 30 \times 1$
>    - $15 = 45 - (120 - 45 \times 2) = 45 \times 3 - 120$
>    - $15 = 120 \times (-1) + 45 \times 3$
> 3. **Conclusion :** $u = -1$, $v = 3$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Démontrer qu'il existe une infinité de nombres premiers.
>   * **Rép :** Si $p_1, \ldots, p_n$ sont tous les premiers, $N = p_1 \cdots p_n + 1$ n'est divisible par aucun $p_i$. Contradiction.
> * **Q2 :** Énoncer le théorème chinois.
>   * **Rép :** Si $\gcd(m, n) = 1$, alors $\mathbb{Z}/mn\mathbb{Z} \simeq \mathbb{Z}/m\mathbb{Z} \times \mathbb{Z}/n\mathbb{Z}$.
> * **Q3 :** Calculer $\varphi(12)$.
>   * **Rép :** $\varphi(12) = \varphi(4)\varphi(3) = 2 \times 2 = 4$. Les inversibles sont $\{1, 5, 7, 11\}$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet sur l'arithmétique.
* **J.-E. Rombaldi**, *Algèbre* — Exercices corrigés pour l'agrégation sur l'arithmétique.
