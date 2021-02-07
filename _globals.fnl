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

; (local colors-arcade [ ;woodblock
; 	(hex.rgb "2b2821")
; 	(hex.rgb "624c3c")
; 	(hex.rgb "d9ac8b")
; 	(hex.rgb "e3cfb4")
; 	(hex.rgb "243d5c")
; 	(hex.rgb "5d7275")
; 	(hex.rgb "5c8b93")
; 	(hex.rgb "b1a58d")
; 	(hex.rgb "b03a48")
; 	(hex.rgb "d4804d")
; 	(hex.rgb "e0c872")
; 	(hex.rgb "3e6958")
; 	])

; (local colors-arcade [ ;psygnosia
; 	(hex.rgb "000000")
; 	(hex.rgb "1b1e29")
; 	(hex.rgb "362747")
; 	(hex.rgb "443f41")
; 	(hex.rgb "52524c")
; 	(hex.rgb "64647c")
; 	(hex.rgb "736150")
; 	(hex.rgb "77785b")
; 	(hex.rgb "9ea4a7")
; 	(hex.rgb "cbe8f7")
; 	(hex.rgb "e08b79")
; 	(hex.rgb "a2324e")
; 	(hex.rgb "003308")
; 	(hex.rgb "084a3c")
; 	(hex.rgb "546a00")
; 	(hex.rgb "516cbf")
; 	])

; (local colors-arcade [ ;arcade standard
; 	(hex.rgb "f1f0ee")
; 	(hex.rgb "ff4d4d")
; 	(hex.rgb "9f1e31")
; 	(hex.rgb "ffc438")
; 	(hex.rgb "f06c00")
; 	(hex.rgb "f1c284")
; 	(hex.rgb "c97e4f")
; 	(hex.rgb "973f3f")
; 	(hex.rgb "57142e")
; 	(hex.rgb "72cb25")
; 	(hex.rgb "238531")
; 	(hex.rgb "0a4b4d")
; 	(hex.rgb "30c5ad")
; 	(hex.rgb "2f7e83")
; 	(hex.rgb "69deff")
; 	(hex.rgb "33a5ff")
; 	(hex.rgb "3259e2")
; 	(hex.rgb "28237b")
; 	(hex.rgb "c95cd1")
; 	(hex.rgb "6c349d")
; 	(hex.rgb "ffaabc")
; 	(hex.rgb "e55dac")
; 	(hex.rgb "17191b")
; 	(hex.rgb "96a5ab")
; 	(hex.rgb "586c79")
; 	(hex.rgb "2a3747")
; 	(hex.rgb "b9a588")
; 	(hex.rgb "7e6352")
; 	(hex.rgb "412f2f")])

(local colors-arcade [
	(hex.rgb :050403)
	(hex.rgb :221f31)
	(hex.rgb :543516)
	(hex.rgb :9b6e2d)
	(hex.rgb :e1b047)
	(hex.rgb :f5ee9b)
	(hex.rgb :fefefe)
	(hex.rgb :8be1e0)
	(hex.rgb :7cc264)
	(hex.rgb :678fcb)
	(hex.rgb :316f23)
	(hex.rgb :404a68)
	(hex.rgb :a14d3f)
	(hex.rgb :a568d4)
	(hex.rgb :9a93b7)
	(hex.rgb :ea9182)])

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
	:colors-arcade colors-arcade

	:fullscreen false
	:started true
	:game-over false
	:time-over false

	:animate-interval 15

	:tau (* math.pi 2)
	:phi 1.61803398875

	:character-z 10

	:collision-debug false

	:tick-rate (/ 1 60)

	:hard-mode false

	:start-clock 0


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

	:set-color (fn [color arcade]
		(if arcade
			(love.graphics.setColor (. colors-arcade color))
			(love.graphics.setColor (. colors color))))

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
	:high-score 0
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


	})