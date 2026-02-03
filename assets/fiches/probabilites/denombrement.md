# Dénombrement

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le **dénombrement** consiste à compter le nombre d'éléments d'ensembles finis.
> * **Principe additif :** $|A \cup B| = |A| + |B| - |A \cap B|$.
> * **Principe multiplicatif :** $|A \times B| = |A| \cdot |B|$.
> * **Arrangements :** $A_n^k = \frac{n!}{(n-k)!}$ (k parmi n ordonnés sans répétition).
> * **Permutations :** $P_n = n!$ (arrangements de n parmi n).
> * **Combinaisons :** $\binom{n}{k} = \frac{n!}{k!(n-k)!}$ (k parmi n non ordonnés).
> * **Formule de Pascal :** $\binom{n}{k} = \binom{n-1}{k-1} + \binom{n-1}{k}$.
> * **Binôme de Newton :** $(a+b)^n = \sum_{k=0}^n \binom{n}{k} a^k b^{n-k}$.
> * **Multinôme :** $(x_1 + \cdots + x_p)^n = \sum \frac{n!}{k_1! \cdots k_p!} x_1^{k_1} \cdots x_p^{k_p}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Avec ou sans répétition :** Tirages avec remise vs sans remise.
> * **Ordre ou non :** Arrangements (ordre compte) vs Combinaisons (ordre ne compte pas).
> * **Surcomptage :** Diviser par le nombre de façons de compter le même objet.
> * **Convention :** $\binom{n}{k} = 0$ si $k > n$ ou $k < 0$.

> [!TIP]
> ### 3. Exercice Type : Anagrammes
> **Énoncé :** Combien d'anagrammes du mot "MISSISSIPPI" ?
>
> **Solution Détaillée :**
> 1. **Lettres :** M (1), I (4), S (4), P (2). Total : 11 lettres.
> 2. **Permutations avec répétitions :** $\frac{11!}{1! \cdot 4! \cdot 4! \cdot 2!}$.
> 3. **Calcul :** $\frac{39916800}{1 \cdot 24 \cdot 24 \cdot 2} = \frac{39916800}{1152} = 34650$.
> 4. **Vérification :** On place d'abord les 4 I parmi 11 : $\binom{11}{4}$.
>    Puis les 4 S parmi 7 : $\binom{7}{4}$. Puis les 2 P parmi 3 : $\binom{3}{2}$.
>    Le M va à la dernière place. Total : $330 \times 35 \times 3 = 34650$. ✓

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Combien de parties à k éléments dans un ensemble à n éléments ?
>   * **Rép :** $\binom{n}{k}$.
> * **Q2 :** Donner une preuve combinatoire de $\sum_{k=0}^n \binom{n}{k} = 2^n$.
>   * **Rép :** C'est le nombre total de parties d'un ensemble à n éléments.
> * **Q3 :** Comment compter les surjections de E vers F ?
>   * **Rép :** Formule d'inclusion-exclusion : $\sum_{k=0}^{p} (-1)^k \binom{p}{k} (p-k)^n$ où $|E|=n$, $|F|=p$.

### 5. Références Bibliographiques
* **C. Deschamps**, *Probabilités* (Très bon pour le dénombrement).
* **D. Foata, A. Fuchs**, *Combinatoire pour l'informatique*.
