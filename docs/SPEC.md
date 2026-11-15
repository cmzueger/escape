# Hut 2847: design

No spoilers here; the solutions are in PUZZLES.md.

## Decisions (owner, 2026-11-15, each chosen from proposals)
| Question | Choice |
|---|---|
| Setting | Alpine hut in a storm: snowed in, the radio is the way out |
| View | Illustrated 2D scenes, tap to look closer, inventory bar |
| Structure | Three acts, nine puzzles; within an act two or three are open at once |
| Score | Clock counts up, nothing ends the game; stars from time and hints |
| Tech | Rust core + Godot 4.5 client, like Pawnkick |
| Hosting | GitHub Pages |
| Art style | "Lamp light": dark, lit by lamp and stove |
| Format | Landscape (960 x 540) |
| Languages | en, de, fr, it, es from the start |
| Spoilers | The owner stays unspoiled and play-tests |
| Puzzle mix | Balanced: find and combine, read clues across the room, small mechanisms |
| Difficulty | Medium: 25 to 40 minutes for a first-time adult, one or two hints |
| Name | Hut 2847 |

## The room
- Main room (three walls): stove wall, bunk wall, kitchen wall. Act 1: light,
  warmth, the way into the warden's room.
- Warden's room (two walls): desk wall, map wall. Act 2: three finds. Act 3:
  the radio.
- It starts dark; light is part of the first act and of the look.

## Score
Three stars (six halves) for finishing within 30 minutes without hints. Each
hint costs half a star, each started 10 minutes over 30 another half; never
less than one star. Every puzzle has three hints (nudge, clue, solution);
asking which hint is next is free, and revealed hints can be read again.
The best result and the running game are kept on the device.

## Architecture
- `core` holds the whole room: flags, inventory, lock positions, hints, time.
  Clients send text commands (`tap coat`, `use key door2`, `dial safe 2 +1`,
  …) and get the state as JSON plus a message key to translate.
- What the pictures must show (counts, numbers, symbols) comes from the
  rules' `clues` command, so pictures and solutions cannot drift apart.
- The client keeps only what is not a rule: which view is shown, which item
  is selected, the running clock (reported with `time`), the saved game
  (`save` / `load`, a short string in `user://hut2847.cfg`).
- Tests: the rules' own tests escape the room in two orders; the client test
  escapes it through the real hotspots; the browser test starts a game in
  the web build and reloads it.

## Not in the first version
Sound, Android, a custom domain, more rooms.
