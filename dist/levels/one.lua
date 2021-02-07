local clock = 0
local boss_offset_top = (g.height / 4)
local boss_offset_bottom = (g.height - boss_offset_top)
local function wave_one()
  local function spawn_bullets(enemy)
    local count = nil
    if g["hard-mode"] then
      count = 15
    else
      count = 1
    end
    local angle = g["get-angle"](enemy, player.entity)
    sound["play-sfx"]("bullet1")
    for i = 1, count do
      local function _1_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        bullet.speed = 0.75
        bullet.type = 2
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_1_)
      angle = (angle + (g.tau / count))
    end
    return nil
  end
  local function spawn_enemy(x, y, alt, shooter)
    local function _0_(enemy)
      enemy.health = 2
      enemy.x = (((x * 48) + g.width) - 16)
      enemy.y = y
      enemy.type = "robo-red"
      enemy.angle = math.pi
      if alt then
        enemy.flags.alt = true
      end
      if shooter then
        enemy.flags.shooter = true
      end
      enemy.speed = 1
      return nil
    end
    local function _1_(enemy)
      if (enemy.flags.shooter and (enemy.clock == 60)) then
        spawn_bullets(enemy)
      end
      if ((enemy.clock >= 60) and (enemy.clock < 80)) then
        local mod = 0.005
        local function _3_()
          if enemy.flags.alt then
            return (-1 * mod)
          else
            return mod
          end
        end
        enemy.angle = (enemy.angle - _3_())
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  for i = 1, 3 do
    spawn_enemy(i, (g.height / 4), nil, (i == 3))
    spawn_enemy((i + 2), (3 * (g.height / 4)), true, (i == 3))
    spawn_enemy((i + 4), (g.height / 4), nil, (i == 3))
  end
  return nil
end
local function wave_two()
  local function spawn_bullets(enemy, alt)
    local count = nil
    if g["hard-mode"] then
      count = 20
    else
      count = 9
    end
    local angle = g["get-angle"](enemy, player.entity)
    if alt then
      angle = (angle + (math.pi / count))
    end
    sound["play-sfx"]("bullet2")
    for i = 1, count do
      local function _2_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        if alt then
          bullet.speed = 1
        else
          bullet.speed = 0.75
        end
        if alt then
          bullet.type = 4
        else
          bullet.type = 2
        end
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_2_)
      angle = (angle + (g.tau / count))
    end
    return nil
  end
  local function spawn_enemy(x, y, alt, shooter, opposite)
    local function _0_(enemy)
      enemy.health = 2
      enemy.x = (((x * 48) + g.width) - 16)
      enemy.y = y
      if opposite then
        enemy.type = "robo-yellow"
      else
        enemy.type = "robo-blue"
      end
      enemy.health = 2
      enemy.angle = math.pi
      if alt then
        enemy.flags.alt = true
      end
      if shooter then
        enemy.flags.shooter = true
      end
      enemy.speed = 1
      return nil
    end
    local function _1_(enemy)
      if (enemy.flags.shooter and (enemy.clock == 75)) then
        spawn_bullets(enemy)
        if g["hard-mode"] then
          spawn_bullets(enemy, true)
        end
      end
      if ((enemy.clock >= 60) and (enemy.clock < 200)) then
        local mod = -0.0025
        local function _3_()
          if enemy.flags.alt then
            return (-1 * mod)
          else
            return mod
          end
        end
        enemy.angle = (enemy.angle - _3_())
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  for i = 1, 6 do
    local y = (g.grid * 5.5)
    spawn_enemy(i, (g.height - y), true, (i == 3), (i > 3))
    spawn_enemy((i + 2), y, nil, (i == 3), (i > 3))
  end
  return nil
end
local function wave_three(t_alt)
  local function spawn_enemy(x, y, shooter, alt)
    local function _0_(enemy)
      enemy.health = 2
      enemy.x = (((x * 48) + g.width) - 16)
      enemy.y = y
      if t_alt then
        enemy.type = "robo-blue"
      else
        enemy.type = "robo-red"
      end
      enemy.angle = math.pi
      if shooter then
        enemy.flags.shooter = true
      end
      enemy.speed = 0.65
      return nil
    end
    local function _1_(enemy)
      if (enemy.flags.shooter and (enemy.clock == 60)) then
        local count = 20
        local limit = 6
        if g["hard-mode"] then
          count = (count * 2)
          limit = (limit * 4)
        end
        sound["play-sfx"]("bullet3")
        local angle = (g["get-angle"](enemy, player.entity) - (((limit / 2) - 1) * (g.tau / count)))
        for i = 1, count do
          if (i < limit) then
            local function _3_(bullet)
              bullet.x = enemy.x
              bullet.y = enemy.y
              bullet.angle = angle
              bullet.speed = 1
              bullet.type = 3
              return nil
            end
            __fnl_global__class_2dbullet.spawn(_3_)
            angle = (angle + (g.tau / count))
          end
        end
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  local function spawn_enemies(alt)
    local y_mod = (g.grid * 2.25)
    if alt then
      y_mod = (-1 * y_mod)
    end
    for i = 1, 1 do
      local y = (g.height / 2)
      for j = 1, 3 do
        local x = (i + (-1 * (j / 8)))
        if alt then
          x = (x + 2)
        end
        local _2_
        if g["hard-mode"] then
          _2_ = (j ~= 2)
        else
          _2_ = (j == 2)
        end
        local function _4_()
          if alt then
            return true
          else
            return false
          end
        end
        spawn_enemy(x, y, _2_, _4_())
        y = (y + y_mod)
      end
    end
    return nil
  end
  spawn_enemies()
  return spawn_enemies(true)
