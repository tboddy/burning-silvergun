; ------------------------------------
; vars
; ------------------------------------

(var images nil)
(local enemies {})

(local fade-interval 12)
(local fade-max (* fade-interval 4))


; ------------------------------------
; collision
; ------------------------------------

(fn kill-enemy [enemy]
	(set enemy.active false)
	(class-explosion.spawn enemy.x enemy.y 3)
	(set g.current-score (+ g.current-score 100))
	(var new-type nil)
	(when (string.find enemy.type :red) (set new-type :red))
	(when (string.find enemy.type :yellow) (set new-type :yellow))
	(when (string.find enemy.type :blue) (set new-type :blue))
	(when (= player.entity.combo 0) (set player.entity.combo 1))
	(when new-type
		(if (= new-type player.entity.last-type)
			(set player.entity.combo (+ player.entity.combo 1))
			(set player.entity.combo 0))
		(set player.entity.last-type new-type))

	(when (and (> player.entity.combo 0) (= (% player.entity.combo 3) 0))
		(var combo-score (* player.entity.combo 100))
		(local limit 9000)
		(when (> combo-score limit) (set combo-score limit))
		(set g.current-score (+ g.current-score combo-score))
		(class-indicator.spawn enemy.x enemy.y (.. "COMBO " combo-score)))

	(when enemy.collider
		(hc.remove enemy.collider)
		(set enemy.collider false)))


(. {


 ; -----------------------------------
 ; init
 ; -----------------------------------

	:enemies []

	:init (fn []
		(for [i 1 32] (table.insert enemies {}))
		(set images (g.images "enemies" ["robot-big-1" "robo-red" "robo-blue" "robo-yellow"])))


 ; -----------------------------------
 ; spawn
 ; -----------------------------------

	:spawn (fn [init-func update-func]
		(local enemy (g.get-item enemies))
		(set enemy.active true)
		(set enemy.health 1)
		(set enemy.visible false)
		(set enemy.clock 0)
		(set enemy.flags {})
		; (set enemy.quad (love.graphics.newQuad 0 0 enemy.size enemy.size images.suika))
		(init-func enemy)
		(set enemy.size 96)
		(set enemy.update-func update-func)
		(var enemy-image (. images enemy.type))
		(set enemy.collider (hc.rectangle enemy.x enemy.y (g.img-width enemy-image) (g.img-height enemy-image)))
		(when enemy.collider
			(set enemy.collider.item-type :enemy)
			(set enemy.collider.item-killable false)))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update-entities (fn []
		(set class-enemy.enemies enemies)
		(set g.enemies enemies)) ; FUCK!

	:update (fn [enemy]
		(enemy.update-func enemy)
		(when (and enemy.speed enemy.angle)
			(set enemy.x (+ enemy.x (* (math.cos enemy.angle) enemy.speed)))
			(set enemy.y (+ enemy.y (* (math.sin enemy.angle) enemy.speed))))
		(when enemy.visible
			(when enemy.collider
				(when (>= enemy.clock fade-max) (set enemy.collider.item-killable true))
				(enemy.collider:moveTo enemy.x enemy.y)
				(when enemy.collider.item-hit
					(set enemy.collider.item-hit false)
					(set enemy.health (- enemy.health enemy.collider.hit-damage))
					(when (<= enemy.health 0) (kill-enemy enemy))))
			(set enemy.clock (+ enemy.clock 1)))
		(when (< enemy.x (+ g.width (/ enemy.size 2)))
			(set enemy.visible true))
		(when (< enemy.x (- 0 (/ enemy.size 2)))
			(set enemy.active false)
			(when enemy.collider
				(hc.remove enemy.collider)
				(set enemy.collider false))))

	:draw (fn [enemy]
		(when (< enemy.clock (* fade-interval 2)) (g.mask :quarter (fn [] (g.img (. images enemy.type) enemy.x enemy.y))))
		(when (and (>= enemy.clock (* fade-interval 2)) (< enemy.clock (* fade-interval 3))) (g.mask :half (fn [] (g.img (. images enemy.type) enemy.x enemy.y))))
		(when (and (>= enemy.clock (* fade-interval 3)) (< enemy.clock (* fade-interval 4))) (g.mask :most (fn [] (g.img (. images enemy.type) enemy.x enemy.y))))
		(when (>= enemy.clock (* fade-interval 4))	(g.img (. images enemy.type) enemy.x enemy.y)))
	

	})