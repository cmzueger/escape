#!/usr/bin/env python3
"""The puzzle knowledge base: what each kind of puzzle element costs in
minutes and hints, how hard and how much fun the owner finds it, and what
that predicts for every room (existing or planned).

Sources (all in tools/knowledge/):
  tags.txt     every room's puzzles: kind, element tags, sources, views
               (spoilers; checked against lib.rs ROOMS)
  runs.txt     the owner's Stats exports, pasted as they come
  survey.json  the owner's questionnaire answers (fetched from the survey
               artifact; absent until answered)
plus the room-level times in tools/estimate.py (TIMES).

    python3 tools/knowledge.py                  # report, writes docs/KNOWLEDGE.md
    python3 tools/knowledge.py check            # tags complete and valid (CI)
    python3 tools/knowledge.py plan "F find_hidden read_letter; X read_log read_witness; M mech_slide"
                                                # a planned room: time, label, fun, warnings

docs/KNOWLEDGE.md names elements and puzzle kinds only, never solutions.
"""
import json
import math
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
KB = HERE / "knowledge"
sys.path.insert(0, str(HERE))
import estimate  # noqa: E402  (room-level owner times and kind priors)

KINDS = "ABCFDMEX"
KIND_NAME = {"A": "action", "B": "lookup", "C": "combine", "F": "find", "D": "mechanism",
             "M": "hard mechanism", "E": "deduction", "X": "hard deduction"}
POINTS = {"F": 1, "D": 1, "M": 2, "E": 2, "X": 4}

# The survey's elements and combinations (ids as in survey.html), grouped.
ELEMENTS = {
    "find": ["find_hidden", "find_tiny", "find_container", "find_moment", "decoy"],
    "read": ["read_letter", "read_log", "read_numbers", "read_riddle", "read_witness", "read_rules", "read_backwards"],
    "code": ["code_direct", "code_combine", "code_count", "code_math", "code_map", "code_order"],
    "mech": ["mech_slide", "mech_rotate", "mech_tilt", "mech_pour", "mech_switch", "mech_path", "mech_assemble"],
    "sense": ["sense_light", "sense_mirror", "sense_music", "sense_listen"],
    "space": ["space_split", "space_look", "space_remote", "space_layout"],
    "people": ["talk", "logic_grid"],
    "items": ["item_use", "item_combine", "item_clever"],
    "game": ["game_skill"],
}
COMBOS = ["combo_decoy_twist", "combo_text_mech", "combo_chain", "combo_parallel", "combo_reuse",
          "combo_early_late", "combo_story_clue", "combo_flavour", "combo_cross_room", "combo_trial",
          "combo_precise", "combo_finale"]
FAMILY = {t: g for g, ts in ELEMENTS.items() for t in ts}
VOCAB = set(FAMILY) | set(COMBOS)
LABEL = {
    "find_hidden": "hidden in plain sight", "find_tiny": "a tiny detail", "find_container": "search inside things",
    "find_moment": "only visible at a moment", "decoy": "a decoy", "read_letter": "a letter that points somewhere",
    "read_log": "times in a log", "read_numbers": "numbers hidden in a text", "read_riddle": "a riddle or poem",
    "read_witness": "statements where someone lies", "read_rules": "rules or instructions",
    "read_backwards": "text mirrored or backwards", "code_direct": "a number straight into a lock",
    "code_combine": "two sources make one code", "code_count": "count things", "code_math": "a little arithmetic",
    "code_map": "a mapping", "code_order": "the right order", "mech_slide": "sliding blocks",
    "mech_rotate": "rotate and align", "mech_tilt": "a tilt maze", "mech_pour": "pouring and balancing",
    "mech_switch": "switches with feedback", "mech_path": "thread a path", "mech_assemble": "assemble pieces",
    "sense_light": "a special light reveals", "sense_mirror": "reflections", "sense_music": "play a melody",
    "sense_listen": "listen for a clue", "space_split": "one clue over two views",
    "space_look": "look from one view into another", "space_remote": "change here, see there",
    "space_layout": "how the rooms lie", "talk": "a conversation with choices", "logic_grid": "a logic grid",
    "item_use": "obvious item, obvious place", "item_combine": "combine two items", "item_clever": "an unexpected use",
    "game_skill": "a small game of skill (walk a maze, play a tune, a well-timed tap)",
    "combo_decoy_twist": "a decoy only a twist exposes", "combo_text_mech": "a text explains a mechanism",
    "combo_chain": "a long chain", "combo_parallel": "several puzzles open at once",
    "combo_reuse": "a tool used again later", "combo_early_late": "seen early, needed late",
    "combo_story_clue": "a story note that is also a clue", "combo_flavour": "atmosphere that leads nowhere",
    "combo_cross_room": "a puzzle that needs two rooms", "combo_trial": "trying is the way",
    "combo_precise": "planning, or it resets", "combo_finale": "a finale that uses the whole room",
}
# The survey's frustrations (general.frustration.N) and the tags they touch.
# (3, too much reading, is judged by the share of reading puzzles instead.)
FRUSTRATION_TAGS = {1: ["find_tiny"], 5: ["code_math"], 8: ["space_split", "space_remote"],
                    9: ["decoy", "combo_decoy_twist"], 11: ["combo_precise"]}


