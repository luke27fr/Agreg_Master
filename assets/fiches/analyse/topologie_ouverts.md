# Topologie : Ouverts et Fermés

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La topologie étudie les notions de proximité et de continuité de façon abstraite.
> * **[Ouvert](def:ouvert) :** Partie $O$ telle que tout point admet un voisinage inclus dans $O$.
> * **[Fermé](def:ferme) :** Complémentaire d'un ouvert. Stable par passage à la limite.
> * **[Adhérence](def:adherence) :** $\bar{A} = $ plus petit fermé contenant $A$ = ensemble des limites de suites de $A$.
> * **[Intérieur](def:interieur) :** $\mathring{A} = $ plus grand ouvert contenu dans $A$.
> * **Frontière :** $\partial A = \bar{A} \setminus \mathring{A}$.
> * **[Dense](def:dense) :** $A$ dense si $\bar{A} = E$ (tout point est limite de points de $A$).
> * **Voisinage :** $V$ est voisinage de $x$ s'il contient un ouvert contenant $x$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Ni ouvert ni fermé :** $]0, 1]$ n'est ni ouvert ni fermé dans $\mathbb{R}$.
> * **Ouvert ET fermé :** $\emptyset$ et $E$ sont toujours ouverts et fermés. Ce sont parfois les seuls ([connexe](def:connexe)).
> * **Adhérence ≠ fermeture :** L'adhérence de $\mathbb{Q}$ dans $\mathbb{R}$ est $\mathbb{R}$.
> * **Intérieur vide :** $\mathring{\mathbb{Q}} = \emptyset$ dans $\mathbb{R}$.
> * **Union/intersection :** Union quelconque d'ouverts = ouvert. Intersection **finie** d'ouverts = ouvert.

> [!TIP]
> ### 3. Exercice Type : Adhérence et intérieur
> **Énoncé :** Déterminer $\bar{A}$ et $\mathring{A}$ pour $A = \mathbb{Q} \cap [0, 1]$ dans $\mathbb{R}$.
>
> **Solution Détaillée :**
> 1. **Adhérence :** Soit $x \in [0, 1]$. Par densité de $\mathbb{Q}$, il existe $(r_n) \subset \mathbb{Q}$ avec $r_n \to x$.
>    En prenant $r_n \cap [0, 1]$ (ajustement près des bords), on a $x \in \bar{A}$.
>    Donc $\bar{A} = [0, 1]$.
> 2. **Intérieur :** Supposons $x \in \mathring{A}$. Alors $\exists \varepsilon > 0, ]x-\varepsilon, x+\varepsilon[ \subset A \subset \mathbb{Q}$.
>    Mais tout intervalle contient des irrationnels. Contradiction.
>    Donc $\mathring{A} = \emptyset$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'une base de topologie ?
>   * **Rép :** Famille d'ouverts telle que tout ouvert est union d'éléments de la famille. Ex : boules ouvertes.
> * **Q2 :** Qu'est-ce que la topologie induite ?
>   * **Rép :** Sur $A \subset E$, les ouverts de $A$ sont les $O \cap A$ où $O$ est ouvert de $E$.
> * **Q3 :** Donner un exemple d'ensemble à la fois ouvert et fermé (autre que $\emptyset$ et $E$).
>   * **Rép :** $[0, 1]$ est ouvert et fermé dans $[0, 1] \cup [2, 3]$ (muni de la topologie induite).

### 5. Références Bibliographiques
* **J. Dixmier**, *Topologie générale*.
* **H. Cartan**, *Cours de calcul différentiel*.
