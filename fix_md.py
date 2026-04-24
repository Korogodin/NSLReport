#!/usr/bin/env python3
"""Transform MD file for ESKD PDF generation (universal for all document types):
- Remove title header lines (go to LaTeX title page)
- Fix heading levels: remove manual numbers, adjust depth
- Convert non-structural #### headings to bold paragraphs
- Remove metadata section at the end (Сведения о документе / Дата / Статус / etc.)
- Remove horizontal rules (--- between sections)
- Remove duplicate title blocks
- Handle both ## N. and # N. numbering styles
"""
import re
import sys


def detect_title_end(lines):
    """Detect where the document title/header block ends and content begins.
    
    Returns the line index where content starts.
    Handles various title patterns:
    - '## РЕГ-4-2: ...' followed by '## 1. ...'
    - '# Общие сведения' (unnumbered top-level)
    - '# ТПД-1-3: ...' followed by '## 1. ...'
    """
    for i, line in enumerate(lines):
        stripped = line.rstrip('\n')
        # First numbered section heading signals content start
        if re.match(r'^#{1,2}\s+\d+\.', stripped):
            return i
        # For documents like РЕГ-6 that use unnumbered # headings
        if re.match(r'^#\s+(?!РЕГ|ТПД|Руководство|Паспорт)', stripped) and i > 0:
            return i
    return 0


def detect_metadata_start(lines):
    """Find where trailing metadata section starts (to remove it)."""
    metadata_keys = re.compile(
        r'^\s*\*?\*?(?:Дата|Статус|Версия|Разработал|Согласовал|Утвердил|Организация|Тестировщик)\s*[:：]\*?\*?\s*',
        re.IGNORECASE
    )
    # Also detect '## N. Сведения о документе' section
    svedenia_re = re.compile(r'^#{1,3}\s+(?:\d+\.?\s+)?Сведения о документе', re.IGNORECASE)
    
    # Search backwards for metadata block
    i = len(lines) - 1
    while i >= 0 and not lines[i].strip():
        i -= 1
    
    metadata_end = i + 1
    while i >= 0:
        stripped = lines[i].strip()
        if not stripped or stripped == '---':
            i -= 1
            continue
        if metadata_keys.match(stripped):
            i -= 1
            continue
        break
    metadata_start_from_keys = i + 1
    
    # Check for Сведения о документе section
    for j, line in enumerate(lines):
        if svedenia_re.match(line.rstrip('\n')):
            return j
    
    if metadata_start_from_keys < metadata_end:
        return metadata_start_from_keys
    return len(lines)


def transform(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Detect heading style: does the document use ## N. or # N. for top sections?
    has_hash2_numbered = any(re.match(r'^## \d+\.', l) for l in lines)
    has_hash1_numbered = any(re.match(r'^# \d+\.', l) for l in lines)
    # Does it use unnumbered # headings as sections (like РЕГ-6)?
    has_unnumbered_h1 = any(re.match(r'^# [^#\d]', l) for l in lines)
    
    title_end = detect_title_end(lines)
    metadata_start = detect_metadata_start(lines)
    
    output = []
    
    for idx, line in enumerate(lines):
        # Skip title block
        if idx < title_end:
            continue
        # Skip metadata section
        if idx >= metadata_start:
            continue
            
        stripped = line.rstrip('\n')

        # Remove horizontal rules (---)
        if stripped == '---':
            continue

        # Remove HTML comments like <!-- ТПД-13 -->
        # (keep them, they're stripped by pandoc anyway)

        if has_hash2_numbered:
            # Pattern: ## N. Title → # Title (chapter)
            m = re.match(r'^## (\d+)\.\s+(.*)', stripped)
            if m:
                output.append(f'# {m.group(2)}\n')
                continue

            # ### N.N Title → ## Title (section)
            m = re.match(r'^### (\d+\.\d+)\s+(.*)', stripped)
            if m:
                output.append(f'## {m.group(2)}\n')
                continue

            # #### N.N.N Title → ### Title (subsection)
            m = re.match(r'^#### (\d+\.\d+\.\d+)\s+(.*)', stripped)
            if m:
                output.append(f'### {m.group(2)}\n')
                continue

            # #### Title (unnumbered) → bold paragraph
            m = re.match(r'^#### (.*)', stripped)
            if m:
                output.append(f'\n**{m.group(1)}**\n')
                continue
        elif has_unnumbered_h1:
            # РЕГ-6 style: # Title → # Title (already correct for chapter)
            # ## Title → ## Title (already correct for section)
            pass
        elif has_hash1_numbered:
            # Pattern: # N. Title → # Title (chapter, strip number)
            m = re.match(r'^# (\d+)\.\s+(.*)', stripped)
            if m:
                output.append(f'# {m.group(2)}\n')
                continue
            # ## N.N Title → ## Title
            m = re.match(r'^## (\d+\.\d+)\s+(.*)', stripped)
            if m:
                output.append(f'## {m.group(2)}\n')
                continue
            # ### N.N.N Title → ### Title
            m = re.match(r'^### (\d+\.\d+\.\d+)\s+(.*)', stripped)
            if m:
                output.append(f'### {m.group(2)}\n')
                continue

        output.append(line)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(output)

    print(f"Transformed: {len(lines)} → {len(output)} lines")


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.md> <output.md>")
        sys.exit(1)
    transform(sys.argv[1], sys.argv[2])
