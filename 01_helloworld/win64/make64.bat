nasm -fwin64 hello64.asm
golink /console /dynamicbase /nxcompat /entry _main /fo hello64_golink.exe hello64.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib\x64" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:hello64_msft.exe hello64.obj kernel32.lib
del hello64.obj