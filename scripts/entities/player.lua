local Player = {}
Player.__index = Player

function Player:new(tiles)
    local self = setmetatable({}, Player)
    self.x, self.y = self:spawn(tiles)
    self.timeSinceMove = 0
    self.moveCooldown = 0.05                                     -- Cooldown time in seconds
    self.sprite = love.graphics.newImage("assets/img/player.png") -- Load player sprite
    self.rotation = 0                                             -- Initial rotation
    return self
end

function Player:draw(tileSize)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    love.graphics.draw(
    self.sprite,
    (self.x - 1) * tileSize + tileSize / 2,
    (self.y - 1) * tileSize + tileSize / 2,
    self.rotation,                                -- rotation (optional)
    tileSize / self.sprite:getWidth(),            -- scale x
    tileSize / self.sprite:getHeight(),           -- scale y
    self.sprite:getWidth() / 2,                   -- origin x
    self.sprite:getHeight() / 2                   -- origin y
)

end

function Player:update(dt, tiles)
    self.timeSinceMove = self.timeSinceMove + dt
    if self.timeSinceMove < self.moveCooldown then return end
    self:move(tiles)
end

function Player:spawn(tiles)
    for y = 1, #tiles[1] do
        for x = 1, #tiles do
            if tiles[x][y] == ' ' then
                return x, y -- Return the first empty tile found
            end
        end
    end
end

local function isPressed(keys)
    for _, key in ipairs(keys) do
        if love.keyboard.isDown(key) then return true end
    end
    return false
end

function Player:move(tiles)
    local dx, dy = 0, 0

    if isPressed({ "up", "w" }) then
        dy = -1
        self.rotation = 0 -- Face up
    end
    if isPressed({ "down", "s" }) then
        dy = 1
        self.rotation = math.pi -- Face down
    end
    if isPressed({ "left", "a" }) then
        dx = -1
        self.rotation = -math.pi / 2 -- Face left
    end
    if isPressed({ "right", "d" }) then
        dx = 1
        self.rotation = math.pi / 2 -- Face right
    end

    local newX, newY = self.x + dx, self.y + dy
    if tiles[newX] and tiles[newX][newY] and tiles[newX][newY] ~= '#' and tiles[newX][newY] ~= 'O' then
        self.x, self.y = newX, newY
        self.timeSinceMove = 0 -- Reset cooldown after a successful move
    end
end

return Player
