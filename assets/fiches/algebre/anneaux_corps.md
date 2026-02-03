# Anneaux et Corps

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **[anneau](def:anneau)** $(A, +, \times)$ est un ensemble muni de deux lois où $(A, +)$ est un groupe abélien et $\times$ est associative et distributive.
> * **Anneau commutatif :** $\times$ est commutative. **Anneau intègre :** commutatif et sans diviseur de zéro.
> * **[Corps](def:corps) :** Anneau commutatif non nul où tout élément non nul est inversible.
> * **[Idéal](def:ideal) :** Sous-groupe additif $I \subset A$ absorbant : $\forall a \in A, \forall x \in I, ax \in I$.
> * **Idéal premier :** $ab \in I \Rightarrow a \in I$ ou $b \in I$. Alors $A/I$ est intègre.
> * **Idéal maximal :** $I$ maximal (par inclusion) parmi les idéaux propres. Alors $A/I$ est un corps.
> * **Anneau principal :** Anneau intègre dont tout idéal est principal (engendré par un élément).
> * **Anneau euclidien :** Anneau intègre muni d'un stathme permettant la division euclidienne.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Intègre ≠ corps :** $\mathbb{Z}$ est intègre mais pas un corps (2 n'est pas inversible).
> * **Idéal premier vs maximal :** Tout idéal maximal est premier, mais pas réciproquement ($\{0\}$ dans $\mathbb{Z}$).
> * **Caractéristique :** Dans un anneau intègre, la caractéristique est 0 ou un nombre premier.
> * **$\mathbb{Z}/n\mathbb{Z}$ :** C'est un corps ssi $n$ est premier. Sinon, il a des diviseurs de zéro.
> * **Sous-anneau :** Doit contenir 1 ! $2\mathbb{Z}$ n'est pas un sous-anneau de $\mathbb{Z}$.

> [!TIP]
> ### 3. Exercice Type : $\mathbb{Z}/n\mathbb{Z}$ corps
> **Énoncé :** Montrer que $\mathbb{Z}/n\mathbb{Z}$ est un corps si et seulement si $n$ est premier.
>
> **Solution Détaillée :**
> 1. **Si $n = p$ premier :** Soit $\bar{a} \neq \bar{0}$ dans $\mathbb{Z}/p\mathbb{Z}$.
>    Alors $\gcd(a, p) = 1$ (car $p \nmid a$). Par Bézout : $au + pv = 1$, donc $\bar{a} \cdot \bar{u} = \bar{1}$.
>    Ainsi $\bar{a}$ est inversible. C'est un corps.
> 2. **Si $n$ n'est pas premier :** $n = ab$ avec $1 < a, b < n$.
>    Alors $\bar{a} \cdot \bar{b} = \bar{n} = \bar{0}$ avec $\bar{a}, \bar{b} \neq \bar{0}$.
>    Il y a des diviseurs de zéro, donc ce n'est pas un corps (ni même intègre).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner un exemple d'anneau non commutatif.
>   * **Rép :** L'anneau des matrices $\mathcal{M}_n(\mathbb{K})$ pour $n \geq 2$.
> * **Q2 :** Qu'est-ce que la caractéristique d'un anneau ?
>   * **Rép :** Plus petit $n > 0$ tel que $n \cdot 1_A = 0$, ou 0 si n'existe pas.
> * **Q3 :** $\mathbb{Z}[i]$ est-il principal ?
>   * **Rép :** Oui, c'est même euclidien pour le stathme $N(a+bi) = a^2 + b^2$.

### 5. Références Bibliographiques
* **D. Perrin**, *Algèbre* — Excellent pour les structures (anneaux, idéaux, corps).
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet.
