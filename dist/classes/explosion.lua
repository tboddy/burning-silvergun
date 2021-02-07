local images = nil
local quad = nil
local explosions = {}
local size = 32
local function _0_()
  __fnl_global__class_2dexplosion.explosions = explosions
  return nil
end
local function _1_(explosion)
  local function draw_explosion()
    return love.graphics.draw(images.explosions, quad, explosion.x, explosion.y, 0, explosion["x-flip"], explosion["y-flip"], (size / 2), (size / 2))
  end
  quad:setViewport(explosion["texture-x"], explosion["texture-y"], size, size, (images.explosions):getDimensions())
  if explosion.transparent then
    return g.mask("half", draw_explosion)
  else
    return draw_explosion()
  end
end
local function _2_()
  for i = 1, 320 do
    table.insert(explosions, {})
  end
  images = g.images("stage", {"explosions"})
  quad = love.graphics.newQuad(0, 0, size, size, images.explosions)
  return nil
end
local function _3_(x, y, color, big, small, transparent)
  local explosion = g["get-item"](explosions)
  explosion.active = true
  explosion.clock = 0
  explosion.x = x
  explosion.y = y
  explosion["texture-x"] = 0
  explosion["texture-y"] = 0
  if (math.random() < 0.5) then
    explosion["x-flip"] = 1
  else
    explosion["x-flip"] = -1
  end
  if (math.random() < 0.5) then
    explosion["y-flip"] = 1
  else
    explosion["y-flip"] = -1
  end
  explosion.color = color
  if transparent then
    explosion.transparent = true
  else
    explosion.transparent = false
  end
  if big then
    explosion["x-flip"] = (explosion["x-flip"] * 2)
    explosion["y-flip"] = (explosion["y-flip"] * 2)
  end
  if small then
    explosion["x-flip"] = (explosion["x-flip"] * 0.5)
    explosion["y-flip"] = (explosion["y-flip"] * 0.5)
    return nil
  end
end
local function _4_(explosion)
  local interval = 4
  local frame = 0
  if (explosion.clock >= interval) then
    frame = 1
  end
  if (explosion.clock >= (interval * 2)) then
    frame = 2
  end
  if (explosion.clock >= (interval * 3)) then
    frame = 3
  end
  if (explosion.clock >= (interval * 4)) then
    frame = 4
  end
  if (explosion.clock >= (interval * 5)) then
    explosion.active = false
  end
  explosion.clock = (explosion.clock + 1)
  explosion["texture-x"] = (size * frame)
  explosion["texture-y"] = (size * (explosion.color - 1))
  return nil
end
return {["update-entities"] = _0_, draw = _1_, explosions = {}, init = _2_, spawn = _3_, update = _4_}
