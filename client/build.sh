#!/bin/sh
# Builds the Rust GDExtension and copies it into client/bin/ for this
# desktop platform (Linux, macOS or Windows via Git Bash).
#   client/build.sh            release build
#   client/build.sh debug      debug build
set -e
cd "$(dirname "$0")/.."
profile="${1:-release}"
if [ "$profile" = "release" ]; then cargo build --release -p hut-godot; else cargo build -p hut-godot; fi
mkdir -p client/bin
touch client/bin/.gdignore
for lib in libhut_godot.so libhut_godot.dylib hut_godot.dll; do
  if [ -f "target/$profile/$lib" ]; then cp "target/$profile/$lib" client/bin/; echo "copied $lib"; fi
done
