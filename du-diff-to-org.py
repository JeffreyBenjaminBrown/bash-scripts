#!/usr/bin/env python3
"""
Convert a diff of file sizes to an org-mode document showing changes by size.
"""

import re
import sys
from typing import Dict, Tuple

def main():
    # Read from stdin
    diff_content = sys.stdin.read()

    # Parse and generate
    changes = parse_diff(diff_content)
    org_content = generate_org_document(changes)

    # Write to stdout
    print(org_content, end='')


def parse_diff(diff_content: str) -> Dict[str, Tuple[float, float]]:
    """
    Parse the diff content and extract file size changes.

    Returns a dict mapping filepath -> (old_size_kb, new_size_kb)
    """
    changes = {}
    removed_lines = {}  # filepath -> size in KB

    for line in diff_content.split('\n'):
        # Match lines like "-50465136K	/home/jeff"
        removed_match = re.match(r'^-(\d+)K\t(.+)$', line)
        if removed_match:
            size_kb = int(removed_match.group(1))
            filepath = removed_match.group(2)
            removed_lines[filepath] = size_kb
            continue

        # Match lines like "+49416620K	/home/jeff"
        added_match = re.match(r'^\+(\d+)K\t(.+)$', line)
        if added_match:
            size_kb = int(added_match.group(1))
            filepath = added_match.group(2)

            # Check if we have a corresponding removed line
            if filepath in removed_lines:
                old_size = removed_lines[filepath]
                new_size = size_kb
                changes[filepath] = (old_size, new_size)
                del removed_lines[filepath]

    return changes


def generate_org_document(changes: Dict[str, Tuple[float, float]]) -> str:
    """
    Generate the org-mode document from the changes.
    """
    lines = []

    # Add the explanatory first headline
    lines.append("* (change in thousands of kb) (filepath)")
    lines.append("** earlier size")
    lines.append("** later size")

    # Calculate changes and sort by absolute value
    entries = []
    for filepath, (old_kb, new_kb) in changes.items():
        change_kb = new_kb - old_kb

        entries.append({
            'filepath': filepath,
            'old_kb': old_kb,
            'new_kb': new_kb,
            'change_kb': change_kb,
            'abs_change': abs(change_kb)
        })

    # Sort by absolute value of change (descending)
    entries.sort(key=lambda x: x['abs_change'], reverse=True)

    # Generate org entries - only round at the final stage
    for entry in entries:
        change_thousands = round(entry['change_kb'] / 1000)
        old_thousands = round(entry['old_kb'] / 1000)
        new_thousands = round(entry['new_kb'] / 1000)

        sign = '+' if change_thousands >= 0 else ''  # negative sign is automatic

        lines.append(f"* {sign}{change_thousands} {entry['filepath']}")
        lines.append(f"** {old_thousands}")
        lines.append(f"** {new_thousands}")

    return '\n'.join(lines) + '\n'


if __name__ == '__main__':
    main()
