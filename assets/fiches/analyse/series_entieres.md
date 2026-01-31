# Séries Entières

### 1. Rayon de convergence
Le rayon de convergence $R$ d'une série entière $\sum a_n z^n$ est défini par :
$$R = \sup \{ r \geq 0 \mid (a_n r^n) \text{ est bornée} \}$$

**Règle de d'Alembert :**
Si $\left| \frac{a_{n+1}}{a_n} \right| \to L$, alors $R = \frac{1}{L}$ (avec la convention $1/0 = +\infty$).

---

### 2. Propriétés de la somme
La fonction $f(z) = \sum_{n=0}^{+\infty} a_n z^n$ est continue sur le disque ouvert de convergence $D(0, R)$.
Elle est même $\mathcal{C}^\infty$ et on peut dériver terme à terme :
$$f'(z) = \sum_{n=1}^{+\infty} n a_n z^{n-1}$$
Le rayon de convergence de la série dérivée est le même que celui de la série initiale.

---

> **⚠️ Pièges à Éviter**
> * **Le bord du disque :** On ne peut rien dire a priori sur la convergence lorsque $|z| = R$. Il faut étudier chaque cas (convergence simple, absolue ou uniforme).
> * **Série lacunaire :** Pour une série comme $\sum z^{n^2}$, la règle de d'Alembert ne s'applique pas directement aux coefficients $a_n$. Il faut revenir à la définition ou poser $u_n = z^{n^2}$.
> * **Sommation d'équivalents :** Attention, $\sum a_n z^n \sim \sum b_n z^n$ quand $z \to R$ demande des hypothèses strictes (coefficients positifs par exemple).

---

### 3. Exercice Classique
**Énoncé :** Déterminer le rayon de convergence de $\sum \frac{n!}{n^n} z^n$.

**Correction :**
En posant $a_n = \frac{n!}{n^n}$, calculons le rapport :
$$\frac{a_{n+1}}{a_n} = \frac{(n+1)!}{(n+1)^{n+1}} \cdot \frac{n^n}{n!} = \frac{n+1}{(n+1)(1 + \frac{1}{n})^n} = \frac{1}{(1 + \frac{1}{n})^n}$$
On sait que $(1 + \frac{1}{n})^n \to e$, donc $\frac{a_{n+1}}{a_n} \to \frac{1}{e}$.
D'après la règle de d'Alembert, $R = e$.