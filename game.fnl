; ------------------------------------
; vars
; ------------------------------------

(global bitser (require "lib.bitser"))
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

(fn load-score []
	(local score-data (love.filesystem.read "score.lua"))
	(when score-data
		(set g.save-table (bitser.loads score-data))
		(when g.save-table.high-score-easy (set g.high-score-easy g.save-table.high-score-easy))
		(when g.save-table.high-score-hard (set g.high-score-hard g.save-table.high-score-hard))
		(when (and g.save-table.fullscreen (or (= g.save-table.fullscreen true) (= g.save-table.fullscreen :true))) (love.window.setFullscreen true))
		)
	(when (not score-data) (set g.save-table {}))
	)

(fn love.load []
	(math.randomseed 1419)
	(love.window.setTitle "assfart")
	(love.window.setMode (* g.width g.scale) (* g.height g.scale) {:vsync false :x 480 :y 256 :minwidth g.width :minheight g.height :resizable true})
	(maid64.setup g.width g.height)
	(love.graphics.setLineStyle :rough)
	(love.graphics.setLineWidth 1)
	(load-score)
	(controls.init)
	(sound.init)
	(if g.started (g.init-game) (start.init)))


; ------------------------------------
; started loop
; ------------------------------------

(var pausing false)
(fn update-pause []
	(when (and (controls.pause) (not pausing))
		(set pausing true)
		(set g.paused (if g.paused false true))
		(if g.paused (sound.stop-bgm) (sound.play-bgm :stage-loop)))
	(when (not (controls.pause)) (set pausing false)))

(var doing-fullscreen false)
(fn update-fullscreen []
	(when (and (controls.fullscreen) (not doing-fullscreen)) (g.toggle-fullscreen))
	(when (not (controls.fullscreen)) (set doing-fullscreen false)))

(fn update-game []
	(background.update)
	(when (not g.game-over)
		(player.update)
		(update-pause))
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
	(update-fullscreen)
	(if g.started (update-game dt) (start.update)))

(fn love.draw []
	(maid64.start)
	(if g.started (draw-game) (start.draw))
	(maid64.finish))

(fn love.resize [width height]
	(maid64.resize width height))

(fn love.run []
	(runhack g.tick-rate))