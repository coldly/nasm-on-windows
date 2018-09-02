@echo off
nasm -fwin32 %~dp0exec32.asm -o %~dp0exec32.obj
golink /console /dynamicbase /nxcompat /entry _main /fo exec32_golink.exe %~dp0exec32.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX86% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:exec32_msft.exe %~dp0exec32.obj kernel32.lib
del %~dp0exec32.obj
