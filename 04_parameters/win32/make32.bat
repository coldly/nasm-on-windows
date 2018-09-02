@echo off
nasm -fwin32 %~dp0parameters32.asm -o %~dp0parameters32.obj
golink /console /dynamicbase /nxcompat /entry _main /fo parameters32_golink.exe %~dp0parameters32.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX86% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:parameters32_msft.exe %~dp0parameters32.obj kernel32.lib
del %~dp0parameters32.obj
