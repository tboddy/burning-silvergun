local images

return {

	------------------------------------
	-- load
	------------------------------------

	load = function()
		images = g.images('enemies', {'smallblue'})
	end,

	------------------------------------
	-- spawn
	------------------------------------

	spawn = function(self, type, y)
		entities:spawn(function(entity)
			entity.update = self.update
			entity.draw = self.draw
			entity.vector = g.vector(g.width + images[type]:getWidth() / 2, y)
			entity.angle = math.pi
			entity.speed = 1
			entity.seen = false
			entity.type = type
		end)
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(entity)
		if entity.seen and (entity.vector.x > g.width + images[entity.type]:getWidth() / 2 or
			entity.vector.x < -images[entity.type]:getWidth() / 2 or
			entity.vector.y < -images[entity.type]:getWidth() / 2 or
			entity.vector.y > g.height + images[entity.type]:getWidth() / 2) then entity.active = false
		elseif not entity.seen and (entity.vector.x <= g.width + images[entity.type]:getWidth() / 2 and
			entity.vector.x >= -images[entity.type]:getWidth() / 2 and
			entity.vector.y >= -images[entity.type]:getWidth() / 2 and
			entity.vector.y <= g.height + images[entity.type]:getWidth() / 2) then entity.seen = true end
		g.moveVector(entity.vector, entity.angle, entity.speed)
	end,

	draw = function(entity)
		-- local img = 'bulletdouble' if entity.flags.homing then img = 'bullethoming' end
		-- g.mask('half', function() g.img(images[img], entity.vector, entity.angle) end)
		g.img(images[entity.type], entity.vector)
	end


}