end
local function wave_four()
  local distance = (g.grid * 5.5)
  local c_x = (g.width + (g.grid * 6.5))
  local c_y = (g.grid * 6.25)
  local x_mod = 0.45
  local y_mod = 0.045
  local function ring()
    local function spawn_bullet(enemy)
      local function _0_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = g["get-angle"](enemy, player.entity)
        bullet.speed = 0.65
        bullet.type = 7
        return nil
      end
      return __fnl_global__class_2dbullet.spawn(_0_)
    end
    local angle = 0
    local count = 9
    for i = 1, count do
      local function _0_(enemy)
        enemy.health = 2
        enemy.flags["c-x"] = c_x
        enemy.flags["c-y"] = c_y
        enemy.flags["c-angle"] = angle
        enemy.angle = nil
        enemy.speed = nil
        enemy.flags["push-x"] = 0
        enemy.flags["push-y"] = 0
        enemy.flags.distance = distance
        enemy.x = (enemy.flags["c-x"] + (math.cos(enemy.flags["c-angle"]) * enemy.flags.distance))
        enemy.y = (enemy.flags["c-y"] + (math.sin(enemy.flags["c-angle"]) * enemy.flags.distance))
        if (i < 4) then
          enemy.type = "robo-blue"
        else
          if (i < 7) then
            enemy.type = "robo-red"
          else
            enemy.type = "robo-yellow"
          end
        end
        return nil
      end
      local function _1_(enemy)
        enemy.flags["c-angle"] = (enemy.flags["c-angle"] - 0.005)
        enemy.x = ((enemy.flags["c-x"] + (math.cos(enemy.flags["c-angle"]) * enemy.flags.distance)) - enemy.flags["push-x"])
        enemy.y = ((enemy.flags["c-y"] + (math.sin(enemy.flags["c-angle"]) * enemy.flags.distance)) + enemy.flags["push-y"])
        local angle0 = math.pi
        local speed = 10
        if (g["hard-mode"] and ((enemy.clock % (60 * 5)) == (60 * 4))) then
          spawn_bullet(enemy)
        end
        enemy.flags["push-x"] = (enemy.flags["push-x"] + x_mod)
        enemy.flags["push-y"] = (enemy.flags["push-y"] + y_mod)
        return nil
      end
      __fnl_global__class_2denemy.spawn(_0_, _1_)
      angle = (angle + (g.tau / count))
    end
    return nil
  end
  local function center()
    local function spawn_bullets(enemy, alt)
      local count = nil
      if g["hard-mode"] then
        count = 7
      else
        count = 5
      end
      local angle = enemy.flags["bullet-angle"]
      sound["play-sfx"]("bullet1")
      for i = 1, count do
        local function _1_(bullet)
          bullet.x = enemy.x
          bullet.y = enemy.y
          bullet.angle = angle
          bullet.speed = 1
          bullet.type = 3
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_1_)
        angle = (angle + (g.tau / count))
      end
      local _1_
      if alt then
        _1_ = -1
      else
        _1_ = 1
      end
      enemy.flags["bullet-angle"] = (enemy.flags["bullet-angle"] - (_1_ * (math.pi / 20)))
      return nil
    end
    local function _0_(enemy)
      enemy.health = 10
      enemy.x = c_x
      enemy.y = c_y
      enemy.speed = nil
      enemy.angle = nil
      enemy.type = "robo-red"
      return nil
    end
    local function _1_(enemy)
      local interval = 10
      local limit = 50
      local max = (limit * 3)
      local start = (limit * 2)
      if g["hard-mode"] then
        max = (limit * 6)
      end
      if ((enemy.clock % max) == 0) then
        enemy.flags["bullet-angle"] = g["get-angle"](enemy, player.entity)
      end
      if ((enemy.x > (g.width / 3)) and ((enemy.clock % max) >= start) and ((enemy.clock % interval) == 0)) then
        spawn_bullets(enemy, (enemy.clock >= max))
      end
      enemy.x = (enemy.x - x_mod)
      enemy.y = (enemy.y + y_mod)
      return nil
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  ring()
  return center()
