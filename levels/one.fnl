; ------------------------------------
; vars
; ------------------------------------

(var clock 0)

(local boss-offset-top (/ g.height 4))
(local boss-offset-bottom (- g.height boss-offset-top))


; ------------------------------------
; bosses
; ------------------------------------


(fn boss-old []

	; opposing fans and rng puke
	(fn pattern-one [enemy]

		(fn spin []
			(fn spawn-bullets [alt]
				(var angle (if alt enemy.flags.bullet-angle-2 enemy.flags.bullet-angle-1))
				(local y (if alt boss-offset-bottom boss-offset-top))
				(local count (if alt 5 7))
				(class-explosion.spawn enemy.x y 2 false true)
				(for [i 1 count]
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y y)
						(set bullet.angle angle)
						(set bullet.speed 1)
						(set bullet.type 3)))
					(set angle (+ angle (/ g.tau count))))
				(set enemy.flags.bullet-angle-1 (+ enemy.flags.bullet-angle-1 enemy.flags.bullet-mod))
				(set enemy.flags.bullet-angle-2 (- enemy.flags.bullet-angle-2 enemy.flags.bullet-mod)))
		(when (= (% enemy.flags.bullet-clock 15) 0)
			(spawn-bullets)
			(spawn-bullets true)))

		(fn puke []
			(fn spawn-bullets []
				(for [i 1 32]
				(class-bullet.spawn (fn [bullet]
					(set bullet.x enemy.x)
					(set bullet.y enemy.y)
					(set bullet.top true)
					(set bullet.angle (* (math.random) g.tau))
					(set bullet.speed (+ 0.75 (* (math.random) 0.25)))
					(set bullet.type 9)))))
			(when (= (% enemy.flags.bullet-clock 45) 0)
				(spawn-bullets)))

		(spin)
		(puke))

	; star cascade
	(fn pattern-two [enemy]

		(fn puke []
			(fn spawn-bullets []
				(local count 25)
				(var angle enemy.bullet-angle-1)
				(for [i 1 count]
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y enemy.y)
						(set bullet.speed 0.75)
						(set bullet.type 9)
						(set bullet.top true)
						(set bullet.angle angle)))
					(set angle (+ angle (/ g.tau count))))
					(set enemy.bullet-angle-1 (+ enemy.bullet-angle-1 (/ g.phi 20))))
			(when (= enemy.flags.bullet-clock 0) (set enemy.bullet-angle-1 0))
			(when (= (% enemy.flags.bullet-clock 30) 0)
				(spawn-bullets)))

		(fn stars []
			(fn spawn-bullets [alt]
				(var angle (+ math.pi (* math.pi (math.random))))
				(local count 30)
				(local mod 0.25)
				(var diff (/ count 10))
				(when alt (set diff (/ diff 2)))
				(local angle-mod (* (/ g.tau count) (+ diff 1)))
				(for [i 1 count]
					(local limit (% i diff))
					(local max (% i (* diff 2)))
					(var b-speed (+ (* max mod) 1))
					(when (>= max diff)
						(set b-speed (- b-speed (* (- max diff) (* mod 2)))))
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y enemy.y)
						(set bullet.angle (+ angle angle-mod))
						(set bullet.speed (+ 0.25 (/ b-speed 4)))
						(set bullet.type 2)))
					(set angle (+ angle (/ g.tau count)))))
			(local interval 60)
			(when (= (% enemy.flags.bullet-clock interval) 0)
				(spawn-bullets (= (% enemy.flags.bullet-clock (* interval 2)) 0))))

		(puke)
		(stars))


	; circles and homing
	(fn pattern-four [enemy]

		(fn circle []
			(local mod (* g.phi 5))
			(fn spawn-bullets [alt]
				(local bullet-y (if alt boss-offset-top boss-offset-bottom))
				(class-explosion.spawn enemy.x bullet-y 2 nil true)
				(local count 20)
				(var angle (if alt enemy.flags.bullet-angle-1 enemy.flags.bullet-angle-2))
				(for [i 1 count]
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y bullet-y)
						(set bullet.type 4)
						(set bullet.speed 1.25)
						(set bullet.angle angle)))
					(set angle (+ angle (/ g.tau count))))
					(if alt
						(set enemy.flags.bullet-angle-1 (+ enemy.flags.bullet-angle-1 mod))
						(set enemy.flags.bullet-angle-2 (- enemy.flags.bullet-angle-2 mod))))
			(local interval 40)
			(when (= (% enemy.flags.bullet-clock interval) 0) (spawn-bullets))
			(when (= (% enemy.flags.bullet-clock interval) (/ interval 2)) (spawn-bullets true)))

		(fn homing []
			(fn spawn-bullets [alt]
				(var angle (if alt enemy.flags.bullet-angle-3 enemy.flags.bullet-angle-4))
				(local mod (/ math.pi 30))
				(local count 3)
				(set angle (- angle (* 2 mod)))
				(local bullet-y (if alt boss-offset-top boss-offset-bottom))
				(class-explosion.spawn enemy.x bullet-y 1 nil true)
				(for [i 1 count]
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y bullet-y)
						(set bullet.speed 1.75)
						(when (= i 2) (set bullet.speed (+ bullet.speed 0.1)))
						(set bullet.type 8)
						(set bullet.top true)
						(set bullet.angle angle)))
					(set angle (+ angle (* mod 2)))))
			(local interval 12)
			(local limit (* interval 8))
			(local max (* limit 2))
			(local offset (* interval 3))
			(when (and (= (% enemy.flags.bullet-clock interval) 0) (< (% enemy.flags.bullet-clock max) (- limit offset)))
				(when (= (% enemy.flags.bullet-clock max) 0)
					(set enemy.flags.bullet-angle-3 (g.get-angle {:x enemy.x :y boss-offset-top} player.entity)))
				(spawn-bullets true))
			(when (and (= (% enemy.flags.bullet-clock interval) 0) (and (>= (% enemy.flags.bullet-clock max) limit) (< (% enemy.flags.bullet-clock max) (- max offset))))
				(when (= (% enemy.flags.bullet-clock max) limit)
					(set enemy.flags.bullet-angle-4 (g.get-angle {:x enemy.x :y boss-offset-bottom} player.entity)))
				(spawn-bullets)))
		(circle)
		(homing))

	(class-enemy.spawn (fn [enemy]
		(set enemy.x (- g.width (* g.grid 1.5)))
		(set enemy.y (/ g.height 2))
		(set enemy.health 100)
		(set enemy.flags.bullet-clock 0)
		(set enemy.type :robot-big-1)
		(set enemy.speed 0)
		(set enemy.angle math.pi)
		(set enemy.flags.bullet-angle-1 0)
		(set enemy.flags.bullet-angle-2 math.pi)
		(set enemy.flags.bullet-mod (/ g.phi 15)))
		(fn [enemy]
			(pattern-four enemy)
			(set enemy.flags.bullet-clock (+ enemy.flags.bullet-clock 1)))))


