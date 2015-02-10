nasm -fwin64 printdword64.asm
golink /console /dynamicbase /nxcompat /entry _main /fo printdword64_golink.exe printdword64.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib\x64" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:printdword64_msft.exe printdword64.obj kernel32.lib
del printdword64.obj