local init_x = (g.grid * 2.5)
local init_y = (g.height / 2)
local images = nil
local bullets = {}
local can_shoot = true
local shot_clock = 0
local invincible_time = (60 * 3)
local invincible_clock = 0
local shot_type = 1
local shot_diff = (g.phi / 3)
local start_x = (g.grid * -13.5)
local entity = {["last-type"] = false, collider = hc.circle(start_x, init_y, 1), combo = 0, hit = false, lives = 5, x = start_x, y = init_y}
local function check_move()
  local mod = 3
  if (entity.x < mod) then
    entity.x = mod
  elseif (entity.x > (g.width - mod)) then
    entity.x = (g.width - mod)
  end
  if (entity.y < mod) then
    entity.y = mod
    return nil
  elseif (entity.y > (g.height - mod)) then
    entity.y = (g.height - mod)
    return nil
  end
end
local function update_move()
  local speed = 2
  local angle = -1
  local function set_angle(_in)
    angle = (math.pi * _in)
    return nil
  end
  if controls.up() then
    set_angle(1.5)
  elseif controls.down() then
    set_angle(0.5)
  end
  if controls.left() then
    set_angle(1)
    if controls.up() then
      set_angle(1.25)
    elseif controls.down() then
      set_angle(0.75)
    end
  end
  if controls.right() then
    set_angle(0)
    if controls.up() then
      set_angle(1.75)
    elseif controls.down() then
      set_angle(0.25)
    end
  end
  if (angle > -1) then
    entity.x = (entity.x + (math.cos(angle) * speed))
    entity.y = (entity.y + (math.sin(angle) * speed))
  end
  check_move()
  local collider_offset = 0.5
  return (entity.collider):moveTo((entity.x - collider_offset), (entity.y - collider_offset))
end
local start_speed = 2.5
local function update_start()
  entity.x = (entity.x + start_speed)
  if (start_speed > 0) then
    start_speed = (start_speed - 0.0125)
    return nil
  else
    start_speed = 0
    return nil
  end
end
local function spawn_bullet(angle, double)
  local bullet = g["get-item"](bullets)
  local offset = 8
  bullet.active = true
  bullet.angle = angle
  bullet.x = (entity.x + (math.cos(bullet.angle) * offset))
  bullet.y = (entity.y + (math.sin(bullet.angle) * offset))
  bullet.speed = 24
  bullet["h-angle"] = nil
  bullet.clock = 0
  if (shot_type == 1) then
    bullet.homing = false
    bullet.damage = 1
    bullet.speed = 24
  end
  if (shot_type == 2) then
    bullet.homing = true
    bullet.damage = 0.25
    bullet.speed = 10
  end
  if (shot_type == 3) then
    bullet.homing = false
    bullet.damage = 2
    bullet.speed = 10
  end
  if bullet.homing then
    bullet.collider = hc.circle(bullet.x, bullet.y, 8)
  else
    local _3_
    if double then
      _3_ = (images["bullet-double"]):getWidth()
    else
      _3_ = (images["bullet-single"]):getWidth()
    end
    bullet.collider = hc.rectangle(bullet.x, bullet.y, _3_, (images["bullet-single"]):getHeight())
  end
  do end (bullet.collider):rotate((bullet.angle + (math.pi / 2)))
  if double then
    bullet.double = true
  else
    bullet.double = false
  end
  return nil
end
local function spawn_bullets()
  sound["play-sfx"]("playershot")
  if (shot_type == 1) then
    spawn_bullet(0, true)
  end
  if ((shot_type == 2) or (shot_type == 3)) then
    spawn_bullet((0 - shot_diff), nil)
    return spawn_bullet(shot_diff, nil)
  end
end
local function update_shot()
  if (can_shoot and (controls["shot-1"]() or controls["shot-2"]())) then
    if controls["shot-1"]() then
      shot_type = 1
    end
    if controls["shot-2"]() then
      shot_type = 2
    end
    can_shoot = false
    shot_clock = 0
  end
  local interval = nil
  if (shot_type == 1) then
    interval = 10
  end
  if (shot_type == 2) then
    interval = 15
  end
  if (shot_type == 3) then
    interval = 35
  end
  local limit = (interval * 1)
  local max = (interval * 1)
  if ((can_shoot == false) and ((shot_clock % interval) == 0) and (shot_clock < limit)) then
    spawn_bullets()
  end
  shot_clock = (shot_clock + 1)
  if (shot_clock >= max) then
    can_shoot = true
    return nil
  end
end
local function bullet_collision(bullet)
  do end (bullet.collider):moveTo(bullet.x, bullet.y)
  for item, position in pairs(hc.collisions(bullet.collider)) do
    if (item["item-type"] and (((item["item-type"] == "enemy") and item["item-killable"]) or (item["item-type"] == "block"))) then
      bullet.collider.hit = true
      item["hit-damage"] = bullet.damage
      item["item-hit"] = true
    end
  end
  if bullet.collider.hit then
    __fnl_global__class_2dexplosion.spawn(bullet.x, bullet.y, 3, false, true)
    hc.remove(bullet.collider)
    bullet.collider = false
    bullet.active = false
    return nil
  end
