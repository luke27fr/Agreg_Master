import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

/// Note personnelle pour une fiche
class PersonalNote {
  final String content;
  final DateTime lastModified;

  PersonalNote({required this.content, required this.lastModified});

  Map<String, dynamic> toJson() => {
    'content': content,
    'lastModified': lastModified.toIso8601String(),
  };

  factory PersonalNote.fromJson(Map<String, dynamic> json) => PersonalNote(
    content: json['content'] as String,
    lastModified: DateTime.parse(json['lastModified'] as String),
  );
}

/// Service singleton pour gérer les notes personnelles
class NotesService extends ChangeNotifier {
  static final NotesService _instance = NotesService._internal();
  factory NotesService() => _instance;
  NotesService._internal();

  final Map<String, PersonalNote> _notes = {};
  bool _isLoaded = false;

  Map<String, PersonalNote> get notes => Map.unmodifiable(_notes);
  bool get isLoaded => _isLoaded;

  /// Charge les notes depuis le fichier local
  Future<void> loadNotes() async {
    if (_isLoaded) return;
    
    try {
      final content = await StorageService.instance.read('agreg_master_notes.json');
      if (content != null) {
        final Map<String, dynamic> data = jsonDecode(content);
        _notes.clear();
        data.forEach((key, value) {
          _notes[key] = PersonalNote.fromJson(value as Map<String, dynamic>);
        });
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement notes: $e');
      _isLoaded = true;
    }
  }

  /// Récupère la note d'une fiche
  PersonalNote? getNote(String ficheId) => _notes[ficheId];

  /// Vérifie si une fiche a une note
  bool hasNote(String ficheId) => _notes.containsKey(ficheId) && _notes[ficheId]!.content.isNotEmpty;

  /// Sauvegarde une note pour une fiche
  Future<void> saveNote(String ficheId, String content) async {
    if (content.trim().isEmpty) {
      _notes.remove(ficheId);
    } else {
      _notes[ficheId] = PersonalNote(
        content: content,
        lastModified: DateTime.now(),
      );
    }
    notifyListeners();
    await _persistNotes();
  }

  /// Supprime la note d'une fiche
  Future<void> deleteNote(String ficheId) async {
    if (_notes.remove(ficheId) != null) {
      notifyListeners();
      await _persistNotes();
    }
  }

  Future<void> _persistNotes() async {
    try {
      final data = _notes.map((key, value) => MapEntry(key, value.toJson()));
      await StorageService.instance.write('agreg_master_notes.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde notes: $e');
    }
  }
}
