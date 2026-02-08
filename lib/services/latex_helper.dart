/// Service de conversion Unicode → LaTeX pour le rendu mathématique.
///
/// Convertit les cas les plus importants :
/// - Indices/exposants Unicode (fₙ → $f_n$, x² → $x^2$)
/// - Ensembles blackboard bold (ℝ → $\mathbb{R}$)
/// - Lettres grecques (λ → $\lambda$)
/// - Indicatrices (𝟙 → $\mathbf{1}$)
///
/// Les symboles Unicode lisibles (∈, ≤, ≥, →, ⟹, etc.) sont conservés
/// tels quels car ils sont déjà bien rendus en texte.
library;

/// Convertit une chaîne contenant du texte mathématique Unicode en LaTeX.
String toLatex(String text) {
  if (text.isEmpty) return text;
  // Si déjà du LaTeX, ne pas retraiter
  if (text.contains('\$')) return text;

  String result = _convertUnicode(text);
  result = _mergeAdjacentMath(result);
  return result;
}

/// Phase 1 : conversion Unicode → LaTeX token par token.
String _convertUnicode(String text) {
  final buf = StringBuffer();
  final runes = text.runes.toList();
  int i = 0;

  while (i < runes.length) {
    final ch = String.fromCharCode(runes[i]);

    // ── Exposants Unicode ──
    if (_sup.containsKey(ch)) {
      final prefix = _backtrackVar(buf);
      String s = '';
      while (i < runes.length &&
          _sup.containsKey(String.fromCharCode(runes[i]))) {
        s += _sup[String.fromCharCode(runes[i])]!;
        i++;
      }
      // Consommer aussi les indices qui suivent directement
      String sub = '';
      while (i < runes.length &&
          _sub.containsKey(String.fromCharCode(runes[i]))) {
        sub += _sub[String.fromCharCode(runes[i])]!;
        i++;
      }
      final supPart = s.length > 1 ? '^{$s}' : '^$s';
      final subPart =
          sub.isNotEmpty ? (sub.length > 1 ? '_{$sub}' : '_$sub') : '';
      buf.write('\$${prefix}$supPart$subPart\$');
      continue;
    }

    // ── Indices Unicode ──
    if (_sub.containsKey(ch)) {
      final prefix = _backtrackVar(buf);
      String s = '';
      while (i < runes.length &&
          _sub.containsKey(String.fromCharCode(runes[i]))) {
        s += _sub[String.fromCharCode(runes[i])]!;
        i++;
      }
      // Consommer aussi les exposants qui suivent directement
      String sup = '';
      while (i < runes.length &&
          _sup.containsKey(String.fromCharCode(runes[i]))) {
        sup += _sup[String.fromCharCode(runes[i])]!;
        i++;
      }
      final subPart = s.length > 1 ? '_{$s}' : '_$s';
      final supPart =
          sup.isNotEmpty ? (sup.length > 1 ? '^{$sup}' : '^$sup') : '';
      buf.write('\$${prefix}$subPart$supPart\$');
      continue;
    }

    // ── Ensembles blackboard bold ──
    if (_bb.containsKey(ch)) {
      buf.write('\$${_bb[ch]}\$');
      i++;
      continue;
    }

    // ── Indicatrice 𝟙 ──
    if (ch == '𝟙') {
      buf.write(r'$\mathbf{1}$');
      i++;
      continue;
    }

    // ── Lettres grecques ──
    if (_greek.containsKey(ch)) {
      final cmd = _greek[ch]!;
      i++;
      // Consommer indices/exposants qui suivent immédiatement
      String sub = '';
      String sup = '';
      while (i < runes.length) {
        final next = String.fromCharCode(runes[i]);
        if (_sub.containsKey(next)) {
          while (i < runes.length &&
              _sub.containsKey(String.fromCharCode(runes[i]))) {
            sub += _sub[String.fromCharCode(runes[i])]!;
            i++;
          }
        } else if (_sup.containsKey(next)) {
          while (i < runes.length &&
              _sup.containsKey(String.fromCharCode(runes[i]))) {
            sup += _sup[String.fromCharCode(runes[i])]!;
            i++;
          }
        } else {
          break;
        }
      }
      final subPart =
          sub.isNotEmpty ? (sub.length > 1 ? '_{$sub}' : '_$sub') : '';
      final supPart =
          sup.isNotEmpty ? (sup.length > 1 ? '^{$sup}' : '^$sup') : '';
      buf.write('\$$cmd$subPart$supPart\$');
      continue;
    }

    // ── Intégrale ∫ avec bornes ──
    if (ch == '∫') {
      i++;
      String lower = '';
      String upper = '';
      // Bornes inférieures (indices unicode)
      while (i < runes.length &&
          _sub.containsKey(String.fromCharCode(runes[i]))) {
        lower += _sub[String.fromCharCode(runes[i])]!;
        i++;
      }
      // Borne inférieure ASCII : _a ou _{...}
      if (lower.isEmpty &&
          i < runes.length &&
          String.fromCharCode(runes[i]) == '_') {
        i++; // skip _
        if (i < runes.length) {
          if (String.fromCharCode(runes[i]) == '{') {
            i++; // skip {
            while (i < runes.length &&
                String.fromCharCode(runes[i]) != '}') {
              lower += String.fromCharCode(runes[i]);
              i++;
            }
            if (i < runes.length) i++; // skip }
          } else {
            lower = String.fromCharCode(runes[i]);
            i++;
          }
        }
      }
      // Bornes supérieures (exposants unicode)
      while (i < runes.length &&
          _sup.containsKey(String.fromCharCode(runes[i]))) {
        upper += _sup[String.fromCharCode(runes[i])]!;
        i++;
      }
      // Borne supérieure ASCII : ^b ou ^{...} ou ^(...)
      if (upper.isEmpty &&
          i < runes.length &&
          String.fromCharCode(runes[i]) == '^') {
        i++; // skip ^
        if (i < runes.length) {
          final nc = String.fromCharCode(runes[i]);
          if (nc == '{') {
            i++;
            while (i < runes.length &&
                String.fromCharCode(runes[i]) != '}') {
              upper += String.fromCharCode(runes[i]);
              i++;
            }
            if (i < runes.length) i++;
          } else if (nc == '(') {
            i++;
            while (i < runes.length &&
                String.fromCharCode(runes[i]) != ')') {
              upper += String.fromCharCode(runes[i]);
              i++;
            }
            if (i < runes.length) i++;
          } else {
            upper = nc;
            i++;
          }
        }
      }
      final lowerPart = lower.isNotEmpty
          ? (lower.length > 1 ? '_{$lower}' : '_$lower')
          : '';
      final upperPart = upper.isNotEmpty
          ? (upper.length > 1 ? '^{$upper}' : '^$upper')
          : '';
      buf.write('\$\\int$lowerPart$upperPart\$');
      continue;
    }

    // ── Somme ∑ avec bornes ──
    if (ch == '∑') {
      i++;
      String expr = '\\sum';
      // Consommer _{...} notation ASCII
      if (i < runes.length && String.fromCharCode(runes[i]) == '_') {
        i++; // skip _
        if (i < runes.length && String.fromCharCode(runes[i]) == '{') {
          expr += '_{';
          i++; // skip {
          while (i < runes.length && String.fromCharCode(runes[i]) != '}') {
            expr += String.fromCharCode(runes[i]);
            i++;
          }
          if (i < runes.length) {
            expr += '}';
            i++; // skip }
          }
        } else if (i < runes.length) {
          // _x (single char subscript)
          expr += '_${String.fromCharCode(runes[i])}';
          i++;
        }
      }
      // Consommer indices unicode comme bornes
      else {
        String sub = '';
        while (i < runes.length &&
            _sub.containsKey(String.fromCharCode(runes[i]))) {
          sub += _sub[String.fromCharCode(runes[i])]!;
          i++;
        }
        if (sub.isNotEmpty) {
          expr += sub.length > 1 ? '_{$sub}' : '_$sub';
        }
      }
      // Consommer exposants unicode comme borne supérieure
      String sup = '';
      while (i < runes.length &&
          _sup.containsKey(String.fromCharCode(runes[i]))) {
        sup += _sup[String.fromCharCode(runes[i])]!;
        i++;
      }
      if (sup.isNotEmpty) {
        expr += sup.length > 1 ? '^{$sup}' : '^$sup';
      }
      // Borne supérieure ASCII : ^n ou ^{...}
      if (sup.isEmpty &&
          i < runes.length &&
          String.fromCharCode(runes[i]) == '^') {
        i++; // skip ^
        if (i < runes.length) {
          if (String.fromCharCode(runes[i]) == '{') {
            expr += '^{';
            i++;
            while (i < runes.length &&
                String.fromCharCode(runes[i]) != '}') {
              expr += String.fromCharCode(runes[i]);
              i++;
            }
            if (i < runes.length) {
              expr += '}';
              i++;
            }
          } else {
            expr += '^${String.fromCharCode(runes[i])}';
            i++;
          }
        }
      }
      buf.write('\$$expr\$');
      continue;
    }

    // ── Produit ∏ ──
    if (ch == '∏') {
      buf.write(r'$\prod$');
      i++;
      continue;
    }

    // ── Racine √ ──
    if (ch == '√') {
      i++;
      // Consommer le contenu qui suit (chiffres, lettres, parenthèses)
      String arg = '';
      if (i < runes.length) {
        final next = String.fromCharCode(runes[i]);
        if (next == '(') {
          // √(...) → \sqrt{...}
          i++; // skip (
          int depth = 1;
          while (i < runes.length && depth > 0) {
            final c = String.fromCharCode(runes[i]);
            if (c == '(') depth++;
            if (c == ')') depth--;
            if (depth > 0) arg += c;
            i++;
          }
        } else {
          // √250, √n, √x → consommer chiffres/lettres
          while (i < runes.length) {
            final c = String.fromCharCode(runes[i]);
            if ((c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57) || // 0-9
                (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) || // A-Z
                (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122)) { // a-z
              arg += c;
              i++;
            } else {
              break;
            }
          }
        }
      }
      if (arg.isEmpty) {
        buf.write(r'$\sqrt{}$');
      } else {
        buf.write('\$\\sqrt{$arg}\$');
      }
      continue;
    }

    // ── Norme ‖ ──
    if (ch == '‖') {
      buf.write(r'$\|$');
      i++;
      continue;
    }

    // ── Produit scalaire ⟨ ⟩ ──
    if (ch == '⟨') {
      buf.write(r'$\langle$');
      i++;
      continue;
    }
    if (ch == '⟩') {
      buf.write(r'$\rangle$');
      i++;
      continue;
    }

    // ── Infini ∞ ──
    if (ch == '∞') {
      buf.write(r'$\infty$');
      i++;
      continue;
    }

    // ── Exposant ASCII ^ ──
    if (ch == '^') {
      final prefix = _backtrackVar(buf);
      i++; // skip ^
      String sup = '';
      if (i < runes.length) {
        final next = String.fromCharCode(runes[i]);
        if (next == '(' || next == '{') {
          // ^(...) ou ^{...}
          final close = next == '(' ? ')' : '}';
          i++; // skip ( ou {
          int depth = 1;
          while (i < runes.length && depth > 0) {
            final c = String.fromCharCode(runes[i]);
            if (c == next) depth++;
            if (c == close) depth--;
            if (depth > 0) sup += c;
            i++;
          }
        } else {
          // ^x (single char)
          sup = next;
          i++;
        }
      }
      if (prefix.isNotEmpty || sup.isNotEmpty) {
        final supPart = sup.length > 1 ? '^{$sup}' : '^$sup';
        buf.write('\$${prefix}$supPart\$');
      } else {
        buf.write('^');
      }
      continue;
    }

    // ── Indice ASCII _ (en contexte math) ──
    if (ch == '_') {
      // Vérifier qu'on est en contexte math (précédé d'une variable)
      final prefix = _backtrackVar(buf);
      if (prefix.isNotEmpty) {
        i++; // skip _
        String sub = '';
        if (i < runes.length) {
          final next = String.fromCharCode(runes[i]);
          if (next == '{') {
            i++; // skip {
            while (i < runes.length &&
                String.fromCharCode(runes[i]) != '}') {
              sub += String.fromCharCode(runes[i]);
              i++;
            }
            if (i < runes.length) i++; // skip }
          } else {
            sub = next;
            i++;
          }
        }
        // Vérifier aussi un ^exposant qui suit immédiatement
        String sup = '';
        if (i < runes.length && String.fromCharCode(runes[i]) == '^') {
          i++; // skip ^
          if (i < runes.length) {
            final nc = String.fromCharCode(runes[i]);
            if (nc == '(' || nc == '{') {
              final close = nc == '(' ? ')' : '}';
              i++;
              int depth = 1;
              while (i < runes.length && depth > 0) {
                final c = String.fromCharCode(runes[i]);
                if (c == nc) depth++;
                if (c == close) depth--;
                if (depth > 0) sup += c;
                i++;
              }
            } else {
              sup = nc;
              i++;
            }
          }
        }
        final subPart = sub.length > 1 ? '_{$sub}' : '_$sub';
        final supPart = sup.isNotEmpty
            ? (sup.length > 1 ? '^{$sup}' : '^$sup')
            : '';
        buf.write('\$$prefix$subPart$supPart\$');
      } else {
        // Pas de contexte math → traiter comme texte
        buf.write(ch);
        i++;
      }
      continue;
    }

    // ── Point médian · → \cdot ──
    if (ch == '·') {
      buf.write(r'$\cdot$');
      i++;
      continue;
    }

    // ── Caractère normal (y compris ∈, ≤, ≥, →, etc. laissés en Unicode) ──
    buf.write(ch);
    i++;
  }

  return buf.toString();
}