# --- Loading -----------------------------------------------------------------------

def load_tags():
    rooms, room = {}, None
    for n, line in enumerate((KB / "tags.txt").read_text().splitlines(), 1):
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        m = re.fullmatch(r"\[(\w+)\]", line)
        if m:
            room = m.group(1)
            rooms[room] = []
            continue
        m = re.fullmatch(r"(\w+):\s*([A-Z])\s*\|\s*([\w ]*)\|\s*(\d+)\s+(\d+)", line)
        if not m or room is None:
            raise SystemExit(f"tags.txt:{n}: cannot read {line!r}")
        rooms[room].append({"label": m.group(1), "kind": m.group(2), "tags": m.group(3).split(),
                            "sources": int(m.group(4)), "views": int(m.group(5))})
    for spec in rooms.values():
        for p in spec:
            p["room_size"] = len(spec)
    return rooms


def catalogue_kinds():
    text = (ROOT / "core/src/lib.rs").read_text()
    return dict(re.findall(r'\("(\w+)", "([A-Z]+)", \w+::PAR_MINUTES\)', text))


def clock(s):
    m, sec = s.split(":")
    return int(m) * 60 + int(sec)


def load_runs():
    """Finished runs with per-puzzle events: {room, total, hints, events[(kind, puzzle, secs)]}."""
    runs, room = [], None
    for line in (KB / "runs.txt").read_text().splitlines():
        m = re.match(r"(\w+) \(target", line)
        if m:
            room = m.group(1)
            continue
        m = re.match(r"\s+done \S+ (\d+:\d\d) hints (\d+) taps (\d+) stars [\d.]+ \| ?(.*)", line)
        if m and room:
            events = []
            for e in m.group(4).split():
                em = re.fullmatch(r"([ph])(\d+)(?:\.\d+)?@(\d+:\d\d)", e)
                if em:
                    events.append((em.group(1), int(em.group(2)), clock(em.group(3))))
            rated = dict(re.findall(r"(fun|difficulty|length) (\d)", line.split("| rated ")[1])) if "| rated " in line else {}
            runs.append({"room": room, "total": clock(m.group(1)) / 60, "hints": int(m.group(2)),
                         "taps": int(m.group(3)), "events": sorted(events, key=lambda e: e[2]),
                         "rated": {k: int(v) for k, v in rated.items()}})
    return runs


def load_survey():
    """The questionnaire's answers, plus what the owner said in the chat
    (notes.json; a questionnaire answer wins)."""
    p = KB / "survey.json"
    survey = json.loads(p.read_text()) if p.exists() else {}
    notes = KB / "notes.json"
    if notes.exists():
        for k, v in json.loads(notes.read_text()).items():
            survey.setdefault(k, v)
    return survey


# --- Per-puzzle observations ----------------------------------------------------------

def puzzle_times(run):
    """Minutes from the previous solve to each puzzle's solve, and hints per puzzle."""
    mins, hints, last = {}, {}, 0
    for kind, p, t in run["events"]:
        if kind == "h":
            hints[p] = hints.get(p, 0) + 1
        elif p not in mins:
            mins[p] = (t - last) / 60
            last = t
    return mins, hints


# --- The time model -------------------------------------------------------------------

def features(puzzle):
    f = {"k:" + puzzle["kind"]: 1.0}
    for t in puzzle["tags"]:
        f["t:" + t] = 1.0
    f["sources"] = max(0, puzzle["sources"] - 1)
    f["views"] = max(0, puzzle["views"] - 1)
    # The owner (2026-11-21): in a big room the easy steps take longer, the
    # right spot has to be found among many and an overview built first.
    if puzzle["kind"] in "ABCF":
        f["big_room"] = max(0, puzzle.get("room_size", 6) - 8) / 8
    return f


