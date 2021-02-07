; ------------------------------------
; vars
; ------------------------------------

(local init-x (* g.grid 2.5))
(local init-y (/ g.height 2))

(var images nil)

(local bullets {})
(var can-shoot true)
(var shot-clock 0)

(local invincible-time (* 60 3))
(var invincible-clock 0)

(var shot-type 1)

(var shot-diff (/ g.phi 3))


; ------------------------------------
; player entity
; ------------------------------------

(local start-x (* g.grid -13.5))
(local entity {
	:x start-x
	:y init-y
	:collider (hc.circle start-x init-y 1)
	:combo 0
	:last-type false
	:lives 66
	:hit false})

; ------------------------------------
; move
; ------------------------------------

(fn check-move []
	(local mod 3)
	(if (< entity.x mod)
		(set entity.x mod)
		(> entity.x (- g.width mod))
		(set entity.x (- g.width mod)))
	(if (< entity.y mod)
		(set entity.y mod)
		(> entity.y (- g.height mod))
		(set entity.y (- g.height mod))))

(fn update-move []
	(local speed 2)
	(var angle -1)
	(fn set-angle [in] (set angle (* math.pi in)))
	(if (controls.up) (set-angle 1.5)
		(controls.down) (set-angle 0.5))
	(when (controls.left) (set-angle 1)
		(if (controls.up) (set-angle 1.25)
			(controls.down) (set-angle 0.75)))
	(when (controls.right) (set-angle 0)
		(if (controls.up) (set-angle 1.75)
			(controls.down) (set-angle 0.25)))
	(when (> angle -1)
		(set entity.x (+ entity.x (* (math.cos angle) speed)))
		(set entity.y (+ entity.y (* (math.sin angle) speed))))
	(check-move)
	(local collider-offset 0.5)
	(entity.collider:moveTo (- entity.x collider-offset) (- entity.y collider-offset)))

(var start-speed 2.5)
(fn update-start []
	(set entity.x (+ entity.x start-speed))
	(if (> start-speed 0)
		(set start-speed (- start-speed 0.0125))
		(set start-speed 0)))


; ------------------------------------
; spawn bullets
; ------------------------------------

(fn spawn-bullet [angle double]
	(local bullet (g.get-item bullets))
	(local offset 8)
	(set bullet.active true)
	(set bullet.angle angle) 
	(set bullet.x (+ entity.x (* (math.cos bullet.angle) offset)))
	(set bullet.y (+ entity.y (* (math.sin bullet.angle) offset)))
	(set bullet.speed 24)
	(set bullet.h-angle nil)
	(set bullet.clock 0)
	(when (= shot-type 1)
		(set bullet.homing false)
		(set bullet.damage 1)
		(set bullet.speed 24))
	(when (= shot-type 2)
		(set bullet.homing true)
		(set bullet.damage 0.25)
		(set bullet.speed 10))
	(when (= shot-type 3)
		(set bullet.homing false)
		(set bullet.damage 2)
		(set bullet.speed 10))
	(if bullet.homing
		(set bullet.collider (hc.circle bullet.x bullet.y 8))
		(set bullet.collider (hc.rectangle bullet.x bullet.y (if double (images.bullet-double:getWidth) (images.bullet-single:getWidth)) (images.bullet-single:getHeight)))
		)
	(bullet.collider:rotate (+ bullet.angle (/ math.pi 2)))
	(set bullet.double (if double true false)))

(fn spawn-bullets []
	(sound.play-sfx :playershot)
	(when (= shot-type 1) (spawn-bullet 0 true))
	(when (or (= shot-type 2) (= shot-type 3))
		(spawn-bullet (- 0 shot-diff) nil)
		(spawn-bullet shot-diff nil)))


; ------------------------------------
; update shot
; ------------------------------------

(fn update-shot []

	(when (and can-shoot (or (controls.shot-1) (controls.shot-2)))
		(when (controls.shot-1) (set shot-type 1))
		(when (controls.shot-2) (set shot-type 2))
		(set can-shoot false)
		(set shot-clock 0))
	(var interval nil)
	(when (= shot-type 1) (set interval 10))
	(when (= shot-type 2) (set interval 15))
	(when (= shot-type 3) (set interval 35))
	(local limit (* interval 1))
	(local max (* interval 1))
	(when (and (= can-shoot false) (= (% shot-clock interval) 0) (< shot-clock limit))
		(spawn-bullets))
	(set shot-clock (+ shot-clock 1))
	(when (>= shot-clock max) (set can-shoot true)))


; ------------------------------------
; update bullet
; ------------------------------------

