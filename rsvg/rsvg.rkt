#lang racket
 
;; Run in DrRacket to see the SVG logo
 
(require ffi/unsafe
         ffi/unsafe/define
         racket/draw
         racket/draw/unsafe/cairo)
 
;; you'll probably need to adjust this line a bit
(define-ffi-definer define-rsvg (ffi-lib "librsvg-2" '("2" #f)))
 
(define-cpointer-type _RsvgHandle)
 
(define-cstruct _GError
  ([domain _int32] [code _int] [message _bytes]))
(define-cstruct _RsvgDimensionData
  ([width _int] [height _int] [em _double] [ex _double]))
 
(define-rsvg rsvg_set_default_dpi (_fun _double -> _void))
 
(define-rsvg rsvg_handle_get_dimensions
  (_fun _RsvgHandle 
        (dim : _RsvgDimensionData-pointer = (make-RsvgDimensionData 0 0 0.0 0.0))
        -> _void
        -> (values (RsvgDimensionData-width dim)
                   (RsvgDimensionData-height dim)
                   (RsvgDimensionData-em dim)
                   (RsvgDimensionData-ex dim))))
 
(define-rsvg rsvg_handle_new_from_data
  (_fun (input : _bytes)
        (input-length : _uint = (bytes-length input))
        (_ptr i _GError)
        ->
        _RsvgHandle))
 
(define-rsvg rsvg_handle_render_cairo
  (_fun _RsvgHandle _pointer -> _bool))
 
;; set this to whatever SVG file path you want
(define logo-bytes (file->bytes "plt-logo-red-shiny.svg"))
 
(define logo-handle (rsvg_handle_new_from_data logo-bytes (make-GError 0 0 #"")))
(define-values (width height _1 _2)
  (rsvg_handle_get_dimensions logo-handle))
 
(define bitmap (make-bitmap width height))
(define bitmap-handle (send bitmap get-handle))
 
(rsvg_handle_render_cairo logo-handle (cairo_create bitmap-handle))
 
;; this is just a bitmap%, so you can turn it into a slideshow pict
;; and manipulate it freely
bitmap