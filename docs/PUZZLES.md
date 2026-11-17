# Locked In: puzzles and solutions

**Spoilers. The owner does not read this file.** The values are defined in
`core/src/hut.rs` and `core/src/light.rs`; the client test `client/tests/smoke_test.gd` plays exactly
this walkthrough.

# Hut 2847

## Act 1: the main room
1. **Lamp.** Dark at the start: only the stove wall near the window can be
   used. Coat by the window → matches. Matches on the oil lamp on the table.
2. **Cupboard lock** (kitchen wall, three wheels). The note on the cupboard
   shows hat, mug, ice axe. Count them: 4 hats (bunk wall), 7 mugs (kitchen
   wall), 3 ice axes (stove wall) → **473**. Inside: kindling.
3. **Stove and key.** Log (wood box) + kindling + matches on the stove, in
   that order of need (matches last). The bucket of ice (kitchen wall) on the
   lit stove → key. Key on the door next to the bunks → warden's room.

## Act 2: the warden's room (two threads, any order)
4. **Cuckoo clock.** The log book on the desk has a bird drawn beside the
   last row (the storm, 16:25). Set the clock to **4:25** → the cuckoo comes
   out with a small key → opens the desk drawer → tracing paper with holes.
5. **Map and strongbox.** Paper on the map: four holes, with 1 to 4 dots for
   the order, show the digits **6 1 9 3** (from 3196, 2410, 1935, 2638) →
   strongbox → fuse.
6. **Barometer.** The log book gives a pressure for each weather (sun 1030,
   cloud 1015, rain 1000, snow 985, storm 970). Turn the barometer's ring
   until each symbol sits at its pressure (7 steps left from the start) →
   the back opens → hand crank.

## Act 3: the radio
7. **Power.** Crank on the radio's side, fuse in the holder on the back
   panel, and the cable board: turn tiles until the line runs from the
   battery (top left) to the plug (bottom right). Path: down, two right, up,
   two right, two down, out.
8. **Frequency.** The radio's plate shows a hut and "m": tune to the hut's
   altitude, **2847** (sign over the front door, map, log book sketch, title).
9. **Signal.** The lamp blinks long, short, short, long, short, long. Repeat
   it on the key (round button short, bar long) → rescue answers. The end.

## Balance notes
- Target: about 3 minutes per puzzle plus walking; act 2 is the longest.
- Tapping empty space makes the tappable things glint, so nothing is a
  pixel hunt.
- Lock wheels check themselves; there is no penalty for trying.

# Gale Rock Light

## Floor 1: store room
1. **Key under the grating.** Magnet (tool board) and thin rope (wall): tap
   one in the inventory, then the other, to tie them. Use the result on the
   floor grating → key → hatch at the top of the stairs. (Also take the gear
   from the tool board.)

## Floor 2: keeper's room
2. **Sea chest** (four wheels of six symbols, an hourglass above). The four
   photos have years and a symbol carved in each frame; oldest first:
   **bell (1871), wave (1889), fish (1903), anchor (1924)**. Inside: crank
   and the large gear.
3. **Hatch lock** (four digits). The plaque shows low water and a moon. The
   book on the table is a tide table (high, low, high, low per day); the
   calendar says day 17; the low water at night is 22:05 → **2205**.
   Take the matches from the shelf over the stove.

## Floor 3: watch room
4. **Signal locker** (four digits). The slate shows a ship flying four flags;
   the poster gives each flag its digit; top to bottom **7305**. Inside: the
   hatch handle (use it on the hatch) and the small gear.
5. **Bearing.** In the window close-up the ship is only visible when
   lightning strikes (every 6 to 10 seconds): it stands over **235** on the
   sill's scale. Set the counter beside the lamp (floor 4) to 235.

## Floor 4: lamp room
6. **Oil.** The reservoir's red mark is at 4 litres. At the barrel on floor
   1: fill the 5 l can, pour into the 3 l can, empty the 3 l can, pour, fill
   the 5 l can, pour → 4 litres left. Tap the can to take it, use it on the
   reservoir. (A wrong amount sends the can back down, empty.)
