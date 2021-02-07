local images = nil
local bg_color = "black"
local fg_color = "purple"
local bg_quad = nil
local clouds_quad = nil
local bg_angle = (math.pi * 1.01)
local clouds_angle = (math.pi * 1.025)
local bg_x = 0
local bg_y = 0
local clouds_x = 0
local clouds_y = 0
local sky_speed = 1
local clouds_speed = 2
local function init_sky()
  do end (images.bottom):setWrap("repeat", "repeat")
  do end (images.top):setWrap("repeat", "repeat")
  bg_quad = love.graphics.newQuad(0, 0, g.width, g.height, images.bottom)
  clouds_quad = love.graphics.newQuad(0, 0, g.width, g.height, images.top)
  return nil
end
local function update_sky()
  bg_quad:setViewport(bg_x, bg_y, g.width, g.height, (images.bottom):getWidth(), (images.bottom):getHeight())
  clouds_quad:setViewport(clouds_x, clouds_y, g.width, g.height, (images.top):getWidth(), (images.top):getHeight())
  bg_x = (bg_x - (math.cos(bg_angle) * sky_speed))
  bg_y = (bg_y - (math.sin(bg_angle) * sky_speed))
  clouds_x = (clouds_x - (math.cos(clouds_angle) * clouds_speed))
  clouds_y = (clouds_y - (math.sin(clouds_angle) * clouds_speed))
  return nil
end
local function draw_sky()
  g["set-color"](bg_color)
  love.graphics.rectangle("fill", 0, 0, g.width, g.height)
  g["set-color"](fg_color)
  local function _0_()
    return love.graphics.draw(images.bottom, bg_quad, 0, 0)
  end
  g.mask("half", _0_)
  local function _1_()
    return love.graphics.draw(images.top, clouds_quad, 0, 0)
  end
  g.mask("quarter", _1_)
  g["set-color"](bg_color)
  local fade_y = (0.5 * g.grid)
  love.graphics.rectangle("fill", 0, 0, g.width, fade_y)
  love.graphics.draw(images.fade, 0, fade_y)
  g["set-color"](fg_color)
  return love.graphics.draw(images["fade-2"], 0, ((g.grid * 4) + (g.height - (images["fade-2"]):getHeight())))
end
local function _0_()
  draw_sky()
  return g["clear-color"]()
end
local function _1_()
  images = g.images("bg", {"bottom", "top", "fade", "fade-2"})
  return init_sky()
end
local function _2_()
  if not g.paused then
    return update_sky()
  end
end
return {draw = _0_, init = _1_, update = _2_}
