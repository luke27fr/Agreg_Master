import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:convert';
import 'package:agreg_master/models/quiz_model.dart';
import 'package:agreg_master/pages/quiz_page.dart';

/// Custom builder for <glossary> tags that renders them as clickable links
class GlossaryElementBuilder extends MarkdownElementBuilder {
  final void Function(String term) onTap;
  final Color linkColor;
  
  GlossaryElementBuilder({required this.onTap, required this.linkColor});
  
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final term = element.attributes['term'] ?? '';
    final text = element.textContent;
    return GestureDetector(
      onTap: () => onTap(term),
      child: Text(
        text,
        style: TextStyle(
          color: linkColor,
          decoration: TextDecoration.underline,
          decorationColor: linkColor,
        ),
      ),
    );
  }
}

/// Custom inline syntax for <glossary> HTML tags
class GlossaryTagSyntax extends md.InlineSyntax {
  GlossaryTagSyntax() : super(r'<glossary term="([^"]+)">([^<]+)</glossary>');
  
  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final term = match.group(1)!;
    final text = match.group(2)!;
    final el = md.Element.text('glossary', text);
    el.attributes['term'] = term;
    parser.addNode(el);
    return true;
  }
}


/// Écran de lecture d'une fiche Markdown avec rendu LaTeX et style "Pièges à éviter".
class FichePage extends StatefulWidget {
  /// Chemin de l'asset .md (ex. assets/fiches/algebre/test.md).
  final String assetPath;

  const FichePage({super.key, required this.assetPath});

  @override
  State<FichePage> createState() => _FichePageState();
}

class _FichePageState extends State<FichePage> {
  // Variables d'état
  List<QuizQuestion> quizQuestions = [];
  Map<String, String> _glossaire = {};

  @override
  void initState() {
    super.initState();
    _loadContent();
    _loadQuiz();
    _loadGlossaire();
  }

