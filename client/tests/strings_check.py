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

hut = (root / "core/src/hut.rs").read_text()
light = (root / "core/src/light.rs").read_text()
obs = (root / "core/src/obs.rs").read_text()
kits = {"g": "orangery", "t": "theatre", "c": "chess", "b": "beach", "n": "train", "a": "alch",
        "k": "attic", "w": "watch", "m": "museum",
        "e": "tree", "q": "gondola", "p": "praline", "y": "toyshop",
        "z": "zeppelin", "s": "ship", "r": "polar",
        "h": "house1905", "j": "house1938", "u": "house1969", "x": "housenow",
        "d": "press", "v": "magic", "i": "noir",
        "wa": "filter", "rc": "railway", "mi": "mill"}
kit_text = {pre: (root / ("core/src/%s.rs" % name)).read_text() for pre, name in kits.items()}
wanted = set(re.findall(r'"([lo]?msg\.\w+)"', hut + light + obs))
for pre, text in kit_text.items():
    wanted |= set(re.findall(r'"(%smsg\.\w+)"' % pre, text))
    if pre == "a":
        wanted.discard("amsg.step_")
        wanted |= {"amsg.step_crucible", "amsg.step_nugget", "amsg.step_elixir"}
    wanted |= {pre + "msg.nothing", pre + "msg.no_use"}
    flavour = re.search(r"flavour: &\[(.*?)\]", text, re.S).group(1)
    wanted |= {pre + "msg." + spot for spot in re.findall(r'"(\w+)"', flavour)}
    items = re.search(r"items: &\[(.*?)\]", text, re.S).group(1)
    wanted |= {"item." + name for name in re.findall(r'"(\w+)"', items)}
    puzzles = len(re.findall(r"Puzzle \{", text))
    wanted |= {"%shint.%d.%d" % (pre, n, level) for n in range(1, puzzles + 1) for level in range(1, 4)}
    wanted |= {pre + "intro.%d" % i for i in (1, 2, 3)} | {pre + "end.title", pre + "end.text"}
for script in (root / "client/scripts").glob("*.gd"):
    wanted |= set(re.findall(r'tr\("([a-z_]+\.[a-z_0-9.]+)"\)', script.read_text()))
for core in (hut, light, obs):
    items = re.search(r"pub const ITEMS[^=]*=\s*\[(.*?)\];", core, re.S).group(1)
    wanted |= {"item." + name for name in re.findall(r'"(\w+)"', items)}
wanted |= {"hint.%d.%d" % (p, level) for p in range(1, 10) for level in range(1, 4)}
wanted |= {"lhint.%d.%d" % (p, level) for p in range(1, 11) for level in range(1, 4)}
wanted |= {"ohint.%d.%d" % (p, level) for p in range(1, 11) for level in range(1, 4)}
wanted |= {pre + "intro.%d" % i for pre in ("", "l", "o") for i in (1, 2, 3)}
wanted |= {pre + key for pre in ("", "l", "o") for key in ("end.title", "end.text")}
wanted |= {"diff.1", "diff.2", "diff.3"}
for key in sorted(wanted - keys):
    problems.append("missing: %s" % key)

for problem in problems:
    print("  FAIL ", problem)
print("%d texts, %d asked for" % (len(keys), len(wanted)))
print("RESULT: %s" % ("PASS" if not problems else "FAIL (%d)" % len(problems)))
sys.exit(1 if problems else 0)
