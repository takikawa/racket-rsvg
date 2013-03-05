RSVG: an FFI binding for loading SVG images
-------------------------------------------

```racket
 (require rsvg)
```

This library provides functions for loading SVG images as Racket bitmap
objects through an FFI binding to
[libRSVG](https://live.gnome.org/LibRsvg). The resulting bitmap objects
can then be freely manipulated with the `racket/draw` or
`slideshow/pict` libraries.

```racket
(load-svg-bitmap port) -> (is-a?/c bitmap%)
  port : input-port?                       
```

Loads an SVG document from `port` and returns a bitmap object with the
SVG document rendered in it.

Raises an `exn:fail` exception when the SVG document fails to load.

```racket
(load-svg-from-file file) -> (is-a?/c bitmap%)
  file : path-string?                         
```

Like `load-svg-bitmap`, but takes a path string argument instead of an
input port.
