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
Alpina (`zeppelin`), Albatross (`ship`), Base 70° South (`polar`); the series
The Quiet House (`house1905`, `house1938`, `house1969`, `housenow`); seventh
set (owner's choice) The Night Edition (`press`), The Great Vaudini
(`magic`), Rain on Gale Street (`noir`); eighth set (owner's choice) The
Filter Hall (`filter`), The 8:15 to Nowhere (`railway`), Harvest Moon
(`mill`); ninth set (owner's choice, long and easy to medium) The Glass
Aviary (`aviary`), Hall of Mirrors (`mirrors`), Detention (`school`); the
series Puffin Island (owner's choice: one island in four seasons) `spring`,
`summer`, `autumn`, `winter`.
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
  `praline.rs`, `toyshop.rs`, `zeppelin.rs`, `ship.rs`, `polar.rs`, the
  house rooms, `press.rs`, `magic.rs`, `noir.rs`, `filter.rs`, `railway.rs`,
  `mill.rs`, `aviary.rs`, `mirrors.rs`, `school.rs` (helpers for these three in
  `set9.rs`: two items combined, taps in an order, a moment), `spring.rs`,
  `summer.rs`, `autumn.rs`, `winter.rs` (small games in `island.rs`: rowing
  with a tide, skating that slides, a kite in gusts, strokes on a beat).
  A dial may not be named like a key of the state (`flags`, `inv`, …: a
  test checks it; a dial "flags" once hid every flag). Write new
  rooms this way. Their pictures are in `art_set2.gd` … `art_set6.gd`, `art_house.gd`,
  `art_set7.gd`, `art_set8.gd`, `art_set9.gd`, `art_island.gd` (each art script extends the one before;
  constants and helpers must not reuse a parent's name), hotspots in
  `views_set2.gd` … `views_set6.gd`, `views_house.gd`, `views_set7.gd`, `views_set8.gd`, `views_set9.gd`, `views_island.gd`. Item names are global (`item.<name>`
  in the texts): pick names no other room uses. Kit locks and
  dials are moved with `turn` and `flip`.
- A new room: a kit spec in `core`, an entry in `ROOMS` and `Room::call`, views and
  art, texts with their own key prefix (the lighthouse uses
  `lmsg.`, `lhint.`, `lintro.`, `lend.`; the observatory `omsg.` and so on), a card picture that moves (its `card` reads `t`;
  `card_motion.gd` fails on a still one), a play-through in
  `smoke_test.gd`, and its solutions in `docs/PUZZLES.md`.
- Hosted on GitHub Pages by `.github/workflows/ci.yml` (every push is tested;
  a push to `main` is then deployed to https://cmzueger.github.io/escape/).
- `docs/SPEC.md` has the decision log.
- **Knowledge base** (owner, 2026-11-18: what is perceived how hard and how
  much fun, to judge times, labels and fun of existing and planned rooms):
  `tools/knowledge.py` reads `tools/knowledge/tags.txt` (every puzzle of every
  room: kind, element tags, clue sources, views; spoilers; `check` runs in CI,
  a new room needs its block), `runs.txt` (paste every Stats export the owner
  sends, as is), `survey.json` and the room times in `tools/estimate.py`. It
  writes `docs/KNOWLEDGE.md` (no solutions): minutes and hints per element,
  the owner's fun and difficulty per element, predicted minutes, label, felt
  difficulty and fun per room, and warnings. `plan "F find_hidden; M
  mech_slide; …"` judges a planned room: use it for every proposal. The
  questionnaire is the artifact https://claude.ai/artifact/9ntdR1rQ1zfirEJxzyyixe
  (source `tools/knowledge/survey.html`; element ids there = tags): read its
  answers with ArtifactData `get` collection `survey`, doc `answers`, save the
  fields as `survey.json`, rerun the report. New element kinds go into the
  survey, `ELEMENTS` in knowledge.py and the tags together. What the owner
  says in the chat about elements and rooms goes into `notes.json`.
  Plan future rooms with small games of skill (owner, 2026-11-21).
- Target minutes: one `PAR_MINUTES` per room module (catalogue, score and the
  intro's `%d` all read it). Every target comes from the learned time model
  (owner, 2026-11-21: the owner's stats only teach the model, no room's
  target is taken from its own time): 0.8 times the predicted owner
  minutes, rounded up below 5 minutes. `tools/knowledge.py targets --write`
  sets them; `check` (in CI) fails when one differs, so after pasting new
  stats or tagging a new room, run it. Half a star is lost per started 15 %
  of the target over it (`halves` in lib.rs, `score` in main.gd). Estimate a planned room with `tools/estimate.py` (puzzle
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
- **0.16.0** (2026-11-21): the series Puffin Island, chosen by the owner
  from four series ideas (one island in four seasons, episodes like the
  aviary, each playable alone; a running story with carry-overs; the
  owner's favourite small games: rowing and the regatta, skating on thin
  ice, a kite in the gusts). Spring (rowing through fog with a tide, Pip the
  puffin chick, a lamb led through gates, a patch sown from a verse, flags,
  a puffin call), Summer (a kite carried by gusts to the sea stack, the
  lighthouse beam turned onto a boat, a signal flashed, Pip bringing a
  screw), Autumn (apples shaken in the wind, a cider press, a trade, a pie
  taken out when golden, the regatta rowed on the drum's beat, the spring
  patch harvested), Winter (skating round thin ice marked only in the
  almanac, icicles rung with a carol, coupled lens panels, the light's
  character from a chart). Text prefixes ps, pu, pa, pw; views PS, PU, PA,
  PW. The catalogue's set chip now counts each set by its index in `SETS`
  (series named by `SERIES`). Catalogue: 36 rooms.
- **0.15.0** (2026-11-21): every target from the learned model, asked for by
  the owner ("my stats should only help to learn and tune that model"):
  0.8 times the predicted owner minutes, rounded up below 5 minutes;
  `knowledge.py targets --write` sets them, `check` enforces them.
- **0.14.1** (2026-11-21): best results are counted again at every start
  with today's targets and score (`_rescore` and `score` in main.gd, the
  same rule as `halves` in lib.rs): every run kept in the stats, and the best
  time with its hints (`hints_best`, kept since this version; older results
  take it from the matching run or from the stars they had). Asked for by
  the owner to see the old runs under the stricter stars.
- **0.14.0** (2026-11-21): stricter stars, asked for by the owner ("I
  shouldn't three-star everything"): every target is about 0.8 times the
  owner's time (unplayed rooms: 0.8 times the predicted owner minutes), and
  half a star goes per started 15 % of the target over it instead of per 10
  minutes. Owner's notes in the knowledge base: easy steps take longer in
  big rooms (finding the spots, building an overview; new time-model
  feature `big_room`), and the setting matters a lot for the fun (the
  aviary's above all). Earlier best stars stay as they were recorded.
- **0.13.1** (2026-11-21): owner's play test of two ninth-set rooms: The
  Glass Aviary 12:17 (fun 5, "the best room so far"), Hall of Mirrors 16:32
  (fun 5), no hints, length right; targets 16 and 21. The owner loves small
  games of skill (playing a tune, walking the maze) and wants more "gaming"
  in future rooms: easy coordination guided by clues. New element
  `game_skill` (family "game") in the knowledge base, tagged where it
  occurs; answers given in the chat go into `tools/knowledge/notes.json`
  (same keys as the questionnaire, which wins).
- **0.13.0** (2026-11-19): the catalogue reworked, asked for by the owner
  (filter and sort, names on one line), layout A of three drafts: two
  columns; status chips (All, Not finished, In progress, Finished: finished
  means finished at least once), difficulty chips, a set chip (all, the
  series, sets 1 to 9: `SETS` in main.gd, a new room goes into it), a sort
  chip (newest, easiest, oldest); all remembered in the prefs
  (`shown_rooms()` is what is listed). Full screen in the browser: a button
  (hut-engine.js makes the request when the finger lifts; the button acts on
  touch-down), on iPhones a tip to add the game to the home screen
  (`manifest.webmanifest` and Apple meta tags: it then opens full screen).
  A new room also needs `SETS`; `web_smoke.js` taps cards through the
  filters (they are remembered between its steps).
- **0.12.0** (2026-11-19): ninth set, asked for as longer rooms of easy to
  at most medium difficulty around animals, illusions and school, chosen in
  two rounds: The Glass Aviary (feed and settle every bird: a fish caught as
  it jumps, a parrot that finishes the keeper's greeting, a whistled song,
  perches from a plan in two halves), Hall of Mirrors (a mirror maze stepped
  through cell by cell, a cylinder mirror that straightens a picture, a
  periscope, fuses with a limit, a beam over two mirrors, a sign seen on a
  turning horse), Detention (fifteen tasks on the teacher's list, ticked off
  as they are done; a sliding photo, a harmonium, a bell peal, a janitor at
  the window). About 24 puzzles over four views each; text prefixes av, hm,
  sc; views AV, HM, SC. Things seen only at a moment read the time (the
  client now keeps `secs` in its state each second). Catalogue: 32 rooms in
  eleven rows. A conversation that ends after its secret no longer shows the
  hang-up text.
- **0.11.1** (2026-11-18): the end screen asks three quick ratings (fun 1 to
  5, difficulty 1 to 5, length too short / right / too long), asked for by
  the owner so they are given while memory is fresh. They are written onto
  the room's latest run (`| rated fun F difficulty D length L`) and so reach
  the Stats export; `tools/knowledge.py` reads them (room fun rated, and
  warnings for rooms rated too short, too long, far too easy or too hard).
- **0.11.0** (2026-11-18): eighth set, the first planned with the knowledge
  base (owner's questionnaire answered; rooms of 20 to 30 minutes, big
  mechanisms with visible progress, few plain codes), chosen in two rounds:
  The Filter Hall (pumping station, 1898: water simulated through a pipe
  wall, a filter layered from a riddle, fountain jets set across both
  halls, the main valve opened at the mayor's toast, timed by `secs`), The
  8:15 to Nowhere (model railway: runs follow points in both rooms, a
  shunting yard, a logic grid for the right engine, a sign lit only by a
  passing train), Harvest Moon (windmill: wind read from gusts, sail cloths,
  a gear ratio, a hoist across floors, a logic slate, flour streams down a
  chute). Text prefixes wa, rc, mi (two letters: every single letter is
  taken); views WA, RC, MI. Catalogue: 29 rooms in ten rows. Low Tide's card
  waves could cross themselves (triangulation errors): fixed.
- **0.10.2** (2026-11-18): the knowledge base (see The project): all 26
  rooms tagged, a questionnaire with pictures for the owner (elements,
  combinations, play style, frustrations, ratings per room), the report
  `docs/KNOWLEDGE.md`. The Night Gallery's last two kinds were in the wrong
  order in `ROOMS` (the new check found it).
- **0.10.1** (2026-11-18): every card picture in the catalogue moves (the
  owner loves the moving ones; asked for all rooms and every future one):
  new check `client/tests/card_motion.gd` (in CI) draws each card at two
  moments and fails on a still one. Owner's times from the stats: Praline
  Works 4:40 (target 15 → 6), Graf Alpina 10:46 with four hints (three for
  its first puzzle), Lookout 0:48.
- **0.10.0** (2026-11-18): seventh set, chosen by the owner in two rounds
  (asked for: more text clues, creative mechanisms, slightly hidden clues,
  a little longer): The Night Edition (print works, 1890), The Great Vaudini
  (illusionist's dressing room, 1925), Rain on Gale Street (detective's
  office, 1947). Text prefixes d, v, i (texts drawn in the pictures:
  `dtext.`, `vtext.`, `itext.`); views O, F, I (close-ups d…, f…, i…).
  New mechanisms: setting mirrored type, watermarks against a lantern, a
  paper path and ink keys, a two-way mirror and Pepper's ghost lit from an
  alcove between the rooms, red light hiding red ink, a typewriter ribbon
  read backwards, the key pushed out onto a sheet under the door.
  Catalogue: 26 rooms in nine rows.
- **0.9.1** (2026-11-18): play statistics for tuning, asked for by the owner:
  every finished run keeps its date, time, hints, taps, stars and a log of
  when each puzzle was solved and each hint asked (`p3@4:10`, `h3.1@5:00`;
  last ten runs per room, plus the game in progress). A Stats button on the
  catalogue shows them as text with Copy (`stats_text()` in main.gd). No
  solutions in it: the owner pastes it into the chat. Puzzle numbers are the
  rules' `puzzles` order (1-based, as in the hint keys).
- **0.9.0** (2026-11-18): the series The Quiet House, chosen by the owner in
  three rounds (an old town house in 1905, 1938, 1969 and today; Clara, the
  vanished pianist; the housekeepers' notes behind a stove tile link the
  episodes). Rooms `house1905`, `house1938`, `house1969`, `housenow`; text
  prefixes h, j, u, x (story notes `hstory.`, `jstory.` …); views H, J, U, X
  (`views_house.gd`, `art_house.gd` extends ArtSet6). New in `house.rs`: a
  piano (`key i`, the tune checked from the last keys played) and a
  multiple-choice conversation (`call`, `say i`, a dial "talk" holds the
  line; a wrong answer hangs up). Piano and music-box notes are sounds
  `note0..7`, `mbox0..7` (`generate.py` takes names). Catalogue: 23 rooms.
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
- The owner's opinion on the new catalogue and on full screen on their phone.
- The owner's play test of the fifth set (built 0.7.0) and its targets.
- The owner's play test of the sixth set (built 0.8.0) and its targets.
- The owner's play test of the series The Quiet House (built 0.9.0) and its targets.
- The owner's play test of the seventh set (built 0.10.0) and its targets.
- The owner's play test of the eighth set (built 0.11.0) and its targets.
- The owner's play test of Detention (built 0.12.0) and its target.
- The owner's play test of the series Puffin Island (built 0.16.0).
- The owner's play test of the remaining rooms (time, what was unclear), whether the third and fourth sets' settings, looks and names are
  liked, and an
  opinion on the sounds, which were made without anyone hearing them.
