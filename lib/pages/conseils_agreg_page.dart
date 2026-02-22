import 'package:flutter/material.dart';
import '../services/conseils_data.dart';

class ConseilsAgregPage extends StatefulWidget {
  const ConseilsAgregPage({super.key});

  @override
  State<ConseilsAgregPage> createState() => _ConseilsAgregPageState();
}

class _ConseilsAgregPageState extends State<ConseilsAgregPage> {
  String? _expandedCategorieId;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conseils & Stratégies'),
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: _buildHeader(isDark),
          ),

          // Barre de recherche
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un conseil...',
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
          ),

          // Résultats de recherche ou catégories
          if (_searchQuery.length >= 2)
            _buildSearchResults(isDark)
          else
            ..._buildCategories(isDark),

          // Pépite du jour en bas
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildPepiteDuJour(isDark),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.blue.shade900.withValues(alpha: 0.4), Colors.indigo.shade900.withValues(alpha: 0.4)]
                : [Colors.blue.shade50, Colors.indigo.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Réussir l\'agrégation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Synthèse des conseils de candidats admis et rapports du jury',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '${ConseilsData.categories.length} thématiques • '
              '${ConseilsData.categories.fold<int>(0, (s, c) => s + c.conseils.length)} conseils détaillés • '
              '${ConseilsData.pepitesDuJour.length} pépites quotidiennes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategories(bool isDark) {
    return ConseilsData.categories.map((cat) {
      final isExpanded = _expandedCategorieId == cat.id;
      final color = _getCategorieColor(cat.id);
      final icon = _getCategorieIcon(cat.id);

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Material(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // En-tête de catégorie
                InkWell(
                  onTap: () => setState(() {
                    _expandedCategorieId = isExpanded ? null : cat.id;
                  }),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isExpanded
                            ? color.withValues(alpha: 0.4)
                            : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12)),
                        width: isExpanded ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.titre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                cat.description,
                                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${cat.conseils.length}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),

                // Conseils (expanded)
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Column(
                      children: cat.conseils.map((conseil) => _buildConseilCard(conseil, color, isDark)).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildConseilCard(ConseilItem conseil, Color accentColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _ConseilExpandableCard(
        conseil: conseil,
        accentColor: accentColor,
        isDark: isDark,
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    final results = ConseilsData.rechercher(_searchQuery);
    if (results.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Aucun conseil trouvé pour "$_searchQuery"',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final conseil = results[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ConseilExpandableCard(
                conseil: conseil,
                accentColor: Colors.blue,
                isDark: isDark,
              ),
            );
          },
          childCount: results.length,
        ),
      ),
    );
  }

  Widget _buildPepiteDuJour(bool isDark) {
    final pepite = ConseilsData.getPepiteDuJour();
    final index = ConseilsData.getPepiteIndex();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.amber.shade900.withValues(alpha: 0.3), Colors.orange.shade900.withValues(alpha: 0.3)]
              : [Colors.amber.shade50, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pépite du jour',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${index + 1}/${ConseilsData.pepitesDuJour.length}',
                  style: TextStyle(fontSize: 10, color: Colors.amber.shade700, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pepite,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategorieColor(String id) {
    switch (id) {
      case 'organisation': return Colors.blue;
      case 'ecrit': return Colors.green;
      case 'oral_lecon': return Colors.purple;
      case 'oral_dev': return Colors.deepPurple;
      case 'jury': return Colors.orange;
      case 'mental': return Colors.teal;
      case 'valise': return Colors.amber.shade700;
      case 'astuces': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getCategorieIcon(String id) {
    switch (id) {
      case 'organisation': return Icons.calendar_today;
      case 'ecrit': return Icons.edit_note;
      case 'oral_lecon': return Icons.school;
      case 'oral_dev': return Icons.bookmark;
      case 'jury': return Icons.groups;
      case 'mental': return Icons.self_improvement;
      case 'valise': return Icons.work;
      case 'astuces': return Icons.emoji_events;
      default: return Icons.info;
    }
  }
}

// ==============================================================================
// Card de conseil expandable
// ==============================================================================
class _ConseilExpandableCard extends StatefulWidget {
  final ConseilItem conseil;
  final Color accentColor;
  final bool isDark;

  const _ConseilExpandableCard({
    required this.conseil,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_ConseilExpandableCard> createState() => _ConseilExpandableCardState();
}

class _ConseilExpandableCardState extends State<_ConseilExpandableCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final conseil = widget.conseil;
    final color = widget.accentColor;
    final isDark = widget.isDark;

    return Material(
      color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _expanded
                  ? color.withValues(alpha: 0.3)
                  : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Row(
                children: [
                  // Importance indicator
                  ...List.generate(conseil.importance, (i) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(Icons.star, color: Colors.amber, size: 12),
                  )),
                  if (conseil.importance < 3)
                    ...List.generate(3 - conseil.importance, (i) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.star_border, color: Colors.grey[400], size: 12),
                    )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      conseil.titre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),

              // Source
              if (conseil.source != null) ...[
                const SizedBox(height: 4),
                Text(
                  conseil.source!,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],

              // Contenu (expanded)
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  conseil.contenu,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                if (conseil.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: conseil.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isDark ? 0.12 : 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
