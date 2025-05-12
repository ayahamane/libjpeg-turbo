#!/bin/bash
set -e

REPO_URL="https://github.com/ayahamane/libjpeg-turbo.git"
BRANCH_NAME="CVE-2020-13790-postpatch"

echo "[*] Installing dependencies (if needed)..."
sudo apt update
sudo apt install -y git clang cmake make

echo "[*] Cloning patched version..."
git clone --branch "$BRANCH_NAME" "$REPO_URL" libjpeg-turbo
cd libjpeg-turbo

echo "[*] Cleaning previous build (if any)..."
rm -rf build && mkdir build && cd build

echo "[*] Building with ASan..."
CC=clang CFLAGS="-fsanitize=address -g" cmake ..
make -j$(nproc)
cd ..

echo "[*] Running crash input..."
./build/cjpeg crash-poc/crash_input.ppm > /dev/null
