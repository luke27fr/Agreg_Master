# Logique et Ensembles

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La logique et la théorie des ensembles sont les fondements des mathématiques.
> * **Proposition :** Énoncé vrai ou faux. Connecteurs : $\land$ (et), $\lor$ (ou), $\neg$ (non), $\Rightarrow$, $\Leftrightarrow$.
> * **Quantificateurs :** $\forall$ (pour tout), $\exists$ (il existe), $\exists!$ (il existe un unique).
> * **Négation :** $\neg(\forall x, P(x)) \equiv \exists x, \neg P(x)$ et $\neg(\exists x, P(x)) \equiv \forall x, \neg P(x)$.
> * **Ensemble :** Collection d'objets. $x \in A$ (appartenance), $A \subset B$ (inclusion).
> * **Opérations :** $A \cup B$, $A \cap B$, $A \setminus B$, $\bar{A}$ (complémentaire), $A \times B$ (produit cartésien).
> * **Lois de De Morgan :** $\overline{A \cup B} = \bar{A} \cap \bar{B}$ et $\overline{A \cap B} = \bar{A} \cup \bar{B}$.
> * **Parties :** $\mathcal{P}(E)$ est l'ensemble des parties de $E$. $|\mathcal{P}(E)| = 2^{|E|}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * $\in$ **vs** $\subset$ **:** $x \in A$ (élément) vs $B \subset A$ (ensemble). $\{1\} \in \{\{1\}, 2\}$ mais $\{1\} \subset \{1, 2\}$.
> * **Implication :** $P \Rightarrow Q$ est vraie si $P$ est fausse (ex falso quodlibet).
> * **Négation de $\Rightarrow$ :** $\neg(P \Rightarrow Q) \equiv P \land \neg Q$.
> * **Ensemble vide :** $\emptyset \subset A$ pour tout $A$. $\emptyset \neq \{\emptyset\}$.
> * **Quantificateurs emboîtés :** $\forall x, \exists y, P(x,y)$ ≠ $\exists y, \forall x, P(x,y)$ en général.

> [!TIP]
> ### 3. Exercice Type : Raisonnement par contraposée
> **Énoncé :** Montrer que si $n^2$ est pair, alors $n$ est pair.
>
> **Solution Détaillée :**
> 1. **Contraposée :** On montre : si $n$ est impair, alors $n^2$ est impair.
> 2. Si $n$ est impair, $n = 2k + 1$ pour un certain $k \in \mathbb{Z}$.
> 3. $n^2 = (2k+1)^2 = 4k^2 + 4k + 1 = 2(2k^2 + 2k) + 1$.
> 4. Donc $n^2$ est impair.
> 5. Par contraposée, si $n^2$ est pair, alors $n$ est pair.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'un raisonnement par l'absurde ?
>   * **Rép :** On suppose $\neg P$ et on en déduit une contradiction. Donc $P$ est vraie.
> * **Q2 :** Énoncer le principe de récurrence.
>   * **Rép :** Si $P(0)$ et $\forall n, P(n) \Rightarrow P(n+1)$, alors $\forall n, P(n)$.
> * **Q3 :** Qu'est-ce que l'axiome du choix ?
>   * **Rép :** Pour toute famille $(A_i)_{i \in I}$ d'ensembles non vides, il existe une fonction de choix $f : I \to \bigcup A_i$ avec $f(i) \in A_i$.

### 5. Références Bibliographiques
* **D. Perrin**, *Algèbre* — Excellent pour les préliminaires logiques et ensemblistes.
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, fondements clairs.
