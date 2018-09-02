@echo off
nasm -fwin32 %~dp0printdword32.asm -o %~dp0printdword32.obj
golink /console /dynamicbase /nxcompat /entry _main /fo printdword32_golink.exe %~dp0printdword32.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX86% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:printdword32_msft.exe %~dp0printdword32.obj kernel32.lib
del %~dp0printdword32.obj
