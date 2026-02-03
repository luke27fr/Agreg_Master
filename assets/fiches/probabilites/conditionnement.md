# Conditionnement

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Le **conditionnement** modélise la mise à jour de l'information.
> * **[Probabilité conditionnelle](def:probabilite conditionnelle) :** $\mathbb{P}(A|B) = \frac{\mathbb{P}(A \cap B)}{\mathbb{P}(B)}$ si $\mathbb{P}(B) > 0$.
> * **Formule des probabilités totales :** Si $(B_i)$ partition, $\mathbb{P}(A) = \sum_i \mathbb{P}(A|B_i)\mathbb{P}(B_i)$.
> * **Formule de Bayes :** $\mathbb{P}(B_j|A) = \frac{\mathbb{P}(A|B_j)\mathbb{P}(B_j)}{\sum_i \mathbb{P}(A|B_i)\mathbb{P}(B_i)}$.
> * **Espérance conditionnelle (discrète) :** $\mathbb{E}[X|Y=y] = \sum_x x \mathbb{P}(X=x|Y=y)$.
> * **Espérance conditionnelle (densité) :** $\mathbb{E}[X|Y=y] = \int x f_{X|Y=y}(x) dx$.
> * **Formule de l'espérance totale :** $\mathbb{E}[X] = \mathbb{E}[\mathbb{E}[X|Y]]$.
> * **Variance totale :** $\text{Var}(X) = \mathbb{E}[\text{Var}(X|Y)] + \text{Var}(\mathbb{E}[X|Y])$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Attention à l'ordre :** $\mathbb{P}(A|B) \neq \mathbb{P}(B|A)$ en général (confusion courante !).
> * **Conditionnement par événement de proba 0 :** Nécessite une définition plus sophistiquée.
> * **Indépendance :** $A \perp B \Leftrightarrow \mathbb{P}(A|B) = \mathbb{P}(A)$.
> * **$\mathbb{E}[X|Y]$ est une variable aléatoire** (fonction de $Y$), pas un nombre.

> [!TIP]
> ### 3. Exercice Type : Urne de Polya
> **Énoncé :** Une urne contient 1 boule rouge et 1 blanche. On tire une boule et on la remet avec une boule de même couleur. Quelle est la probabilité d'avoir 2 rouges après 2 tirages ?
>
> **Solution Détaillée :**
> 1. **Premier tirage :** $\mathbb{P}(R_1) = 1/2$, $\mathbb{P}(B_1) = 1/2$.
> 2. **Si $R_1$ :** Urne = 2R, 1B. $\mathbb{P}(R_2|R_1) = 2/3$.
> 3. **Probabilité totale :** $\mathbb{P}(R_1 \cap R_2) = \mathbb{P}(R_2|R_1)\mathbb{P}(R_1) = \frac{2}{3} \cdot \frac{1}{2} = \frac{1}{3}$.
> 4. **Vérification par Bayes :** $\mathbb{P}(R_1|R_2) = \frac{\mathbb{P}(R_2|R_1)\mathbb{P}(R_1)}{\mathbb{P}(R_2)} = \frac{1/3}{1/2} = \frac{2}{3}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer la formule de Bayes.
>   * **Rép :** $\mathbb{P}(B|A) = \frac{\mathbb{P}(A|B)\mathbb{P}(B)}{\mathbb{P}(A)}$.
> * **Q2 :** Qu'est-ce que $\mathbb{E}[X|Y]$ ?
>   * **Rép :** C'est la v.a. $g(Y)$ telle que $\mathbb{E}[Xh(Y)] = \mathbb{E}[g(Y)h(Y)]$ pour toute $h$ bornée.
> * **Q3 :** Montrer la formule de l'espérance totale.
>   * **Rép :** $\mathbb{E}[\mathbb{E}[X|Y]] = \sum_y \mathbb{E}[X|Y=y]\mathbb{P}(Y=y) = \mathbb{E}[X]$ par définition.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Traitement complet du conditionnement.
* **J.-Y. Ouvrard**, *Probabilités 1* — Nombreux exercices sur Bayes et probabilités totales.
