@echo off
nasm -fwin32 %~dp0hello32.asm -o %~dp0hello32.obj
golink /console /dynamicbase /nxcompat /entry _main /fo hello32_golink.exe %~dp0hello32.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX86% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:hello32_msft.exe %~dp0hello32.obj kernel32.lib
del %~dp0hello32.obj