; ------------------------------------
; enemies
; ------------------------------------

(fn wave-one []

	(fn spawn-bullets [enemy]
		(local count (if g.hard-mode 9 1))
		(var angle (g.get-angle enemy player.entity))
	 (sound.play-sfx :bullet1)
		(for [i 1 count]
			(class-bullet.spawn (fn [bullet]
				(set bullet.x enemy.x)
				(set bullet.y enemy.y)
				(set bullet.angle angle)
				(set bullet.speed 1)
				(set bullet.type 2)))
			(set angle (+ angle (/ g.tau count)))))

	(fn spawn-enemy [x y alt shooter]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 2)
			(set enemy.x (- (+ (* x 48) g.width) 16))
			(set enemy.y y)
			(set enemy.type :robo-red)
			(set enemy.angle math.pi)
			(when alt (set enemy.flags.alt true))
			(when shooter (set enemy.flags.shooter true))
			(set enemy.speed 1))
			(fn [enemy]
				(when (and enemy.flags.shooter (= enemy.clock 60))
					(spawn-bullets enemy))
				(when (and (>= enemy.clock 60) (< enemy.clock 80))
					(var mod 0.005)
					(set enemy.angle (- enemy.angle (if enemy.flags.alt (* -1 mod) mod)))))))

	(for [i 1 3]
		(spawn-enemy i (/ g.height 4) nil (= i 3))
		(spawn-enemy (+ i 2) (* 3 (/ g.height 4)) true (= i 3))
		(spawn-enemy (+ i 4) (/ g.height 4) nil (= i 3))))