7. **Clockwork.** Four gears (tool board, chest, locker, lamp room floor),
   three pegs. Left to right: **large, small, very large**; the plain gear is
   left over. Then the crank on the first wheel.
8. **Shutter drum.** The sea chart (floor 3) shows Gale Rock's rhythm:
   on, on, off, on, off, off, off, off. The drum turns the other way (arrows),
   so from the left: pins **5, 7 and 8** in, the rest out.
9. **Pressure.** Each valve moves two gauges one step (of four); all three
   must be in the green. From the start: left once, middle three times,
   right twice (any order).
10. **Light it.** With oil, clockwork and pressure the three lights on the
    lamp's base are green; matches on the lamp. If the drum or the bearing is
    wrong the lamp flares, the ship does not react, and you can try again.

## Balance notes (lighthouse)
- Aimed at about 20 to 25 minutes for the owner (playing as a couple), who took
  10 for the hut: more cross-referencing (three sources for the hatch code),
  two logic puzzles (oil, valves), one observation puzzle (lightning).
- Nothing on the lamp tells whether drum and bearing are right; only the
  three physical parts have lights.

# Col Sidereal

The decoder: around the dome hang eight plaques, each with a constellation
figure; under each the rail shows an hour (0 h, 3 h, … 21 h). The moonbeam
falls on the plaque opposite the slit and shows a digit there:

| Position | Figure | Hour | Digit | Atlas angle |
|---|---|---|---|---|
| 0 | arc | 0 h | 4 | +40° |
| 1 | W | 3 h | 9 | +60° |
| 2 | kite | 6 h | 1 | −10° |
| 3 | hook | 9 h | 6 | +20° |
| 4 | cross | 12 h | 3 | −30° |
| 5 | Y | 15 h | 8 | +10° |
| 6 | triangle | 18 h | 2 | +50° |
| 7 | arrow | 21 h | 7 | 0° |

1. **Desk drawer** (three wheels of figures). The note over the desk shows
   green, red, white; the coloured books in the library carry figures on
   their spines: **triangle, hook, Y**. Inside: the gate key and a torn page
   (use it on the notebook).
2. **Instrument cabinet** (four digits). Its plaque: sun clock minus star
   clock. The stopped clocks by the door show 10:25 and 4:50 → **0535**.
   Inside: eyepiece and fuse.
3. **Switchboard** (chart wall). Fuse in; each switch flips its lamp and
   both neighbours; all six must burn. From the start (lamps 4 and 5 on):
   switches **1, 4 and 5**. The dome wheel now works.
4. **Wall box in the dome** (four digits, a comet engraved). The wall map in
   the study shows the comet's path: kite, Y, arc, cross → digits from the
   plaques → **1843**. Inside: photographic plate and the atlas case's key.
5. **Orrery.** The notebook's second page: red planet 6, ringed planet 2,
   grey planet 7. Read the plaques backwards: **red to the hook, ringed to
   the triangle, grey to the arrow**. The base's drawer gives the
   counterweights.
6. **Balance.** Eyepiece into the telescope, counterweights onto the bar.
   Camera 15 + eyepiece 8 = 23 → hang **4, 7 and 12**.
7. **Setting circles.** The notebook says 14. 11., 23 h and sketches the
   planisphere on the desk: turn its disc until hour 23 stands at month 11
   (8 steps left from the start); the figure under the red mark is the
   **hook**. The atlas gives the hook 9 h and +20° → set the telescope's two
   counters to **9 h, +20°**.
8. **Slit.** Turn the dome until the slit stands over the hook's plaque
   (9 h; position 3, three steps left from where the test leaves it).
9. **Photograph.** The eyepiece now shows the comet (it says what is wrong
   otherwise: out of balance, the dome in the way, or only stars). Plate
   into the camera on the telescope.
10. **Door** (four digits). Tap the camera to see the plate: W, triangle,
    hook, arrow beside the comet → **9267**. The lock only accepts it once
    the plate is exposed.

## Balance notes (observatory)
- The dome keeps turning after the photograph (until 0.6.1 it froze, and the
  door code could not be read from the plaques any more). Owner's time: 40
  minutes with several hints, partly because of that.
