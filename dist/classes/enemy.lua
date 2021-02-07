local images = nil
local enemies = {}
local fade_interval = 12
local fade_max = (fade_interval * 4)
local function kill_enemy(enemy)
  if enemy.suicide then
    enemy.suicide()
  end
  enemy.active = false
  __fnl_global__class_2dexplosion.spawn(enemy.x, enemy.y, 3)
  sound["play-sfx"]("explosion1")
  g["current-score"] = (g["current-score"] + 100)
  local new_type = nil
  if string.find(enemy.type, "red") then
    new_type = "red"
  end
  if string.find(enemy.type, "yellow") then
    new_type = "yellow"
  end
  if string.find(enemy.type, "blue") then
    new_type = "blue"
  end
  if (player.entity.combo == 0) then
    player.entity.combo = 1
  end
  if new_type then
    if (new_type == player.entity["last-type"]) then
      player.entity.combo = (player.entity.combo + 1)
    else
      player.entity.combo = 0
    end
    player.entity["last-type"] = new_type
  end
  if ((player.entity.combo > 0) and ((player.entity.combo % 3) == 0)) then
    local combo_score = (player.entity.combo * 100)
    local limit = 9000
    if (combo_score > limit) then
      combo_score = limit
    end
    g["current-score"] = (g["current-score"] + combo_score)
    __fnl_global__class_2dindicator.spawn(enemy.x, enemy.y, ("COMBO " .. combo_score))
  end
  if enemy.collider then
    hc.remove(enemy.collider)
    enemy.collider = false
    return nil
  end
end
local function check_collision(enemy)
  local distance = g["get-distance"](enemy, player.entity)
  if (distance < 20) then
    for item, position in pairs(hc.collisions(enemy.collider)) do
      if (item["item-type"] and (item["item-type"] == "player") and (player["invincible-clock"] == 0)) then
        player.hit(3)
        __fnl_global__class_2dexplosion.spawn(enemy.x, enemy.y, 3)
      end
    end
    return nil
  end
end
local function _0_()
  __fnl_global__class_2denemy.enemies = enemies
  g.enemies = enemies
  return nil
end
local function _1_(enemy)
  if (enemy.clock < (fade_interval * 2)) then
    local function _2_()
      return g.img(images[enemy.type], enemy.x, enemy.y)
    end
    g.mask("quarter", _2_)
  end
  if ((enemy.clock >= (fade_interval * 2)) and (enemy.clock < (fade_interval * 3))) then
    local function _3_()
      return g.img(images[enemy.type], enemy.x, enemy.y)
    end
    g.mask("half", _3_)
  end
  if ((enemy.clock >= (fade_interval * 3)) and (enemy.clock < (fade_interval * 4))) then
    local function _4_()
      return g.img(images[enemy.type], enemy.x, enemy.y)
    end
    g.mask("most", _4_)
  end
  if (enemy.clock >= (fade_interval * 4)) then
    return g.img(images[enemy.type], enemy.x, enemy.y)
  end
end
local function _2_()
  for i = 1, 32 do
    table.insert(enemies, {})
  end
  images = g.images("enemies", {"robot-big-1", "robo-red", "robo-blue", "robo-yellow"})
  return nil
end
local function _3_(init_func, update_func)
  local enemy = g["get-item"](enemies)
  enemy.active = true
  enemy.health = 1
  enemy.visible = false
  enemy.clock = 0
  enemy.flags = {}
  enemy.suicide = nil
  init_func(enemy)
  enemy.size = 96
  enemy["update-func"] = update_func
  local enemy_image = images[enemy.type]
  enemy.collider = hc.rectangle(enemy.x, enemy.y, g["img-width"](enemy_image), g["img-height"](enemy_image))
  if enemy.collider then
    enemy.collider["item-type"] = "enemy"
    enemy.collider["item-killable"] = false
    return nil
  end
end
local function _4_(enemy)
  enemy["update-func"](enemy)
  if (enemy.speed and enemy.angle) then
    enemy.x = (enemy.x + (math.cos(enemy.angle) * enemy.speed))
    enemy.y = (enemy.y + (math.sin(enemy.angle) * enemy.speed))
  end
  if enemy.visible then
    if enemy.collider then
      if (enemy.clock >= fade_max) then
        enemy.collider["item-killable"] = true
      end
      if (not g["game-over"] and enemy.collider) then
        do end (enemy.collider):moveTo(enemy.x, enemy.y)
      end
      if enemy.collider["item-hit"] then
        enemy.collider["item-hit"] = false
        enemy.health = (enemy.health - enemy.collider["hit-damage"])
        if (enemy.health <= 0) then
          kill_enemy(enemy)
        end
      end
    end
    enemy.clock = (enemy.clock + 1)
  end
  if (enemy.x < (g.width + (enemy.size / 2))) then
    enemy.visible = true
  end
  if (enemy.x < (0 - (enemy.size / 2))) then
    enemy.active = false
    if enemy.collider then
      hc.remove(enemy.collider)
      enemy.collider = false
    end
  end
  if (not g["game-over"] and enemy.collider) then
    return check_collision(enemy)
  end
end
return {["update-entities"] = _0_, draw = _1_, enemies = {}, init = _2_, spawn = _3_, update = _4_}
