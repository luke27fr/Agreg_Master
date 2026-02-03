# Réels et Complexes

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> $\mathbb{R}$ est le [corps](def:corps) des réels, $\mathbb{C}$ le corps des complexes.
> * **Borne supérieure :** $\mathbb{R}$ est le seul corps totalement ordonné où toute partie non vide majorée admet une borne sup.
> * **Densité :** $\mathbb{Q}$ est [dense](def:dense) dans $\mathbb{R}$ : entre deux réels, il y a un rationnel.
> * **Partie entière :** $\lfloor x \rfloor = \max\{n \in \mathbb{Z} : n \leq x\}$.
> * **Nombres complexes :** $z = a + ib$ avec $a = \text{Re}(z)$, $b = \text{Im}(z)$.
> * **Module et argument :** $|z| = \sqrt{a^2 + b^2}$, $z = |z|e^{i\theta}$ où $\theta = \arg(z)$.
> * **Conjugué :** $\bar{z} = a - ib$. On a $z\bar{z} = |z|^2$.
> * **Formule d'Euler :** $e^{i\theta} = \cos\theta + i\sin\theta$.
> * **Racines $n$-ièmes :** Les racines de $z^n = w$ sont $\sqrt[n]{|w|}e^{i(\theta + 2k\pi)/n}$ pour $k = 0, \ldots, n-1$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Argument non défini pour 0 :** $\arg(0)$ n'existe pas.
> * **Argument non unique :** $\arg(z)$ est défini modulo $2\pi$.
> * **Inégalité triangulaire :** $|z + w| \leq |z| + |w|$ avec égalité ssi $z$ et $w$ sont positivement liés.
> * $|z^n| = |z|^n$ **:** Vrai, mais $\arg(z^n) = n\arg(z)$ modulo $2\pi$.
> * **Racine carrée complexe :** Pas de racine carrée "canonique" dans $\mathbb{C}$.

> [!TIP]
> ### 3. Exercice Type : Résolution de $z^3 = 1$
> **Énoncé :** Trouver toutes les racines cubiques de l'unité.
>
> **Solution Détaillée :**
> 1. On cherche $z$ tel que $|z|^3 = 1$ et $3\arg(z) \equiv 0 \pmod{2\pi}$.
> 2. Donc $|z| = 1$ et $\arg(z) = \frac{2k\pi}{3}$ pour $k \in \{0, 1, 2\}$.
> 3. **Racines :**
>    - $k = 0$ : $z_0 = 1$
>    - $k = 1$ : $z_1 = e^{2i\pi/3} = -\frac{1}{2} + i\frac{\sqrt{3}}{2} = j$
>    - $k = 2$ : $z_2 = e^{4i\pi/3} = -\frac{1}{2} - i\frac{\sqrt{3}}{2} = j^2 = \bar{j}$
> 4. **Vérification :** $1 + j + j^2 = 0$ (somme des racines).

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Montrer que $\mathbb{R}$ n'est pas dénombrable.
>   * **Rép :** Argument diagonal de Cantor sur les développements décimaux.
> * **Q2 :** Pourquoi $\mathbb{C}$ n'est-il pas ordonné ?
>   * **Rép :** Si $i > 0$, alors $i^2 = -1 > 0$, contradiction. Idem pour $i < 0$.
> * **Q3 :** Énoncer le théorème de d'Alembert-Gauss.
>   * **Rép :** Tout polynôme non constant de $\mathbb{C}[X]$ admet au moins une racine dans $\mathbb{C}$.

### 5. Références Bibliographiques
* **X. Gourdon**, *Analyse* — La référence pour l'agrégation, très complet.
* **H. Queffélec**, *Analyse pour l'agrégation* — Spécialement conçu pour le concours.