end
local function homing_angle(bullet)
  local angle = bullet.angle
  local target = nil
  if g.enemies then
    local enemy = nil
    for i = 1, #g.enemies do
      local enemy0 = g.enemies[i]
      if (enemy0.visible and enemy0.active and (enemy0.x > 8) and (enemy0.y > 0) and (enemy0.y < g.height)) then
        enemy0.flags["homing-distance"] = g["get-distance"](bullet, enemy0)
        if not target then
          target = enemy0
        end
        if (target and (enemy0.flags["homing-distance"] < target.flags["homing-distance"])) then
          target = enemy0
        end
      end
    end
  end
  if target then
    angle = g["get-angle"](bullet, target)
  end
  return angle
end
local function update_bullet(bullet)
  bullet.x = (bullet.x + (math.cos(bullet.angle) * bullet.speed))
  bullet.y = (bullet.y + (math.sin(bullet.angle) * bullet.speed))
  local img = nil
  if bullet.double then
    img = images["bullet-double"]
  else
    if bullet.homing then
      img = images["bullet-homing"]
    else
      img = images["bullet-single"]
    end
  end
  if bullet.homing then
    if ((bullet.clock % 10) == 5) then
      bullet["h-angle"] = homing_angle(bullet)
    end
    if bullet["h-angle"] then
      local mod = 0
      local diff = 0.25
      if (bullet.angle < bullet["h-angle"]) then
        mod = diff
      end
      if (bullet.angle > bullet["h-angle"]) then
        mod = (diff * -1)
      end
      bullet.angle = (bullet.angle + mod)
    end
  end
  if bullet.collider then
    bullet_collision(bullet)
  end
  bullet.clock = (bullet.clock + 1)
  if ((bullet.x > (g.width + g["img-width"](img))) or (bullet.y > (g.height + g["img-height"](img))) or (bullet.y < (-1 * g["img-height"](img)))) then
    if bullet.collider then
      hc.remove(bullet.collider)
      bullet.collider = false
    end
    bullet.active = false
    return nil
  end
end
local function update_bullets()
  for i = 1, #bullets do
    local bullet = bullets[i]
    if bullet.active then
      update_bullet(bullet)
    end
  end
  return nil
end
local function draw_player()
  return g.img(images.nitori, (entity.x - 1), (entity.y + 3))
end
local function draw_hitbox()
  return g.img(images.hitbox, entity.x, entity.y)
end
local function draw_bullet(bullet)
  if bullet.homing then
    g["set-color"]("green")
    local function _0_()
      return g.circle(bullet.x, bullet.y, 10)
    end
    g.mask("quarter", _0_)
    g["clear-color"]()
  end
  local img = nil
  if bullet.double then
    img = images["bullet-double"]
  else
    if bullet.homing then
      img = images["bullet-homing"]
    else
      img = images["bullet-single"]
    end
  end
  g.img(img, bullet.x, bullet.y, (bullet.angle + (math.pi / 2)))
  if (bullet.collider and g["collision-debug"]) then
    return (bullet.collider):draw("line")
  end
end
local function draw_bullets()
  local function _0_()
    for i = 1, #bullets do
      local bullet = bullets[i]
      if bullet.active then
        draw_bullet(bullet)
      end
    end
    return nil
  end
  return g.mask("half", _0_)
end
local function _0_()
  draw_bullets()
  local interval = g["animate-interval"]
  if ((invincible_clock <= 0) or ((invincible_clock % (interval * 2)) < interval)) then
    draw_player()
  end
  draw_hitbox()
  if (entity.collider and g["collision-debug"]) then
    g["set-color"]("red-light")
    do end (entity.collider):draw("fill")
  end
  return g["clear-color"]()
end
local function _1_(color)
  invincible_clock = invincible_time
  entity.lives = (entity.lives - 1)
  __fnl_global__class_2dexplosion.spawn(entity.x, entity.y, color, true)
  entity.x = init_x
  entity.y = init_y
  if (entity.lives < 0) then
    g["game-over"] = true
    sound["stop-bgm"]()
    return sound["play-sfx"]("gameover")
  end
end
local function _2_()
  for i = 1, 128 do
    table.insert(bullets, {})
  end
  images = g.images("player", {"nitori", "hitbox", "bullet-double", "bullet-single", "bullet-homing"})
  entity.collider["item-type"] = "player"
  return nil
end
local function _3_()
  local limit = (10 * 20)
  if (not g.paused and (g["start-clock"] < limit)) then
    update_start()
  end
  if (not g.paused and (g["start-clock"] >= limit)) then
    update_move()
    update_shot()
  end
  if not g.paused then
    update_bullets()
    if (invincible_clock > 0) then
      invincible_clock = (invincible_clock - 1)
    end
  end
  player.entity = entity
  player.bullets = bullets
  player["invincible-clock"] = invincible_clock
  return nil
end
return {draw = _0_, hit = _1_, init = _2_, update = _3_}
