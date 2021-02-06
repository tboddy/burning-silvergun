; ------------------------------------
; vars
; ------------------------------------

(local x 6)
(local y 6)
(local offset 10)

(local time-limit (* 60 2))
(var time-left time-limit)



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
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
		(set time-left (- time-left (/ 1 60)))
		(when (<= time-left 0)
			(set time-left 0)
			(set g.game-over true)
			(set g.time-over true)))

	:draw (fn []
		(draw-score)
		(draw-time)
		(when player.entity (draw-lives))
		; (draw-debug)
		(when (and g.game-over (not g.time-over)) (draw-big-overlay "GAME OVER"))
		(when (and g.game-over g.time-over) (draw-big-overlay "TIME OVER"))
		)


	})