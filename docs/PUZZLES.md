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
