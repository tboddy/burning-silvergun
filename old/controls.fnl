; ------------------------------------
; vars
; ------------------------------------

(global baton (require :lib.baton))
(var input nil)

(var joystick nil)
(var hat nil)


; ------------------------------------
; utils
; ------------------------------------

(fn pressed [in] (. (love.keyboard.isDown in)))


; ------------------------------------
; extern
; ------------------------------------

(. {


	; -----------------------------------
	; init
	; -----------------------------------

	:init (fn []
		(local baton-obj {
			:controls {
				:left [:key:left :axis:leftx- :button:dpleft]
				:right [:key:right :axis:leftx+ :button:dpright]
				:up [:key:up :axis:lefty- :button:dpup]
				:down [:key:down :axis:lefty+ :button:dpdown]
				:shot-1 [:key:z :button:a]
				:shot-2 [:key:x :button:b]
				:pause [:key:escape :button:start]
				:reload [:key:r :button:back]
				:fullscreen [:key:f]
			}})
		(local joysticks (love.joystick.getJoysticks))
		(for [i 1 (length joysticks)] (if (= i 1) (set baton-obj.joystick (. joysticks i))))
		(set input (baton.new baton-obj)))


	; -----------------------------------
	; update
	; -----------------------------------

	:update (fn []
		(input:update))



	; -----------------------------------
	; state
	; -----------------------------------

	; LMAO DONT EVER DO THIS

	:reload (fn [] (. (= (input:get :reload) 1)))
	:pause (fn [] (. (= (input:get :pause) 1)))
	:fullscreen (fn [] (. (= (input:get :fullscreen) 1)))


	; -----------------------------------
	; movement
	; -----------------------------------

	:left (fn [] (. (= (input:get :left) 1)))
	:right (fn [] (. (= (input:get :right) 1)))
	:up (fn [] (. (= (input:get :up) 1)))
	:down (fn [] (. (= (input:get :down) 1)))


	; -----------------------------------
	; shoot
	; -----------------------------------

	:shot-1 (fn [] (. (= (input:get :shot-1) 1)))
	:shot-2 (fn [] (. (= (input:get :shot-2) 1)))


	})