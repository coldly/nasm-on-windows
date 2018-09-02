@echo off
nasm -fwin64 %~dp0timestamp64.asm -o %~dp0timestamp64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo timestamp64_golink.exe %~dp0timestamp64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:timestamp64_msft.exe %~dp0timestamp64.obj kernel32.lib
del %~dp0timestamp64.obj
