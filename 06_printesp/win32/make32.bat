@echo off
nasm -fwin32 %~dp0printesp32.asm -o %~dp0printesp32.obj
golink /console /dynamicbase /nxcompat /entry _main /fo printesp32_golink.exe %~dp0printesp32.obj kernel32.dll
CALL %~dp0..\..\setmspath.bat
%MSLinker% /LIBPATH:%MSLibsX86% /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:printesp32_msft.exe %~dp0printesp32.obj kernel32.lib
del %~dp0printesp32.obj
