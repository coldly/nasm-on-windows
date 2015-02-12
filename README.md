# nasm-on-windows
This is my personal repository for playing with NASM on Windows, available
publicly. It's been helping me brush up on the x86 architecture and learn the
x64 architecture.

The 'make' batch scripts build the program once and then link the object file
with two different linkers: GoASM's GoLink.exe (http://www.godevtool.com/)
and Microsoft's link.exe that came packaged with Visual Studio Express 2013
for Desktop. This will produce two executable files which should behave
identically. If you prefer one linker over the other, modify the batch script
accordingly. Though I mention a specific version of Microsoft's link.exe, any
version should work.

Specific versions of the linkers I'm using with this repository are:
 - GoLink.Exe Version 0.28.0.0 - Copyright Jeremy Gordon 2002/12
 - Microsoft (R) Incremental Linker Version 12.00.21005.1
   Copyright (C) Microsoft Corporation

I've passively noticed a couple of differences between the linkers so far:
 - GoLink.exe occassionally produces smaller executables
 - GoLink.exe does not catch bugs relating to Win64 indirect references like
   link.exe does, but instead outputs the faulty executable without warnings.
   For more information about Win64 indirect references see Section 7.6.1,
   "win64: Writing Position-Independent Code" of the NASM Manual.
