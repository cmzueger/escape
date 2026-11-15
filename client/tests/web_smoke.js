// Browser smoke test for the web build (client/build-web.sh): loads it in
// headless Chromium, starts a game by tapping, takes the matches and lights
// the lamp, and checks the room through the page's copy of the rules.
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
  console.log("Hut 2847 web smoke test");
  const browser = await chromium.launch({ args: ["--use-angle=swiftshader", "--enable-unsafe-swiftshader"] });
  // The game's own size, so the taps below are in its coordinates.
  const page = await browser.newPage({ viewport: { width: 960, height: 540 } });
  const errors = [];
  page.on("pageerror", (e) => errors.push(String(e)));
  await page.goto(url);
  const state = async () => JSON.parse(await page.evaluate(() => window.hut.call("state"))).state;
  const mode = () => page.evaluate(() => window.hut && window.hut.mode);
  const tap = async (x, y) => {
    await page.mouse.click(x, y);
    await page.waitForTimeout(300);
  };

  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  check(true, "the title screen appears");
  await tap(480, 308); // Play
  check((await mode()) === "play", "Play starts a game");
  await tap(480, 380); // Begin (the story panel)
  await tap(281, 210); // the coat
  check((await state()).inv.includes("matches"), "matches taken from the coat");
  await tap(227, 506); // the first inventory slot
  await tap(640, 266); // the lamp
  check((await state()).flags.includes("lamp_lit"), "the lamp is lit");
  await page.waitForTimeout(1500);
  check((await state()).secs >= 1, "the clock runs");
  await tap(928, 236); // right: the kitchen wall
  check((await page.evaluate(() => window.hut.view)) === "B", "the arrow turns to the next wall");
  if (shot) await page.screenshot({ path: shot });
  // The game is saved in the browser: a reload offers to continue.
  await page.waitForTimeout(5000);
  await page.reload();
  await page.waitForFunction(() => window.hut && window.hut.mode === "title", null, { timeout: 60000 });
  check((await state()).flags.includes("lamp_lit"), "the saved game is loaded after a reload");
  check(errors.length === 0, "no page errors " + JSON.stringify(errors));

  await browser.close();
  console.log("RESULT: " + (failures === 0 ? "PASS" : "FAIL (" + failures + ")"));
  process.exit(failures === 0 ? 0 : 1);
})();
