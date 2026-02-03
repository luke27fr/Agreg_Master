# Espaces Vectoriels

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Un **[espace vectoriel](def:espace vectoriel)** sur un [corps](def:corps) $\mathbb{K}$ est un ensemble $E$ muni d'une addition interne et d'une multiplication externe par des scalaires, vérifiant 8 axiomes.
> * **Sous-espace vectoriel :** Partie non vide stable par combinaison linéaire. C'est automatiquement un espace vectoriel.
> * **[Famille libre](def:famille libre) :** $(v_1, \ldots, v_n)$ est libre si $\sum \lambda_i v_i = 0 \Rightarrow \forall i, \lambda_i = 0$.
> * **[Famille génératrice](def:famille generatrice) :** $(v_1, \ldots, v_n)$ engendre $E$ si tout vecteur de $E$ est combinaison linéaire des $v_i$.
> * **[Base](def:base) :** Famille à la fois libre et génératrice. Toute base a le même cardinal : la **[dimension](def:dimension)**.
> * **Théorème de la base incomplète :** Toute famille libre peut être complétée en une base.
> * **Formule de Grassmann :** $\dim(E + F) = \dim(E) + \dim(F) - \dim(E \cap F)$.
> * **Somme directe :** $E \oplus F$ signifie $E + F = E \oplus F$ et $E \cap F = \{0\}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Libre ≠ générateur :** $(e_1)$ est libre mais pas génératrice de $\mathbb{R}^2$. $(\vec{0})$ est génératrice de $\{0\}$ mais pas libre !
> * **Dimension infinie :** $\mathbb{R}[X]$ est de dimension infinie (attention aux raisonnements finis).
> * **Somme vs somme directe :** $E + F$ n'est pas toujours directe ! Vérifier $E \cap F = \{0\}$.
> * **Vecteur nul :** Le vecteur $\vec{0}$ n'est **jamais** dans une famille libre.
> * **Base et coordonnées :** Les coordonnées dépendent de la base choisie et de **l'ordre** des vecteurs.

> [!TIP]
> ### 3. Exercice Type : Supplémentaire
> **Énoncé :** Soit $F = \{(x, y, z) \in \mathbb{R}^3 : x + y + z = 0\}$. Trouver un supplémentaire de $F$ dans $\mathbb{R}^3$.
>
> **Solution Détaillée :**
> 1. **Dimension de $F$ :** $F = \ker(\varphi)$ où $\varphi(x,y,z) = x+y+z$. Par le théorème du [rang](def:rang) : $\dim(F) = 3 - 1 = 2$.
> 2. **Base de $F$ :** On cherche les solutions de $x + y + z = 0$. En posant $y, z$ libres : $F = \text{Vect}((-1,1,0), (-1,0,1))$.
> 3. **Supplémentaire :** Il suffit de trouver un vecteur $v \notin F$. Prenons $v = (1,1,1)$ : $1+1+1 = 3 \neq 0$.
>    Donc $G = \text{Vect}((1,1,1))$ est un supplémentaire de $F$ : $\mathbb{R}^3 = F \oplus G$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Qu'est-ce qu'un hyperplan ? Comment le caractériser ?
>   * **Rép :** Sous-espace de codimension 1, c'est-à-dire [noyau](def:noyau) d'une forme linéaire non nulle. $H = \ker(f)$ avec $f \in E^* \setminus \{0\}$.
> * **Q2 :** Toute famille libre est-elle finie en dimension finie ?
>   * **Rép :** Oui ! Si $\dim(E) = n$, toute famille libre a au plus $n$ éléments. Sinon on contredirait la dimension.
> * **Q3 :** Peut-on avoir $E \oplus F = E \oplus G$ avec $F \neq G$ ?
>   * **Rép :** Oui ! Dans $\mathbb{R}^2$, la droite $D_x$ a pour supplémentaires toutes les droites non horizontales.
> * **Q4 :** Énoncer le théorème de la base adaptée à une somme directe.
>   * **Rép :** Si $E = F_1 \oplus \cdots \oplus F_k$, en juxtaposant des bases de chaque $F_i$, on obtient une base de $E$.

### 5. Références Bibliographiques
* **R. Music**, *Algèbre linéaire* — Très bon pour les espaces vectoriels et les bases.
* **X. Gourdon**, *Algèbre* — La référence pour l'agrégation, très complet.
