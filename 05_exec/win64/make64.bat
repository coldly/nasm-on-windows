@echo off
nasm -fwin64 %~dp0exec64.asm -o %~dp0exec64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo exec64_golink.exe %~dp0exec64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:exec64_msft.exe %~dp0exec64.obj kernel32.lib
del %~dp0exec64.obj