end
local function boss_one()
  local limit = (60 * 2)
  local max = (60 * 3)
  local s_interval = 15
  local start = (max / 4)
  local _end = max
  local function spawn_bullets_1(enemy)
    local function spawn_bullets(alt)
      local count = nil
      if g["hard-mode"] then
        count = 11
      else
        count = 4
      end
      local angle = nil
      if alt then
        angle = (enemy.flags["bullet-angle-2"] + (math.pi / count))
      else
        angle = enemy.flags["bullet-angle-2"]
      end
      __fnl_global__class_2dexplosion.spawn(enemy.x, boss_offset_top, 1, nil, true)
      sound["play-sfx"]("bullet2")
      for i = 1, count do
        local function _2_(bullet)
          bullet.x = enemy.x
          bullet.y = boss_offset_top
          bullet.type = 9
          bullet.top = true
          bullet.speed = 1
          bullet.angle = angle
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_2_)
        angle = (angle + (g.tau / count))
      end
      enemy.flags["bullet-angle-2"] = (enemy.flags["bullet-angle-2"] + (g.phi / 15))
      return nil
    end
    if ((enemy.flags["bullet-clock"] % max) == start) then
      enemy.flags["bullet-angle-2"] = 0
    end
    if (((enemy.flags["bullet-clock"] % s_interval) == 0) and ((enemy.flags["bullet-clock"] % max) >= start) and ((enemy.flags["bullet-clock"] % max) < _end)) then
      if ((enemy.flags["bullet-clock"] % (2 * max)) < max) then
        return spawn_bullets(((enemy.flags["bullet-clock"] % (s_interval * 2)) == 0))
      end
    end
  end
  local function spawn_bullets_2(enemy)
    local interval = nil
    if g["hard-mode"] then
      interval = 1
    else
      interval = 5
    end
    local alt = (max > (enemy.flags["bullet-clock"] % (max * 2)))
    local function spawn_bullets()
      local mod = enemy.flags["bullet-mod-1"]
      if alt then
        mod = (-1 * mod)
      end
      sound["play-sfx"]("bullet3")
      local function _2_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.type = 2
        bullet.speed = 0.75
        bullet.angle = enemy.flags["bullet-angle-1"]
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_2_)
      enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + mod)
      enemy.flags["bullet-mod-1"] = (enemy.flags["bullet-mod-1"] - 0.0005)
      return nil
    end
    if ((enemy.flags["bullet-clock"] % max) == 0) then
      enemy.flags["bullet-mod-1"] = (g.phi / 2)
      enemy.flags["bullet-angle-1"] = 0
    end
    if (((enemy.flags["bullet-clock"] % interval) == 0) and ((enemy.flags["bullet-clock"] % max) < limit)) then
      return spawn_bullets()
    end
  end
  local function spawn_bullets_3(enemy)
    local function spawn_bullets()
      local count = nil
      if g["hard-mode"] then
        count = 9
      else
        count = 3
      end
      local angle = enemy.flags["bullet-angle-2"]
      __fnl_global__class_2dexplosion.spawn(enemy.x, boss_offset_bottom, 1, nil, true)
      sound["play-sfx"]("bullet2")
      for i = 1, count do
        local function _1_(bullet)
          bullet.x = enemy.x
          bullet.y = enemy.y
          bullet.type = 8
          bullet.top = true
          bullet.speed = 1
          bullet.angle = angle
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_1_)
        angle = (angle + (g.tau / count))
      end
      enemy.flags["bullet-angle-2"] = (enemy.flags["bullet-angle-2"] - (g.phi / 6))
      return nil
    end
    if ((enemy.flags["bullet-clock"] % max) == start) then
      enemy.flags["bullet-angle-2"] = 0
    end
    if (((enemy.flags["bullet-clock"] % s_interval) == 0) and ((enemy.flags["bullet-clock"] % max) >= start) and ((enemy.flags["bullet-clock"] % max) < _end)) then
      if ((enemy.flags["bullet-clock"] % (2 * max)) >= max) then
        return spawn_bullets()
      end
    end
  end
  local function spawn_enemy(y, type)
    local function _0_(enemy)
      enemy.x = (g.width + (g.grid * 1.5))
      enemy.y = y
      if (type == 2) then
        enemy.health = 40
      else
        enemy.health = 20
      end
      enemy.flags["bullet-clock"] = 0
      enemy.type = "robo-red"
      enemy.speed = 1
      if (type == 2) then
        enemy.speed = 1.25
      end
      enemy.flags.type = type
      enemy.flags["bullet-clock"] = 0
      enemy.angle = math.pi
      return nil
    end
    local function _1_(enemy)
      if enemy.visible then
        if (enemy.speed > 0) then
          enemy.speed = (enemy.speed - 0.01)
        else
          enemy.speed = 0
        end
      end
      if (enemy.clock >= 60) then
        if (enemy.flags.type == 1) then
          spawn_bullets_1(enemy)
        end
        if (enemy.flags.type == 2) then
          spawn_bullets_2(enemy)
        end
        if (enemy.flags.type == 3) then
          spawn_bullets_3(enemy)
        end
        enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  spawn_enemy((g.height / 4), 1)
  spawn_enemy((g.height / 2), 2)
  return spawn_enemy(((g.height / 4) * 3), 3)
end
local function wave_five()
  local function spawn_bullets(enemy, alt)
    local count = nil
    if g["hard-mode"] then
      count = 12
    else
      count = 4
    end
    local angle = enemy.flags["bullet-angle"]
    if alt then
      angle = (angle + (g.tau / (count * 2)))
    end
    for i = 1, count do
      local function _2_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        bullet.speed = 1
        bullet.type = 5
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_2_)
      angle = (angle + (g.tau / count))
    end
    enemy.flags["bullet-angle"] = (enemy.flags["bullet-angle"] - (math.pi / 30))
    return nil
  end
  local function spawn_enemy(x_offset, y)
    local function _0_(enemy)
      enemy.health = 5
      enemy.x = (g.width + (g.grid * x_offset))
      enemy.y = y
      enemy.speed = 0.5
      enemy.flags["bullet-angle"] = 0
      enemy.angle = g["get-angle"](enemy, player.entity)
      enemy.type = "robo-blue"
      return nil
    end
    local function _1_(enemy)
      local interval = 30
      if ((enemy.clock >= 60) and (enemy.clock < (60 * 4)) and ((enemy.clock % interval) == 0)) then
        return spawn_bullets(enemy, ((enemy.clock % (interval * 2)) == interval))
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  spawn_enemy(1, (g.height / 4))
  spawn_enemy(4, (g.height / 2))
  return spawn_enemy(8, ((g.height / 4) * 3))
end
local function wave_six()
  local function spawn_bullets(enemy)
    local count = nil
    if g["hard-mode"] then
      count = 20
    else
      count = 10
    end
    local angle = g["get-angle"](enemy, player.entity)
    for i = 1, count do
      local function _1_(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        bullet.speed = 0.75
        if (enemy.type == "robo-yellow") then
          bullet.type = 2
        else
          bullet.type = 7
        end
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_1_)
      angle = (angle + (g.tau / count))
    end
    return nil
  end
  local function spawn_enemy(x_offset, y, alt)
    local function _0_(enemy)
      enemy.health = 2
      enemy.x = ((g.grid * 2) + g.width + ((g.grid * 3) * (x_offset - 1)))
      enemy.y = y
      enemy.speed = 0.75
      enemy.angle = math.pi
      enemy.flags["angle-mod"] = 0.0025
      if alt then
        enemy.flags["angle-mod"] = (-1 * enemy.flags["angle-mod"])
      end
      if alt then
        enemy.type = "robo-yellow"
      else
        enemy.type = "robo-red"
      end
      return nil
    end
    local function _1_(enemy)
      if (enemy.clock == (60 * 1.5)) then
        spawn_bullets(enemy)
      end
      if (g["hard-mode"] and (enemy.clock == (60 * 3))) then
        spawn_bullets(enemy)
      end
      if (enemy.clock >= (60 * 1.5)) then
        enemy.angle = (enemy.angle + enemy.flags["angle-mod"])
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  for i = 1, 3 do
    spawn_enemy(i, (g.height / 3))
    spawn_enemy((i + 2), ((g.height / 3) * 2), true)
    spawn_enemy((i + 4), (g.height / 3))
    spawn_enemy((i + 6), ((g.height / 3) * 2), true)
  end
  return nil
