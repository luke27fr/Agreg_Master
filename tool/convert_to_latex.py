#!/usr/bin/env python3
"""Convert Unicode math notation to LaTeX in JSON data files."""

import json
import re
import sys
import os

# Unicode superscript/subscript mappings
SUPERSCRIPTS = {
    '⁰': '0', '¹': '1', '²': '2', '³': '3', '⁴': '4',
    '⁵': '5', '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9',
    'ⁿ': 'n', 'ᵏ': 'k', 'ᵐ': 'm', 'ᵖ': 'p', 'ᵍ': 'q',
    '⁻': '-', '⁺': '+',
}

SUBSCRIPTS = {
    '₀': '0', '₁': '1', '₂': '2', '₃': '3', '₄': '4',
    '₅': '5', '₆': '6', '₇': '7', '₈': '8', '₉': '9',
    'ₙ': 'n', 'ₖ': 'k', 'ₘ': 'm', 'ₚ': 'p', 'ₐ': 'a',
    'ᵢ': 'i', 'ⱼ': 'j',
}

# Math symbol replacements (inside $...$)
MATH_SYMBOLS = {
    '∈': '\\in ',
    '∉': '\\notin ',
    '≤': '\\leq ',
    '≥': '\\geq ',
    '≠': '\\neq ',
    '≡': '\\equiv ',
    '≅': '\\simeq ',
    '≈': '\\approx ',
    '⟹': '\\Rightarrow ',
    '⟸': '\\Leftarrow ',
    '⟺': '\\Leftrightarrow ',
    '⇒': '\\Rightarrow ',
    '⇐': '\\Leftarrow ',
    '⇔': '\\Leftrightarrow ',
    '→': '\\to ',
    '←': '\\leftarrow ',
    '↦': '\\mapsto ',
    '↗': '\\nearrow ',
    '∀': '\\forall ',
    '∃': '\\exists ',
    '∅': '\\emptyset ',
    '∞': '\\infty',
    '∪': '\\cup ',
    '∩': '\\cap ',
    '⊂': '\\subset ',
    '⊃': '\\supset ',
    '⊆': '\\subseteq ',
    '⊇': '\\supseteq ',
    '⊕': '\\oplus ',
    '⊗': '\\otimes ',
    '⊥': '\\perp ',
    '∎': '\\blacksquare',
    '✓': '',
    '·': '\\cdot ',
    '×': '\\times ',
    'λ': '\\lambda',
    'μ': '\\mu',
    'σ': '\\sigma',
    'π': '\\pi',
    'ε': '\\varepsilon',
    'δ': '\\delta',
    'φ': '\\varphi',
    'ω': '\\omega',
    'θ': '\\theta',
    'α': '\\alpha',
    'β': '\\beta',
    'γ': '\\gamma',
    'Δ': '\\Delta',
    'Σ': '\\Sigma',
    'Φ': '\\Phi',
    'ℓ': '\\ell',
}

# Blackboard bold
BLACKBOARD = {
    'ℝ': '\\mathbb{R}',
    'ℤ': '\\mathbb{Z}',
    'ℚ': '\\mathbb{Q}',
    'ℂ': '\\mathbb{C}',
    'ℕ': '\\mathbb{N}',
    '𝔽': '\\mathbb{F}',
    '𝕋': '\\mathbb{T}',
}

# Indicators and special
SPECIAL = {
    '𝟙': '\\mathbf{1}',
    'ḡ': '\\bar{g}',
    'λ̄': '\\bar{\\lambda}',
}


def collect_superscripts(s, i):
    """Collect consecutive superscript characters starting at position i."""
    result = ''
    while i < len(s) and s[i] in SUPERSCRIPTS:
        result += SUPERSCRIPTS[s[i]]
        i += 1
    return result, i


def collect_subscripts(s, i):
    """Collect consecutive subscript characters starting at position i."""
    result = ''
    while i < len(s) and s[i] in SUBSCRIPTS:
        result += SUBSCRIPTS[s[i]]
        i += 1
    return result, i


def convert_math_expression(text):
    """Convert a string with Unicode math to LaTeX notation."""
    if not text:
        return text
    
    result = []
    i = 0
    in_math = False
    
    while i < len(text):
        ch = text[i]
        
        # Handle superscripts
        if ch in SUPERSCRIPTS:
            sup, new_i = collect_superscripts(text, i)
            if len(sup) > 1:
                result.append('^{' + sup + '}')
            else:
                result.append('^' + sup)
            i = new_i
            continue
        
        # Handle subscripts  
        if ch in SUBSCRIPTS:
            sub, new_i = collect_subscripts(text, i)
            if len(sub) > 1:
                result.append('_{' + sub + '}')
            else:
                result.append('_' + sub)
            i = new_i
            continue
        
        # Handle blackboard bold
        if ch in BLACKBOARD:
            result.append(BLACKBOARD[ch])
            i += 1
            continue
        
        # Handle special symbols
        if ch in SPECIAL:
            result.append(SPECIAL[ch])
            i += 1
            continue
            
        # Handle math symbols
        if ch in MATH_SYMBOLS:
            result.append(MATH_SYMBOLS[ch])
            i += 1
            continue
        
        # Handle ⟨ and ⟩ (angle brackets for inner products)
        if ch == '⟨':
            result.append('\\langle ')
            i += 1
            continue
        if ch == '⟩':
            result.append('\\rangle ')
            i += 1
            continue
        
        # Handle ‖ (norm)
        if ch == '‖':
            result.append('\\|')
            i += 1
            continue
        
        # Handle integral signs with limits
        if ch == '∫':
            result.append('\\int')
            i += 1
            continue
        
        if ch == '∑':
            result.append('\\sum')
            i += 1
            continue
            
        if ch == '∏':
            result.append('\\prod')
            i += 1
            continue
        
        if ch == '√':
            result.append('\\sqrt')
            i += 1
            continue
            
        # Handle floor/ceil
        if ch == '⌊':
            result.append('\\lfloor ')
            i += 1
            continue
        if ch == '⌋':
            result.append('\\rfloor ')
            i += 1
            continue
        
        # Regular character
        result.append(ch)
        i += 1
    
    return ''.join(result)


