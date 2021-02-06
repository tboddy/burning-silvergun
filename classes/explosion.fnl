; ------------------------------------
; vars
; ------------------------------------

(var images nil)
(var quad nil)

(local explosions {})
(local size 32)

(. {


 ; -----------------------------------
 ; vars
 ; -----------------------------------

 :explosions {}

 ; -----------------------------------
 ; init
 ; -----------------------------------

 :init (fn []
  (for [i 1 320] (table.insert explosions {}))
  (set images (g.images "stage" ["explosions"]))
  (set quad (love.graphics.newQuad 0 0 size size images.explosions)))


 ; -----------------------------------
 ; spawn
 ; -----------------------------------

 :spawn (fn [x y color big small transparent]
  (local explosion (g.get-item explosions))
  (set explosion.active true)
  (set explosion.clock 0)
  (set explosion.x x)
  (set explosion.y y)
  (set explosion.texture-x 0)
  (set explosion.texture-y 0)
  (set explosion.x-flip (if (< (math.random) 0.5) 1 -1))
  (set explosion.y-flip (if (< (math.random) 0.5) 1 -1))
  (set explosion.color color)
  (set explosion.transparent (if transparent true false))
  (when big (set explosion.x-flip (* explosion.x-flip 2)) (set explosion.y-flip (* explosion.y-flip 2)))
  (when small (set explosion.x-flip (* explosion.x-flip 0.5)) (set explosion.y-flip (* explosion.y-flip 0.5))))


 ; -----------------------------------
 ; loop
 ; -----------------------------------

 :update-entities (fn [] (set class-explosion.explosions explosions))

 :update (fn [explosion]
  (local interval 4)
  (var frame 0)
  (when (>= explosion.clock interval) (set frame 1))
  (when (>= explosion.clock (* interval 2)) (set frame 2))
  (when (>= explosion.clock (* interval 3)) (set frame 3))
  (when (>= explosion.clock (* interval 4)) (set frame 4))
  (when (>= explosion.clock (* interval 5)) (set explosion.active false))
  (set explosion.clock (+ explosion.clock 1))
  (set explosion.texture-x (* size frame))
  (set explosion.texture-y (* size (- explosion.color 1))))

 :draw (fn [explosion]
  (fn draw-explosion [] (love.graphics.draw images.explosions quad explosion.x explosion.y 0 explosion.x-flip explosion.y-flip (/ size 2) (/ size 2)))
  (quad:setViewport explosion.texture-x explosion.texture-y size size (images.explosions:getDimensions))
  (if explosion.transparent (g.mask :half draw-explosion) (draw-explosion)))


 })