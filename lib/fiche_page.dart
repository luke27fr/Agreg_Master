import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Écran de lecture d'une fiche Markdown avec rendu LaTeX et style "Pièges à éviter".
class FichePage extends StatefulWidget {
  /// Chemin de l'asset .md (ex. assets/fiches/algebre/test.md).
  final String assetPath;

  const FichePage({super.key, required this.assetPath});

  @override
  State<FichePage> createState() => _FichePageState();
}

class _FichePageState extends State<FichePage> {
  String _content = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

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
    final styleSheet = _buildMarkdownStyleSheet();
    final bodyRows = _buildBodyRows(segments, styleSheet);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: bodyRows,
        ),
      ),
    );
  }

  /// Regroupe les segments en « lignes » : texte + formules inline dans un Wrap (fluide),
  /// formules $$ seules sur une ligne (bloc centré). Liste = bloc pleine largeur.
  static const double _wrapSpacing = 6.0;
  static const double _wrapRunSpacing = 2.0;
  static const double _paragraphSpacing = 10.0;

  List<Widget> _buildBodyRows(List<dynamic> segments, MarkdownStyleSheet styleSheet) {
    final rows = <Widget>[];
    final run = <Map<String, String>>[];

    void addSpacing() {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: _paragraphSpacing));
    }

    void flushRun() {
      if (run.isEmpty) return;
      final children = run.map((s) => _segmentToWidget(s, styleSheet)).whereType<Widget>().toList();
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
        rows.add(_segmentToWidget(item, styleSheet));
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
              child: MarkdownBody(data: text, styleSheet: styleSheet),
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

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet() {
    return MarkdownStyleSheet(
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
      blockquote: const TextStyle(
        color: Color(0xFFBF360C),
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
  Widget _buildPiegesContainerFromContent(String rawContent) {
    final content = _stripBlockquotePrefix(rawContent);
    if (content.trim().isEmpty) return const SizedBox.shrink();
    final parts = _parseBlockquoteContent(content);
    if (parts.isEmpty) return const SizedBox.shrink();

    final piegesStyleSheet = MarkdownStyleSheet(
      p: const TextStyle(color: Color(0xFFBF360C), fontSize: 14),
      listBullet: const TextStyle(color: Color(0xFFBF360C), fontSize: 14),
      strong: const TextStyle(
        color: Color(0xFFBF360C),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    final columnChildren = <Widget>[];
    final run = <Widget>[];

    void flushRun() {
      if (run.isEmpty) return;
      columnChildren.add(Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: _wrapSpacing,
        runSpacing: _wrapRunSpacing,
        children: run.toList(),
      ));
      run.clear();
    }

    for (final part in parts) {
      if (part['block'] != null) {
        flushRun();
        final formula = part['block']!;
        try {
          columnChildren.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Math.tex(
                  formula,
                  mathStyle: MathStyle.display,
                  textStyle: const TextStyle(fontSize: 16, color: Color(0xFF1B365D)),
                ),
              ),
            ),
          ));
        } catch (_) {
          columnChildren.add(Center(child: Text(formula, style: const TextStyle(fontFamily: 'monospace', color: Colors.red, fontSize: 12))));
        }
      } else if (part['inline'] != null) {
        final formula = part['inline']!;
        try {
          run.add(Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Math.tex(
              formula,
              mathStyle: MathStyle.text,
              textStyle: const TextStyle(fontSize: 14, color: Color(0xFF1B365D)),
            ),
          ));
        } catch (_) {
          run.add(Text(formula, style: const TextStyle(fontFamily: 'monospace', color: Colors.red, fontSize: 12)));
        }
      } else if (part['text'] != null && (part['text'] as String).trim().isNotEmpty) {
        final text = part['text'] as String;
        if (_isListContent(text)) {
          flushRun();
          columnChildren.add(Align(
            alignment: Alignment.centerLeft,
            child: MarkdownBody(data: text, styleSheet: piegesStyleSheet),
          ));
        } else {
          run.add(MarkdownBody(
            data: text,
            styleSheet: piegesStyleSheet,
          ));
        }
      }
    }
    flushRun();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE65100), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFE65100),
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pièges à éviter',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: columnChildren,
            ),
          ),
        ],
      ),
    );
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

  Widget _segmentToWidget(Map<String, String> segment, MarkdownStyleSheet styleSheet) {
    if (segment.containsKey(_keyBlockquote)) {
      return _buildPiegesContainerFromContent(segment[_keyBlockquote]!);
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
