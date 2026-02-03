# Convergences et Intégrales

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Les théorèmes de convergence permettent d'intervertir limite et intégrale.
> * **Convergence monotone (Beppo Levi) :** Si $f_n \nearrow f$ avec $f_n \geq 0$ mesurables, alors $\int f_n \nearrow \int f$.
> * **Lemme de Fatou :** $\int \liminf f_n \leq \liminf \int f_n$ pour $f_n \geq 0$.
> * **Convergence dominée (Lebesgue) :** Si $f_n \to f$ p.p., $|f_n| \leq g$ intégrable, alors $\int f_n \to \int f$.
> * **Fubini :** $\int \int f(x,y) dx dy = \int \int f(x,y) dy dx$ si $\int \int |f| < +\infty$.
> * **Dérivation sous l'intégrale :** $\frac{d}{dt} \int f(x,t) dx = \int \frac{\partial f}{\partial t}(x,t) dx$ sous conditions.
> * **Intégrale dépendant d'un paramètre :** $F(t) = \int_a^b f(x, t) dx$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Domination :** La fonction dominante $g$ doit être **indépendante de $n$** et intégrable.
> * **Fatou :** L'inégalité peut être stricte ! $f_n = \mathbf{1}_{[n, n+1]}$ : $\liminf f_n = 0$ mais $\int f_n = 1$.
> * **Fubini :** Nécessite l'intégrabilité de $|f|$. Contre-exemple : $\int_0^1 \int_0^1 \frac{x^2 - y^2}{(x^2+y^2)^2}$.
> * **Convergence simple ≠ dominée :** Il faut une majoration uniforme en $n$.
> * **Dérivation :** Vérifier que $\frac{\partial f}{\partial t}$ est dominée par une fonction intégrable.

> [!TIP]
> ### 3. Exercice Type : Convergence dominée
> **Énoncé :** Calculer $\lim_{n \to \infty} \int_0^{+\infty} \frac{n \sin(x/n)}{x(1 + x^2)} dx$.
>
> **Solution Détaillée :**
> 1. **Convergence simple :** $\frac{n \sin(x/n)}{x} \to 1$ quand $n \to \infty$ (car $\frac{\sin u}{u} \to 1$).
>    Donc $f_n(x) = \frac{n \sin(x/n)}{x(1 + x^2)} \to \frac{1}{1 + x^2}$.
> 2. **Domination :** $|n \sin(x/n)| \leq |x|$ (car $|\sin u| \leq |u|$).
>    Donc $|f_n(x)| \leq \frac{1}{1 + x^2}$ qui est intégrable sur $[0, +\infty[$.
> 3. **Convergence dominée :** $\lim \int f_n = \int \lim f_n = \int_0^{+\infty} \frac{dx}{1 + x^2} = [\arctan x]_0^{+\infty} = \frac{\pi}{2}$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le théorème de convergence dominée.
>   * **Rép :** Si $f_n \to f$ p.p. et $|f_n| \leq g$ avec $g$ intégrable, alors $\int f_n \to \int f$ et $\int |f_n - f| \to 0$.
> * **Q2 :** Peut-on appliquer Fubini à $\int_0^1 \int_0^1 \frac{x - y}{(x + y)^3} dx dy$ ?
>   * **Rép :** Non sans précaution : l'intégrale de $|f|$ diverge. Les deux intégrales itérées donnent des résultats opposés.
> * **Q3 :** Quelle est l'utilité du lemme de Fatou ?
>   * **Rép :** Obtenir une inégalité même sans domination. Utile pour montrer l'intégrabilité de la limite.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **W. Rudin**, *Analyse réelle et complexe* (traduit en français) — Classique rigoureux.
