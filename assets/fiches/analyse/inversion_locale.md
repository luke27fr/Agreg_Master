# Théorème de l'Inversion Locale

> [!NOTE]
> ### 1. Énoncé du Théorème
> Soit $f : U \subset E \to F$ une application de classe $\mathcal{C}^1$, où $E$ et $F$ sont des [Banach](def:banach). Soit $a \in U$.
> **Condition :** La différentielle $df_a$ est un [isomorphisme bicontinu](def:isomorphisme).
> **Conclusion :** Il existe un voisinage ouvert $V$ de $a$ et un voisinage ouvert $W$ de $f(a)$ tels que :
> * **Bijectivité :** L'application $f$ est un [difféomorphisme](def:diffeomorphisme) de classe $\mathcal{C}^1$ de $V$ sur $W$.
> * **Formule :** Pour tout $y \in W$, en posant $x = f^{-1}(y)$, on a :
> $$d(f^{-1})_y = (df_x)^{-1}$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Caractère Local :** Le théorème garantit l'injectivité **au voisinage** de $a$, et non sur $U$ entier.
> * **Contre-exemple :** L'exponentielle complexe $z \mapsto e^z$ est localement injective partout, mais n'est pas injective sur $\mathbb{C}$ car elle est de période $2i\pi$.
> * **Dimension finie :** $df_a$ est un isomorphisme si et seulement si le déterminant de la [Jacobienne](def:jacobienne) $J_f(a)$ est non nul.

> [!TIP]
> ### 3. Exercice : Coordonnées Polaires
> **Énoncé :** Soit $f(r, \theta) = (r \cos \theta, r \sin \theta)$ définie sur $U = ]0, +\infty[ \times \mathbb{R}$. Montrer que $f$ est un difféomorphisme local en tout point. Est-ce global ?
>
> #### Solution Détaillée :
> **1. Calcul de la Jacobienne :**
> L'application est $\mathcal{C}^\infty$. On calcule la matrice Jacobienne en tout point $(r, \theta)$ :
> $$J_f(r, \theta) = \begin{pmatrix} \cos \theta & -r \sin \theta \\ \sin \theta & r \cos \theta \end{pmatrix}$$
>
> **2. Inversibilité locale :**
> On calcule le déterminant : $\det(J_f) = r (\cos^2 \theta + \sin^2 \theta) = r$.
> Comme $r > 0$ sur $U$, le déterminant est toujours non nul. D'après le TIL, $f$ est un difféomorphisme local en tout point.
>
> **3. Globalité :**
> $f$ n'est pas un difféomorphisme global de $U$ sur son image $\mathbb{R}^2 \setminus \{0\}$ car elle n'est pas injective : $f(r, \theta) = f(r, \theta + 2\pi)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Ce théorème est-il vrai si les espaces ne sont pas complets ?
>   * **Rép :** Non. Il existe des contre-exemples classiques dans les espaces de polynômes (théorème de Nash-Moser pour les cas "pathologiques").
> * **Q2 :** Comment passer du local au global ?
>   * **Rép :** Il faut des conditions topologiques supplémentaires. Par exemple, si $f$ est propre et $F$ est connexe (Théorème d'Hadamard-Lévy).
> * **Q3 :** Que faire si $df_a$ n'est pas inversible ?
>   * **Rép :** On est au voisinage d'un point critique. Il faut étudier les rangs (Théorème du rang constant) ou utiliser des développements limités d'ordre supérieur (Théorie des singularités).

### 5. Références Bibliographiques
* **F. Rouvière**, *Petit guide de calcul différentiel* — Très pédagogique sur le calcul différentiel.
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.