end
local function wave_seven(t_alt)
  local function spawn_bullets(enemy, alt)
    local angle = enemy.flags["bullet-angle"]
    local count = nil
    if g["hard-mode"] then
      count = 16
    else
      count = 5
    end
    for i = 1, count do
      local function _1_(bullet)
        bullet.x = enemy.flags["bullet-pos"].x
        bullet.y = enemy.flags["bullet-pos"].y
        bullet.angle = angle
        bullet.speed = 0.75
        if (enemy.type == "robo-red") then
          bullet.type = 9
        else
          bullet.type = 4
        end
        return nil
      end
      __fnl_global__class_2dbullet.spawn(_1_)
      angle = (angle + (g.tau / count))
    end
    local mod = (g.phi / 5)
    local function _1_()
      if alt then
        return (-1 * mod)
      else
        return mod
      end
    end
    enemy.flags["bullet-angle"] = (enemy.flags["bullet-angle"] + _1_())
    return nil
  end
  local function spawn_enemy(x_offset, y)
    local function _0_(enemy)
      enemy.health = 6
      enemy.x = ((x_offset * (g.grid * 3)) + (g.width + (g.grid * 2)))
      enemy.y = y
      if t_alt then
        enemy.y = (enemy.y - (g.grid * 3))
      end
      if t_alt then
        enemy.type = "robo-red"
      else
        enemy.type = "robo-blue"
      end
      enemy.angle = math.pi
      enemy.speed = 0.65
      enemy.flags["angle-mod"] = 0.0125
      return nil
    end
    local function _1_(enemy)
      local interval = 20
      local limit = (60 * 1)
      local max = (limit * 2)
      if ((enemy.clock % limit) == 0) then
        enemy.flags["bullet-pos"] = {x = enemy.x, y = enemy.y}
        enemy.flags["bullet-angle"] = g["get-angle"](enemy, player.entity)
      end
      if ((enemy.clock >= max) and (enemy.clock < (60 * 7)) and ((enemy.clock % max) >= limit) and ((enemy.clock % interval) == 0)) then
        spawn_bullets(enemy, (enemy.clock >= (max * 2)))
      end
      if (enemy.clock >= 160) then
        enemy.angle = (enemy.angle - enemy.flags["angle-mod"])
        if (enemy.angle <= 0) then
          enemy.angle = 0
          return nil
        end
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  for i = 1, 3 do
    spawn_enemy(i, ((g.height / 5) * 3))
  end
  return nil
end
local function wave_eight()
  local function center()
    local function spawn_bullets(enemy)
      local offset = 32
      local x = (enemy.x - 4)
      local y = (enemy.y - (offset / 2))
      local mod = (g.phi / 30)
      local angle = (math.pi + mod)
      for i = 1, 2 do
        __fnl_global__class_2dexplosion.spawn(x, y, 2, false, true)
        local function _0_(bullet)
          bullet.x = x
          bullet.y = y
          bullet.angle = angle
          bullet.speed = 1.25
          bullet.type = 3
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_0_)
        angle = (angle - (mod * 2))
        y = (y + offset)
      end
      return nil
    end
    local function _0_(enemy)
      enemy.health = 10
      enemy.x = (g.width + (g.grid * 2))
      enemy.y = (g.height / 2)
      enemy.type = "robo-blue"
      enemy.angle = math.pi
      enemy.speed = 0.35
      return nil
    end
    local function _1_(enemy)
      local interval = 30
      local max = (60 * 3)
      local start = 60
      if ((enemy.clock < (60 * 7)) and ((enemy.clock % interval) == 0) and ((enemy.clock % max) >= start)) then
        return spawn_bullets(enemy)
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  local function sides()
    local function spawn_bullet(enemy)
      local angle = enemy.flags["bullet-angle"]
      local count = nil
      if g["hard-mode"] then
        count = 20
      else
        count = 1
      end
      for i = 1, count do
        local function _1_(bullet)
          bullet.x = enemy.flags["bullet-pos"].x
          bullet.y = enemy.flags["bullet-pos"].y
          bullet.angle = angle
          bullet.speed = 1.25
          bullet.type = 9
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_1_)
        angle = (angle + (g.tau / count))
      end
      return nil
    end
    local function spawn_enemy(alt)
      local function _0_(enemy)
        enemy.health = 4
        enemy.x = (g.width + (2 * g.grid))
        enemy.y = (-2 * g.grid)
        enemy.type = "robo-yellow"
        enemy.angle = (math.pi * 0.75)
        enemy.flags["angle-mod"] = 0.0025
        if alt then
          enemy.flags.alt = true
          enemy.y = (g.height - enemy.y)
          enemy.angle = (math.pi * 1.25)
          enemy.flags["angle-mod"] = (-1 * enemy.flags["angle-mod"])
        end
        enemy.speed = 0.35
        return nil
      end
      local function _1_(enemy)
        if (enemy.clock >= 160) then
          enemy.angle = (enemy.angle + enemy.flags["angle-mod"])
          if (not enemy.flags.alt and (enemy.angle >= math.pi)) then
            enemy.angle = math.pi
          end
          if (enemy.flags.alt and (enemy.angle < math.pi)) then
            enemy.angle = math.pi
          end
        end
        local interval = 10
        local limit = 30
        local max = (limit * 2)
        if ((enemy.clock >= 120) and (enemy.clock < (60 * 8)) and ((enemy.clock % max) >= limit) and ((enemy.clock % interval) == 0)) then
          if ((enemy.clock % max) == limit) then
            enemy.flags["bullet-pos"] = {x = enemy.x, y = enemy.y}
            enemy.flags["bullet-angle"] = g["get-angle"](enemy, player.entity)
          end
          return spawn_bullet(enemy)
        end
      end
      return __fnl_global__class_2denemy.spawn(_0_, _1_)
    end
    spawn_enemy()
    return spawn_enemy(true)
  end
  center()
  return sides()
