# Hut 2847

An escape room in an alpine hut, played in the browser. You are snowed in, the
warden is gone, and somewhere there is a radio. Nine puzzles in three acts; a
good time is 30 minutes. Offline, no accounts.

Play: https://cmzueger.github.io/escape/

- `core/` the room in Rust: state, puzzles, hints, score (`cargo test`).
- `web/` the same as WebAssembly for the web build, `godot/` as a GDExtension
  for the desktop client and the tests.
- `client/` the Godot 4.5 client. Everything is drawn in code
  (`scripts/art.gd`), texts are in `i18n/strings.csv` (en, de, fr, it, es).
- `docs/SPEC.md` the design and its decisions, `docs/SETUP.md` the one-time
  steps, `docs/PUZZLES.md` **the solutions (spoilers)**.

```sh
cargo test                                   # the rules
client/build.sh debug                        # the extension for Godot
godot --headless --path client --import
godot --headless --path client --script res://tests/smoke_test.gd   # plays the whole room
GODOT=godot client/build-web.sh              # the web build in client/export/web
```
