# Espaces Affines

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> **Espace affine.** Un ensemble $\mathcal{E}$ est un espace affine de direction $\vec{E}$ (espace vectoriel sur $K$) si on dispose d'une application $\mathcal{E} \times \mathcal{E} \to \vec{E}$, $(A,B) \mapsto \vec{AB}$, vérifiant :
> * **Relation de Chasles :** Pour tous $A, B, C \in \mathcal{E}$, $\vec{AB} + \vec{BC} = \vec{AC}$.
> * **Action libre et transitive :** Pour tout $A \in \mathcal{E}$ et tout $\vec{v} \in \vec{E}$, il existe un unique $B \in \mathcal{E}$ tel que $\vec{AB} = \vec{v}$. On note $B = A + \vec{v}$.
>
> La **dimension** de $\mathcal{E}$ est par définition $\dim \vec{E}$.
>
> **Sous-espace affine.** Un sous-ensemble $F \subset \mathcal{E}$ est un sous-espace affine s'il s'écrit $F = A + \vec{F}$ où $A \in F$ et $\vec{F}$ est un sous-espace vectoriel de $\vec{E}$ (la **direction** de $F$). On a $\dim F = \dim \vec{F}$.
> * Dimension 0 : **point** ; dimension 1 : **droite affine** ; dimension $n-1$ : **hyperplan affine**.
> * Un hyperplan affine est de la forme $\{M \in \mathcal{E} : f(\vec{AM}) = \alpha\}$ où $f$ est une forme linéaire non nulle.
>
> **Caractérisation par les barycentres.** $F \subset \mathcal{E}$ est un sous-espace affine si et seulement si $F$ est stable par barycentres : pour tous $A, B \in F$ et $\lambda \in K$, on a $\lambda A + (1-\lambda) B \in F$.
>
> **Indépendance affine.** Des points $(A_0, A_1, \ldots, A_k)$ sont **affinement indépendants** si $(\vec{A_0 A_1}, \ldots, \vec{A_0 A_k})$ est une famille libre de $\vec{E}$.
>
> **Repère affine.** Un repère affine de $\mathcal{E}$ (de dimension $n$) est la donnée de $(n+1)$ points affinement indépendants $(A_0, A_1, \ldots, A_n)$. Tout point $M$ s'écrit de manière unique $M = \lambda_0 A_0 + \lambda_1 A_1 + \cdots + \lambda_n A_n$ avec $\sum \lambda_i = 1$ (**coordonnées barycentriques**).

> [!NOTE]
> ### 2. Barycentres et Combinaisons Affines
> **Barycentre.** Soient $(A_1, \alpha_1), \ldots, (A_k, \alpha_k)$ des points pondérés avec $\sum \alpha_i \neq 0$. Le **barycentre** est l'unique point $G$ tel que :
> $$\sum_{i=1}^{k} \alpha_i \vec{GA_i} = \vec{0}$$
> soit encore, pour tout point $O$ :
> $$\vec{OG} = \frac{\sum \alpha_i \vec{OA_i}}{\sum \alpha_i}$$
>
> **Propriétés fondamentales :**
> * **Indépendance de l'origine** : la formule ne dépend pas du choix de $O$ (grâce à $\sum \alpha_i \neq 0$).
> * **Associativité** : on peut calculer un barycentre par regroupements successifs. Par exemple, le barycentre de $(A, 1), (B, 2), (C, 3)$ est le barycentre de $(G_{AB}, 3), (C, 3)$ où $G_{AB}$ est le barycentre de $(A, 1), (B, 2)$.
> * **Combinaison affine** : $\sum \lambda_i A_i$ avec $\sum \lambda_i = 1$ (les poids sont normalisés).
>
> **Sous-espace affine engendré.** Le sous-espace affine engendré par $(A_0, \ldots, A_k)$ est l'ensemble des barycentres de ces points, soit :
> $$\text{Aff}(A_0, \ldots, A_k) = A_0 + \text{Vect}(\vec{A_0 A_1}, \ldots, \vec{A_0 A_k})$$
>
> **Enveloppe convexe.** L'enveloppe convexe de $(A_0, \ldots, A_k)$ est l'ensemble des barycentres à coefficients **positifs** : $\{\sum \lambda_i A_i : \lambda_i \geq 0, \sum \lambda_i = 1\}$.

