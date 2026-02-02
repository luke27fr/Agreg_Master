# Polynômes d'Endomorphismes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Si $f \in \mathcal{L}(E)$ et $P \in \mathbb{K}[X]$, on définit $P(f) = \sum a_k f^k$.
> * **Annulateur :** Ensemble des polynômes $P$ tels que $P(f) = 0$. C'est un idéal de $\mathbb{K}[X]$.
> * **[Polynôme minimal](def:polynome minimal) :** Générateur unitaire $\mu_f$ de l'annulateur. $\deg(\mu_f) \leq n$.
> * **[Polynôme caractéristique](def:polynome caracteristique) :** $\chi_f(X) = \det(XI - f)$. Degré exactement $n$.
> * **Cayley-Hamilton :** $\chi_f(f) = 0$. Donc $\mu_f | \chi_f$.
> * **Mêmes racines :** $\mu_f$ et $\chi_f$ ont les mêmes racines (les valeurs propres).
> * **[Diagonalisable](def:diagonalisable) :** $f$ diagonalisable ssi $\mu_f$ est scindé à racines simples.
> * **Lemme de décomposition des noyaux :** Si $P = P_1 \cdots P_k$ avec $P_i$ premiers entre eux, alors $\ker(P(f)) = \bigoplus \ker(P_i(f))$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Multiplicités différentes :** $\mu_f$ et $\chi_f$ ont les mêmes racines mais pas les mêmes multiplicités.
> * **Degré du minimal :** $\deg(\mu_f) \leq \deg(\chi_f) = n$, mais peut être strictement inférieur.
> * **Calcul de $\mu_f$ :** En général, $\mu_f$ est le plus petit polynôme non trivial de l'idéal annulateur.
> * **Somme directe :** Dans le lemme de décomposition, les $P_i$ doivent être premiers entre eux deux à deux.
> * **Trigonalisable :** $f$ trigonalisable ssi $\chi_f$ est scindé (pas besoin de condition sur $\mu_f$).

> [!TIP]
> ### 3. Exercice Type : Calcul du polynôme minimal
> **Énoncé :** Soit $A = \begin{pmatrix} 1 & 1 & 0 \\ 0 & 1 & 1 \\ 0 & 0 & 1 \end{pmatrix}$. Trouver $\mu_A$.
>
> **Solution Détaillée :**
> 1. **Polynôme caractéristique :** $\chi_A(X) = (X - 1)^3$ (matrice triangulaire).
> 2. **Test de $(X-1)$ :** $A - I = \begin{pmatrix} 0 & 1 & 0 \\ 0 & 0 & 1 \\ 0 & 0 & 0 \end{pmatrix} \neq 0$.
> 3. **Test de $(X-1)^2$ :** $(A - I)^2 = \begin{pmatrix} 0 & 0 & 1 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix} \neq 0$.
> 4. **Test de $(X-1)^3$ :** $(A - I)^3 = 0$.
> 5. **Conclusion :** $\mu_A(X) = (X - 1)^3 = \chi_A(X)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Cayley-Hamilton.
>   * **Rép :** Tout endomorphisme (ou matrice) annule son polynôme caractéristique : $\chi_f(f) = 0$.
> * **Q2 :** Donner un exemple où $\mu_f \neq \chi_f$.
>   * **Rép :** $A = I_n$ : $\chi_A = (X-1)^n$ mais $\mu_A = X - 1$.
> * **Q3 :** Comment utilise-t-on le lemme de décomposition des noyaux ?
>   * **Rép :** Pour décomposer $E$ en somme directe de sous-espaces stables, notamment pour la réduction de Jordan.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Réduction).
* **C. Deschamps**, *Maths MP* (Polynômes d'endomorphismes).
