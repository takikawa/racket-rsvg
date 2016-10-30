RSVG: an FFI binding for loading SVG images
-------------------------------------------

[![Scribble](https://img.shields.io/badge/Docs-Scribble-blue.svg)](http://pkg-build.racket-lang.org/doc/rsvg/index.html)

Install:

```
 raco pkg install rsvg
```

Use:

```racket
 (require rsvg)
```

This library provides functions for loading SVG images as Racket bitmap
objects through an FFI binding to
[libRSVG](https://live.gnome.org/LibRsvg). The resulting bitmap objects
can then be freely manipulated with the `racket/draw` or
`pict` libraries.

Bug reports and patches welcome.

---

Copyright © 2013-2016 Asumu Takikawa.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program. If not, see http://www.gnu.org/licenses.
