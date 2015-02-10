nasm -fwin32 printdword32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo printdword32_golink.exe printdword32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:printdword32_msft.exe printdword32.obj kernel32.lib
del printdword32.obj