def solve(a, b):
    n = len(b)
    for i in range(n):
        p = a[i][i]
        for j in range(n):
            a[i][j] /= p
        b[i] /= p
        for r in range(n):
            if r != i and a[r][i]:
                f = a[r][i]
                for j in range(n):
                    a[r][j] -= f * a[i][j]
                b[r] -= f * b[i]
    return b


# Minutes a hint stands for: the time the owner would still have needed.
HINT_MINUTES = estimate.HINT_MINUTES


def fit(rooms, runs):
    """Ridge regression on minutes: puzzle-level rows from the runs, room-level
    rows (sums) from the owner's best times. A puzzle solved with hints
    counts too (owner, 2026-11-21): each hint stands for HINT_MINUTES more
    the owner would still have needed, and the row weighs a little less.
    Kinds pull towards estimate.py's priors, everything else towards 0."""
    names = ["k:" + k for k in KINDS] + ["t:" + t for t in sorted(VOCAB)] + ["sources", "views", "big_room"]
    idx = {n: i for i, n in enumerate(names)}
    rows = []
    split_rooms = set()
    for run in runs:
        spec = rooms.get(run["room"])
        if not spec:
            continue
        mins, hints = puzzle_times(run)
        for p, m in mins.items():
            if 1 <= p <= len(spec):
                h = hints.get(p, 0)
                rows.append((features(spec[p - 1]), m + HINT_MINUTES * h, 1.0 if h == 0 else 0.7))
        split_rooms.add(run["room"])
    for room, (kinds, t, _) in estimate.ROOMS.items():
        if t is None or room in split_rooms or room not in rooms:
            continue
        total = {}
        for p in rooms[room]:
            for k, v in features(p).items():
                total[k] = total.get(k, 0) + v
        rows.append((total, t, 0.6 * (0.7 if room in estimate.HINTED else 1.0)))
    n = len(names)
    a = [[0.0] * n for _ in range(n)]
    b = [0.0] * n
    for f, t, w in rows:
        for ki, vi in f.items():
            i = idx[ki]
            b[i] += w * vi * t
            for kj, vj in f.items():
                a[i][idx[kj]] += w * vi * vj
    for name, i in idx.items():
        if name.startswith("k:"):
            lam, prior = 2.0, estimate.PRIOR[name[2:]]
        else:
            lam, prior = 6.0, 0.0
        a[i][i] += lam
        b[i] += lam * prior
    x = solve(a, b)
    return {name: x[i] for name, i in idx.items()}, len(rows)


def predict(puzzle, w):
    return max(0.1, sum(w.get(k, 0.0) * v for k, v in features(puzzle).items()))


# --- Taste (survey) ---------------------------------------------------------------------

def rating(survey, tag, what):
    key = ("co." if tag.startswith("combo_") else "el.") + tag + "." + what
    v = survey.get(key)
    return v if isinstance(v, (int, float)) else None


def puzzle_taste(puzzle, survey, what):
    vals = [r for r in (rating(survey, t, what) for t in puzzle["tags"]) if r is not None]
    return sum(vals) / len(vals) if vals else None


def room_fun(spec, survey):
    vals = [v for v in (puzzle_taste(p, survey, "fun") for p in spec) if v is not None]
    if not vals:
        return None
    families = {FAMILY.get(t) for p in spec for t in p["tags"] if t in FAMILY}
    variety = min(0.5, 0.08 * len(families))
    return min(5.0, sum(vals) / len(vals) + variety)


def rated_fun(room, survey, runs):
    """The owner's fun rating of a room: the end-screen ratings of its runs
    and the questionnaire's, averaged."""
    vals = [r["rated"]["fun"] for r in runs if r["room"] == room and "fun" in r["rated"]]
    q = survey.get(f"room.{room}.fun")
    if isinstance(q, (int, float)):
        vals.append(q)
    return sum(vals) / len(vals) if vals else None


def label(points):
    return "hard" if points >= 8 else "medium" if points >= 4 else "easy"


# --- Warnings -----------------------------------------------------------------------------

