local indicators = {}
local function _0_()
  __fnl_global__class_2dindicator.indicators = indicators
  return nil
end
local function _1_(indicator)
  return g.label(indicator.label, (indicator.x - (g.width / 2)), indicator.y, "yellow", "center")
end
local function _2_()
  for i = 1, 64 do
    table.insert(indicators, {})
  end
  return nil
end
local function _3_(x, y, label)
  local indicator = g["get-item"](indicators)
  indicator.active = true
  indicator.clock = 0
  indicator.x = math.floor(x)
  indicator.y = math.floor(y)
  local x_limit = (g.width - (g.grid * 2.5))
  if (indicator.x > x_limit) then
    indicator.x = x_limit
  end
  indicator.label = label
  return nil
end
local function _4_(indicator)
  if (indicator.clock >= 120) then
    indicator.active = false
  end
  if ((indicator.clock % 3) == 0) then
    indicator.y = (indicator.y - 1)
  end
  indicator.clock = (indicator.clock + 1)
  return nil
end
return {["update-entities"] = _0_, draw = _1_, indicators = {}, init = _2_, spawn = _3_, update = _4_}
