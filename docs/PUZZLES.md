# Hut 2847: puzzles and solutions

**Spoilers. The owner does not read this file.** The values are defined in
`core/src/lib.rs`; the client test `client/tests/smoke_test.gd` plays exactly
this walkthrough.

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