def warnings(spec, survey, observed=None):
    out = []
    kinds = "".join(p["kind"] for p in spec)
    streak = re.findall(r"[AB]{3,}", kinds)
    if streak:
        out.append(f"{max(len(s) for s in streak)} simple steps (actions or lookups) in a row")
    if not any(k in kinds for k in "DM"):
        out.append("no mechanism at all")
    else:
        gaps = re.split(r"[DM]", kinds)
        if max(len(g) for g in gaps) >= 5:
            out.append("five or more puzzles in a row without a mechanism")
    counts = {}
    for p in spec:
        for t in p["tags"]:
            if t in FAMILY and t != "item_use":
                counts[t] = counts.get(t, 0) + 1
    for t, c in sorted(counts.items()):
        if c >= 3:
            out.append(f"{LABEL[t]} {c} times")
    reading = sum(1 for p in spec if any(FAMILY.get(t) == "read" for t in p["tags"]))
    if (survey.get("general.text") == 1 or survey.get("general.frustration.3")) and reading > len(spec) * 0.5:
        out.append(f"{reading} of {len(spec)} puzzles need reading (too much reading frustrates the owner)")
    for n, ts in FRUSTRATION_TAGS.items():
        if survey.get(f"general.frustration.{n}") and ts:
            hit = [i + 1 for i, p in enumerate(spec) if set(p["tags"]) & set(ts)]
            if hit:
                out.append(f"puzzles {', '.join(map(str, hit))} touch a stated frustration ({', '.join(LABEL[t] for t in ts)})")
    for i, p in enumerate(spec, 1):
        fun = puzzle_taste(p, survey, "fun")
        if fun is not None and fun <= 2.0:
            out.append(f"puzzle {i} ({KIND_NAME[p['kind']]}) is built from elements rated dull")
        diff = puzzle_taste(p, survey, "diff")
        if diff is not None and diff >= 4.5:
            out.append(f"puzzle {i} ({KIND_NAME[p['kind']]}) is built from elements rated too hard")
    for i, (hints, ratio) in (observed or {}).items():
        p = spec[i - 1]
        if hints >= 2:
            out.append(f"puzzle {i} ({KIND_NAME[p['kind']]}) needed {hints} hints")
        if ratio and ratio >= 2.5:
            out.append(f"puzzle {i} ({KIND_NAME[p['kind']]}) took {ratio:.1f} times the predicted time")
    return out


# --- Commands -------------------------------------------------------------------------------

def check(rooms):
    problems = []
    cat = catalogue_kinds()
    for room, kinds in cat.items():
        spec = rooms.get(room)
        if spec is None:
            problems.append(f"{room}: no entry in tags.txt")
            continue
        got = "".join(p["kind"] for p in spec)
        if got != kinds:
            problems.append(f"{room}: kinds {got} in tags.txt, {kinds} in lib.rs")
        for p in spec:
            bad = [t for t in p["tags"] if t not in VOCAB]
            if bad:
                problems.append(f"{room}.{p['label']}: unknown tags {bad}")
            if not p["tags"]:
                problems.append(f"{room}.{p['label']}: no tags")
    for room in rooms:
        if room not in cat:
            problems.append(f"{room}: in tags.txt but not in the catalogue")
    survey = (KB / "survey.html").read_text()
    for t in VOCAB:
        if f'"{t}"' not in survey:
            problems.append(f"tag {t} is not asked in survey.html")
    return problems


