# Locked In

Escape rooms played in the browser. Offline, no accounts.

| Room | Difficulty | Target | |
|---|---|---|---|
| Hut 2847 | easy | 15 min | Snowed in at an alpine hut; somewhere there is a radio. Nine puzzles. |
| Gale Rock Light | medium | 25 min | A dark lighthouse in a gale and a ship heading for the rocks. Ten puzzles on four floors. |

Play: https://cmzueger.github.io/escape/

- `core/` the rooms in Rust (`hut.rs`, `light.rs`): state, puzzles, hints,
  score (`cargo test`).
- `web/` the same as WebAssembly for the web build, `godot/` as a GDExtension
  for the desktop client and the tests.
- `client/` the Godot 4.5 client. Everything is drawn in code
  (`scripts/art.gd`, `art_light.gd`), texts are in `i18n/strings.csv` (en, de,
  fr, it, es), sounds are synthesised by `audio/generate.py`.
- `docs/SPEC.md` the design and its decisions, `docs/SETUP.md` the one-time
  steps, `docs/PUZZLES.md` **the solutions (spoilers)**.

```sh
cargo test                                   # the rules
client/build.sh debug                        # the extension for Godot
godot --headless --path client --import
godot --headless --path client --script res://tests/smoke_test.gd   # plays both rooms
GODOT=godot client/build-web.sh              # the web build in client/export/web
```
