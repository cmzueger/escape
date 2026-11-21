# Locked In

Escape rooms played in the browser. Offline, no accounts.

| Room | Difficulty | Target | |
|---|---|---|---|
| Hut 2847 | easy | 5 min | Snowed in at an alpine hut; somewhere there is a radio. Nine puzzles. |
| Gale Rock Light | medium | 11 min | A dark lighthouse in a gale and a ship heading for the rocks. Ten puzzles on four floors. |
| Col Sidereal | hard | 29 min | An observatory on a pass whose door only opens once the night's observation is recorded. Ten layered puzzles in a study and a dome. |
| The Orangery | easy | 4 min | A greenhouse in the evening sun, latched from outside. Eight puzzles with water, plants and colours. |
| Curtain Call | easy | 7 min | Backstage after the last performance. Eight puzzles with stage lights, masks and costumes. |
| The Grandmaster's Study | hard | 21 min | Seven problems about how chess pieces move; a chart in the room teaches the moves. |
| Low Tide | easy | 3 min | A bathing hut whose door has swollen shut. Six puzzles with shells, kites and the tide. |
| Night Train | easy | 4 min | A sealed sleeping compartment. Six puzzles with a timetable, a ticket and luggage. |
| The Alchemist's Cellar | easy | 5 min | Make a golden key. Six puzzles about doing things in the right way and order. |
| The Attic | easy | 2 min | Grandmother's attic, and the trapdoor has fallen shut. Six puzzles with old toys and photographs. |
| The Watchmaker | easy | 3 min | Locked in a watchmaker's workshop over lunch. Five puzzles with clocks and a watch to mend. |
| The Night Gallery | easy | 10 min | A museum's Egyptian wing after closing. Six puzzles in a sign language the room teaches. |
| Lookout | easy | 2 min | A kids' club treehouse in autumn, locked from above. Five puzzles with a mirror board and a periscope. |
| Gondola 12 | easy | 5 min | A cable car stopped halfway on a snowy morning. Six puzzles; shadows matter. |
| Praline Works | easy | 5 min | A 1920s chocolate factory at night. Six puzzles with a torn recipe and a tilting tray. |
| Tinker & Sons | medium | 7 min | A toy shop on Christmas Eve, with a dollhouse copy of itself. Seven puzzles, a labyrinth and a deduction. |
| Graf Alpina | medium | 11 min | A zeppelin's chart room over the Alps at dusk, drifting off course. Five puzzles with a compass, a cipher and things hidden in plain sight. |
| Albatross | medium | 8 min | A 1950s steamer's wheelhouse in a storm. Five puzzles with ballast tanks, coloured glass and two lighthouses. |
| Base 70° South | hard | 16 min | A polar station in a white-out. Six puzzles: a logic grid, invisible ink and a store full of crates. |
| The Quiet House · 1905 | easy | 4 min | Series, episode 1: the night the family's young pianist vanished. Six puzzles with a music box and a piano. |
| The Quiet House · 1938 | medium | 6 min | Episode 2: the housekeeper before the house is sold. Five puzzles with a telephone and a fuse box. |
| The Quiet House · 1969 | medium | 8 min | Episode 3: a student renting the old room. Five puzzles with a record player, opera glasses and the landlady. |
| The Quiet House · Today | hard | 15 min | Episode 4: the heir renovating the house finds what was left behind. Six puzzles. |
| The Night Edition | hard | 17 min | A newspaper's print works in 1890, an hour before the presses run. Nine puzzles with type, paper and ink. |
| The Great Vaudini | medium | 9 min | An illusionist's dressing room in 1925: the apprentice's test. Eight puzzles with tricks, cards and mirrors. |
| Rain on Gale Street | hard | 23 min | A detective's office in 1947, locked from outside. Eight puzzles; three witnesses, one lies. |
| The Filter Hall | hard | 21 min | A Victorian pumping station on opening day. Twelve puzzles; make the fountain in the square rise. |
| The 8:15 to Nowhere | hard | 22 min | A model railway club and its founder's last layout. Eleven puzzles with points, a shunting yard and a phone call. |
| Harvest Moon | hard | 21 min | A windmill at the harvest festival. Twelve puzzles; sails, gears, a sack hoist and the first flour. |
| The Glass Aviary | medium | 10 min | A glass bird house on a sunny Sunday, the keeper away. Twenty-four small puzzles: feed every bird and settle it on its perch. |
| Hall of Mirrors | medium | 11 min | A funfair at night with the lights still on. Twenty-four puzzles: a mirror maze, crooked mirrors and a carousel to wake. |
| Detention | medium | 16 min | A village school in 1925, kept in after lessons. Twenty-four puzzles from the teacher's list of tasks. |
| Puffin Island · Spring | easy | 11 min | Series, episode 1: an island keeper laid up at nesting time. Twenty-three puzzles; rowing through the fog, a puffin chick, a lamb and the supply boat. |
| Puffin Island · Summer | easy | 8 min | Episode 2: a storm rolls in. Twenty puzzles; a kite in the gusts, the lighthouse beam and the hay. |
| Puffin Island · Autumn | medium | 8 min | Episode 3: market day. Nineteen puzzles; apples, cider, a pie and the regatta. |
| Puffin Island · Winter | easy | 9 min | Episode 4: the longest night. Nineteen puzzles; skating on thin ice, an ice cave and the lighthouse lamp. |
| Midnight in Serenissima | medium | 14 min | Carnival night in a city of canals: twenty places walked street by street, with a map. Twenty-three puzzles; a ring toss, glass blown at the furnace, a gondola through the canals and the fireworks. |

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
godot --headless --path client --script res://tests/smoke_test.gd   # plays all nineteen rooms
GODOT=godot client/build-web.sh              # the web build in client/export/web
```
