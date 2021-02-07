; ------------------------------------
; vars
; ------------------------------------

(local g-width 256)
(local g-height 240)

(local font (love.graphics.newFont "fonts/atari-st.ttf" 8))
(local font-big (love.graphics.newFont "fonts/atari-st-8x16.ttf" 14))


; ------------------------------------
; colors
; ------------------------------------

(local colors {
	:black (hex.rgb "0d080d")
	:brown-dark (hex.rgb "4f2b24")
	:brown (hex.rgb "825b31")
	:brown-light (hex.rgb "c59154")
	:yellow-dark (hex.rgb "f0bd77")
	:yellow (hex.rgb "fbdf9b")
	:off-white (hex.rgb "fff9e4")
	:gray (hex.rgb "bebbb2")
	:green (hex.rgb "7bb24e")
	:blue-light (hex.rgb "74adbb")
	:blue (hex.rgb "4180a0")
	:blue-dark (hex.rgb "32535f")
	:purple (hex.rgb "2a2349")
	:red-dark (hex.rgb "7d3840")
	:red (hex.rgb "c16c5b")
	:red-light (hex.rgb "e89973")
	:white (hex.rgb "ffffff")
})

(fn clear-color []
	(love.graphics.setColor colors.white))

; ------------------------------------
; masks
; ------------------------------------

(local masks {
	:half (love.graphics.newImage "img/masks/half.png")
	:quarter (love.graphics.newImage "img/masks/quarter.png")
	:most (love.graphics.newImage "img/masks/most.png")})

(fn do-mask [mask callback]
	(love.graphics.stencil (fn []
		(love.graphics.setShader maskshader)
		(love.graphics.draw (. masks mask) 0 0)
		(. (love.graphics.setShader))) :replace 1)
	(love.graphics.setStencilTest :greater 0)
	(callback)
	(love.graphics.setStencilTest))

; ------------------------------------
; chrome label
; ------------------------------------

(fn label-shadows [input x y limit align]
	(love.graphics.setColor colors.black)
	(love.graphics.printf input (+ x 1) (+ y 1) limit align)
	(love.graphics.printf input (- x 1) (- y 1) limit align)
	(love.graphics.printf input (- x 1) (+ y 1) limit align)
	(love.graphics.printf input (+ x 1) (- y 1) limit align)
	(love.graphics.printf input x (- y 1) limit align)
	(love.graphics.printf input x (+ y 1) limit align)
	(love.graphics.printf input (- x 1) y limit align)
	(love.graphics.printf input (+ x 1) y limit align))

(fn label-overlay [input x y limit align big]
	(local accent-color :yellow)
	(local accent-offset (if big 8 4))
	(love.graphics.setScissor x (+ y accent-offset) g-width (+ y (* accent-offset 2)))
	(love.graphics.setColor (. colors accent-color))
	(do-mask :half (fn [] (love.graphics.printf input x y limit align)))
	(love.graphics.setScissor))


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; vars
	; -----------------------------------

	:grid 16

	:width g-width
	:height g-height

	:scale 2

	:colors colors
	:clear-color clear-color

	:save-table nil

	:fullscreen false
	:started false
	:paused false
	:game-over false
	:time-over false
	:game-finished false
	:game-over-clock 0

	:kill-bullet-clock 0
	:kill-bullets false
	:no-miss true

	:animate-interval 15

	:tau (* math.pi 2)
	:phi 1.61803398875

	:character-z 10

	:collision-debug false

	:tick-rate (/ 1 60)

	:hard-mode false

	:start-clock 0

	:in-boss false
	:enemy-count 0


	; -----------------------------------
	; chrome label
	; -----------------------------------

	:label (fn [input ?x y ?color ?align ?limit big overlay]
		(local color (if ?color ?color :off-white))
		(local x (if ?x ?x 0))
		(local align (if ?align ?align :left))
		(local limit (if ?limit ?limit g-width))
		(love.graphics.setFont (if big font-big font))
		(label-shadows input x y limit align)
		(love.graphics.setColor (. colors color))
		(love.graphics.printf input x y limit align)
		(when overlay (label-overlay input x y limit align big))
		(clear-color))


	; -----------------------------------
	; love helpers
	; -----------------------------------

	:set-color (fn [color]
		(love.graphics.setColor (. colors color)))

	:quad (fn [size image] (. (love.graphics.newQuad 0 0 size size image)))

	:update-quad (fn [quad x y size image]
		(quad:setViewport x y size size (image:getDimensions)))

	:img-width (fn [img] (. (img:getWidth)))
	:img-height (fn [img] (. (img:getHeight)))
	:line-width (fn [width] (love.graphics.setLineWidth width))
	:circle (fn [x y rad line] (love.graphics.circle (if line :line :fill) x y rad))


	; -----------------------------------
	; image helpers
	; -----------------------------------

	:images (fn [dir files]
		(local arr {})
		(each [i file (ipairs files)]
			(local img (love.graphics.newImage (.. "img/" dir "/" file ".png")))
			(img:setFilter :nearest :nearest)
			(tset arr file img))
		(. arr))

	:img (fn [image x y rotation]
		(local x-offset (/ (image:getWidth) 2))
		(local y-offset (/ (image:getHeight) 2))
		(love.graphics.draw image x y (if rotation rotation 0) 1 1 x-offset y-offset))


	; -----------------------------------
	; get item for spawning
	; -----------------------------------

	:get-item (fn [arr]
		(var j 1)
		(each [i item (ipairs arr)] (when (and (not item.active) (= j 1)) (set j i)))
		(. arr j))

	:get-item-index (fn [arr]
		(var index 1)
		(var j 1)
		(each [i item (ipairs arr)] (when (and (not item.active) (= j 1)) (set index i) (set j i)))
		(. {:index index :item (. arr j)}))


	; -----------------------------------
	; trig helpers
	; -----------------------------------

	:get-angle (fn [a b] (. (math.atan2 (- b.y a.y) (- b.x a.x))))

	:get-distance (fn [a b] (. (math.sqrt (+ (* (- a.x b.x) (- a.x b.x)) (* (- a.y b.y) (- a.y b.y))))))


	; -----------------------------------
	; restart
	; -----------------------------------

	:restart (fn []
		(love.event.quit :restart))


	; -----------------------------------
	; score
	; -----------------------------------

	:current-score 0
	:high-score-easy 0
	:high-score-hard 0
	:current-doggy 1

	:process-score (fn [input]
		(var score (tostring input))
		(for [i 1 (- 7 (length score))] (set score (.. "0" score )))
		(. score))


	; -----------------------------------
	; masks
	; -----------------------------------

	:mask do-mask

	:enemies [] ; FUCK


	; -----------------------------------
	; fullscreen
	; -----------------------------------

	:toggle-fullscreen (fn []
		(local is-fs (love.window.getFullscreen))
		(when is-fs
			(love.window.setFullscreen false)
			(maid64.resize (love.graphics.getWidth) (love.graphics.getHeight)))
		(when (not is-fs)
			(love.window.setFullscreen true)))


	})