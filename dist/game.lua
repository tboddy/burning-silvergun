bitser = require("lib.bitser")
hex = require("lib.hex")
hc = require("lib.hc")
maid64 = require("lib.maid")
g = require("_globals")
controls = require("controls")
sound = require("sound")
start = require("start")
background = require("background")
__fnl_global__class_2dexplosion = require("classes.explosion")
__fnl_global__class_2dindicator = require("classes.indicator")
player = require("player")
__fnl_global__class_2denemy = require("classes.enemy")
stage = require("stage")
chrome = require("chrome")
local function _0_()
  background.init()
  player.init()
  return stage.init()
end
g["init-game"] = _0_
local function load_score()
  local score_data = love.filesystem.read("score.lua")
  if score_data then
    g["save-table"] = bitser.loads(score_data)
    if g["save-table"]["high-score-easy"] then
      g["high-score-easy"] = g["save-table"]["high-score-easy"]
    end
    if g["save-table"]["high-score-hard"] then
      g["high-score-hard"] = g["save-table"]["high-score-hard"]
    end
    if (g["save-table"].fullscreen and ((g["save-table"].fullscreen == true) or (g["save-table"].fullscreen == "true"))) then
      love.window.setFullscreen(true)
    end
  end
  if not score_data then
    g["save-table"] = {}
    return nil
  end
end
love.load = function()
  math.randomseed(1419)
  love.window.setTitle("burning silvergun")
  love.window.setMode((g.width * g.scale), (g.height * g.scale), {minheight = g.height, minwidth = g.width, resizable = true, vsync = false, x = 128, y = 128})
  maid64.setup(g.width, g.height)
  love.graphics.setLineStyle("rough")
  love.graphics.setLineWidth(1)
  load_score()
  controls.init()
  sound.init()
  if g.started then
    return g["init-game"]()
  else
    return start.init()
  end
end
local pausing = false
local function update_pause()
  if (controls.pause() and not pausing) then
    pausing = true
    if g.paused then
      g.paused = false
    else
      g.paused = true
    end
    if g.paused then
      sound["stop-bgm"]()
    else
      sound["play-bgm"]("stage-loop")
    end
  end
  if not controls.pause() then
    pausing = false
    return nil
  end
end
local doing_fullscreen = false
local function update_fullscreen()
  if (controls.fullscreen() and not doing_fullscreen) then
    g["toggle-fullscreen"]()
  end
  if not controls.fullscreen() then
    doing_fullscreen = false
    return nil
  end
end
local function update_game()
  background.update()
  if not g["game-over"] then
    player.update()
    update_pause()
  end
  stage.update()
  chrome.update()
  if (g["game-over-clock"] > 60) then
    if (controls["shot-1"]() or controls["shot-2"]() or controls.pause()) then
      g.restart()
    end
  end
  if g["game-over"] then
    g["game-over-clock"] = (g["game-over-clock"] + 1)
    return nil
  end
end
local function draw_game()
  background.draw()
  stage["draw-blocks"]()
  if not g["game-over"] then
    player.draw()
  end
  stage.draw()
  return chrome.draw()
end
love.update = function(dt)
  controls.update()
  sound.update()
  if controls.reload() then
    g.restart()
  end
  update_fullscreen()
  if g.started then
    return update_game(dt)
  else
    return start.update()
  end
end
love.draw = function()
  maid64.start()
  if g.started then
    draw_game()
  else
    start.draw()
  end
  return maid64.finish()
end
love.resize = function(width, height)
  return maid64.resize(width, height)
end
love.run = function()
  return runhack(g["tick-rate"])
end
return love.run