end
local function boss_two()
  local function circle(enemy, alt)
    local mod = (g.phi * 5)
    local function spawn_bullets()
      local bullet_y = enemy.y
      __fnl_global__class_2dexplosion.spawn(enemy.x, bullet_y, 2, nil, true)
      local count = nil
      if g["hard-mode"] then
        count = 20
      else
        count = 10
      end
      local angle = nil
      if alt then
        angle = enemy.flags["bullet-angle-1"]
      else
        angle = enemy.flags["bullet-angle-2"]
      end
      for i = 1, count do
        local function _2_(bullet)
          bullet.x = enemy.x
          bullet.y = bullet_y
          bullet.type = 5
          bullet.speed = 0.75
          bullet.angle = angle
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_2_)
        angle = (angle + (g.tau / count))
      end
      if alt then
        enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + mod)
        return nil
      else
        enemy.flags["bullet-angle-2"] = (enemy.flags["bullet-angle-2"] - mod)
        return nil
      end
    end
    local interval = 40
    if (alt and ((enemy.flags["bullet-clock"] % interval) == 0)) then
      spawn_bullets()
    end
    if (not alt and ((enemy.flags["bullet-clock"] % interval) == (interval / 2))) then
      return spawn_bullets(true)
    end
  end
  local function homing(enemy, alt)
    local function spawn_bullets()
      local angle = nil
      if alt then
        angle = enemy.flags["bullet-angle-3"]
      else
        angle = enemy.flags["bullet-angle-4"]
      end
      local count = nil
      if g["hard-mode"] then
        count = 13
      else
        count = 5
      end
      local bullet_y = enemy.y
      __fnl_global__class_2dexplosion.spawn(enemy.x, bullet_y, 1, nil, true)
      angle = (angle - (math.pi / 2))
      for i = 1, count do
        local function _2_(bullet)
          bullet.x = enemy.x
          bullet.y = bullet_y
          bullet.speed = 1
          bullet.type = 8
          bullet.top = true
          bullet.angle = angle
          return nil
        end
        __fnl_global__class_2dbullet.spawn(_2_)
        angle = (angle + (g.tau / count))
      end
      return nil
    end
    local interval = 25
    local limit = (interval * 8)
    local max = (limit * 2)
    local offset = (interval * 3)
    local mod = (g.phi / 13)
    if alt then
      if (((enemy.flags["bullet-clock"] % interval) == 0) and ((enemy.flags["bullet-clock"] % max) < (limit - offset))) then
        if ((enemy.flags["bullet-clock"] % max) == 0) then
          enemy.flags["bullet-angle-3"] = g["get-angle"]({x = enemy.x, y = enemy.y}, player.entity)
        end
        spawn_bullets(true)
        enemy.flags["bullet-angle-3"] = (enemy.flags["bullet-angle-3"] - mod)
      end
    end
    if not alt then
      if (((enemy.flags["bullet-clock"] % interval) == 0) and (((enemy.flags["bullet-clock"] % max) >= limit) and ((enemy.flags["bullet-clock"] % max) < (max - offset)))) then
        if ((enemy.flags["bullet-clock"] % max) == limit) then
          enemy.flags["bullet-angle-4"] = g["get-angle"]({x = enemy.x, y = enemy.y}, player.entity)
        end
        spawn_bullets()
        enemy.flags["bullet-angle-4"] = (enemy.flags["bullet-angle-4"] + mod)
        return nil
      end
    end
  end
  local function spawn_enemy(y, type)
    local function _0_(enemy)
      enemy.x = (g.width + (g.grid * 1.5))
      enemy.y = y
      enemy.health = 40
      enemy.flags["bullet-clock"] = 0
      enemy.type = "robo-red"
      enemy.speed = 1.15
      enemy.flags.type = type
      enemy.flags["bullet-clock"] = 0
      enemy.flags["bullet-angle-1"] = 0
      enemy.flags["bullet-angle-2"] = 0
      enemy.flags["bullet-angle-3"] = 0
      enemy.flags["bullet-angle-4"] = 0
      enemy.angle = math.pi
      return nil
    end
    local function _1_(enemy)
      if enemy.visible then
        if (enemy.speed > 0) then
          enemy.speed = (enemy.speed - 0.01)
        else
          enemy.speed = 0
        end
      end
      if (enemy.clock >= 100) then
        circle(enemy, (enemy.flags.type == 2))
        homing(enemy, (enemy.flags.type == 2))
        enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
        return nil
      end
    end
    return __fnl_global__class_2denemy.spawn(_0_, _1_)
  end
  spawn_enemy((g.height / 4), 1)
  return spawn_enemy(((g.height / 4) * 3), 2)
