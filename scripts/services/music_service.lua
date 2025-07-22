local ripple = require("lib.ripple.ripple")
local menu_source = love.audio.newSource("assets/BGM/menu.mp3", "stream")
local game_source = love.audio.newSource("assets/BGM/gameplay.mp3", "stream")

local M = {}

local instance = nil

local menu_BGM = ripple.newSound(menu_source, {
  volume = .25,
  loop = true,
})

local game_BGM = ripple.newSound(game_source, {
  volume = .25,
  loop = true,
})

function M.play_menu_track()
    if instance then
        instance:stop()
        instance = nil
    end
    instance = menu_BGM:play()
end

function M.play_game_track()
    if instance then
        instance:stop()
        instance = nil
    end
    instance = game_BGM:play()
end

return M