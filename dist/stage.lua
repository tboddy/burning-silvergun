__fnl_global__class_2dbullet = require("classes.bullet")
__fnl_global__class_2dblock = require("classes.block")
local level_one = require("levels.one")
local function update_enemies()
  g["enemy-count"] = 0
  for i = 1, #__fnl_global__class_2denemy.enemies do
    local enemy = (__fnl_global__class_2denemy.enemies)[i]
    if enemy.active then
      g["enemy-count"] = (g["enemy-count"] + 1)
      __fnl_global__class_2denemy.update(enemy)
    end
  end
  return nil
end
local function draw_enemies()
  for i = 1, #__fnl_global__class_2denemy.enemies do
    local enemy = (__fnl_global__class_2denemy.enemies)[i]
    if (enemy.active and enemy.visible) then
      __fnl_global__class_2denemy.draw(enemy)
    end
  end
  return nil
end
local kill_bullet_limit = 90
local function update_bullets()
  for i = 1, #__fnl_global__class_2dbullet.bullets do
    local bullet = (__fnl_global__class_2dbullet.bullets)[i]
    if (bullet.active and bullet.x and bullet.y) then
      __fnl_global__class_2dbullet.update(bullet)
    end
  end
  if g["kill-bullets"] then
    g["kill-bullet-clock"] = kill_bullet_limit
    g["kill-bullets"] = false
  end
  if (g["kill-bullet-clock"] > 0) then
    g["kill-bullet-clock"] = (g["kill-bullet-clock"] - 1)
    return nil
  end
end
local function draw_bullets()
  for i = 1, #__fnl_global__class_2dbullet.bullets do
    local bullet = (__fnl_global__class_2dbullet.bullets)[i]
    if (bullet.active and bullet.visible and bullet.x and bullet.y and not bullet.top) then
      __fnl_global__class_2dbullet.draw(bullet)
    end
  end
  for i = 1, #__fnl_global__class_2dbullet.bullets do
    local bullet = (__fnl_global__class_2dbullet.bullets)[i]
    if (bullet.active and bullet.visible and bullet.x and bullet.y and bullet.top) then
      __fnl_global__class_2dbullet.draw(bullet)
    end
  end
  return nil
end
local function update_blocks()
  for i = 1, #__fnl_global__class_2dblock.blocks do
    local block = (__fnl_global__class_2dblock.blocks)[i]
    if block.active then
      __fnl_global__class_2dblock.update(block)
    end
  end
  return nil
end
local function draw_blocks()
  for i = 1, #__fnl_global__class_2dblock.blocks do
    local block = (__fnl_global__class_2dblock.blocks)[i]
    if block.active then
      __fnl_global__class_2dblock.draw(block, 1)
    end
  end
  for i = 1, #__fnl_global__class_2dblock.blocks do
    local block = (__fnl_global__class_2dblock.blocks)[i]
    if block.active then
      __fnl_global__class_2dblock.draw(block, 2)
    end
  end
  for i = 1, #__fnl_global__class_2dblock.blocks do
    local block = (__fnl_global__class_2dblock.blocks)[i]
    if block.active then
      __fnl_global__class_2dblock.draw(block, 3)
    end
  end
  for i = 1, #__fnl_global__class_2dblock.blocks do
    local block = (__fnl_global__class_2dblock.blocks)[i]
    if block.active then
      __fnl_global__class_2dblock.draw(block, 4)
    end
  end
  return g["clear-color"]()
end
local function update_explosions()
  for i = 1, #__fnl_global__class_2dexplosion.explosions do
    local explosion = (__fnl_global__class_2dexplosion.explosions)[i]
    if explosion.active then
      __fnl_global__class_2dexplosion.update(explosion)
    end
  end
  return nil
end
local function draw_explosions()
  for i = 1, #__fnl_global__class_2dexplosion.explosions do
    local explosion = (__fnl_global__class_2dexplosion.explosions)[i]
    if explosion.active then
      __fnl_global__class_2dexplosion.draw(explosion)
    end
  end
  return g["clear-color"]()
end
local function update_indicators()
  for i = 1, #__fnl_global__class_2dindicator.indicators do
    local indicator = (__fnl_global__class_2dindicator.indicators)[i]
    if indicator.active then
      __fnl_global__class_2dindicator.update(indicator)
    end
  end
  return nil
end
local function draw_indicators()
  for i = 1, #__fnl_global__class_2dindicator.indicators do
    local indicator = (__fnl_global__class_2dindicator.indicators)[i]
    if indicator.active then
      __fnl_global__class_2dindicator.draw(indicator)
    end
  end
  return nil
end
local function _0_()
  draw_enemies()
  draw_explosions()
  draw_bullets()
  return draw_indicators()
end
local function _1_()
  __fnl_global__class_2denemy.init()
  __fnl_global__class_2dbullet.init()
  __fnl_global__class_2dblock.init()
  __fnl_global__class_2dexplosion.init()
  return __fnl_global__class_2dindicator.init()
end
local function _2_()
  if not g.paused then
    __fnl_global__class_2denemy["update-entities"]()
    __fnl_global__class_2dbullet["update-entities"]()
    __fnl_global__class_2dblock["update-entities"]()
    __fnl_global__class_2dexplosion["update-entities"]()
    __fnl_global__class_2dindicator["update-entities"]()
    update_enemies()
    update_bullets()
    update_blocks()
    update_explosions()
    update_indicators()
    return level_one.update()
  end
end
return {["draw-blocks"] = draw_blocks, draw = _0_, init = _1_, update = _2_}
