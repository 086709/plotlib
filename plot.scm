#|lightweight plotting library for windows users of mit-scheme |#

(define (range str stp inc)
;makes a list of numbers from str to stp exclusive stp incremented by inc
  (cond ((< str stp) (cons str (range (+ str inc) stp inc)))
        (else '())))

(define (const-l fil len)
;makes a constant list of symbol fil len times
  (cond ((> len 0) (cons fil (const-l fil (- len 1))))
        (else '())))

(define (draw-vector device color cords)
;prints a vector at start cords of size vector components, the input
;'(0 0 .5 .5) will make a vector (.5 .5) on screen with the tail at (0 0)
  (define x0 (car cords)) (define y0 (cadr cords)) (define x1 (caddr cords)) (define y1 (cadddr cords)) (define off .007)
  (graphics-operation device 'set-foreground-color color)
  (graphics-set-line-style device 0)
  (graphics-draw-line device x0 y0 (+ x0 x1) (+ y0 y1))
  (graphics-operation device 'fill-polygon (vector (+ (+ x0 x1) off) (+ (+ y0 y1) off)
						                                       (+ (+ x0 x1) off) (- (+ y0 y1) off)
						                                       (- (+ x0 x1) off) (- (+ y0 y1) off)
                                                   (- (+ x0 x1) off) (+ (+ y0 y1) off))))

(define (draw-vector-list device color cords)
;prints a list of vectors on screen
  (map (lambda (lst)
       	 (draw-vector device color lst))
       cords))

(define (pair-zip pair1 pair2)
;takes two lists of pars, makes list of lists of pair items
;pair1 '((1 2))' pair2 '((3 5))' -> '((1 2 3 5))'
  (cond ((not (eq? pair1 '())) (cons (list (car (car pair1)) (cadr (car pair1)) (car (car pair2)) (cadr (car pair2)))
                                     (pair-zip (cdr pair1) (cdr pair2))))
        (else '())))

(define (coord-grid-cart device color xmax xmin ymax ymin)
;not fully implemented
;currently makes unlabled cordinate grid thats 20 by 20 cells
  (graphics-operation device 'set-foreground-color color)
  (graphics-set-line-style device 2)
  (map (lambda (lst)
      	 (graphics-draw-line device (car lst) (cadr lst) (caddr lst) (cadddr lst)))
       (pair-zip (zip (const-l -1 20)
            		      (range -1 1 .1))
            		 (zip (const-l 1 20)
      	 	            (range -1 1 .1))))
  (map (lambda (lst)
      	 (graphics-draw-line device (car lst) (cadr lst) (caddr lst) (cadddr lst)))
       (pair-zip (zip (range -1 1 .1)
             		      (const-l -1 20))
              	 (zip (range -1 1 .1)
      		            (const-l 1 20))))
 (graphics-set-line-style device 1)
 (graphics-draw-line device -1 0 1 0)
 (graphics-draw-line device 0 -1 0 1))

(define (draw-line device color cords)
;draws a line of line-segments from the list cords
;cords is of the form '((x0 y0 x1 y1) (x1 y1 x2 y2) ... (xn-1 yn-1 xn yn)
;make an appropriate list from a list of plain cordinates '((x0 y0) (x1 y1)...)'
;with make-line-cords
  (graphics-operation device 'set-foreground-color color)
  (graphics-set-line-style device 0)
  (map (lambda (lst)
 	       (graphics-draw-line device (car lst) (cadr lst) (caddr lst) (cadddr lst)))
       cords))

(define (make-line-cords point-lst)
;makes coord lists from point lists for drawint line-segments
;transforms list '((x0 y0) (x1 y1) ... (xn yn)) ->
;                '((x0 y0 x1 y1) (x1 y1 x2 y2) ... (xn-1 yn-1 xn yn))'
  (cond ((not (eq? (cdr point-lst) '())) (cond ((not (eq? (cdr point-lst) '())) (cons (list (car (car point-lst)) (cadr (car point-lst)) (car (cadr point-lst)) (cadr (cadr point-lst)))
                                               	                                      (make-line-cords (cdr point-lst))))
        	                                     (else '())))
        (else '())))

(define (plot-fucnt device color fun range)
;plots a functin with line segments
;use for functs that can tolerate lower fidelity or when it is infeasable
;to plot enough points for function to be visible
  (draw-line device color (make-line-cords (zip range (map fun range)))))

(define (plot-funct2 device color func range)
;plots a function with dots
;lower performance, must use high fidelity list (points are spaced .001-.0001)
;makes prettier plots
  (graphics-operation device 'set-foreground-color color)
  (map (lambda (lst)
  	     (graphics-draw-point device (car lst) (cadr lst)))
       (zip range (map func range))))

(define (clear device color)
    (graphics-operation device 'set-foreground-color color)
    (graphics-operation device  'fill-polygon #(1 1 1 -1 -1 -1 -1 1)))

(define (plot-point-list device color points)
  (graphics-operation device 'set-foreground-color color)
  (map (lambda (lst)
      	 (graphics-draw-point device (car lst) (cadr lst)))
       points))

(define (scale-point lst xfact yfact)
  (list (* xfact (car lst)) (* yfact (cadr lst))))

(define (scale-point-list lst xfact yfact)
  (map (lambda (point)
         (scale-point point xfact yfact))
       lst))

(define (draw-seg-list device color lst)
  (graphics-operation device 'set-foreground-color color)
  (graphics-set-line-style device 0)
  (map (lambda (slst)
         (graphics-draw-line device (car slst) (cadr slst) (caddr slst) (cadddr slst)))
       lst))