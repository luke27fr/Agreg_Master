# Séries Entières

> [!NOTE]
> ### 1. Définitions et Rayon
> Soit $\sum a_n z^n$ une [série entière](def:serie_entiere). Le [rayon de convergence](def:rayon) $R$ est défini par le [théorème de Cauchy-Hadamard](def:cauchy_hadamard) :
> $$R = \sup \{r \ge 0 \mid (a_n r^n) \text{ est bornée}\}$$
> * **Règle de d'Alembert :** Si $|\frac{a_{n+1}}{a_n}| \to L$, alors $R = \frac{1}{L}$.
> * **Dérivation :** On peut dériver terme à terme. La série dérivée a le **même rayon** de convergence.
> $$f'(z) = \sum_{n=1}^{+\infty} n a_n z^{n-1}$$

> [!WARNING]
> ### 2. Pièges à éviter
> * **Le bord du disque :** Pour $|z|=R$, on ne peut rien dire a priori. Il faut étudier chaque cas (convergence simple, absolue ou [uniforme](def:convergence_uniforme)).
> * **Série lacunaire :** Pour une série type $\sum z^{n^2}$, la règle de d'Alembert ne s'applique pas directement. Il faut poser $u_n = z^{n^2}$ ou revenir à Cauchy-Hadamard.

> [!TIP]
> ### 3. Exercice Classique
> **Énoncé :** Déterminer le rayon de convergence de la série $\sum a_n z^n$ avec $a_n = \frac{n!}{n^n}$.
>
> #### Solution Détaillée :
> **1. Règle de d'Alembert :**
> On pose $u_n = |a_n z^n|$ pour $z \neq 0$. On étudie la limite de $\frac{a_{n+1}}{a_n}$.
> $$\frac{a_{n+1}}{a_n} = \frac{(n+1)!}{(n+1)^{n+1}} \times \frac{n^n}{n!} = \frac{n+1}{(n+1)^{n+1}} n^n = \frac{1}{(n+1)^n} n^n$$
>
> **2. Passage à l'exponentielle :**
> On réécrit le rapport :
> $$\frac{a_{n+1}}{a_n} = \left( \frac{n}{n+1} \right)^n = \left( \frac{1}{1 + \frac{1}{n}} \right)^n = \frac{1}{(1+\frac{1}{n})^n}$$
>
> **3. Conclusion :**
> On sait que $(1+\frac{1}{n})^n = \exp(n \ln(1+1/n)) \to e^1 = e$.
> Donc $\lim |\frac{a_{n+1}}{a_n}| = \frac{1}{e}$. D'après la règle de d'Alembert, le rayon est l'inverse de cette limite : $R = e$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Une fonction $\mathcal{C}^\infty$ est-elle toujours développable en série entière ?
>   * **Rép :** Non. Contre-exemple célèbre : $f(x) = e^{-1/x^2}$ (prolongée par 0 en 0). Elle est $\mathcal{C}^\infty$, toutes ses dérivées en 0 sont nulles, mais elle n'est pas nulle.
> * **Q2 :** Que dire du rayon de la somme de deux séries ?
>   * **Rép :** $R_{\Sigma} \ge \min(R_1, R_2)$. Si $R_1 \neq R_2$, on a égalité avec le minimum. Si $R_1 = R_2$, le rayon peut être plus grand (ex: somme nulle).
> * **Q3 :** Quel est le lien avec l'Holomorphie ?
>   * **Rép :** Une somme de série entière est holomorphe dans son disque ouvert de convergence. Réciproquement, toute fonction holomorphe est analytique (développable en série entière).