  // Chargement du glossaire depuis JSON (81 définitions)
  Future<void> _loadGlossaire() async {
    try {
      final jsonString = await rootBundle.loadString('assets/glossaire.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      setState(() {
        _glossaire = data.map((k, v) => MapEntry(k.toString(), v.toString()));
      });
      print("✅ Glossaire chargé : ${_glossaire.length} définitions.");
    } catch (e) {
      print("❌ Erreur chargement glossaire : $e");
    }
  }

  // Normalisation des clés (accents, espaces, underscores)
  String _normalizeKey(String key) {
    String str = key.toLowerCase().trim();
    // Remplacer les espaces par des underscores (ou vice versa pour la recherche)
    str = str.replaceAll(' ', '_');
    // Normaliser les accents courants
    const withAccent = 'àáâãäåèéêëìíîïòóôõöùúûüçñ';
    const withoutAccent = 'aaaaaaeeeeiiiiooooouuuucn';
    for (int i = 0; i < withAccent.length; i++) {
      str = str.replaceAll(withAccent[i], withoutAccent[i]);
    }
    return str;
  }

  // 3. La fonction magique qui cherche le quiz
  Future<void> _loadQuiz() async {
    try {
      // A. On charge tout le fichier quiz.json
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);

      // B. On nettoie le nom du fichier pour avoir la "clé"
      // Ex: "assets/fiches/analyse/hilbert.md" deviendra juste "hilbert"
      String keyName = widget.assetPath.split('/').last.replaceAll('.md', '');

      // C. On vérifie si cette clé existe dans le JSON
      if (data.containsKey(keyName)) {
        // D. Si oui, on transforme les données JSON en objets QuizQuestion
        final List<dynamic> questionsJson = data[keyName];
        setState(() {
          quizQuestions = questionsJson
              .map((q) => QuizQuestion.fromJson(q))
              .toList();
        });
        print("Quiz trouvé pour $keyName : ${quizQuestions.length} questions.");
      } else {
        print("Aucun quiz trouvé pour $keyName");
      }
    } catch (e) {
      print("Erreur lors du chargement du quiz : $e");
    }
  }

  String _content = '';
  bool _loading = true;
  String? _error;

  Future<void> _loadContent() async {
    try {
      final content = await rootBundle.loadString(widget.assetPath);
      if (mounted) {
        setState(() {
          _content = content;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chargement...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        ),
      );
    }

    final fileName = widget.assetPath.split('/').last.replaceAll('.md', '');
    final title = _titleCase(fileName);

    // Découpage : blockquotes entiers (>) en un segment chacun, reste en texte/formules.
    final segments = _splitContentWithMath(_content);
    final styleSheet = _buildMarkdownStyleSheet(context);
    final bodyRows = _buildBodyRows(context, segments, styleSheet);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: bodyRows,
        ),
      ),
      floatingActionButton: quizQuestions.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      title: title,
                      questions: quizQuestions,
                    ),
                  ),
                );
              },
              label: const Text("S'entraîner"),
              icon: const Icon(Icons.psychology),
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
  /// Regroupe les segments en « lignes » : texte + formules inline dans un Wrap (fluide),
  /// formules $$ seules sur une ligne (bloc centré). Liste = bloc pleine largeur.
  static const double _wrapSpacing = 6.0;
  static const double _wrapRunSpacing = 2.0;
  static const double _paragraphSpacing = 10.0;

  List<Widget> _buildBodyRows(BuildContext context, List<dynamic> segments, MarkdownStyleSheet styleSheet) {
    final rows = <Widget>[];
    final run = <Map<String, String>>[];

    void addSpacing() {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: _paragraphSpacing));
    }

    void flushRun() {
      if (run.isEmpty) return;
      final children = run.map((s) => _segmentToWidget(context, s, styleSheet)).whereType<Widget>().toList();
      if (children.isEmpty) return;
      addSpacing();
      rows.add(Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: _wrapSpacing,
        runSpacing: _wrapRunSpacing,
        children: children,
      ));
      run.clear();
    }

    for (final item in segments) {
      if (item is Map<String, String> && item.containsKey(_keyBlockquote)) {
        flushRun();
        addSpacing();
        rows.add(_segmentToWidget(context, item, styleSheet));
        continue;
      }
      if (item is! List<Map<String, String>>) continue;
      final paragraph = item as List<Map<String, String>>;
      for (final seg in paragraph) {
        if (seg.containsKey(_keyBlock)) {
          flushRun();
          addSpacing();
          rows.add(_buildBlockFormula(seg[_keyBlock]!));
        } else if (seg.containsKey(_keyText)) {
          final text = seg[_keyText] ?? '';
          if (_isListContent(text)) {
            flushRun();
            addSpacing();
            rows.add(Align(
              alignment: Alignment.centerLeft,
              child: MarkdownBody(
              data: text,
              styleSheet: styleSheet,
              onTapLink: (text, href, title) => _showGlossaireDialog(context, href ?? ''),
            ),
            ));
          } else {
            run.add(seg);
          }
        } else {
          run.add(seg);
        }
      }
      flushRun();
    }
    if (rows.isNotEmpty && rows.last is SizedBox) rows.removeLast();
    return rows;
  }

  bool _isListContent(String text) {
    final trimmed = text.trimLeft();
    if (trimmed.startsWith('* ') || trimmed.startsWith('- ')) return true;
    return trimmed.contains(RegExp(r'\n\s*[\*\-]\s+'));
  }

  Widget _buildBlockFormula(String formula) {
    try {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Math.tex(
              formula,
              mathStyle: MathStyle.display,
              textStyle: const TextStyle(fontSize: 18, color: Color(0xFF1B365D)),
            ),
          ),
        ),
      );
    } catch (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Text(
            formula,
            style: const TextStyle(fontFamily: 'monospace', color: Colors.red, fontSize: 12),
          ),
        ),
      );
    }
  }

  void _showGlossaireDialog(BuildContext context, String href) {
    if (!href.startsWith('def:')) return;
    final rawTerm = href.substring(4).trim();
    final termLower = rawTerm.toLowerCase();
    final normalizedTerm = _normalizeKey(rawTerm);
    
    // Recherche 1 : exacte (lowercase)
    String? definition = _glossaire[termLower];
    
    // Recherche 2 : avec underscore (ex: "espace affine" -> "espace_affine")
    if (definition == null) {
      definition = _glossaire[termLower.replaceAll(' ', '_')];
    }
    
    // Recherche 3 : normalisée (sans accents, avec underscores)
    if (definition == null) {
      for (var entry in _glossaire.entries) {
        if (_normalizeKey(entry.key) == normalizedTerm) {
          definition = entry.value;
          break;
        }
      }
    }
    
    final title = rawTerm.isEmpty ? 'Glossaire' : rawTerm[0].toUpperCase() + (rawTerm.length > 1 ? rawTerm.substring(1) : '');
    
    final glossaireStyleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: const TextStyle(fontSize: 15, height: 1.5),
      code: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
    );
    
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: MarkdownBody(
            data: definition ?? 'Définition non trouvée pour « $rawTerm ».',
            styleSheet: glossaireStyleSheet,
            extensionSet: _markdownLatexExtensionSet,
            builders: _markdownLatexBuilders,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static const double _lineHeight = 1.5;

  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    final withHeight = base.copyWith(height: _lineHeight, fontFamily: base.fontFamily);
    return MarkdownStyleSheet(
      p: withHeight.copyWith(color: const Color(0xFF1B365D)),
      h1: base.copyWith(height: _lineHeight, fontWeight: FontWeight.bold, fontSize: 22),
      h2: base.copyWith(height: _lineHeight, fontWeight: FontWeight.bold, fontSize: 18),
      h3: base.copyWith(height: _lineHeight, fontWeight: FontWeight.w600, fontSize: 16),
      listBullet: withHeight,
      strong: withHeight.copyWith(fontWeight: FontWeight.bold),
      blockquoteDecoration: BoxDecoration(
        color: const Color(0xFFFFF5F0),
        border: Border(
          left: BorderSide(
            color: const Color(0xFFD84315),
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      blockquote: withHeight.copyWith(
        color: const Color(0xFFBF360C),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  /// Types de segments : texte, formule bloc/inline, ou blockquote entier.
  static const String _keyBlock = 'block';
  static const String _keyInline = 'inline';
  static const String _keyText = 'text';
  static const String _keyBlockquote = 'blockquote';

  /// Configuration LaTeX partagée pour tous les blocs (Note, Warning, Tip, Question de Jury).
  /// Garantit le rendu des formules $...$ et $$...$$ dans les blockquotes.
  /// Configuration LaTeX + GlossaryTag partagée pour tous les blocs.
  static md.ExtensionSet get _markdownLatexExtensionSet => md.ExtensionSet(
    [LatexBlockSyntax(), ...md.ExtensionSet.gitHubFlavored.blockSyntaxes],
    [GlossaryTagSyntax(), LatexInlineSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );
  static Map<String, MarkdownElementBuilder> get _markdownLatexBuilders => {'latex': LatexElementBuilder()};
  
  Map<String, MarkdownElementBuilder> _getBuilders(Color linkColor) => {
    'latex': LatexElementBuilder(),
    'glossary': GlossaryElementBuilder(
      onTap: (term) => _showGlossaireDialog(context, 'def:$term'),
      linkColor: linkColor,
    ),
  };

  /// Style d'un blockquote : balises GitHub ([!NOTE], [!WARNING], [!TIP], [!QUESTION]) puis mots-clés, sinon gris.
  ({Color accentColor, Color bgColor, String title, IconData icon}) _getBlockquoteStyle(String firstLine) {
    final lower = firstLine.toLowerCase();
    if (lower.contains('[!note]')) {
      return (accentColor: Colors.blue[800]!, bgColor: Colors.blue[50]!, title: 'Cours', icon: Icons.info);
    }
    if (lower.contains('[!warning]')) {
      return (accentColor: const Color(0xFFE65100), bgColor: const Color(0xFFFFF3E0), title: 'Pièges à éviter', icon: Icons.warning_amber_rounded);
    }
    if (lower.contains('[!tip]')) {
      return (accentColor: Colors.green[800]!, bgColor: Colors.green[50]!, title: 'Exercice', icon: Icons.lightbulb);
    }
    if (lower.contains('[!question]')) {
      return (accentColor: Colors.purple[800]!, bgColor: Colors.purple.shade50, title: 'Questions de Jury', icon: Icons.question_answer);
    }
    if (RegExp(r'définition|théorème|theorem|propriété|lemme|proposition').hasMatch(lower)) {
      return (accentColor: Colors.blue[800]!, bgColor: Colors.blue[50]!, title: 'Cours', icon: Icons.menu_book);
    }
    if (RegExp(r'exercice|exemple|correction|application').hasMatch(lower)) {
      return (accentColor: Colors.green[800]!, bgColor: Colors.green[50]!, title: 'Exercice', icon: Icons.assignment);
    }
    if (RegExp(r'pièges|attention|erreur').hasMatch(lower)) {
      return (accentColor: const Color(0xFFE65100), bgColor: const Color(0xFFFFF3E0), title: 'Pièges à éviter', icon: Icons.warning_amber_rounded);
    }
    return (accentColor: Colors.grey[800]!, bgColor: Colors.grey[50]!, title: 'Note', icon: Icons.format_quote);
  }

  /// Découpe le contenu : tout ce qui commence par > est un seul segment blockquote
  /// (jusqu’à ce qu’il n’y ait plus de lignes commençant par >). Le reste est
  /// découpé en texte / formules $$ et $.
  /// Retourne List<dynamic> : Map = blockquote, List<Map> = un paragraphe (segments).
  List<dynamic> _splitContentWithMath(String text) {
    final result = <dynamic>[];
    final lines = text.split('\n');
    int i = 0;

    while (i < lines.length) {
      final line = lines[i];
      if (line.trimLeft().startsWith('>')) {
        final blockquoteLines = <String>[];
        while (i < lines.length && lines[i].trimLeft().startsWith('>')) {
          blockquoteLines.add(lines[i]);
          i++;
        }
        if (blockquoteLines.isNotEmpty) {
          result.add({_keyBlockquote: blockquoteLines.join('\n')});
        }
        continue;
      }
      final normalLines = <String>[];
      while (i < lines.length && !lines[i].trimLeft().startsWith('>')) {
        normalLines.add(lines[i]);
        i++;
      }
      if (normalLines.isNotEmpty) {
        final normalContent = normalLines.join('\n');
        final paragraphs = normalContent.split(RegExp(r'\n\s*\n'));
        for (final para in paragraphs) {
          final trimmed = para.trim();
          if (trimmed.isEmpty) continue;
          final segs = <Map<String, String>>[];
          _addSegmentsFromContent(segs, trimmed);
          if (segs.isNotEmpty) result.add(segs);
        }
      }
    }
    return result;
  }

  /// Ajoute des segments texte / bloc / inline à partir d’un contenu (sans blockquote).
  void _addSegmentsFromContent(List<Map<String, String>> segments, String content) {
    int lastEnd = 0;
    final blockRegex = RegExp(r'\$\$([\s\S]*?)\$\$');
    for (final m in blockRegex.allMatches(content)) {
      if (m.start > lastEnd) {
        _addTextAndInlineMath(segments, content.substring(lastEnd, m.start));
      }
      final formula = m.group(1)?.trim() ?? '';
      if (formula.isNotEmpty) {
        segments.add({_keyBlock: formula});
      }
      lastEnd = m.end;
    }
    if (lastEnd < content.length) {
      _addTextAndInlineMath(segments, content.substring(lastEnd));
    }
  }

  void _addTextAndInlineMath(List<Map<String, String>> segments, String raw) {
    int last = 0;
    final inlineRegex = RegExp(r'\$([^$\n\r]+)\$');
    for (final m in inlineRegex.allMatches(raw)) {
      if (m.start > last) {
        final part = raw.substring(last, m.start);
        if (part.trim().isNotEmpty) {
          segments.add({_keyText: part});
        }
      }
      final formula = m.group(1)?.trim() ?? '';
      if (formula.isNotEmpty) {
        segments.add({_keyInline: formula});
      }
      last = m.end;
    }
    if (last < raw.length) {
      final part = raw.substring(last);
      if (part.trim().isNotEmpty) {
        segments.add({_keyText: part});
      }
    }
  }

  /// Regroupe les segments consécutifs qui font partie du même blockquote (>).
  /// Dès qu’un segment texte commence par « > », on collecte tous les segments
  /// suivants (texte + formules) jusqu’à un paragraphe suivant (\n\n non suivi de >).
  /// Chaque groupe est ensuite rendu dans un seul Container Pièges.

  /// Un seul bandeau orange par section Pièges : contenu = tout le blockquote (avec > et LaTeX).
  /// À l’intérieur : Column de MarkdownBody (texte, listes *) et Math.tex (formules).
  /// Bâtit un blockquote avec style déterminé par mots-clés de la première ligne.
  /// Utilise MarkdownBody standard (avec LaTeX) pour éviter les chevauchements de listes.
  Widget _buildBlockquoteContainer(String rawContent, BuildContext context) {
    final stripped = _stripBlockquotePrefix(rawContent);
    final lines = stripped.split('\n');
    final firstLine = lines.isNotEmpty ? lines.first.trim() : '';
    final style = _getBlockquoteStyle(firstLine);
    final content = _stripBlockquoteLabel(stripped);
    if (content.trim().isEmpty) return const SizedBox.shrink();
    return _buildAdmonitionContainer(
      context: context,
      content: content,
      accentColor: style.accentColor,
      bgColor: style.bgColor,
      title: style.title,
      icon: style.icon,
    );
  }

  /// Helper commun pour tous les blockquotes (Note, Warning, Tip, Question de Jury) :
  /// MarkdownBody avec extensionSet + builders LaTeX identiques pour tous les blocs.
  Widget _buildAdmonitionContainer({
    required BuildContext context,
    required String content,
    required Color accentColor,
    required Color bgColor,
    required String title,
    required IconData icon,
  }) {
    // Pre-process: Convert def: links to use <glossary> custom tag to avoid LaTeX interference
    String processedContent = content.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\(def:([^\)]+)\)'),
      (match) => '<glossary term="${match.group(2)}">${match.group(1)}</glossary>',
    );
    
    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      blockSpacing: 4.0,
      listIndent: 20.0,
      p: TextStyle(height: 1.3, color: accentColor, fontSize: 14),
      listBullet: TextStyle(color: accentColor, fontSize: 14),
      strong: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 14, height: 1.3),
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.12), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: processedContent,
              styleSheet: styleSheet,
              extensionSet: _markdownLatexExtensionSet,
              builders: _getBuilders(accentColor),
              onTapLink: (text, href, title) => _showGlossaireDialog(context, href ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  /// Supprime la première ligne si elle contient une balise GitHub ou un mot-clé d'admonition.
  /// Si le blockquote ne fait qu'une ligne (ex: "> [!NOTE] Formellement : ..."), on enlève seulement le tag et on garde le texte.
  String _stripBlockquoteLabel(String content) {
    final lines = content.split('\n');
    if (lines.isEmpty) return content;
    final first = lines.first.trim();
    final firstLower = first.toLowerCase();
    final hasTag = firstLower.contains('[!note]') || firstLower.contains('[!warning]') || firstLower.contains('[!tip]') || firstLower.contains('[!question]');
    final hasKeyword = RegExp(r'définition|théorème|theorem|propriété|lemme|proposition|exercice|exemple|correction|application|pièges|attention|erreur').hasMatch(firstLower) ||
        firstLower.contains('[!theorem]');
    if ((hasTag || hasKeyword) && lines.length > 1) return lines.sublist(1).join('\n').trim();
    if ((hasTag || hasKeyword) && lines.length == 1) return _stripTagFromFirstLine(first);
    return content;
  }

  /// Enlève le tag [!NOTE], [!WARNING], etc. du début d'une ligne (pour blockquote sur une seule ligne).
  String _stripTagFromFirstLine(String line) {
    final stripped = line.replaceFirst(
      RegExp(r'\[\!\s*(?:note|warning|tip|question)\s*\]\s*', caseSensitive: false),
      '',
    );
    return stripped.trim();
  }

  /// Découpe le contenu d’un blockquote en parties texte / formule bloc / formule inline.
  List<Map<String, String?>> _parseBlockquoteContent(String content) {
    final parts = <Map<String, String?>>[];
    int lastEnd = 0;
    final blockRegex = RegExp(r'\$\$([\s\S]*?)\$\$');
    for (final m in blockRegex.allMatches(content)) {
      if (m.start > lastEnd) {
        _addBlockquoteTextAndInline(parts, content.substring(lastEnd, m.start));
      }
      final formula = m.group(1)?.trim() ?? '';
      if (formula.isNotEmpty) parts.add({'block': formula});
      lastEnd = m.end;
    }
    if (lastEnd < content.length) {
      _addBlockquoteTextAndInline(parts, content.substring(lastEnd));
    }
    return parts;
  }

  void _addBlockquoteTextAndInline(List<Map<String, String?>> parts, String raw) {
    int last = 0;
    final inlineRegex = RegExp(r'\$([^$\n\r]+)\$');
    for (final m in inlineRegex.allMatches(raw)) {
      if (m.start > last) {
        final t = raw.substring(last, m.start).trim();
        if (t.isNotEmpty) parts.add({'text': t});
      }
      final formula = m.group(1)?.trim() ?? '';
      if (formula.isNotEmpty) parts.add({'inline': formula});
      last = m.end;
    }
    if (last < raw.length) {
      final t = raw.substring(last).trim();
      if (t.isNotEmpty) parts.add({'text': t});
    }
  }

  Widget _segmentToWidget(BuildContext context, Map<String, String> segment, MarkdownStyleSheet styleSheet) {
    if (segment.containsKey(_keyBlockquote)) {
      return _buildBlockquoteContainer(segment[_keyBlockquote]!, context);
    }
    if (segment.containsKey(_keyBlock)) {
      final formula = segment[_keyBlock]!;
      try {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Math.tex(
            formula,
            mathStyle: MathStyle.display,
            textStyle: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1B365D),
            ),
          ),
        );
      } catch (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            formula,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        );
      }
    }
    if (segment.containsKey(_keyInline)) {
      final formula = segment[_keyInline]!;
      try {
        return Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Math.tex(
            formula,
            mathStyle: MathStyle.text,
            textStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1B365D),
            ),
          ),
        );
      } catch (_) {
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            formula,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        );
      }
    }
    final text = segment[_keyText] ?? '';
    if (text.isEmpty) return const SizedBox.shrink();
    return MarkdownBody(
      data: text,
      styleSheet: styleSheet,
      onTapLink: (text, href, title) => _showGlossaireDialog(context, href ?? ''),
    );
  }

  /// Enlève tous les préfixes « > » en début de ligne pour le contenu déjà
  /// dans l’encadré Pièges (évite d’afficher des « > » en trop).
  String _stripBlockquotePrefix(String text) {
    return text.split('\n').map((line) {
      final trimmed = line.trimLeft();
      if (trimmed.isEmpty) return line;
      if (trimmed.startsWith('>')) {
        final after = trimmed.substring(1).trimLeft();
        return after.isEmpty ? '' : after;
      }
      return line;
    }).join('\n').trim();
  }
}
