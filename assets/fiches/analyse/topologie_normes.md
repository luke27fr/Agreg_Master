# Topologie des Espaces Normés

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un espace normé est un [espace vectoriel](def:espace vectoriel) muni d'une [norme](def:norme).
> * **Norme :** $\|x\| \geq 0$, $\|x\| = 0 \Leftrightarrow x = 0$, $\|\lambda x\| = |\lambda| \|x\|$, $\|x + y\| \leq \|x\| + \|y\|$.
> * **Boule ouverte :** $B(a, r) = \{x : \|x - a\| < r\}$. Boule fermée : $\bar{B}(a, r) = \{x : \|x - a\| \leq r\}$.
> * **[Ouvert](def:ouvert) :** Partie $O$ telle que $\forall x \in O, \exists r > 0, B(x, r) \subset O$.
> * **[Fermé](def:ferme) :** Complémentaire d'un ouvert. Contient ses limites.
> * **Équivalence de normes :** $N_1 \sim N_2$ si $\exists c, C > 0, cN_1 \leq N_2 \leq CN_1$.
> * **Dimension finie :** En dimension finie, toutes les normes sont équivalentes.
> * **Suite convergente :** $x_n \to x$ si $\|x_n - x\| \to 0$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Boule ouverte ≠ intérieur de la boule fermée :** Vrai en général, mais pas en dimension infinie parfois.
> * **Équivalence :** En dimension infinie, les normes ne sont pas toutes équivalentes !
> * **Fermé borné ≠ compact :** En dimension infinie, fermé + borné n'implique pas compact.
> * **Norme vs semi-norme :** Une semi-norme peut être nulle sur des vecteurs non nuls.
> * **Convergence :** Dépend de la norme choisie (mais pas en dimension finie).

> [!TIP]
> ### 3. Exercice Type : Équivalence des normes en dim finie
> **Énoncé :** Dans $\mathbb{R}^n$, montrer que $\|x\|_1 \leq \sqrt{n} \|x\|_2$.
>
> **Solution Détaillée :**
> 1. $\|x\|_1 = \sum_{i=1}^{n} |x_i|$ et $\|x\|_2 = \sqrt{\sum |x_i|^2}$.
> 2. Par Cauchy-Schwarz dans $\mathbb{R}^n$ :
>    $$\sum_{i=1}^{n} |x_i| \cdot 1 \leq \sqrt{\sum |x_i|^2} \cdot \sqrt{\sum 1^2} = \|x\|_2 \sqrt{n}$$
> 3. **Conclusion :** $\|x\|_1 \leq \sqrt{n} \|x\|_2$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Pourquoi toutes les normes sont-elles équivalentes en dimension finie ?
>   * **Rép :** La sphère unité pour $\|\cdot\|_2$ est compacte. Toute norme $N$ y est continue, donc atteint son min et max.
> * **Q2 :** Donner un exemple de deux normes non équivalentes.
>   * **Rép :** Sur $C([0,1])$ : $\|f\|_\infty = \sup |f|$ et $\|f\|_1 = \int |f|$. Pas équivalentes (suite de pics).
> * **Q3 :** Qu'est-ce qu'un espace de [Banach](def:banach) ?
>   * **Rép :** Espace normé [complet](def:complet) (toute suite de Cauchy converge).

### 5. Références Bibliographiques
* **H. Brézis**, *Analyse fonctionnelle*.
* **W. Rudin**, *Functional Analysis*.
