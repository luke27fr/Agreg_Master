import 'dart:convert';
import 'dart:io';

/// Pass 1: Replace Unicode characters with LaTeX commands (no $ wrapping)
String unicodeToLatex(String text) {
  if (text.isEmpty) return text;
  
  final buf = StringBuffer();
  final runes = text.runes.toList();
  int i = 0;
  
  while (i < runes.length) {
    final ch = String.fromCharCode(runes[i]);
    
    // Superscripts - collect consecutive
    if (_superscripts.containsKey(ch)) {
      String sup = '';
      while (i < runes.length && _superscripts.containsKey(String.fromCharCode(runes[i]))) {
        sup += _superscripts[String.fromCharCode(runes[i])]!;
        i++;
      }
      buf.write(sup.length > 1 ? '^{$sup}' : '^$sup');
      continue;
    }
    
    // Subscripts - collect consecutive
    if (_subscripts.containsKey(ch)) {
      String sub = '';
      while (i < runes.length && _subscripts.containsKey(String.fromCharCode(runes[i]))) {
        sub += _subscripts[String.fromCharCode(runes[i])]!;
        i++;
      }
      buf.write(sub.length > 1 ? '_{$sub}' : '_$sub');
      continue;
    }
    
    // Check replacement maps
    if (_replacements.containsKey(ch)) {
      buf.write(_replacements[ch]);
      i++;
      continue;
    }
    
    buf.write(ch);
    i++;
  }
  
  return buf.toString();
}

/// Pass 2: Wrap math expressions in $...$
/// Strategy: tokenize by spaces, classify each token, merge adjacent math tokens
String wrapMathRegions(String text) {
  if (text.isEmpty) return text;
  
  // Don't process if already has $ (already LaTeX formatted)
  if (text.contains('\$')) return text;
  
  // Split into tokens preserving separators
  final tokens = <_Token>[];
  final pattern = RegExp(r'(\s+|[,;:!?]+(?:\s|$))');
  int pos = 0;
  
  for (final match in pattern.allMatches(text)) {
    if (match.start > pos) {
      tokens.add(_Token(text.substring(pos, match.start), false));
    }
    tokens.add(_Token(match.group(0)!, false)); // separator
    pos = match.end;
  }
  if (pos < text.length) {
    tokens.add(_Token(text.substring(pos), false));
  }
  
  // Classify each non-separator token as math or text
  for (int i = 0; i < tokens.length; i++) {
    final t = tokens[i];
    if (t.text.trim().isEmpty || RegExp(r'^[,;:!?]+\s*$').hasMatch(t.text)) continue;
    tokens[i] = _Token(t.text, _isMathToken(t.text));
  }
  
  // Build output: group consecutive math tokens and wrap in $...$
  final buf = StringBuffer();
  int ti = 0;
  
  while (ti < tokens.length) {
    if (!tokens[ti].isMath) {
      buf.write(tokens[ti].text);
      ti++;
      continue;
    }
    
    // Start of math region
    final mathParts = <String>[];
    mathParts.add(tokens[ti].text);
    ti++;
    
    // Continue collecting math and connecting separators
    while (ti < tokens.length) {
      // Check if next non-separator is also math
      if (tokens[ti].text.trim().isEmpty || RegExp(r'^[,;:!?]+\s*$').hasMatch(tokens[ti].text)) {
        // It's a separator - check if next content is math
        int nextContent = ti + 1;
        while (nextContent < tokens.length && 
               (tokens[nextContent].text.trim().isEmpty || 
                RegExp(r'^[,;:!?]+\s*$').hasMatch(tokens[nextContent].text))) {
          nextContent++;
        }
        
        if (nextContent < tokens.length && tokens[nextContent].isMath) {
          // Include separator in math region
          for (int j = ti; j <= nextContent; j++) {
            mathParts.add(tokens[j].text);
          }
          ti = nextContent + 1;
          continue;
        } else {
          break; // End of math region
        }
      } else if (tokens[ti].isMath) {
        mathParts.add(tokens[ti].text);
        ti++;
      } else {
        // Check if it's a short connecting word between math
        final word = tokens[ti].text.toLowerCase();
        if (_mathConnectors.contains(word) && ti + 1 < tokens.length) {
          // Look ahead for more math
          int nextContent = ti + 1;
          while (nextContent < tokens.length && 
                 (tokens[nextContent].text.trim().isEmpty || 
                  RegExp(r'^[,;:!?]+\s*$').hasMatch(tokens[nextContent].text))) {
            nextContent++;
          }
          if (nextContent < tokens.length && tokens[nextContent].isMath) {
            // Include connector in math region
            for (int j = ti; j <= nextContent; j++) {
              mathParts.add(tokens[j].text);
            }
            ti = nextContent + 1;
            continue;
          }
        }
        break; // End of math region
      }
    }
    
    final mathContent = mathParts.join('').trim();
    if (mathContent.isNotEmpty) {
      buf.write('\$$mathContent\$');
    }
  }
  
  String result = buf.toString();
  
  // Post-processing: fix common issues
  // Remove $ around very short non-math content
  result = result.replaceAllMapped(RegExp(r'\$([a-zA-Z])\$'), (m) {
    // Single letter that's probably a variable - keep it in math
    return '\$${m.group(1)}\$';
  });
  
  // Merge adjacent $...$ blocks with just whitespace between
  result = result.replaceAllMapped(RegExp(r'\$\s*\$'), (m) => ' ');
  
  // Fix "$x$ = $y$" to "$x = y$" 
  result = _mergeAdjacentMath(result);
  
  return result;
}

