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

Built as 0.7.0. Targets: Lookout 10, Gondola 12, Praline Works 15, Tinker &
Sons 16 minutes (Tinker & Sons listed as hard, the others medium). With
sixteen rooms the catalogue has six rows; the last holds one card, centred.

## Estimating time (2026-11-17)
Puzzles are classed by kind: A action, B lookup, C combine, D mechanism, E
deduction. `tools/estimate.py` fits minutes per kind to the owner's times
(first fit: A 0.2, B 0.7, C 0.9, D 1.0, E 4.2) and estimates any room from
its kinds. The easy and medium rooms have no E puzzles; the hard ones three
or four, which is the jump the owner noticed. A real medium room needs one
or two E puzzles among C and D ones.

## Difficulty labels (owner, 2026-11-17)
Rooms stay as they are; the labels follow their puzzles. Difficulty is how
hard the thinking is, not how long it takes (the target time is shown
separately): hard with two or more deductions, medium with one deduction or
three or more mechanisms, easy otherwise. Result: hard Col Sidereal and The
Grandmaster's Study; medium Gale Rock Light, The Night Gallery, Tinker &
Sons; the others easy.

## Finer kinds (owner, 2026-11-17)
Added F find (a clue easy to miss), M hard mechanism (needs planning) and X
hard deduction (a longer chain or grid) beside D and E. The label is a point
score: F and D one, M and E two, X four; medium from 4, hard from 8.

