#lang racket
 
;; FFI bindings to the RSVG library
 
(require ffi/unsafe
         ffi/unsafe/define
         racket/draw
         racket/draw/unsafe/cairo
         (rename-in racket/contract
                    [-> c:->]))

(provide (contract-out
          [load-svg-bitmap
           (c:-> input-port? (is-a?/c bitmap%))]
          [load-svg-from-file
           (c:-> path-string? (is-a?/c bitmap%))]))
 
(define-ffi-definer define-rsvg (ffi-lib "librsvg-2" '("2" #f)))
 
;; Data definitions
(define-cpointer-type _RsvgHandle)
 
(define-cstruct _GError
  ([domain _int32] [code _int] [message _string/latin-1]))
(define-cstruct _RsvgDimensionData
  ([width _int] [height _int] [em _double] [ex _double]))
 
;; FFI bindings

;; functions for setting the DPI
(define-rsvg rsvg_set_default_dpi (_fun _double -> _void))
(define-rsvg rsvg_set_default_dpi_x_y (_fun _double _double -> _void))
(define-rsvg rsvg_handle_set_dpi (_fun _RsvgHandle _double -> _void))
(define-rsvg rsvg_handle_set_dpi_x_y
  (_fun _RsvgHandle _double _double -> _void))

;; get the image dimensions for a handle
(define-rsvg rsvg_handle_get_dimensions
  (_fun _RsvgHandle 
        (dim : _RsvgDimensionData-pointer = (make-RsvgDimensionData 0 0 0.0 0.0))
        -> _void
        -> (values (RsvgDimensionData-width dim)
                   (RsvgDimensionData-height dim)
                   (RsvgDimensionData-em dim)
                   (RsvgDimensionData-ex dim))))

;; given an input array of bytes and its size, return a handle
;; (or NULL) and an error object
(define-rsvg rsvg_handle_new_from_data
  (_fun (input : _bytes)
        (input-length : _uint = (bytes-length input))
        (error : (_ptr o _GError-pointer))
        ->
        (handle : _RsvgHandle/null)
        ->
        (values handle error)))
 
;; render the handle to the given cairo_t context
(define-rsvg rsvg_handle_render_cairo
  (_fun _RsvgHandle _pointer -> _bool))

;; free the given handle
(define-rsvg rsvg_handle_free (_fun _RsvgHandle -> _void))

;; High-level API

(define (load-svg-bitmap port)
  (define input-bytes (port->bytes port))
  (define-values (svg-handle error-obj)
    (rsvg_handle_new_from_data input-bytes))
  (unless svg-handle
    (error (GError-message error-obj)))
  (define-values (width height _1 _2)
    (rsvg_handle_get_dimensions svg-handle))
  (define bitmap (make-bitmap width height))
  (define bitmap-handle (send bitmap get-handle))
  (rsvg_handle_render_cairo svg-handle (cairo_create bitmap-handle))
  (rsvg_handle_free svg-handle)
  bitmap)

(define (load-svg-from-file file-path)
  (with-input-from-file file-path
    (λ () (load-svg-bitmap (current-input-port)))))
