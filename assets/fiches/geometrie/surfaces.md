# Surfaces

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Une surface dans $\mathbb{R}^3$ est définie par une équation $F(x,y,z) = 0$ ou paramétriquement $\Sigma(u,v)$.
> * **Surface paramétrée :** $\Sigma : U \subset \mathbb{R}^2 \to \mathbb{R}^3$, $(u, v) \mapsto (x(u,v), y(u,v), z(u,v))$.
> * **Régulière :** $\Sigma_u \times \Sigma_v \neq 0$ (vecteurs tangents linéairement indépendants).
> * **Plan tangent :** Engendré par $\Sigma_u$ et $\Sigma_v$. Normale : $\vec{n} = \Sigma_u \times \Sigma_v$.
> * **Première forme fondamentale :** $I = E\,du^2 + 2F\,du\,dv + G\,dv^2$ avec $E = \Sigma_u \cdot \Sigma_u$, etc.
> * **Seconde forme fondamentale :** $II = L\,du^2 + 2M\,du\,dv + N\,dv^2$. Mesure la courbure.
> * **Courbure de Gauss :** $K = \frac{LN - M^2}{EG - F^2}$ (produit des courbures principales).
> * **Courbure moyenne :** $H = \frac{EN + GL - 2FM}{2(EG - F^2)}$.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Régularité :** La sphère avec paramétrage usuel est singulière aux pôles.
> * **Orientation :** Le choix de $\vec{n}$ définit une orientation ; changer l'ordre de $u, v$ change le signe.
> * **Courbure intrinsèque :** $K$ est intrinsèque (Theorema Egregium de Gauss), $H$ ne l'est pas.
> * **Surface minimale :** $H = 0$ (ex : caténoïde, hélicoïde), pas nécessairement d'aire minimale globale.
> * **Isométries :** Une isométrie préserve $I$ (et $K$), mais pas nécessairement la forme de la surface.

> [!TIP]
> ### 3. Exercice Type : Courbure de la sphère
> **Énoncé :** Calculer la courbure de Gauss de la sphère de rayon $R$.
>
> **Solution Détaillée :**
> 1. **Paramétrage :** $\Sigma(\theta, \varphi) = (R\sin\theta\cos\varphi, R\sin\theta\sin\varphi, R\cos\theta)$.
> 2. **Vecteurs tangents :**
>    - $\Sigma_\theta = (R\cos\theta\cos\varphi, R\cos\theta\sin\varphi, -R\sin\theta)$
>    - $\Sigma_\varphi = (-R\sin\theta\sin\varphi, R\sin\theta\cos\varphi, 0)$
> 3. **Première forme :** $E = R^2$, $F = 0$, $G = R^2\sin^2\theta$.
> 4. **Seconde forme :** $L = R$, $M = 0$, $N = R\sin^2\theta$ (après calcul).
> 5. **Courbure de Gauss :** $K = \frac{R \cdot R\sin^2\theta - 0}{R^2 \cdot R^2\sin^2\theta} = \frac{1}{R^2}$.
> 6. **Conclusion :** Courbure de Gauss constante positive $K = 1/R^2$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le Theorema Egregium de Gauss.
>   * **Rép :** La courbure de Gauss ne dépend que de la première forme fondamentale (propriété intrinsèque).
> * **Q2 :** Qu'est-ce qu'une géodésique ?
>   * **Rép :** Courbe sur la surface dont la courbure géodésique est nulle. Localement, plus court chemin.
> * **Q3 :** Quelle est la courbure de Gauss d'un cylindre ?
>   * **Rép :** $K = 0$ (surface développable, localement isométrique au plan).

### 5. Références Bibliographiques
* **M. Berger**, *Géométrie* — Encyclopédique, couvre tous les aspects des surfaces.
* **J. Lelong-Ferrand, J.-M. Arnaudiès**, *Géométrie et Cinématique* — Classique complet sur les surfaces.
