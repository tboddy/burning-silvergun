maxEntities = 5120
entities = {}

return {


	------------------------------------
	-- load
	------------------------------------

	load = function()
		for i = 1, maxEntities do entities[i] = {} end
	end,


	------------------------------------
	-- spawn
	------------------------------------

	spawn = function(self, init)
		local index = 1
		for i, item in ipairs(entities) do if not item.active and index == 1 then index = i break end end
		local entity = entities[index]
		entity.active = true
		entity.seen = false
		entity.hit = false
		entity.radius = 1
		entity.collider = false
		entity.flags = {}
		init(entities[index])
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function() 
		for i, entity in ipairs(entities) do
			if entity.active then entity.update(entity) end
		end
	end,

	draw = function()
		for i, entity in ipairs(entities) do
			if entity.active and entity.seen then
				entity.draw(entity)
				if g.collisionDebug and entity.collider then
					g:setColor('green')
					love.graphics.circle('fill', entity.vector.x, entity.vector.y, entity.radius)
					g:resetColor()
				end
			end
		end
	end


}