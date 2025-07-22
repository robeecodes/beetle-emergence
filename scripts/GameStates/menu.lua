local love = require("love")
local Gamestate = require("lib.hump.hump.gamestate")
local music = require("scripts.services.music_service")
local exit_game = require("scripts.services.exit_game")

local menu = {}

local titleScreen = love.graphics.newImage("assets/img/splash.png")

function menu:enter()
    menu:init()
end

function menu:init()
    music.play_menu_track() -- Play the menu background music
end

function menu:draw()
    love.graphics.draw(titleScreen, 0, 0, 0, love.graphics.getWidth() / titleScreen:getWidth(), love.graphics.getHeight() / titleScreen:getHeight())
end

function menu:keypressed(key, isrepeat)
    exit_game(key)
    if key == "Enter" or key == "return" then
        Gamestate.switch(gameplay)
    end
end

return menu