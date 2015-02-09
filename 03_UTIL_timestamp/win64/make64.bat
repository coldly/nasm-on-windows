nasm -fwin64 timestamp64.asm
golink /console /dynamicbase /nxcompat /entry _main /fo timestamp64_golink.exe timestamp64.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib\x64" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:timestamp64_msft.exe timestamp64.obj kernel32.lib
del timestamp64.obj