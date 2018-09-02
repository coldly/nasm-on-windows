# nasm-on-windows
This is my personal repository for playing with NASM on Windows, available
publicly. It's been helping me brush up on the x86 architecture and learn the
x64 architecture.

The "make" batch scripts build the program once and then link the object file
with two different linkers: GoASM's [GoLink.exe](http://www.godevtool.com/)
and Microsoft's link.exe that came packaged with Visual Studio 2017. This will
produce two executable files which should behave identically. If you prefer one
linker over the other, modify the batch script accordingly. Though I mention a
specific version of Microsoft's link.exe, any version should work.

Note that I have hardcoded the path to the Microsoft linker based on my
computer's installation directory of Visual Studio 2017. You may need to adjust
this path, which is set in the setmspath.bat file.

You will need to install the [Windows 10 SDK](https://developer.microsoft.com/en-US/windows/downloads/windows-10-sdk)
to link using the Microsoft linker.

Specific versions of the linkers I'm using with this repository are:
* GoLink.Exe Version 1.0.3.0  Copyright Jeremy Gordon 2002-2018   info@goprog.com
* Microsoft (R) Incremental Linker Version 14.00.24234.1
   Copyright (C) Microsoft Corporation.  All rights reserved.

I've passively noticed a couple of differences between the linkers so far:
* GoLink.exe occassionally produces smaller executables
* GoLink.exe does not catch bugs relating to Win64 indirect references like
   link.exe does, but instead outputs the faulty executable without warnings.
   This may have changed since version 0.28.0.0 I had tested with earlier.

For more information about Win64 indirect references see [Section 7.6.1](https://www.nasm.us/doc/nasmdoc7.html#section-7.6.1),
"win64: Writing Position-Independent Code" of the NASM Manual.
