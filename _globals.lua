return {


	--------------------------------------
	-- window
	--------------------------------------

	scale = 3,
	width = 256,
	height = 240,


	--------------------------------------
	-- save data
	--------------------------------------

	saveTable = nil,


	--------------------------------------
	-- state stuff
	--------------------------------------

	tickRate = 1 / 60,
	gameOverClock = 0,
	started = true,

	toggleFullscreen = function()
		local isFullscreen = love.window.getFullscreen()
		if isFullscreen then
			love.window.setFullscreen(false)
			maid64.resize(love.graphics.getWidth(), love.graphics.getHeight())
		else love.window.setFullscreen(true) end
	end


}