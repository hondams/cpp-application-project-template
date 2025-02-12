pushd ..\..
"%CLION_HOME%\bin\cmake\win\x64\bin\cmake.exe" --build cmake-build-debug --target clean -j 6
popd
pause
