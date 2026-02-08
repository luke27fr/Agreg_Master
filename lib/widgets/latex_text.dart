import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../services/latex_helper.dart' as latex;

/// Widget réutilisable pour afficher du texte avec des formules LaTeX.
///
/// Gère :
/// - `$$...$$` : formules en mode display (centrées, sur leur propre ligne)
/// - `$...$`  : formules inline (dans le flux du texte)
/// - `**...**` : texte en gras
/// - `\n`     : retours à la ligne
///
/// Utilise [Math.tex] de flutter_math_fork pour un rendu fiable des maths.
class LatexText extends StatelessWidget {
  /// Le texte brut (peut contenir Unicode ou LaTeX natif).
  final String data;

  /// Style de base du texte.
  final TextStyle? style;

  /// Si true, le texte est sélectionnable.
  final bool selectable;

  const LatexText({
    super.key,
    required this.data,
    this.style,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.trim().isEmpty) return const SizedBox.shrink();

    // Convertir les symboles Unicode en LaTeX si nécessaire
    final processed = latex.toLatex(data);
    final blocks = _splitIntoBlocks(processed);

    if (blocks.isEmpty) return const SizedBox.shrink();

    // Un seul bloc texte → rendu simple
    if (blocks.length == 1 && !blocks[0].isDisplayMath) {
      return _buildParagraph(blocks[0].content, context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: blocks.map((block) {
        if (block.isDisplayMath) {
          return _buildDisplayMath(block.content, context);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: _buildParagraph(block.content, context),
        );
      }).toList(),
    );
  }

  /// Découpe le texte en blocs : display math ($$...$$) et texte normal.
  /// Le texte normal est aussi découpé par \n.
  List<_Block> _splitIntoBlocks(String text) {
    final blocks = <_Block>[];
    final regex = RegExp(r'\$\$([\s\S]*?)\$\$');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        _addTextBlocks(blocks, text.substring(lastEnd, match.start));
      }
      final formula = match.group(1)?.trim() ?? '';
      if (formula.isNotEmpty) {
        blocks.add(_Block(content: formula, isDisplayMath: true));
      }
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      _addTextBlocks(blocks, text.substring(lastEnd));
    }

    return blocks.isEmpty
        ? [_Block(content: text, isDisplayMath: false)]
        : blocks;
  }

  /// Ajoute des blocs texte en découpant par les sauts de ligne.
  void _addTextBlocks(List<_Block> blocks, String text) {
    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        blocks.add(_Block(content: trimmed, isDisplayMath: false));
      }
    }
  }

  /// Rendu d'une formule en mode display (centrée).
  Widget _buildDisplayMath(String formula, BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            formula,
            mathStyle: MathStyle.display,
            textStyle: effectiveStyle.copyWith(
              fontSize: (effectiveStyle.fontSize ?? 14) + 2,
            ),
            onErrorFallback: (_) => Text(
              formula,
              style: effectiveStyle.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ),
    );
  }

  /// Rendu d'un paragraphe avec du texte et des maths inline.
  Widget _buildParagraph(String text, BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final spans = _parseInlineSpans(text, effectiveStyle);

    if (selectable) {
      return SelectableText.rich(
        TextSpan(children: spans),
        style: effectiveStyle,
      );
    }
    return Text.rich(
      TextSpan(children: spans),
      style: effectiveStyle,
    );
  }

  /// Parse le texte pour extraire les $...$ (inline math) et **...** (gras).
  List<InlineSpan> _parseInlineSpans(String text, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    int i = 0;
    final buf = StringBuffer();

    while (i < text.length) {
      // ── Inline math $...$ ──
      if (text[i] == '\$') {
        // Chercher le $ fermant
        final closeIdx = text.indexOf('\$', i + 1);
        if (closeIdx == -1) {
          // Pas de $ fermant → traiter comme texte
          buf.write(text[i]);
          i++;
          continue;
        }

        // Vider le buffer texte
        if (buf.isNotEmpty) {
          spans.add(TextSpan(text: buf.toString(), style: baseStyle));
          buf.clear();
        }

        final formula = text.substring(i + 1, closeIdx).trim();
        if (formula.isNotEmpty) {
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              formula,
              mathStyle: MathStyle.text,
              textStyle: baseStyle,
              onErrorFallback: (_) => Text(
                formula,
                style: baseStyle.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ));
        }
        i = closeIdx + 1;
        continue;
      }

      // ── Gras **...** ──
      if (i + 1 < text.length && text[i] == '*' && text[i + 1] == '*') {
        final closeIdx = text.indexOf('**', i + 2);
        if (closeIdx == -1) {
          buf.write('**');
          i += 2;
          continue;
        }

        if (buf.isNotEmpty) {
          spans.add(TextSpan(text: buf.toString(), style: baseStyle));
          buf.clear();
        }

        final boldContent = text.substring(i + 2, closeIdx);
        // Le contenu gras peut aussi contenir des maths
        final innerSpans = _parseInlineSpans(boldContent,
            baseStyle.copyWith(fontWeight: FontWeight.bold));
        spans.addAll(innerSpans);
        i = closeIdx + 2;
        continue;
      }

      buf.write(text[i]);
      i++;
    }

    if (buf.isNotEmpty) {
      spans.add(TextSpan(text: buf.toString(), style: baseStyle));
    }

    return spans;
  }
}

class _Block {
  final String content;
  final bool isDisplayMath;
  const _Block({required this.content, required this.isDisplayMath});
}
