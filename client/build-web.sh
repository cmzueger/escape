#!/bin/sh
# Builds the web version. Output: client/export/web/ (a static site).
#   GODOT=/path/to/godot client/build-web.sh
# Needs Rust with the wasm32-unknown-unknown target and Godot 4.5 with its
# web export templates.
set -e
cd "$(dirname "$0")/.."
: "${GODOT:=godot}"
rustup target add wasm32-unknown-unknown >/dev/null 2>&1 || true
cargo build --release -p hut-web --target wasm32-unknown-unknown
out=client/export/web
rm -rf "$out"
mkdir -p "$out"
touch client/export/.gdignore # keep Godot from importing build output
"$GODOT" --headless --path client --import >/dev/null 2>&1 || true
"$GODOT" --headless --path client --export-release "Web" export/web/index.html
cp client/web/hut-engine.js client/web/manifest.webmanifest "$out/"
cp target/wasm32-unknown-unknown/release/hut_web.wasm "$out/"
# Large files go compressed; hut-engine.js unpacks them in the browser.
for f in "$out"/index.wasm "$out"/index.pck; do
  gzip -9 -n "$f"
  mv "$f.gz" "$f.gz.wasm"
done
touch "$out/.nojekyll"
ls -la "$out"
echo "Web build: $out"