end
local function boss_three()
  local function spawn_bullets_1(enemy)
    local function center()
      local function spawn_bullets()
        local count = nil
        if g["hard-mode"] then
          count = 17
        else
          count = 7
        end
        local angle = enemy.flags["bullet-angle-1"]
        for i = 1, count do
          local function _1_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.y
            bullet.angle = angle
            bullet.speed = 0.65
            bullet.type = 5
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_1_)
          angle = (angle + (g.tau / count))
        end
        return nil
      end
      local interval = 10
      local max = (interval * 4)
      if ((enemy.flags["bullet-clock"] % max) == 0) then
        enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + (g.phi / 9))
      end
      if ((enemy.flags["bullet-clock"] % interval) == 0) then
        return spawn_bullets()
      end
    end
    local function rando()
      local function spawn_bullets()
        local count = nil
        if g["hard-mode"] then
          count = 30
        else
          count = 5
        end
        local angle = enemy.flags["bullet-angle-2"]
        __fnl_global__class_2dexplosion.spawn(enemy.x, enemy.flags["bullet-pos"], 1, nil, true)
        for i = 1, count do
          local function _1_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.flags["bullet-pos"]
            bullet.angle = angle
            bullet.speed = 1
            bullet.type = 8
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_1_)
          angle = (angle + (g.tau / count))
        end
        return nil
      end
      local interval = 15
      local limit = (interval * 5)
      local max = (limit * 2)
      if ((enemy.flags["bullet-clock"] % max) == limit) then
        enemy.flags["bullet-angle-2"] = g["get-angle"]({x = enemy.x, y = enemy.flags["bullet-pos"]}, player.entity)
        enemy.flags["bullet-pos"] = (32 + ((g.height - 64) * math.random()))
      end
      if (((enemy.flags["bullet-clock"] % max) >= (limit + interval)) and ((enemy.flags["bullet-clock"] % interval) == 0)) then
        spawn_bullets()
        local mod = nil
        if g["hard-mode"] then
          mod = (g.phi / 11)
        else
          mod = (g.phi / 9)
        end
        if (enemy.flags["bullet-pos"] < (g.height / 2)) then
          mod = (-1 * mod)
        end
        enemy.flags["bullet-angle-2"] = (enemy.flags["bullet-angle-2"] + mod)
        return nil
      end
    end
    center()
    rando()
    enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
    return nil
  end
  local function spawn_bullets_2(enemy)
    local function spin()
      local function spawn_bullets(alt)
        local angle = nil
        if alt then
          angle = enemy.flags["bullet-angle-2"]
        else
          angle = enemy.flags["bullet-angle-1"]
        end
        local y = nil
        if alt then
          y = boss_offset_bottom
        else
          y = boss_offset_top
        end
        local count = nil
        if alt then
          count = 3
        else
          count = 5
        end
        if g["hard-mode"] then
          count = (count * 2)
        end
        __fnl_global__class_2dexplosion.spawn(enemy.x, y, 2, false, true)
        for i = 1, count do
          local function _4_(bullet)
            bullet.x = enemy.x
            bullet.y = y
            bullet.angle = angle
            bullet.speed = 0.75
            bullet.type = 3
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_4_)
          angle = (angle + (g.tau / count))
        end
        enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + enemy.flags["bullet-mod"])
        enemy.flags["bullet-angle-2"] = (enemy.flags["bullet-angle-2"] - enemy.flags["bullet-mod"])
        return nil
      end
      if ((enemy.flags["bullet-clock"] % 20) == 0) then
        spawn_bullets()
        return spawn_bullets(true)
      end
    end
    local function puke()
      local function spawn_bullets()
        local count = nil
        if g["hard-mode"] then
          count = 20
        else
          count = 10
        end
        for i = 1, count do
          local function _1_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.y
            bullet.top = true
            bullet.angle = (math.random() * g.tau)
            bullet.speed = (0.75 + (math.random() * 0.25))
            bullet.type = 10
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_1_)
        end
        return nil
      end
      if ((enemy.flags["bullet-clock"] % 45) == 0) then
        return spawn_bullets()
      end
    end
    spin()
    puke()
    enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
    return nil
  end
  local function spawn_bullets_3(enemy)
    local function puke()
      local function spawn_bullets()
        local count = nil
        if g["hard-mode"] then
          count = 35
        else
          count = 15
        end
        local angle = enemy.flags["bullet-angle-1"]
        for i = 1, count do
          local function _1_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.y
            bullet.speed = 0.75
            bullet.type = 10
            bullet.top = true
            bullet.angle = angle
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_1_)
          angle = (angle + (g.tau / count))
        end
        enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + (g.phi / 15))
        return nil
      end
      if (enemy.flags["bullet-clock"] == 0) then
        enemy.flags["bullet-angle-1"] = 0
      end
      if ((enemy.flags["bullet-clock"] % 30) == 0) then
        return spawn_bullets()
      end
    end
    local function stars()
      local function spawn_bullets(alt)
        local angle = (math.pi + (math.pi * math.random()))
        local count = nil
        if g["hard-mode"] then
          count = 30
        else
          count = 15
        end
        local mod = 0.25
        local diff = (count / 10)
        if alt then
          diff = (diff / 2)
        end
        local angle_mod = ((g.tau / count) * (diff + 1))
        for i = 1, count do
          local limit = (i % diff)
          local max = (i % (diff * 2))
          local b_speed = ((max * mod) + 1)
          if (max >= diff) then
            b_speed = (b_speed - ((max - diff) * (mod * 2)))
          end
          local function _3_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.y
            bullet.angle = (angle + angle_mod)
            bullet.speed = (0.25 + (b_speed / 4))
            bullet.type = 2
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_3_)
          angle = (angle + (g.tau / count))
        end
        return nil
      end
      local interval = 60
      if ((enemy.flags["bullet-clock"] % interval) == 0) then
        return spawn_bullets(((enemy.flags["bullet-clock"] % (interval * 2)) == 0))
      end
    end
    puke()
    stars()
    enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
    return nil
  end
  local function spawn_bullets_4(enemy)
    local function puke()
      local interval = nil
      if g["hard-mode"] then
        interval = 2
      else
        interval = 4
      end
      if ((enemy.flags["bullet-clock"] % interval) == 0) then
        local function _1_(bullet)
          bullet.x = enemy.x
          bullet.y = enemy.y
          bullet.angle = (g.tau * math.random())
          bullet.speed = 0.5
          bullet.top = true
          bullet.type = 10
          return nil
        end
        return __fnl_global__class_2dbullet.spawn(_1_)
      end
    end
    local function ring()
      local function spawn_bullets(alt)
        local count = 2
        local angle = enemy.flags["bullet-angle-1"]
        for i = 1, count do
          local function _0_(bullet)
            bullet.x = enemy.x
            bullet.y = enemy.y
            bullet.angle = angle
            bullet.speed = 1
            bullet.type = 3
            return nil
          end
          __fnl_global__class_2dbullet.spawn(_0_)
          angle = (angle + (g.tau / count))
        end
        enemy.flags["bullet-angle-1"] = (enemy.flags["bullet-angle-1"] + (g.phi / 10))
        return nil
      end
      local interval = nil
      if g["hard-mode"] then
        interval = 1
      else
        interval = 3
      end
      if ((enemy.flags["bullet-clock"] % interval) == 0) then
        spawn_bullets()
      end
      enemy.flags["bullet-clock"] = (enemy.flags["bullet-clock"] + 1)
      return nil
    end
    ring()
    return puke()
  end
  local function _0_(enemy)
    enemy.x = (g.width + (g.grid * 4))
    enemy.y = (g.height / 2)
    enemy.flags["init-health"] = 300
    enemy.health = enemy.flags["init-health"]
    enemy.type = "robot-big-1"
    enemy.speed = 1.9
    enemy.flags["bullet-clock"] = 0
    enemy.flags["bullet-angle-1"] = 0
    enemy.flags["bullet-angle-2"] = 0
    enemy.flags["bullet-mod"] = (g.phi / 9)
    enemy.flags["bullet-pos"] = g.grid
    local function _1_()
      g["kill-bullets"] = true
      g["game-over"] = true
      g["game-finished"] = true
      g["current-score"] = (g["current-score"] + 10000)
      if g["no-miss"] then
        g["current-score"] = (g["current-score"] + 10000)
        return nil
      end
    end
    enemy.suicide = _1_
    enemy.angle = math.pi
    return nil
  end
  local function _1_(enemy)
    if enemy.visible then
      if (enemy.speed > 0) then
        enemy.speed = (enemy.speed - 0.025)
      else
        enemy.speed = 0
      end
    end
    if (enemy.speed <= 0) then
      if (enemy.health >= (3 * (enemy.flags["init-health"] / 4))) then
        spawn_bullets_1(enemy)
      end
      if ((enemy.health >= (enemy.flags["init-health"] / 2)) and (enemy.health < (3 * (enemy.flags["init-health"] / 4)))) then
        spawn_bullets_2(enemy)
      end
      if ((enemy.health >= (enemy.flags["init-health"] / 4)) and (enemy.health < (enemy.flags["init-health"] / 2))) then
        spawn_bullets_3(enemy)
      end
      if (enemy.health < (enemy.flags["init-health"] / 4)) then
        return spawn_bullets_4(enemy)
      end
    end
  end
  return __fnl_global__class_2denemy.spawn(_0_, _1_)
