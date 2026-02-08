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

  // Phase 0 : envelopper les commandes LaTeX brutes (\cmd) hors des $...$
  String result = _wrapRawLatexCommands(text);

  // Phase 1 : conversion Unicode → LaTeX, uniquement hors des $...$
  if (result.contains('\$')) {
    // Texte mixte : convertir seulement les parties hors $...$
    result = _convertUnicodeOutsideMath(result);
  } else {
    result = _convertUnicode(result);
  }

  result = _mergeAdjacentMath(result);
  return result;
}

/// Convertit Unicode en LaTeX uniquement dans les parties hors des $...$ et $$...$$.
String _convertUnicodeOutsideMath(String text) {
  final buf = StringBuffer();
  int i = 0;
  while (i < text.length) {
    if (text[i] == '\$') {
      // Détecter $$ (display) ou $ (inline)
      if (i + 1 < text.length && text[i + 1] == '\$') {
        // $$...$$ : copier tel quel
        final close = text.indexOf('\$\$', i + 2);
        if (close != -1) {
          buf.write(text.substring(i, close + 2));
          i = close + 2;
        } else {
          buf.write(text.substring(i));
          break;
        }
      } else {
        // $...$ : copier tel quel
        final close = text.indexOf('\$', i + 1);
        if (close != -1) {
          buf.write(text.substring(i, close + 1));
          i = close + 1;
        } else {
          buf.write(text.substring(i));
          break;
        }
      }
    } else {
      // Hors math : trouver le prochain $ et convertir ce segment
      final nextDollar = text.indexOf('\$', i);
      final segment = nextDollar == -1
          ? text.substring(i)
          : text.substring(i, nextDollar);
      buf.write(_convertUnicode(segment));
      i += segment.length;
    }
  }
  return buf.toString();
}

