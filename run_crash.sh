#!/bin/bash
set -e

echo "[*] Installing dependencies (if needed)..."
sudo apt update
sudo apt install -y clang cmake make

echo "[*] Cleaning previous build..."
rm -rf build && mkdir build && cd build

echo "[*] Building libjpeg-turbo with ASAN..."
CC=clang CFLAGS="-fsanitize=address -g" cmake ..
make -j$(nproc)
cd ..

echo "[*] Running crash input..."
./build/cjpeg crash-poc/crash_input.ppm > /dev/null
