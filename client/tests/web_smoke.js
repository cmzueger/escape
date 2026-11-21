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
  // Sort chip: newest first, easiest first, oldest first (remembered).
  await tap(776, 39);
  await tap(776, 39);
  await tap(402, 130); // Play on the first card (Hut 2847)
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
  await tap(402, 118); // Continue on the first card
  check((await mode()) === "play" && (await state()).flags.includes("lamp_lit"), "the saved game continues after a reload");
  // Other cards, filters and orders: [chip taps after a reload, card button, room].
  // The filters are remembered, so each step starts where the last one left
  // off (sort: newest, easiest, oldest; set: all, then each set in order).
  const SORT = [776, 39], HARD = [509, 74], LEVELS = [285, 74], SET = [630, 74], OPEN = [418, 39];
  for (const [chips, x, y, id] of [
    [[], 873, 130, "light"], [[], 402, 214, "obs"],
    [[SORT], 402, 130, "winter"], [[], 873, 130, "autumn"],
    [[HARD], 402, 130, "mill"], [[SET], 402, 130, "obs"],
    [[LEVELS], 873, 130, "light"], [[SET, SET, SET, SET, SET, SET], 873, 214, "house1905"],
    [[SET, SET, SET, SET, OPEN], 402, 214, "summer"]]) {
    await page.reload();
    await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
    await page.waitForTimeout(500);
    for (const [cx, cy] of chips) {
      await tap(cx, cy);
      await page.waitForTimeout(500); // the catalogue is built again
    }
    await tap(x, y);
    check((await page.evaluate(() => window.hut.room)) === id && (await state()).room === id, id + " starts");
    // The browser stores the remembered filters a moment later.
    await page.waitForTimeout(2000);
  }
  // Full screen, asked for with the button and made when the finger lifts.
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  check((await page.evaluate(() => window.hutScreen.state())) === "off", "the browser offers full screen");
  await page.mouse.move(774, 498);
  await page.mouse.down();
  await page.waitForTimeout(200);
  await page.mouse.up();
  await page.waitForTimeout(500);
  check((await page.evaluate(() => window.hutScreen.state())) === "on", "the button turns full screen on");
  // On a phone: a swipe that starts on a Play button scrolls and starts nothing;
  // a tap still plays.
  {
    const ctx = await browser.newContext({ viewport: { width: 960, height: 540 }, hasTouch: true, isMobile: true });
    const phone = await ctx.newPage();
    phone.on("pageerror", (e) => errors.push(String(e)));
    await phone.goto(url);
    await phone.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
    await phone.waitForTimeout(500);
    const cdp = await ctx.newCDPSession(phone);
    const touch = (type, x, y) => cdp.send("Input.dispatchTouchEvent", { type, touchPoints: type === "touchEnd" ? [] : [{ x, y }] });
    await touch("touchStart", 173, 400);
    for (let i = 1; i <= 12; i++) {
      await touch("touchMove", 173, 400 - i * 20);
      await phone.waitForTimeout(30);
    }
    await touch("touchEnd");
    await phone.waitForTimeout(500);
    check((await phone.evaluate(() => window.hut.mode)) === "title", "a swipe over the cards starts no room");
    await touch("touchStart", 402, 130);
    await touch("touchEnd");
    await phone.waitForTimeout(500);
    const after = await phone.evaluate(() => window.hut.room);
    check((await phone.evaluate(() => window.hut.mode)) === "play" && after !== "school", "the swipe scrolled the catalogue (" + after + ")");
    await ctx.close();
  }
  check(errors.length === 0, "no page errors " + JSON.stringify(errors));

  await browser.close();
  console.log("RESULT: " + (failures === 0 ? "PASS" : "FAIL (" + failures + ")"));
  process.exit(failures === 0 ? 0 : 1);
})();