/// Phase 2 : fusionner les blocs $...$ adjacents.
///
/// Transforme par exemple :
/// - `$\mathbb{Z}$/3$\mathbb{Z}$` → `$\mathbb{Z}/3\mathbb{Z}$`
/// - `$\mathbf{1}$_$\mathbb{Q}$` → `$\mathbf{1}_\mathbb{Q}$`
/// - `$\chi$_A(X)` → `$\chi_A(X)$`
/// - `$a$(x)` → `$a(x)$`
/// - `$\|$$f_n$$\|$` → `$\|f_n\|$`
String _mergeAdjacentMath(String text) {
  // Fusion 1 : $a$$b$ → $ab$ (directement adjacents)
  var result = text;
  var prev = '';
  while (result != prev) {
    prev = result;
    result = result.replaceAllMapped(
        RegExp(r'\$([^$]+)\$\$([^$]+)\$'),
        (m) => '\$${m.group(1)}${m.group(2)}\$');
  }

  // Fusion 2 : $a$<sep>$b$ où sep est court
  // Inclut /, ·, ×, -, +, =, (, ), [, ], |, ,, _, espace, et chiffres
  prev = '';
  while (result != prev) {
    prev = result;
    result = result.replaceAllMapped(
        RegExp(r'\$([^$]+)\$([/·×\-+=|_,\s\(\)\[\]0-9]{1,4})\$([^$]+)\$'),
        (m) => '\$${m.group(1)}${m.group(2)}${m.group(3)}\$');
  }

  // Fusion 3 : $a$(content) → $a(content)$ si content est court et math-like
  result = result.replaceAllMapped(
      RegExp(r'\$([^$]+)\$\(([A-Za-z0-9,+\-*/\s]{1,20})\)'),
      (m) => '\$${m.group(1)}(${m.group(2)})\$');

  // Fusion 4 : texte_$a$ → $texte_a$ (underscore connecteur)
  // Ex: χ$\chi$_A → corriger en $\chi_A$
  // Ici on gère le cas $cmd$_var
  result = result.replaceAllMapped(
      RegExp(r'\$([^$]+)\$_([A-Za-z0-9]+)'),
      (m) => '\$${m.group(1)}_${m.group(2)}\$');

  // Nettoyer les espaces multiples dans les blocs $
  result = result.replaceAllMapped(
      RegExp(r'\$([^$]+)\$'),
      (m) => '\$${m.group(1)!.replaceAll(RegExp(r'\s{2,}'), ' ').trim()}\$');

  return result;
}

