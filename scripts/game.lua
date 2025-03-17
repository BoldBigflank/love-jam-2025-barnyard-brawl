local Game = {}

local TILE_TYPES = {
    Empty = 1,

}

local grid = {
    { 0, 1, 0 },
    { 0, 0, 0 },
    { 0, 0, 0 }
}

function Game:enter(previous, ...)
    self.sprites = {}
    self.sprites[1] = Sprite('assets/Square (outline)/bear.png')
end

function Game:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
end

function Game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game Phase", 400, 300)
    for _, sprite in pairs(self.sprites) do
        sprite:draw()
    end
end

function Game:leave(next, ...)
    for _, sprite in pairs(self.sprites) do
        sprite:destroy()
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        Manager:push(Title)
    end
end

return Game
