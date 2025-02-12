set CLION_HOME=C:\Program Files (x86)\JetBrains\CLion 2024.3.2
setx CLION_HOME "%CLION_HOME%"

pushd ..\..

mkdir cmake-build-debug > NUL 2>&1
pushd cmake-build-debug
"%CLION_HOME%\bin\cmake\win\x64\bin\cmake.exe" -DCMAKE_BUILD_TYPE=Debug "-DCMAKE_MAKE_PROGRAM=%CLION_HOME:\=/%/bin/ninja/win/x64/ninja.exe" -G Ninja -S .. -B .
popd

popd

pause