/// Remonter dans le buffer pour capturer la variable précédant un ^/_.
/// Retourne la variable extraite (et la retire du buffer).
String _backtrackVar(StringBuffer buf) {
  final s = buf.toString();
  if (s.isEmpty) return '';

  int back = s.length - 1;

  // Si le dernier caractère est une parenthèse/crochet fermant,
  // remonter jusqu'à l'ouvrant
  if (back >= 0 && (s[back] == ')' || s[back] == ']')) {
    final open = s[back] == ')' ? '(' : '[';
    int depth = 1;
    back--;
    while (back >= 0 && depth > 0) {
      if (s[back] == s[s.length - 1]) {
        depth++;
      } else if (s[back] == open) {
        depth--;
      }
      if (depth > 0) back--;
    }
    // Remonter aussi les lettres/chiffres avant la parenthèse
    while (back > 0 && _isVarChar(s[back - 1])) {
      back--;
    }
  } else {
    // Remonter sur les caractères de variable
    while (back > 0 && _isVarChar(s[back - 1])) {
      back--;
    }
  }

  final word = s.substring(back);

  // Ne pas capturer les mots français courants
  if (word.isEmpty ||
      _stop.contains(word.toLowerCase()) ||
      word.length > 12) {
    return '';
  }

  // Retirer du buffer
  final kept = s.substring(0, back);
  buf.clear();
  buf.write(kept);
  return word;
}

