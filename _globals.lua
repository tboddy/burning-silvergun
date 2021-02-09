--------------------------------------
-- masks
--------------------------------------

local masks, maskShader = {
	half = love.graphics.newImage('img/masks/half.png'),
	quarter = love.graphics.newImage('img/masks/quarter.png'),
	most = love.graphics.newImage('img/masks/most.png')
}, love.graphics.newShader([[vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){ if(Texel(texture, texture_coords).rgb == vec3(0.0)) {discard;} return vec4(1.0); }]])



return {


	--------------------------------------
	-- window
	--------------------------------------

	scale = 3,
	width = 256,
	height = 240,
	grid = 16,


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
	collisionDebug = false,

	toggleFullscreen = function()
		local isFullscreen = love.window.getFullscreen()
		if isFullscreen then
			love.window.setFullscreen(false)
			maid64.resize(love.graphics.getWidth(), love.graphics.getHeight())
		else love.window.setFullscreen(true) end
	end,


	--------------------------------------
	-- colors
	--------------------------------------

	colors = {
		black = hex.rgb('0d080d'),
		brownDark = hex.rgb('4f2b24'),
		brown = hex.rgb('825b31'),
		brownLight = hex.rgb('c59154'),
		yellowDark = hex.rgb('f0bd77'),
		yellow = hex.rgb('fbdf9b'),
		offWhite = hex.rgb('fff9e4'),
		gray = hex.rgb('bebbb2'),
		green = hex.rgb('7bb24e'),
		blueLight = hex.rgb('74adbb'),
		blue = hex.rgb('4180a0'),
		blueDark = hex.rgb('32535f'),
		purple = hex.rgb('2a2349'),
		redDark = hex.rgb('7d3840'),
		red = hex.rgb('c16c5b'),
		redLight = hex.rgb('e89973'),
		white = hex.rgb('ffffff')
	},

	--------------------------------------
	-- helpers
	--------------------------------------

	images = function(dir, files)
		local arr = {}
		for i, file in ipairs(files) do
			local img = love.graphics.newImage('img/' .. dir .. '/' .. file .. '.png')
			img:setFilter('nearest', 'nearest')
			arr[file] = img
		end
		return arr
	end,

	img = function(image, pos)
		love.graphics.draw(image, pos.x, pos.y, 0, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
	end,

	vector = function(vX, vY)
		local x = 0 if vX then x = vX end
		local y = 0 if vY then y = vY end
		return {x = x, y = y}
	end,

	moveVector = function(vector, angle, speed)
		vector.x = vector.x + math.cos(angle) * speed
		vector.y = vector.y + math.sin(angle) * speed
		return vector
	end,

	setColor = function(self, color)
		love.graphics.setColor(self.colors[color])
	end,

	resetColor = function(self)
		love.graphics.setColor(self.colors.white)
	end,


	--------------------------------------
	-- masks
	--------------------------------------

	mask = function(mask, callback)
		love.graphics.stencil(function()
			love.graphics.setShader(maskShader)
			love.graphics.draw(masks[mask], 0, 0)
			return love.graphics.setShader()
		end, 'replace', 1)
		love.graphics.setStencilTest('greater', 0)
		callback()
		love.graphics.setStencilTest()
	end


}