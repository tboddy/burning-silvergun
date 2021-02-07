local blocks = {}
local speed = 0.5
local size = 16
local radius = 4
local images = nil
local function kill_block(block)
  if block.destructable then
    if (block.type == "d") then
      local doggy_score = (g["current-doggy"] * 900)
      g["current-score"] = (g["current-score"] + doggy_score)
      g["current-doggy"] = (g["current-doggy"] + 1)
      sound["play-sfx"]("bonus")
      __fnl_global__class_2dindicator.spawn((block.x + (size / 2)), (block.y + (size / 2)), ("BONUS " .. doggy_score))
    end
    if ((block.type == "x") or (block.type == "d") or (block.type == "X")) then
      block.type = "O"
    end
    if block.collider then
      __fnl_global__class_2dexplosion.spawn((block.x + (size / 2)), (block.y + (size / 2)), 3)
      g["current-score"] = (g["current-score"] + 10)
      hc.remove(block.collider)
      block.collider = false
      return nil
    end
  end
end
local function _0_()
  __fnl_global__class_2dblock.blocks = blocks
  return nil
end
local function _1_(block, level)
  local x = block.x
  local y = block.y
  local platform_color = "purple"
  local shadow_color = "black"
  local point_color = "blue-dark"
  local point_color_alt = "red-dark"
  local floor_mod = 8
  local floor_x = (x - (floor_mod / 2))
  local floor_y = (y - (floor_mod / 2))
  local floor_width = (size + floor_mod)
  local floor_height = (size + floor_mod)
  local shadow_height = 12
  local pipe_width = 10
  local pipe_narrow = 4
  local function floor_shadow()
    g["set-color"](platform_color)
    local shadow_y = (floor_y + shadow_height)
    love.graphics.rectangle("fill", floor_x, shadow_y, floor_width, floor_height, radius)
    local offset = (shadow_height / 3)
    g["set-color"](shadow_color)
    love.graphics.setScissor(floor_x, ((shadow_y + floor_height) - offset), floor_width, offset)
    local function _2_()
      return love.graphics.rectangle("fill", floor_x, shadow_y, floor_width, floor_height, radius)
    end
    g.mask("most", _2_)
    love.graphics.setScissor(floor_x, ((shadow_y + floor_height) - offset - offset), floor_width, offset)
    local function _3_()
      return love.graphics.rectangle("fill", floor_x, shadow_y, floor_width, floor_height, radius)
    end
    g.mask("half", _3_)
    love.graphics.setScissor(floor_x, ((shadow_y + floor_height) - offset - offset - offset), floor_width, offset)
    local function _4_()
      return love.graphics.rectangle("fill", floor_x, shadow_y, floor_width, floor_height, radius)
    end
    g.mask("quarter", _4_)
    return love.graphics.setScissor()
  end
  local function floor()
    g["set-color"](platform_color)
    return love.graphics.rectangle("fill", floor_x, floor_y, floor_width, floor_height, radius)
  end
  local function point(alt, shadow)
    if shadow then
      g["set-color"](shadow_color)
    end
    local function point_top()
      local function _3_()
        if alt then
          return point_color_alt
        else
          return point_color
        end
      end
      g["set-color"](_3_())
      love.graphics.rectangle("fill", x, y, size, (size - 1), (radius / 2))
      local function _4_()
        if alt then
          return point_color_alt
        else
          return point_color
        end
      end
      g["set-color"](_4_())
      love.graphics.rectangle("fill", x, y, size, size, (radius / 2))
      g["set-color"](platform_color)
      local function _5_()
        return love.graphics.rectangle("fill", x, (y + 1), size, (size - 1), (radius / 2))
      end
      return g.mask("half", _5_)
    end
    if shadow then
      local function _3_()
        local _4_
        if shadow then
          _4_ = (y + 2)
        else
          _4_ = y
        end
        return love.graphics.rectangle("fill", x, _4_, size, size, (radius / 2))
      end
      return g.mask("quarter", _3_)
    else
      return point_top()
    end
  end
  local function destroyed()
    g["set-color"](shadow_color)
    local function _2_()
      return love.graphics.rectangle("fill", x, y, size, size, (radius / 2))
    end
    return g.mask("quarter", _2_)
  end
  local function pipe(vertical, _end)
    local offset = (size / 2)
    local x_a = x
    local y_a = (y + offset)
    local x_b = (x + size)
    local y_b = (y + offset)
    if vertical then
      x_a = (x + offset)
      y_a = y
      x_b = (x + offset)
      y_b = (y + size)
    end
    if _end then
      y_a = (y_a + offset)
    end
    local end_offset = 2
    love.graphics.setLineWidth(pipe_width)
    g["set-color"](shadow_color)
    local _4_
    if _end then
      _4_ = (y_a + end_offset)
    else
      _4_ = y_a
    end
    love.graphics.line(x_a, _4_, x_b, y_b)
    g["set-color"](platform_color)
    local function _6_()
      return love.graphics.line(x_a, y_a, x_b, y_b)
    end
    g.mask("quarter", _6_)
    love.graphics.setLineWidth(pipe_narrow)
    local function _7_()
      return love.graphics.line(x_a, y_a, x_b, y_b)
    end
    return g.mask("half", _7_)
  end
  local function pipe_corner(type)
    love.graphics.setScissor(x, y, size, size)
    local c_x = x
    local c_y = y
    if (type == 2) then
      c_x = (x + size)
    end
    if (type == 3) then
      c_y = (y + size)
    end
    if (type == 4) then
      c_x = (x + size)
      c_y = (y + size)
    end
    love.graphics.setLineWidth(pipe_width)
    g["set-color"](shadow_color)
    love.graphics.circle("line", c_x, c_y, (size / 2))
    g["set-color"](platform_color)
    local function _5_()
      return love.graphics.circle("line", c_x, c_y, (size / 2))
    end
    g.mask("quarter", _5_)
    love.graphics.setLineWidth(pipe_narrow)
    local function _6_()
      return love.graphics.circle("line", c_x, c_y, (size / 2))
    end
    g.mask("half", _6_)
    return love.graphics.setScissor()
  end
  local function doggy()
    local doggy_color = "brown"
    g["set-color"](doggy_color)
    love.graphics.rectangle("fill", x, y, size, (size - 1), (radius / 2))
    g["set-color"](doggy_color)
    love.graphics.rectangle("fill", x, y, size, size, (radius / 2))
    g["set-color"](platform_color)
    local function _2_()
      return love.graphics.rectangle("fill", x, (y + 1), size, (size - 1), (radius / 2))
    end
    g.mask("half", _2_)
    love.graphics.draw(images.point, x, (y + 1))
    g["set-color"]("brown-light")
    return love.graphics.draw(images.point, x, y)
  end
  if (level == 1) then
    if ((block.type == "o") or (block.type == "x") or (block.type == "X") or (block.type == "O") or (block.type == "d")) then
      floor_shadow()
    end
    if (block.type == "|") then
      pipe()
    end
    if (block.type == "-") then
      pipe(true)
    end
    if (block.type == "<") then
      pipe(true, true)
    end
    if (block.type == "/") then
      pipe_corner(2)
    end
    if (block.type == "?") then
      pipe_corner(4)
    end
    if (block.type == "+") then
      pipe_corner(1)
    end
    if (block.type == "=") then
      pipe_corner(3)
    end
  end
  if (level == 2) then
    if ((block.type == "o") or (block.type == "x") or (block.type == "X") or (block.type == "O") or (block.type == "d")) then
      floor()
    end
  end
  if (level == 3) then
    if ((block.type == "x") or (block.type == "X") or (block.type == "d")) then
      point(false, true)
    end
    if (block.type == "O") then
      destroyed()
    end
  end
  if (level == 4) then
    if (block.type == "d") then
      doggy()
    end
    if (block.type == "x") then
      point()
    end
    if (block.type == "X") then
      point(true)
    end
  end
  love.graphics.setLineWidth(1)
  if (block.collider and g["collision-debug"]) then
    g["set-color"]("gray")
    do end (block.collider):draw("line")
  end
  return g["clear-color"]()