(fn wave-two []

	(fn spawn-bullets [enemy alt]
		(local count (if g.hard-mode 18 9))
		(var angle (g.get-angle enemy player.entity))
		(when alt (set angle (+ angle (/ math.pi count))))
	 (sound.play-sfx :bullet2)
		(for [i 1 count]
			(class-bullet.spawn (fn [bullet]
				(set bullet.x enemy.x)
				(set bullet.y enemy.y)
				(set bullet.angle angle)
				(set bullet.speed (if alt 1.25 1))
				(set bullet.type (if alt 4 2))))
			(set angle (+ angle (/ g.tau count)))))

	(fn spawn-enemy [x y alt shooter opposite]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 2)
			(set enemy.x (- (+ (* x 48) g.width) 16))
			(set enemy.y y)
			(set enemy.type (if opposite :robo-yellow :robo-blue))
			(set enemy.health 2)
			(set enemy.angle math.pi)
			(when alt (set enemy.flags.alt true))
			(when shooter (set enemy.flags.shooter true))
			(set enemy.speed 1))
			(fn [enemy]
				(when (and enemy.flags.shooter (= enemy.clock 75))
					(spawn-bullets enemy)
					(when g.hard-mode (spawn-bullets enemy true)))
				(when (and (>= enemy.clock 60) (< enemy.clock 200))
					(var mod -0.0025)
					(set enemy.angle (- enemy.angle (if enemy.flags.alt (* -1 mod) mod)))))))

	(for [i 1 6]
		(local y (* g.grid 5.5))
		(spawn-enemy i (- g.height y) true (= i 3) (> i 3))
		(spawn-enemy (+ i 2) y nil (= i 3) (> i 3))))

(fn wave-three [t-alt]

	(fn spawn-enemy [x y shooter alt]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 2)
			(set enemy.x (- (+ (* x 48) g.width) 16))
			(set enemy.y y)
			(set enemy.type (if t-alt :robo-blue :robo-red))
			(set enemy.angle math.pi)
			(when shooter (set enemy.flags.shooter true))
			(set enemy.speed 0.75))
			(fn [enemy]
				(when (and enemy.flags.shooter (= enemy.clock 60))
					(local count 20)
					(local limit 6)
					(sound.play-sfx :bullet3)
					(var angle (- (g.get-angle enemy player.entity) (* (- (/ limit 2) 1) (/ g.tau count))))
					(for [i 1 count]
						(when (< i limit)
							(class-bullet.spawn (fn [bullet]
								(set bullet.x enemy.x)
								(set bullet.y enemy.y)
								(set bullet.angle angle)
								(set bullet.speed 1)
								(set bullet.type 3)))
							(set angle (+ angle (/ g.tau count)))))))))

	(fn spawn-enemies [alt]
		(var y-mod (* g.grid 2.25))
		(when alt (set y-mod (* -1 y-mod)))
		(for [i 1 1]
			(var y (/ g.height 2))
			(for [j 1 3]
				(var x (+ i (* -1 (/ j 8))))
				(when alt (set x (+ x 2)))
				(spawn-enemy x y (= j 2) (if alt true false))
				(set y (+ y y-mod)))))

	(spawn-enemies)
	(spawn-enemies true))

