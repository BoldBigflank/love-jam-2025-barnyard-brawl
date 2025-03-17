Grid = require 'scripts.grid'
Card = require 'scripts.card'
local Plan = {}

local TILE_TYPES = {
    Empty = 1,

}
function Plan:enter(previous, ...)
    self.sprites = {}
    local grid = Grid:new(5, 6)
    self.sprites[1] = grid
    grid.x = love.graphics.getWidth() / 2 - grid.width / 2
    grid.y = love.graphics.getHeight() / 2 - grid.height / 2
    for i, image in ipairs({
        'bear',
        'buffalo',
        'chick',
        'chicken',
        'cow',
        'crocodile',
        'giraffe',
        'hippo',
    }) do
        local card = Card(image)
        card.width = 100
        card.height = 100
        grid:add(math.floor(i / 3) + 1, i % 3 + 1, card)
    end
end

function Plan:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
end

function Plan:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Gold: " .. GameManager:getInstance().currentGold, 400, 0)
    for _, sprite in pairs(self.sprites) do
        sprite:render()
    end
end

function Plan:leave(next, ...)
    for _, sprite in pairs(self.sprites) do
        sprite:destroy()
    end
end

function Plan:keypressed(key)
    if key == 'escape' then
        Manager:push(Game)
    end
end

return Plan
