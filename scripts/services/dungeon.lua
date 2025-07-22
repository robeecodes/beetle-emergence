local astray = require("lib.astray")

local Dungeon = {}
Dungeon.__index = Dungeon

local grass = love.graphics.newImage("assets/map/grass.png")
local mud = love.graphics.newImage("assets/map/mud.png")
local capsule = love.graphics.newImage("assets/img/capsule.png")

math.randomseed(os.time())

function Dungeon:new(width, height)
    local self = setmetatable({}, Dungeon)
    self.width = width
    self.height = height
    self.tileSize = 16
    self.tiles = {}
    self.symbols = {
        Wall = '#',
        Empty = ' ',
        DoorN = '|',
        DoorS = '|',
        DoorE = '-',
        DoorW = '-',
    }
    self.tiles = self:generate()
    self.pickups = self:_setPickups(self.tiles, math.random(8, 15)) -- Set pickups in the dungeon
    return self
end

function Dungeon:generate()
    local generator = astray.Astray:new(
        self.width,        -- Map width
        self.height,       -- Map height
        20,                   -- Change direction modifier (1-30)
        50,                   -- Sparseness modifier (25-70)
        70,                   -- Dead end removal modifier (50-99)
        astray.RoomGenerator:new( -- Room generator configuration
            6,                -- Number of rooms
            4, 8,             -- Min/Max room width
            4, 8              -- Min/Max room height
        )
    )

    local dungeon = generator:Generate()
    local rawTiles = generator:CellToTiles(dungeon, self.symbols)
    self:_updateWalls(rawTiles, #rawTiles, #rawTiles[1])
    return self:_fixTiles(rawTiles, #rawTiles, #rawTiles[1])
end

function Dungeon:draw()
    -- Draw the tiles
    for y = 1, #self.tiles[1] do
        for x = 1, #self.tiles do
            local tile = self.tiles[x][y]
            if tile == '#' or tile == 'O' then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.draw(grass, (x - 1) * self.tileSize, (y - 1) * self.tileSize)
            else
                love.graphics.setColor(0.8, 0.8, 0.8)
                love.graphics.draw(mud, (x - 1) * self.tileSize, (y - 1) * self.tileSize)
            end
        end
    end

    -- Draw the pickups
    for y = 1, #self.pickups do
        local pickup = self.pickups[y]
        if pickup then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(capsule, (pickup[1] - 1) * self.tileSize, (pickup[2] - 1) * self.tileSize)
        end
    end
end

function Dungeon:_updateWalls(tiles, width, height)
    local block = false
    for y = 0, height do
        for x = 0, width do
            if tiles[x] and tiles[x][y] == '#' then
                tiles[x][y] = block and '#' or 'O'
            end
            block = not block
        end
    end
end

function Dungeon:_fixTiles(tiles, width, height)
    local fixed = {}
    for y = 0, height do
        for x = 0, width do
            if not fixed[x + 1] then fixed[x + 1] = {} end
            fixed[x + 1][y + 1] = tiles[x][y]
        end
    end
    return fixed
end

function Dungeon:_findRooms(tiles)
    local candidates = {}

    for x = 1, #tiles - 1 do
        for y = 1, #tiles[1] - 1 do
            if tiles[x][y]     == ' ' and
               tiles[x+1][y]   == ' ' and
               tiles[x][y+1]   == ' ' and
               tiles[x+1][y+1] == ' ' then

                table.insert(candidates, {x, y})
            end
        end
    end

    return candidates
end


function Dungeon:_setPickups(tiles, count)
    local rooms = Dungeon:_findRooms(tiles)
    local pickups = {}

    for i = 1, math.min(count, #rooms) do
        local index = love.math.random(#rooms)
        local pos = table.remove(rooms, index)
        table.insert(pickups, pos)
    end

    return pickups
end

return Dungeon
