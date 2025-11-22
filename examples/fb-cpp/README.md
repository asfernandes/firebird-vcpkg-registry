# fb-cpp example

This directory contains a minimal CMake application that links against the `fb-cpp` port via vcpkg's manifest mode.

## Prerequisites

- A local clone of vcpkg with `VCPKG_ROOT` pointing to it.
- This registry available locally (a simple clone is enough).

## Configure and build

```bash
cmake -S . -B build
cmake --build build
```

The resulting executable is written to `build/fb-cpp-example`.

## Install with bundled dependencies

Use `cmake --install` to stage the example plus its runtime requirements from vcpkg into a prefix of your choice:

```bash
cmake --install build --prefix /tmp/fb-cpp-install [--config Release]
```
