# Fractions Rationnelles

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une **fraction rationnelle** est un quotient $F = \frac{P}{Q}$ de deux polynômes avec $Q \neq 0$.
> * **Corps des fractions :** $\mathbb{K}(X)$ est le corps des fractions de l'anneau $\mathbb{K}[X]$.
> * **Forme irréductible :** $F = \frac{P}{Q}$ avec $\gcd(P, Q) = 1$ et $Q$ unitaire.
> * **Degré :** $\deg(F) = \deg(P) - \deg(Q)$.
> * **Pôle :** $\alpha$ est un pôle de $F$ si $Q(\alpha) = 0$ (et $P(\alpha) \neq 0$).
> * **Ordre d'un pôle :** Multiplicité de $\alpha$ comme racine de $Q$.
> * **Partie entière :** Division euclidienne : $F = E + \frac{R}{Q}$ avec $\deg(R) < \deg(Q)$.
> * **Décomposition en éléments simples :** Sur $\mathbb{C}$ : $F = E + \sum \frac{a_{i,j}}{(X - \alpha_i)^j}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Degré négatif :** Si $\deg(P) < \deg(Q)$, le degré de $F$ est **négatif**.
> * **Simplification :** Ne pas oublier de simplifier ! $\frac{X^2-1}{X-1} = X+1$ pour $X \neq 1$.
> * **DES sur $\mathbb{R}$ :** Apparition de termes en $\frac{aX+b}{(X^2+pX+q)^k}$ pour les pôles complexes conjugués.
> * **Pôle ≠ zéro :** Un pôle est une racine du **dénominateur**, pas du numérateur.
> * **Multiplicité :** Dans la DES, les coefficients dépendent de l'ordre du pôle.

> [!TIP]
> ### 3. Exercice Type : Décomposition en éléments simples
> **Énoncé :** Décomposer $F = \frac{1}{X^2(X-1)}$ en éléments simples sur $\mathbb{R}$.
>
> **Solution Détaillée :**
> 1. **Pôles :** $0$ (ordre 2) et $1$ (ordre 1).
> 2. **Forme :** $F = \frac{a}{X} + \frac{b}{X^2} + \frac{c}{X-1}$.
> 3. **Calcul de $c$ :** $(X-1)F|_{X=1} = \frac{1}{1} = 1$, donc $c = 1$.
> 4. **Calcul de $b$ :** $X^2 F|_{X=0} = \frac{1}{-1} = -1$, donc $b = -1$.
> 5. **Calcul de $a$ :** Limite en $+\infty$ : $XF \to 0$, donc $a + c = 0$, soit $a = -1$.
> 6. **Vérification :** $F = \frac{-1}{X} + \frac{-1}{X^2} + \frac{1}{X-1}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi la DES est-elle unique ?
>   * **Rép :** C'est une conséquence de la décomposition en irréductibles et du théorème chinois pour les polynômes.
> * **Q2 :** Comment intègre-t-on une fraction rationnelle ?
>   * **Rép :** On décompose en éléments simples puis on intègre terme à terme (logarithmes et arctan).
> * **Q3 :** Quelle est la DES de $\frac{1}{X^2+1}$ sur $\mathbb{R}$ ? Sur $\mathbb{C}$ ?
>   * **Rép :** Sur $\mathbb{R}$ : déjà irréductible. Sur $\mathbb{C}$ : $\frac{1}{2i}\left(\frac{1}{X-i} - \frac{1}{X+i}\right)$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Fractions rationnelles).
* **C. Deschamps**, *Maths MPSI/MP*.
