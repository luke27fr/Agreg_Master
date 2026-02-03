import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:share_plus/share_plus.dart';
import '../services/structured_notes_service.dart';
import '../models/structured_notes_model.dart';

class StructuredNotesPage extends StatefulWidget {
  const StructuredNotesPage({super.key});

  @override
  State<StructuredNotesPage> createState() => _StructuredNotesPageState();
}

class _StructuredNotesPageState extends State<StructuredNotesPage> with SingleTickerProviderStateMixin {
  final StructuredNotesService _service = StructuredNotesService();
  late TabController _tabController;
  String _searchQuery = '';

  static md.ExtensionSet get _latexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _service.addListener(_onDataChanged);
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
        title: const Text('Mes Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Toutes', icon: Icon(Icons.note)),
            Tab(text: 'Favoris', icon: Icon(Icons.star)),
            Tab(text: 'Par catégorie', icon: Icon(Icons.category)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher dans vos notes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesTab(_service.searchNotes(_searchQuery), isDark),
                _buildNotesTab(_service.favorites, isDark),
                _buildCategoriesTab(isDark),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNoteDialog(),
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle note'),
      ),
    );
  }

  Widget _buildNotesTab(List<StructuredNote> notes, bool isDark) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aucune note',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(notes[index], isDark);
      },
    );
  }

  Widget _buildNoteCard(StructuredNote note, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(
          _getCategoryIcon(note.categorie),
          color: _getCategoryColor(note.categorie),
        ),
        title: Text(
          note.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _formatDate(note.dateModification),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (note.tags.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                children: note.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.isFavorite)
              const Icon(Icons.star, color: Colors.amber, size: 20),
            const Icon(Icons.chevron_right),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: note.contenu,
                  extensionSet: _latexExtensionSet,
                  builders: {'latex': LatexElementBuilder()},
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        note.isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => _service.updateNote(
                        note.id,
                        isFavorite: !note.isFavorite,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditNoteDialog(note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _exportNote(note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(note),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(bool isDark) {
    final categories = ['cours', 'exercice', 'developpement', 'remarque', 'astuce'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = _service.getNotesByCategory(category).length;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(_getCategoryIcon(category), color: _getCategoryColor(category)),
            title: Text(
              category.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: _getCategoryColor(category),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => _showCategoryNotes(category),
          ),
        );
      },
    );
  }

  void _showCreateNoteDialog() {
    final titreController = TextEditingController();
    final contenuController = TextEditingController();
    String selectedCategory = 'remarque';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvelle note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titreController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                  items: ['cours', 'exercice', 'developpement', 'remarque', 'astuce']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contenuController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Contenu (Markdown + LaTeX)',
                    hintText: 'Utilisez \\$formule\\$ pour LaTeX inline\net \\$\\$formule\\$\\$ pour bloc',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titreController.text.isNotEmpty && contenuController.text.isNotEmpty) {
                  _service.createNote(
                    titre: titreController.text,
                    contenu: contenuController.text,
                    categorie: selectedCategory,
                  );
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(StructuredNote note) {
    // Similar to create dialog but with existing data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Édition à implémenter')),
    );
  }

  void _showCategoryNotes(String category) {
    final notes = _service.getNotesByCategory(category);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(category.toUpperCase())),
          body: _buildNotesTab(notes, Theme.of(context).brightness == Brightness.dark),
        ),
      ),
    );
  }

  Future<void> _exportNote(StructuredNote note) async {
    try {
      final markdown = _service.exportToMarkdown(note);
      await Share.share(markdown, subject: note.titre);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'export')),
        );
      }
    }
  }

  void _confirmDelete(StructuredNote note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette note ?'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${note.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _service.deleteNote(note.id);
              Navigator.pop(ctx);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cours': return Icons.school;
      case 'exercice': return Icons.fitness_center;
      case 'developpement': return Icons.science;
      case 'remarque': return Icons.comment;
      case 'astuce': return Icons.lightbulb;
      default: return Icons.note;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'cours': return Colors.blue;
      case 'exercice': return Colors.green;
      case 'developpement': return Colors.purple;
      case 'remarque': return Colors.orange;
      case 'astuce': return Colors.amber;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
