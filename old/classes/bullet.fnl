; ------------------------------------
; vars
; ------------------------------------

(var images nil)
(var quad nil)

(local bullets {})
(local bullet-animate-interval 8)


; ------------------------------------
; spawn props
; ------------------------------------

(fn set-type [bullet x y width height]
	(set bullet.texture-base-x x)
	(set bullet.texture-x x)
	(set bullet.texture-y y)
	(set bullet.texture-width width)
	(set bullet.texture-height height))

(fn set-collider [bullet]
	(when (or (= bullet.type 1) (= bullet.type 6)) ; arrow
		(local dist 5.5)
		(var angle bullet.angle)
		(local x-a (+ bullet.x (* (math.cos angle) dist)))
		(local y-a (+ bullet.y (* (math.sin angle) dist)))
		(set angle (+ angle (/ g.tau 3)))
		(local x-b (+ bullet.x (* (math.cos angle) dist)))
		(local y-b (+ bullet.y (* (math.sin angle) dist)))
		(set angle (+ angle (/ g.tau 3)))
		(local x-c (+ bullet.x (* (math.cos angle) dist)))
		(local y-c (+ bullet.y (* (math.sin angle) dist)))
		(set bullet.collider (hc.polygon x-a y-a x-b y-b x-c y-c)))
	(when (or (= bullet.type 2) (= bullet.type 7)) ; big
		(set bullet.collider (hc.circle bullet.x bullet.y 7)))
	(when (or (= bullet.type 3) (= bullet.type 8)) ; bolt
		(set bullet.collider (hc.rectangle bullet.x bullet.y 5 11)))
	(when (or (= bullet.type 4) (= bullet.type 9)) ; pill
		(set bullet.collider (hc.rectangle bullet.x bullet.y 2 6)))
	(when (or (= bullet.type 5) (= bullet.type 10)) ; small
		(set bullet.collider (hc.circle bullet.x bullet.y 3))))

(fn animate [bullet]
	(local current (math.floor ( / (% bullet.clock (* bullet-animate-interval 4)) bullet-animate-interval)))
	(set bullet.texture-x (+ (* current bullet.texture-width) bullet.texture-base-x)))


; ------------------------------------
; collision w player
; ------------------------------------

(fn check-collision [bullet]
	(local distance (g.get-distance bullet player.entity))
	(when (or (< distance 20) bullet.collider)
		(when (not bullet.collider)	(set-collider bullet))
		(bullet.collider:moveTo bullet.x bullet.y)
		(when (and (not= bullet.type 1) (not= bullet.type 6)) (bullet.collider:setRotation (+ (/ math.pi 2 ) bullet.angle)))
		(each [item position (pairs (hc.collisions bullet.collider))]
			(when (and item.item-type (= item.item-type :player) (= player.invincible-clock 0))
				(local color (if (< bullet.type 6) 2 1))
				(player.hit color)
				(class-explosion.spawn bullet.x bullet.y color)
				(hc.remove bullet.collider)
				(set bullet.collider false)
				(set bullet.active false)))))


(. {


	; -----------------------------------
	; vars
	; -----------------------------------

	:bullets {}


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn []
		(for [i 1 640] (table.insert bullets {}))
		(set images (g.images "stage" ["bullets"]))
		(set quad (love.graphics.newQuad 0 0 1 1 images.bullets)))


	; -----------------------------------
	; spawn
	; -----------------------------------

	:spawn (fn [init-func update-func]
		(when (= 0 g.kill-bullet-clock)
			(local bullet (g.get-item bullets))
			(set bullet.active true)
			(set bullet.clock 0)
			(set bullet.grazed false)
			(set bullet.top false)
			(set bullet.visible true)
			(set bullet.flags {})
			(init-func bullet)
			(when (= bullet.type 1) (set-type bullet 0 0 16 14))
			(when (= bullet.type 2) (set-type bullet 0 14 16 16))
			(when (= bullet.type 3) (set-type bullet 0 30 20 6))
			(when (= bullet.type 4) (set-type bullet 0 36 12 4))
			(when (= bullet.type 5) (set-type bullet 0 40 8 8))
			(when (= bullet.type 6) (set-type bullet 64 0 16 14))
			(when (= bullet.type 7) (set-type bullet 64 14 16 16))
			(when (= bullet.type 8) (set-type bullet 80 30 20 6))
			(when (= bullet.type 9) (set-type bullet 48 36 12 4))
			(when (= bullet.type 10) (set-type bullet 32 40 8 8))
			(if update-func (set bullet.update-func update-func) (set bullet.update-func nil))))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update-entities (fn [] (set class-bullet.bullets bullets))

	:update (fn [bullet]
		(when bullet.update-func (bullet.update-func bullet))
		(animate bullet)
		(when (and bullet.angle bullet.speed)
			(set bullet.x (+ bullet.x (* (math.cos bullet.angle) bullet.speed)))
			(set bullet.y (+ bullet.y (* (math.sin bullet.angle) bullet.speed))))
		(when (not g.game-over) (check-collision bullet))
		(set bullet.clock (+ bullet.clock 1))
		(when (> g.kill-bullet-clock 0)
			(when bullet.visible (class-explosion.spawn bullet.x bullet.y (if (< bullet.type 6) 2 1) nil true))
			(set bullet.active false))
		(when (and bullet.visible (or (< bullet.x (* -1 bullet.texture-width)) (> bullet.x (+ g.width bullet.texture-width))
			(< bullet.y (* -1 bullet.texture-height)) (> bullet.y (+ g.height bullet.texture-height))))
			(set bullet.active false)
			(when bullet.collider
				(hc.remove bullet.collider)
				(set bullet.collider false))))

	:draw (fn [bullet]
		(local offset-x (/ bullet.texture-width 2))
		(local offset-y (/ bullet.texture-height 2))
		(quad:setViewport bullet.texture-x bullet.texture-y bullet.texture-width bullet.texture-height (images.bullets:getDimensions))
		(local rotation (if (or (= bullet.type 1) (= bullet.type 3) (= bullet.type 4) (= bullet.type 6) (= bullet.type 8) (= bullet.type 9)) bullet.angle 0))

		(love.graphics.draw images.bullets quad bullet.x bullet.y rotation 1 1 offset-x offset-y)
		(when (and bullet.collider g.collision-debug) (g.set-color :green) (bullet.collider:draw :fill))
		(g.clear-color)
		)


	})