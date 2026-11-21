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

# Lookout
1. **Club chest** (three wheels framed red, yellow, blue). The darts in the
   dartboard: red in 7, yellow in 3, blue in 9 → **739** → battery.
2. **Signal lamp.** Battery into the lamp: its beam crosses the mirror board.
3. **Mirror board** (6 by 4, lamp in from the left on row 2, glass marble at
   the top, second column). Mirrors 1, 2, 4 like `\`, mirror 3 like `/`: the
   beam goes down, right, up and left along the top into the marble → the
   alarm drawer springs open → periscope handle. (Only this setting works.)
4. **Periscope.** Handle onto the periscope; now it turns (8 directions).
5. **Hatch** (four wheels). Three treehouses with the club's orange flag
   show dice: by the lake (3 6 1 2, the first one met turning right), by the
   big pine (**5 2 6 4**) and by the small pine (1 4 4 2). Only the map's star
   marks the friends' one, by the big pine → **5264**. (Since 0.7.2; before,
   the decoy had a blue flag and the right one came first, so the map was
   never needed. The farmhouse 386 and the bus stop 17 are decoys too.)

# Gondola 12
1. **Backpack** (wheels framed blue, red, black). The piste map: the blue
   run's round sign 4, the red run's square sign 8, the black run's diamond
   2 → **482** → pocket knife.
2. **First-aid box** (wheels marked with 1, 2, 3 dots). The sculpture on
   the turntable casts a shadow on the wall: at the base mark with one dot a
   2 (front), two dots a 4 (side), three dots a 5 (the 2 seen from behind,
   mirrored) → **245** → spare fuse and the emergency card.
3. **Panel cover.** Pocket knife on the panel.
4. **Fuse** into the panel.
5. **Brake** lever up (released), as the card's second step shows.
6. **Direction.** The card: drive to the nearer station. The cabin was going
   down; the pylon ahead (downhill) is number 7 of 9 (the map numbers them
   from the valley) → only 2 spans up, 7 down → lever **up**, green button.
   Down: the cabin creeps, stops, and the lever goes back to stop.

# Praline Works
1. **Hat locker** (three wheels). Time cards: cup 6:30, bicycle 8:15, hat
   7:45, umbrella 7:10 → **745** → torn piece 2. (Piece 1 lies on the floor
   under the conveyor.)
2. **Mould cabinet** (four shape wheels). The enamel sign: heart red, star
   gold, shell green, leaf blue, bean violet, square silver. The wrapping
   machine's reels: green, red, blue, gold → **shell, heart, leaf, star** →
   piece 3.
3. **Tray** (both pralines roll together; a praline over an empty mould
   drops in). From the start: **right, down, left, down, left, up** (six is
   the fewest) → piece 4 under the tray.
4. **Recipe card.** All four pieces into the frame (any corner), then turn
   each until it is upright (from the start: 3, 1, 2, 3 taps).
5. **Kettle** (three pairs of wheels, marked 1, 2, 3 dots). The recipe:
   45°, 27°, 31° → **452731** → the conveyor runs; the gold praline holds the
   office key.
6. **Door.** The office key.

# Tinker & Sons
1. **Drawers.** In the dollhouse's copy of the drawer wall one drawer is
   ajar: second row, third from the left → winding key.
2. **Train.** Winding key on the train; the last wagon tips the golden
   walnut onto the station.
3. **Nutcracker.** Walnut on the nutcracker → marble.
4. **Labyrinth** (the marble rolls until a peg or the edge; it drops into the
   hole when it rolls over it). From the start: **up, right, down, right,
   down, left, down** (seven is the fewest; the hole stays reachable from
   everywhere) → tree star.
5. **Tree.** Star on the tree → the lights come on, the presents can be seen.
6. **Presents** (deduction). Notes: cap ✗ teddy, cap ✗ horse, glasses ✗
   teddy, glasses ✗ horse, glasses ✗ kite, bonnet ✗ horse. Glasses → drum;
   the horse can only go to pigtails; cap → kite; bonnet → teddy → the till
   opens → shop key.
7. **Door.** The shop key.

## Balance notes (fifth set)
- Targets from puzzle count and type, between the owner's medium and hard
  times: Lookout 10, Gondola 12, Praline Works 15, Tinker & Sons 16
  minutes. Untested by a person.

## Gates added in 0.7.1 (a known code no longer opens early)
- Orangery door: needs the grown flower and the bottle. Theatre trunk: the
  lighting desk powered. Chess safe: the drawer's contents taken. Lookout
  hatch: the periscope's handle on. Praline kettle: the recipe whole. Night
  Train panel: the ticket punched.

# Graf Alpina
1. **Cabinet** (four wheels, a church on the lock). The photograph's church
   clock shows 7:35 → **0735** (the wall clock's 4:20 is a decoy) → bar
   magnet, binoculars.
2. **Paperweight.** The horseshoe magnet holding down the chart.
3. **Course** (three wheels on the compass). The telegram is in signs: a ring
   with a notch at one of ten places, clockwise from the top; the burnt code
   book keeps 3, 7 and 0 as samples. The telegram reads **2, 2, 5**.
4. **Magnets** (both into the compass; each slot: empty, pulling, pushing).
   Earth pulls north 3, the engines west 1, a magnet 2. Only **top slot
   pushing, bottom slot pulling** makes the needle point at 225 (south-west).
   The airship turns to the valley.
5. **Valves** (three wheels). Binoculars on the window: the ground crew's
   panels show **618**.

# Albatross
1. **Signal locker** (four wheels, a bell on the lock). The ship's bell has
   **1938** engraved small (the plaque's 1951 is a decoy) → coloured glass.
2. **Glass** onto the ballast diagram: each pane hides its own colour.
3. **Ballast.** The log book's last pennant is blue: hide red and green, the
   blue plan is port 4, centre 5, starboard 4 (the red 2 6 2 and green 5 3 5
   are level too). Valves settle two tanks (an odd unit stays in the fuller),
   the centre floods to 8 or pumps to 0. From 8 5 3: **port valve, pump,
   starboard valve, port valve, pump, starboard valve, flood, starboard
   valve** (eight is the fewest; no dead ends) → the cabinet: telegraph
   handle.
4. **Course** (three wheels). The window: left light 2 flashes, right 4. The
   chart: positions (left, right, course) 4-2 095, **2-4 310**, 3-1 170; the
   first is the mirror image, a decoy.
5. **Telegraph.** The handle on the engine telegraph.

# Base 70° South
1. **Duty board** (a face under each shift). The log book: beard directly
   before glasses; hat earlier than beard; hat not on day; scarf not at
   night. Only one rota: **dawn hat, day scarf, dusk beard, night glasses**
   → UV lamp.
2. **UV.** The lamp on the wall map shows **746** by the radio mast (the
   printed 21 and 58 are grid numbers).
3. **Crates** (6 by 6; crates move along their length; the red one leaves on
   the right of its row). 22 steps at best: crate numbers as in `polar.rs`:
   1 w, 3 s, 4 e, 3 s, 1 w w w, 2 s, 3 n n, 4 w, 6 w, 2 s s, 7 e e, 3 n n,
   then the red crate e e e e → the big fuse.
4. **Generator.** The fuse.
5. **Radio** (needs power and the UV numbers): **746** → the teleprinter
   prints four faces: glasses, scarf, beard, hat.
6. **Airlock.** Each face's shift counted from dawn: night 4, day 2, dusk 3,
   dawn 1 → **4231**.

## Balance notes (sixth set)
- Estimated with tools/estimate.py: Graf Alpina 10, Albatross 8, Base 70°
  South 14 minutes; targets 13, 10, 19. Untested by a person.

# The Quiet House (series): design
The same floor of Number 7 in four eras. Walls: the parlour (piano, tiled
stove, door) and Clara's room (bed, window onto the courtyard, wardrobe).
Piano keys 0..7 (C to C'), each with Clara's coloured sticker (red, orange,
yellow, green, blue, indigo, violet, pink). Behind a loose stove tile the
housekeepers keep their notes for each other (story).

## 1905 (easy, `house1905`, prefix h, views H1 parlour, H2 Clara's room)
You are Marie, the young maid, the night Clara vanished.
1. F: the music box's crank is under Clara's pillow.
2. A: crank on the music box: it plays (sound) and shows its pins in the
   stickers' colours (visual twin).
3. D: play the tune on the piano: keys **4 2 0 2 4** → the lid compartment:
   the wardrobe key.
4. A: key on the wardrobe → a hatbox with a lock of three wheels marked with
   a small, a medium and a large treble clef.
5. F: Clara stuck clef stickers in three views, each with dots: small clef on
   the parlour clock (3), medium on a stove tile (7), large on the bed's
   headboard (1) → **371** → Clara's farewell note and the door key.
6. A: the key on the door.

## 1938 (medium, `house1938`, prefix j, views J1 parlour, J2 Berta's room)
You are Berta, housekeeper; the house is to be sold.
1. F: the cracked stove tile → Marie's note of 1905 with her telephone
   number **3815**.
2. C: dial it; talk to old Marie (wrong answers end the call; dial again).
   Right path: say who you are, then ask where the music box is. She hid it
   behind the parlour panelling and painted a mark that only shows when the
   parlour lamp is lit, seen from Clara's window.
3. D: the fuse box (four switches: kitchen, parlour, stairs, shop; more than
   two on blows them): **parlour on**, the lamp lights.
4. E: from Berta's window across the courtyard: the stairwell window opposite
   reflects the lit parlour: the mark on the second panel from the right in
   the reflection, a mirror image: the **second panel from the left** (of
   six) → the music box and the house key.
5. A: the key on the door.

## 1969 (medium, `house1969`, prefix u, views U1 living room, U2 student room)
You rent Clara's old room from Mrs Jost.
1. F: the stove tile: Marie's and Berta's notes, and Berta's sketch of the
   courtyard with one window marked.
2. D: the record player: an old shellac record only plays right at **78**;
   the record (sound) and its sleeve (coloured dots) give the tune's first
   half; the broken music box (pins) its second half.
3. C: play the whole tune on the piano: **4 2 0 2 4 5 7 4** → the piano
   bench: opera glasses.
4. E: Berta's sketch was drawn from the other side of the courtyard (mirrored):
   with the opera glasses, the marked window shows three flowerpots with
   numbers: **528** (other windows show decoys) → the desk drawer: the
   intercom handset.
5. C: the handset on the intercom: Mrs Jost asks three questions about the
   house's story (answers in the notes: Marie hid the box; behind the
   panelling; Clara played the piano) → she opens the door.

## Today (hard, `housenow`, prefix x, views X1 living room, X2 Clara's room)
You renovate the house, the last of the family.
1. F: the stove tile: all the notes; the 1969 one says Clara played her tune
   backwards on her last night.
2. E: the tune backwards: **4 7 5 4 2 0 2 4** → the piano: the toolbox key
   (hammer, matches).
3. D: light the stove (open the damper first): smoke rises from one of the
   three chimneys seen from Clara's window.
4. X: the renovation plan shows the floor from above with the flues; seen
   from the courtyard the roof is mirrored. The chimney that never smokes
   belongs to a flue behind a bricked-up niche: knock the **fourth wall
   segment** (of six) with the hammer → Clara's box (four wheels).
5. E: call the conservatory archive in Paris (number on the record sleeve,
   **0142**): asked the right things, the archivist says Clara always used
   her birth year; the 1905 note says she was 12 that year → **1893**.
6. B: open the box: her letter and a recording. The end.

# Seventh set (0.10.0)

## The Night Edition (hard, `press`, prefix d, views O1 composing room, O2 press hall)
You, the reporter, are locked in an hour before the presses run; the
foreman swapped your front page about Hale's bank. Kinds FXMFCDAEA.
1. F: the waste bin under the case: the foreman's letter to H. (his locker
   number is on his time card; the front page is in it; the watchman's
   instructions are in Tuesday's small ads).
2. X: the time cards (clock number, in, out) and the watchman's log: the
   proofreader came in dry at 22:00 (card 951, 22:03, the decoy), the
   foreman soaked at 22:05 (**263**, 22:07), two compositors left at 22:20
   (418, 102), the apprentice at 22:30 (735, 22:31). Locker **263** → the
   front-page forme (one line missing) and a manual page with the middle of
   the paper path.
3. M: the composing stick: the missing line is the sum in your notebook,
   **47520**. Type prints mirrored: the sorts are mirror images and the line
   reads backwards in the stick: set **0 2 5 7 4**; a proof shows the
   result. Then the forme on the stick: the line goes in.
4. F: the watchman's lantern held against the three paper reels shows their
   watermarks; the house rules on the wall: only paper with the crown of
   five points. Reel 1 has a crown of three (the decoy, met first), reel 2
   an anchor, **reel 3** the right crown. Mount it.
5. C: thread the paper: the wall chart (an ink splash hides rollers 3 and 4)
   and the manual page (rollers 3 and 4): over, under, under, over, over,
   under.
6. D: the ink fountain: five keys; the test sheet shows each column's grey;
   the house rules show the grey wanted (the middle one). All keys to the
   middle.
7. A: the full forme onto the plate cylinder.
8. E: two papers with an ad signed H.: Monday's on the hook in the
   composing room (5816, the decoy) and Tuesday's on the watchman's desk:
   the lost parrot with **3** words, **1** blue feather, **4** toes, answers
   to **2** whistles → the desk drawer **3142** → the press key.
9. A: the key in the press: the edition rolls, the delivery door opens.

## The Great Vaudini (medium, `magic`, prefix v, views F1 dressing room, F2 wings)
Vaudini's apprentice test: out before his curtain call. Kinds FAEFDMCA.
1. F: the costume rack: a small key sewn into the cape's lining.
2. A: the key opens the trunk: the patter script and a letter to his rival.
3. E: the Cabinet of Wonders, six panels; the script's incantation is five
   riddles: **crown, moon, key, sun, eye** (the star is never named). A
   wrong panel starts over. Inside: the marked deck.
4. F: the deck spread on the dressing table: four of eight backs have a tiny
   dot in a corner; the letter says the cards speak in the order a clock's
   hand sweeps the corners, from the top left. Faces: top left 2, top right
   7, bottom right 5, bottom left 8 → padlock **2758**.
5. D: the dressing mirror is two-way: with its bulbs off and the alcove lamp
   on (switch in the wings), you see into the alcove between the rooms: a
   sketch of the sawing box with its three parts shifted.
6. M: Pepper's ghost: the tilted glass in the wings reflects the alcove's
   digit board (only when its lamp is lit) into three windows of the
   backdrop. The handle has five positions marked by clock faces (10, 11,
   12, 1, 2 o'clock); the poster on the dressing-room wall shows the Floating
   Clock at **1 o'clock** → **583** (each other position shows another
   number) → padlock 2.
7. C: the sawing box: the three parts shifted as in the sketch (**2, 0, 3**)
   → a drawer with the toy rabbit, the key of the last padlock inside.
8. A: the last padlock once the other two are open: the chain falls.

## Rain on Gale Street (hard, `noir`, prefix i, views I1 office, I2 reception)
Someone wants the Ambassador case closed and locked you in. Kinds FAEEFEXM.
1. F: the waste basket: a sheet of carbon paper.
2. A: held against the desk lamp (lit): a copy of the intruder's note: the
   cabinet is locked with the numbers on the detective's pad, scribbled over
   in red.
3. E: red light hides red ink: the desk lamp off and the blinds open, the
   neon lights the room red and the pad shows **6047** → the filing cabinet:
   two witness statements (the bartender: when the church clock struck
   eleven; the taxi driver: the moment the rain began).
4. E: the typewriter's ribbon held to the lamp: the last thing typed, read
   backwards: the doorman's statement is in the coat with the red carnation.
5. F: three coats; the pink carnation (met first) is the decoy; the red
   carnation's pocket: the doorman: as the last tram passed the hotel.
6. E: the radio's note: police band = our street number. The door's glass
   reads it mirrored from inside (74, the decoy): **47** → the bulletin: the
   rain began two minutes before eleven.
7. X: the tram timetable (wall): the last tram leaves the depot at 22:41
   and reaches the Ambassador 17 minutes later: 22:58; the rain 22:58; the
   bartender lies (23:00). The note on the case board: the safe is set to
   the minute she left → **2258** → the ruby and a letter opener.
8. M: the key is in the lock outside: carbon paper under the door, push the
   key out with the letter opener, pull the sheet back with the key, open.

# Eighth set (0.11.0)

## The Filter Hall (hard, `filter`, prefix wa, views WA1 engine hall, WA2 filter hall)
An inspector locked in during the opening; the fountain in the square must
run before the mayor's speech ends. Kinds FADCDFEEXMMF.
1. F: the coal bunker hides the engineer's spanner.
2. A: the spanner opens the jammed firebox; the matches (tin on the desk)
   light the fire.
3. D: the boiler's feed valve until the water glass stands between the red
   marks (**5**).
4. C: the speaking tube (once the boiler is right): the chief engineer asks
   what the pressure gauge shows (**in the green**) and which flag flies over
   the pump house across the square (window: **blue**); then he gives the
   starting order.
5. D: three levers (throttle, steam, drains on screen): **steam, drains,
   throttle**; a wrong lever stalls the engine and starts over.
6. F: one of three risers in the filter hall knocks and shakes (sound and
   picture): the **third**; bleed it.
7. E: the plaque's riddle names the layers the water passes, top to bottom:
   gravel, sand, charcoal. Poured bottom first: **charcoal, sand, gravel**;
   the test tap shows clear or muddy water.
8. E: one pipe elbow is missing: the ceremony's curved brass horn fits the
   socket.
9. X: the engineer's notes on the six district valves (exactly three open;
   market shut on Sundays; harbour and station never together; mill only
   with hill; exactly one of harbour and mill; the square open; hill and
   harbour never together) → **mill, hill, square** open, the rest shut.
10. M: the pipe wall (4 by 4 tiles): from the inlet top left through the
    filter tank to the fountain main bottom right; water fills the tiles it
    reaches. Only a path through the filter can reach the main.
11. M: the fountain's jets are the engine's speed (governor, engine hall)
    times each jet's valve (filter hall); the programme shows 2, 6, 2 →
    speed **2**, valves **1, 3, 1** (speed 3 cannot make the small jets).
12. F: the mayor's speech (programme): the water rises when he raises his
    glass; through the window he does it every 15 seconds: open the main
    valve then.

## The 8:15 to Nowhere (hard, `railway`, prefix rc, views RC1 club room, RC2 workshop)
The founder Albert Finch's last layout. Kinds FADDCCXFMEE.
1. F: the controller key is in the model station's clock tower.
2. A: the key in the controller: power.
3. D: the turntable: any engine onto the exit (tracks 1 to 4).
4. D: points P1 to the main line, P2 to the dairy, run: the milk van
   delivered.
5. C: P2 to the tunnel, then in the workshop P3 to the post office, run: the
   parcels delivered (points in both rooms).
6. C: the telephone, speed dial Hollis: say you are a new member of Albert's
   club; yes, four engines but the plates are gone → Duchess always ran the
   7:30.
7. X: Finch's notes (workbench): Comet is blue; Atlas ran the 6:40; black
   later than red; green not Atlas and not the 7:05; Lark later than Comet;
   green before black; plus Duchess 7:30 → the 8:15 is the **black engine,
   track 4**: the 8:15 headboard (workbench) on it.
8. F: during a run through the tunnel the engine's lamp lights a sign in
   the workshop showing a book's spine: the **sixth book** on the shelf
   opens the hidden branch to Nowhere (and comes out in your hand).
9. M: the yard (tracks of 3, 3 and 2 wagons): Finch's letter wants the
   passengers behind the engine, then the mail, the coal at the back: eleven
   moves at best.
10. E: a gap in the hidden branch: the book bridges it.
11. E: the 8:15 itself: turntable to track 4, P1 main, P2 tunnel, P3 on, P4
    to Nowhere, run → the little station: the door opens.

## Harvest Moon (hard, `mill`, prefix mi, views MI1 meal floor, MI2 stone floor)
The harvest festival; the first flour must reach the village before the
moon rises. Kinds FAECFAMCXDEA.
1. F: the cap's winding handle lies under the sacks.
2. A: the handle on the winding wheel.
3. E: the window: the poplars' leaves blow east in each gust, so the wind
   comes from the **west**: wind the cap to face it.
4. C: Greta at the door (once the cap faces the wind): say the sails face
   the wind, ask about the festival → full cloth on the sails with the sun,
   half on those with the moon.
5. F: the sails' tips carry small suns and moons: sails 1 and 3 full, 2 and
   4 half.
6. A: the brake rope on the meal floor releases the brake above: the sails
   turn.
7. M: the miller's song: the stones turn eighteen times for every turn of
   the sails; brake wheel 48, spur wheel 96, rack 12, 16, 24 → wallower
   **16**, stone nut **16** (the only pair).
8. C: the hoist: the clutch upstairs engaged and the trapdoors downstairs
   open.
9. X: the slate's clues (rye from the well farm; the barn's sack oats or
   spelt; no wheat from oak or cow; oak not spelt or oats; cow no spelt) →
   apple wheat, barn spelt, well rye: hoist **apple, barn, well** in the
   bread's order (wheat, spelt, rye); a wrong sack starts over.
10. D: the chute's three flaps: **right, left, right**: fine flour into the
    festival sack, bran into the bran sack.
11. E: the loading door's counterweight is missing: the full bran sack on
    its hook.
12. A: the festival sack onto the cart: it rolls down to the village.

## The Glass Aviary (medium, `aviary`, prefix av, views AV1 entrance, AV2 tropical corner, AV3 pond, AV4 seed store)
The keeper has gone for seed; every bird fed and settled before the doors
open. Kinds FAAFAAACACCAAACADDACACCA.
1. F: the keys lie in the nest box on the entrance post.
2. A: the keys open the seed store.
3. A: the net in the store.
4. F: the fish only jumps now and then (last 3 s of every 9): the net on the
   pond while it is out of the water.
5. A: the fish to the kingfisher.
6. A: an apple from the tree.
7. A: the knife in the store.
8. C: knife on apple: slices.
9. A: slices to the parrot.
10. C: the parrot starts the keeper's greeting; the keeper's note on the
    desk has it: "Good morning, my **feathered friends**" → the parrot
    squawks that the singer's seed is in the **sun** jar.
11. C: the jars (star, moon, sun): the **sun** jar (a wrong one is refused;
    before the parrot says it, no jar is taken).
12. A: seed to the canary; it sings its song (five notes drawn).
13. A: the watering can by the tap.
14. A: can on the tap: water.
15. C: sugar (store) and water: nectar.
16. A: nectar in the hummingbird feeder.
17. D: the orchid's three misting valves (0 to 2): the gauge's green mark
    is **5** in all → it blooms; its label shows the plan's second half.
18. D: the shade crank at the entrance: fully closed (**3**) darkens the
    owl's corner; the owl wakes and flies up.
19. A: the whistle on the owl's empty perch.
20. C: scoop (store) on the grain sack: grain.
21. A: grain to the peacock.
22. C: the whistle at the canary's cage: the canary's song, holes
    **3 1 4 2 3** (left to right, 1 to 4).
23. C: the perch stand's six sliders (0 bottom to 3 top): the desk plan
    gives perches 1 to 3, the orchid's label 4 to 6: **3 1 2 0 2 3**.
24. A: the bell once every bird is fed, the song played and the perches set.

## Hall of Mirrors (medium, `mirrors`, prefix hm, views HM1 entrance, HM2 maze, HM3 funhouse, HM4 carousel)
The fair has closed with the lights still on: start the carousel to call
the attendant. Kinds FACAAFACCCCADCCADAFCAACA.
1. F: a coin glints under the ticket booth.
2. A: the coin in the turnstile.
3. C: the maze plan on the booth: from the entrance (bottom middle) to the
   centre: **E N E N N N W S S W**; a wall is a mirror (bump).
4. A: the brass key at the centre.
5. A: the key opens the prize cabinet: mallet and a cylinder mirror.
6. F: the strength tester only rings when its lamp blinks (last 2 s of
   every 7): hit then → a token.
7. A: the token in Zelda.
8. C: Zelda: ask about **the carousel**, the stars are in **the crooked
   picture** → each horse rises as high as its star is big.
9. C: the cylinder mirror on the smeared drawing: four coloured stars of
   different sizes.
10. C: the horses (red, blue, green, gold) to heights **2 0 3 1**.
11. C: behind the curtain a periscope looks down on the generator's chalk
    mark.
12. A: the generator's dial to the mark (**4**).
13. D: fuses (motor, lights, music, popcorn, fan; more than three trips
    them all): the carousel's sign shows motor, lights, music → those three.
14. C: the squat funhouse mirror shows darts on top of the stall's shelf.
15. C: the balloons in the poster's colour order (**blue, red, purple,
    yellow, green**); a wrong one refills them → prize: a small mirror.
16. A: the mirror into the empty spotlight.
17. D: the two spotlight mirrors (angles **5** and **2**) put the beam on
    the sensor.
18. A: the brake lever (horses, fuses and beam done): the carousel turns.
19. F: as it turns, the golden horse's saddle shows a sign for a moment
    (last 2 s of every 6): the **star**.
20. C: the organ's card with the star, then the crank: music.
21. A: sugar at the candy-floss cart.
22. A: a stick.
23. C: sugar into the machine (power on), then the stick: candy floss.
24. A: candy floss to the clown while the music plays: it honks, the
    attendant comes.

## Detention (medium, `school`, prefix sc, views SC1 blackboard, SC2 desks, SC3 teacher's desk, SC4 back of the room)
Kept in after school in 1925; Miss Keller's list of fifteen tasks; the
door opens when all are done. Kinds FAAACACACDCACAFCDCCCMCAA.
1. F: the cupboard key under the flower pot.
2. A: the key opens the cupboard.
3. A: its shelves: sponge, ink, carrot, pencils.
4. A: the watering can at the pump outside the window: water.
5. C: sponge in the water: wet sponge (before the plant gets it).
6. A: the wet sponge cleans the board: three sums.
7. C: the abacus: **7, 6, 8** (3+4, 9−3, 2×4) → the teacher's drawer opens
   (clock key, matches, sharpener).
8. A: ink in the inkwells.
9. C: name cards on the desks as in the register's plan: **Emil, Anna,
   Fritz, Dora, Ben** (front left to right…).
10. D: clock key on the clock, then set it to the church clock: **3:45**.
11. C: (after the seating) Dora's desk has her pen-friend's letter, the
    stamp's outline → globe to outline **6** (of 8).
12. A: the rest of the water on the plant.
13. C: the books by their numerals (chart on the wall): I II III IV V.
14. A: carrot to the rabbit.
15. F: the rabbit hops aside: a map pin in the straw.
16. C: the pin on the map, then the trip diary's stops in order (castle,
    lake, bridge): towns **5, 2, 6**.
17. D: the stove's damper fully open, then a match (closed: smoke).
18. C: the school song on the harmonium: keys **1 3 5 6 5 3 1**.
19. C: the bell rope as the bell board shows: **long short short long
    long**.
20. C: the janitor at the window (after the smoke): **a pupil kept in**,
    the teacher is **Miss Keller** (door plate) → the spare key is behind
    the class photo.
21. M: the class photo's sliding pieces put right (14 moves at best).
22. C: lost property to the pegs by the embroidered initials: scarf E →
    Emil, cap A → Anna, mitten F → Fritz.
23. A: pencils and sharpener.
24. A: the door key from behind the photo, in the door (all tasks done;
    the task list ticks them off).

## Puffin Island · Spring (easy, `spring`, prefix ps, views PS1 jetty, PS2 cottage, PS3 cliffs, PS4 meadow)
Maggie is laid up; the puffins land at dusk and the supply boat is due.
1. F: the boathouse key in Maggie's boots.
2. A: key on the boathouse: oars, toolbox, spade.
3. A: planks from the woodpile.
4. A: planks across the jetty's gap.
5. C: the toolbox on the gap: the jetty is mended.
6. A: oars in the boat.
7. C: rowing to the bird rock on the chart (6 by 5; rocks), the tide clock
   says the tide runs east (each stroke drifts one cell east): **E N N N N**.
   Straight north from the jetty drifts onto a rock.
8. A: Pip in the nest on the rock.
9. A: Pip into the box by the stove.
10. A: spade on the patch: worms.
11. A: the fishing line in Maggie's coat.
12. C: worms on the line.
13. F: the line from the mended jetty while the float bobs (last 3 s of 8).
14. A: fish to Pip.
15. D: the meadow gates: **right, any, left** lead the lamb to its pen
    (other ways: garden, bog, cliff path).
16. C: the almanac's verse (beans want sun, cabbage the wall's shade,
    carrots between): rows shade to sun **cabbage, carrot, bean**.
17. A: the watering can at the well. 18. A: filled. 19. A: on the sown patch.
20. C: Maggie (once Pip is home): Pip is safe, then **the jetty is mended**
    → she names the signals.
21. C: the flagpole: her three messages looked up in the signal book: flags
    **5, 2, 4** (top to bottom).
22. C: the bone whistle from the shelf, the almanac's puffin call on the
    cliff ledge: **long, short, long, long**.
23. A: the jetty bell once all is done: the supply boat comes.

## Puffin Island · Summer (easy, `summer`, prefix pu, views PU1 harbour, PU2 lighthouse, PU3 barn, PU4 headland)
A squall; Tom's dinghy is caught at the sea stack; Ewan's boat is out.
1. F: the lighthouse key in a lobster pot. 2. A: the door. 3. A: oil from
the store. 4. A: oil in the lamp.
5. F: Pip lands on the harbour wall now and then (last 3 s of 10) with
   something shiny: tap him then → the lens screw.
6. A: the screw in the lens. 7. A: the barn door. 8. A: matches in the barn.
9. A: matches on the oiled lamp.
10. D: the lens turned until the beam falls on Ewan's boat (**7th** stop).
11. A: the old kite (barn). 12. A: the sewing box (lighthouse). 13. C: mend
the kite. 14. A: twine (barn). 15. C: twine on the mended kite.
16. C: at the headland: let out with the gusts (last 2 s of 5, the wind sock
    stands out), hold in the calm (letting out in the calm drops it two);
    five gusts carry the line to Tom.
17. C: Tom shouts across: say the line is fast, ask what to send Ewan →
    "harbour safe".
18. C: the shutter, the code card's "harbour safe": **short, long, long,
    short, long**.
19. C: the bales into the loft as the barn's sign shows the stack: marks
    **3, 1, 4, 2**; a wrong one and the stack falls.
20. A: the harbour horn: Ewan comes home.

## Puffin Island · Autumn (medium, `autumn`, prefix pa, views PA1 orchard, PA2 cider house, PA3 market, PA4 bay)
Market day and the regatta.
1. F: the shed key under the scarecrow's hat. 2. A: the shed: net and
basket. 3. A: the net under the apple tree.
4. F: shake the tree while the wind blows (last 2 s of 6): apples.
5. A: apples in the press.
6. D: the press screw to **6th** notch (0 to 7): looser gives nothing,
   tighter bursts (back to the start).
7. A: bottles. 8. A: bottles at the press: cider.
9. C: the trader: "**cider for flour**", then accept his fair offer → flour.
10. A: eggs from the hen house. 11. C: flour and eggs: dough. 12. C: dough
and apples: the pie. 13. A: pie in the oven.
14. F: take it out while it glows golden (last 3 s of 9).
15. A: pie to the judges: a ribbon.
16. A: the basket at the spring patch: vegetables (carry-over).
17. A: vegetables to the crew: a seat in the boat.
18. C: the regatta: a stroke on each drum beat (1 s in 2); six lengths
    ahead within ten strokes; off-beat loses a length.
19. A: the cup (ribbon and race won).

## Puffin Island · Winter (easy, `winter`, prefix pw, views PW1 lake, PW2 cottage, PW3 lamp room, PW4 ice cave)
The longest night; the lamp is out; a ship is due.
1. F: the shovel in the coal scuttle. 2. A: dig out the door. 3. A: skates.
4. A: wet matches (drawer). 5. A: dried at the stove. 6. A: the lantern.
7. C: matches and lantern: lit.
8. C: Maggie (once dug out): ask about **the oil**, then **the icicles**
   → she tells of the almanac's carol.
9. C: skating to the cave (7 by 6; snowbanks stop you, thin ice marked only
   in the almanac): **N E S W N E**. North, east, north breaks the ice.
10. A: the lit lantern in the cave.
11. C: the icicles (left to right 1 to 5), the carol: **3 5 2 4 1**.
12. A: the oil can behind the ice. 13. A: filled at the barrel. 14. A: oil
in the lamp.
15. M: the lens panels (each turn moves its right neighbour too, the last
    the first): turn panel 1 once and panel 3 twice.
16. A: the crank. 17. A: wound into the clockwork.
18. C: the chart of lights: this light's character, **pattern 5** of 6.
19. A: the lit lantern to the lamp: the light shines, the northern lights.