end
local function _2_()
  for i = 1, 256 do
    table.insert(blocks, {})
  end
  images = g.images("stage", {"point"})
  return nil
end
local function _3_(column, row, type)
  local block = g["get-item"](blocks)
  block.active = true
  block.y = ((column - 1) * size)
  block.x = (g.width + (g.grid * 2))
  block.x = (block.x - (column * 2))
  block.type = type
  if (type == "d") then
    block.health = 5
  else
    block.health = 0.1
  end
  if ((type == "d") or (type == "x") or (type == "X")) then
    block.destructable = true
  else
    block.destructable = false
  end
  if block.destructable then
    block.collider = hc.rectangle(block.x, block.y, size, size)
  else
    block.collider = false
  end
  if block.collider then
    block.collider["item-type"] = "block"
    return nil
  end
end
local function _4_(block)
  block.x = (block.x - speed)
  if block.collider then
    do end (block.collider):moveTo((block.x + (size / 2)), (block.y + (size / 2)))
    if block.collider["item-hit"] then
      block.collider["item-hit"] = false
      block.health = (block.health - 1)
      if (block.health <= 0) then
        kill_block(block)
      end
    end
  end
  if (block.x < (-2 * g.grid)) then
    block.active = false
    if block.collider then
      hc.remove(block.collider)
      block.collider = false
      return nil
    end
  end
end
return {["update-entities"] = _0_, blocks = {}, draw = _1_, init = _2_, spawn = _3_, speed = speed, update = _4_}
