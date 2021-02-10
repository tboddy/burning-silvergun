local images, canMove
local speed, startSpeed, startLimit, startMod = 2, 2.25, 240, 0.05

local shotClock, shotType, canShoot = 0, 1, true


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


--------------------------------------
-- shooting
--------------------------------------

local spawnBullets = function(entity)
	if controls.input:get('shotOne') == 1 then playerBullet:spawn(entity)
	else
		playerBullet:spawn(entity, true)
		playerBullet:spawn(entity, true, true)
	end
end

local updateShot = function(entity)
	if canShoot and (controls.input:get('shotOne') == 1 or controls.input:get('shotTwo') == 1) then
		shotType = 1 if controls.input:get('shotTwo') == 2 then shotType = 2 end
		canShoot = false
		shotClock = 0
	end
	local interval = 10 if controls.input:get('shotTwo') == 1 then interval = 15 end
	local limit = interval
	local max = interval
	if not canShoot and shotClock % interval == 0 and shotClock < limit then spawnBullets(entity) end
	shotClock = shotClock + 1
	if shotClock >= max then canShoot = true end
end


return {


	------------------------------------
	-- load
	------------------------------------

	load = function(self)
		images = g.images('player', {'nitori', 'hitbox'})
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
		if canMove then updateShot(entity) end
	end,

	draw = function(entity)
		g.img(images.nitori, {x = entity.vector.x, y = entity.vector.y + 4})
		g.img(images.hitbox, entity.vector)
	end


}