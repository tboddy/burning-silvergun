playmat = require 'lib.playmat'

local images, bottomCamera, topCamera
local bgColor, fgColor = 'black', 'purple'
local cameraZoom, cameraRotation = 256, math.pi * .575
local bgPos, fgPos = g.vector(), g.vector()
local bgAngle, fgAngle = math.pi * 0.01, math.pi * 0.02
local bgSpeed, fgSpeed = 5, 10
local fadeY, bottomHeight = g.grid * 5, g.height / 4


return {


	--------------------------------------
	-- load
	--------------------------------------

	load = function()
		images = g.images('bg', {'bottom', 'top', 'fade', 'fade2'})
		images.bottom:setWrap('repeat', 'repeat')
		images.top:setWrap('repeat', 'repeat')
		bottomCamera = playmat.newCamera(g.width, g.height, 0, 0, cameraRotation, cameraZoom, 1, 1)
		topCamera = playmat.newCamera(g.width, g.height, 0, 0, cameraRotation, cameraZoom, 1, 1)
	end,


	--------------------------------------
	-- loop
	--------------------------------------

	update = function()
		if not g.paused then
			g.moveVector(bgPos, bgAngle, bgSpeed)
			g.moveVector(fgPos, fgAngle, fgSpeed)
		end
	end,

	draw = function()
		g:setColor(bgColor)
		love.graphics.rectangle('fill', 0, 0, g.width, g.height)
		g:setColor(fgColor)
		g.mask('half', function() playmat.drawPlane(bottomCamera, images.bottom, bgPos.x, bgPos.y, 1, 1, true) end)
		g.mask('quarter', function() playmat.drawPlane(topCamera, images.top, fgPos.x, fgPos.y, 1, 1, true) end)
		g:setColor(bgColor)
		love.graphics.rectangle('fill', 0, 0, g.width, fadeY)
		love.graphics.draw(images.fade, 0, fadeY)
		g:setColor(fgColor)
		love.graphics.draw(images.fade2, 0, g.height - images.fade2:getHeight() + g.grid * 5)
		g:resetColor()
	end


}