- Built before the owner had played the lighthouse; the 35 minute target is
  a guess to be corrected by their time.
- The decoder is used forwards twice (box, door) and backwards once
  (orrery); the planisphere is the only clue that is a tool with no lock.
- The intro recommends paper and pencil: eight figure-digit pairs to keep.

# The Orangery
1. **Wilted flower.** Watering can (floor) on the tap (pond wall), then on the
   drooping flower at the end of the bench → it blooms, a key hangs on it.
2. **Green cupboard.** Key → trowel and brass pointer.
3. **Sundial.** Pointer on the sundial → the shadow falls on **7**.
4. **Seed cabinet** (three digits; plaque: sundial, lily, butterfly):
   7, 5 lilies on the pond, 3 butterflies over the bench → **753**. Inside:
   bulb and valve wheel.
5. **The big pot.** Trowel, bulb, then a full can → a tall flower with four
   blossoms (from the top: white, red, violet, yellow).
6. **Pipes.** Wheel on the bare valve; open the first and third valve, close
   the middle one (it leads to the drain) → the fountain runs.
7. **Bottle.** It drifts to the pond's edge: tap the pond, then the bottle.
   Its note: read the flower from the bottom up.
8. **Door** (four colours): **yellow, violet, red, white**.

# Curtain Call
1. **Lighting desk.** Plug (props table, wings) into the desk (stage).
2. **Prop trunk** (three digits). Call sheet in the wings: magenta, yellow,
   cyan. Mix two lamps for each; the backdrop then shows a digit: red + blue
   → 8, red + green → 4, green + blue → 2 → **842**. Inside: crank; the
   prompt book stays in the trunk.
3. **Winch.** Crank → the lighting bar comes down, the follow spot can move.
4. **Trap.** Prompt book: the stage from above, a cross at the back right.
   On the desk move the spot fully right and fully up → trap opens → mask.
5. **Masks.** Hang the mask on the empty hook; press in the order of the
   poster's acts: **angry, happy, sleepy, sad** → niche → stage door key.
6. **Mirror.** Each switch flips its bulb and the next clockwise; from the
   start press switches **1, 3 and 4** (clockwise from the top) → the glass
   shows four dots: blue, red, white, yellow.
7. **Key** into the stage door.
8. **Door code.** Costume tags: blue 1, red 3, white 5, yellow 6 → **1356**.

# The Grandmaster's Study
1. **Desk drawer** (letter and number). Travel board: the one empty square
   both the rook (b6) and the bishop (g2) can reach, the pawn on b7 blocking
   → **c6**. Inside: rook; a score sheet appears on the desk.
2. **Wall safe** behind the portrait (four digits). Score sheet: c3, f1, a2,
   h3; the bookshelf is a board a to h by 1 to 3 with a digit on every book
   → **2958**. Inside: bishop.
3. **Mantel clock.** Five named squares, each to be set light or dark:
   **b4 dark, e4 light, g1 dark, c8 light, h5 light**. Inside: knight.
4. **Trophy cabinet** (four digits). Tile panel: start on the ringed tile,
   make the three jumps as drawn, read the digits → **2239**. Inside: white
   king.
5. **Small board.** The only square not attacked by queen, rook and bishop:
   top row, third from the left. Drawer: brass key.
6. **Big board.** All three pieces must attack the black king on e5:
   **rook e1, bishop h8, knight c4** → the king falls, steel key under him.
7. **Door.** Both keys.

# Low Tide
1. **Shell box** (three digits; plaque: spiral shell, fan shell, starfish).
   Count them on both walls and the floor: 4, 2, 6 → **426**. Inside:
   corkscrew.
2. **Ship in a bottle.** Corkscrew → a paper showing a green kite.
3. **Kites.** Three kites, three crossing strings: the green kite's string
   ends at the **right-hand hook**; pull it → the kite brings a key.
4. **Tide clock.** Key opens the locker (spade, clock hand). Hand onto the
   tide clock; through the window the water stands at mark 4 of the tide
   post → set the clock to **4** → its box gives a brass token.
