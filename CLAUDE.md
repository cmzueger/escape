# Hut 2847: notes for Claude

Read automatically by Claude Code sessions on this repository. Owner: Christoph
Züger (Switzerland). Sister project of Pawnkick (`cmzueger/pawn-kick`), same
tech stack and habits, but offline only: no server, no accounts.

## The project
An escape room in an alpine hut ("Hut 2847"), landscape, point and click.
- `core/` rules in Rust (text commands in, JSON out; all solutions live here),
  `web/` the same as WASM, `godot/` as GDExtension (class `HutRoom`).
- `client/` Godot 4.5: `scripts/main.gd` (screens, bar, panels), `views.gd`
  (hotspots, navigation, light per view), `art.gd` (every picture, drawn in
  code from the rules' `clues`), `light.gdshader` (darkness and light pools).
- Hosted on GitHub Pages by `.github/workflows/ci.yml` (every push is tested;
  a push to `main` is then deployed to https://cmzueger.github.io/escape/).
- `docs/SPEC.md` has the decision log.

## How we work
- Work on `main`. Sessions may start on a `claude/…` branch: push with
  `git push origin HEAD:main` (and the branch), after checking it is a
  fast-forward.
- **The owner plays the room unspoiled.** Never put solutions, codes or the
  clue chains in chat messages, commit messages, screenshots sent to the
  owner, README or SPEC. They belong only in `docs/PUZZLES.md`, the code and
  the tests. Describe puzzles to the owner by object and type at most.
- The owner chooses from proposals: for design questions offer a few options
  (pictures for visual ones) and let them pick.
- Show a draft or screenshots before UI redesigns (render with Godot under
  `xvfb-run`: `client/tests/smoke_test.gd -- shots <folder>` saves every view;
  those pictures contain solutions, pick what to show).
- Five languages for every text: `client/i18n/strings.csv` (en, de [Swiss
  spelling, no ß], fr, it, es). No solution may depend on a word.
- No pull requests unless asked. No model names in code or commits. Commits end
  with the Co-Authored-By / Claude-Session lines the session gives.
- Tests: `cargo test`; `client/tests/strings_check.py`; the client play-through
  `client/tests/smoke_test.gd` (headless Godot, needs `client/build.sh debug`);
  the browser test `client/tests/web_smoke.js` (see the workflow).
- A change to a drawing's position needs the same change in `views.gd`
  (hotspots) and, for the title and intro buttons, in `web_smoke.js`.

## History (latest first)
- **0.1.0** (2026-11-15): first version. Setting, structure, score, tech,
  hosting, art style, format, languages and name chosen by the owner from
  proposals (see SPEC). Web only, no sound yet.

## Open
- Sound (wind, fire, radio), an Android build, a custom domain.
- The owner's play test: where it was too easy, too hard or unclear.
