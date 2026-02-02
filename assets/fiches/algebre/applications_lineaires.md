# Applications Linéaires

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une **[application linéaire](def:application lineaire)** $f : E \to F$ entre deux [espaces vectoriels](def:espace vectoriel) vérifie : $f(\lambda u + \mu v) = \lambda f(u) + \mu f(v)$.
> * **[Noyau](def:noyau) :** $\ker(f) = \{x \in E : f(x) = 0\}$. C'est un sous-espace de $E$.
> * **Image :** $\text{Im}(f) = \{f(x) : x \in E\}$. C'est un sous-espace de $F$.
> * **[Rang](def:rang) :** $\text{rg}(f) = \dim(\text{Im}(f))$.
> * **Théorème du rang :** $\dim(E) = \dim(\ker(f)) + \text{rg}(f)$.
> * **Injectivité :** $f$ injective $\Leftrightarrow \ker(f) = \{0\}$.
> * **Surjectivité :** $f$ surjective $\Leftrightarrow \text{Im}(f) = F$.
> * **Isomorphisme :** Application linéaire bijective. Si $\dim(E) = \dim(F) < \infty$, alors injectif $\Leftrightarrow$ surjectif $\Leftrightarrow$ bijectif.
> * **Endomorphisme :** Application linéaire de $E$ dans lui-même. L'ensemble $\mathcal{L}(E)$ est un [anneau](def:anneau).

> [!WARNING]
> ### 2. Pièges à éviter
> * **Théorème du rang en dim infinie :** Ne s'applique qu'en dimension **finie** ! La dérivation sur $\mathbb{R}[X]$ a un noyau de dimension 1 et est surjective.
> * **Injective + surjective :** En dimension infinie, on peut être injectif sans être surjectif (décalage sur $\ell^2$).
> * **Composition :** $\ker(g \circ f) \supset \ker(f)$ et $\text{Im}(g \circ f) \subset \text{Im}(g)$. Attention au sens des inclusions !
> * **Matrice et base :** La matrice d'une application linéaire dépend des bases choisies **à la source ET au but**.
> * **Rang ligne = rang colonne :** Mais les espaces engendrés sont différents ($\text{Im}(f)$ vs $\text{Im}({}^t\!f)$).

> [!TIP]
> ### 3. Exercice Type : Projecteur
> **Énoncé :** Soit $p \in \mathcal{L}(E)$ tel que $p^2 = p$. Montrer que $E = \ker(p) \oplus \text{Im}(p)$.
>
> **Solution Détaillée :**
> 1. **Somme :** Soit $x \in E$. On écrit $x = (x - p(x)) + p(x)$.
>    - $p(x) \in \text{Im}(p)$ par définition.
>    - $p(x - p(x)) = p(x) - p^2(x) = p(x) - p(x) = 0$, donc $x - p(x) \in \ker(p)$.
> 2. **Directe :** Soit $y \in \ker(p) \cap \text{Im}(p)$. Alors $y = p(z)$ pour un certain $z$, et $p(y) = 0$.
>    Donc $0 = p(y) = p(p(z)) = p^2(z) = p(z) = y$.
> 3. **Conclusion :** $E = \ker(p) \oplus \text{Im}(p)$, et $p$ est la [projection](def:projection) sur $\text{Im}(p)$ parallèlement à $\ker(p)$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner une CNS pour qu'une application linéaire soit un isomorphisme.
>   * **Rép :** En dimension finie égale : $\det(f) \neq 0$, ou $\ker(f) = \{0\}$, ou $\text{rg}(f) = \dim(E)$.
> * **Q2 :** Que peut-on dire de $\dim(\ker(f \circ g))$ ?
>   * **Rép :** $\dim(\ker(g)) \leq \dim(\ker(f \circ g)) \leq \dim(\ker(g)) + \dim(\ker(f))$ (en dim finie).
> * **Q3 :** Comment se transforme la matrice d'une application linéaire par changement de base ?
>   * **Rép :** $M' = Q^{-1} M P$ où $P$ est la matrice de passage à la source et $Q$ au but. Pour un endomorphisme : $M' = P^{-1} M P$.
> * **Q4 :** Qu'est-ce que le dual d'un espace vectoriel ?
>   * **Rép :** $E^* = \mathcal{L}(E, \mathbb{K})$ est l'espace des formes linéaires. En dimension finie, $\dim(E^*) = \dim(E)$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Algèbre* (Chapitre Applications linéaires).
* **R. Music**, *Algèbre MPSI-MP* (Exercices sur le rang).