def report(rooms, runs, survey):
    w, nrows = fit(rooms, runs)
    lines = ["# Puzzle knowledge", "",
             "What each kind of puzzle element costs and how it feels, from the owner's",
             "play times (Stats exports), hints and questionnaire answers. Generated by",
             "`python3 tools/knowledge.py`; do not edit by hand. No solutions here: puzzles",
             "are named by number and kind only.", ""]
    lines += [f"Data: {len(runs)} runs with puzzle times, {sum(1 for r in estimate.ROOMS.values() if r[1])} room times, "
              f"{'questionnaire answered' if survey else 'questionnaire not answered yet'}; {nrows} rows fitted.", ""]
    # Elements.
    use = {}
    for spec in rooms.values():
        for p in spec:
            for t in p["tags"]:
                use[t] = use.get(t, 0) + 1
    obs_hints, obs_n = {}, {}
    for run in runs:
        spec = rooms.get(run["room"], [])
        mins, hints = puzzle_times(run)
        for p in mins:
            if 1 <= p <= len(spec):
                for t in spec[p - 1]["tags"]:
                    obs_n[t] = obs_n.get(t, 0) + 1
                    obs_hints[t] = obs_hints.get(t, 0) + hints.get(p, 0)
    lines += ["## Elements", "",
              "Minutes: the fitted extra time an element adds to a puzzle (on top of its kind).",
              "Hints: hints asked per observed puzzle with it. Fun and difficulty: the owner's",
              "answers (1 to 5). Rooms: puzzles using it across the catalogue.", "",
              "| Element | Group | Minutes | Hints | Fun | Difficulty | More? | Puzzles |",
              "|---|---|---:|---:|---:|---:|---|---:|"]
    more_word = {1: "less", 2: "same", 3: "more"}
    for g, ts in list(ELEMENTS.items()) + [("combination", COMBOS)]:
        for t in ts:
            fun, diff, more = rating(survey, t, "fun"), rating(survey, t, "diff"), rating(survey, t, "more")
            h = f"{obs_hints.get(t, 0) / obs_n[t]:.1f}" if obs_n.get(t) else "-"
            lines.append(f"| {LABEL[t]} | {g} | {w['t:' + t]:+.1f} | {h} | {fun or '-'} | {diff or '-'} | "
                         f"{more_word.get(more, '-')} | {use.get(t, 0)} |")
    lines += ["", "Minutes per puzzle kind: " + ", ".join(f"{KIND_NAME[k]} {w['k:' + k]:.1f}" for k in KINDS)
              + f"; each extra clue source {w['sources']:+.1f}, each extra view {w['views']:+.1f}, an easy step in a big room (24 puzzles) {w['big_room'] * 2:+.1f}.", ""]
    # Rooms.
    lines += ["## Rooms", "",
              "Predicted: owner minutes from the tags (the target is about 0.8 times that).",
              "Label: from the kinds (lib.rs). Felt: mean difficulty of the elements (owner's",
              "answers). Fun: forecast from the elements, then the owner's rating if given.", "",
              "| Room | Puzzles | Predicted | Owner | Label | Felt | Fun forecast | Fun rated |",
              "|---|---:|---:|---:|---|---:|---:|---:|"]
    notes = []
    pairs = [(room_fun(spec, survey), rated_fun(room, survey, runs)) for room, spec in rooms.items()]
    pairs = [(f, r) for f, r in pairs if f and r]
    offset = sum(r - f for f, r in pairs) / len(pairs) if pairs else 0.0
    for room, spec in rooms.items():
        pred = sum(predict(p, w) for p in spec)
        own = estimate.ROOMS.get(room, (None, None, ""))[1]
        pts = sum(POINTS.get(p["kind"], 0) for p in spec)
        felt = [v for v in (puzzle_taste(p, survey, "diff") for p in spec) if v is not None]
        fun = room_fun(spec, survey)
        if fun:
            fun = max(1.0, min(5.0, fun + offset))
        rated = rated_fun(room, survey, runs)
        if rated:
            rated = round(rated, 1)
        lines.append(f"| {room} | {len(spec)} | {pred:.1f} | {own if own else '-'} | {label(pts)} | "
                     f"{sum(felt) / len(felt):.1f} | " if felt else f"| {room} | {len(spec)} | {pred:.1f} | "
                     f"{own if own else '-'} | {label(pts)} | - | ")
        lines[-1] += f"{fun:.1f} | " if fun else "- | "
        lines[-1] += f"{rated} |" if rated else "- |"
        observed = {}
        for run in runs:
            if run["room"] != room:
                continue
            mins, hints = puzzle_times(run)
            for p, m in mins.items():
                if 1 <= p <= len(spec):
                    observed[p] = (hints.get(p, 0), m / predict(spec[p - 1], w))
        ws = warnings(spec, survey, observed)
        lengths = [r["rated"]["length"] for r in runs if r["room"] == room and "length" in r["rated"]]
        if lengths and sum(lengths) / len(lengths) < 1.5:
            ws.append("rated too short after playing")
        if lengths and sum(lengths) / len(lengths) > 2.5:
            ws.append("rated too long after playing")
        diffs = [r["rated"]["difficulty"] for r in runs if r["room"] == room and "difficulty" in r["rated"]]
        if diffs and abs(sum(diffs) / len(diffs) - 3) >= 1.5:
            ws.append("felt " + ("far too easy" if sum(diffs) / len(diffs) < 3 else "far too hard") + " after playing")
        if ws:
            notes.append(f"- **{room}**: " + "; ".join(ws) + ".")
    lines += ["", f"Fun forecasts are shifted by {offset:+.1f} to match the rooms the owner rated ({len(pairs)}).", ""]
    lines += ["## Warnings", "", *(notes or ["None."]), ""]
    # Survey free text.
    texts = [(k, v) for k, v in survey.items() if isinstance(v, str) and v.strip() and not k.startswith("_")]
    if texts:
        lines += ["## The owner's notes", ""] + [f"- `{k}`: {v}" for k, v in sorted(texts)] + [""]
    out = "\n".join(lines)
    (ROOT / "docs/KNOWLEDGE.md").write_text(out)
    return out


