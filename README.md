# basisu_odin
A set of Odin bindings for the Basis Universal Texture Codec

Currently tracked version is version 2.1.0

## Build

The build scripts clone the pinned Basis Universal source revision when it is missing, then write the native archive to the canonical platform directory.

```bash
# Windows
./build.bat
# Linux/Darwin
./build.sh
```

## NOTE
These bindings are designed to match the basisu_wasm_X.h headers, which are intended for use in C and C FFI (such as Odin). They are complete, however I'm currently mainly developing on a Windows system and cannot debug foreign linking for the Linux and Mac binaries. Please feel free to open a PR if these bindings do not properly bind to a given platform.

Additional note: In the original API, the wasm_bool_t type is a typedef for a uint32_t. However, given its intended usage as a boolean type, I've chosen to bind this as an Odin b32. This should not cause any issues, but if any arise please let me know in an issue. Thanks!
