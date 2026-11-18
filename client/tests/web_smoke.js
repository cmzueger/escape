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
  await tap(178, 150); // Play on the first card (Hut 2847)
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
  await tap(135, 155); // Continue on the first card
  check((await mode()) === "play" && (await state()).flags.includes("lamp_lit"), "the saved game continues after a reload");
  // The second room.
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  await tap(475, 155); // Play on the second card (Gale Rock Light)
  check((await page.evaluate(() => window.hut.room)) === "light" && (await state()).room === "light", "the lighthouse starts");
  // The third room.
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  await page.waitForTimeout(500);
  await tap(777, 155); // Play on the third card (Col Sidereal)
  check((await page.evaluate(() => window.hut.room)) === "obs" && (await state()).room === "obs", "the observatory starts");
  // The second and third row, then the fourth, which is reached by scrolling.
  for (const [x, y, id, scroll] of [[173, 274, "orangery"], [475, 274, "theatre"], [777, 289, "chess"],
    [173, 408, "beach"], [475, 408, "train"], [777, 404, "alch"],
    [173, 381, "attic", 100], [475, 381, "watch", 100], [777, 377, "museum", 100],
    [173, 193, "tree", 4000], [475, 193, "gondola", 4000], [777, 193, "praline", 4000],
    [173, 312, "toyshop", 4000], [475, 312, "zeppelin", 4000], [777, 312, "ship", 4000], [475, 431, "polar", 4000]]) {
    await page.reload();
    await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
    await page.waitForTimeout(500);
    if (scroll) {
      await page.mouse.move(480, 300);
      await page.mouse.wheel(0, scroll);
      await page.waitForTimeout(500);
    }
    await tap(x, y);
    check((await page.evaluate(() => window.hut.room)) === id && (await state()).room === id, id + " starts");
  }
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
    await touch("touchStart", 173, 155);
    await touch("touchEnd");
    await phone.waitForTimeout(500);
    const after = await phone.evaluate(() => window.hut.room);
    check((await phone.evaluate(() => window.hut.mode)) === "play" && after !== "hut", "the swipe scrolled the catalogue (" + after + ")");
    await ctx.close();
  }
  check(errors.length === 0, "no page errors " + JSON.stringify(errors));

  await browser.close();
  console.log("RESULT: " + (failures === 0 ? "PASS" : "FAIL (" + failures + ")"));
  process.exit(failures === 0 ? 0 : 1);
})();
