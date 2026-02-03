# Groupes et Structures

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **[groupe](def:groupe)** $(G, \cdot)$ est un ensemble muni d'une loi interne associative, avec élément neutre et symétriques.
> * **Groupe abélien :** Groupe dont la loi est commutative.
> * **[Sous-groupe](def:sous-groupe) :** $H \subset G$ est un sous-groupe si $H \neq \emptyset$ et $\forall a, b \in H, ab^{-1} \in H$.
> * **Ordre d'un élément :** Plus petit $n \geq 1$ tel que $g^n = e$. Si n'existe pas, ordre infini.
> * **Théorème de Lagrange :** Si $H$ est un sous-groupe de $G$ fini, alors $|H|$ divise $|G|$.
> * **[Sous-groupe distingué](def:distingue) :** $H \triangleleft G$ si $\forall g \in G, gHg^{-1} = H$. Permet de former $G/H$.
> * **Morphisme de groupes :** $\varphi : G \to G'$ tel que $\varphi(ab) = \varphi(a)\varphi(b)$.
> * **Premier théorème d'isomorphisme :** $G/\ker(\varphi) \simeq \text{Im}(\varphi)$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Sous-groupe vs partie stable :** Une partie stable n'est pas forcément un sous-groupe (il faut les inverses).
> * **Distingué :** Dans un groupe non abélien, tous les sous-groupes ne sont pas distingués !
> * **Ordre et divisibilité :** L'ordre d'un élément divise l'ordre du groupe, mais la réciproque est fausse — pas toujours d'élément d'ordre $d$ si $d | |G|}$.
> * **Quotient :** $G/H$ n'est un groupe que si $H$ est **distingué**.
> * **Isomorphisme :** Deux groupes de même cardinal ne sont pas forcément isomorphes — ex: $\mathbb{Z}/4\mathbb{Z} \not\simeq \mathbb{Z}/2\mathbb{Z} \times \mathbb{Z}/2\mathbb{Z}$.

> [!TIP]
> ### 3. Exercice Type : Sous-groupes de $\mathbb{Z}$
> **Énoncé :** Montrer que tout sous-groupe de $(\mathbb{Z}, +)$ est de la forme $n\mathbb{Z}$ pour un certain $n \in \mathbb{N}$.
>
> **Solution Détaillée :**
> 1. Si $H = \{0\}$, alors $H = 0\mathbb{Z}$.
> 2. Si $H \neq \{0\}$, alors $H$ contient des éléments non nuls. Comme $H$ est stable par opposé, $H \cap \mathbb{N}^* \neq \emptyset$.
> 3. Soit $n = \min(H \cap \mathbb{N}^*)$. Montrons $H = n\mathbb{Z}$.
>    - $n\mathbb{Z} \subset H$ : car $n \in H$ et $H$ est un sous-groupe.
>    - $H \subset n\mathbb{Z}$ : soit $h \in H$. Division euclidienne : $h = nq + r$ avec $0 \leq r < n$.
>      Alors $r = h - nq \in H$. Par minimalité de $n$, on a $r = 0$, donc $h \in n\mathbb{Z}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de Lagrange.
>   * **Rép :** Si $H$ est un sous-groupe d'un groupe fini $G$, alors $|H|$ divise $|G|$. De plus, $|G| = |H| \cdot [G:H]$.
> * **Q2 :** Qu'est-ce que le centre d'un groupe ?
>   * **Rép :** $Z(G) = \{g \in G : \forall h \in G, gh = hg\}$. C'est un sous-groupe distingué de $G$.
> * **Q3 :** Donner un exemple de groupe non abélien.
>   * **Rép :** Le groupe symétrique $\mathfrak{S}_3$ (permutations de 3 éléments), ou $GL_2(\mathbb{R})$.

### 5. Références Bibliographiques
* **D. Perrin**, *Algèbre* — Excellent pour les structures (groupes, anneaux, corps).
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet.
