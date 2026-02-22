import 'package:flutter/material.dart';
import '../services/bibliotheque_data.dart';

class BibliothequeIdealePage extends StatefulWidget {
  const BibliothequeIdealePage({super.key});

  @override
  State<BibliothequeIdealePage> createState() => _BibliothequeIdealePageState();
}

class _BibliothequeIdealePageState extends State<BibliothequeIdealePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategorie = 'tous';
  final Set<String> _valise = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Pré-remplir la valise avec les livres recommandés
    for (final livre in BibliothequeData.livresValise) {
      _valise.add(livre.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LivreAgreg> get _filteredLivres {
    var livres = BibliothequeData.livres;
    if (_selectedCategorie != 'tous') {
      livres = livres.where((l) => l.categorie == _selectedCategorie).toList();
    }
    if (_searchQuery.isNotEmpty) {
      livres = BibliothequeData.rechercher(_searchQuery);
      if (_selectedCategorie != 'tous') {
        livres = livres.where((l) => l.categorie == _selectedCategorie).toList();
      }
    }
    return livres;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque idéale'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.library_books), text: 'Catalogue'),
            Tab(icon: Icon(Icons.search), text: 'Développements'),
            Tab(icon: Icon(Icons.work), text: 'Ma Valise'),
          ],
          labelColor: isDark ? Colors.white : Theme.of(context).primaryColor,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCatalogueTab(isDark),
          _buildDeveloppementsTab(isDark),
          _buildValiseTab(isDark),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 1 : Catalogue
  // ============================================================================
  Widget _buildCatalogueTab(bool isDark) {
    final livres = _filteredLivres;

    return Column(
      children: [
        // Barre de recherche
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un livre, un auteur...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),

        // Filtres par catégorie
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildCategorieChip('tous', 'Tous', isDark),
              _buildCategorieChip('algebre', 'Algèbre', isDark),
              _buildCategorieChip('analyse', 'Analyse', isDark),
              _buildCategorieChip('probabilites', 'Probabilités', isDark),
              _buildCategorieChip('geometrie', 'Géométrie', isDark),
              _buildCategorieChip('transversal', 'Transversal', isDark),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Info banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bibliographie commentée avec les pages exactes des développements. '
                    'Appuyez sur un livre pour voir le détail.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Liste des livres
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: livres.length,
            itemBuilder: (context, index) => _buildLivreCard(livres[index], isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorieChip(String id, String label, bool isDark) {
    final selected = _selectedCategorie == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label, style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        )),
        selected: selected,
        onSelected: (_) => setState(() => _selectedCategorie = id),
        selectedColor: Theme.of(context).primaryColor,
        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
        checkmarkColor: Colors.white,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildLivreCard(LivreAgreg livre, bool isDark) {
    final inValise = _valise.contains(livre.id);
    final color = _getCategorieColor(livre.categorie);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showLivreDetail(livre),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: inValise
                    ? color.withValues(alpha: 0.4)
                    : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12)),
                width: inValise ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône livre
                Container(
                  width: 56,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_stories, color: color, size: 24),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          livre.difficulteLabel,
                          style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        livre.titre,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        livre.auteurs,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildBadge(livre.categorieLabel, color, isDark),
                          const SizedBox(width: 6),
                          _buildBadge('${livre.developpements.length} dév.', Colors.grey, isDark),
                          if (livre.conseilleValise) ...[
                            const SizedBox(width: 6),
                            _buildBadge('Valise', Colors.amber.shade700, isDark),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        livre.commentaire,
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Bouton valise
                IconButton(
                  icon: Icon(
                    inValise ? Icons.work : Icons.work_outline,
                    color: inValise ? Colors.amber.shade700 : Colors.grey,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      if (inValise) {
                        _valise.remove(livre.id);
                      } else {
                        _valise.add(livre.id);
                      }
                    });
                  },
                  tooltip: inValise ? 'Retirer de la valise' : 'Ajouter à la valise',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  // ============================================================================
  // TAB 2 : Recherche par développement
  // ============================================================================
  Widget _buildDeveloppementsTab(bool isDark) {
    return _DeveloppementsSearchView(isDark: isDark);
  }

  // ============================================================================
  // TAB 3 : Ma Valise
  // ============================================================================
  Widget _buildValiseTab(bool isDark) {
    final livresValise = BibliothequeData.livres
        .where((l) => _valise.contains(l.id))
        .toList();

    // Calculer la couverture par catégorie
    final couverture = <String, int>{};
    for (final cat in BibliothequeData.categories) {
      couverture[cat] = livresValise.where((l) => l.categorie == cat).length;
    }

    final totalDevs = livresValise.fold<int>(0, (sum, l) => sum + l.developpements.length);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conseil
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.amber.shade900.withValues(alpha: 0.3), Colors.orange.shade900.withValues(alpha: 0.3)]
                    : [Colors.amber.shade50, Colors.orange.shade50],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.work, color: Colors.amber.shade700, size: 24),
                    const SizedBox(width: 10),
                    const Text(
                      'Constituer sa valise',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  BibliothequeData.conseilValise,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats de la valise
          Row(
            children: [
              Expanded(child: _buildValiseStatCard(
                '${livresValise.length}',
                'livres',
                livresValise.length <= BibliothequeData.maxLivresValise
                    ? Colors.green
                    : Colors.red,
                isDark,
              )),
              const SizedBox(width: 10),
              Expanded(child: _buildValiseStatCard(
                '$totalDevs',
                'développements',
                Colors.blue,
                isDark,
              )),
              const SizedBox(width: 10),
              Expanded(child: _buildValiseStatCard(
                '${couverture.values.where((v) => v > 0).length}/${BibliothequeData.categories.length}',
                'domaines couverts',
                Colors.purple,
                isDark,
              )),
            ],
          ),

          if (livresValise.length > BibliothequeData.maxLivresValise)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attention : vous avez ${livresValise.length} livres. '
                        'La limite recommandée est de ${BibliothequeData.maxLivresValise}.',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Couverture par domaine
          const Text(
            'Couverture par domaine',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ...BibliothequeData.categories.map((cat) {
            final count = couverture[cat] ?? 0;
            final label = _getCategorieLabel(cat);
            final color = _getCategorieColor(cat);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
                  Text(
                    count == 0 ? 'Non couvert' : '$count livre${count > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: count == 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    count == 0 ? Icons.cancel : Icons.check_circle,
                    color: count == 0 ? Colors.red : Colors.green,
                    size: 16,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // Liste des livres dans la valise
          const Text(
            'Livres dans la valise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),

          if (livresValise.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(Icons.work_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'Votre valise est vide',
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ajoutez des livres depuis le catalogue',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...livresValise.map((livre) => _buildValiseBookTile(livre, isDark)),
        ],
      ),
    );
  }

  Widget _buildValiseStatCard(String value, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: color,
          )),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildValiseBookTile(LivreAgreg livre, bool isDark) {
    final color = _getCategorieColor(livre.categorie);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _showLivreDetail(livre),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.auto_stories, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(livre.titre, style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13,
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        '${livre.auteurs} • ${livre.developpements.length} dév.',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.red[300], size: 20),
                  onPressed: () => setState(() => _valise.remove(livre.id)),
                  tooltip: 'Retirer de la valise',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Détail d'un livre
  // ============================================================================
  void _showLivreDetail(LivreAgreg livre) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _LivreDetailPage(
        livre: livre,
        inValise: _valise.contains(livre.id),
        onToggleValise: () {
          setState(() {
            if (_valise.contains(livre.id)) {
              _valise.remove(livre.id);
            } else {
              _valise.add(livre.id);
            }
          });
        },
      ),
    ));
  }

  // ============================================================================
  // Utils
  // ============================================================================
  Color _getCategorieColor(String categorie) {
    switch (categorie) {
      case 'algebre': return Colors.blue;
      case 'analyse': return Colors.green;
      case 'probabilites': return Colors.orange;
      case 'geometrie': return Colors.purple;
      case 'transversal': return Colors.teal;
      default: return Colors.grey;
    }
  }

  String _getCategorieLabel(String categorie) {
    switch (categorie) {
      case 'algebre': return 'Algèbre';
      case 'analyse': return 'Analyse';
      case 'probabilites': return 'Probabilités';
      case 'geometrie': return 'Géométrie';
      case 'transversal': return 'Transversal';
      default: return categorie;
    }
  }
}

// ==============================================================================
// Recherche par développement (Tab 2)
// ==============================================================================
class _DeveloppementsSearchView extends StatefulWidget {
  final bool isDark;
  const _DeveloppementsSearchView({required this.isDark});

  @override
  State<_DeveloppementsSearchView> createState() => _DeveloppementsSearchViewState();
}

class _DeveloppementsSearchViewState extends State<_DeveloppementsSearchView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = _query.length >= 2
        ? BibliothequeData.trouverDeveloppement(_query)
        : <MapEntry<LivreAgreg, PageReference>>[];

    // Si pas de recherche, afficher tous les développements groupés
    final allDevs = _query.isEmpty ? _buildAllDeveloppements() : null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un développement (ex: Sylow, Fourier...)',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: widget.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),

        // Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: widget.isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[400], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trouvez dans quel livre et à quelle page se trouve un développement donné.',
                    style: TextStyle(fontSize: 12, color: widget.isDark ? Colors.white60 : Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: _query.isNotEmpty && _query.length >= 2
              ? results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text('Aucun développement trouvé pour "$_query"',
                            style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final entry = results[index];
                        return _buildDevResult(entry.key, entry.value, widget.isDark);
                      },
                    )
              : allDevs != null
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: allDevs,
                    )
                  : Center(
                      child: Text(
                        'Tapez au moins 2 caractères',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
        ),
      ],
    );
  }

  List<Widget> _buildAllDeveloppements() {
    final widgets = <Widget>[];
    for (final livre in BibliothequeData.livres) {
      if (livre.developpements.isEmpty) continue;
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          '${livre.titre} — ${livre.auteurs}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
        ),
      ));
      for (final dev in livre.developpements) {
        widgets.add(_buildDevResult(livre, dev, widget.isDark));
      }
    }
    return widgets;
  }

  Widget _buildDevResult(LivreAgreg livre, PageReference dev, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dev.developpement,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.auto_stories, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${livre.titre} (${livre.auteurs})',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dev.pages,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                if (dev.leconNumero != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Leçons ${dev.leconNumero}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (dev.commentaire != null) ...[
              const SizedBox(height: 6),
              Text(
                dev.commentaire!,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// Page de détail d'un livre
// ==============================================================================
class _LivreDetailPage extends StatelessWidget {
  final LivreAgreg livre;
  final bool inValise;
  final VoidCallback onToggleValise;

  const _LivreDetailPage({
    required this.livre,
    required this.inValise,
    required this.onToggleValise,
  });

  Color get _color {
    switch (livre.categorie) {
      case 'algebre': return Colors.blue;
      case 'analyse': return Colors.green;
      case 'probabilites': return Colors.orange;
      case 'geometrie': return Colors.purple;
      case 'transversal': return Colors.teal;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(livre.auteurs, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(
              inValise ? Icons.work : Icons.work_outline,
              color: inValise ? Colors.amber.shade700 : null,
            ),
            onPressed: () {
              onToggleValise();
              Navigator.pop(context);
            },
            tooltip: inValise ? 'Retirer de la valise' : 'Ajouter à la valise',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color.withValues(alpha: 0.1), _color.withValues(alpha: 0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _color.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _color.withValues(alpha: isDark ? 0.3 : 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_stories, color: _color, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              livre.categorieLabel,
                              style: TextStyle(fontSize: 9, color: _color, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              livre.titre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(livre.auteurs, style: TextStyle(
                              fontSize: 14, color: _color, fontWeight: FontWeight.w600,
                            )),
                            const SizedBox(height: 2),
                            Text(
                              '${livre.editeur}${livre.edition != null ? ' • ${livre.edition}' : ''}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _badge(livre.difficulteLabel, _difficulteColor(livre.difficulte), isDark),
                      _badge('${livre.developpements.length} développements', Colors.blue, isDark),
                      if (livre.conseilleValise)
                        _badge('Recommandé valise', Colors.amber.shade700, isDark),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pourquoi ce livre
            _sectionTitle('Pourquoi ce livre ?', Icons.star, Colors.amber),
            const SizedBox(height: 8),
            Text(
              livre.pourquoi,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Avis détaillé
            _sectionTitle('Avis détaillé', Icons.rate_review, Colors.blue),
            const SizedBox(height: 8),
            Text(
              livre.commentaire,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Points forts / faibles
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Points forts', Icons.thumb_up, Colors.green),
                      const SizedBox(height: 8),
                      ...livre.pointsForts.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.add_circle, color: Colors.green, size: 14),
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Text(p, style: const TextStyle(fontSize: 12, height: 1.3))),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                if (livre.pointsFaibles.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Points faibles', Icons.thumb_down, Colors.red),
                        const SizedBox(height: 8),
                        ...livre.pointsFaibles.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.remove_circle, color: Colors.red, size: 14),
                              ),
                              const SizedBox(width: 6),
                              Expanded(child: Text(p, style: const TextStyle(fontSize: 12, height: 1.3))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Développements avec pages
            _sectionTitle(
              'Développements & pages exactes',
              Icons.bookmark,
              Colors.deepPurple,
            ),
            const SizedBox(height: 4),
            Text(
              'Les pages où trouver chaque développement dans ce livre :',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 12),

            ...livre.developpements.map((dev) => _buildDevCard(dev, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: color,
        )),
      ],
    );
  }

  Widget _badge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600, color: color,
      )),
    );
  }

  Color _difficulteColor(int level) {
    switch (level) {
      case 1: return Colors.green;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildDevCard(PageReference dev, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dev.developpement,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Pages
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bookmark, color: Colors.blue, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        dev.pages,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                // Leçons
                if (dev.leconNumero != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.school, color: Colors.purple, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Leçons ${dev.leconNumero}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (dev.commentaire != null) ...[
              const SizedBox(height: 8),
              Text(
                dev.commentaire!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontStyle: FontStyle.italic,
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
