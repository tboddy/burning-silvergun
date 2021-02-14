local sidePadding, labelHeight = 4, 8

local drawFrame = function()
	local bgColor, fgColor, border = 'black', 'purple', 8
	local height = g.height - border * 2
	g:setColor(fgColor)
	love.graphics.rectangle('fill', 0, 0, g.width, border)
	love.graphics.rectangle('fill', 0, g.height - border, g.width, border)
	love.graphics.rectangle('fill', 0, border, border, g.height - border * 2)
	love.graphics.rectangle('fill', g.width - border, border, border, height)
	love.graphics.rectangle('fill', g.width / 2 - border / 2, border, border, height)
	g:resetColor()
end


local drawDebug = function()
	local x = g.width - sidePadding
	local y = g.height - sidePadding - labelHeight
	g:label('player bullets: ' .. g.playerBulletCount, nil, y, 'right', x)
end


return {


	------------------------------------
	-- load
	------------------------------------

	load = function()

	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(self)

	end,

	draw = function()
		-- drawFrame()
		-- drawDebug()
	end


}