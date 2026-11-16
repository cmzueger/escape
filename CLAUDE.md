# Locked In: notes for Claude

Read automatically by Claude Code sessions on this repository. Owner: Christoph
Züger (Switzerland). Sister project of Pawnkick (`cmzueger/pawn-kick`), same
tech stack and habits, but offline only: no server, no accounts.

## The project
"Locked In": a catalogue of escape rooms, landscape, point and click. Rooms:
Hut 2847 (`hut`, easy, 15 min), Gale Rock Light (`light`, medium, 25 min) and
Col Sidereal (`obs`, hard, 35 min).
- `core/` rules in Rust (text commands in, JSON out; all solutions live here):
  `lib.rs` the catalogue and dispatch, one module per room (`hut.rs`,
  `light.rs`, `obs.rs`). `web/` the same as WASM, `godot/` as GDExtension (`HutRoom`).
- `client/` Godot 4.5: `scripts/main.gd` (catalogue, bar, panels, sound
  cues), `views.gd` + `views_light.gd` + `views_obs.gd` (hotspots, navigation, light
  per view), `art.gd` → `art_light.gd` → `art_obs.gd` (each extends the one
  before; every picture, drawn in code from the
  rules' `clues`), `light.gdshader` (darkness, light pools, lightning),
  `sound.gd` and `audio/` (sounds synthesised by `audio/generate.py`, needs
  numpy and ffmpeg; the .ogg files are committed).
- A new room: a module in `core`, an entry in `ROOMS` and `Room`, a views and
  an art script, texts with their own key prefix (the lighthouse uses
  `lmsg.`, `lhint.`, `lintro.`, `lend.`; the observatory `omsg.` and so on), a card picture, a play-through in
  `smoke_test.gd`, and its solutions in `docs/PUZZLES.md`.
- Hosted on GitHub Pages by `.github/workflows/ci.yml` (every push is tested;
  a push to `main` is then deployed to https://cmzueger.github.io/escape/).
- `docs/SPEC.md` has the decision log.

## How we work
- Work directly on `main` (owner, 2026-11-16): commit there and push with
  `git push origin HEAD:main` after checking it is a fast-forward. Do not
  create or push `claude/…` branches, even if a session starts on one.
- Every code change gets a new version in `client/project.godot`
  (`config/version`).
- **The owner plays the rooms unspoiled.** Never put solutions, codes or the
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
- **0.3.0** (2026-11-16): third room Col Sidereal (hard, moonlight look, a
  study and a dome): layered clues, one decoder used three times. Built
  before the owner had played the lighthouse, so its difficulty is untested.
  The catalogue's cards are narrower so that three fit.
- **0.2.0** (2026-11-16): the catalogue "Locked In" with a card per room
  (difficulty, target time, best stars); second room Gale Rock Light (storm
  green look with lightning); sound (atmospheres and effects, mute); a target
  time per room. The owner, playing as a couple, finished the hut in 10
  minutes without hints, so it is listed as easy; medium was asked for next.
- **0.1.0** (2026-11-15): first version. Setting, structure, score, tech,
  hosting, art style, format, languages and name chosen by the owner from
  proposals (see SPEC). Web only, no sound yet.

## Open
- An Android build, a custom domain, more rooms (a fourth card needs the
  catalogue to scroll or wrap).
- The owner's play test of the lighthouse and the observatory (time, what was
  unclear) and an
  opinion on the sounds, which were made without anyone hearing them.
