-- local fennel = require('lib.fennel')
-- table.insert(package.loaders or package.searchers, fennel.searcher)
maskshader = love.graphics.newShader([[vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){ if(Texel(texture, texture_coords).rgb == vec3(0.0)) {discard;} return vec4(1.0); }]])
runhack = function(tickRate)
  if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
  if love.timer then love.timer.step() end
  local lag = 0
  return function()
    if love.event then
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == 'quit' then if not love.quit or not love.quit() then return a or 0 end end
        love.handlers[name](a,b,c,d,e,f)
      end
    end
    if love.timer then lag = math.min(lag + love.timer.step(), tickRate * 25) end
    while lag >= tickRate do
      if love.update then love.update(tickRate) end
      lag = lag - tickRate
    end
    if love.graphics and love.graphics.isActive() then
      love.graphics.origin()
      love.graphics.clear(love.graphics.getBackgroundColor())
      if love.draw then love.draw() end
      love.graphics.present()
    end
    if love.timer then love.timer.sleep(0.001) end
  end
end

require('game')


-- g3d = require "lib.g3d"
-- maid64 = require "lib.maid"

-- function love.load()
--   love.window.setMode(640, 480, {vsync = false})
--   maid64.setup(320, 240)
--     Earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {0,0,4})
--     Moon = g3d.newModel("assets/sphere.obj", "assets/moon.png", {5,0,4}, nil, {0.5,0.5,0.5})
--     Background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
--     Timer = 0
-- end

-- function love.mousemoved(x,y, dx,dy)
--     g3d.camera.firstPersonLook(dx,dy)
-- end

-- function love.update(dt)
--     Timer = Timer + dt
--     Moon:setTranslation(math.cos(Timer)*5, 0, math.sin(Timer)*5 +4)
--     Moon:setRotation(0,-1*Timer,0)
--     g3d.camera.firstPersonMovement(dt)
-- end

-- function love.draw()
--   maid64.start()
--     Earth:draw()
--     Moon:draw()
--     Background:draw()
--   maid64.finish()
-- end