> [!NOTE]
> ### 3. Parallélisme et Intersection
> **Parallélisme.** Deux sous-espaces affines $F_1 = A_1 + \vec{F_1}$ et $F_2 = A_2 + \vec{F_2}$ sont **parallèles** si $\vec{F_1} \subset \vec{F_2}$ ou $\vec{F_2} \subset \vec{F_1}$.
> * Si $\vec{F_1} = \vec{F_2}$ (même direction), alors $F_1 \cap F_2 = \varnothing$ ou $F_1 = F_2$.
> * Deux droites de $\mathbb{R}^3$ peuvent être non coplanaires (ni sécantes, ni parallèles).
>
> **Intersection.** $(A_1 + \vec{F_1}) \cap (A_2 + \vec{F_2}) \neq \varnothing$ si et seulement si $\vec{A_1 A_2} \in \vec{F_1} + \vec{F_2}$.
>
> **Formule de dimension.** Si $F_1 \cap F_2 \neq \varnothing$ :
> $$\dim(F_1 \cap F_2) = \dim \vec{F_1} + \dim \vec{F_2} - \dim(\vec{F_1} + \vec{F_2})$$
>
> **Positions relatives dans $\mathbb{R}^3$.** Deux droites $D_1, D_2$ :
> * **Sécantes** : $D_1 \cap D_2 = \{P\}$ (un point), $\vec{D_1} \neq \vec{D_2}$
> * **Parallèles distinctes** : $D_1 \cap D_2 = \varnothing$, $\vec{D_1} = \vec{D_2}$
> * **Confondues** : $D_1 = D_2$
> * **Non coplanaires** : $D_1 \cap D_2 = \varnothing$, $\vec{D_1} \neq \vec{D_2}$, $\vec{A_1 A_2} \notin \vec{D_1} + \vec{D_2}$

> [!NOTE]
> ### 4. Applications Affines
> **Définition.** $f : \mathcal{E} \to \mathcal{F}$ est **affine** si la fonction $\vec{f} : \vec{E} \to \vec{F}$ définie par $\vec{f}(\vec{AB}) = \vec{f(A)f(B)}$ est **linéaire**. On appelle $\vec{f}$ la **partie linéaire** de $f$.
>
> **Caractérisations équivalentes :**
> * $f$ conserve les barycentres : $f(\sum \lambda_i A_i) = \sum \lambda_i f(A_i)$ pour $\sum \lambda_i = 1$.
> * Il existe un point $A$ tel que $\vec{v} \mapsto f(A + \vec{v}) - f(A)$ est linéaire.
> * En coordonnées : $f(X) = LX + \vec{b}$ où $L$ est une matrice (partie linéaire) et $\vec{b}$ un vecteur (translation).
>
> **Propriétés :**
> * La composée de deux applications affines est affine. Partie linéaire : $\vec{g \circ f} = \vec{g} \circ \vec{f}$.
> * $f$ est bijective si et seulement si $\vec{f}$ est un isomorphisme.
> * $f$ est entièrement déterminée par les images d'un **repère affine** : si $(A_0, \ldots, A_n)$ est un repère et on se donne $(B_0, \ldots, B_n)$, il existe une unique application affine $f$ telle que $f(A_i) = B_i$.
>
> **Groupe affine.** $\text{GA}(\mathcal{E}) = \{f : \mathcal{E} \to \mathcal{E}, f \text{ bijection affine}\}$.
> * Structure : $\text{GA}(\mathcal{E}) \simeq \text{GL}(\vec{E}) \ltimes \vec{E}$ (produit semi-direct).
> * **Translations** : $t_{\vec{v}}(M) = M + \vec{v}$, partie linéaire $= \text{Id}$. Les translations forment un sous-groupe distingué isomorphe à $(\vec{E}, +)$.
> * **Homothéties** : $h_{\Omega, k}(M) = \Omega + k \cdot \vec{\Omega M}$, partie linéaire $= k \cdot \text{Id}$. Point fixe $\Omega$ si $k \neq 1$.

> [!NOTE]
> ### 5. Théorèmes Classiques
> **Théorème de Thalès.** Soient $D_1 \parallel D_2$ deux droites parallèles, et $\Delta, \Delta'$ deux sécantes les coupant en $A, B$ et $A', B'$ respectivement. Si $O = \Delta \cap \Delta'$, alors :
> $$\frac{OA}{OB} = \frac{OA'}{OB'}$$
> *Interprétation affine :* Une projection sur une droite parallèlement à une direction conserve les rapports.
>
> **Théorème de Ménélaüs.** Soit $ABC$ un triangle et $M, N, P$ des points sur les droites $(BC), (CA), (AB)$ respectivement. Alors $M, N, P$ sont alignés si et seulement si :
> $$\frac{\overline{BM}}{\overline{MC}} \cdot \frac{\overline{CN}}{\overline{NA}} \cdot \frac{\overline{AP}}{\overline{PB}} = -1$$
>
> **Théorème de Céva.** Avec les mêmes notations, les droites $(AM), (BN), (CP)$ sont concourantes si et seulement si :
> $$\frac{\overline{BM}}{\overline{MC}} \cdot \frac{\overline{CN}}{\overline{NA}} \cdot \frac{\overline{AP}}{\overline{PB}} = +1$$
>
> *Application :* Les médianes d'un triangle sont concourantes (centre de gravité $G = \frac{A+B+C}{3}$).