(fn wave-four []

	(local distance (* g.grid 5.5))
	(local c-x (+ g.width (* g.grid 6.5)))
	(local c-y (* g.grid 6.25))
	(local x-mod 0.45)
	(local y-mod 0.045)

	(fn ring []
		(var angle 0)
		(local count 9)
		(for [i 1 count]
			(class-enemy.spawn (fn [enemy]
				(set enemy.health 2)
				(set enemy.flags.c-x c-x)
				(set enemy.flags.c-y c-y)
				(set enemy.flags.c-angle angle)
				(set enemy.angle nil)
				(set enemy.speed nil)
				(set enemy.flags.push-x 0)
				(set enemy.flags.push-y 0)
				(set enemy.flags.distance distance)
				(set enemy.x (+ enemy.flags.c-x (* (math.cos enemy.flags.c-angle) enemy.flags.distance)))
				(set enemy.y (+ enemy.flags.c-y (* (math.sin enemy.flags.c-angle) enemy.flags.distance)))
				(set enemy.type (if (< i 4) :robo-blue (if (< i 7) :robo-red :robo-yellow))))
				(fn [enemy]
					(set enemy.flags.c-angle (- enemy.flags.c-angle 0.005))
					(set enemy.x (- (+ enemy.flags.c-x (* (math.cos enemy.flags.c-angle) enemy.flags.distance)) enemy.flags.push-x))
					(set enemy.y (+ (+ enemy.flags.c-y (* (math.sin enemy.flags.c-angle) enemy.flags.distance)) enemy.flags.push-y))
					(local angle math.pi)
					(local speed 10)
					(set enemy.flags.push-x (+ enemy.flags.push-x x-mod))
					(set enemy.flags.push-y (+ enemy.flags.push-y y-mod)))) ; lmao
			(set angle (+ angle (/ g.tau count)))))

	(fn center []
		(fn spawn-bullets [enemy alt]
			(local count 5)
			(var angle enemy.flags.bullet-angle)
			(sound.play-sfx :bullet1)
			(for [i 1 count]
				(class-bullet.spawn (fn [bullet]
					(set bullet.x enemy.x)
					(set bullet.y enemy.y)
					(set bullet.angle angle)
					(set bullet.speed 1)
					(set bullet.type 3)))
				(set angle (+ angle (/ g.tau count))))
			(set enemy.flags.bullet-angle (- enemy.flags.bullet-angle (* (if alt -1 1) (/ math.pi 20)))))
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 10)
			(set enemy.x c-x)
			(set enemy.y c-y)
			(set enemy.speed nil)
			(set enemy.angle nil)
			(set enemy.type :robo-red))
			(fn [enemy]
				(local interval 10)
				(local limit 50)
				(local max (* limit 3))
				(local start (* limit 2))
				(when (= (% enemy.clock max) 0)	(set enemy.flags.bullet-angle (g.get-angle enemy player.entity)))
				(when (and (> enemy.x (/ g.width 3)) (>= (% enemy.clock max) start) (= (% enemy.clock interval) 0))
					(spawn-bullets enemy (>= enemy.clock max)))
				(set enemy.x (- enemy.x x-mod))
				(set enemy.y (+ enemy.y y-mod)))))

	(ring)
	(center))

