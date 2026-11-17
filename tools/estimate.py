#!/usr/bin/env python3
"""Estimates how long a room takes from its puzzles' kinds, calibrated on the
owner's play-test times (as a couple, no hints, no bugs).

Kinds (one letter per puzzle, in order):
  A action      use the obvious item on the obvious thing
  B lookup      one clue read straight into a lock or setting
  C combine     two sources, a mapping, an order or a count across views
  D mechanism   reason about a contraption (mirrors, tilting, valves, mixing)
  E deduction   a logic or decoding chain (several steps, a twist)

    python3 tools/estimate.py            # fit, then estimates for every room
    python3 tools/estimate.py AABCCDDE   # estimate a planned room
No spoilers here: only kinds and times.
"""
import pathlib
import re
import sys

# The owner's minutes (as a couple, no hints, no bugs); the kinds come from
# the catalogue in core/src/lib.rs.
TIMES = {
    "hut": (4.85, ""),
    "light": (11.4, "a bug cost time"),
    "obs": (None, "39 min with a bug and hints"),
    "orangery": (2.88, ""),
    "theatre": (7.25, ""),
    "chess": (None, "24 min with hints"),
    "beach": (2.63, ""),
    "train": (4.73, ""),
    "attic": (3.13, ""),
    "tree": (1.1, "before the map mattered"),
    "gondola": (4.28, ""),
}
_LIB = pathlib.Path(__file__).resolve().parent.parent / "core" / "src" / "lib.rs"
ROOMS = {
    room: (kinds,) + TIMES.get(room, (None, ""))
    for room, kinds in re.findall(r'\("(\w+)", "([A-E]+)", \w+::PAR_MINUTES\)', _LIB.read_text())
}
KINDS = "ABCDE"
# Prior guesses, kept when the data cannot tell (no played room has them).
PRIOR = {"A": 0.25, "B": 0.6, "C": 1.0, "D": 1.8, "E": 4.0}


def counts(kinds):
    return [kinds.count(k) for k in KINDS]


def fit():
    """Least squares with a pull towards the prior (few rooms, much noise)."""
    rows = [(counts(k), t) for k, t, _ in ROOMS.values() if t is not None]
    n = len(KINDS)
    lam = 2.0
    a = [[0.0] * n for _ in range(n)]
    b = [0.0] * n
    for x, t in rows:
        for i in range(n):
            b[i] += x[i] * t
            for j in range(n):
                a[i][j] += x[i] * x[j]
    for i, k in enumerate(KINDS):
        a[i][i] += lam
        b[i] += lam * PRIOR[k]
    # Gauss-Jordan.
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
    return {k: max(0.1, b[i]) for i, k in enumerate(KINDS)}


def estimate(kinds, w):
    return sum(w[k] for k in kinds)


if __name__ == "__main__":
    w = fit()
    print("minutes per puzzle kind:", "  ".join(f"{k} {w[k]:.1f}" for k in KINDS))
    if len(sys.argv) > 1:
        print(f"{sys.argv[1]}: about {estimate(sys.argv[1], w):.0f} min")
        sys.exit(0)
    print(f"{'room':10} {'kinds':12} {'estimate':>8} {'owner':>6}")
    for room, (kinds, t, note) in ROOMS.items():
        own = f"{t:.1f}" if t is not None else "-"
        print(f"{room:10} {kinds:12} {estimate(kinds, w):8.1f} {own:>6}  {note}")
