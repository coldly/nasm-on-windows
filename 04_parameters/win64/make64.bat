@echo off
nasm -fwin64 %~dp0parameters64.asm -o %~dp0parameters64.obj
golink /console /dynamicbase /nxcompat /entry _main /fo parameters64_golink.exe %~dp0parameters64.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX64% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:parameters64_msft.exe %~dp0parameters64.obj kernel32.lib
del %~dp0parameters64.obj
