@echo off
nasm -fwin64 %~dp0hello64.asm -o %~dp0hello64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo hello64_golink.exe %~dp0hello64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:hello64_msft.exe %~dp0hello64.obj kernel32.lib
del %~dp0hello64.obj
