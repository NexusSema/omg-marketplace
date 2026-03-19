#!/bin/bash
# Pull a Confluence page and convert it to Markdown with frontmatter.
#
# Usage: pull-confluence-to-md.sh <page_id> [output.md]
#
# Fetches the page via REST API v2, converts XHTML storage format to Markdown,
# and injects frontmatter with page metadata for round-trip sync.
#
# Handles: headings, lists, tables, code macros, links, bold/italic, images.
# Unknown Confluence macros are preserved as HTML comments.
#
# Requires env vars: ATLASSIAN_EMAIL, ATLASSIAN_API_TOKEN
# Optional: ATLASSIAN_INSTANCE (defaults to yourcompany.atlassian.net)

set -euo pipefail

PAGE_ID="$1"
OUTPUT="${2:-}"

# Resolve credentials
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-yourcompany.atlassian.net}"

if [ -z "$ATLASSIAN_EMAIL" ] || [ -z "$ATLASSIAN_API_TOKEN" ]; then
  echo "Error: ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN must be set"
  exit 1
fi

BASE_URL="https://${ATLASSIAN_INSTANCE}/wiki/api/v2"

# Fetch page
PAGE_JSON=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "${BASE_URL}/pages/${PAGE_ID}?body-format=storage")

# Extract metadata and convert
python3 - "$PAGE_JSON" "$OUTPUT" "$PAGE_ID" << 'PYEOF'
import json
import sys
import re
import html as html_mod

page_json = sys.argv[1]
output_file = sys.argv[2]
page_id = sys.argv[3]

data = json.loads(page_json)

if 'title' not in data:
    print(f"Error: {json.dumps(data, indent=2)}")
    sys.exit(1)

title = data['title']
space_id = data.get('spaceId', '')
version = data['version']['number']
body_html = data['body']['storage']['value']

# Generate output filename if not provided
if not output_file:
    slug = re.sub(r'[^\w\s-]', '', title).strip().replace(' ', '-')
    output_file = f'{slug}.md'


def unescape(text):
    """Unescape HTML entities."""
    return html_mod.unescape(text)


def strip_tags(text):
    """Remove HTML tags, keeping text content."""
    return re.sub(r'<[^>]+>', '', text)


