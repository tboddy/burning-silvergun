; ------------------------------------
; vars
; ------------------------------------

(var clock 0)
(var overlay-type 4)
(var scene 1)
(local offset 14)
(local s-offset 10)
(local fade-interval 10)

(var images nil)


; ------------------------------------
; overlay
; ------------------------------------

(fn trigger-overlay [trigger type] (when (>= clock trigger) (set overlay-type type)))

(fn draw-overlay []
	(local m-type (if (= overlay-type 1) :quarter (if (= overlay-type 2) :half :most)))
	(g.set-color :black)
	(if (= overlay-type 4)
		(love.graphics.rectangle :fill 0 0 g.width g.height)
	 (g.mask m-type (fn [] (love.graphics.rectangle :fill 0 0 g.width g.height))))
 (g.clear-color))


; ------------------------------------
; splash screen
; ------------------------------------

(fn update-splash [next]
	(local limit (* 60 4))
	(trigger-overlay fade-interval 3)
	(trigger-overlay (* fade-interval 2) 2)
	(trigger-overlay (* fade-interval 3) 1)
	(trigger-overlay (* fade-interval 4) 0)
	(trigger-overlay limit 1)
	(trigger-overlay (+ limit fade-interval) 2)
	(trigger-overlay (+ limit (* fade-interval 2)) 3)
	(trigger-overlay (+ limit (* fade-interval 3)) 4)
	(when (>= clock (+ limit (* fade-interval 6)))
		(set scene next)
		(set clock -1)))

(fn draw-splash-1 []
	(var y (- (/ g.height 2) offset))
	(g.label "THE ISOLATION CARAVAN" nil y nil :center)
	(set y (+ y offset))
	(g.label "TOUHOU GAME JAM VOL.6" nil y nil :center))
	; (love.graphics.draw images.ilya (- g.width (g.img-width images.ilya) 10) (- g.height (g.img-height images.ilya) 8)))

(fn draw-splash-2 []
	(local bee-x (- (/ g.width 2) (/ (g.img-width images.bee) 2)))
	(var y (* g.grid 3.25))
	(love.graphics.draw images.bee bee-x y)
	(set y (+ y (* 1.25 g.grid) (g.img-height images.bee)))
	(g.label "PROGRAMMING, DESIGN," nil y nil :center)
	(set y (+ y offset))
	(g.label "ART, AND SOUND" nil y nil :center)
	(set y (+ y offset))
	(g.label "2021 T.BODDY" nil y nil :center))


; ------------------------------------
; main menu
; ------------------------------------

(local menu-items ["START EASY" "START HARD" "EXIT"])
(var active-menu 1)
(var can-move false)
(var moving false)
(var choosing false)

(fn draw-title []
	(local x (+ 4 (- (/ g.width 2) (/ (g.img-width images.title) 2)))) ; wtf
	(local y (* g.grid 2))
	(g.set-color :black)
	(love.graphics.draw images.title-shadow x y)
	(g.set-color :yellow)
	(love.graphics.draw images.title x y)
	(g.set-color :off-white)
	(love.graphics.draw images.title-top x y)
	(g.clear-color))

(fn choose-menu-item []
	(when (= active-menu 1)
		(g.init-game)
		(set g.started true)
		))

(fn update-menu-controls []
	(when (and (not moving) (controls.up))
		(set active-menu (- active-menu 1))
		(set moving true))
	(when (and (not moving) (controls.down))
		(set active-menu (+ active-menu 1))
		(set moving true))
	(when (and (not (controls.up)) (not (controls.down))) (set moving false))
	(when (< active-menu 1) (set active-menu (length menu-items)))
	(when (> active-menu (length menu-items)) (set active-menu 1))
	(when (and (controls.shot-1) (not choosing))
		(set choosing true)
		(choose-menu-item))
	(when (not (controls.shot-1)) (set choosing false)))

(fn update-menu []
	(trigger-overlay fade-interval 3)
	(trigger-overlay (* fade-interval 2) 2)
	(trigger-overlay (* fade-interval 3) 1)
	(trigger-overlay (* fade-interval 4) 0)
	(when (>= clock (* fade-interval 5))
		(set can-move true)
		(update-menu-controls)))

(fn draw-menu []
	(var y (* g.grid 9.5))
	(for [i 1 (length menu-items)]
		(g.label (. menu-items i) nil y nil :center nil nil true)
		(when (and can-move (= i active-menu))
			(local x (* g.grid 4.25))
			(local size 8)
			(g.set-color :black)
			(love.graphics.polygon :fill x y (+ x size 1) (+ y (/ size 2) 1) x (+ y size))
			(g.set-color :red)
			(love.graphics.polygon :fill x y (+ x size) (+ y (/ size 2)) x (+ y size)))
		(set y (+ y offset)))
	)

(fn draw-scores []
	(var x 8)
	(var y (- g.height 16))
	(g.label "HI EASY" x (- y s-offset) nil nil nil nil true)
	(g.label (g.process-score g.high-score) x y nil nil nil nil true)
	(set x (- g.width x))
	(g.label "HI HARD" nil (- y s-offset) nil :right x nil true)
	(g.label (g.process-score g.high-score) nil y nil :right x nil true)
	)


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn []
  (set images (g.images "start" ["bee" "ilya" "bg" "title" "title-shadow" "title-top"])))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
		(when (= scene 1) (update-splash 2))
		(when (= scene 2) (update-splash 3))
		(when (>= scene 3) (update-menu))
		(set clock (+ clock 1)))

	:draw (fn []
		(g.set-color :black)
		(love.graphics.rectangle :fill 0 0 g.width g.height)
		(g.clear-color)
		(when (= scene 1) (draw-splash-1))
		(when (= scene 2) (draw-splash-2))
		(when (= scene 3)
			(love.graphics.draw images.bg 0 0)
			(draw-title)
			(draw-menu)
			(draw-scores))
		(when (< 0 overlay-type) (draw-overlay)))


	})