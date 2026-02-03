# Intégrales Impropres

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une intégrale impropre est une intégrale sur un intervalle non borné ou avec une fonction non bornée.
> * **Type 1 (borne infinie) :** $\int_a^{+\infty} f = \lim_{b \to +\infty} \int_a^b f$ si cette limite existe.
> * **Type 2 (singularité) :** $\int_a^b f = \lim_{\varepsilon \to 0^+} \int_{a+\varepsilon}^b f$ si $f$ explose en $a$.
> * **Convergence absolue :** $\int |f|$ converge $\Rightarrow$ $\int f$ converge.
> * **Comparaison :** $0 \leq f \leq g$ et $\int g$ converge $\Rightarrow$ $\int f$ converge.
> * **Équivalents :** Si $f \sim g$ et $f, g > 0$, alors $\int f$ et $\int g$ ont même nature.
> * **Intégrales de Riemann :** $\int_1^{+\infty} \frac{dx}{x^\alpha}$ converge ssi $\alpha > 1$.
> * **En 0 :** $\int_0^1 \frac{dx}{x^\alpha}$ converge ssi $\alpha < 1$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Semi-convergence :** $\int_1^{+\infty} \frac{\sin x}{x} dx$ converge mais pas absolument.
> * **Valeur principale :** $\lim_{\varepsilon \to 0} (\int_{-1}^{-\varepsilon} + \int_{\varepsilon}^{1}) \frac{dx}{x} = 0$ mais l'intégrale diverge.
> * **Deux singularités :** Traiter chaque singularité séparément.
> * $\alpha = 1$ **critique :** $\int_1^{+\infty} \frac{dx}{x}$ diverge (logarithme), $\int_0^1 \frac{dx}{x}$ diverge aussi.
> * **Comparaison :** Seulement pour fonctions de signe constant !

> [!TIP]
> ### 3. Exercice Type : Convergence par comparaison
> **Énoncé :** Étudier la convergence de $\int_1^{+\infty} \frac{dx}{x^2 + x}$.
>
> **Solution Détaillée :**
> 1. **Équivalent :** Pour $x \to +\infty$, $\frac{1}{x^2 + x} \sim \frac{1}{x^2}$.
> 2. **Intégrale de référence :** $\int_1^{+\infty} \frac{dx}{x^2}$ converge — Riemann, $\alpha = 2 > 1$.
> 3. **Comparaison :** $\frac{1}{x^2 + x} \leq \frac{1}{x^2}$ pour $x \geq 1$.
> 4. **Conclusion :** $\int_1^{+\infty} \frac{dx}{x^2 + x}$ converge.
> 5. **Calcul :** $\frac{1}{x^2+x} = \frac{1}{x} - \frac{1}{x+1}$, donc $\int_1^{+\infty} = \lim [\ln\frac{x}{x+1}]_1^b = \ln 2$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Donner un exemple d'intégrale semi-convergente.
>   * **Rép :** $\int_0^{+\infty} \frac{\sin x}{x} dx = \frac{\pi}{2}$ (intégrale de Dirichlet), mais $\int |\frac{\sin x}{x}|$ diverge.
> * **Q2 :** L'intégrale $\int_1^{+\infty} \frac{\sin(x^2)}{x} dx$ converge-t-elle ?
>   * **Rép :** Oui, par le changement $u = x^2$ et intégration par parties (critère d'Abel).
> * **Q3 :** Calculer $\int_0^{+\infty} e^{-x^2} dx$.
>   * **Rép :** $\frac{\sqrt{\pi}}{2}$ (intégrale de Gauss, par passage en polaires).

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **C. Zuily, H. Queffélec**, *Analyse pour l'agrégation* — Cours et exercices.
