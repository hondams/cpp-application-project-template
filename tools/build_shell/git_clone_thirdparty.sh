pushd ../../thirdparty

git clone https://github.com/bkaradzic/bgfx.cmake.git
pushd bgfx.cmake
git checkout -b v1.129.8866-491 refs/tags/v1.129.8866-491
git submodule init
git submodule update
popd

git clone https://github.com/memononen/nanovg.git

popd


pushd ..

git clone https://github.com/emscripten-core/emsdk.git
pushd emsdk
git checkout -b 4.0.3 refs/tags/4.0.3
popd

popd
