local images, bgQuad, cloudsQuad
local bgColor, fgColor = 'black', 'purple'
local bgAngle, cloudsAngle = math.pi * 0.01, math.pi * 0.02
local bgPos, cloudsPos = g.vector(), g.vector()
local bgSpeed, cloudsSpeed = 1, 2
local fadeY = 8


return {


	--------------------------------------
	-- load
	--------------------------------------

	load = function()
		images = g.images('bg', {'bottom', 'top', 'fade', 'fade2'})
		images.bottom:setWrap('repeat', 'repeat')
		images.top:setWrap('repeat', 'repeat')
		bgQuad = love.graphics.newQuad(0, 0, g.width, g.height, images.bottom)
		cloudsQuad = love.graphics.newQuad(0, 0, g.width, g.height, images.top)
	end,


	--------------------------------------
	-- loop
	--------------------------------------

	update = function()
		if not g.paused then
			g.moveVector(bgPos, bgAngle, bgSpeed)
			g.moveVector(cloudsPos	, cloudsAngle, cloudsSpeed)
			bgQuad:setViewport(bgPos.x, bgPos.y, g.width, g.height, images.bottom:getWidth(), images.bottom:getHeight())
			cloudsQuad:setViewport(cloudsPos.x, cloudsPos.y, g.width, g.height, images.top:getWidth(), images.top:getHeight())
		end
	end,

	draw = function()
		g:setColor(bgColor)
		love.graphics.rectangle('fill', 0, 0, g.width, g.height)
		g:setColor(fgColor)
		g.mask('half', function() love.graphics.draw(images.bottom, bgQuad, 0, 0) end)
		g.mask('quarter', function() love.graphics.draw(images.top, cloudsQuad, 0, 0) end)
		g:setColor(bgColor)
		love.graphics.rectangle('fill', 0, 0, g.width, fadeY)
		love.graphics.draw(images.fade, 0, fadeY)
		g:setColor(fgColor)
		love.graphics.draw(images.fade2, 0, g.height - images.fade2:getHeight() + g.grid * 3)
		g:resetColor()
	end


}