> [!NOTE]
> ### 6. Application : Systèmes Linéaires
> L'ensemble des solutions d'un système linéaire $AX = b$ est :
> * **Vide** si $b \notin \text{Im}(A)$ (système incompatible).
> * Un **sous-espace affine** $x_0 + \ker A$ si $x_0$ est une solution particulière.
>
> C'est l'interprétation géométrique fondamentale : résoudre $AX = b$ revient à trouver un sous-espace affine de direction $\ker A$.
>
> **Exemple.** Le système $\begin{cases} x + y + z = 1 \\ 2x - y + z = 0 \end{cases}$ a pour ensemble de solutions la droite affine $\{(\frac{1}{3}, \frac{2}{3}, 0) + t(-\frac{2}{3}, \frac{1}{3}, 1) : t \in \mathbb{R}\}$.

> [!WARNING]
> ### 7. Pièges à Éviter
> * **Espace affine ≠ espace vectoriel :** Un espace affine n'a pas d'origine. Un sous-espace affine ne contient pas nécessairement $0$. Un sous-espace vectoriel EST un sous-espace affine (passant par l'origine), mais la réciproque est fausse.
> * **Intersection vide :** Contrairement aux sous-espaces vectoriels (qui contiennent toujours $\{0\}$), deux sous-espaces affines peuvent avoir une intersection vide (droites parallèles distinctes).
> * **Combinaison affine ≠ combinaison linéaire :** Dans $\sum \lambda_i A_i$, la contrainte $\sum \lambda_i = 1$ est essentielle pour que le résultat soit indépendant de l'origine. Sans cette contrainte, l'expression n'a pas de sens dans un espace affine.
> * **Parallélisme strict :** $F_1 \parallel F_2$ au sens strict signifie $\vec{F_1} = \vec{F_2}$ et $F_1 \neq F_2$. Attention à la définition "au sens large" ($\vec{F_1} \subset \vec{F_2}$) qui inclut les sous-espaces inclus.
> * **Barycentre et somme des poids :** Si $\sum \alpha_i = 0$, le barycentre n'existe pas. On obtient alors un vecteur (pas un point).
> * **Applications affines et points fixes :** Toute application affine n'a pas nécessairement de point fixe (ex : une translation non nulle). Point fixe $\Leftrightarrow$ $1$ est valeur propre de la partie linéaire.
> * **Repère affine ≠ repère vectoriel :** Un repère affine de $\mathcal{E}$ a $n+1$ points (un de plus que la dimension), tandis qu'une base de $\vec{E}$ a $n$ vecteurs.

> [!TIP]
> ### 8. Exercice Type : Intersection de Sous-Espaces Affines
> **Énoncé :** Dans $\mathbb{R}^3$, on considère les deux droites :
> * $D_1 = \{(1, 0, 2) + t(1, 1, 0) : t \in \mathbb{R}\}$
> * $D_2 = \{(0, 1, 1) + s(2, 1, 1) : s \in \mathbb{R}\}$
>
> Déterminer si $D_1$ et $D_2$ sont sécantes, parallèles ou non coplanaires.
>
> **Solution Détaillée :**
> 1. **Directions :** $\vec{D_1} = \text{Vect}(1,1,0)$ et $\vec{D_2} = \text{Vect}(2,1,1)$. Ces vecteurs ne sont pas colinéaires, donc $D_1$ et $D_2$ ne sont **pas parallèles**.
> 2. **Condition d'intersection :** On vérifie si $\vec{A_1 A_2} = (0,1,1) - (1,0,2) = (-1, 1, -1)$ appartient à $\vec{D_1} + \vec{D_2} = \text{Vect}((1,1,0), (2,1,1))$.
> 3. **Test :** On cherche $\alpha, \beta$ tels que $\alpha(1,1,0) + \beta(2,1,1) = (-1, 1, -1)$.
>    * $\alpha + 2\beta = -1$
>    * $\alpha + \beta = 1$
>    * $\beta = -1$
>    D'où $\beta = -1$, $\alpha = 2$. Vérifions : $2(1,1,0) + (-1)(2,1,1) = (0, 1, -1) \neq (-1, 1, -1)$.
> 4. **Conclusion :** $\vec{A_1 A_2} \notin \vec{D_1} + \vec{D_2}$. Les droites $D_1$ et $D_2$ sont **non coplanaires** (elles ne se coupent pas et ne sont pas parallèles).

> [!TIP]
> ### 9. Exercice Type : Application Affine
> **Énoncé :** Soit $f : \mathbb{R}^2 \to \mathbb{R}^2$ définie par $f(x, y) = (2x - y + 1, x + y - 2)$.
>
> a) Montrer que $f$ est affine et déterminer sa partie linéaire.
> b) $f$ a-t-elle un point fixe ?
>
> **Solution Détaillée :**
> a) On écrit $f(X) = LX + \vec{b}$ avec $L = \begin{pmatrix} 2 & -1 \\ 1 & 1 \end{pmatrix}$ et $\vec{b} = \begin{pmatrix} 1 \\ -2 \end{pmatrix}$.
> Comme $L$ est une matrice et $\vec{b}$ un vecteur, $f$ est bien affine. La partie linéaire est $\vec{f} : (u, v) \mapsto (2u - v, u + v)$, de matrice $L$.
>
> b) Point fixe : $f(x,y) = (x,y)$ $\Leftrightarrow$ $(L - I)X = -\vec{b}$.
> $(L - I) = \begin{pmatrix} 1 & -1 \\ 1 & 0 \end{pmatrix}$, $\det = 1 \neq 0$, donc il existe un **unique point fixe**.
> Résolution : $x - y = -1$ et $x = 2$, d'où $x = 2, y = 3$. Le point fixe est $(2, 3)$.