end
local current_enemy_section = 1
local enemy_sections = nil
local function _0_()
  local base = 0
  base = (60 * 4.5)
  if (clock == base) then
    wave_one()
  end
  if (clock == (base + (60 * 4.75))) then
    wave_two()
  end
  base = (base + (60 * 11.5))
  if (clock == base) then
    wave_three()
  end
  if (clock == (base + (60 * 4.5))) then
    wave_three(true)
  end
  base = (base + (60 * 9))
  if (clock == base) then
    wave_four()
  end
  base = (base + (60 * 10.5))
  if (clock == base) then
    boss_one()
  end
  base = (base + 1)
  if (clock == base) then
    g["in-boss"] = true
    return nil
  end
end
local function _1_()
  local base = 0
  base = 60
  if (clock == base) then
    wave_five()
  end
  base = (base + (60 * 4.5))
  if (clock == base) then
    wave_five()
  end
  base = (base + (60 * 5))
  if (clock == base) then
    wave_six()
  end
  base = (base + (60 * 10))
  if (clock == base) then
    wave_seven()
  end
  base = (base + (60 * 4))
  if (clock == base) then
    wave_seven(true)
  end
  base = (base + (60 * 5.5))
  if (clock == base) then
    wave_eight()
  end
  base = (base + (60 * 10))
  if (clock == base) then
    boss_two()
  end
  base = (base + 1)
  if (clock == base) then
    g["in-boss"] = true
    return nil
  end
end
local function _2_()
  if (clock == 60) then
    return boss_three()
  end
end
enemy_sections = {_0_, _1_, _2_}
local function update_enemies()
  local func = enemy_sections[current_enemy_section]
  func()
  if g["in-boss"] then
    if (g["enemy-count"] == 0) then
      g["in-boss"] = false
      clock = -60
      current_enemy_section = (current_enemy_section + 1)
    end
  end
  if g["game-finished"] then
    g["game-over"] = true
    return nil
  end
