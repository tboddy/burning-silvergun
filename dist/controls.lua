baton = require("lib.baton")
local input = nil
local joystick = nil
local hat = nil
local function pressed(_in)
  return love.keyboard.isDown(_in)
end
local function _0_()
  return (input:get("shot-1") == 1)
end
local function _1_()
  return (input:get("shot-2") == 1)
end
local function _2_()
  return (input:get("down") == 1)
end
local function _3_()
  return (input:get("fullscreen") == 1)
end
local function _4_()
  local baton_obj = {controls = {["shot-1"] = {"key:z", "button:a"}, ["shot-2"] = {"key:x", "button:b"}, down = {"key:down", "axis:lefty+", "button:dpdown"}, fullscreen = {"key:f"}, left = {"key:left", "axis:leftx-", "button:dpleft"}, pause = {"key:escape", "button:start"}, reload = {"key:r", "button:back"}, right = {"key:right", "axis:leftx+", "button:dpright"}, up = {"key:up", "axis:lefty-", "button:dpup"}}}
  local joysticks = love.joystick.getJoysticks()
  for i = 1, #joysticks do
    if (i == 1) then
      baton_obj.joystick = joysticks[i]
    end
  end
  input = baton.new(baton_obj)
  return nil
end
local function _5_()
  return (input:get("left") == 1)
end
local function _6_()
  return (input:get("pause") == 1)
end
local function _7_()
  return (input:get("reload") == 1)
end
local function _8_()
  return (input:get("right") == 1)
end
local function _9_()
  return (input:get("up") == 1)
end
local function _10_()
  return input:update()
end
return {["shot-1"] = _0_, ["shot-2"] = _1_, down = _2_, fullscreen = _3_, init = _4_, left = _5_, pause = _6_, reload = _7_, right = _8_, up = _9_, update = _10_}
