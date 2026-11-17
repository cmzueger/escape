# Locked In: design

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

## Decisions (owner, 2026-11-16, second iteration)
| Question | Choice |
|---|---|
| Catalogue | Cards in one game: picture, name, difficulty, target time, best stars |
| Name of the catalogue | Locked In |
| Second room | Lighthouse in a gale, "Gale Rock Light" |
| Its difficulty | Medium (the hut, played in 10 minutes without hints, is "easy") |
| Its layout | Four floors, climb up; hatches are the gates |
| Its look | Storm green, with lightning (which can matter for a puzzle) |
| Targets | One per room: hut 15 minutes, lighthouse 25 minutes |
| Sound | Effects and atmospheres, generated in code, no music |

## Decisions (owner, 2026-11-16, third iteration)
| Question | Choice |
|---|---|
| Third room | Observatory on the pass, "Col Sidereal", hard, target 35 minutes |
| What makes it hard | Layered clues: answers need two or three sources and a step of reasoning; things learned early come back |
| Its look | Moonlight, silver and violet; where the moonlight falls matters |
| Its layout | A study below and the dome above, three walls each |

## Decisions (owner, 2026-11-16, second set)
| Question | Choice |
|---|---|
| Easy | Gardener's greenhouse, "The Orangery", look: evening sun |
| Medium | Theatre backstage, "Curtain Call", look: coloured stage lights |
| Hard | Chess master's study, "The Grandmaster's Study", look: library green and wood; no chess knowledge needed, the room teaches the moves |
| Catalogue | Two rows of three |
| Tuning | Build now, adjust targets and hints after the owner's play tests |

## Third set (2026-11-16)
The owner asked for three more rooms at once, without a proposal round. The
settings come from earlier proposals not chosen at the time; looks and names
are Claude's and open to change:
| Room | Setting | Look |
|---|---|---|
| Low Tide (easy) | Beach hut at low tide | Bright daylight, white and blue stripes |
| Night Train (medium) | Night train compartment | Warm wood and brass, the night passing outside |
| The Alchemist's Cellar (hard) | Alchemist's laboratory | Stone vault, green glow, gold |

The catalogue shows three rows of three smaller cards.

## Fourth set (2026-11-17)
Again three rooms at once without a proposal round; settings, looks and names
are Claude's and open to change:
| Room | Setting | Look |
|---|---|---|
| The Attic (easy) | Grandmother's attic | Warm dusty wood, afternoon light through a dormer |
| The Watchmaker (medium) | Watchmaker's workshop | Brown and brass, a work lamp |
| The Night Gallery (hard) | Museum, Egyptian wing at night | Navy and moonlight, sandstone and gold |

With twelve rooms the catalogue scrolls: three rows are in view, a small
arrow says there is more below, and the position is remembered. Chosen
without asking as the smallest change; other layouts (pages, sets as tabs)
are open.

## Hut 2847
- Main room (three walls): stove wall, bunk wall, kitchen wall. Act 1: light,
  warmth, the way into the warden's room.
- Warden's room (two walls): desk wall, map wall. Act 2: three finds. Act 3:
  the radio.
- It starts dark; light is part of the first act and of the look.

## Gale Rock Light
- Four floors, one wide view each: store room, keeper's room, watch room,
  lamp room. Each hatch needs something from its floor; the lamp room needs
  things from every floor, so you walk down again.
- New mechanisms: two carried items can be combined, lightning shows what the
  dark hides, a measuring puzzle, gears, valves.

## Col Sidereal
- Study (desk wall, library, chart wall) and dome (telescope, dome wheel,
  orrery), joined by a stair behind a gate. Clues in one room explain
  machines in the other, so you go up and down.
- The dome turns; the slit and the moonbeam move with it.
- New mechanisms: a tool that is not a lock, a switch puzzle, a balance, and
  a final check that needs several things right at once, with feedback on
  what is still wrong.

## Sound
Atmospheres per place (wind at the hut, fire once it burns, ticking, radio
static; sea, wind and rain at the lighthouse, louder the higher you climb)
and effects for what you do (clicks, locks, pick-ups, a chime for each solved
puzzle, thunder after lightning). One switch, sound on or off.

## Score
Three stars (six halves) for finishing within the room's target time without
hints. Each hint costs half a star, each started 10 minutes over the target
another half; never
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
Android, a custom domain, music, a hard room.

## Fifth set (owner, 2026-11-17)
Rooms between the existing medium and hard ones (10 to 20 minutes), each with
its own target from its puzzle count and difficulty, and new puzzle types.
Chosen by the owner in two rounds:
| Room | Look | Planned | New puzzle types |
|---|---|---|---|
| Gondola 12 (stuck cable car) | Snowy winter morning, white and pale blue | ~12 min, 6 puzzles | Shadow play |
| Tinker & Sons (toy shop after hours) | Christmas: snowy window, red and green, fairy lights | ~18 min, 7 puzzles | Picture deduction, tilt maze, a dollhouse copying the shop |
| Lookout (kids' treehouse) | Autumn: red and gold leaves, late afternoon, a lantern | ~10 min, 5 puzzles | Light beam and mirrors |
| Praline Works (chocolate factory) | 1920s: copper kettles, tiled walls, enamel signs | ~15 min, 6 puzzles | Torn pieces, a tilt tray |

Not chosen: submarine, space capsule, detective's office, magician's dressing
room; fold the paper, fingerprint dust, memory flash.
