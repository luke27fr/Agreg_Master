import 'package:flutter/material.dart';
import '../services/mind_map_service.dart';
import '../models/mind_map_model.dart';

class MindMapPage extends StatefulWidget {
  const MindMapPage({super.key});

  @override
  State<MindMapPage> createState() => _MindMapPageState();
}

class _MindMapPageState extends State<MindMapPage> with SingleTickerProviderStateMixin {
  final MindMapService _service = MindMapService();
  late TabController _tabController;
  String _selectedDomaine = 'Algèbre';
  String? _selectedNodeId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service.addListener(_onDataChanged);
    _service.loadMindMap();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _service.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Carte Mentale', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Carte', icon: Icon(Icons.account_tree)),
            Tab(text: 'Parcours', icon: Icon(Icons.route)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMapTab(isDark),
          _buildPathsTab(isDark),
        ],
      ),
    );
  }

  Widget _buildMapTab(bool isDark) {
    final nodes = _service.getNodesByDomaine(_selectedDomaine);

    // Grouper par niveau
    final byLevel = <int, List<MindMapNode>>{};
    for (var node in nodes) {
      byLevel.putIfAbsent(node.niveau, () => []).add(node);
    }

    return Column(
      children: [
        // Sélecteur de domaine
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Domaine : ', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDomaineChip('Algèbre'),
                      const SizedBox(width: 8),
                      _buildDomaineChip('Analyse'),
                      const SizedBox(width: 8),
                      _buildDomaineChip('Géométrie'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Carte hiérarchique
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: byLevel.entries.map((entry) {
                return _buildLevelSection(entry.key, entry.value, isDark);
              }).toList(),
            ),
          ),
        ),

        // Détails du nœud sélectionné
        if (_selectedNodeId != null)
          _buildNodeDetails(_service.getNode(_selectedNodeId!)!, isDark),
      ],
    );
  }

  Widget _buildLevelSection(int level, List<MindMapNode> nodes, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getLevelColor(level).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getLevelColor(level)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getLevelIcon(level), size: 16, color: _getLevelColor(level)),
                      const SizedBox(width: 6),
                      Text(
                        'Niveau $level - ${_getLevelLabel(level)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getLevelColor(level),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: nodes.map((node) => _buildNodeCard(node, isDark)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeCard(MindMapNode node, bool isDark) {
    final isSelected = _selectedNodeId == node.id;
    final hasPrereq = node.prerequisIds.isNotEmpty;
    final hasNext = node.suivantIds.isNotEmpty;

    return GestureDetector(
      onTap: () => setState(() => _selectedNodeId = node.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF1A237E)
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A237E) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getNodeIcon(node.type),
                  size: 16,
                  color: isSelected ? Colors.white : _getTypeColor(node.type),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    node.titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasPrereq)
                  Icon(
                    Icons.arrow_upward,
                    size: 12,
                    color: isSelected ? Colors.white70 : Colors.orange,
                  ),
                if (hasPrereq) const SizedBox(width: 4),
                if (hasNext)
                  Icon(
                    Icons.arrow_downward,
                    size: 12,
                    color: isSelected ? Colors.white70 : Colors.green,
                  ),
                if (hasNext) const SizedBox(width: 4),
                Text(
                  node.type,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeDetails(MindMapNode node, bool isDark) {
    final prereqs = _service.getPrerequisites(node.id);
    final next = _service.getNextNodes(node.id);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_getNodeIcon(node.type), color: _getTypeColor(node.type)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  node.titre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _selectedNodeId = null),
              ),
            ],
          ),

          if (node.description != null) ...[
            const SizedBox(height: 12),
            Text(node.description!),
          ],

          if (node.motsCles.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: node.motsCles.map((mot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    mot,
                    style: const TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                );
              }).toList(),
            ),
          ],

          if (prereqs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Prérequis :',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: prereqs.map((n) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Text(n.titre, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
            ),
          ],

          if (next.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Permet d\'aborder :',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: next.map((n) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(n.titre, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPathsTab(bool isDark) {
    final paths = _service.paths;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        return _buildPathCard(paths[index], isDark);
      },
    );
  }

  Widget _buildPathCard(LearningPath path, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.route, color: Color(0xFF1A237E)),
        ),
        title: Text(
          path.nom,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${path.nodeIds.length} étapes • ${path.dureeEstimeeHeures}h',
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(path.description),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flag, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Objectif: ${path.objectif}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Parcours détaillé :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...path.nodeIds.asMap().entries.map((entry) {
                  final index = entry.key;
                  final nodeId = entry.value;
                  final node = _service.getNode(nodeId);
                  
                  if (node == null) return const SizedBox.shrink();
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: _getLevelColor(node.niveau).withOpacity(0.2),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getLevelColor(node.niveau),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                node.titre,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                node.type,
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _getNodeIcon(node.type),
                          size: 18,
                          color: _getTypeColor(node.type),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomaineChip(String domaine) {
    final isSelected = _selectedDomaine == domaine;
    return ChoiceChip(
      label: Text(domaine),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedDomaine = domaine),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1: return Colors.green;
      case 2: return Colors.blue;
      case 3: return Colors.orange;
      case 4: return Colors.deepOrange;
      case 5: return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getLevelIcon(int level) {
    switch (level) {
      case 1: return Icons.looks_one;
      case 2: return Icons.looks_two;
      case 3: return Icons.looks_3;
      case 4: return Icons.looks_4;
      case 5: return Icons.looks_5;
      default: return Icons.help;
    }
  }

  String _getLevelLabel(int level) {
    switch (level) {
      case 1: return 'Fondamental';
      case 2: return 'Intermédiaire';
      case 3: return 'Avancé';
      case 4: return 'Expert';
      case 5: return 'Maîtrise';
      default: return 'Inconnu';
    }
  }

  IconData _getNodeIcon(String type) {
    switch (type) {
      case 'lecon': return Icons.school;
      case 'concept': return Icons.lightbulb;
      case 'theoreme': return Icons.science;
      case 'chapitre': return Icons.book;
      default: return Icons.article;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'lecon': return const Color(0xFF1A237E);
      case 'concept': return Colors.purple;
      case 'theoreme': return Colors.teal;
      case 'chapitre': return Colors.indigo;
      default: return Colors.grey;
    }
  }
}
