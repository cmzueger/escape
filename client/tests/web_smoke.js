// Browser smoke test for the web build (client/build-web.sh): loads it in
// headless Chromium, starts the first room by tapping its card, takes the
// matches and lights the lamp, reloads and continues, starts the other rooms,
// and checks the rooms through the page's copy of the rules.
//   (cd client/export/web && python3 -m http.server 8799) &
//   NODE_PATH=$(npm root -g) node client/tests/web_smoke.js http://localhost:8799/ [screenshot.png]
// Needs Playwright with Chromium.
const { chromium } = require("playwright");

const url = process.argv[2] || "http://localhost:8799/";
const shot = process.argv[3];
let failures = 0;

function check(ok, what) {
  console.log(ok ? "  ok   " : "  FAIL ", what);
  if (!ok) failures++;
}

(async () => {
  console.log("Locked In web smoke test");
  const browser = await chromium.launch({ args: ["--use-angle=swiftshader", "--enable-unsafe-swiftshader"] });
  // The game's own size, so the taps below are in its coordinates.
  const page = await browser.newPage({ viewport: { width: 960, height: 540 } });
  const errors = [];
  page.on("pageerror", (e) => errors.push(String(e)));
  // Tap everything that reaches the speakers, to check that sound is heard.
  await page.addInitScript(() => {
    window.__peak = 0;
    const connect = AudioNode.prototype.connect;
    AudioNode.prototype.connect = function (dest, ...rest) {
      if (dest instanceof AudioDestinationNode && !dest.context.__tap) {
        const tap = dest.context.createAnalyser();
        const buf = new Float32Array(tap.fftSize);
        dest.context.__tap = tap;
        setInterval(() => {
          tap.getFloatTimeDomainData(buf);
          for (const v of buf) window.__peak = Math.max(window.__peak, Math.abs(v));
        }, 20);
      }
      if (dest instanceof AudioDestinationNode) connect.call(this, dest.context.__tap);
      return connect.call(this, dest, ...rest);
    };
  });
  await page.goto(url);
  const state = async () => JSON.parse(await page.evaluate(() => window.hut.call("state"))).state;
  const mode = () => page.evaluate(() => window.hut && window.hut.mode);
  const tap = async (x, y) => {
    await page.mouse.click(x, y);
    await page.waitForTimeout(300);
  };

  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  check(true, "the catalogue appears");
  await tap(178, 180); // Play on the first card (Hut 2847)
  check((await mode()) === "play", "Play starts a game");
  await tap(480, 406); // Begin (the story panel)
  await tap(281, 210); // the coat
  check((await state()).inv.includes("matches"), "matches taken from the coat");
  await tap(178, 506); // the first inventory slot
  await tap(640, 266); // the lamp
  check((await state()).flags.includes("lamp_lit"), "the lamp is lit");
  await page.waitForTimeout(1500);
  check((await state()).secs >= 1, "the clock runs");
  const peak = await page.evaluate(() => window.__peak);
  check(peak > 0.01, "sound is heard (peak " + peak.toFixed(3) + ")");
  await tap(928, 236); // right: the kitchen wall
  check((await page.evaluate(() => window.hut.view)) === "B", "the arrow turns to the next wall");
  if (shot) await page.screenshot({ path: shot });
  // The game is saved in the browser: after a reload the card offers to continue.
  await page.waitForTimeout(5000);
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  await tap(135, 180); // Continue on the first card
  check((await mode()) === "play" && (await state()).flags.includes("lamp_lit"), "the saved game continues after a reload");
  // The second room.
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  await tap(480, 180); // Play on the second card (Gale Rock Light)
  check((await page.evaluate(() => window.hut.room)) === "light" && (await state()).room === "light", "the lighthouse starts");
  // The third room.
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  await tap(782, 180); // Play on the third card (Col Sidereal)
  check((await page.evaluate(() => window.hut.room)) === "obs" && (await state()).room === "obs", "the observatory starts");
  // The second and third row.
  for (const [x, y, id] of [[178, 300, "orangery"], [480, 300, "theatre"], [782, 314, "chess"],
    [178, 432, "beach"], [480, 432, "train"], [782, 430, "alch"]]) {
    await page.reload();
    await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
    await page.waitForTimeout(500);
    await tap(x, y);
    check((await page.evaluate(() => window.hut.room)) === id && (await state()).room === id, id + " starts");
  }
  check(errors.length === 0, "no page errors " + JSON.stringify(errors));

  await browser.close();
  console.log("RESULT: " + (failures === 0 ? "PASS" : "FAIL (" + failures + ")"));
  process.exit(failures === 0 ? 0 : 1);
})();
