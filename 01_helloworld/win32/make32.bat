nasm -fwin32 hello32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo hello32_golink.exe hello32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:hello32_msft.exe hello32.obj kernel32.lib
del hello32.obj