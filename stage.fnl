; ------------------------------------
; import
; ------------------------------------

(global class-bullet (require "classes.bullet"))
(global class-block (require "classes.block"))

(local level-one (require "levels.one"))


; -----------------------------------
; entity loop
; -----------------------------------

(fn update-enemies []
	(set g.enemy-count 0)
	(for [i 1 (length class-enemy.enemies)]
		(local enemy (. class-enemy.enemies i))
		(when enemy.active
			(set g.enemy-count (+ g.enemy-count 1))
			(class-enemy.update enemy))))

(fn draw-enemies []
	(for [i 1 (length class-enemy.enemies)]
		(local enemy (. class-enemy.enemies i))
		(when (and enemy.active enemy.visible) (class-enemy.draw enemy))))

(fn update-bullets []
	(for [i 1 (length class-bullet.bullets)]
		(local bullet (. class-bullet.bullets i))
		(when (and bullet.active bullet.x bullet.y) (class-bullet.update bullet))))

(fn draw-bullets []
	(for [i 1 (length class-bullet.bullets)]
		(local bullet (. class-bullet.bullets i))
		(when (and bullet.active bullet.visible bullet.x bullet.y (not bullet.top)) (class-bullet.draw bullet)))
	(for [i 1 (length class-bullet.bullets)]
		(local bullet (. class-bullet.bullets i))
		(when (and bullet.active bullet.visible bullet.x bullet.y bullet.top) (class-bullet.draw bullet))))

(fn update-blocks []
	(for [i 1 (length class-block.blocks)]
		(local block (. class-block.blocks i))
		(when (and block.active) (class-block.update block))))

(fn draw-blocks []
		(for [i 1 (length class-block.blocks)]
			(local block (. class-block.blocks i))
			(when block.active (class-block.draw block 1)))
		(for [i 1 (length class-block.blocks)]
			(local block (. class-block.blocks i))
			(when block.active (class-block.draw block 2)))
		(for [i 1 (length class-block.blocks)]
			(local block (. class-block.blocks i))
			(when block.active (class-block.draw block 3)))
		(for [i 1 (length class-block.blocks)]
			(local block (. class-block.blocks i))
			(when block.active (class-block.draw block 4)))
	(g.clear-color))

(fn update-explosions []
	(for [i 1 (length class-explosion.explosions)]
		(local explosion (. class-explosion.explosions i))
		(when (and explosion.active) (class-explosion.update explosion))))

(fn draw-explosions []
		(for [i 1 (length class-explosion.explosions)]
			(local explosion (. class-explosion.explosions i))
			(when explosion.active (class-explosion.draw explosion)))
	(g.clear-color))

(fn update-indicators []
	(for [i 1 (length class-indicator.indicators)]
		(local indicator (. class-indicator.indicators i))
		(when (and indicator.active) (class-indicator.update indicator))))

(fn draw-indicators []
		(for [i 1 (length class-indicator.indicators)]
			(local indicator (. class-indicator.indicators i))
			(when indicator.active (class-indicator.draw indicator))))


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn []
		(class-enemy.init)
		(class-bullet.init)
		(class-block.init)
		(class-explosion.init)
		(class-indicator.init))


	; -----------------------------------
	; loop
	; -----------------------------------

	:update (fn []
		(when (not g.paused)
			(class-enemy.update-entities)
			(class-bullet.update-entities)
			(class-block.update-entities)
			(class-explosion.update-entities)
			(class-indicator.update-entities)
			(update-enemies)
			(update-bullets)
			(update-blocks)
			(update-explosions)
			(update-indicators)
			(level-one.update)))

	:draw (fn []
		(draw-enemies)
		(draw-explosions)
		(draw-bullets)
		(draw-indicators))

	:draw-blocks draw-blocks


	})