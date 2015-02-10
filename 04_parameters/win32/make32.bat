nasm -fwin32 parameters32.asm
golink /console /dynamicbase /nxcompat /entry _main /fo parameters32_golink.exe parameters32.obj kernel32.dll
"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\link.exe" /LIBPATH:"C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" /DYNAMICBASE /NXCOMPAT /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /OUT:parameters32_msft.exe parameters32.obj kernel32.lib
del parameters32.obj