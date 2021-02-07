; ------------------------------------
; vars
; ------------------------------------

(local x 6)
(local y 6)
(local offset 10)

(local time-limit (* 60 2))
(var time-left time-limit)

(local fade-interval 10)
(local start-max (* 60 4.5))


; ------------------------------------
; hud
; ------------------------------------

(fn draw-score []
	(g.label (g.process-score g.current-score) x y nil nil nil nil true))

(fn draw-time []
	(local time-label time-left)
	(local minutes (math.floor (/ time-left 60)))
	(var seconds (string.format "%.2f" (- time-left (* minutes 60))))
	(when (< (length seconds) 5) (set seconds (.. "0" seconds)))
	(g.label (.. minutes ":" (string.gsub seconds "%." ":")) nil y nil "right" (- g.width x) nil true))

(fn draw-lives []
	(g.label (.. "x" (if (> player.entity.lives 0) player.entity.lives 0)) nil (- g.height y 8) nil "right" (- g.width x) nil true))


; ------------------------------------
; overlays
; ------------------------------------

(fn draw-big-overlay [label]
	(var y (- (/ g.height 2) 8))
	(g.set-color :black)
	(g.mask :half (fn [] (love.graphics.rectangle :fill 0 0 g.width g.height)))
	(g.label label nil y nil "center" nil true true))

(fn draw-debug []
	(when player.entity (g.label (.. "COMBO " player.entity.combo) 6 (- g.height 8 5))))


; ------------------------------------
; start
; ------------------------------------

(fn draw-start []
	(g.label (.. (if g.hard-mode "HARD" "EASY") " MODE START!") nil (- (/ g.height 2) 8) nil :center nil true true)
	(g.set-color :black)
	(when (< g.start-clock fade-interval) (love.graphics.rectangle :fill 0 0 g.width g.height))
	(when (and (>= g.start-clock fade-interval) (< g.start-clock (* fade-interval 2))) (g.mask :most (fn [] (love.graphics.rectangle :fill 0 0 g.width g.height))))
	(when (and (>= g.start-clock (* fade-interval 2)) (< g.start-clock (* fade-interval 3))) (g.mask :half (fn [] (love.graphics.rectangle :fill 0 0 g.width g.height))))
	(when (and (>= g.start-clock (* fade-interval 3)) (< g.start-clock (* fade-interval 4))) (g.mask :quarter (fn [] (love.graphics.rectangle :fill 0 0 g.width g.height))))
	(g.clear-color)

	)


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
		(when (and (not g.paused) (not g.game-over) (not g.time-over)) (set time-left (- time-left (/ 1 60))))
		(when (<= time-left 0)
			(set time-left 0)
			(set g.game-over true)
			(set g.time-over true))
		(when (not g.paused) (set g.start-clock (+ g.start-clock 1))))

	:draw (fn []
		(when g.paused (draw-big-overlay "PAUSED"))
		(when (and g.game-over (not g.game-finished) (not g.time-over)) (draw-big-overlay "GAME OVER"))
		(when (and g.game-over g.time-over) (draw-big-overlay "TIME OVER"))
		(when (and (not g.paused) (< g.start-clock start-max)) (draw-start))
		(when player.entity (draw-lives))
		(draw-score)
		(draw-time)
		; (draw-debug)
		)


	})