/// Merge adjacent math regions separated by operators or short connectors
String _mergeAdjacentMath(String text) {
  // Pattern: $...$ followed by optional space and operator/= and space and $...$
  final pattern = RegExp(r'\$([^$]+)\$(\s*[=<>+\-*/|&]\s*)\$([^$]+)\$');
  String prev = text;
  String current = text.replaceAllMapped(pattern, (m) => '\$${m.group(1)}${m.group(2)}${m.group(3)}\$');
  while (current != prev) {
    prev = current;
    current = current.replaceAllMapped(pattern, (m) => '\$${m.group(1)}${m.group(2)}${m.group(3)}\$');
  }
  return current;
}

/// Determine if a token is mathematical
bool _isMathToken(String token) {
  // Contains LaTeX commands
  if (token.contains('\\')) return true;
  
  // Contains ^ or _ (sub/superscript)
  if (token.contains('^') || token.contains('_')) return true;
  
  // Is a pure number
  if (RegExp(r'^-?\d+(/\d+)?$').hasMatch(token)) return false; // plain numbers in text
  
  // Contains mixed letters and numbers with math operators
  if (RegExp(r'[A-Za-z]\d|[=<>]').hasMatch(token) && 
      RegExp(r'[\^_\\=<>+\-*/]').hasMatch(token)) return true;
  
  // Is a single variable letter followed by sub/super
  if (RegExp(r'^[A-Za-z][\^_]').hasMatch(token)) return true;
  
  // Contains mathematical operators after letters
  if (RegExp(r'[A-Za-z][=<>+\-*/][A-Za-z0-9]').hasMatch(token)) return true;
  
  // Common math patterns
  if (RegExp(r'^\(?[A-Za-z]\)?[=<>]').hasMatch(token)) return true;
  
  // Fractions like 1/n, x/y
  if (RegExp(r'^[A-Za-z0-9]+/[A-Za-z0-9]+$').hasMatch(token) && 
      RegExp(r'[A-Za-z]').hasMatch(token)) return true;
  
  // Parenthesized expressions with variables: (1-p), (n+1), etc.
  if (RegExp(r'^\(.*[A-Za-z].*[+\-*/].*\)$').hasMatch(token)) return true;
  
  // Matrix notation [[...]]
  if (token.contains('[[')) return true;
  
  return false;
}

const _mathConnectors = {'et', 'ou', 'si', 'car', 'avec', 'pour', 'and', 'or', 'where', 'mod'};

class _Token {
  final String text;
  final bool isMath;
  _Token(this.text, this.isMath);
}

/// Combined conversion
String convertToLatex(String text) {
  if (text.isEmpty) return text;
  
  // Skip if already contains LaTeX math delimiters
  if (text.contains('\$')) return text;
  
  // Pass 1: Unicode to LaTeX commands
  String result = unicodeToLatex(text);
  
  // Pass 2: Wrap math in $...$
  result = wrapMathRegions(result);
  
  return result;
}

// =================== Character maps ===================

const _superscripts = {
  '⁰': '0', '¹': '1', '²': '2', '³': '3', '⁴': '4',
  '⁵': '5', '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9',
  'ⁿ': 'n', 'ᵏ': 'k', 'ᵐ': 'm', 'ᵖ': 'p', 'ᵍ': 'q',
  '⁻': '-', '⁺': '+',
};

const _subscripts = {
  '₀': '0', '₁': '1', '₂': '2', '₃': '3', '₄': '4',
  '₅': '5', '₆': '6', '₇': '7', '₈': '8', '₉': '9',
  'ₙ': 'n', 'ₖ': 'k', 'ₘ': 'm', 'ₚ': 'p', 'ₐ': 'a',
  'ᵢ': 'i', 'ⱼ': 'j',
};

