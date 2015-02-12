nasm -fwin32 exec32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo exec32_golink.exe exec32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:exec32_msft.exe exec32.obj kernel32.lib
del exec32.obj
