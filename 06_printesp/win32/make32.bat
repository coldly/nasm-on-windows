nasm -fwin32 printesp32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo printesp32_golink.exe printesp32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:printesp32_msft.exe printesp32.obj kernel32.lib
del printesp32.obj