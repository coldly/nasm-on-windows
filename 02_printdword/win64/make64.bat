@echo off
nasm -fwin64 %~dp0printdword64.asm -o %~dp0printdword64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo printdword64_golink.exe %~dp0printdword64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:printdword64_msft.exe %~dp0printdword64.obj kernel32.lib
del %~dp0printdword64.obj