def convert_xhtml_to_md(xhtml):
    """Convert Confluence storage XHTML to Markdown."""
    lines = []

    # Extract and convert code macros first (preserve content)
    def replace_code_macro(m):
        macro_body = m.group(0)
        lang_match = re.search(r'ac:name="language">([^<]+)', macro_body)
        lang = lang_match.group(1) if lang_match else ''
        code_match = re.search(r'<!\[CDATA\[(.*?)\]\]>', macro_body, re.DOTALL)
        if not code_match:
            code_match = re.search(r'<ac:plain-text-body>(.*?)</ac:plain-text-body>', macro_body, re.DOTALL)
        code = code_match.group(1) if code_match else ''
        return f'\n```{lang}\n{code}\n```\n'

    xhtml = re.sub(
        r'<ac:structured-macro\s+ac:name="code"[^>]*>.*?</ac:structured-macro>',
        replace_code_macro,
        xhtml,
        flags=re.DOTALL
    )

    # Preserve unknown macros as HTML comments
    def replace_unknown_macro(m):
        macro_name = re.search(r'ac:name="([^"]+)"', m.group(0))
        name = macro_name.group(1) if macro_name else 'unknown'
        return f'\n<!-- Confluence macro: {name} -->\n'

    xhtml = re.sub(
        r'<ac:structured-macro[^>]*>.*?</ac:structured-macro>',
        replace_unknown_macro,
        xhtml,
        flags=re.DOTALL
    )

    # Images
    def replace_image(m):
        url_match = re.search(r'ri:value="([^"]+)"', m.group(0))
        if url_match:
            return f'![image]({url_match.group(1)})'
        filename_match = re.search(r'ri:filename="([^"]+)"', m.group(0))
        if filename_match:
            return f'![{filename_match.group(1)}]({filename_match.group(1)})'
        return '![image]()'

    xhtml = re.sub(r'<ac:image[^>]*>.*?</ac:image>', replace_image, xhtml, flags=re.DOTALL)

    # Headings
    for level in range(1, 7):
        xhtml = re.sub(
            rf'<h{level}[^>]*>(.*?)</h{level}>',
            lambda m, l=level: f'\n{"#" * l} {unescape(strip_tags(m.group(1)))}\n',
            xhtml,
            flags=re.DOTALL
        )

    # Bold
    xhtml = re.sub(r'<strong>(.*?)</strong>', r'**\1**', xhtml, flags=re.DOTALL)
    xhtml = re.sub(r'<b>(.*?)</b>', r'**\1**', xhtml, flags=re.DOTALL)

    # Italic
    xhtml = re.sub(r'<em>(.*?)</em>', r'*\1*', xhtml, flags=re.DOTALL)
    xhtml = re.sub(r'<i>(.*?)</i>', r'*\1*', xhtml, flags=re.DOTALL)

    # Inline code
    xhtml = re.sub(r'<code>(.*?)</code>', r'`\1`', xhtml, flags=re.DOTALL)

    # Links
    xhtml = re.sub(r'<a\s+href="([^"]+)"[^>]*>(.*?)</a>', r'[\2](\1)', xhtml, flags=re.DOTALL)

    # Horizontal rules
    xhtml = re.sub(r'<hr\s*/?\s*>', '\n---\n', xhtml)

    # Tables
    def convert_table(m):
        table_html = m.group(0)
        rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)
        if not rows:
            return ''

        md_rows = []
        for i, row in enumerate(rows):
            cells = re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', row, re.DOTALL)
            cell_texts = [unescape(strip_tags(c)).strip() for c in cells]
            md_rows.append('| ' + ' | '.join(cell_texts) + ' |')
            if i == 0:
                md_rows.append('| ' + ' | '.join(['---'] * len(cell_texts)) + ' |')

        return '\n' + '\n'.join(md_rows) + '\n'

    xhtml = re.sub(r'<table[^>]*>.*?</table>', convert_table, xhtml, flags=re.DOTALL)

    # Lists - unordered
    def convert_ul(m):
        items = re.findall(r'<li[^>]*>(.*?)</li>', m.group(0), re.DOTALL)
        result = '\n'
        for item in items:
            text = unescape(strip_tags(item)).strip()
            result += f'- {text}\n'
        return result

    xhtml = re.sub(r'<ul[^>]*>(.*?)</ul>', convert_ul, xhtml, flags=re.DOTALL)

    # Lists - ordered
    def convert_ol(m):
        items = re.findall(r'<li[^>]*>(.*?)</li>', m.group(0), re.DOTALL)
        result = '\n'
        for idx, item in enumerate(items, 1):
            text = unescape(strip_tags(item)).strip()
            result += f'{idx}. {text}\n'
        return result

    xhtml = re.sub(r'<ol[^>]*>(.*?)</ol>', convert_ol, xhtml, flags=re.DOTALL)

    # Paragraphs → newlines
    xhtml = re.sub(r'<p[^>]*>(.*?)</p>', lambda m: unescape(strip_tags(m.group(1))) + '\n', xhtml, flags=re.DOTALL)

    # Line breaks
    xhtml = re.sub(r'<br\s*/?\s*>', '\n', xhtml)

    # Strip remaining tags
    xhtml = re.sub(r'<[^>]+>', '', xhtml)

    # Unescape remaining entities
    xhtml = unescape(xhtml)

    # Clean up excessive blank lines
    xhtml = re.sub(r'\n{3,}', '\n\n', xhtml)

    return xhtml.strip()


# Build frontmatter
frontmatter = f"""---
confluence_title: "{title}"
confluence_space_id: "{space_id}"
confluence_page_id: "{page_id}"
confluence_version: {version}
---"""

# Convert body
markdown_body = convert_xhtml_to_md(body_html)

# Write output
result = f'{frontmatter}\n\n{markdown_body}\n'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(result)

print(f'Pulled: {title} (v{version})')
print(f'Saved: {output_file}')
PYEOF
