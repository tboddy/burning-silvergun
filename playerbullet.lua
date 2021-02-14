local images

return {

	------------------------------------
	-- load
	------------------------------------

	load = function()
		images = g.images('player', {'bulletdouble', 'bullethoming'})
	end,

	------------------------------------
	-- spawn
	------------------------------------

	spawn = function(self, playerEntity, homing, alt)
		sound:playSfx('playershot')
		local angle = 0
		local distance = 18
		if homing then
			local diff = g.phi / 3
			if alt then angle = angle - diff else angle = angle + diff end
		end
		local x = playerEntity.vector.x + math.cos(angle) * distance
		local y = playerEntity.vector.y + math.sin(angle) * distance
		entities:spawn(function(entity)
			entity.type = 'playerBullet'
			entity.vector = g.vector(x, y)
			entity.seen = true
			entity.collider = true
			entity.radius = 8
			entity.update = self.update
			entity.draw = self.draw
			entity.angle = angle
			entity.speed = images.bulletdouble:getWidth() + 4
			if homing then
				entity.flags.homing = true
				entity.speed = images.bullethoming:getWidth() / 2
				entity.radius = 6
			else 
				entity.vector.x = entity.vector.x - 12
			end
		end)
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(entity)
		if entity.vector.x >= g.width + g.grid or entity.vector.y < -g.grid or entity.vector.y >= g.height + g.grid then entity.active = false end
		g.moveVector(entity.vector, entity.angle, entity.speed)
	end,

	draw = function(entity)
		local img = 'bulletdouble' if entity.flags.homing then img = 'bullethoming' end
		g.mask('half', function() g.img(images[img], entity.vector, entity.angle) end)
	end


}