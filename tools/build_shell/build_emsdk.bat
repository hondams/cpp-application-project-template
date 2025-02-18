pushd ..\emsdk
call emsdk.bat install latest
call emsdk.bat activate latest
call emsdk_env.bat
call emcc.bat --version
popd
pause
