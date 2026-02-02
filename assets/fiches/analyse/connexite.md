# Connexité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La [connexité](def:connexe) exprime le fait qu'un espace est "d'un seul tenant".
> * **Connexe :** $E$ ne peut pas s'écrire comme union de deux ouverts non vides disjoints.
> * **Équivalent :** Les seules parties à la fois ouvertes et fermées sont $\emptyset$ et $E$.
> * **[Connexe par arcs](def:connexe par arcs) :** Deux points quelconques peuvent être reliés par un chemin continu.
> * **Implication :** Connexe par arcs $\Rightarrow$ connexe (réciproque fausse en général).
> * **Image continue :** L'image d'un connexe par une fonction continue est connexe.
> * **Connexes de $\mathbb{R}$ :** Les intervalles et uniquement les intervalles.
> * **Composantes connexes :** Classes d'équivalence pour "être reliés par un connexe".

> [!WARNING]
> ### 2. Pièges à éviter
> * **Connexe ≠ connexe par arcs :** Le "peigne" topologique est connexe mais pas connexe par arcs.
> * **Union de connexes :** L'union de deux connexes n'est connexe que si leur intersection est non vide.
> * **Fermé dans un connexe :** Un fermé propre non vide d'un connexe n'est pas ouvert.
> * **Produit :** Le produit de connexes est connexe.
> * **Ouvert de $\mathbb{R}^n$ ($n \geq 1$) :** Connexe $\Leftrightarrow$ connexe par arcs.

> [!TIP]
> ### 3. Exercice Type : $GL_n(\mathbb{R})$ non connexe
> **Énoncé :** Montrer que $GL_n(\mathbb{R})$ n'est pas connexe.
>
> **Solution Détaillée :**
> 1. **Application déterminant :** $\det : GL_n(\mathbb{R}) \to \mathbb{R}^*$ est continue.
> 2. **Image :** $\det(GL_n(\mathbb{R})) = \mathbb{R}^* = ]-\infty, 0[ \cup ]0, +\infty[$.
> 3. **$\mathbb{R}^*$ non connexe :** C'est l'union de deux ouverts non vides disjoints.
> 4. Si $GL_n(\mathbb{R})$ était connexe, son image par $\det$ serait connexe. Contradiction.
> 5. **Conclusion :** $GL_n(\mathbb{R})$ a (au moins) deux composantes connexes : $GL_n^+$ et $GL_n^-$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Montrer que $\mathbb{R}^n \setminus \{0\}$ est connexe pour $n \geq 2$.
>   * **Rép :** Connexe par arcs : on relie $x$ à $y$ en contournant l'origine si nécessaire.
> * **Q2 :** $\mathbb{Q}$ est-il connexe dans $\mathbb{R}$ ?
>   * **Rép :** Non. $\mathbb{Q} = (\mathbb{Q} \cap ]-\infty, \sqrt{2}[) \cup (\mathbb{Q} \cap ]\sqrt{2}, +\infty[)$.
> * **Q3 :** Qu'est-ce qu'un espace simplement connexe ?
>   * **Rép :** Connexe par arcs et tout lacet peut être contracté en un point (pas de "trou"). Ex : $\mathbb{R}^2$ mais pas $\mathbb{R}^2 \setminus \{0\}$.

### 5. Références Bibliographiques
* **J. Dixmier**, *Topologie générale*.
* **W. Rudin**, *Principles of Mathematical Analysis*.