5. **Sand.** Dig at the little red flag with the spade → a tin box; the
   token opens it → the spare key.
6. **Door.** The key.

# Night Train
1. **Suitcase** (three digits). Its tag shows the tower; the timetable gives
   the tower 07:42 → **742**. Inside: the conductor's punch; a ticket is put
   on the table.
2. **Seat.** The ticket says seat 23: lift seat **23** → a briefcase.
3. **Briefcase** (four wheels of station signs). The ticket's journey is
   bridge → peak; in the timetable's order with the stops between:
   **bridge, tower, mill, peak**. Inside: a red handle.
4. **Punch** the ticket (punch on the ticket in its close-up) → a pattern of
   holes.
5. **Conductor's panel** (three by three). Light the buttons of the holes:
   top left, top right; middle; bottom left, bottom middle → a flap opens.
6. **Handle** onto the socket → the door.

# The Alchemist's Cellar
1. **Vials.** The book: three vials under air, water, fire. The wall chart:
   air violet, water green, fire orange. Only red, yellow, blue exist: vial
   1 red + blue, vial 2 yellow + blue, vial 3 red + yellow → the cabinet
   unlocks (lead inside); take the third vial as the elixir.
2. **Scales.** The lead lies left. Weights 1, 3, 9; each tap moves one: off,
   left, right. **9 right, 1 and 3 left** → balance (the lead weighs 5) → a
   drawer with the bellows.
3. **Floor disc.** The book shows three rings with moon, sun, earth (outer
   ring first): turn each ring until that sign is under the red mark → a
   hatch with the crucible.
4. **Furnace, order.** As the book numbers them: crucible, lead, elixir.
5. **Furnace, heat.** Bellows as often as the lead weighs: **5** strokes,
   then tap the furnace. A sixth stroke boils over, looking in too early
   lets the fire die; both start the count again. → the golden key.
6. **Door.** The golden key.

# The Attic
1. **Trunk.** The album on the chair: three birthday photos with 5, 8 and 3
   candles → **583** → a small crank and a toy wagon.
2. **Music box.** Crank on the music box, tap it → a tiny key.
3. **Train.** The wagon fills the gap on the shelf's toy train.
4. **Wardrobe.** The wagons' numbers from the engine: **2794** (the 9 is the
   wagon from the trunk) → a hooked pole.
5. **Padlock.** The tiny key on the trapdoor.
6. **Trapdoor.** The pole on the trapdoor (it opens downwards).

# The Watchmaker
1. **Drawer.** Four wall clocks (3:50, 8:35, 11:05, 6:20); only the second
   one's pendulum swings → **0835** → a loupe and a mainspring. A loose
   wheel lies on the bench.
2. **Engraving.** Loupe on the pocket watch: a tiny dial showing 4:10.
3. **Tall clock.** Set its hands to **4:10** → the case opens: a balance
   wheel.
4. **The watch.** As the plan on the wall numbers them: mainspring, wheel,
   balance wheel. A part that is too early does not go in.
5. **Door.** The running watch opens its lid: **618**.

# The Night Gallery
The tablet gives each sign a number of dots: eye 3, bird 5, water 1, sun 6,
reed 2, scarab 4. Everything else is read through it.
1. **Display case.** Its label: water, reed, bird → **125** → a feather.
2. **Scales.** The feather's tag shows 7 dots. Jars: eye 3, sun 6, scarab 4,
   bird 5 → **eye and scarab** on the right pan → a golden disc.
3. **Dial.** The disc in the dial under the skylight; the frieze's upper band
   has the sun over the bird → turn the ring until the **bird** is in the
   beam (two steps back) → a niche with the scarab key.
4. **Sarcophagus.** The frieze's procession walks to the right, so it is read
   from the right: **water, scarab, eye, reed** → a papyrus.
5. **Key.** The scarab key in the door.
6. **Door.** The papyrus: 4, 6, 3, 5 dots, read backwards through the tablet:
   **scarab, sun, eye, bird**.

## Balance notes (fourth set)
- Untested by a person. The attic is meant to be a straight line; the
  watchmaker's first step (which clock) and the gallery's reading direction
  are the likely sticking points.
