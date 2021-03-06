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
(var starting false)


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
	(g.label "THE ISOLATION CARAVAN" nil y nil :center nil nil true)
	(set y (+ y offset))
	(g.label "TOUHOU GAME JAM VOL.6" nil y nil :center nil nil true))
	; (love.graphics.draw images.ilya (- g.width (g.img-width images.ilya) 10) (- g.height (g.img-height images.ilya) 8)))

(fn draw-splash-2 []
	(local bee-x (- (/ g.width 2) (/ (g.img-width images.bee) 2)))
	(var y (* g.grid 3.25))
	(love.graphics.draw images.bee bee-x y)
	(set y (+ y (* 1.25 g.grid) (g.img-height images.bee)))
	(g.label "PROGRAMMING, DESIGN," nil y nil :center nil nil true)
	(set y (+ y offset))
	(g.label "ART, AND SOUND" nil y nil :center nil nil true)
	(set y (+ y offset))
	(g.label "2021 T.BODDY" nil y nil :center nil nil true))


; ------------------------------------
; main menu
; ------------------------------------

(local menu-items ["START EASY" "START HARD" "HOW TO" "FULLSCREEN" "EXIT"])
(var active-menu 1)
(var can-move false)
(var moving false)
(var choosing false)

(fn draw-title []
	(local x (+ 4 (- (/ g.width 2) (/ (g.img-width images.title) 2)))) ; wtf
	(local y (* g.grid 1.5))
	(g.set-color :black)
	(love.graphics.draw images.title-shadow x y)
	(g.set-color :yellow)
	(love.graphics.draw images.title x y)
	(g.set-color :off-white)
	(love.graphics.draw images.title-top x y)
	(g.clear-color))

(fn choose-menu-item []
	(when (or (= active-menu 1) (= active-menu 2))
		(set g.hard-mode (if (= active-menu 2) true false))
		(set clock -1)
		(sound.stop-bgm)
		(sound.play-sfx :start)
		(set starting true))
	(when (= active-menu 3)
		(sound.play-sfx :menuchange)
		(set scene 4))
	(when (= active-menu 4) (g.toggle-fullscreen))
	(when (= active-menu 5) (love.event.quit)))

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
	(when (and (or (controls.shot-1) (controls.shot-2)) (not choosing))
		(set choosing true)
		(choose-menu-item))
	(when (and (not (controls.shot-1)) (not (controls.shot-2))) (set choosing false)))

(var played-bgm false)
(fn update-menu []
	(when (not played-bgm)
		(set played-bgm true)
		(sound.play-bgm :start))
	(trigger-overlay fade-interval 3)
	(trigger-overlay (* fade-interval 2) 2)
	(trigger-overlay (* fade-interval 3) 1)
	(trigger-overlay (* fade-interval 4) 0)
	(when (>= clock (* fade-interval 5))
		(set can-move true)
		(update-menu-controls)))

(fn update-starting []
	(trigger-overlay fade-interval 1)
	(trigger-overlay (* fade-interval 2) 2)
	(trigger-overlay (* fade-interval 3) 3)
	(trigger-overlay (* fade-interval 4) 4)
	(when (>= clock (* fade-interval 5))
		(set g.started true)
		(g.init-game)))

(fn menu-arrow [x y]
		(local size 8)
		(love.graphics.polygon :fill x y (+ x size) (+ y (/ size 2)) x (+ y size)))




(fn draw-menu []
	(local is-fs (love.window.getFullscreen))
	(var y (- (* g.grid 8.75) 2))
	(for [i 1 (length menu-items)]
		(var label (. menu-items i))
		(when (and is-fs (= i 4))
			(set label "WINDOWED"))
		(g.label label nil y nil :center nil nil true)
		(when (and can-move (= i active-menu))
			(local x (* g.grid 4.25))
			(g.set-color :black)
			(menu-arrow (- x 1) y) ; fuck outta here lmao
			(menu-arrow (+ x 1) y)
			(menu-arrow x (- y 1))
			(menu-arrow x (+ y 1))
			(menu-arrow (- x 1) (- y 1))
			(menu-arrow (- x 1) (+ y 1))
			(menu-arrow (+ x 1) (- y 1))
			(menu-arrow (+ x 1) (+ y 1))
			(g.set-color :red)
			(menu-arrow x y))
		(set y (+ y offset)))
	)

(fn draw-scores []
	(var x 8)
	(var y (- g.height 16))
	(g.label "HI EASY" x (- y s-offset) nil nil nil nil true)
	(g.label (g.process-score g.high-score-easy) x y nil nil nil nil true)
	(set x (- g.width x))
	(g.label "HI HARD" nil (- y s-offset) nil :right x nil true)
	(g.label (g.process-score g.high-score-hard) nil y nil :right x nil true))


; ------------------------------------
; controls screen
; ------------------------------------

(local controls-limit-1 (- g.width (* g.grid 5.5)))
(local controls-limit-2 (- g.width (* g.grid 4)))
(local controls-limit-3 (- g.width (* g.grid 6)))
(local controls-limit-4 (- g.width (* g.grid 3.5)))
(local controls-limit-5 (- g.width (* g.grid 7.5)))
(local controls-limit-6 (- g.width (* g.grid 5)))
(local controls-labels [
	{:label "KEYBOARD" :margin 16 :big true}
	{:label "MOVE: ARROW KEYS"}
	{:label "SHOT 1: Z" :limit controls-limit-1}
	{:label "SHOT 2: X" :limit controls-limit-1}
	{:label "PAUSE: ESC" :limit controls-limit-2}
	{:label "FULLSCREEN: F" :limit controls-limit-5}
	{:label "RESTART: R" :limit controls-limit-3 :margin 12}
	{:label "GAMEPAD" :margin 16 :big true}
	{:label "MOVE: DPAD/LSTICK"}
	{:label "SHOT 1: A" :limit controls-limit-3}
	{:label "SHOT 2: B" :limit controls-limit-3}
	{:label "PAUSE: START" :limit controls-limit-4}
	{:label "RESTART: BACK" :limit controls-limit-6 :margin 14}
	{:label "ANY SHOT TO RETURN"}])

(fn draw-controls []
	(var y 20)
	(for [i 1 (length controls-labels)]
		(local row (. controls-labels i))
		(var limit (if row.limit row.limit g.width))
		(when (and (not= i 1) (not= i 8) (not= i (length controls-labels)))
			(set limit (+ limit (* g.grid 2)))
			(when (> i 8) (set limit (+ limit 8))))
		(g.label row.label nil y nil :center limit (if row.big true nil) true)
		(set y (+ y (if row.margin row.margin 0) s-offset))))

(fn update-controls []
	(when (and (or (controls.shot-1) (controls.shot-2)) (not choosing))
		(set choosing true)
		(sound.play-sfx :menuchange)
		(set scene 3))
	(when (and (not (controls.shot-1)) (not (controls.shot-2))) (set choosing false)))


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
		(when (= scene 3) (update-menu))
		(when (= scene 4) (update-controls))
		(when starting (update-starting))
		(set clock (+ clock 1)))

	:draw (fn []
		(g.set-color :black)
		(love.graphics.rectangle :fill 0 0 g.width g.height)
		(g.clear-color)
		(when (= scene 1) (draw-splash-1))
		(when (= scene 2) (draw-splash-2))
		(when (or (= scene 3) (= scene 4)) (love.graphics.draw images.bg 0 0))
		(when (= scene 3)
			(draw-title)
			(draw-menu)
			(draw-scores))
		(when (= scene 4) (draw-controls))
		(when (< 0 overlay-type) (draw-overlay)))


	})