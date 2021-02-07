local g_width = 256
local g_height = 240
local font = love.graphics.newFont("fonts/atari-st.ttf", 8)
local font_big = love.graphics.newFont("fonts/atari-st-8x16.ttf", 14)
local colors = {["blue-dark"] = hex.rgb("32535f"), ["blue-light"] = hex.rgb("74adbb"), ["brown-dark"] = hex.rgb("4f2b24"), ["brown-light"] = hex.rgb("c59154"), ["off-white"] = hex.rgb("fff9e4"), ["red-dark"] = hex.rgb("7d3840"), ["red-light"] = hex.rgb("e89973"), ["yellow-dark"] = hex.rgb("f0bd77"), black = hex.rgb("0d080d"), blue = hex.rgb("4180a0"), brown = hex.rgb("825b31"), gray = hex.rgb("bebbb2"), green = hex.rgb("7bb24e"), purple = hex.rgb("2a2349"), red = hex.rgb("c16c5b"), white = hex.rgb("ffffff"), yellow = hex.rgb("fbdf9b")}
local function clear_color()
  return love.graphics.setColor(colors.white)
end
local masks = {half = love.graphics.newImage("img/masks/half.png"), most = love.graphics.newImage("img/masks/most.png"), quarter = love.graphics.newImage("img/masks/quarter.png")}
local function do_mask(mask, callback)
  local function _0_()
    love.graphics.setShader(maskshader)
    love.graphics.draw(masks[mask], 0, 0)
    return love.graphics.setShader()
  end
  love.graphics.stencil(_0_, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
  callback()
  return love.graphics.setStencilTest()
end
local function label_shadows(input, x, y, limit, align)
  love.graphics.setColor(colors.black)
  love.graphics.printf(input, (x + 1), (y + 1), limit, align)
  love.graphics.printf(input, (x - 1), (y - 1), limit, align)
  love.graphics.printf(input, (x - 1), (y + 1), limit, align)
  love.graphics.printf(input, (x + 1), (y - 1), limit, align)
  love.graphics.printf(input, x, (y - 1), limit, align)
  love.graphics.printf(input, x, (y + 1), limit, align)
  love.graphics.printf(input, (x - 1), y, limit, align)
  return love.graphics.printf(input, (x + 1), y, limit, align)
end
local function label_overlay(input, x, y, limit, align, big)
  local accent_color = "yellow"
  local accent_offset = nil
  if big then
    accent_offset = 8
  else
    accent_offset = 4
  end
  love.graphics.setScissor(x, (y + accent_offset), g_width, (y + (accent_offset * 2)))
  love.graphics.setColor(colors[accent_color])
  local function _1_()
    return love.graphics.printf(input, x, y, limit, align)
  end
  do_mask("half", _1_)
  return love.graphics.setScissor()
end
local function _0_(a, b)
  return math.atan2((b.y - a.y), (b.x - a.x))
end
local function _1_(a, b)
  return math.sqrt((((a.x - b.x) * (a.x - b.x)) + ((a.y - b.y) * (a.y - b.y))))
end
local function _2_(arr)
  local j = 1
  for i, item in ipairs(arr) do
    if (not item.active and (j == 1)) then
      j = i
    end
  end
  return arr[j]
end
local function _3_(arr)
  local index = 1
  local j = 1
  for i, item in ipairs(arr) do
    if (not item.active and (j == 1)) then
      index = i
      j = i
    end
  end
  return {index = index, item = arr[j]}
end
local function _4_(img)
  return img:getHeight()
end
local function _5_(img)
  return img:getWidth()
end
local function _6_(width)
  return love.graphics.setLineWidth(width)
end
local function _7_(input)
  local score = tostring(input)
  for i = 1, (7 - #score) do
    score = ("0" .. score)
  end
  return score
end
local function _8_(color)
  return love.graphics.setColor(colors[color])
end
local function _9_()
  local is_fs = love.window.getFullscreen()
  if is_fs then
    love.window.setFullscreen(false)
    maid64.resize(love.graphics.getWidth(), love.graphics.getHeight())
  end
  if not is_fs then
    return love.window.setFullscreen(true)
  end
end
local function _10_(quad, x, y, size, image)
  return quad:setViewport(x, y, size, size, image:getDimensions())
end
local function _11_(x, y, rad, line)
  local _12_
  if line then
    _12_ = "line"
  else
    _12_ = "fill"
  end
  return love.graphics.circle(_12_, x, y, rad)
end
local function _12_(dir, files)
  local arr = {}
  for i, file in ipairs(files) do
    local img = love.graphics.newImage(("img/" .. dir .. "/" .. file .. ".png"))
    img:setFilter("nearest", "nearest")
    arr[file] = img
  end
  return arr
end
local function _13_(image, x, y, rotation)
  local x_offset = (image:getWidth() / 2)
  local y_offset = (image:getHeight() / 2)
  local _14_
  if rotation then
    _14_ = rotation
  else
    _14_ = 0
  end
  return love.graphics.draw(image, x, y, _14_, 1, 1, x_offset, y_offset)
end
local function _14_(input, _3fx, y, _3fcolor, _3falign, _3flimit, big, overlay)
  local color = nil
  if _3fcolor then
    color = _3fcolor
  else
    color = "off-white"
  end
  local x = nil
  if _3fx then
    x = _3fx
  else
    x = 0
  end
  local align = nil
  if _3falign then
    align = _3falign
  else
    align = "left"
  end
  local limit = nil
  if _3flimit then
    limit = _3flimit
  else
    limit = g_width
  end
  local function _19_()
    if big then
      return font_big
    else
      return font
    end
  end
  love.graphics.setFont(_19_())
  label_shadows(input, x, y, limit, align)
  love.graphics.setColor(colors[color])
  love.graphics.printf(input, x, y, limit, align)
  if overlay then
    label_overlay(input, x, y, limit, align, big)
  end
  return clear_color()
end
local function _15_(size, image)
  return love.graphics.newQuad(0, 0, size, size, image)
end
local function _16_()
  return love.event.quit("restart")
end
return {["animate-interval"] = 15, ["character-z"] = 10, ["clear-color"] = clear_color, ["collision-debug"] = false, ["current-doggy"] = 1, ["current-score"] = 0, ["enemy-count"] = 0, ["game-finished"] = false, ["game-over"] = false, ["game-over-clock"] = 0, ["get-angle"] = _0_, ["get-distance"] = _1_, ["get-item"] = _2_, ["get-item-index"] = _3_, ["hard-mode"] = false, ["high-score-easy"] = 0, ["high-score-hard"] = 0, ["img-height"] = _4_, ["img-width"] = _5_, ["in-boss"] = false, ["kill-bullet-clock"] = 0, ["kill-bullets"] = false, ["line-width"] = _6_, ["no-miss"] = true, ["process-score"] = _7_, ["save-table"] = nil, ["set-color"] = _8_, ["start-clock"] = 0, ["tick-rate"] = (1 / 60), ["time-over"] = false, ["toggle-fullscreen"] = _9_, ["update-quad"] = _10_, circle = _11_, colors = colors, enemies = {}, fullscreen = false, grid = 16, height = g_height, images = _12_, img = _13_, label = _14_, mask = do_mask, paused = false, phi = 1.61803398875, quad = _15_, restart = _16_, scale = 3, started = false, tau = (math.pi * 2), width = g_width}
