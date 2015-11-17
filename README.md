RSVG: an FFI binding for loading SVG images
-------------------------------------------

[![Scribble](https://img.shields.io/badge/Docs-Scribble-blue.svg)](http://pkg-build.racket-lang.org/doc/rsvg/index.html)

```racket
 (require rsvg)
```

This library provides functions for loading SVG images as Racket bitmap
objects through an FFI binding to
[libRSVG](https://live.gnome.org/LibRsvg). The resulting bitmap objects
can then be freely manipulated with the `racket/draw` or
`slideshow/pict` libraries.

Note: this is alpha software and has only been tested on
      Debian GNU/Linux. Bug reports and patches welcome.

---

Copyright © 2013-2015 Asumu Takikawa.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

