; ------------------------------------
; vars
; ------------------------------------

(global hex (require "lib.hex"))
(global hc (require "lib.hc"))
(global maid64 (require "lib.maid"))
(global g (require "_globals"))
(global controls (require "controls"))
(global sound (require "sound"))
(global start (require "start"))
(global background (require "background"))
(global class-explosion (require "classes.explosion"))
(global class-indicator (require "classes.indicator"))
(global player (require "player"))
(global class-enemy (require "classes.enemy"))
(global stage (require "stage"))
(global chrome (require "chrome"))


; ------------------------------------
; init
; ------------------------------------

(tset g :init-game (fn [] ; lol fuck
	(background.init)
	(player.init)
	(stage.init)))

(fn love.load []
	(math.randomseed 1419)
	(love.window.setTitle "assfart")
	(love.window.setMode (* g.width g.scale) (* g.height g.scale) {:vsync false :x 480 :y 256 :minwidth g.width :minheight g.height :resizable true})
	(maid64.setup g.width g.height)
	(love.graphics.setLineStyle :rough)
	(love.graphics.setLineWidth 1)
	(controls.init)
	(sound.init)
	(if g.started (g.init-game) (start.init)))


; ------------------------------------
; started loop
; ------------------------------------

(fn update-game []
	(background.update)
	(when (not g.game-over) (player.update))
	(stage.update)
	(chrome.update))

(fn draw-game []
	(background.draw)
	(stage.draw-blocks)
	(when (not g.game-over) (player.draw))
	(stage.draw)
	(chrome.draw))


; ------------------------------------
; main loop
; ------------------------------------

(fn love.update [dt]
	(controls.update)
	(sound.update)
	(when (controls.reload) (g.restart))
	(if g.started (update-game dt) (start.update)))

(fn love.draw []
	(maid64.start)
	(if g.started (draw-game) (start.draw))
	(maid64.finish))

(fn love.resize [width height]
	(maid64.resize width height))

(fn love.run []
	(runhack g.tick-rate))