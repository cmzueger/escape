// Hut 2847 for the Godot web build (included in the page's <head> by the
// "Web" export preset; client/build-web.sh copies it next to index.html).
//
// The room's rules are the Rust crate web/ compiled to WebAssembly
// (hut_web.wasm); GDScript calls it through JavaScriptBridge
// (client/scripts/room_link.gd).
//
// Large files are shipped gzip-compressed and unpacked here. They are named
// <file>.gz.wasm (index.wasm.gz.wasm, index.pck.gz.wasm) because every
// static host serves .wasm files, while some refuse .gz.
(function () {
  "use strict";

  const plainFetch = window.fetch.bind(window);
  const packed = /\.(wasm|pck)$/;

  async function unpack(response, type) {
    const bytes = new Uint8Array(await response.arrayBuffer());
    // Some hosts already decompress (Content-Encoding: gzip); check the magic.
    let body = bytes;
    if (bytes[0] === 0x1f && bytes[1] === 0x8b) {
      const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream("gzip"));
      body = new Uint8Array(await new Response(stream).arrayBuffer());
    }
    return new Response(body, { status: 200, headers: { "Content-Type": type } });
  }

  window.fetch = async function (input, init) {
    const url = typeof input === "string" ? input : input.url;
    const path = url.split(/[?#]/)[0];
    if (packed.test(path) && !path.endsWith(".gz.wasm") && typeof DecompressionStream !== "undefined") {
      const type = path.endsWith(".wasm") ? "application/wasm" : "application/octet-stream";
      const gz = await plainFetch(path + ".gz.wasm", init);
      if (gz.ok) {
        return unpack(gz, type);
      }
    }
    return plainFetch(input, init);
  };

  let engine = null;
  let failure = "";

  function call(command) {
    const bytes = new TextEncoder().encode(command);
    const ptr = engine.hut_alloc(bytes.length);
    new Uint8Array(engine.memory.buffer, ptr, bytes.length).set(bytes);
    const n = engine.hut_call(ptr, bytes.length);
    engine.hut_free(ptr, bytes.length);
    return new TextDecoder().decode(new Uint8Array(engine.memory.buffer, engine.hut_out(), n));
  }

  (async function () {
    try {
      const response = await window.fetch("hut_web.wasm");
      if (!response.ok) {
        throw new Error("hut_web.wasm: HTTP " + response.status);
      }
      engine = (await WebAssembly.instantiate(await response.arrayBuffer(), {})).instance.exports;
    } catch (e) {
      failure = String(e);
    }
  })();

  window.hut = {
    ready: () => engine !== null,
    failure: () => failure,
    call: (command) => (engine ? call(command) : '{"ok":false,"error":"not loaded"}'),
    // For tests: what the game shows (set by the client).
    view: "",
  };
})();