(fn bullet-collision [bullet]
	(bullet.collider:moveTo bullet.x bullet.y)
	(each [item position (pairs (hc.collisions bullet.collider))]
		(when (and item.item-type (or (and (= item.item-type :enemy) item.item-killable) (= item.item-type :block)))
			(set bullet.collider.hit true)
			(set item.hit-damage bullet.damage)
			(set item.item-hit true)))
	(when bullet.collider.hit
		(class-explosion.spawn bullet.x bullet.y 3 false true)
		(hc.remove bullet.collider)
		(set bullet.collider false)
		(set bullet.active false)))

(fn homing-angle [bullet]
	(var angle bullet.angle)
	(var target nil)
	(when g.enemies ; FUCK
		(var enemy nil)
		(for [i 1 (length g.enemies)]
			(local enemy (. g.enemies i))
			(when (and enemy.visible enemy.active (> enemy.x 8) (> enemy.y 0) (< enemy.y g.height)) ; bunch of dumbass seatbelts
				(set enemy.flags.homing-distance (g.get-distance bullet enemy))
				(when (not target) (set target enemy))
				(when (and target (< enemy.flags.homing-distance target.flags.homing-distance))
					(set target enemy)))))
	(when target (set angle (g.get-angle bullet target)))
	(. angle))

(fn update-bullet [bullet]
	(set bullet.x (+ bullet.x (* (math.cos bullet.angle) bullet.speed)))
	(set bullet.y (+ bullet.y (* (math.sin bullet.angle) bullet.speed)))
	(local img (if bullet.double images.bullet-double (if bullet.homing images.bullet-homing images.bullet-single)))	
	(when bullet.homing
		(when (= (% bullet.clock 10) 5)
			(set bullet.h-angle (homing-angle bullet)))
		(when bullet.h-angle
			(var mod 0)
			(local diff 0.25)
			(when (< bullet.angle bullet.h-angle) (set mod diff))
			(when (> bullet.angle bullet.h-angle) (set mod (* diff -1)))
			(set bullet.angle (+ bullet.angle mod))))

	(when bullet.collider (bullet-collision bullet))
	(set bullet.clock (+ bullet.clock 1))
	(when (or (> bullet.x (+ g.width (g.img-width img))) (> bullet.y (+ g.height (g.img-height img))) (< bullet.y (* -1 (g.img-height img))))
		(when bullet.collider
			(hc.remove bullet.collider)
			(set bullet.collider false))
		(set bullet.active false)))

(fn update-bullets []
	(for [i 1 (length bullets)]
		(local bullet (. bullets i))
		(when bullet.active (update-bullet bullet))))


; ------------------------------------
; draw player
; ------------------------------------

(fn draw-player []
	(g.img images.nitori (- entity.x 1) (+ entity.y 3)))

(fn draw-hitbox []
	(g.img images.hitbox entity.x entity.y))


; ------------------------------------
; draw bullets
; ------------------------------------

(fn draw-bullet [bullet]
	(when bullet.homing
		(g.set-color :green)
		(g.mask :quarter (fn [] (g.circle bullet.x bullet.y 10)))
		(g.clear-color))
	(local img (if bullet.double images.bullet-double (if bullet.homing images.bullet-homing images.bullet-single)))
	(g.img img bullet.x bullet.y (+ bullet.angle (/ math.pi 2)))
	(when (and bullet.collider g.collision-debug) (bullet.collider:draw :line)))

(fn draw-bullets []
	(g.mask :half (fn [] 
		(for [i 1 (length bullets)]
			(local bullet (. bullets i))
			(when bullet.active (draw-bullet bullet))))))


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn []
		(for [i 1 128] (table.insert bullets {}))
		(set images (g.images "player" ["nitori" "hitbox" "bullet-double" "bullet-single" "bullet-homing"]))
		(set entity.collider.item-type :player))


	; -----------------------------------
	; get hit
	; -----------------------------------

	:hit (fn [color]
			(set invincible-clock invincible-time)
			(set entity.lives (- entity.lives 1))
			(class-explosion.spawn entity.x entity.y color true)
			(set entity.x init-x)
			(set entity.y init-y)
			(when (< entity.lives 0)
				(set g.game-over true)
				(sound.stop-bgm)
				(sound.play-sfx :gameover)
				))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
		(local limit (* 10 20))
		(when (and (not g.paused) (< g.start-clock limit)) (update-start))
		(when (and (not g.paused) (>= g.start-clock limit))
			(update-move)
			(update-shot))
		(when (not g.paused)
			(update-bullets)
			(when (> invincible-clock 0) (set invincible-clock (- invincible-clock 1))))
		(set player.entity entity)
		(set player.bullets bullets)
		(set player.invincible-clock invincible-clock))

	:draw (fn []
		(draw-bullets)
		(local interval g.animate-interval)
		(when (or (<= invincible-clock 0) (< (% invincible-clock (* interval 2)) interval))
			(draw-player))
		(draw-hitbox)
		(when (and entity.collider g.collision-debug)
			(g.set-color :red-light)
			(entity.collider:draw :fill))
		(g.clear-color))


	})











