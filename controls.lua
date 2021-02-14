local baton = require 'lib.baton'


return {


	------------------------------------
	-- load
	------------------------------------

	load = function(self)
		local batonConfig = {
			controls = {
				left = {'key:left', 'axis:leftx-', 'button:dpleft'},
				right = {'key:right', 'axis:leftx+', 'button:dpright'},
				up = {'key:up', 'axis:lefty-', 'button:dpup'},
				down = {'key:down', 'axis:lefty+', 'button:dpdown'},
				shotOne = {'key:z', 'button:a'},
				shotTwo = {'key:x', 'button:b'},
				pause = {'key:escape', 'button:start'},
				reload = {'key:r', 'button:back'},
				fullscreen = {'key:f'}
			}
		}
		local joysticks = love.joystick.getJoysticks()
		if #joysticks then batonConfig.joystick = joysticks[1] end
		self.input = baton.new(batonConfig)
	end,


	------------------------------------
	-- state stuff
	------------------------------------

	updatePause = function(self)
		if self.input:get('pause') == 1 and not self.doingPause then
			self.doingPause = true
			if g.paused then
				g.paused = false
				-- sound:stopBgm()
			else
				g.paused = true
				-- sound:startBgm('stage-loop')
			end
		elseif self.input:get('pause') == 0 then self.doingPause = false end
	end,

	updateFullscreen = function(self)
		if self.input:get('fullscreen') == 1 and not self.doingFullscreen then g.toggleFullscreen()
		elseif self.input:get('fullscreen') == 0 then self.doingFullscreen = false end
	end,

	updateRestart = function(self)
		if g.gameOverClock >= 60 and (controls.shotOne() or controls.shotTwo()) then love.event.quit('restart') end
		if self.input:get('reload') == 1 then love.event.quit('restart') end
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(self)
		self.input:update()
		self:updateFullscreen()
		self:updateRestart()
		if not g.gameOver then self:updatePause() end
	end


}