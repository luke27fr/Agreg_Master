# Loi des Grands Nombres et Théorème Central Limite

> [!NOTE]
> ### 1. Définitions et Fondamentaux
> Soit $(X_n)$ une suite de v.a. i.i.d. d'espérance $\mu$ et variance $\sigma^2$. On pose $\bar{X}_n = \frac{1}{n}\sum_{k=1}^n X_k$.
> * **[LGN](def:lgn) faible :** $\bar{X}_n \xrightarrow{\mathbb{P}} \mu$ (convergence en probabilité).
> * **LGN forte :** $\bar{X}_n \xrightarrow{p.s.} \mu$ (convergence presque sûre).
> * **[TCL](def:tcl) :** $\frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} \xrightarrow{\mathcal{L}} \mathcal{N}(0,1)$ (convergence en loi).
> * **Formulation équivalente :** $\sqrt{n}(\bar{X}_n - \mu) \xrightarrow{\mathcal{L}} \mathcal{N}(0, \sigma^2)$.
> * **Approximation pratique :** Pour $n$ grand, $\bar{X}_n \approx \mathcal{N}(\mu, \sigma^2/n)$.
> * **Intervalle de confiance :** $\mu \in [\bar{X}_n - 1.96\frac{\sigma}{\sqrt{n}}, \bar{X}_n + 1.96\frac{\sigma}{\sqrt{n}}]$ à 95%.

> [!WARNING]
> ### 2. Pièges à éviter
> * **Hypothèses :** La LGN faible nécessite $\mathbb{E}[X_1]$ finie, la LGN forte aussi.
> * **TCL :** Nécessite variance finie ! Ne s'applique pas à Cauchy.
> * **Vitesse de convergence :** Le TCL ne dit rien sur la vitesse (Berry-Esseen pour ça).
> * **i.i.d. :** Les versions généralisées existent (Lindeberg, Lyapunov) pour des v.a. non identiques.

> [!TIP]
> ### 3. Exercice Type : Approximation binomiale
> **Énoncé :** Soit $S_n \sim \mathcal{B}(n, p)$. Calculer $\mathbb{P}(S_{100} \geq 60)$ pour $p = 0.5$.
>
> **Solution Détaillée :**
> 1. **Paramètres :** $\mu = np = 50$, $\sigma^2 = np(1-p) = 25$, $\sigma = 5$.
> 2. **Centrage-réduction :** $Z_n = \frac{S_n - 50}{5}$.
> 3. **Approximation TCL :** $\mathbb{P}(S_n \geq 60) = \mathbb{P}(Z_n \geq 2)$.
> 4. **Correction de continuité :** $\mathbb{P}(S_n \geq 60) \approx \mathbb{P}(Z_n \geq \frac{59.5-50}{5}) = \mathbb{P}(Z_n \geq 1.9)$.
> 5. **Table :** $\mathbb{P}(Z \geq 1.9) = 1 - \Phi(1.9) \approx 1 - 0.9713 = 0.0287$.

> [!QUESTION]
> ### 4. Questions de Jury
> * **Q1 :** Énoncer le TCL.
>   * **Rép :** Si $(X_n)$ i.i.d. avec $\mu = \mathbb{E}[X_1]$ et $\sigma^2 = \text{Var}(X_1) < \infty$, alors $\frac{\sum X_k - n\mu}{\sigma\sqrt{n}} \to \mathcal{N}(0,1)$.
> * **Q2 :** Quelle différence entre LGN faible et forte ?
>   * **Rép :** Faible = convergence en probabilité, Forte = convergence presque sûre.
> * **Q3 :** Pourquoi la correction de continuité ?
>   * **Rép :** On approche une loi discrète par une loi continue; $P(X \geq k) \approx P(Y \geq k - 0.5)$.

### 5. Références Bibliographiques
* **D. Foata, A. Fuchs**, *Calcul des probabilités* — Démonstrations complètes de la LGN et du TCL.
* **J.-Y. Ouvrard**, *Probabilités 2* — Applications et exercices sur les théorèmes limites.
