# Réduction des Endomorphismes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Soit $f \in \mathcal{L}(E)$ un endomorphisme d'un [espace vectoriel](def:espace vectoriel) de dimension finie.
> * **[Valeur propre](def:valeur_propre) :** $\lambda \in \mathbb{K}$ tel que $\exists v \neq 0, f(v) = \lambda v$. Équivalent à $\ker(f - \lambda \text{Id}) \neq \{0\}$.
> * **[Vecteur propre](def:vecteur propre) :** Vecteur non nul $v$ tel que $f(v) = \lambda v$ pour une certaine valeur propre $\lambda$.
> * **Sous-espace propre :** $E_\lambda = \ker(f - \lambda \text{Id})$. C'est un sous-espace stable par $f$.
> * **[Polynôme caractéristique](def:polynome caracteristique) :** $\chi_f(X) = \det(X \cdot \text{Id} - f)$. Ses racines sont les valeurs propres.
> * **[Polynôme minimal](def:polynome minimal) :** Plus petit polynôme unitaire $\mu_f$ tel que $\mu_f(f) = 0$. Il divise $\chi_f$.
> * **[Diagonalisable](def:diagonalisable) :** $f$ est diagonalisable ssi $E$ admet une [base](def:base) de vecteurs propres.
> * **Trigonalisable :** $f$ est trigonalisable ssi $\chi_f$ est scindé sur $\mathbb{K}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Vecteur propre nul :** Le vecteur $\vec{0}$ n'est **jamais** un vecteur propre par définition !
> * **Multiplicité :** Distinguer multiplicité algébrique (dans $\chi_f$) et géométrique (i.e. $\dim E_\lambda$). On a toujours $1 \leq m_g(\lambda) \leq m_a(\lambda)$.
> * **Diagonalisable sur $\mathbb{R}$ vs $\mathbb{C}$ :** Une matrice réelle peut être diagonalisable sur $\mathbb{C}$ mais pas sur $\mathbb{R}$ (ex: rotation).
> * **Polynôme minimal :** $\mu_f$ et $\chi_f$ ont les mêmes racines mais pas les mêmes multiplicités.
> * **Cayley-Hamilton :** $\chi_f(f) = 0$ (l'endomorphisme annule son polynôme caractéristique). Mais $\chi_f \neq \mu_f$ en général.

> [!TIP]
> ### 3. Exercice Type : Diagonalisabilité
> **Énoncé :** Soit $A = \begin{pmatrix} 2 & 1 \\ 0 & 2 \end{pmatrix}$. $A$ est-elle diagonalisable ?
>
> **Solution Détaillée :**
> 1. **Polynôme caractéristique :**
>    $$\chi_A(X) = \det(XI_2 - A) = \det\begin{pmatrix} X-2 & -1 \\ 0 & X-2 \end{pmatrix} = (X-2)^2$$
> 2. **Valeur propre :** $\lambda = 2$ avec multiplicité algébrique $m_a(2) = 2$.
> 3. **Sous-espace propre :**
>    $$E_2 = \ker(A - 2I_2) = \ker\begin{pmatrix} 0 & 1 \\ 0 & 0 \end{pmatrix} = \text{Vect}\begin{pmatrix} 1 \\ 0 \end{pmatrix}$$
>    Donc $m_g(2) = \dim(E_2) = 1 < 2 = m_a(2)$.
> 4. **Conclusion :** $A$ n'est **pas** diagonalisable car $m_g(2) \neq m_a(2)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner une CNS de diagonalisabilité.
>   * **Rép :** $f$ diagonalisable $\Leftrightarrow$ $\mu_f$ scindé à racines simples $\Leftrightarrow$ $\sum \dim(E_\lambda) = \dim(E)$ $\Leftrightarrow$ $\forall \lambda, m_g(\lambda) = m_a(\lambda)$.
> * **Q2 :** Énoncer le théorème de Cayley-Hamilton.
>   * **Rép :** Tout endomorphisme annule son polynôme caractéristique : $\chi_f(f) = 0$.
> * **Q3 :** Qu'est-ce que la décomposition de Dunford ?
>   * **Rép :** Si $f$ est à polynôme caractéristique scindé, alors $f = d + n$ avec $d$ diagonalisable, $n$ nilpotent, et $dn = nd$.
> * **Q4 :** Quand une matrice réelle est-elle diagonalisable sur $\mathbb{R}$ ?
>   * **Rép :** Quand $\chi_f$ est scindé sur $\mathbb{R}$ ET que toutes les multiplicités géométriques égalent les algébriques (ex: matrice symétrique réelle).

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Chapitre Réduction).
* **R. Music**, *Algèbre MP* (Exercices de réduction).
* **C. Deschamps**, *Maths MP* (Dunford et Jordan).
