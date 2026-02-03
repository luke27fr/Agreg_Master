# Polynômes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **polynôme** à coefficients dans un anneau $A$ est une expression $P = \sum_{k=0}^{n} a_k X^k$ où les $a_k \in A$.
> * **Degré :** $\deg(P) = \max\{k : a_k \neq 0\}$. Par convention, $\deg(0) = -\infty$.
> * **Coefficient dominant :** $a_n$ si $\deg(P) = n$. Un polynôme est **unitaire** si son coefficient dominant vaut 1.
> * **Divisibilité :** $P | Q$ si $\exists R \in A[X], Q = PR$. Les inversibles de $\mathbb{K}[X]$ sont les constantes non nulles.
> * **Division euclidienne :** $\forall A, B \in \mathbb{K}[X]$ avec $B \neq 0$, $\exists ! (Q, R)$ tels que $A = BQ + R$ et $\deg(R) < \deg(B)$.
> * **PGCD :** Plus grand diviseur commun (au sens de la divisibilité). $\text{pgcd}(A, B) = AU + BV$ (Bézout).
> * **Racines :** $\alpha$ est racine de $P$ ssi $P(\alpha) = 0$ ssi $(X - \alpha) | P$.
> * **Multiplicité :** $\alpha$ est racine de multiplicité $m$ si $(X-\alpha)^m | P$ mais $(X-\alpha)^{m+1} \nmid P$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Degré du produit :** $\deg(PQ) = \deg(P) + \deg(Q)$ seulement si $A$ est **intègre**. Contre-exemple dans $\mathbb{Z}/4\mathbb{Z}$ : $(2X)(2X) = 4X^2 = 0$.
> * **Polynôme nul vs fonction nulle :** En caractéristique $p$, $X^p - X$ est nul sur $\mathbb{F}_p$ mais n'est pas le polynôme nul ! Ne pas confondre polynôme et fonction polynomiale.
> * **Nombre de racines :** Un polynôme de degré $n$ a **au plus** $n$ racines (dans un corps). Mais attention aux multiplicités : $X^2$ a une seule racine (de multiplicité 2).
> * **Irréductibilité :** Dépend du corps ! $X^2 + 1$ est irréductible dans $\mathbb{R}[X]$ mais pas dans $\mathbb{C}[X]$.
> * **Critère d'Eisenstein :** S'applique aux polynômes à coefficients **entiers**, pas à n'importe quel anneau.

> [!TIP]
> ### 3. Exercice Type : Irréductibilité
> **Énoncé :** Montrer que $P = X^4 + 1$ est irréductible dans $\mathbb{Q}[X]$ mais réductible dans $\mathbb{R}[X]$.
>
> **Solution Détaillée :**
> 1. **Dans $\mathbb{Q}[X]$ :** On applique Eisenstein au polynôme translaté $P(X+1) = (X+1)^4 + 1$.
>    $$(X+1)^4 + 1 = X^4 + 4X^3 + 6X^2 + 4X + 2$$
>    Avec $p = 2$ : $2 | 4, 6, 4, 2$ mais $2 \nmid 1$ et $4 \nmid 2$. Donc $P(X+1)$ est irréductible, donc $P$ aussi.
> 2. **Dans $\mathbb{R}[X]$ :** Les racines sont $e^{i\pi(2k+1)/4}$ pour $k = 0, 1, 2, 3$. En regroupant les conjugués :
>    $$X^4 + 1 = (X^2 - \sqrt{2}X + 1)(X^2 + \sqrt{2}X + 1)$$
>    Ces deux facteurs sont irréductibles dans $\mathbb{R}[X]$ (discriminant négatif).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer et démontrer le théorème de d'Alembert-Gauss.
>   * **Rép :** $\mathbb{C}$ est algébriquement clos : tout polynôme non constant de $\mathbb{C}[X]$ admet au moins une racine dans $\mathbb{C}$. Preuve : par analyse complexe (Liouville) ou topologique.
> * **Q2 :** Quels sont les polynômes irréductibles de $\mathbb{R}[X]$ ?
>   * **Rép :** Les polynômes de degré 1 et les polynômes de degré 2 à discriminant strictement négatif. Tout polynôme de $\mathbb{R}[X]$ se factorise en produit de tels facteurs.
> * **Q3 :** Qu'est-ce que le résultant de deux polynômes ?
>   * **Rép :** $\text{Res}(P, Q) = a_n^m b_m^n \prod (r_i - s_j)$ où $r_i$, $s_j$ sont les racines. Il est nul ssi $P$ et $Q$ ont une racine commune. C'est le déterminant de la matrice de Sylvester.
> * **Q4 :** Donner un critère d'irréductibilité autre qu'Eisenstein.
>   * **Rép :** Réduction modulo $p$ : si $\bar{P}$ est irréductible dans $\mathbb{F}_p[X]$ et $\deg(\bar{P}) = \deg(P)$, alors $P$ est irréductible dans $\mathbb{Q}[X]$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet sur les polynômes.
* **D. Perrin**, *Algèbre* — Excellent pour l'arithmétique des polynômes et l'irréductibilité.
