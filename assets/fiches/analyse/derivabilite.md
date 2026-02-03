# Dérivabilité

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> La [dérivabilité](def:derivabilite) mesure la variation instantanée d'une fonction.
> * **Dérivée :** $f'(a) = \lim_{h \to 0} \frac{f(a+h) - f(a)}{h}$ si cette limite existe.
> * **Interprétation :** Pente de la tangente au graphe en $(a, f(a))$.
> * **Dérivée à droite/gauche :** Limites à droite/gauche du taux d'accroissement.
> * **[$C^1$](def:c1) :** $f$ dérivable avec $f'$ continue.
> * **Théorème de Rolle :** $f$ continue sur $[a,b]$, dérivable sur $]a,b[$, $f(a) = f(b) \Rightarrow \exists c, f'(c) = 0$.
> * **Accroissements finis :** $f$ continue sur $[a,b]$, dérivable sur $]a,b[$ $\Rightarrow \exists c, f(b) - f(a) = f'(c)(b-a)$.
> * **Sens de variation :** $f' > 0$ sur $I$ $\Rightarrow$ $f$ strictement croissante sur $I$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Dérivable ≠ $C^1$ :** $f(x) = x^2 \sin(1/x)$ est dérivable en 0 mais $f'$ non continue.
> * **Dérivée nulle :** $f'(a) = 0$ n'implique pas extremum (point d'inflexion possible).
> * **Réciproque Rolle :** Faux ! $f'$ peut s'annuler sans que $f$ soit constante sur un intervalle.
> * **$f' > 0$ presque partout :** Ne suffit pas pour la stricte croissance (fonction de Cantor).
> * **Composition :** $(f \circ g)' = (f' \circ g) \cdot g'$ (règle de la chaîne).

> [!TIP]
> ### 3. Exercice Type : Théorème des accroissements finis
> **Énoncé :** Montrer que $|\sin(x) - \sin(y)| \leq |x - y|$ pour tous $x, y$.
>
> **Solution Détaillée :**
> 1. Soit $f(t) = \sin(t)$. $f$ est $C^1$ sur $\mathbb{R}$ avec $f'(t) = \cos(t)$.
> 2. Par le TAF, $\exists c$ entre $x$ et $y$ tel que $\sin(x) - \sin(y) = \cos(c)(x - y)$.
> 3. Donc $|\sin(x) - \sin(y)| = |\cos(c)| |x - y| \leq |x - y|$ car $|\cos(c)| \leq 1$.
> 4. **Conclusion :** $\sin$ est 1-[lipschitzienne](def:lipschitzienne).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer la règle de L'Hôpital.
>   * **Rép :** Si $f, g \to 0$ ou $\pm\infty$ et $\frac{f'}{g'} \to \ell$, alors $\frac{f}{g} \to \ell$ (sous conditions).
> * **Q2 :** Une fonction peut-elle être dérivable sans avoir de tangente ?
>   * **Rép :** Non, dérivabilité implique existence de la tangente. Mais une courbe peut avoir une tangente verticale (dérivée infinie).
> * **Q3 :** Qu'est-ce que la formule de Taylor-Young ?
>   * **Rép :** $f(a+h) = \sum_{k=0}^{n} \frac{f^{(k)}(a)}{k!} h^k + o(h^n)$ si $f$ est $n$ fois dérivable en $a$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
