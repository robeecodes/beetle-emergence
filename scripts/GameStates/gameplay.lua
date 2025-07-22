local ripple = require("lib.ripple.ripple")
local Gamestate = require("lib.hump.hump.gamestate")

local Player = require("scripts.entities.player")
local Dungeon = require("scripts.services.dungeon")
local Camera = require("lib.hump.hump.camera")
local music = require("scripts.services.music_service")
local exit_game = require("scripts.services.exit_game")

local dungeon
local player
local camera
local view_radius = 75 -- Radius of visibility around the player

local pickup_source = love.audio.newSource("assets/SFX/pickup.mp3", "static")
local pickup_SFX = ripple.newSound(pickup_source, {
  volume = .25,
  loop = false,
})

local total_pickups -- Total number of pickups to spawn
local collected_pickups = 0 -- Counter for collected pickups

local gameplay = {}

function gameplay:enter()
    gameplay:init()
end

function gameplay:init()
    dungeon = Dungeon:new(35, 35)
    total_pickups = #dungeon.pickups
    collected_pickups = 0
    view_radius = 75 -- Reset view radius
    player = Player:new(dungeon.tiles)
    camera = Camera(player.x * dungeon.tileSize, player.y * dungeon.tileSize)
    camera:zoom(2)          -- Set initial zoom level

    music.play_game_track() -- Play the gameplay background music
end

function gameplay:update(dt)
    player:update(dt, dungeon.tiles)
    camera:lookAt(player.x * dungeon.tileSize, player.y * dungeon.tileSize)
    gameplay:collect_pickup()
end

function gameplay:draw()
    camera:attach()
    dungeon:draw()
    player:draw(dungeon.tileSize)

    love.graphics.stencil(function()
        love.graphics.circle("fill",
            (player.x - 0.5) * dungeon.tileSize,
            (player.y - 0.5) * dungeon.tileSize,
            view_radius) -- Radius of visibility
    end, "replace", 1)

    love.graphics.setStencilTest("less", 1)
    love.graphics.setColor(0, 0, 0, 1)                -- Darkness color
    love.graphics.rectangle("fill", 0, 0, 4000, 4000) -- Fill the entire screen with darkness
    love.graphics.setStencilTest()
    camera:detach()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20)) -- Set font size for text
    love.graphics.print("Collectibles: " .. tostring(collected_pickups or 0) .. '/' .. tostring(total_pickups), 10, 10)

end

function gameplay:keypressed(key, isrepeat)
    exit_game(key)

    if key == "f2" then
        Gamestate.switch(menu) -- Switch to menu state on escape
    end
end

function gameplay:collect_pickup(pickup)
    -- Handle pickup collection logic here
    -- Check for pickup collisions
    for i = #dungeon.pickups, 1, -1 do
        local px, py = dungeon.pickups[i][1], dungeon.pickups[i][2]
        if math.floor(player.x) == px and math.floor(player.y) == py then
            table.remove(dungeon.pickups, i)
            view_radius = view_radius + 15 -- Increase view radius on pickup
            pickup_SFX:play() -- Play pickup sound effect
            collected_pickups = collected_pickups + 1 -- Increment collected pickups
            if collected_pickups >= total_pickups then
                Gamestate.switch(menu) -- Switch to menu when all pickups are collected
            end
        end
    end
end

return gameplay
