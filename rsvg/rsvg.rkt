#lang racket

;; FFI bindings to the RSVG library

(require ffi/unsafe
         ffi/unsafe/define
         racket/draw
         pict
         racket/class
         racket/draw/private/local ;; needed for in-cairo-context
         racket/draw/unsafe/cairo
         (rename-in racket/contract
                    [-> c:->]
                    [->* c:->*]))

(provide (contract-out
          [load-svg-bitmap
           (c:->* (input-port?) (real?) (is-a?/c bitmap%))]
          [load-svg-from-file
           (c:->* (path-string?) (real?) (is-a?/c bitmap%))]
          [svg-port->pict
           (c:->* (input-port?) (real?) pict?)]
          [svg-file->pict
           (c:->* (path-string?) (real?) pict?)]))

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
        (error : _pointer  = (make-GError 0 0 ""))
        ->
        (handle : _RsvgHandle/null)
        ->
        (values handle (ptr-ref error _GError-pointer/null))))

;; render the handle to the given cairo_t context
(define-rsvg rsvg_handle_render_cairo
  (_fun _RsvgHandle _pointer -> _bool))

;; free the given handle
(define-rsvg rsvg_handle_free (_fun _RsvgHandle -> _void))

;; High-level API

(define (svg-bytes->pict input-bytes [α 1.0])
  (define-values (svg-handle error-obj)
    (rsvg_handle_new_from_data input-bytes))
  (unless svg-handle
    (error (GError-message error-obj)))
  (define-values (width height _1 _2)
    (rsvg_handle_get_dimensions svg-handle))
  ;; ill-formed svgs can be weird
  (when (or (<= width 0) (<= height 0))
    (error "expected image with positive width and height"))

  ;; for use in the `dc`s below
  (define (cairo-proc target-cr)
    (cairo_save target-cr)
    (cairo_scale target-cr α α)
    (rsvg_handle_render_cairo svg-handle target-cr)
    (cairo_restore target-cr))

  (define pict
    (dc (λ (dc x y)
             (define tr (send dc get-transformation))
             (send dc translate x y)
             (cond [(is-a? dc record-dc%)
                    ;; this process will result in a non-scalable
                    ;; picture, but it will affect record-dc% contexts
                    ;; like in DrRacket
                    (define bitmap
                      (make-bitmap (exact-round (* α width))
                                   (exact-round (* α height))))
                    (define bdc (new bitmap-dc% [bitmap bitmap]))
                    (send bdc in-cairo-context cairo-proc)
                    (send dc draw-bitmap bitmap 0 0)]
                   [else
                    ;; the handler is needed in case the object
                    ;; doesn't actually have a `in-cairo-context`
                    ;; method, which is possible for non-built-in
                    ;; dc<%> objects
                    (with-handlers ([exn:fail:object? void])
                      (send dc in-cairo-context cairo-proc))])
             (send dc set-transformation tr))
          (* α width) (* α height)))
  (register-finalizer pict (λ _ (rsvg_handle_free svg-handle)))
  pict)


(define (svg-port->pict port [α 1.0])
  (svg-bytes->pict (port->bytes port) α))

(define (svg-file->pict file-path [α 1.0])
  (with-input-from-file file-path
    (λ () (svg-port->pict (current-input-port) α))))

;; directly to bitmap
(define (load-svg-bitmap port [α 1.0])
  (pict->bitmap (svg-port->pict port α)))

(define (load-svg-from-file file-path [α 1.0])
  (with-input-from-file file-path
    (λ () (load-svg-bitmap (current-input-port) α))))
