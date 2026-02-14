import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'storage_service.dart';
import '../models/structured_notes_model.dart';

// Conditional imports for PDF file export (mobile only)
import 'storage_io_helper.dart' if (dart.library.html) 'storage_web_helper.dart' as io_helper;

class StructuredNotesService extends ChangeNotifier {
  static final StructuredNotesService _instance = StructuredNotesService._internal();
  factory StructuredNotesService() => _instance;
  StructuredNotesService._internal();

  List<StructuredNote> _notes = [];

  List<StructuredNote> get notes => _notes;
  List<StructuredNote> get favorites => _notes.where((n) => n.isFavorite).toList();

  /// Crée une nouvelle note
  Future<StructuredNote> createNote({
    required String titre,
    required String contenu,
    List<String>? tags,
    String? leconId,
    String? domaine,
    String categorie = 'remarque',
  }) async {
    final note = StructuredNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      titre: titre,
      dateCreation: DateTime.now(),
      dateModification: DateTime.now(),
      contenu: contenu,
      tags: tags ?? [],
      leconId: leconId,
      domaine: domaine,
      categorie: categorie,
    );

    _notes.insert(0, note);
    await _saveNotes();
    notifyListeners();
    
    return note;
  }

  /// Met à jour une note
  Future<void> updateNote(String noteId, {
    String? titre,
    String? contenu,
    List<String>? tags,
    bool? isFavorite,
  }) async {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        titre: titre,
        contenu: contenu,
        tags: tags,
        isFavorite: isFavorite,
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  /// Supprime une note
  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
    await _saveNotes();
    notifyListeners();
  }

  /// Recherche de notes
  List<StructuredNote> searchNotes(String query) {
    if (query.isEmpty) return _notes;
    
    final lowerQuery = query.toLowerCase();
    return _notes.where((note) {
      return note.titre.toLowerCase().contains(lowerQuery) ||
             note.contenu.toLowerCase().contains(lowerQuery) ||
             note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Filtre par catégorie
  List<StructuredNote> getNotesByCategory(String category) {
    return _notes.where((n) => n.categorie == category).toList();
  }

  /// Filtre par domaine
  List<StructuredNote> getNotesByDomaine(String domaine) {
    return _notes.where((n) => n.domaine == domaine).toList();
  }

  /// Exporte une note en Markdown
  String exportToMarkdown(StructuredNote note) {
    final buffer = StringBuffer();
    buffer.writeln('# ${note.titre}');
    buffer.writeln();
    buffer.writeln('**Date:** ${_formatDate(note.dateCreation)}');
    
    if (note.domaine != null) {
      buffer.writeln('**Domaine:** ${note.domaine}');
    }
    
    if (note.leconId != null) {
      buffer.writeln('**Leçon:** ${note.leconId}');
    }
    
    if (note.tags.isNotEmpty) {
      buffer.writeln('**Tags:** ${note.tags.join(', ')}');
    }
    
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln(note.contenu);
    
    return buffer.toString();
  }

  /// Exporte une note en PDF. Returns file path on mobile, null on web.
  Future<String?> exportToPDF(StructuredNote note) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                note.titre,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Date: ${_formatDate(note.dateCreation)}'),
              if (note.domaine != null)
                pw.Text('Domaine: ${note.domaine}'),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 16),
              pw.Text(note.contenu),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    return io_helper.savePdfFile('note_${note.id}.pdf', bytes);
  }

  // Persistance
  Future<void> loadData() async {
    try {
      final content = await StorageService.instance.read('structured_notes.json');
      if (content != null) {
        final data = jsonDecode(content) as List<dynamic>;
        _notes = data
            .map((e) => StructuredNote.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement notes: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final data = _notes.map((e) => e.toJson()).toList();
      await StorageService.instance.write('structured_notes.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde notes: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
