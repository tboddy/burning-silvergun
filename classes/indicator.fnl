; ------------------------------------
; vars
; ------------------------------------

(local indicators {})


(. {


 ; -----------------------------------
 ; init
 ; -----------------------------------

 :indicators {}

 :init (fn []
  (for [i 1 64] (table.insert indicators {}))
  )


 ; -----------------------------------
 ; spawn
 ; -----------------------------------

 :spawn (fn [x y label]
  (local indicator (g.get-item indicators))
  (set indicator.active true)
  (set indicator.clock 0)
  (set indicator.x (math.floor x))
  (set indicator.y (math.floor y))
  (local x-limit (- g.width (* g.grid 2.5)))
  (when (> indicator.x x-limit)
   (set indicator.x x-limit))
  (set indicator.label label))


 ; -----------------------------------
 ; loop
 ; -----------------------------------

 :update-entities (fn []
  (set class-indicator.indicators indicators))

 :update (fn [indicator]
  (when (>= indicator.clock 120) (set indicator.active false))
  (when (= (% indicator.clock 3) 0) (set indicator.y (- indicator.y 1)))
  (set indicator.clock (+ indicator.clock 1)))

 :draw (fn [indicator]
  (g.label indicator.label (- indicator.x (/ g.width 2)) indicator.y :yellow :center))

 })