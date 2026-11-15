#!/usr/bin/env python3
"""Checks client/i18n/strings.csv: every key has a text in all five languages,
no German text uses "ß" (Swiss spelling), and every text the rules or the
client ask for exists."""
import csv
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[2]
rows = list(csv.reader(open(root / "client/i18n/strings.csv", encoding="utf-8")))
problems = []
if rows[0] != ["keys", "en", "de", "fr", "it", "es"]:
    problems.append("header: %s" % rows[0])
keys = set()
for row in rows[1:]:
    if len(row) != 6 or any(not cell.strip() for cell in row):
        problems.append("incomplete: %s" % row[:1])
        continue
    if row[0] in keys:
        problems.append("twice: %s" % row[0])
    keys.add(row[0])
    if "ß" in row[2]:
        problems.append("ß in German: %s" % row[0])
    if row[1].count("%") != min(cell.count("%") for cell in row[1:]):
        problems.append("placeholders differ: %s" % row[0])

wanted = set(re.findall(r'"(msg\.\w+)"', (root / "core/src/lib.rs").read_text()))
for script in (root / "client/scripts").glob("*.gd"):
    wanted |= set(re.findall(r'tr\("([a-z_]+\.[a-z_0-9.]+)"\)', script.read_text()))
core = (root / "core/src/lib.rs").read_text()
items = re.search(r"pub const ITEMS[^=]*=\s*\[(.*?)\];", core, re.S).group(1)
wanted |= {"item." + name for name in re.findall(r'"(\w+)"', items)}
wanted |= {"hint.%d.%d" % (p, level) for p in range(1, 10) for level in range(1, 4)}
wanted |= {"intro.1", "intro.2", "intro.3"}
for key in sorted(wanted - keys):
    problems.append("missing: %s" % key)

for problem in problems:
    print("  FAIL ", problem)
print("%d texts, %d asked for" % (len(keys), len(wanted)))
print("RESULT: %s" % ("PASS" if not problems else "FAIL (%d)" % len(problems)))
sys.exit(1 if problems else 0)
