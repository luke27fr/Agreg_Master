# Compacité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La [compacité](def:compact) est une propriété de "finitude topologique" fondamentale en analyse.
> * **Définition :** $K$ est compact si de tout recouvrement ouvert on peut extraire un sous-recouvrement **fini**.
> * **En dimension finie :** Compact $\Leftrightarrow$ fermé et borné (Borel-Lebesgue).
> * **Bolzano-Weierstrass :** Compact $\Leftrightarrow$ toute suite admet une sous-suite convergente (dans $K$).
> * **Image continue :** L'image d'un compact par une fonction continue est compacte.
> * **Extrema :** Fonction continue sur un compact $\Rightarrow$ atteint ses bornes.
> * **Uniformité :** Fonction continue sur un compact $\Rightarrow$ uniformément continue (Heine).
> * **Intersection décroissante :** Intersection de compacts emboîtés non vides = non vide.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Fermé borné en dim infinie :** La boule unité fermée de $\ell^2$ n'est **pas** compacte !
> * **Ouvert ≠ compact :** $]0, 1[$ n'est pas compact (pas fermé).
> * **Partie de compact :** Une partie d'un compact n'est compacte que si elle est **fermée**.
> * **Complet ≠ compact :** $\mathbb{R}$ est complet mais pas compact.
> * **Séquentiellement compact :** En général, équivalent à compact pour les espaces métriques.

> [!TIP]
> ### 3. Exercice Type : Extrema sur un compact
> **Énoncé :** Soit $f : [a, b] \to \mathbb{R}$ continue. Montrer que $f$ atteint son maximum.
>
> **Solution Détaillée :**
> 1. **Image compacte :** $f([a, b])$ est compact dans $\mathbb{R}$ (image continue d'un compact).
> 2. **Compact de $\mathbb{R}$ :** Donc $f([a, b])$ est fermé et borné.
> 3. **Borne sup atteinte :** Soit $M = \sup f([a, b])$. Il existe $(y_n) \subset f([a, b])$ avec $y_n \to M$.
>    Comme $f([a, b])$ est fermé, $M \in f([a, b])$.
> 4. **Conclusion :** $\exists c \in [a, b]$ tel que $f(c) = M$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Borel-Lebesgue.
>   * **Rép :** Dans $\mathbb{R}^n$, compact $\Leftrightarrow$ fermé et borné.
> * **Q2 :** Qu'est-ce qu'un espace localement compact ?
>   * **Rép :** Tout point admet un voisinage compact. Ex : $\mathbb{R}^n$, mais pas les espaces de Banach de dimension infinie.
> * **Q3 :** Donner un exemple de partie fermée et bornée non compacte.
>   * **Rép :** Dans $C([0,1])$, la boule unité fermée. La suite $f_n(x) = x^n$ n'a pas de sous-suite convergente pour $\|\cdot\|_\infty$.

### 5. Références Bibliographiques
* **J. Dixmier**, *Topologie générale* — Référence pour la topologie.
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
