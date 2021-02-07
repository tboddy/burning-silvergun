local x = 6
local y = 6
local offset = 10
local time_limit = (60 * 3)
local time_left = time_limit
local fade_interval = 10
local start_max = (60 * 4.5)
local function draw_score()
  return g.label(g["process-score"](g["current-score"]), x, y, nil, nil, nil, nil, true)
end
local function draw_time()
  local time_label = time_left
  local minutes = math.floor((time_left / 60))
  local seconds = string.format("%.2f", (time_left - (minutes * 60)))
  if (#seconds < 5) then
    seconds = ("0" .. seconds)
  end
  return g.label((minutes .. ":" .. string.gsub(seconds, "%.", ":")), nil, y, nil, "right", (g.width - x), nil, true)
end
local function draw_lives()
  local function _0_()
    if (player.entity.lives > 0) then
      return player.entity.lives
    else
      return 0
    end
  end
  return g.label(("x" .. _0_()), nil, (g.height - y - 8), nil, "right", (g.width - x), nil, true)
end
local function draw_big_overlay(label)
  local y0 = ((g.height / 2) - 8)
  if g["game-finished"] then
    y0 = (y0 - g.grid)
  end
  g["set-color"]("black")
  local function _1_()
    return love.graphics.rectangle("fill", 0, 0, g.width, g.height)
  end
  g.mask("half", _1_)
  g.label(label, nil, y0, nil, "center", nil, true, true)
  if (g["game-finished"] and g["no-miss"]) then
    y0 = (y0 + 20)
    return g.label("NO MISS! +10000", nil, y0, nil, "center", nil, true, true)
  end
end
local function draw_debug()
  if player.entity then
    return g.label(("COMBO " .. player.entity.combo), 6, (g.height - 8 - 5))
  end
end
local function draw_start()
  local _0_
  if g["hard-mode"] then
    _0_ = "HARD"
  else
    _0_ = "EASY"
  end
  g.label((_0_ .. " MODE START!"), nil, ((g.height / 2) - 8), nil, "center", nil, true, true)
  g["set-color"]("black")
  if (g["start-clock"] < fade_interval) then
    love.graphics.rectangle("fill", 0, 0, g.width, g.height)
  end
  if ((g["start-clock"] >= fade_interval) and (g["start-clock"] < (fade_interval * 2))) then
    local function _3_()
      return love.graphics.rectangle("fill", 0, 0, g.width, g.height)
    end
    g.mask("most", _3_)
  end
  if ((g["start-clock"] >= (fade_interval * 2)) and (g["start-clock"] < (fade_interval * 3))) then
    local function _4_()
      return love.graphics.rectangle("fill", 0, 0, g.width, g.height)
    end
    g.mask("half", _4_)
  end
  if ((g["start-clock"] >= (fade_interval * 3)) and (g["start-clock"] < (fade_interval * 4))) then
    local function _5_()
      return love.graphics.rectangle("fill", 0, 0, g.width, g.height)
    end
    g.mask("quarter", _5_)
  end
  return g["clear-color"]()
end
local saved_score = false
local function update_game_over()
  if not saved_score then
    if (g["hard-mode"] and (g["current-score"] > g["high-score-hard"])) then
      g["save-table"]["high-score-hard"] = g["current-score"]
    end
    if (not g["hard-mode"] and (g["current-score"] > g["high-score-easy"])) then
      g["save-table"]["high-score-easy"] = g["current-score"]
    end
    local save_str = bitser.dumps(g["save-table"])
    love.filesystem.write("score.lua", save_str)
    saved_score = true
    return nil
  end
end
local function _0_()
  if g.paused then
    draw_big_overlay("PAUSED")
  end
  if (g["game-over"] and not g["game-finished"] and not g["time-over"]) then
    draw_big_overlay("GAME OVER")
  end
  if (g["game-over"] and g["game-finished"]) then
    draw_big_overlay("GAME FINISHED")
  end
  if (g["game-over"] and g["time-over"]) then
    draw_big_overlay("TIME OVER")
  end
  if (not g.paused and (g["start-clock"] < start_max)) then
    draw_start()
  end
  if player.entity then
    draw_lives()
  end
  draw_score()
  return draw_time()
end
local function _1_()
  if (not g.paused and not g["game-over"] and not g["time-over"]) then
    time_left = (time_left - (1 / 60))
  end
  if (time_left <= 0) then
    time_left = 0
    g["game-over"] = true
    g["time-over"] = true
  end
  if not g.paused then
    g["start-clock"] = (g["start-clock"] + 1)
  end
  if g["game-over"] then
    return update_game_over()
  end
end
return {draw = _0_, update = _1_}
