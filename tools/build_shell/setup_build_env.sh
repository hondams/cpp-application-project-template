export CLION_HOME=/c/Program\ Files\ \(x86\)/JetBrains/CLion\ 2024.3.2
export C=~/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/gcc.exe
export CC=~/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/g++.exe

pushd ..\..

mkdir cmake-build-debug > dev/null 2>&1
pushd cmake-build-debug
cmake -DCMAKE_C_COMPILER=$C -DCMAKE_CXX_COMPILER=$CC -DCMAKE_BUILD_TYPE=Debug "-DCMAKE_MAKE_PROGRAM=$CLION_HOME/bin/ninja/win/x64/ninja.exe" -G Ninja -S .. -B .
popd

popd

pause
