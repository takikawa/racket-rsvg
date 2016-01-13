#lang scribble/manual

@title{RSVG: an FFI binding for loading SVG images}

@(require (for-label racket/base
                     racket/class
                     racket/draw
                     pict
                     rsvg))

@defmodule[rsvg]

This library provides functions for loading SVG images as
Racket bitmap objects through an FFI binding to
@hyperlink["https://live.gnome.org/LibRsvg" "libRSVG"].
The resulting bitmap objects can then be freely manipulated with
the @racketmodname[racket/draw] or @racketmodname[pict] libraries.

@defproc[(svg-port->pict [port input-port?] [α real? 1.0])
         pict?]{
  Loads an SVG document from @racket[port] and returns a pict
  object scaled by @racket[α] with the SVG document rendered in it.

  Raises an @racket[exn:fail] exception when the SVG document
  fails to load.
}

@defproc[(svg-file->pict [file path-string?] [α real? 1.0])
         pict?]{
  Like @racket[svg-port->pict], but takes a path string argument
  instead of an input port.
}

@defproc[(load-svg-bitmap [port input-port?] [α real? 1.0])
         (is-a?/c bitmap%)]{
  Like @racket[svg-port->pict], but renders straight to bitmap.
}

@defproc[(load-svg-from-file [file path-string?] [α real? 1.0])
         (is-a?/c bitmap%)]{
  Like @racket[load-svg-bitmap], but takes a path string argument
  instead of an input port.
}

