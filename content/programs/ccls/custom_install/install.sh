# Build ccls from source on Alpine
apk add --no-cache git cmake make g++ clang-dev llvm-dev rapidjson-dev
git clone --depth=1 --recursive https://github.com/MaskRay/ccls /tmp/ccls-build
mkdir -p /tmp/ccls-build/build
cd /tmp/ccls-build/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
rm -rf /tmp/ccls-build