bool _isVarChar(String ch) {
  if (ch.isEmpty) return false;
  final c = ch.codeUnitAt(0);
  return (c >= 48 && c <= 57) || // 0-9
      (c >= 65 && c <= 90) || // A-Z
      (c >= 97 && c <= 122) || // a-z
      ch == '\'' ||
      ch == '_' ||
      ch == '-';
}

// ── Mots-outils à ne pas capturer ──
final _stop = <String>{
  'le', 'la', 'les', 'un', 'une', 'des', 'du', 'de', 'et', 'ou', 'si',
  'en', 'par', 'pour', 'sur', 'dans', 'avec', 'est', 'sont', 'soit',
  'donc', 'alors', 'car', 'mais', 'que', 'qui', 'il', 'on', 'ce', 'ne',
  'pas', 'tout', 'tous', 'plus', 'non', 'oui', 'vers',
  'ipP', 'tcl', 'mod', 'loi', 'cas', 'max', 'min', 'inf', 'sup',
  'dim', 'det', 'ker', 'rg',
};

// ─────────────────── Tables de correspondance ───────────────────

const _sup = <String, String>{
  '⁰': '0', '¹': '1', '²': '2', '³': '3', '⁴': '4',
  '⁵': '5', '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9',
  'ⁿ': 'n', 'ᵏ': 'k', 'ᵐ': 'm', 'ᵖ': 'p', 'ᵍ': 'q',
  '⁻': '-', '⁺': '+',
};