/// Phase 0 : Détecte les commandes LaTeX brutes (\cmd, \cmd{...}) hors des $...$
/// et les enveloppe dans $...$. Regroupe les séquences adjacentes.
String _wrapRawLatexCommands(String text) {
  // Si pas de backslash, rien à faire
  if (!text.contains('\\')) return text;

  // Commandes LaTeX connues à détecter (sans le \)
  const knownCommands = {
    'cdot', 'cdots', 'ldots', 'times', 'div', 'pm', 'mp',
    'lambda', 'Lambda', 'alpha', 'beta', 'gamma', 'delta', 'Delta',
    'epsilon', 'varepsilon', 'theta', 'Theta', 'mu', 'nu', 'xi',
    'pi', 'Pi', 'rho', 'sigma', 'Sigma', 'tau', 'phi', 'Phi',
    'varphi', 'psi', 'Psi', 'omega', 'Omega', 'chi', 'eta', 'zeta',
    'sqrt', 'frac', 'sum', 'prod', 'int', 'oint',
    'infty', 'partial', 'nabla', 'forall', 'exists',
    'mathbb', 'mathbf', 'mathrm', 'mathcal', 'text',
    'langle', 'rangle', 'lfloor', 'rfloor', 'lceil', 'rceil',
    'leq', 'geq', 'neq', 'approx', 'equiv', 'sim', 'simeq',
    'subset', 'supset', 'subseteq', 'supseteq', 'in', 'notin',
    'cup', 'cap', 'setminus', 'emptyset',
    'to', 'rightarrow', 'leftarrow', 'Rightarrow', 'Leftarrow',
    'mapsto', 'implies', 'iff',
    'overline', 'underline', 'hat', 'tilde', 'bar', 'vec',
    'oplus', 'otimes', 'circ', 'bullet',
    'det', 'dim', 'ker', 'Im', 'Re', 'log', 'ln', 'exp',
    'sin', 'cos', 'tan', 'arcsin', 'arccos', 'arctan',
    'min', 'max', 'sup', 'inf', 'lim',
    'binom', 'choose',
    'ell',
  };

  final buf = StringBuffer();
  int i = 0;
  bool inDollar = false;

  while (i < text.length) {
    // Basculer le mode $...$
    if (text[i] == '\$') {
      inDollar = !inDollar;
      buf.write(text[i]);
      i++;
      continue;
    }

    // Hors des $...$, détecter \commande
    if (!inDollar && text[i] == '\\' && i + 1 < text.length) {
      // Lire le nom de la commande
      int cmdStart = i + 1;
      int cmdEnd = cmdStart;
      while (cmdEnd < text.length &&
          ((text.codeUnitAt(cmdEnd) >= 65 && text.codeUnitAt(cmdEnd) <= 90) ||
           (text.codeUnitAt(cmdEnd) >= 97 && text.codeUnitAt(cmdEnd) <= 122))) {
        cmdEnd++;
      }

      final cmdName = text.substring(cmdStart, cmdEnd);

      if (cmdName.isNotEmpty && knownCommands.contains(cmdName)) {
        // Collecter la commande + arguments {...} et contenu math adjacent
        final mathBuf = StringBuffer();
        mathBuf.write('\\$cmdName');
        i = cmdEnd;

        // Consommer les arguments {....}
        while (i < text.length && text[i] == '{') {
          int depth = 1;
          mathBuf.write('{');
          i++;
          while (i < text.length && depth > 0) {
            if (text[i] == '{') depth++;
            if (text[i] == '}') depth--;
            mathBuf.write(text[i]);
            i++;
          }
        }

        // Continuer à collecter les tokens math adjacents
        // (lettres, chiffres, ^, _, {}, autres \commandes, espaces courts)
        bool continueCollecting = true;
        while (continueCollecting && i < text.length) {
          final ch = text[i];
          if (ch == '\\' && i + 1 < text.length) {
            // Autre commande LaTeX adjacente
            int nc = i + 1;
            int ne = nc;
            while (ne < text.length &&
                ((text.codeUnitAt(ne) >= 65 && text.codeUnitAt(ne) <= 90) ||
                 (text.codeUnitAt(ne) >= 97 && text.codeUnitAt(ne) <= 122))) {
              ne++;
            }
            final nextCmd = text.substring(nc, ne);
            if (nextCmd.isNotEmpty && knownCommands.contains(nextCmd)) {
              mathBuf.write('\\$nextCmd');
              i = ne;
              // Consommer les arguments
              while (i < text.length && text[i] == '{') {
                int depth = 1;
                mathBuf.write('{');
                i++;
                while (i < text.length && depth > 0) {
                  if (text[i] == '{') depth++;
                  if (text[i] == '}') depth--;
                  mathBuf.write(text[i]);
                  i++;
                }
              }
            } else {
              continueCollecting = false;
            }
          } else if (ch == '^' || ch == '_') {
            mathBuf.write(ch);
            i++;
            // Consommer l'argument qui suit (lettre, chiffre, ou {..})
            if (i < text.length) {
              if (text[i] == '{') {
                int depth = 1;
                mathBuf.write('{');
                i++;
                while (i < text.length && depth > 0) {
                  if (text[i] == '{') depth++;
                  if (text[i] == '}') depth--;
                  mathBuf.write(text[i]);
                  i++;
                }
              } else {
                mathBuf.write(text[i]);
                i++;
              }
            }
          } else if ((ch.codeUnitAt(0) >= 65 && ch.codeUnitAt(0) <= 90) ||
                     (ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122) ||
                     (ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57) ||
                     ch == '(' || ch == ')' || ch == ',' || ch == '.' ||
                     ch == '+' || ch == '-' || ch == '=' || ch == '!' ||
                     ch == '|' || ch == '/' || ch == '\'' || ch == ' ') {
            // Espace : seulement si suivi d'un autre token math
            if (ch == ' ') {
              // Regarder si le prochain non-espace est un token math
              int peek = i + 1;
              while (peek < text.length && text[peek] == ' ') peek++;
              if (peek < text.length &&
                  (text[peek] == '\\' || text[peek] == '^' || text[peek] == '_' ||
                   text[peek] == '{')) {
                mathBuf.write(' ');
                i++;
              } else {
                continueCollecting = false;
              }
            } else {
              mathBuf.write(ch);
              i++;
            }
          } else {
            continueCollecting = false;
          }
        }

        buf.write('\$${mathBuf.toString()}\$');
      } else {
        // Pas une commande connue, garder tel quel
        buf.write(text[i]);
        i++;
      }
    } else {
      buf.write(text[i]);
      i++;
    }
  }

  return buf.toString();
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
      // Consommer le contenu qui suit (chiffres, lettres, parenthèses, lettres grecques, indices)
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
          // √250, √n, √x, √λₙ → consommer chiffres/lettres/grec/indices
          while (i < runes.length) {
            final c = String.fromCharCode(runes[i]);
            if ((c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57) || // 0-9
                (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) || // A-Z
                (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122)) { // a-z
              arg += c;
              i++;
            } else if (_greek.containsKey(c)) {
              arg += _greek[c]!;
              i++;
              // Consommer les indices/exposants Unicode qui suivent la lettre grecque
              while (i < runes.length) {
                final sc = String.fromCharCode(runes[i]);
                if (_sub.containsKey(sc)) {
                  String s = '';
                  while (i < runes.length && _sub.containsKey(String.fromCharCode(runes[i]))) {
                    s += _sub[String.fromCharCode(runes[i])]!;
                    i++;
                  }
                  arg += s.length > 1 ? '_{$s}' : '_$s';
                } else if (_sup.containsKey(sc)) {
                  String s = '';
                  while (i < runes.length && _sup.containsKey(String.fromCharCode(runes[i]))) {
                    s += _sup[String.fromCharCode(runes[i])]!;
                    i++;
                  }
                  arg += s.length > 1 ? '^{$s}' : '^$s';
                } else {
                  break;
                }
              }
            } else if (_sub.containsKey(c)) {
              // Indices Unicode directement après un chiffre/lettre
              String s = '';
              while (i < runes.length && _sub.containsKey(String.fromCharCode(runes[i]))) {
                s += _sub[String.fromCharCode(runes[i])]!;
                i++;
              }
              arg += s.length > 1 ? '_{$s}' : '_$s';
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

    // ── Symboles spéciaux isolés ──
    // † (dagger) hors contexte d'exposant
    if (ch == '†') {
      buf.write(r'$\dagger$');
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
          // ^x (single char) — convertir les symboles spéciaux
          if (next == '†') {
            sup = '\\dagger';
          } else if (next == '⊤') {
            sup = '\\top';
          } else {
            sup = next;
          }
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

    // ── Diacritiques combinants Unicode (barre, tilde, chapeau sur le caractère précédent) ──
    // Caractères comme v̄ = 'v' + U+0304 (combining overbar)
    final code = runes[i];
    if (code == 0x0304 || code == 0x0305) {
      // Combining overline/macron → \overline{x}
      final prefix = _backtrackVar(buf);
      if (prefix.isNotEmpty) {
        buf.write('\$\\overline{$prefix}\$');
      } else {
        buf.writeCharCode(code);
      }
      i++;
      continue;
    }
    if (code == 0x0303) {
      // Combining tilde → \tilde{x}
      final prefix = _backtrackVar(buf);
      if (prefix.isNotEmpty) {
        buf.write('\$\\tilde{$prefix}\$');
      } else {
        buf.writeCharCode(code);
      }
      i++;
      continue;
    }
    if (code == 0x0302) {
      // Combining circumflex → \hat{x}
      final prefix = _backtrackVar(buf);
      if (prefix.isNotEmpty) {
        buf.write('\$\\hat{$prefix}\$');
      } else {
        buf.writeCharCode(code);
      }
      i++;
      continue;
    }
    if (code == 0x20D7) {
      // Combining right arrow → \vec{x}
      final prefix = _backtrackVar(buf);
      if (prefix.isNotEmpty) {
        buf.write('\$\\vec{$prefix}\$');
      } else {
        buf.writeCharCode(code);
      }
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
  // Fusion 1 : $a$$b$ → $a b$ (directement adjacents)
  // Ajoute un espace si $a$ finit par une commande \xxx et $b$ commence par une lettre
  var result = text;
  var prev = '';
  while (result != prev) {
    prev = result;
    result = result.replaceAllMapped(
        RegExp(r'\$([^$]+)\$\$([^$]+)\$'),
        (m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          // Si a finit par une commande \xxx et b commence par une lettre,
          // ajouter un espace pour éviter \cdotP → \cdot P
          final needsSpace = RegExp(r'\\[a-zA-Z]+$').hasMatch(a) &&
              b.isNotEmpty && RegExp(r'^[a-zA-Z]').hasMatch(b);
          return '\$${a}${needsSpace ? ' ' : ''}${b}\$';
        });
  }

  // Fusion 2 : $a$<sep>$b$ où sep est court
  // Inclut /, ·, ×, -, +, =, (, ), [, ], ,, _, espace, et chiffres
  // NOTE: PAS de | (pipe) car il est utilisé pour la cardinalité |P₃| et ne doit pas être absorbé
  prev = '';
  while (result != prev) {
    prev = result;
    result = result.replaceAllMapped(
        RegExp(r'\$([^$]+)\$([/·×\-+=_,\s\(\)\[\]0-9]{1,4})\$([^$]+)\$'),
        (m) {
          final a = m.group(1)!;
          final sep = m.group(2)!;
          final b = m.group(3)!;
          return '\$${a}${sep}${b}\$';
        });
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
