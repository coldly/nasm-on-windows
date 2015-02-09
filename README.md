# nasm-on-windows
This is my personal repository for playing with NASM on Windows, available publicly. It's been helping me brush up on the x86 architecture and learn the x64 architecture.

The 'make' batch scripts build the program once and then link the object file with two different linkers: GoASM's GoLink.exe (http://www.godevtool.com/) and Microsoft's link.exe that came packaged with Visual Studio Express 2013 for Desktop. This will produce two executable files which should behave identically. If you prefer one linker over the other, modify the batch script accordingly. Though I mention a specific version of Microsoft's link.exe, any version should work.
