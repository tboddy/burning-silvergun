local clock = 0
local overlay_type = 4
local scene = 1
local offset = 14
local s_offset = 10
local fade_interval = 10
local images = nil
local starting = false
local function trigger_overlay(trigger, type)
  if (clock >= trigger) then
    overlay_type = type
    return nil
  end
end
local function draw_overlay()
  local m_type = nil
  if (overlay_type == 1) then
    m_type = "quarter"
  else
    if (overlay_type == 2) then
      m_type = "half"
    else
      m_type = "most"
    end
  end
  g["set-color"]("black")
  if (overlay_type == 4) then
    love.graphics.rectangle("fill", 0, 0, g.width, g.height)
  else
    local function _1_()
      return love.graphics.rectangle("fill", 0, 0, g.width, g.height)
    end
    g.mask(m_type, _1_)
  end
  return g["clear-color"]()
end
local function update_splash(next)
  local limit = (60 * 4)
  trigger_overlay(fade_interval, 3)
  trigger_overlay((fade_interval * 2), 2)
  trigger_overlay((fade_interval * 3), 1)
  trigger_overlay((fade_interval * 4), 0)
  trigger_overlay(limit, 1)
  trigger_overlay((limit + fade_interval), 2)
  trigger_overlay((limit + (fade_interval * 2)), 3)
  trigger_overlay((limit + (fade_interval * 3)), 4)
  if (clock >= (limit + (fade_interval * 6))) then
    scene = next
    clock = -1
    return nil
  end
end
local function draw_splash_1()
  local y = ((g.height / 2) - offset)
  g.label("THE ISOLATION CARAVAN", nil, y, nil, "center", nil, nil, true)
  y = (y + offset)
  return g.label("TOUHOU GAME JAM VOL.6", nil, y, nil, "center", nil, nil, true)
end
local function draw_splash_2()
  local bee_x = ((g.width / 2) - (g["img-width"](images.bee) / 2))
  local y = (g.grid * 3.25)
  love.graphics.draw(images.bee, bee_x, y)
  y = (y + (1.25 * g.grid) + g["img-height"](images.bee))
  g.label("PROGRAMMING, DESIGN,", nil, y, nil, "center", nil, nil, true)
  y = (y + offset)
  g.label("ART, AND SOUND", nil, y, nil, "center", nil, nil, true)
  y = (y + offset)
  return g.label("2021 T.BODDY", nil, y, nil, "center", nil, nil, true)
end
local menu_items = {"START EASY", "START HARD", "HOW TO", "FULLSCREEN", "EXIT"}
local active_menu = 1
local can_move = false
local moving = false
local choosing = false
local function draw_title()
  local x = (4 + ((g.width / 2) - (g["img-width"](images.title) / 2)))
  local y = (g.grid * 1.5)
  g["set-color"]("black")
  love.graphics.draw(images["title-shadow"], x, y)
  g["set-color"]("yellow")
  love.graphics.draw(images.title, x, y)
  g["set-color"]("off-white")
  love.graphics.draw(images["title-top"], x, y)
  return g["clear-color"]()
end
local function choose_menu_item()
  if ((active_menu == 1) or (active_menu == 2)) then
    if (active_menu == 2) then
      g["hard-mode"] = true
    else
      g["hard-mode"] = false
    end
    clock = -1
    sound["stop-bgm"]()
    sound["play-sfx"]("start")
    starting = true
  end
  if (active_menu == 3) then
    sound["play-sfx"]("menuchange")
    scene = 4
  end
  if (active_menu == 4) then
    g["toggle-fullscreen"]()
  end
  if (active_menu == 5) then
    return love.event.quit()
  end
