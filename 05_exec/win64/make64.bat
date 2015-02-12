nasm -fwin64 exec64.asm
golink /console /dynamicbase /nxcompat /entry _main /fo exec64_golink.exe exec64.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib\x64" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:_main /OUT:exec64_msft.exe exec64.obj kernel32.lib
del exec64.obj