def plan(text, rooms, runs, survey):
    w, _ = fit(rooms, runs)
    spec = []
    for part in text.split(";"):
        words = part.split()
        if not words:
            continue
        kind, tags = words[0], words[1:]
        bad = [t for t in tags if t not in VOCAB]
        if kind not in KIND_NAME or bad:
            raise SystemExit(f"cannot read {part!r} (kind {kind}, unknown tags {bad})")
        spec.append({"label": "", "kind": kind, "tags": tags, "sources": 1, "views": 1})
    for p in spec:
        p["room_size"] = len(spec)
    pred = sum(predict(p, w) for p in spec)
    pts = sum(POINTS.get(p["kind"], 0) for p in spec)
    fun = room_fun(spec, survey)
    pairs = [(room_fun(s, survey), survey.get(f"room.{r}.fun")) for r, s in rooms.items()]
    pairs = [(f, r) for f, r in pairs if f and isinstance(r, (int, float))]
    if fun and pairs:
        fun = max(1.0, min(5.0, fun + sum(r - f for f, r in pairs) / len(pairs)))
    print(f"{len(spec)} puzzles: about {pred:.0f} owner minutes (target {target(pred)}), {label(pts)} ({pts} points)"
          + (f", fun forecast {fun:.1f} of 5" if fun else ""))
    for i, p in enumerate(spec, 1):
        print(f"  {i}. {KIND_NAME[p['kind']]:15} {predict(p, w):4.1f} min  {' '.join(p['tags'])}")
    for x in warnings(spec, survey):
        print("  warning:", x)


def target(minutes):
    """A room's target from its predicted owner minutes (owner, 2026-11-21):
    0.8 times to the nearest minute, and never under 5 minutes (owner,
    2026-11-21: the smallest rooms' targets were too short to be fair)."""
    return max(5, round(0.8 * minutes))


def targets(rooms, runs):
    """Each room's target from the learned model (the owner's stats only
    teach the model; no room's target is taken from its own time)."""
    w, _ = fit(rooms, runs)
    return {room: target(sum(predict(p, w) for p in spec)) for room, spec in rooms.items()}


def par_files():
    out = {}
    for f in sorted((ROOT / "core/src").glob("*.rs")):
        m = re.search(r"pub const PAR_MINUTES: u32 = (\d+);", f.read_text())
        if m:
            out[f.stem] = (f, int(m.group(1)))
    return out


def sync_targets(rooms, runs, write):
    """Compares (or with write, sets) every room's PAR_MINUTES to the model."""
    wanted, have, problems = targets(rooms, runs), par_files(), []
    for room, t in sorted(wanted.items()):
        if room not in have:
            continue
        f, now = have[room]
        if now != t:
            if write:
                f.write_text(re.sub(r"pub const PAR_MINUTES: u32 = \d+;", f"pub const PAR_MINUTES: u32 = {t};", f.read_text()))
                print(f"{room}: {now} -> {t} min")
            else:
                problems.append(f"{room}: target {now} min, the model says {t} (run tools/knowledge.py targets --write)")
    return problems


if __name__ == "__main__":
    rooms = load_tags()
    if len(sys.argv) > 1 and sys.argv[1] == "check":
        problems = check(rooms) + sync_targets(rooms, load_runs(), False)
        for p in problems:
            print("FAIL", p)
        print("RESULT:", "PASS" if not problems else f"FAIL ({len(problems)})")
        sys.exit(1 if problems else 0)
    runs, survey = load_runs(), load_survey()
    if len(sys.argv) > 1 and sys.argv[1] == "targets":
        sync_targets(rooms, runs, "--write" in sys.argv)
        for room, t in sorted(targets(rooms, runs).items()):
            print(f"  {room}: {t} min")
    elif len(sys.argv) > 2 and sys.argv[1] == "plan":
        plan(sys.argv[2], rooms, runs, survey)
    else:
        print(report(rooms, runs, survey))
