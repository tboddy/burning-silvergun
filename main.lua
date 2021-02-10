--------------------------------------
-- imports
--------------------------------------

maid64 = require 'lib.maid'
bitser = require 'lib.bitser'
hex = require 'lib.hex'
hc = require 'lib.hc'
g = require '_globals'
controls = require 'controls'
sound = require 'sound'
entities = require 'entities'
-- start = require 'start'
background = require 'background'
-- classExplosion = require 'classes.explosion'
-- classIndicator = require 'classes.indicator'
playerBullet = require 'playerbullet'
player = require 'player'
-- classEnemy = require 'classes.enemy'
-- stage = require 'stage'
-- chrome = require 'chrome'


--------------------------------------
-- load
--------------------------------------

local loadGame = function()
	background.load()
	playerBullet.load()
	player:load()
	-- 	stage.load()
end

local loadScore = function()
	local scoreData = love.filesystem.read('score.lua')
	if scoreData then
		g.saveTable = bitser.loads(scoreData)
		if g.saveTable.highScoreEasy then g.highScoreEasy = g.saveTable.highScoreEasy end
		if g.saveTable.highScoreHard then g.highScoreHard = g.saveTable.highScoreHard end
		if g.saveTable.fullscreen and (g.saveTable.fullscreen == true or g.saveTable.fullscreen == 'true') then love.window.setFullscreen(true) end
	else g.saveTable = {} end
end 

love.load = function()
	math.randomseed(1419)
	love.window.setTitle('burning silvergun redux')
	local windowConfig = {
		vsync = false,
		x = 128,
		y = 128,
		minwidth = g.width,
		minheight = g.height,
		resizable = true
	}
	love.window.setMode(g.width * g.scale, g.height * g.scale, windowConfig)
	maid64.setup(g.width, g.height)
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(1)
	loadScore()
	controls:load()
	sound:load()
	entities:load()
	loadGame()
	-- if g.started then g.loadGame else start.init end
end


--------------------------------------
-- loop
--------------------------------------

local updateGame = function()
	background.update()
	-- stage.update()
	-- chrome.update()
	if g.gameOver then g.gameOverClock = g.gameOverClock + 1 end
end

local drawGame = function()
	background.draw()
	entities:draw()
	-- stage.drawBlocks()
	-- stage.draw()
	-- chrome.draw()
end

love.update = function()
	controls:update()
	sound:update()
	entities:update()
	updateGame()
	-- if g.started then updateGame() else start.update() end
end

love.draw = function()
	maid64.start()
	drawGame()
	-- if g.started then drawGame() else start.draw() end
	maid64.finish()
end


--------------------------------------
-- hacks
--------------------------------------

love.resize = function(width, height)
	maid64.resize(width, height)
end

love.run = function()
  if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
  if love.timer then love.timer.step() end
  local lag = 0
  return function()
    if love.event then
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == 'quit' then if not love.quit or not love.quit() then return a or 0 end end
        love.handlers[name](a,b,c,d,e,f)
      end
    end
    if love.timer then lag = math.min(lag + love.timer.step(), g.tickRate * 25) end
    while lag >= g.tickRate do
      if love.update then love.update(g.tickRate) end
      lag = lag - g.tickRate
    end
    if love.graphics and love.graphics.isActive() then
      love.graphics.origin()
      love.graphics.clear(love.graphics.getBackgroundColor())
      if love.draw then love.draw() end
      love.graphics.present()
    end
    if love.timer then love.timer.sleep(0.001) end
  end
end
