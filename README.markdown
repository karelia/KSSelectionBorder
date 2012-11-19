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

Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Usage
=====

Add `KSSelectionBorder.h`, `KSSelectionBorder.m`, `ESCursors.h`, and `ESCursors.m` to your project. Ideally, make this repo a submodule, which in turn includes ESCursors as a submodule. But hey, it's your codebase, do whatever you feel like.

In your code, instantiate `KSSelectionBorder`s as needed and ask them to draw. A variety of instance methods are also provided to figure out precisely where and how to draw, and the cursor for resize handles.