# Locked In: notes for Claude

Read automatically by Claude Code sessions on this repository. Owner: Christoph
Züger (Switzerland). Sister project of Pawnkick (`cmzueger/pawn-kick`), same
tech stack and habits, but offline only: no server, no accounts.

## The project
"Locked In": a catalogue of escape rooms, landscape, point and click. Rooms
(the easy/medium/hard below is where each was meant to sit; the label shown
now follows its puzzle kinds, see `difficulty` in lib.rs):
first set Hut 2847 (`hut`, easy), Gale Rock Light (`light`, medium), Col
Sidereal (`obs`, hard); second set The Orangery
(`orangery`, easy), Curtain Call (`theatre`, medium), The Grandmaster's Study
(`chess`, hard); third set Low Tide (`beach`, easy), Night Train (`train`,
medium), The Alchemist's Cellar (`alch`, hard); fourth set The Attic (`attic`,
easy), The Watchmaker (`watch`, medium), The Night Gallery (`museum`, hard);
fifth set (owner's choice) Lookout (`tree`), Gondola 12 (`gondola`), Praline
Works (`praline`), Tinker & Sons (`toyshop`); sixth set (owner's choice) Graf
Alpina (`zeppelin`), Albatross (`ship`), Base 70° South (`polar`).
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
- The rules from the second set on are **data for `core/src/kit.rs`** (flags, items,
  locks, dials, picks, uses, latching checks, a hook for the odd mechanism):
  see `orangery.rs`, `theatre.rs`, `chess.rs`, `beach.rs`, `train.rs`,
  `alch.rs`, `attic.rs`, `watch.rs`, `museum.rs`, `tree.rs`, `gondola.rs`,
  `praline.rs`, `toyshop.rs`, `zeppelin.rs`, `ship.rs`, `polar.rs`. Write new
  rooms this way. Their pictures are in `art_set2.gd` … `art_set6.gd` (each art script extends the one before;
  constants and helpers must not reuse a parent's name), hotspots in
  `views_set2.gd` … `views_set6.gd`. Item names are global (`item.<name>`
  in the texts): pick names no other room uses. Kit locks and
  dials are moved with `turn` and `flip`.
- A new room: a kit spec in `core`, an entry in `ROOMS` and `Room::call`, views and
  art, texts with their own key prefix (the lighthouse uses
  `lmsg.`, `lhint.`, `lintro.`, `lend.`; the observatory `omsg.` and so on), a card picture, a play-through in
  `smoke_test.gd`, and its solutions in `docs/PUZZLES.md`.
- Hosted on GitHub Pages by `.github/workflows/ci.yml` (every push is tested;
  a push to `main` is then deployed to https://cmzueger.github.io/escape/).
- `docs/SPEC.md` has the decision log.
- Target minutes: one `PAR_MINUTES` per room module (catalogue, score and the
  intro's `%d` all read it). Set per room from the owner's times (about 1.3
  times theirs). Estimate a planned room with `tools/estimate.py` (puzzle
  kinds A action, B lookup, C combine, F find, D mechanism, M hard mechanism,
  E deduction, X hard deduction, fitted to the owner's times; add each new
  time to its table). The label: points F/D 1, M/E 2, X 4; medium from 4,
  hard from 8.

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
- Tests: `cargo test` (includes `no_shortcuts`: a player who knows every
  answer may not solve a puzzle before its `available` holds, finish with a
  puzzle skipped, or carry an item without a use: gate locks and dials with
  `needs`, `a&b` for several flags; a new kit room goes into its list);
  `client/tests/strings_check.py`; `client/tests/views_check.py`;
  `client/tests/layout_check.gd` (under `xvfb-run`: every drawn arrow lies
  on a hotspot, every wheel hotspot has its arrow); the client play-through
  `client/tests/smoke_test.gd` (headless Godot, needs `client/build.sh debug`);
  the browser test `client/tests/web_smoke.js` (see the workflow).
- After a change to the catalogue: `client/tests/title_shots.gd` (under
  `xvfb-run`) renders it in all five languages with the widest cards and
  fails if a card leaves the screen.
- Every view name must be unique across all rooms (the dispatch goes by name,
  newest module first): `views_check.py` fails otherwise.
- Decoys must look like the real thing: the clue that tells them apart is
  the only way (and the first one met should be a decoy).
- A decoder a later puzzle needs again (like the observatory's dome) must
  never freeze; freezing is only for a mechanism held in its solved position.
- A change to a drawing's position needs the same change in `views.gd`
  (hotspots) and, for the title and intro buttons, in `web_smoke.js`.
- `title_shots.gd` needs its output folder (`-- <folder>`); without it the
  script never ends. The catalogue's font has no arrow glyphs: draw them.

## History (latest first)
- **0.8.0** (2026-11-18): sixth set, chosen by the owner in two rounds:
  Graf Alpina (zeppelin; compass and magnets, a cipher rebuilt from a burnt
  page, clues in a photo and through binoculars), Albatross (ship; ballast
  tanks that settle level, coloured glass over an overprinted diagram,
  lighthouses with a mirrored decoy), Base 70° South (polar; a logic grid in
  pictures, UV ink, sliding crates, a message read through the grid). Text
  prefixes z, s, r; views Z, V, R. Catalogue: 19 rooms in seven rows. After
  changing strings.csv, re-import (`--import`) before the headless test.
- **0.7.3** (2026-11-17): the owner asked for a "find" kind (clues that are
  easy to miss) and noted mechanisms and deductions vary in difficulty: kinds
  F, M (hard mechanism) and X (hard deduction) added, the label is now a
  point score. The Night Gallery becomes easy. Next: proposals for new rooms,
  medium to hard, with creative mechanisms, deductions and hidden clues.
- **0.7.2** (2026-11-17): the owner keeps the rooms as they are and wants
  honest labels; difficulty is not length. Each room's puzzle kinds live in
  `ROOMS` (lib.rs); the label follows from them (`difficulty`: hard two or
  more deductions, medium one deduction or three mechanisms, easy the rest),
  the time stays separate; `tools/estimate.py` reads the same kinds. Lookout:
  the map was never needed (the decoy had another flag and the right
  treehouse came first); now three alike treehouses, a decoy met first.
- **0.7.1** (2026-11-17): owner's times: Low Tide 2:38, Night Train 4:44,
  Attic 3:08, Lookout 1:06, Gondola 4:17 ("all rather easy"); targets of the
  played rooms follow (train 7, gondola 6, tree 3). Gondola's first-aid box
  drew its wheels one place left of their hotspots: new `layout_check.gd`.
  New `no_shortcuts` test found locks open before their clue could be seen
  (orangery door, theatre trunk, chess safe, lookout hatch, praline kettle,
  night train panel): now gated. `tools/estimate.py`: deductions (E) take
  about 4 minutes each, every other kind under one; the easy and medium rooms
  have none, the hard ones three or four, hence the gap.
- **0.7.0** (2026-11-17): fifth set, chosen by the owner in two rounds
  (settings, then names and looks; puzzle types voted on): Lookout,
  Gondola 12, Praline Works, Tinker & Sons, aimed between the owner's medium
  and hard times. New mechanisms: a beam through turnable mirrors, a shadow
  sculpture, two tilt boards (one ball; two pralines at once), a torn card
  turned piece by piece, a picture deduction, a dollhouse copying the shop.
  Kit hooks for these live in the room modules. Text prefixes e, q, p, y.
- **0.6.3** (2026-11-17): target times per room from the owner's times
  (asked for: "move towards these"): hut 7, light 15, obs 30, orangery 5,
  theatre 10, chess 25, beach 5, train 10, alch 20, attic 5, watch 10,
  museum 20 minutes (untested rooms estimated). Intros take the minutes from
  the catalogue. The catalogue scrolls by swiping anywhere on it (a swipe
  started on a Play button starts nothing), has a wide scroll bar and a tap
  strip with an arrow (down to the last row, back up). Owner's times so far:
  hut 4:51, light 11:23, obs 39:04, orangery 2:53, theatre 7:15, chess 24:00
  (hints), beach 2:38.
- **0.6.2** (2026-11-17): a hint asked at a puzzle that is not ready yet
  (or already solved) said nothing and gave another puzzle's hint; the owner
  took it for the puzzle in view (chess room, small board). The hint panel
  now says when a hint is for another puzzle (`where` in the rules' answer:
  here, later, done; one `pick_hint` in `lib.rs` for every room).
  `views_check.py` also checks that the views named in hint lists exist in
  the room's own module (the lighthouse chart had lost its hint).
- **0.6.1** (2026-11-17): fixes from the owner's first play tests. The
  lighthouse's chart close-up shared its view name with the chess room's and
  led into it; the observatory's dome stopped turning after the photograph
  though the door code needs it. New checks: `views_check.py` (a view,
  picture or drawing helper name in one place only) and, in the play-through,
  every reachable view belongs to its room (at the start and when solved),
  plus random tapping in every room (stays in the room, no refused command,
  every message has a text). A saved view of another room is not restored.
  Play-test times (owner, as a couple): Orangery and Low Tide 3 min each,
  Curtain Call 8 min, Col Sidereal 40 min with several hints (the dome bug
  cost time); the lighthouse unfinished because of the bug.
- **0.6.0** (2026-11-17): fourth set, again built straight away at the owner's
  request (settings, looks and names by Claude): The Attic, The Watchmaker,
  The Night Gallery. The catalogue scrolls (three rows in view, position
  remembered); chosen without asking, other layouts are open.
- **0.5.0** (2026-11-16): third set, built straight away at the owner's
  request without a proposal round (settings taken from earlier proposals the
  owner had seen but not picked; looks and names chosen by Claude): Low Tide,
  Night Train, The Alchemist's Cellar. The catalogue shows three rows of
  three; a tenth room needs a new catalogue layout (ask the owner).
- **0.4.0** (2026-11-16): second set of three rooms (settings, looks and names
  chosen by the owner in three rounds, then built in one go): The Orangery,
  Curtain Call, The Grandmaster's Study (no chess knowledge needed). The
  catalogue shows two rows of three compact cards. Difficulty: "build now,
  tune later".
- **0.3.1** (2026-11-16): cards keep their width in every language (texts
  are cut with "…", Continue and New game stand one under the other).
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
- An Android build, a custom domain.
- The owner's play test of the fifth set (built 0.7.0) and its targets.
- The owner's play test of the sixth set (built 0.8.0) and its targets.
- In progress: the series The Quiet House (four episodes), see SPEC.
- The owner's play test of the remaining rooms (time, what was unclear), whether the third and fourth sets' settings, looks and names are
  liked, whether the scrolling catalogue is, and an
  opinion on the sounds, which were made without anyone hearing them.
