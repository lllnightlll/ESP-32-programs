#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build/linux

if command -v g++ >/dev/null 2>&1 && command -v cmake >/dev/null 2>&1; then
  cmake --preset linux
  cmake --build --preset linux
elif [ -x "${HOME}/.local/zig/zig" ]; then
  "${HOME}/.local/zig/zig" c++ -std=c++17 -g -O0 -o build/linux/esp32-programs src/main.cpp
elif [ -x "${HOME}/.local/bin/micromamba" ]; then
  prefix="${HOME}/.local/host-cpp"
  "${HOME}/.local/bin/micromamba" run -p "${prefix}" \
    cmake --preset linux -DCMAKE_BUILD_RPATH="${prefix}/lib"
  "${HOME}/.local/bin/micromamba" run -p "${prefix}" \
    cmake --build --preset linux
else
  echo "g++ and cmake are missing. Install build-essential and cmake, or put Zig in ~/.local/zig." >&2
  exit 1
fi