const _sub = <String, String>{
  '₀': '0', '₁': '1', '₂': '2', '₃': '3', '₄': '4',
  '₅': '5', '₆': '6', '₇': '7', '₈': '8', '₉': '9',
  'ₙ': 'n', 'ₖ': 'k', 'ₘ': 'm', 'ₚ': 'p', 'ₐ': 'a',
  'ᵢ': 'i', 'ⱼ': 'j', '₋': '-', '₊': '+',
};

const _bb = <String, String>{
  'ℝ': r'\mathbb{R}',
  'ℤ': r'\mathbb{Z}',
  'ℚ': r'\mathbb{Q}',
  'ℂ': r'\mathbb{C}',
  'ℕ': r'\mathbb{N}',
  '𝔽': r'\mathbb{F}',
  '𝕋': r'\mathbb{T}',
};

const _greek = <String, String>{
  'α': r'\alpha',
  'β': r'\beta',
  'γ': r'\gamma',
  'δ': r'\delta',
  'ε': r'\varepsilon',
  'θ': r'\theta',
  'λ': r'\lambda',
  'μ': r'\mu',
  'ν': r'\nu',
  'ξ': r'\xi',
  'π': r'\pi',
  'ρ': r'\rho',
  'σ': r'\sigma',
  'τ': r'\tau',
  'φ': r'\varphi',
  'ψ': r'\psi',
  'ω': r'\omega',
  'χ': r'\chi',
  'Δ': r'\Delta',
  'Σ': r'\Sigma',
  'Φ': r'\Phi',
  'ℓ': r'\ell',
};