const _replacements = {
  'ℝ': r'\mathbb{R}',
  'ℤ': r'\mathbb{Z}',
  'ℚ': r'\mathbb{Q}',
  'ℂ': r'\mathbb{C}',
  'ℕ': r'\mathbb{N}',
  '𝔽': r'\mathbb{F}',
  '𝕋': r'\mathbb{T}',
  '𝟙': r'\mathbf{1}',
  '∈': r'\in ',
  '∉': r'\notin ',
  '≤': r'\leq ',
  '≥': r'\geq ',
  '≠': r'\neq ',
  '≡': r'\equiv ',
  '≅': r'\simeq ',
  '≈': r'\approx ',
  '⟹': r'\Rightarrow ',
  '⟸': r'\Leftarrow ',
  '⟺': r'\Leftrightarrow ',
  '⇒': r'\Rightarrow ',
  '⇐': r'\Leftarrow ',
  '⇔': r'\Leftrightarrow ',
  '→': r'\to ',
  '←': r'\leftarrow ',
  '↦': r'\mapsto ',
  '↗': r'\nearrow ',
  '∀': r'\forall ',
  '∃': r'\exists ',
  '∅': r'\emptyset',
  '∞': r'\infty',
  '∪': r'\cup ',
  '∩': r'\cap ',
  '⊂': r'\subset ',
  '⊃': r'\supset ',
  '⊆': r'\subseteq ',
  '⊇': r'\supseteq ',
  '⊕': r'\oplus ',
  '⊗': r'\otimes ',
  '⊥': r'\perp',
  '⟨': r'\langle ',
  '⟩': r'\rangle ',
  '‖': r'\|',
  '∫': r'\int',
  '∑': r'\sum',
  '∏': r'\prod',
  '√': r'\sqrt',
  '⌊': r'\lfloor ',
  '⌋': r'\rfloor ',
  '·': r'\cdot ',
  '×': r'\times ',
  '≢': r'\not\equiv ',
  'λ': r'\lambda',
  'μ': r'\mu',
  'σ': r'\sigma',
  'ε': r'\varepsilon',
  'δ': r'\delta',
  'φ': r'\varphi',
  'ω': r'\omega',
  'θ': r'\theta',
  'α': r'\alpha',
  'β': r'\beta',
  'γ': r'\gamma',
  'Δ': r'\Delta',
  'Φ': r'\Phi',
  'ξ': r'\xi',
  'ψ': r'\psi',
  'ρ': r'\rho',
  'τ': r'\tau',
  'ν': r'\nu',
  'χ': r'\chi',
  'ℓ': r'\ell',
  // Note: π kept as-is when used in text like "π/2" (will be in math context)
  'π': r'\pi',
};

// =================== File processors ===================

void processFile(String path, String key, Function(Map<String, dynamic>) processor) {
  print('Processing $path...');
  final file = File(path);
  final content = file.readAsStringSync();
  final data = jsonDecode(content) as Map<String, dynamic>;
  
  if (data.containsKey(key)) {
    final list = data[key] as List;
    for (int i = 0; i < list.length; i++) {
      processor(list[i] as Map<String, dynamic>);
    }
    print('  Processed ${list.length} entries.');
  }
  
  final encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync(encoder.convert(data));
}

void processExercise(Map<String, dynamic> ex) {
  if (ex['enonce'] is String) ex['enonce'] = convertToLatex(ex['enonce']);
  if (ex['indication'] is String) ex['indication'] = convertToLatex(ex['indication']);
  if (ex['solution'] is List) {
    ex['solution'] = (ex['solution'] as List).map((s) => 
      s is String ? convertToLatex(s) : s).toList();
  }
}

void processDemo(Map<String, dynamic> demo) {
  if (demo['enonce'] is String) demo['enonce'] = convertToLatex(demo['enonce']);
  if (demo['preuve'] is List) {
    demo['preuve'] = (demo['preuve'] as List).map((s) => 
      s is String ? convertToLatex(s) : s).toList();
  }
  if (demo['corollaires'] is List) {
    demo['corollaires'] = (demo['corollaires'] as List).map((s) => 
      s is String ? convertToLatex(s) : s).toList();
  }
}

void processContreExemple(Map<String, dynamic> ce) {
  if (ce['enonce'] is String) ce['enonce'] = convertToLatex(ce['enonce']);
  if (ce['explication'] is String) ce['explication'] = convertToLatex(ce['explication']);
}

void main() {
  final baseDir = Directory.current.path;
  final dataDir = '$baseDir/assets/data';
  
  processFile('$dataDir/exercices.json', 'exercices', processExercise);
  processFile('$dataDir/demonstrations.json', 'demonstrations', processDemo);
  processFile('$dataDir/contre_exemples.json', 'contre_exemples', processContreExemple);
  
  print('\nAll files converted!');
  
  // Print a few samples for verification
  final exFile = File('$dataDir/exercices.json');
  final exData = jsonDecode(exFile.readAsStringSync()) as Map<String, dynamic>;
  final exList = exData['exercices'] as List;
  
  print('\n=== SAMPLE OUTPUTS ===');
  for (int i = 0; i < 3 && i < exList.length; i++) {
    final ex = exList[i];
    print('\n--- ${ex['titre']} ---');
    print('Énoncé: ${ex['enonce']}');
    if (ex['solution'] is List) {
      for (final s in (ex['solution'] as List).take(2)) {
        print('  Sol: $s');
      }
    }
  }
}