(fn boss-one []

	(local limit (* 60 2))
	(local max (* 60 3))
	(local s-interval 15)
	(local start (/ max 4))
	(local end max)

	(fn spawn-bullets-1 [enemy]
		(fn spawn-bullets [alt]
			(local count 4)
			(var angle (if alt (+ enemy.flags.bullet-angle-2 (/ math.pi count)) enemy.flags.bullet-angle-2))
			(class-explosion.spawn enemy.x boss-offset-top 1 nil true)
			(sound.play-sfx :bullet2)
			(for [i 1 count]
					(class-bullet.spawn (fn [bullet]
						(set bullet.x enemy.x)
						(set bullet.y boss-offset-top)
						(set bullet.type 9)
						(set bullet.top true)
						(set bullet.speed 1)
						(set bullet.angle angle)))
				(set angle (+ angle (/ g.tau count))))
			(set enemy.flags.bullet-angle-2 (+ enemy.flags.bullet-angle-2 (/ g.phi 15)))
			)
		(when (= (% enemy.flags.bullet-clock max) start) (set enemy.flags.bullet-angle-2 0))
		(when (and (= (% enemy.flags.bullet-clock s-interval) 0) (>= (% enemy.flags.bullet-clock max) start) (< (% enemy.flags.bullet-clock max) end))
			(if (< (% enemy.flags.bullet-clock (* 2 max)) max) (spawn-bullets (= (% enemy.flags.bullet-clock (* s-interval 2)) 0)))))

	(fn spawn-bullets-2 [enemy]
		(local interval 5)
		(local alt (> max (% enemy.flags.bullet-clock (* max 2))))
		(fn spawn-bullets []
			(var mod enemy.flags.bullet-mod-1)
			(when alt (set mod (* -1 mod)))
			(sound.play-sfx :bullet3)
			(class-bullet.spawn (fn [bullet]
				(set bullet.x enemy.x)
				(set bullet.y enemy.y)
				(set bullet.type 2)
				(set bullet.speed 0.75)
				(set bullet.angle enemy.flags.bullet-angle-1)))
			(set enemy.flags.bullet-angle-1 (+ enemy.flags.bullet-angle-1 mod))
			(set enemy.flags.bullet-mod-1 (- enemy.flags.bullet-mod-1 0.0005)))
		(when (= (% enemy.flags.bullet-clock max) 0)
			(set enemy.flags.bullet-mod-1 (/ g.phi 2))
			(set enemy.flags.bullet-angle-1 0))
		(when (and (= (% enemy.flags.bullet-clock interval) 0) (< (% enemy.flags.bullet-clock max) limit)) (spawn-bullets)))

	(fn spawn-bullets-3 [enemy]
		(fn spawn-bullets []
			(local count 3)
			(var angle enemy.flags.bullet-angle-2)
			(class-explosion.spawn enemy.x boss-offset-bottom 1 nil true)
			(sound.play-sfx :bullet2)
			(for [i 1 count]
				(class-bullet.spawn (fn [bullet]
					(set bullet.x enemy.x)
					(set bullet.y enemy.y)
					(set bullet.type 8)
					(set bullet.top true)
					(set bullet.speed 1)
					(set bullet.angle angle)))
				(set angle (+ angle (/ g.tau count))))
				(set enemy.flags.bullet-angle-2 (- enemy.flags.bullet-angle-2 (/ g.phi 6))))
		(when (= (% enemy.flags.bullet-clock max) start) (set enemy.flags.bullet-angle-2 0))
		(when (and (= (% enemy.flags.bullet-clock s-interval) 0) (>= (% enemy.flags.bullet-clock max) start) (< (% enemy.flags.bullet-clock max) end))
			(if (>= (% enemy.flags.bullet-clock (* 2 max)) max) (spawn-bullets))))

	(fn spawn-enemy [y type]
		(class-enemy.spawn (fn [enemy]
			(set enemy.x (+ g.width (* g.grid 1.5)))
			(set enemy.y y)
			(set enemy.health 15)
			(set enemy.flags.bullet-clock 0)
			(set enemy.type :robo-red)
			(set enemy.speed 1)
			(when (= type 2) (set enemy.speed 1.25))
			(set enemy.flags.type type)
			(set enemy.flags.bullet-clock 0)
			(set enemy.angle math.pi))
			(fn [enemy]
				(when enemy.visible

					(if (> enemy.speed 0)
						(set enemy.speed (- enemy.speed 0.01))
						(set enemy.speed 0)))
				(when (>= enemy.clock 60)
					(when (= enemy.flags.type 1) (spawn-bullets-1 enemy))
					(when (= enemy.flags.type 2) (spawn-bullets-2 enemy))
					(when (= enemy.flags.type 3) (spawn-bullets-3 enemy))
					(set enemy.flags.bullet-clock (+ enemy.flags.bullet-clock 1))))))
		(spawn-enemy (/ g.height 4) 1)
		(spawn-enemy (/ g.height 2) 2)
		(spawn-enemy (* (/ g.height 4) 3) 3)	)


