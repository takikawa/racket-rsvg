#lang racket

(require pict
         racket/runtime-path
         rsvg
         rackunit)

(define-runtime-path curly "curly.svg")
(define-runtime-path tests "tests.rkt")

(check-exn
  (λ (exn) (regexp-match? #rx"positive width and height"
                          (exn-message exn)))
  (λ () (bitmap (load-svg-from-file curly))))

(check-exn
  (λ (exn) (regexp-match? #rx"Error domain 1 code 4"
                          (exn-message exn)))
  (λ () (load-svg-from-file tests)))

