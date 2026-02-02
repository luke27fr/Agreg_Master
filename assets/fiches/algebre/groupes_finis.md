# Groupes Finis

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un [groupe](def:groupe) fini est un groupe de cardinal fini. L'étude des groupes finis utilise le théorème de Lagrange et ses conséquences.
> * **Groupe cyclique :** Groupe engendré par un seul élément : $G = \langle g \rangle = \{g^k : k \in \mathbb{Z}\}$.
> * **Théorème de Lagrange :** $|H|$ divise $|G|$ pour tout [sous-groupe](def:sous-groupe) $H$.
> * **Petit théorème de Fermat :** Si $p$ est premier et $a \not\equiv 0 \pmod{p}$, alors $a^{p-1} \equiv 1 \pmod{p}$.
> * **Théorème d'Euler :** $a^{\varphi(n)} \equiv 1 \pmod{n}$ si $\gcd(a, n) = 1$.
> * **Groupe symétrique :** $\mathfrak{S}_n$ est le groupe des permutations de $\{1, \ldots, n\}$, de cardinal $n!$.
> * **Signature :** Morphisme $\varepsilon : \mathfrak{S}_n \to \{-1, +1\}$. Le noyau est le groupe alterné $\mathfrak{A}_n$.
> * **Théorèmes de Sylow :** Existence et propriétés des $p$-sous-groupes de Sylow.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Réciproque de Lagrange :** Fausse ! $\mathfrak{A}_4$ (ordre 12) n'a pas de sous-groupe d'ordre 6.
> * **Cyclique ≠ abélien :** Tout groupe cyclique est abélien, mais la réciproque est fausse ($\mathbb{Z}/2\mathbb{Z} \times \mathbb{Z}/2\mathbb{Z}$ n'est pas cyclique).
> * **Signature :** C'est un **morphisme**, donc $\varepsilon(\sigma\tau) = \varepsilon(\sigma)\varepsilon(\tau)$.
> * **Transposition :** Une transposition est toujours de signature $-1$.
> * **Décomposition en cycles :** Les cycles à supports disjoints **commutent**.

> [!TIP]
> ### 3. Exercice Type : Groupes d'ordre $p$ premier
> **Énoncé :** Montrer que tout groupe d'ordre $p$ premier est cyclique.
>
> **Solution Détaillée :**
> 1. Soit $G$ un groupe d'ordre $p$ et $g \in G \setminus \{e\}$.
> 2. Soit $H = \langle g \rangle$ le sous-groupe engendré par $g$.
> 3. Par Lagrange, $|H|$ divise $|G| = p$.
> 4. Comme $g \neq e$, on a $|H| \geq 2$. Les seuls diviseurs de $p$ sont $1$ et $p$.
> 5. Donc $|H| = p = |G|$, ce qui implique $H = G$.
> 6. Conclusion : $G = \langle g \rangle$ est cyclique.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Combien y a-t-il de groupes d'ordre 4 à isomorphisme près ?
>   * **Rép :** Deux : $\mathbb{Z}/4\mathbb{Z}$ (cyclique) et $\mathbb{Z}/2\mathbb{Z} \times \mathbb{Z}/2\mathbb{Z}$ (groupe de Klein).
> * **Q2 :** $\mathfrak{A}_n$ est-il un sous-groupe distingué de $\mathfrak{S}_n$ ?
>   * **Rép :** Oui, c'est le noyau de la signature, qui est un morphisme.
> * **Q3 :** Énoncer un théorème de Sylow.
>   * **Rép :** Si $p^k$ divise $|G|$ avec $p$ premier, alors $G$ possède un sous-groupe d'ordre $p^k$ (existence).

### 5. Références Bibliographiques
* **D. Perrin**, *Cours d'algèbre* (Groupes finis).
* **J.-P. Serre**, *Cours d'arithmétique* (Groupes).