(fn wave-five []

	(fn spawn-bullets [enemy alt]
		(local count 5)
		(var angle enemy.flags.bullet-angle)
		(when alt (set angle (+ angle (/ g.tau (* count 2)))))
		(for [i 1 count]
			(class-bullet.spawn (fn [bullet]
				(set bullet.x enemy.x)
				(set bullet.y enemy.y)
				(set bullet.angle angle)
				(set bullet.speed 1)
				(set bullet.type 3)))
			(set angle (+ angle (/ g.tau count))))
		(set enemy.flags.bullet-angle (- enemy.flags.bullet-angle (/ math.pi 30))))

	(fn spawn-enemy [x-offset y]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 5)
			(set enemy.x (+ g.width (* g.grid x-offset)))
			(set enemy.y y)
			(set enemy.speed 0.5)
			(set enemy.flags.bullet-angle 0)
			(set enemy.angle (g.get-angle enemy player.entity))
			(set enemy.type :robo-blue))
			(fn [enemy]
				(local interval 30)
				(when (and (>= enemy.clock 60) (< enemy.clock (* 60 4)) (= (% enemy.clock interval) 0))
					(spawn-bullets enemy (= (% enemy.clock (* interval 2)) interval))))))

	(spawn-enemy 1 (/ g.height 4))
	(spawn-enemy 4 (/ g.height 2))
	(spawn-enemy 8 (* (/ g.height 4) 3))

	)

(fn wave-six []

	(fn spawn-bullets [enemy]
		(local count 7)
		(var angle (* math.pi (math.random)))
		(for [i 1 count]
			(class-bullet.spawn (fn [bullet]
				(set bullet.x enemy.x)
				(set bullet.y enemy.y)
				(set bullet.angle angle)
				(set bullet.speed 0.75)
				(set bullet.type 2)))
			(set angle (+ angle (/ g.tau count)))))

	(fn spawn-enemy [x-offset y alt]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 2)
			(set enemy.x (+ (* g.grid 2) g.width (* (* g.grid 3) (- x-offset 1))))
			(set enemy.y y)
			(set enemy.speed 1)
			(set enemy.angle math.pi)
			(set enemy.flags.angle-mod 0.0025)
			(when alt (set enemy.flags.angle-mod (* -1 enemy.flags.angle-mod)))
			(set enemy.type (if alt :robo-yellow :robo-red)))
			(fn [enemy]
				(when (= enemy.clock (* 60 1.5)) (spawn-bullets enemy))
				(when (>= enemy.clock (* 60 1.5))
					(set enemy.angle (+ enemy.angle enemy.flags.angle-mod))))))

	(for [i 1 3]
		(spawn-enemy i (/ g.height 3))
		(spawn-enemy (+ i 2) (* (/ g.height 3) 2) true)
		(spawn-enemy (+ i 4) (/ g.height 3))
		(spawn-enemy (+ i 6) (* (/ g.height 3) 2) true)))

(fn wave-seven []
	(fn spawn-enemy [y]
		(class-enemy.spawn (fn [enemy]
			(set enemy.health 5)
			(set enemy.x (+ g.width (* g.grid 2)))
			(set enemy.y y)
			(set enemy.type :robo-blue)
			(set enemy.angle math.pi)
			(set enemy.speed 1)
			(set enemy.flags.angle-mod 0.0125))
			(fn [enemy]
				(when (>= enemy.clock 100)
					(set enemy.speed (- enemy.speed 0.005))
					(when (<= enemy.speed 0.67) (set enemy.speed 0.67))
					(set enemy.angle (- enemy.angle enemy.flags.angle-mod))
					(when (<= enemy.angle 0)
						(set enemy.angle 0))))))
	(spawn-enemy (/ g.height 4)))

(fn wave-eight [])

(fn boss-two [])


(fn wave-nine [])

(fn wave-ten [])

(fn wave-eleven [])

(fn wave-twelve [])

(fn boss-three [])


; ------------------------------------
; enemy order
; ------------------------------------

