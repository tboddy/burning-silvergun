local images, canMove = nil, nil
local speed, startSpeed, startLimit, startMod = 2, 2.25, 240, 0.05


--------------------------------------
-- moving
--------------------------------------

local checkBounds = function(vector)
	local mod = 3
	if vector.x < mod then vector.x = mod elseif vector.x > g.width - mod then vector.x = g.width - mod end
	if vector.y < mod then vector.y = mod elseif vector.y > g.height - mod then vector.y = g.height - mod end
end

local moveControls = function(entity)
	local angle = -1
	local setAngle = function(input) angle = math.pi * input end
	if controls.input:get('up') == 1 then setAngle(1.5)
	elseif controls.input:get('down') == 1 then setAngle(0.5) end
	if controls.input:get('left') == 1 then
		setAngle(1)
		if controls.input:get('up') == 1 then setAngle(1.25)
		elseif controls.input:get('down') == 1 then setAngle(0.75) end
	elseif controls.input:get('right') == 1 then
		setAngle(0)
		if controls.input:get('up') == 1 then setAngle(1.75)
		elseif controls.input:get('down') == 1 then setAngle(0.25) end
	end
	if angle > -1 then g.moveVector(entity.vector, angle, speed) end
	checkBounds(entity.vector)
end

local moveStart = function(entity)
	g.moveVector(entity.vector, 0, startSpeed)
	startSpeed = startSpeed - startMod
	if startSpeed <= 0 then canMove = true end
end

local updateMove = function(entity)
	if not g.paused then
		if canMove then moveControls(entity)
		else moveStart(entity) end
	end
end


return {


	------------------------------------
	-- load
	------------------------------------

	load = function(self)
		images = g.images('player', {'nitori', 'hitbox', 'bullet-double', 'bullet-single', 'bullet-homing'})
		entities:spawn(function(entity)
			entity.type = 'player'
			entity.vector = g.vector(-(images.nitori:getWidth() / 2), g.width / 2)
			entity.seen = true
			entity.collider = true
			entity.radius = 1
			entity.update = self.update
			entity.draw = self.draw
		end)
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(entity)
		updateMove(entity)
	end,

	draw = function(entity)
		g.img(images.nitori, {x = entity.vector.x, y = entity.vector.y + 4})
		g.img(images.hitbox, entity.vector)
	end


}