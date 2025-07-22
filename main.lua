local love = require("love")
local Gamestate = require("lib.hump.hump.gamestate")
menu = require "scripts.GameStates.menu"
gameplay = require "scripts.GameStates.gameplay"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end