(var current-enemy-section 1)
(local enemy-sections [

	(fn []
		(var base 0)
		(set base (* 60 4.5))
		(when (= clock base) (wave-one))
		(when (= clock (+ base (* 60 4.75))) (wave-two))
		(set base (+ base (* 60 11.5)))
		(when (= clock base) (wave-three))
		(when (= clock (+ base (* 60 4))) (wave-three true))
		(set base (+ base (* 60 8.5)))
		(when (= clock base) (wave-four))
		(set base (+ base (* 60 10.5)))
		(when (= clock base) (boss-one))
		(when (= clock (+ base 60)) (set g.in-boss true)))

	(fn []
		(var base 0)
		(when (= clock base) (wave-seven)))
		; (set base (* 60 1.5))
		; (when (= clock base) (wave-six)))
	])

(fn update-enemies []
	(local func (. enemy-sections current-enemy-section))
	(func)
	(when g.in-boss
		(when (= g.enemy-count 0)
			(set g.in-boss false)
			(set clock -1)
			(if (<= (+ current-enemy-section 1) (length enemy-sections))
				(set current-enemy-section (+ current-enemy-section 1))
				(set g.game-finished true))))
	(when g.game-finished (set g.game-over true)))


; ------------------------------------
; blocks order
; ------------------------------------

