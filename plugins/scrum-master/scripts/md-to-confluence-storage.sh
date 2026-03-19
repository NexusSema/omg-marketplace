#!/bin/bash
# Convert a Markdown file to Confluence storage format (XHTML).
#
# Usage: md-to-confluence-storage.sh <input.md> [output.html]
#
# - Strips YAML frontmatter before converting
# - Converts: headings, bold, italic, lists (nested), tables, code blocks,
#   inline code, links, images, horizontal rules
# - XHTML-safe output (escapes &, <, >)
# - Python3 stdlib only — no pip dependencies

set -euo pipefail

INPUT="$1"
OUTPUT="${2:-}"

if [ ! -f "$INPUT" ]; then
  echo "Error: File not found: $INPUT"
  exit 1
fi

if [ -z "$OUTPUT" ]; then
  OUTPUT="${INPUT%.md}.html"
fi

python3 - "$INPUT" "$OUTPUT" << 'PYEOF'
import sys
import re
import html

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Strip YAML frontmatter
content = re.sub(r'^---\s*\n.*?\n---\s*\n', '', content, count=1, flags=re.DOTALL)

lines = content.split('\n')
output_lines = []
in_code_block = False
code_lang = ''
code_lines = []
in_table = False
table_rows = []
in_list = False
list_stack = []  # stack of (indent_level, list_type)
list_lines = []


def escape(text):
    """HTML-escape text."""
    return html.escape(text, quote=True)


def convert_inline(text):
    """Convert inline markdown to XHTML."""
    # Images: ![alt](url)
    text = re.sub(
        r'!\[([^\]]*)\]\(([^)]+)\)',
        r'<ac:image><ri:url ri:value="\2" /></ac:image>',
        text
    )
    # Links: [text](url)
    text = re.sub(
        r'\[([^\]]+)\]\(([^)]+)\)',
        r'<a href="\2">\1</a>',
        text
    )
    # Bold+Italic: ***text*** or ___text___
    text = re.sub(r'\*\*\*(.+?)\*\*\*', r'<strong><em>\1</em></strong>', text)
    text = re.sub(r'___(.+?)___', r'<strong><em>\1</em></strong>', text)
    # Bold: **text** or __text__
    text = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'__(.+?)__', r'<strong>\1</strong>', text)
    # Italic: *text* or _text_
    text = re.sub(r'\*(.+?)\*', r'<em>\1</em>', text)
    text = re.sub(r'(?<!\w)_(.+?)_(?!\w)', r'<em>\1</em>', text)
    # Inline code: `text`
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    return text


def flush_list():
    """Flush accumulated list items into XHTML."""
    global list_lines
    if not list_lines:
        return ''

    result = []
    stack = []  # (indent, tag)

    for indent, ordered, item_text in list_lines:
        tag = 'ol' if ordered else 'ul'

        # Close deeper nesting levels
        while stack and stack[-1][0] > indent:
            old_indent, old_tag = stack.pop()
            result.append(f'</li></{old_tag}>')

        if not stack:
            # First item or back to empty
            result.append(f'<{tag}>')
            stack.append((indent, tag))
        elif indent > stack[-1][0]:
            # Deeper nesting — open new sublist
            result.append(f'<{tag}>')
            stack.append((indent, tag))
        else:
            # Same level — close previous item
            result.append('</li>')

        result.append(f'<li>{convert_inline(escape(item_text))}')

    while stack:
        old_indent, old_tag = stack.pop()
        result.append(f'</li></{old_tag}>')

    list_lines = []
    return ''.join(result)


def flush_table():
    """Flush accumulated table rows into XHTML."""
    global table_rows
    if not table_rows:
        return ''

    result = ['<table>']
    for i, row in enumerate(table_rows):
        cells = [c.strip() for c in row.strip('|').split('|')]
        # Skip separator row (---|----|---)
        if all(re.match(r'^[-:]+$', c.strip()) for c in cells):
            continue
        result.append('<tr>')
        for cell in cells:
            tag = 'th' if i == 0 else 'td'
            result.append(f'<{tag}>{convert_inline(escape(cell))}</{tag}>')
        result.append('</tr>')
    result.append('</table>')

    table_rows = []
    return ''.join(result)


i = 0
while i < len(lines):
    line = lines[i]

    # Code block start/end
    code_match = re.match(r'^```(\w*)', line)
    if code_match:
        if in_code_block:
            # End code block
            code_content = escape('\n'.join(code_lines))
            lang_attr = f' ac:name="code"'
            params = ''
            if code_lang:
                params = f'<ac:parameter ac:name="language">{escape(code_lang)}</ac:parameter>'
            output_lines.append(
                f'<ac:structured-macro{lang_attr}>'
                f'{params}'
                f'<ac:plain-text-body><![CDATA[{chr(10).join(code_lines)}]]></ac:plain-text-body>'
                f'</ac:structured-macro>'
            )
            in_code_block = False
            code_lines = []
            code_lang = ''
        else:
            # Flush any pending list or table
            flushed = flush_list()
            if flushed:
                output_lines.append(flushed)
            flushed = flush_table()
            if flushed:
                output_lines.append(flushed)
            in_code_block = True
            code_lang = code_match.group(1)
        i += 1
        continue

    if in_code_block:
        code_lines.append(line)
        i += 1
        continue

    # Table row
    if re.match(r'^\|.+\|', line):
        # Flush any pending list
        flushed = flush_list()
        if flushed:
            output_lines.append(flushed)
        table_rows.append(line)
        i += 1
        continue
    elif table_rows:
        flushed = flush_table()
        if flushed:
            output_lines.append(flushed)

    # List item (unordered)
    ul_match = re.match(r'^(\s*)[*+-]\s+(.+)', line)
    # List item (ordered)
    ol_match = re.match(r'^(\s*)\d+\.\s+(.+)', line)

    if ul_match:
        indent = len(ul_match.group(1))
        list_lines.append((indent, False, ul_match.group(2)))
        i += 1
        continue
    elif ol_match:
        indent = len(ol_match.group(1))
        list_lines.append((indent, True, ol_match.group(2)))
        i += 1
        continue
    elif list_lines:
        flushed = flush_list()
        if flushed:
            output_lines.append(flushed)

    # Heading
    heading_match = re.match(r'^(#{1,6})\s+(.+)', line)
    if heading_match:
        level = len(heading_match.group(1))
        text = heading_match.group(2)
        output_lines.append(f'<h{level}>{convert_inline(escape(text))}</h{level}>')
        i += 1
        continue

    # Horizontal rule
    if re.match(r'^(-{3,}|_{3,}|\*{3,})\s*$', line):
        output_lines.append('<hr />')
        i += 1
        continue

    # Blank line
    if line.strip() == '':
        i += 1
        continue

    # Regular paragraph
    output_lines.append(f'<p>{convert_inline(escape(line))}</p>')
    i += 1

# Flush remaining
flushed = flush_list()
if flushed:
    output_lines.append(flushed)
flushed = flush_table()
if flushed:
    output_lines.append(flushed)

result = '\n'.join(output_lines)

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(result)

print(f'Converted: {input_file} → {output_file}')
PYEOF