end
local function update_menu_controls()
  if (not moving and controls.up()) then
    active_menu = (active_menu - 1)
    moving = true
  end
  if (not moving and controls.down()) then
    active_menu = (active_menu + 1)
    moving = true
  end
  if (not controls.up() and not controls.down()) then
    moving = false
  end
  if (active_menu < 1) then
    active_menu = #menu_items
  end
  if (active_menu > #menu_items) then
    active_menu = 1
  end
  if ((controls["shot-1"]() or controls["shot-2"]()) and not choosing) then
    choosing = true
    choose_menu_item()
  end
  if (not controls["shot-1"]() and not controls["shot-2"]()) then
    choosing = false
    return nil
  end
end
local played_bgm = false
local function update_menu()
  if not played_bgm then
    played_bgm = true
    sound["play-bgm"]("start")
  end
  trigger_overlay(fade_interval, 3)
  trigger_overlay((fade_interval * 2), 2)
  trigger_overlay((fade_interval * 3), 1)
  trigger_overlay((fade_interval * 4), 0)
  if (clock >= (fade_interval * 5)) then
    can_move = true
    return update_menu_controls()
  end
end
local function update_starting()
  trigger_overlay(fade_interval, 1)
  trigger_overlay((fade_interval * 2), 2)
  trigger_overlay((fade_interval * 3), 3)
  trigger_overlay((fade_interval * 4), 4)
  if (clock >= (fade_interval * 5)) then
    g.started = true
    return g["init-game"]()
  end
end
local function menu_arrow(x, y)
  local size = 8
  return love.graphics.polygon("fill", x, y, (x + size), (y + (size / 2)), x, (y + size))
end
local function draw_menu()
  local is_fs = love.window.getFullscreen()
  local y = ((g.grid * 8.75) - 2)
  for i = 1, #menu_items do
    local label = menu_items[i]
    if (is_fs and (i == 4)) then
      label = "WINDOWED"
    end
    g.label(label, nil, y, nil, "center", nil, nil, true)
    if (can_move and (i == active_menu)) then
      local x = (g.grid * 4.25)
      g["set-color"]("black")
      menu_arrow((x - 1), y)
      menu_arrow((x + 1), y)
      menu_arrow(x, (y - 1))
      menu_arrow(x, (y + 1))
      menu_arrow((x - 1), (y - 1))
      menu_arrow((x - 1), (y + 1))
      menu_arrow((x + 1), (y - 1))
      menu_arrow((x + 1), (y + 1))
      g["set-color"]("red")
      menu_arrow(x, y)
    end
    y = (y + offset)
  end
  return nil
end
local function draw_scores()
  local x = 8
  local y = (g.height - 16)
  g.label("HI EASY", x, (y - s_offset), nil, nil, nil, nil, true)
  g.label(g["process-score"](g["high-score-easy"]), x, y, nil, nil, nil, nil, true)
  x = (g.width - x)
  g.label("HI HARD", nil, (y - s_offset), nil, "right", x, nil, true)
  return g.label(g["process-score"](g["high-score-hard"]), nil, y, nil, "right", x, nil, true)
end
local controls_limit_1 = (g.width - (g.grid * 5.5))
local controls_limit_2 = (g.width - (g.grid * 4))
local controls_limit_3 = (g.width - (g.grid * 6))
local controls_limit_4 = (g.width - (g.grid * 3.5))
local controls_limit_5 = (g.width - (g.grid * 7.5))
local controls_limit_6 = (g.width - (g.grid * 5))
local controls_labels = {{big = true, label = "KEYBOARD", margin = 16}, {label = "MOVE: ARROW KEYS"}, {label = "SHOT 1: Z", limit = controls_limit_1}, {label = "SHOT 2: X", limit = controls_limit_1}, {label = "PAUSE: ESC", limit = controls_limit_2}, {label = "FULLSCREEN: F", limit = controls_limit_5}, {label = "RESTART: R", limit = controls_limit_3, margin = 12}, {big = true, label = "GAMEPAD", margin = 16}, {label = "MOVE: DPAD/LSTICK"}, {label = "SHOT 1: A", limit = controls_limit_3}, {label = "SHOT 2: B", limit = controls_limit_3}, {label = "PAUSE: START", limit = controls_limit_4}, {label = "RESTART: BACK", limit = controls_limit_6, margin = 14}, {label = "ANY SHOT TO RETURN"}}
local function draw_controls()
  local y = 20
  for i = 1, #controls_labels do
    local row = controls_labels[i]
    local limit = nil
    if row.limit then
      limit = row.limit
    else
      limit = g.width
    end
    if ((i ~= 1) and (i ~= 8) and (i ~= #controls_labels)) then
      limit = (limit + (g.grid * 2))
      if (i > 8) then
        limit = (limit + 8)
      end
    end
    local _2_
    if row.big then
      _2_ = true
    else
      _2_ = nil
    end
    g.label(row.label, nil, y, nil, "center", limit, _2_, true)
    local _4_
    if row.margin then
      _4_ = row.margin
    else
      _4_ = 0
    end
    y = (y + _4_ + s_offset)
  end
  return nil
end
local function update_controls()
  if ((controls["shot-1"]() or controls["shot-2"]()) and not choosing) then
    choosing = true
    sound["play-sfx"]("menuchange")
    scene = 3
  end
  if (not controls["shot-1"]() and not controls["shot-2"]()) then
    choosing = false
    return nil
  end
end
local function _0_()
  g["set-color"]("black")
  love.graphics.rectangle("fill", 0, 0, g.width, g.height)
  g["clear-color"]()
  if (scene == 1) then
    draw_splash_1()
  end
  if (scene == 2) then
    draw_splash_2()
  end
  if ((scene == 3) or (scene == 4)) then
    love.graphics.draw(images.bg, 0, 0)
  end
  if (scene == 3) then
    draw_title()
    draw_menu()
    draw_scores()
  end
  if (scene == 4) then
    draw_controls()
  end
  if (0 < overlay_type) then
    return draw_overlay()
  end
end
local function _1_()
  images = g.images("start", {"bee", "ilya", "bg", "title", "title-shadow", "title-top"})
  return nil
end
local function _2_()
  if (scene == 1) then
    update_splash(2)
  end
  if (scene == 2) then
    update_splash(3)
  end
  if (scene == 3) then
    update_menu()
  end
  if (scene == 4) then
    update_controls()
  end
  if starting then
    update_starting()
  end
  clock = (clock + 1)
  return nil
end
return {draw = _0_, init = _1_, update = _2_}
