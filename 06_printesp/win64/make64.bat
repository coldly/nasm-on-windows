@echo off
nasm -fwin64 %~dp0printesp64.asm -o %~dp0printesp64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo printesp64_golink.exe %~dp0printesp64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:printesp64_msft.exe %~dp0printesp64.obj kernel32.lib
del %~dp0printesp64.obj
