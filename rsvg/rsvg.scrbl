#lang scribble/manual

@title{RSVG: an FFI binding for loading SVG images}

@(require (for-label "rsvg.rkt"))

@defmodule[rsvg]

This library provides functions for loading SVG images as
Racket bitmap objects through an FFI binding to
@hyperlink["https://live.gnome.org/LibRsvg" "libRSVG"].
The resulting bitmap objects can then be freely manipulated with
the @racketmodname[racket/draw] or @racketmodname[slideshow/pict]
libraries.

@defproc[(load-svg-bitmap [port input-port?])
         (is-a?/c bitmap%)]{
  Loads an SVG document from @racket[port] and returns a bitmap
  object with the SVG document rendered in it.

  Raises an @racket[exn:fail] exception when the SVG document
  fails to load.
}

@defproc[(load-svg-from-file [file path-string?])
         (is-a?/c bitmap%)]{
  Like @racket[load-svg-bitmap], but takes a path string argument
  instead of an input port.
}

