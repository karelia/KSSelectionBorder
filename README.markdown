Features
========

`KSSelectionBorder` is a fairly small class for drawing the outline & handles Apple uses to represent selections in many of their apps (e.g. iWork and Interface Builder)

Contact
=======

I'm Mike Abdullah, of [Karelia Software](http://karelia.com). [@mikeabdullah](http://twitter.com/mikeabdullah) on Twitter.

Questions about the code should be left as issues at https://github.com/karelia/KSSelectionBorder or message me on Twitter.

Dependencies
============

* [ESCursors](https://github.com/ssp/ESCursors), included as a submodule
* Quartz
* AppKit

Definitely works as far back as OS X v10.5, maybe further

License
=======

### ESCursors ###

[ESCursors](https://github.com/ssp/ESCursors) carries its own license:

You may use this code in your own projects at your own risk.
Please notify us of problems you discover. You are required 
to give reasonable credit when using the code in your projects.

### KSSelectionBorder ###

Copyright © 2009 Karelia Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Usage
=====

Add `KSSelectionBorder.h`, `KSSelectionBorder.m`, `ESCursors.h`, and `ESCursors.m` to your project. Ideally, make this repo a submodule, which in turn includes ESCursors as a submodule. But hey, it's your codebase, do whatever you feel like.

In your code, instantiate `KSSelectionBorder`s as needed and ask them to draw. A variety of instance methods are also provided to figure out precisely where and how to draw, and the cursor for resize handles.