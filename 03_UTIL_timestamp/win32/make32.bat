nasm -fwin32 timestamp32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo timestamp32_golink.exe timestamp32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:timestamp32_msft.exe timestamp32.obj kernel32.lib
del timestamp32.obj