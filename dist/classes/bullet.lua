local images = nil
local quad = nil
local bullets = {}
local bullet_animate_interval = 8
local function set_type(bullet, x, y, width, height)
  bullet["texture-base-x"] = x
  bullet["texture-x"] = x
  bullet["texture-y"] = y
  bullet["texture-width"] = width
  bullet["texture-height"] = height
  return nil
end
local function set_collider(bullet)
  if ((bullet.type == 1) or (bullet.type == 6)) then
    local dist = 5.5
    local angle = bullet.angle
    local x_a = (bullet.x + (math.cos(angle) * dist))
    local y_a = (bullet.y + (math.sin(angle) * dist))
    angle = (angle + (g.tau / 3))
    local x_b = (bullet.x + (math.cos(angle) * dist))
    local y_b = (bullet.y + (math.sin(angle) * dist))
    angle = (angle + (g.tau / 3))
    local x_c = (bullet.x + (math.cos(angle) * dist))
    local y_c = (bullet.y + (math.sin(angle) * dist))
    bullet.collider = hc.polygon(x_a, y_a, x_b, y_b, x_c, y_c)
  end
  if ((bullet.type == 2) or (bullet.type == 7)) then
    bullet.collider = hc.circle(bullet.x, bullet.y, 7)
  end
  if ((bullet.type == 3) or (bullet.type == 8)) then
    bullet.collider = hc.rectangle(bullet.x, bullet.y, 5, 11)
  end
  if ((bullet.type == 4) or (bullet.type == 9)) then
    bullet.collider = hc.rectangle(bullet.x, bullet.y, 2, 6)
  end
  if ((bullet.type == 5) or (bullet.type == 10)) then
    bullet.collider = hc.circle(bullet.x, bullet.y, 3)
    return nil
  end
end
local function animate(bullet)
  local current = math.floor(((bullet.clock % (bullet_animate_interval * 4)) / bullet_animate_interval))
  bullet["texture-x"] = ((current * bullet["texture-width"]) + bullet["texture-base-x"])
  return nil
end
local function check_collision(bullet)
  local distance = g["get-distance"](bullet, player.entity)
  if ((distance < 20) or bullet.collider) then
    if not bullet.collider then
      set_collider(bullet)
    end
    do end (bullet.collider):moveTo(bullet.x, bullet.y)
    if ((bullet.type ~= 1) and (bullet.type ~= 6)) then
      do end (bullet.collider):setRotation(((math.pi / 2) + bullet.angle))
    end
    for item, position in pairs(hc.collisions(bullet.collider)) do
      if (item["item-type"] and (item["item-type"] == "player") and (player["invincible-clock"] == 0)) then
        local color = nil
        if (bullet.type < 6) then
          color = 2
        else
          color = 1
        end
        player.hit(color)
        __fnl_global__class_2dexplosion.spawn(bullet.x, bullet.y, color)
        hc.remove(bullet.collider)
        bullet.collider = false
        bullet.active = false
      end
    end
    return nil
  end
end
local function _0_()
  __fnl_global__class_2dbullet.bullets = bullets
  return nil
end
local function _1_(bullet)
  local offset_x = (bullet["texture-width"] / 2)
  local offset_y = (bullet["texture-height"] / 2)
  quad:setViewport(bullet["texture-x"], bullet["texture-y"], bullet["texture-width"], bullet["texture-height"], (images.bullets):getDimensions())
  local rotation = nil
  if ((bullet.type == 1) or (bullet.type == 3) or (bullet.type == 4) or (bullet.type == 6) or (bullet.type == 8) or (bullet.type == 9)) then
    rotation = bullet.angle
  else
    rotation = 0
  end
  love.graphics.draw(images.bullets, quad, bullet.x, bullet.y, rotation, 1, 1, offset_x, offset_y)
  if (bullet.collider and g["collision-debug"]) then
    g["set-color"]("green")
    do end (bullet.collider):draw("fill")
  end
  return g["clear-color"]()
end
local function _2_()
  for i = 1, 640 do
    table.insert(bullets, {})
  end
  images = g.images("stage", {"bullets"})
  quad = love.graphics.newQuad(0, 0, 1, 1, images.bullets)
  return nil
end
local function _3_(init_func, update_func)
  if (0 == g["kill-bullet-clock"]) then
    local bullet = g["get-item"](bullets)
    bullet.active = true
    bullet.clock = 0
    bullet.grazed = false
    bullet.top = false
    bullet.visible = true
    bullet.flags = {}
    init_func(bullet)
    if (bullet.type == 1) then
      set_type(bullet, 0, 0, 16, 14)
    end
    if (bullet.type == 2) then
      set_type(bullet, 0, 14, 16, 16)
    end
    if (bullet.type == 3) then
      set_type(bullet, 0, 30, 20, 6)
    end
    if (bullet.type == 4) then
      set_type(bullet, 0, 36, 12, 4)
    end
    if (bullet.type == 5) then
      set_type(bullet, 0, 40, 8, 8)
    end
    if (bullet.type == 6) then
      set_type(bullet, 64, 0, 16, 14)
    end
    if (bullet.type == 7) then
      set_type(bullet, 64, 14, 16, 16)
    end
    if (bullet.type == 8) then
      set_type(bullet, 80, 30, 20, 6)
    end
    if (bullet.type == 9) then
      set_type(bullet, 48, 36, 12, 4)
    end
    if (bullet.type == 10) then
      set_type(bullet, 32, 40, 8, 8)
    end
    if update_func then
      bullet["update-func"] = update_func
      return nil
    else
      bullet["update-func"] = nil
      return nil
    end
  end
end
local function _4_(bullet)
  if bullet["update-func"] then
    bullet["update-func"](bullet)
  end
  animate(bullet)
  if (bullet.angle and bullet.speed) then
    bullet.x = (bullet.x + (math.cos(bullet.angle) * bullet.speed))
    bullet.y = (bullet.y + (math.sin(bullet.angle) * bullet.speed))
  end
  if not g["game-over"] then
    check_collision(bullet)
  end
  bullet.clock = (bullet.clock + 1)
  if (g["kill-bullet-clock"] > 0) then
    if bullet.visible then
      local _8_
      if (bullet.type < 6) then
        _8_ = 2
      else
        _8_ = 1
      end
      __fnl_global__class_2dexplosion.spawn(bullet.x, bullet.y, _8_, nil, true)
    end
    bullet.active = false
  end
  if (bullet.visible and ((bullet.x < (-1 * bullet["texture-width"])) or (bullet.x > (g.width + bullet["texture-width"])) or (bullet.y < (-1 * bullet["texture-height"])) or (bullet.y > (g.height + bullet["texture-height"])))) then
    bullet.active = false
    if bullet.collider then
      hc.remove(bullet.collider)
      bullet.collider = false
      return nil
    end
  end
end
return {["update-entities"] = _0_, bullets = {}, draw = _1_, init = _2_, spawn = _3_, update = _4_}
