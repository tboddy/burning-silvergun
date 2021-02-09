; ------------------------------------
; vars
; ------------------------------------

(local blocks {})

(var speed 0.5)
(local size 16)
(local radius 4)

(var images nil)


; ------------------------------------
; collision
; ------------------------------------

(fn kill-block [block]
	(when block.destructable
			(when (= block.type :d)
				(local doggy-score (* g.current-doggy 900))
				(set g.current-score (+ g.current-score doggy-score))
				(set g.current-doggy (+ g.current-doggy 1))
			 (sound.play-sfx :bonus)
				(class-indicator.spawn (+ block.x (/ size 2)) (+ block.y (/ size 2)) (.. "BONUS " doggy-score)))
			(when (or (= block.type :x) (= block.type :d) (= block.type :X)) (set block.type :O))
			(when block.collider
				(class-explosion.spawn (+ block.x (/ size 2)) (+ block.y (/ size 2)) 3)
				(set g.current-score (+ g.current-score 10))
				(hc.remove block.collider)
				(set block.collider false))))


(. { 


	; -----------------------------------
	; vars
	; -----------------------------------

	:speed speed


	; -----------------------------------
	; init
	; -----------------------------------

	:blocks {}

	:init (fn []
		(for [i 1 256] (table.insert blocks {}))
		(set images (g.images "stage" ["point"])))


	; -----------------------------------
	; spawn
	; -----------------------------------

	:spawn (fn [column row type]
		(local block (g.get-item blocks))
		(set block.active true)
		(set block.y (* (- column 1) size))
		; (set block.x (- g.width (- 0 (* row size))))
		(set block.x (+ g.width (* g.grid 2)))
		(set block.x (- block.x (* column 2)))
		(set block.type type)
		(set block.health (if (= type :d) 5 0.1))
		(set block.destructable (if (or (= type :d) (= type :x) (= type :X)) true false))
		(set block.collider (if block.destructable (hc.rectangle block.x block.y size size) false))
		(when block.collider  (set block.collider.item-type :block)))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update-entities (fn [] (set class-block.blocks blocks))

	:update (fn [block]
		(set block.x (- block.x speed))
		(when block.collider
			(block.collider:moveTo (+ block.x (/ size 2)) (+ block.y (/ size 2)))
			(when block.collider.item-hit
				(set block.collider.item-hit false)
				(set block.health (- block.health 1))
				(when (<= block.health 0) (kill-block block))))
		(when (< block.x (* -2 g.grid))
			(set block.active false)
			(when block.collider
				(hc.remove block.collider)
				(set block.collider false))))

	:draw (fn [block level]
		(var x block.x)
		(var y block.y)

		(local platform-color :purple)
		(local shadow-color :black)
		(local point-color :blue-dark)
		(local point-color-alt :red-dark)

		(local floor-mod 8)
		(local floor-x (- x (/ floor-mod 2)))
		(local floor-y  (- y (/ floor-mod 2)))
		(local floor-width  (+ size floor-mod))
		(local floor-height  (+ size floor-mod))

		(local shadow-height 12)

		(local pipe-width 10)
		(local pipe-narrow 4)

		(fn floor-shadow []
			(g.set-color platform-color)
			(local shadow-y (+ floor-y shadow-height))
			(love.graphics.rectangle :fill floor-x shadow-y floor-width floor-height radius)
			(local offset (/ shadow-height 3))
			(g.set-color shadow-color)
			(love.graphics.setScissor floor-x (- (+ shadow-y floor-height) offset) floor-width offset)
			(g.mask :most (fn [] (love.graphics.rectangle :fill floor-x shadow-y floor-width floor-height radius)))
			(love.graphics.setScissor floor-x (- (+ shadow-y floor-height) offset offset) floor-width offset)
			(g.mask :half (fn [] (love.graphics.rectangle :fill floor-x shadow-y floor-width floor-height radius)))
			(love.graphics.setScissor floor-x (- (+ shadow-y floor-height) offset offset offset) floor-width offset)
			(g.mask :quarter (fn [] (love.graphics.rectangle :fill floor-x shadow-y floor-width floor-height radius)))
			(love.graphics.setScissor))

		(fn floor []
			(g.set-color platform-color)
			(love.graphics.rectangle :fill floor-x floor-y floor-width floor-height radius))

		(fn point [alt shadow]
			(when shadow (g.set-color shadow-color))
			(fn point-top []
				(g.set-color (if alt point-color-alt point-color))
				(love.graphics.rectangle :fill x y size (- size 1) (/ radius 2))
				(g.set-color (if alt point-color-alt point-color))
				(love.graphics.rectangle :fill x y size size (/ radius 2))
				(g.set-color platform-color)
				(g.mask :half (fn [] (love.graphics.rectangle :fill x (+ y 1) size (- size 1) (/ radius 2)))))
			(if shadow (g.mask :quarter (fn [] (love.graphics.rectangle :fill x (if shadow (+ y 2) y) size size (/ radius 2)))) (point-top)))

		(fn destroyed []
			(g.set-color shadow-color)
			(g.mask :quarter (fn [] (love.graphics.rectangle :fill x y size size (/ radius 2)))))

		(fn pipe [vertical end]
			(local offset (/ size 2))
			(var x-a x)
			(var y-a (+ y offset))
			(var x-b (+ x size))
			(var y-b (+ y offset))
			(when vertical
				(set x-a (+ x offset))
				(set y-a y)
				(set x-b (+ x offset))
				(set y-b (+ y size)))
			(when end
				(set y-a (+ y-a offset)))
			(local end-offset 2)
			(love.graphics.setLineWidth pipe-width)
			(g.set-color shadow-color)
			(love.graphics.line x-a (if end (+ y-a end-offset) y-a) x-b y-b)
			(g.set-color platform-color)
			(g.mask :quarter (fn [] (love.graphics.line x-a y-a x-b y-b)))
			(love.graphics.setLineWidth pipe-narrow)
			(g.mask :half (fn [] (love.graphics.line x-a y-a x-b y-b))))

		(fn pipe-corner [type]
			(love.graphics.setScissor x y size size)
			(var c-x x)
			(var c-y y)
			(when (= type 2) (set c-x (+ x size)))
			(when (= type 3) (set c-y (+ y size)))
			(when (= type 4)
				(set c-x (+ x size))
				(set c-y (+ y size)))
			(love.graphics.setLineWidth pipe-width)
			(g.set-color shadow-color)
			(love.graphics.circle :line c-x c-y (/ size 2))
			(g.set-color platform-color)
			(g.mask :quarter (fn [] (love.graphics.circle :line c-x c-y (/ size 2))))
			(love.graphics.setLineWidth pipe-narrow)
			(g.mask :half (fn [] (love.graphics.circle :line c-x c-y (/ size 2))))
			(love.graphics.setScissor))

		(fn doggy []
			(local doggy-color :brown)
			(g.set-color doggy-color)
			(love.graphics.rectangle :fill x y size (- size 1) (/ radius 2))
			(g.set-color doggy-color)
			(love.graphics.rectangle :fill x y size size (/ radius 2))
			(g.set-color platform-color)
			(g.mask :half (fn [] (love.graphics.rectangle :fill x (+ y 1) size (- size 1) (/ radius 2))))
			(love.graphics.draw images.point x (+ y 1))
			(g.set-color :brown-light)
			(love.graphics.draw images.point x y))

		(when (= level 1)
			(when (or (= block.type :o) (= block.type :x) (= block.type :X) (= block.type :O) (= block.type :d)) (floor-shadow))
			(when (= block.type :|) (pipe))
			(when (= block.type :-) (pipe true))
			(when (= block.type :<) (pipe true true))
			(when (= block.type :/) (pipe-corner 2))
			(when (= block.type :?) (pipe-corner 4))
			(when (= block.type :+) (pipe-corner 1))
			(when (= block.type :=) (pipe-corner 3)))

		(when (= level 2)
			(when (or (= block.type :o) (= block.type :x) (= block.type :X) (= block.type :O) (= block.type :d)) (floor)))

		(when (= level 3)
			(when (or (= block.type :x) (= block.type :X) (= block.type :d)) (point false true))
			(when (= block.type :O) (destroyed)))

		(when (= level 4)
			(when (= block.type :d) (doggy))
			(when (= block.type :x) (point))
			(when (= block.type :X) (point true)))

		(love.graphics.setLineWidth 1)
		(when (and block.collider g.collision-debug) (g.set-color :gray) (block.collider:draw :line))
		(g.clear-color))


})