end
local block_layout = {{"_", "_", "_", "o", "o", "o", "o", "o", "o", "o", "o", "o", "_", "_", "_"}, {"_", "_", "o", "x", "X", "x", "X", "o", "X", "x", "X", "x", "o", "_", "_"}, {"-", "-", "o", "X", "x", "X", "o", "o", "o", "X", "x", "X", "o", "<", "-"}, {"_", "_", "o", "x", "X", "x", "o", "d", "o", "x", "X", "x", "o", "_", "_"}, {"-", "-", "o", "X", "x", "X", "o", "o", "o", "X", "x", "X", "o", "<", "-"}, {"_", "_", "o", "x", "X", "x", "X", "o", "X", "x", "X", "x", "o", "_", "_"}, {"_", "_", "_", "o", "o", "o", "o", "o", "o", "o", "o", "o", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "=", "-", "/", "_", "_", "_", "?", "-", "+", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "x", "X", "_", "_", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "X", "x", "X", "x", "<", "-", "-", "-", "-", "x", "X", "x", "X", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "o", "x", "X", "o", "_", "_", "_", "_", "_", "o", "X", "x", "o", "_"}, {"_", "o", "o", "o", "o", "<", "-", "-", "-", "-", "o", "d", "o", "o", "_"}, {"_", "o", "x", "X", "o", "_", "_", "_", "_", "_", "o", "X", "x", "o", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "X", "x", "X", "x", "<", "-", "-", "-", "-", "x", "X", "x", "X", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "_", "x", "X", "_", "_", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "?", "+", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "_", "_", "o", "_", "_"}, {"x", "X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "o", "x", "o", "_"}, {"o", "o", "o", "o", "o", "o", "o", "<", "-", "-", "-", "o", "X", "o", "<"}, {"o", "o", "o", "d", "o", "o", "o", "_", "_", "_", "_", "o", "x", "o", "_"}, {"o", "o", "o", "o", "o", "o", "o", "<", "-", "-", "-", "o", "X", "o", "<"}, {"x", "X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "o", "x", "o", "_"}, {"X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "_", "_", "o", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"-", "+", "_", "_", "=", "-", "-", "-", "-", "-", "x", "X", "x", "X", "<"}, {"_", "|", "_", "_", "|", "_", "_", "_", "_", "_", "o", "x", "X", "o", "_"}, {"_", "|", "_", "_", "|", "_", "_", "_", "_", "_", "o", "o", "o", "o", "_"}, {"X", "x", "X", "o", "X", "x", "_", "_", "_", "_", "o", "o", "o", "o", "_"}, {"x", "X", "o", "o", "o", "X", "x", "_", "_", "_", "o", "x", "X", "o", "_"}, {"X", "x", "o", "d", "o", "x", "X", "<", "-", "-", "x", "X", "x", "X", "<"}, {"x", "X", "o", "o", "o", "X", "x", "_", "_", "_", "X", "x", "X", "x", "_"}, {"X", "x", "X", "o", "X", "x", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"-", "-", "-", "+", "_", "|", "_", "_", "_", "_", "_", "_", "x", "_", "_"}, {"_", "_", "_", "|", "_", "|", "_", "_", "_", "_", "_", "x", "X", "x", "_"}, {"_", "_", "_", "|", "_", "|", "_", "_", "_", "_", "_", "X", "x", "X", "<"}, {"_", "_", "o", "o", "o", "o", "o", "_", "_", "_", "_", "o", "X", "o", "_"}, {"_", "o", "x", "X", "x", "X", "x", "o", "_", "_", "_", "d", "x", "o", "<"}, {"_", "o", "X", "x", "X", "x", "X", "o", "<", "-", "-", "o", "X", "o", "_"}, {"_", "o", "x", "X", "x", "X", "x", "o", "_", "_", "_", "X", "x", "X", "<"}, {"-", "o", "X", "x", "o", "o", "o", "_", "_", "_", "_", "x", "X", "x", "_"}, {"_", "o", "x", "X", "o", "_", "_", "_", "_", "_", "_", "_", "x", "_", "_"}, {"_", "o", "X", "x", "o", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "o", "X", "x", "o", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "o", "o", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "o", "o", "o", "o", "o", "o", "o", "o", "o", "_", "_", "_"}, {"_", "_", "o", "x", "X", "x", "X", "o", "X", "x", "X", "x", "o", "_", "_"}, {"-", "-", "o", "X", "x", "X", "o", "o", "o", "X", "x", "X", "o", "<", "-"}, {"_", "_", "o", "x", "X", "x", "o", "d", "o", "x", "X", "x", "o", "_", "_"}, {"-", "-", "o", "X", "x", "X", "o", "o", "o", "X", "x", "X", "o", "<", "-"}, {"_", "_", "o", "x", "X", "x", "X", "o", "X", "x", "X", "x", "o", "_", "_"}, {"_", "_", "_", "o", "o", "o", "o", "o", "o", "o", "o", "o", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "|", "_", "_", "_", "|", "_", "_", "_", "_", "_"}, {"_", "_", "_", "=", "-", "/", "_", "_", "_", "?", "-", "+", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "x", "X", "_", "_", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "X", "x", "X", "x", "<", "-", "-", "-", "-", "x", "X", "x", "X", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "o", "x", "X", "o", "_", "_", "_", "_", "_", "o", "X", "x", "o", "_"}, {"_", "o", "o", "o", "o", "<", "-", "-", "-", "-", "o", "d", "o", "o", "_"}, {"_", "o", "x", "X", "o", "_", "_", "_", "_", "_", "o", "X", "x", "o", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "X", "x", "X", "x", "<", "-", "-", "-", "-", "x", "X", "x", "X", "_"}, {"_", "x", "X", "x", "X", "_", "_", "_", "_", "_", "X", "x", "X", "x", "_"}, {"_", "_", "x", "X", "_", "_", "_", "_", "_", "_", "_", "X", "x", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "?", "+", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"_", "_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "_", "_", "o", "_", "_"}, {"x", "X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "o", "x", "o", "_"}, {"o", "o", "o", "o", "o", "o", "o", "<", "-", "-", "-", "o", "X", "o", "<"}, {"o", "o", "o", "d", "o", "o", "o", "_", "_", "_", "_", "o", "x", "o", "_"}, {"o", "o", "o", "o", "o", "o", "o", "<", "-", "-", "-", "o", "X", "o", "<"}, {"x", "X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "o", "x", "o", "_"}, {"X", "x", "X", "x", "X", "x", "_", "_", "_", "_", "_", "_", "o", "_", "_"}, {"_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_"}, {"_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "_", "?", "-", "-"}, {"_", "_", "|", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "|", "_", "_", "_", "_", "_", "_", "o", "x", "o", "_", "_", "_"}, {"_", "_", "|", "_", "_", "_", "_", "_", "o", "x", "X", "x", "o", "_", "_"}, {"_", "_", "?", "-", "-", "-", "-", "-", "o", "X", "x", "X", "o", "<", "-"}, {"_", "_", "_", "_", "_", "_", "_", "_", "o", "x", "X", "x", "o", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "o", "x", "o", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "|", "_", "_", "_", "_"}, {"-", "-", "-", "-", "+", "_", "_", "_", "_", "_", "|", "_", "_", "_", "_"}, {"_", "_", "_", "_", "|", "_", "_", "_", "_", "_", "|", "_", "_", "_", "_"}, {"_", "_", "_", "o", "X", "o", "_", "_", "_", "_", "|", "_", "_", "_", "_"}, {"_", "_", "o", "X", "x", "X", "o", "_", "_", "_", "|", "_", "_", "_", "_"}, {"-", "-", "o", "x", "X", "x", "o", "<", "-", "-", "/", "_", "_", "_", "_"}, {"_", "_", "o", "X", "x", "X", "o", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "o", "X", "o", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}, {"_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"}}
local temp_layout = {}
for i = #block_layout, 1, -1 do
  temp_layout[(#temp_layout + 1)] = block_layout[i]
end
block_layout = temp_layout
local current_block_row = 1
local function spawn_blocks()
  local row = block_layout[current_block_row]
  if row then
    for j = 1, #row do
      local tile = row[j]
      if (tile ~= "_") then
        __fnl_global__class_2dblock.spawn(j, 1, tile)
      end
    end
    current_block_row = (current_block_row + 1)
    return nil
  end
end
local bgm_started = nil
local function update_bgm()
  if (bgm_started and not sound["playing-bgm"]) then
    sound["play-bgm"]("stage-loop")
  end
  if not bgm_started then
    sound["play-bgm"]("stage-intro")
    bgm_started = true
    return nil
  end
end
local function _3_()
  update_enemies()
  if ((#block_layout > 0) and ((clock % 32) == 0)) then
    spawn_blocks()
  end
  if not g["game-over"] then
    update_bgm()
  end
  clock = (clock + 1)
  return nil
end
return {update = _3_}