> [!QUESTION]
> ### 10. Questions de Jury
> * **Q1 :** Quelle est la différence fondamentale entre un espace affine et un espace vectoriel ?
>   * **Rép :** L'espace vectoriel a un élément neutre ($\vec{0}$), l'espace affine n'a pas de point privilégié. On ne peut pas "additionner" deux points d'un espace affine, seulement prendre des barycentres ($\sum \lambda_i = 1$).
> * **Q2 :** L'intersection de deux sous-espaces affines est-elle toujours un sous-espace affine ?
>   * **Rép :** L'intersection est soit **vide**, soit un sous-espace affine (de direction $\vec{F_1} \cap \vec{F_2}$). Ce n'est pas toujours non vide (ex : droites parallèles distinctes).
> * **Q3 :** Comment se traduit le théorème de Thalès en termes d'applications affines ?
>   * **Rép :** La projection sur une droite parallèlement à une direction donnée est une application affine. Le théorème de Thalès exprime la conservation des rapports par cette projection.
> * **Q4 :** Le groupe affine est-il commutatif ?
>   * **Rép :** Non. Par exemple, la composée d'une translation et d'une rotation dépend de l'ordre. Le groupe affine est un produit semi-direct $\text{GA}(E) \simeq \text{GL}(\vec{E}) \ltimes \vec{E}$.
> * **Q5 :** Donnez un exemple de sous-ensemble de $\mathbb{R}^2$ stable par barycentres de deux points, mais qui n'est pas un sous-espace affine.
>   * **Rép :** Ce n'est pas possible : un sous-ensemble non vide stable par barycentres de deux points (i.e. stable par $\lambda A + (1-\lambda)B$) EST un sous-espace affine. C'est la caractérisation.
> * **Q6 :** Comment déterminer si une application $f : \mathbb{R}^n \to \mathbb{R}^n$ est affine ?
>   * **Rép :** Vérifier que $f$ s'écrit $f(X) = LX + b$ (forme matricielle), ou que $f$ conserve les barycentres, ou que $(A, B) \mapsto f(B) - f(A)$ est bilinéaire en $\vec{AB}$.
> * **Q7 :** Qu'est-ce qu'un simplexe ?
>   * **Rép :** L'enveloppe convexe de $n+1$ points affinement indépendants de $\mathbb{R}^n$. Ex : segment ($n=1$), triangle ($n=2$), tétraèdre ($n=3$).

### 11. Références Bibliographiques
* **M. Audin**, *Géométrie* — Excellente approche moderne liant algèbre et géométrie affine.
* **X. Gourdon**, *Les Maths en Tête — Algèbre* — Chapitre complet sur les espaces affines (pp. 280-310).
* **P. Caldero, J. Germoni**, *Histoires hédonistes de groupes et de géométries* — Développements de géométrie affine très appréciés du jury.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Traitement classique et rigoureux.