## Sixth set (owner, 2026-11-18)
Medium to hard rooms with new mechanisms, deductions and hidden clues. Chosen
by the owner in two rounds:
| Room | Look | Difficulty | Planned puzzle types |
|---|---|---|---|
| Graf Alpina (zeppelin chart room) | Golden dusk over glaciers, brass and mahogany | medium | Compass and magnets, rebuild a cipher, clues in details |
| Albatross (ship's bridge in a storm) | 1950s steamer: wooden wheelhouse, brass, oil lamps, grey storm light | medium | Water levels (ballast), coloured filters, clues in details, one deduction |
| Base 70° South (polar research station) | White-out storm, grey and white, red emergency light, yellow gear | hard | Sliding blocks, invisible ink (UV), a hard logic grid |

All four new mechanisms (sliding blocks, coloured filters, water levels,
compass and magnets) and all four clue kinds (logic grid, rebuild a cipher,
invisible ink, clues in details) were wanted. Not chosen: Grand Hotel,
scriptorium, bank vault, detective's office, inventor's workshop.

Built as 0.8.0: Graf Alpina (5 puzzles, kinds FFEMF, medium, 13 min),
Albatross (FDMEA, medium, 10 min), Base 70° South (XFMABE, hard, 19 min).

## Series: The Quiet House (owner, 2026-11-18)
Four episodes, each playable alone, the story building across them, chosen
by the owner in three rounds:
- The same floor of an old town house (shop below, rooms stacked above, a
  courtyard with windows facing each other) in 1905, 1938, 1969 and today.
- The secret: Clara, 12, the pianist of the family, vanished in 1905; each
  generation comes closer to what happened to her.
- Linked by the housekeepers' notes: generations of housekeepers leave notes
  for each other in a hidden place.
- Difficulty rising: easy, medium, medium, hard.
- Story through intro and ending texts, a recurring link (the notes) and
  notes to find in the rooms.
- Mechanics wanted: music and sound (with a visual twin, so it works muted),
  one clue spread across views, how the rooms lie relative to each other,
  multiple-choice interactions (talking to someone), looking from one view
  into another, changing something in one view that shows in another.
Built as 0.9.0: four rooms on the house's two rooms per era (parlour and
Clara's room); the piano, the tiled stove with its hidden notes and the
courtyard recur in every era. Kinds and targets: 1905 FADAFA (easy, 5 min),
1938 FCDEA (medium, 8 min), 1969 FDCEC (medium, 9 min), today FEDXEB (hard,
18 min). Shared mechanisms in `core/src/house.rs` (piano, conversation).
Not chosen: Grand Hotel Belvedere, The Missing Composer, Agency 13; the
clockmaker's fortune, the inventor's machine; lakeside villa, mountain chalet.

## Seventh set (owner, 2026-11-18)
Asked for: more clues in text form, creative mechanisms, slightly hidden
clues, rooms a little longer. Chosen in two rounds:
- The Night Edition (a newspaper print works, 1890; a reporter locked in
  before the presses run; gaslight, ink black, cream paper, red proof marks).
- The Great Vaudini (an illusionist's dressing room, 1925; the apprentice's
  test, out before his curtain call; red velvet and gold).
- Rain on Gale Street (a detective's office, 1947; locked in by someone who
  wants a case closed, three witnesses, one lies; black and white with red
  neon through the blinds).
- About 20 to 25 minutes each: 8 to 9 puzzles, at least two deductions and
  two hard mechanisms.
- Text clues of every kind: riddles and poems, statements to cross-check,
  codes in documents, logs with times, and clues printed on a wall that are
  one ingredient of another puzzle or of finding something hidden.
Built as 0.10.0: kinds and targets The Night Edition FXMFCDAEA (hard, 21
min), The Great Vaudini FAEFDMCA (medium, 14 min), Rain on Gale Street
FAEEFEXM (hard, 26 min).
Not chosen: Station X, Orbital Station Kepler, The Abbey Library; Gutenberg
& Daughter, The Blue Pencil; Vanishing Act, Smoke & Mirrors; The Last
Client, Room 4B.

## Eighth set (owner, 2026-11-18)
First set planned with the knowledge base (the owner's questionnaire: loves
outstanding mechanisms with visible progress, sliding, tilting, paths, light,
sound, cross-room puzzles, logic grids, talking, riddles, clever item uses;
dislikes plain codes into locks, counting, mappings, logs, decoy twists; wants
rooms of 20 to 30 minutes). Chosen in two rounds:
- The Filter Hall (a Victorian pumping station, 1898; an inspector locked in
  during the opening; make the fountain in the square run before the mayor's
  speech ends; white tiles and water). Headline: water routed through pipes
  and valves across two halls.
- The 8:15 to Nowhere (a model railway club; the founder's last puzzle
  layout; club room, warm lamp). Headline: points and signals so trains
  deliver the right cargo, through a wall tunnel into the next room.
- Harvest Moon (a windmill at the harvest festival; grind the first flour
  before the moon rises; golden dusk). Headline: sails, gears and millstones
  linked floor by floor; sacks down a chute.
About 12 puzzles each, few plain code locks. Built as 0.11.0: The Filter
Hall FADCDFEEXMMF (hard, 28 min), The 8:15 to Nowhere FADDCCXFMEE (hard, 25
min), Harvest Moon FAECFAMCXDEA (hard, 25 min), each judged with
`tools/knowledge.py plan` before it was built.
Not chosen: The Shadow Theatre, Bathysphere Station, The Organ Loft;
Pumping Station No. 3, Under the Reservoir; Night Run, Junction 9; The Last
Grind, Miller's Daughter.

## Ninth set (owner, 2026-11-19)
Asked for: longer rooms of easy to at most medium difficulty, themes animals,
illusions and school. The knowledge base shows the owner's time goes mostly
into deductions, so easy and medium rooms grow long through more puzzles and
more space: about 24 puzzles over four views each. Chosen in two rounds:
- The Glass Aviary (a glass bird house in sunshine; the keeper has gone for
  seed; every bird fed and settled before the doors open).
- Hall of Mirrors (a funfair's mirror maze at night, neon; find the way out
  and start the carousel to call the attendant).
- Detention (a village school in 1925, chalkboard, warm afternoon; the
  teacher's list of tasks, the door opens when all are done).
Not chosen: The Night Zoo, Noah's Workshop; Museum of Illusions, Camera
Obscura; Science Lab After Hours, Midnight at the Boarding School; The
Songbird Dome, Field Notes; Reflections, The Mirror Salon; The Snow Day,
Class of 1925.
Built as 0.12.0 (looks: green glass and sunshine; night funfair with neon;
chalkboard and a warm afternoon): The Glass Aviary
FAAFAAACACCAAACADDACACCA (medium, 14 min), Hall of Mirrors
FACAAFACCCCADCCADAFCAACA (medium, 16 min), Detention
FAAACACACDCACAFCDCCCMCAA (medium, 20 min); targets about 1.3 times the
knowledge base's prediction. Most puzzles are small (feed, fetch, combine),
with a few mechanisms each and things seen only at a moment. A conversation
that ends after its secret was told no longer shows the hang-up text (all
rooms).

## Catalogue, second layout (owner, 2026-11-19)
Asked for: filter and sort (see unfinished rooms), grouping, names that do
not wrap, maybe two columns; and full screen in the mobile browser. Of three
drafts (A filter chips and a sort button in two columns, B a side list of
groups, C shelves per group scrolling sideways) the owner chose A. Sorts:
newest first, easiest first, catalogue order (oldest first). Filters:
status, difficulty and set (the series counts as one). Full screen: a button
where the browser allows it, and home-screen support with a tip on iPhones.
Built as 0.13.0.

## Small games (owner, 2026-11-21)
After The Glass Aviary ("the best room so far") and Hall of Mirrors: small
games of skill, like playing a tune or walking a maze, are "super fun".
Future rooms should have more of them, easy coordination combined with
knowledge from the clues. Recorded as the knowledge base's element
`game_skill`.

## Stricter stars (owner, 2026-11-21)
Targets of 1.3 times the owner's time gave three stars to almost every run.
Of four options the owner chose "strict": a target of about 0.8 times the
owner's time and half a star lost per started 15 % of the target over it
(before: per 10 minutes). Also noted: in big rooms the easy steps take
longer (finding the right spot among many), and the setting matters a lot
for the fun.

## Targets from the model (owner, 2026-11-21)
No room's target is set from the owner's own time any more: the owner's
stats only teach the time model in the knowledge base, and every target is
0.8 times the model's predicted owner minutes, rounded up below 5 minutes.

## Second series: Puffin Island (owner, 2026-11-21)
Asked for: a new series. Of four ideas (Night at the Museum Annex, The
Wildlife Rescue Station, The Travelling Circus Train, Four Seasons on Puffin
Island) the owner chose Puffin Island: one small island in four seasons,
episodes like the aviary (about 20 puzzles over four views, easy to
medium), each playable alone, a running story with a few carry-overs. The
frame: the player helps old Maggie, the island keeper; her almanac gains a
page per episode; Pip, a puffin chick raised in spring, returns each
season. Episodes: Spring (nesting time), Summer (the storm), Autumn (harvest
and the regatta), Winter (the northern lights). The owner's favourite small
games for it: rowing and the regatta, skating on thin ice, a kite in the
gusts. Name: Puffin Island.
Not chosen: Night at the Museum Annex, The Wildlife Rescue Station, The
Travelling Circus Train; the names Maggie's Island, A Year on Skerry Isle.
Built as 0.16.0: Spring (23 puzzles, easy), Summer (20, easy), Autumn (19,
medium), Winter (19, easy); targets from the learned model. Carry-overs:
the jetty mended in spring holds in summer, the spring patch is harvested
in autumn, Pip returns each season, the almanac gains a page.
