#!/usr/bin/env python3
"""Every view name belongs to one room module and every picture and drawing
helper to one art script. A name used twice sends the player into another room (the dispatch
asks the newest module first), as the lighthouse's chart once did."""
import collections
import pathlib
import re
import sys

here = pathlib.Path(__file__).resolve().parent.parent / "scripts"
views = ["views.gd", "views_light.gd", "views_obs.gd", "views_set2.gd", "views_set3.gd", "views_set4.gd", "views_set5.gd", "views_set6.gd", "views_house.gd", "views_set7.gd", "views_set8.gd"]
arts = ["art.gd", "art_light.gd", "art_obs.gd", "art_set2.gd", "art_set3.gd", "art_set4.gd", "art_set5.gd", "art_set6.gd", "art_house.gd", "art_set7.gd", "art_set8.gd"]

owner = collections.defaultdict(set)
for name in views:
    s = (here / name).read_text()
    for m in re.finditer(r'"go:(\w+)"', s):
        owner[m.group(1)].add(name)
    for const in ("PARENT", "FIRST"):
        m = re.search(r"const %s := \{(.*?)\n\}" % const, s, re.S)
        if m:
            for a, b in re.findall(r'"(\w+)":\s*"(\w+)"', m.group(1)):
                if const == "PARENT":
                    owner[a].add(name)
                owner[b].add(name)
    for m in re.finditer(r"const (?:RINGS|MAIN_ROOM|WARDEN_ROOM|FLOORS|STUDY|DOME) := (\[.*?\])\n", s):
        for v in re.findall(r'"(\w+)"', m.group(1)):
            owner[v].add(name)

drawn = collections.defaultdict(set)
for name in arts:
    for v in re.findall(r'^\t\t"(\w+)":\s*_\w+\(', (here / name).read_text(), re.M):
        drawn[v].add(name)

# The art scripts extend each other: a helper defined twice replaces the
# older room's drawing. Only these are meant to be overridden.
helpers = collections.defaultdict(set)
for name in arts:
    for f in re.findall(r"^func (\w+)\(", (here / name).read_text(), re.M):
        if f not in ("draw_view", "item", "card"):
            helpers[f].add(name)

failures = 0
# Every view a room's hint list names must exist (a renamed view loses its hints).
core = here.parent.parent / "core" / "src"
for rs in sorted(core.glob("*.rs")):
    text = rs.read_text()
    names = []
    m = re.search(r"hint_views: &\[(.*?)\n    \],", text, re.S)
    if m:
        names += re.findall(r'\("(\w+)", &\[', m.group(1))
    m = re.search(r"fn hint_puzzle.*?let wanted: &\[usize\] = match view \{(.*?)\n        \};", text, re.S)
    if m:
        for arm in re.findall(r'^\s+((?:"\w+"(?: \| )?)+) =>', m.group(1), re.M):
            names += re.findall(r'"(\w+)"', arm)
    module = {"hut": "views.gd", "light": "views_light.gd", "obs": "views_obs.gd"}.get(rs.stem)
    for name in views[3:]:
        m = re.search(r"const FIRST := \{(.*?)\}", (here / name).read_text())
        if m and '"%s"' % rs.stem in m.group(1):
            module = name
    for v in names:
        if module not in owner.get(v, set()):
            print("FAIL hint view %s in %s is no view of %s" % (v, rs.name, module))
            failures += 1
for kind, table in (("view", owner), ("picture", drawn), ("art helper", helpers)):
    for v, where in sorted(table.items()):
        if len(where) > 1:
            print("FAIL %s %s is in %s" % (kind, v, ", ".join(sorted(where))))
            failures += 1
print("%d views, %d pictures" % (len(owner), len(drawn)))
print("RESULT: %s" % ("PASS" if failures == 0 else "FAIL"))
sys.exit(1 if failures else 0)
