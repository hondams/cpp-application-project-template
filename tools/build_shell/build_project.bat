pushd ..\..
"%CLION_HOME%\bin\cmake\win\x64\bin\cmake.exe" --build "%CD%\cmake-build-debug" --target all -j 6
popd
pause
