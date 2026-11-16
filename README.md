# Locked In

Escape rooms played in the browser. Offline, no accounts.

| Room | Difficulty | Target | |
|---|---|---|---|
| Hut 2847 | easy | 15 min | Snowed in at an alpine hut; somewhere there is a radio. Nine puzzles. |
| Gale Rock Light | medium | 25 min | A dark lighthouse in a gale and a ship heading for the rocks. Ten puzzles on four floors. |
| Col Sidereal | hard | 35 min | An observatory on a pass whose door only opens once the night's observation is recorded. Ten layered puzzles in a study and a dome. |
| The Orangery | easy | 15 min | A greenhouse in the evening sun, latched from outside. Eight puzzles with water, plants and colours. |
| Curtain Call | medium | 25 min | Backstage after the last performance. Eight puzzles with stage lights, masks and costumes. |
| The Grandmaster's Study | hard | 35 min | Seven problems about how chess pieces move; a chart in the room teaches the moves. |
| Low Tide | easy | 15 min | A bathing hut whose door has swollen shut. Six puzzles with shells, kites and the tide. |
| Night Train | medium | 25 min | A sealed sleeping compartment. Six puzzles with a timetable, a ticket and luggage. |
| The Alchemist's Cellar | hard | 35 min | Make a golden key. Six puzzles about doing things in the right way and order. |

Play: https://cmzueger.github.io/escape/

- `core/` the rooms in Rust (`hut.rs`, `light.rs`, `obs.rs`; the later rooms are data for `kit.rs`): state, puzzles, hints,
  score (`cargo test`).
- `web/` the same as WebAssembly for the web build, `godot/` as a GDExtension
  for the desktop client and the tests.
- `client/` the Godot 4.5 client. Everything is drawn in code
  (`scripts/art*.gd`), texts are in `i18n/strings.csv` (en, de,
  fr, it, es), sounds are synthesised by `audio/generate.py`.
- `docs/SPEC.md` the design and its decisions, `docs/SETUP.md` the one-time
  steps, `docs/PUZZLES.md` **the solutions (spoilers)**.

```sh
cargo test                                   # the rules
client/build.sh debug                        # the extension for Godot
godot --headless --path client --import
godot --headless --path client --script res://tests/smoke_test.gd   # plays all nine rooms
GODOT=godot client/build-web.sh              # the web build in client/export/web
```