def wrap_math_regions(text):
    """Wrap mathematical regions of text in $...$ delimiters."""
    if not text:
        return text
    
    # First convert Unicode to LaTeX commands
    text = convert_math_expression(text)
    
    # Now wrap regions that contain LaTeX commands in $...$
    # Strategy: find sequences that contain LaTeX commands and wrap them
    
    # Pattern: sequences containing backslash commands, ^, _, and alphanumeric
    # We need to be smart about what to wrap
    
    # Split by sentence boundaries to process chunks
    # Simple approach: find runs of "math-like" content
    
    # Regex to find math-like regions:
    # - Contains \command
    # - Contains ^ or _
    # - Contains sequences like x^2, A_n, etc.
    
    # First, wrap explicit LaTeX commands that aren't already in $...$
    # Find regions with backslash commands
    
    parts = []
    i = 0
    while i < len(text):
        # Check if we're already inside a math delimiter
        if text[i] == '$':
            # Find matching $
            end = text.find('$', i + 1)
            if end != -1:
                parts.append(text[i:end+1])
                i = end + 1
                continue
        
        # Look for math-like patterns
        # Pattern: word chars possibly followed by subscripts/superscripts and LaTeX commands
        math_match = re.match(
            r'([A-Za-z0-9]*(?:\\[a-zA-Z]+[\{\}A-Za-z0-9]*|[\^_][\{]?[A-Za-z0-9\-\+]+[\}]?)+(?:[A-Za-z0-9\\,\.\+\-\*/\(\)\[\]\{\}=<>!| ]*(?:\\[a-zA-Z]+[\{\}A-Za-z0-9]*|[\^_][\{]?[A-Za-z0-9\-\+]+[\}]?))*)',
            text[i:]
        )
        
        if math_match and len(math_match.group(0).strip()) > 0:
            math_region = math_match.group(0).strip()
            # Only wrap if it contains meaningful LaTeX
            if '\\' in math_region or '^' in math_region or '_' in math_region:
                parts.append('$' + math_region + '$')
                i += math_match.end()
                continue
        
        parts.append(text[i])
        i += 1
    
    result = ''.join(parts)
    
    # Clean up: merge adjacent $...$ regions
    result = re.sub(r'\$\s*\$', ' ', result)
    
    # Clean up: fix $$ at word boundaries  
    result = result.replace('$ $', ' ')
    
    return result


def process_string(text):
    """Process a single string field."""
    if not text or not isinstance(text, str):
        return text
    return wrap_math_regions(text)


def process_list(items):
    """Process a list of strings."""
    if not items or not isinstance(items, list):
        return items
    return [process_string(item) if isinstance(item, str) else item for item in items]


def process_exercise(ex):
    """Process an exercise entry."""
    if 'enonce' in ex:
        ex['enonce'] = process_string(ex['enonce'])
    if 'indication' in ex:
        ex['indication'] = process_string(ex['indication'])
    if 'solution' in ex:
        ex['solution'] = process_list(ex['solution'])
    return ex


def process_demonstration(demo):
    """Process a demonstration entry."""
    if 'titre' in demo:
        demo['titre'] = process_string(demo['titre'])
    if 'enonce' in demo:
        demo['enonce'] = process_string(demo['enonce'])
    if 'preuve' in demo:
        demo['preuve'] = process_list(demo['preuve'])
    if 'corollaires' in demo:
        demo['corollaires'] = process_list(demo['corollaires'])
    if 'remarque' in demo:
        demo['remarque'] = process_string(demo['remarque'])
    return demo


def process_contre_exemple(ce):
    """Process a counter-example entry."""
    if 'enonce' in ce:
        ce['enonce'] = process_string(ce['enonce'])
    if 'explication' in ce:
        ce['explication'] = process_string(ce['explication'])
    return ce


def process_file(filepath, key, processor):
    """Process a JSON file."""
    print(f"Processing {filepath}...")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if key in data:
        data[key] = [processor(item) for item in data[key]]
    
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"  Done! Processed {len(data.get(key, []))} entries.")


if __name__ == '__main__':
    base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_dir = os.path.join(base, 'assets', 'data')
    
    process_file(
        os.path.join(data_dir, 'exercices.json'),
        'exercices', process_exercise
    )
    
    process_file(
        os.path.join(data_dir, 'demonstrations.json'),
        'demonstrations', process_demonstration
    )
    
    process_file(
        os.path.join(data_dir, 'contre_exemples.json'),
        'contre_exemples', process_contre_exemple
    )
    
    print("\nAll files converted!")
