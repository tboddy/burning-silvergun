; ------------------------------------
; vars
; ------------------------------------

(var images nil)

; (var bg-color :black)
; (var fg-color :purple)

(var bg-color :black)
(var fg-color :purple)


; ------------------------------------
; sky
; ------------------------------------

(var bg-quad nil)
(var clouds-quad nil)
(var bg-angle (* math.pi 1.01))
(var clouds-angle (* math.pi 1.025))

(var bg-x 0)
(var bg-y 0)
(var clouds-x 0)
(var clouds-y 0)

(var sky-speed 1)
(var clouds-speed 2)

(fn init-sky []
 (images.bottom:setWrap :repeat :repeat)
 (images.top:setWrap :repeat :repeat)
 (set bg-quad (love.graphics.newQuad 0 0 g.width g.height images.bottom))
 (set clouds-quad (love.graphics.newQuad 0 0 g.width g.height images.top)))

(fn update-sky []
 (bg-quad:setViewport bg-x bg-y g.width g.height (images.bottom:getWidth) (images.bottom:getHeight))
 (clouds-quad:setViewport clouds-x clouds-y g.width g.height (images.top:getWidth) (images.top:getHeight))
 (set bg-x (- bg-x (* (math.cos bg-angle) sky-speed)))
 (set bg-y (- bg-y (* (math.sin bg-angle) sky-speed)))
 (set clouds-x (- clouds-x (* (math.cos clouds-angle) clouds-speed)))
 (set clouds-y (- clouds-y (* (math.sin clouds-angle) clouds-speed))))

(fn draw-sky []
 (g.set-color bg-color)
 (love.graphics.rectangle :fill 0 0 g.width g.height)
 (g.set-color fg-color)
 (g.mask :half (fn [] (love.graphics.draw images.bottom bg-quad 0 0)))
 (g.mask :quarter (fn [] (love.graphics.draw images.top clouds-quad 0 0)))
 (g.set-color bg-color)
 (local fade-y (* 0.5 g.grid))
 (love.graphics.rectangle :fill 0 0 g.width fade-y)
 (love.graphics.draw images.fade 0 fade-y)
 (g.set-color fg-color)
 (love.graphics.draw images.fade-2 0 (+ (* g.grid 4) (- g.height (images.fade-2:getHeight))))
 )


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn [] 
  (set images (g.images "bg" ["bottom" "top" "fade" "fade-2"]))
  (init-sky))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
  (when (not g.paused) (update-sky)))

	:draw (fn []
		(draw-sky)
		(g.clear-color))


	})


; ------------------------------------
; floor
; ------------------------------------

; (var floor-camera nil)
; (var floor-x 0)
; (var floor-speed 4)

; (fn init-floor []
;  (set floor-camera (playmat.newCamera g.width g.height 0 0 (* math.pi 1.5) 128 0.5 1)))

; (fn update-floor []
;  (set floor-x (- floor-x floor-speed)))

; (fn draw-floor []
;  (local y (* g.grid 9))
;  (love.graphics.setScissor 0 y g.width (- g.height y))
;  (g.set-color bg-color)
;  (love.graphics.rectangle :fill 0 0 g.width g.height)
;  (g.set-color fg-color)
;  (playmat.drawPlane floor-camera images.bottom floor-x 0 1 1 true)
;  (love.graphics.setScissor)
;  (g.set-color bg-color)
;  (g.mask :most (fn [] (love.graphics.draw images.fade 0 y))))