(var block-layout [
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :X :x :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :X :x :X :x :_]
	[:- :+ :_ :_ := :- :- :- :- :- :x :X :x :X :<]
	[:_ :| :_ :_ :| :_ :_ :_ :_ :_ :o :x :X :o :_]
	[:_ :| :_ :_ :| :_ :_ :_ :_ :_ :o :o :o :o :_]
	[:X :x :X :o :X :x :_ :_ :_ :_ :o :o :o :o :_]
	[:x :X :o :o :o :X :x :_ :_ :_ :o :x :X :o :_]
	[:X :x :o :d :o :x :X :< :- :- :x :X :x :X :<]
	[:x :X :o :o :o :X :x :_ :_ :_ :X :x :X :x :_]
	[:X :x :X :o :X :x :_ :_ :_ :_ :_ :X :x :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:- :- :- :+ :_ :| :_ :_ :_ :_ :_ :_ :x :_ :_]
	[:_ :_ :_ :| :_ :| :_ :_ :_ :_ :_ :x :X :x :_]
	[:_ :_ :_ :| :_ :| :_ :_ :_ :_ :_ :X :x :X :<]
	[:_ :_ :o :o :o :o :o :_ :_ :_ :_ :o :X :o :_]
	[:_ :o :x :X :x :X :x :o :_ :_ :_ :o :x :o :<]
	[:_ :o :X :x :X :x :X :o :< :- :- :o :X :o :_]
	[:_ :o :x :X :x :X :x :o :_ :_ :_ :X :x :X :<]
	[:- :o :X :x :o :o :o :_ :_ :_ :_ :x :X :x :_]
	[:_ :o :x :X :o :_ :_ :_ :_ :_ :_ :_ :x :_ :_]
	[:_ :o :X :x :o :_ :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:_ :o :X :x :o :< :- :+ :_ := :- :- :/ :_ :_]
	[:_ :_ :o :o :_ :_ :_ :| :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :| :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :| :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :| :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :o :o :o :o :o :o :o :o :o :_ :_ :_]
	[:_ :_ :o :x :X :x :X :o :X :x :X :x :o :_ :_]
	[:- :- :o :X :x :X :o :o :o :X :x :X :o :< :-]
	[:_ :_ :o :x :X :x :o :d :o :x :X :x :o :_ :_]
	[:- :- :o :X :x :X :o :o :o :X :x :X :o :< :-]
	[:_ :_ :o :x :X :x :X :o :X :x :X :x :o :_ :_]
	[:_ :_ :_ :o :o :o :o :o :o :o :o :o :_ :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :| :_ :_ :_ :| :_ :_ :_ :_ :_]
	[:_ :_ :_ := :- :/ :_ :_ :_ :? :- :+ :_ :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :| :_ :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :| :_ :_ :_]
	[:_ :_ :x :X :_ :_ :_ :_ :_ :_ :_ :X :x :_ :_]
	[:_ :x :X :x :X :_ :_ :_ :_ :_ :X :x :X :x :_]
	[:_ :X :x :X :x :< :- :- :- :- :x :X :x :X :_]
	[:_ :x :X :x :X :_ :_ :_ :_ :_ :X :x :X :x :_]
	[:_ :o :x :X :o :_ :_ :_ :_ :_ :o :X :x :o :_]
	[:_ :o :o :o :o :< :- :- :- :- :o :o :o :o :_]
	[:_ :o :x :X :o :_ :_ :_ :_ :_ :o :X :x :o :_]
	[:_ :x :X :x :X :_ :_ :_ :_ :_ :X :x :X :x :_]
	[:_ :X :x :X :x :< :- :- :- :- :x :X :x :X :_]
	[:_ :x :X :x :X :_ :_ :_ :_ :_ :X :x :X :x :_]
	[:_ :_ :x :X :_ :_ :_ :_ :_ :_ :_ :X :x :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :| :_ :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :? :+ :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:_ :_ :_ :| :_ :_ :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:X :x :X :x :X :x :_ :_ :_ :_ :_ :_ :o :_ :_]
	[:x :X :x :X :x :X :x :_ :_ :_ :_ :o :x :o :_]
	[:o :o :o :o :o :o :o :< :- :- :- :o :X :o :<]
	[:o :o :o :d :o :o :o :_ :_ :_ :_ :o :x :o :_]
	[:o :o :o :o :o :o :o :< :- :- :- :o :X :o :<]
	[:x :X :x :X :x :X :x :_ :_ :_ :_ :o :x :o :_]
	[:X :x :X :x :X :x :_ :_ :_ :_ :_ :_ :o :_ :_]
	[:_ :_ :| :_ :_ :_ :_ :_ :_ :_ :_ :_ :| :_ :_]
	[:_ :_ :| :_ :_ :_ :_ :_ :_ :_ :_ :_ :? :- :-]
	[:_ :_ :| :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :| :_ :_ :_ :_ :_ :_ :o :x :o :_ :_ :_]
	[:_ :_ :| :_ :_ :_ :_ :_ :o :x :X :x :o :_ :_]
	[:_ :_ :? :- :- :- :- :- :o :X :x :X :o :< :-]
	[:_ :_ :_ :_ :_ :_ :_ :_ :o :x :X :x :o :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :o :x :o :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :| :_ :_ :_ :_]
	[:- :- :- :- :+ :_ :_ :_ :_ :_ :| :_ :_ :_ :_]
	[:_ :_ :_ :_ :| :_ :_ :_ :_ :_ :| :_ :_ :_ :_]
	[:_ :_ :_ :o :X :o :_ :_ :_ :_ :| :_ :_ :_ :_]
	[:_ :_ :o :X :x :X :o :_ :_ :_ :| :_ :_ :_ :_]
	[:- :- :o :x :X :x :o :< :- :- :/ :_ :_ :_ :_]
	[:_ :_ :o :X :x :X :o :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :o :X :o :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	[:_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_ :_]
	])

(local temp-layout [])
(for [i (length block-layout) 1 -1] (tset temp-layout (+ (length temp-layout) 1) (. block-layout i)))
(set block-layout temp-layout)
(var current-block-row 1)

(fn spawn-blocks [] ;move to stage
	(local row (. block-layout current-block-row))
	(when row
	(for [j 1 (length row)]
		(local tile (. row j))
		(when (not= tile :_)
			(class-block.spawn j 1 tile)))
	(set current-block-row (+ current-block-row 1))))


; ------------------------------------
; bgm intro logic
; ------------------------------------

(var bgm-started nil)

(fn update-bgm []
	(when (and bgm-started (not sound.playing-bgm)) (sound.play-bgm :stage-loop))
	(when (not bgm-started)
		(sound.play-bgm :stage-intro)
		(set bgm-started true)))



; ------------------------------------
; extern
; ------------------------------------

(. {

	:update (fn []
		(update-enemies)
		(when (and (> (length block-layout) 0) (= (% clock 32) 0)) (spawn-blocks))
		(when (not g.game-over) (update-bgm))
		(set clock (+ clock 1)))

	})