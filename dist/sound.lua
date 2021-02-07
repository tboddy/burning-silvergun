local current_sound = nil
local sfx_names = {"bullet1", "bullet2", "bullet3", "explosion1", "explosion2", "gameover", "menuchange", "playerhit", "playershot", "start", "bonus"}
local sfx_files = {}
local sfx_volume = 0.5
local bgm_names = {"start", "stage-intro", "stage-loop"}
local bgm_files = {}
local bgm_volume = 1
local function _0_(bgm_name)
  for i = 1, #bgm_names do
    local name = bgm_names[i]
    local file = bgm_files[name]
    if file:isPlaying() then
      file:stop()
    end
  end
  local play_file = bgm_files[bgm_name]
  return play_file:play()
end
local function _1_(name)
  local file = sfx_files[name]
  if file:isPlaying() then
    file:stop()
  end
  return file:play()
end
local function _2_()
  for i = 1, #bgm_names do
    local name = bgm_names[i]
    local file = bgm_files[name]
    if file:isPlaying() then
      file:stop()
    end
  end
  return nil
end
local function _3_()
  for i = 1, #sfx_names do
    local name = sfx_names[i]
    sfx_files[name] = love.audio.newSource(("sfx/" .. name .. ".wav"), "static")
    local file = sfx_files[name]
    file:setVolume(sfx_volume)
    if (name == "playershot") then
      file:setVolume(0.3)
    end
    if ((name == "bullet1") or (name == "bullet2") or (name == "bullet3")) then
      file:setVolume(0.45)
    end
  end
  for i = 1, #bgm_names do
    local name = bgm_names[i]
    bgm_files[name] = love.audio.newSource(("bgm/" .. name .. ".mp3"), "static")
    local file = bgm_files[name]
    file:setVolume(bgm_volume)
    if (name == "stage-loop") then
      file:setLooping(true)
    end
  end
  return nil
end
local function _4_()
  sound["playing-bgm"] = false
  for i = 1, #bgm_names do
    local name = bgm_names[i]
    local file = bgm_files[name]
    if file:isPlaying() then
      sound["playing-bgm"] = true
    end
  end
  return nil
end
return {["play-bgm"] = _0_, ["play-sfx"] = _1_, ["playing-bgm"] = false, ["stop-bgm"] = _2_, init = _3_, update = _4_}
