#!/usr/bin/env bash

set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$BASE/basis_universal"
BUILD_DIR="$BASE/build_shared"

clone_at_revision() {
    local dir="$1"
    local revision="$2"
    local remote="$3"
    shift 3
    [ -d "$dir" ] && return
    git clone "$@" "$remote" "$dir"
    if ! git -C "$dir" checkout --detach "$revision"; then
        git -C "$dir" fetch origin "$revision"
        git -C "$dir" checkout --detach FETCH_HEAD
    fi
}

clone_at_revision "$SOURCE_DIR" 1e9ab1f575cd52d2bfc053dd4def2da5f091316f https://github.com/BinomialLLC/basis_universal.git --depth=1

linux_arch_dir() {
    case "$(uname -m)" in
        x86_64 | amd64) echo "linux_x64" ;;
        aarch64 | arm64) echo "linux_arm64" ;;
        *) echo "linux_$(uname -m)" ;;
    esac
}

darwin_arch_dir() {
    case "$(uname -m)" in
        x86_64 | amd64) echo "darwin_x64" ;;
        aarch64 | arm64) echo "darwin_arm64" ;;
        *) echo "darwin_$(uname -m)" ;;
    esac
}

case "$(uname -s)" in
    Darwin)
        CPU=$(sysctl -n hw.ncpu)
        OUTPUT_DIR="$BASE/$(darwin_arch_dir)"
        LIB_NAME=basisu_c.dylib
        SOURCE_LIB="$BUILD_DIR/libbasisu_c.dylib"
        ;;
    Linux)
        CPU=$(nproc)
        OUTPUT_DIR="$BASE/$(linux_arch_dir)"
        LIB_NAME=basisu_c.so
        SOURCE_LIB="$BUILD_DIR/libbasisu_c.so"
        ;;
    *)
        echo "Unsupported host OS: $(uname -s)" >&2
        exit 1
        ;;
esac

echo "Configuring shared build..."
cmake -S "$BASE" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release -DBASISU_BUILD_SHARED=ON

echo "Building shared project..."
cmake --build "$BUILD_DIR" --target basisu_c --config Release -j"$CPU"

mkdir -p "$OUTPUT_DIR"
cp "$SOURCE_LIB" "$OUTPUT_DIR/$LIB_NAME"

echo "Shared build completed successfully!"
