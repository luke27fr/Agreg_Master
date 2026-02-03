# Convexité en Analyse

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La convexité est une propriété géométrique avec de nombreuses applications analytiques.
> * **Fonction [convexe](def:convexe) :** $f(\lambda x + (1-\lambda)y) \leq \lambda f(x) + (1-\lambda)f(y)$ pour $\lambda \in [0,1]$.
> * **Épigraphe :** $\text{epi}(f) = \{(x, t) : t \geq f(x)\}$. $f$ convexe ssi épigraphe convexe.
> * **Inégalité des pentes :** $f$ convexe ssi $\frac{f(y)-f(x)}{y-x}$ croît en $y$ ou $x$.
> * **Dérivée :** $f$ convexe et dérivable $\Leftrightarrow$ $f'$ croissante $\Leftrightarrow$ $f''$ $\geq 0$ (si existe).
> * **Inégalité de Jensen :** $f(\mathbb{E}[X]) \leq \mathbb{E}[f(X)]$ pour $f$ convexe et $X$ variable aléatoire.
> * **Stricte convexité :** Inégalité stricte pour $\lambda \in ]0,1[$ et $x \neq y$.
> * **Semi-continuité inférieure :** Toute fonction convexe sur un ouvert est continue.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Convexe ≠ $C^2$ :** $f(x) = |x|$ est convexe mais pas $C^1$ en 0.
> * **Jensen :** Attention au sens de l'inégalité pour les fonctions concaves (inverser).
> * **Minimum :** Une fonction convexe atteint son minimum sur un fermé borné convexe (si elle est s.c.i.).
> * **Point de discontinuité :** Une fonction convexe sur un ouvert est automatiquement continue.
> * **Sous-différentiel :** En un point de non-dérivabilité, il existe quand même des "pentes" admissibles.

> [!TIP]
> ### 3. Exercice Type : Inégalité AM-GM via Jensen
> **Énoncé :** Montrer que $\sqrt[n]{a_1 \cdots a_n} \leq \frac{a_1 + \cdots + a_n}{n}$ pour $a_i > 0$.
>
> **Solution Détaillée :**
> 1. **Fonction :** $f(x) = -\ln(x)$ est convexe sur $]0, +\infty[$ car $f''(x) = 1/x^2 > 0$.
> 2. **Jensen discret :** $f\left(\frac{1}{n}\sum a_i\right) \leq \frac{1}{n}\sum f(a_i)$.
> 3. **Application :** $-\ln\left(\frac{a_1 + \cdots + a_n}{n}\right) \leq \frac{1}{n}\sum (-\ln a_i) = -\ln\sqrt[n]{a_1 \cdots a_n}$.
> 4. **Passage à l'exp :** $\frac{a_1 + \cdots + a_n}{n} \geq \sqrt[n]{a_1 \cdots a_n}$ (en inversant l'inégalité car $-\ln$ décroissante).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer l'inégalité de Jensen.
>   * **Rép :** Si $\varphi$ est convexe et $X$ intégrable, alors $\varphi(\mathbb{E}[X]) \leq \mathbb{E}[\varphi(X)]$.
> * **Q2 :** Une fonction convexe est-elle toujours dérivable ?
>   * **Rép :** Non, mais elle admet des dérivées à gauche et à droite en tout point intérieur.
> * **Q3 :** Donner un exemple de fonction convexe non continue.
>   * **Rép :** Impossible sur un ouvert. Mais sur un fermé : $f(x) = 0$ pour $x \in [0,1[$, $f(1) = 1$ (pas convexe en fait). Sur un ouvert, convexe $\Rightarrow$ continue.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
