Grid = require 'scripts.grid'
Card = require 'scripts.card'
local Plan = {}

local TILE_TYPES = {
    Empty = 1,

}
function Plan:enter(previous, ...)
    self.sprites = {}
    local grid = Grid:new(3, 3)
    self.sprites[1] = grid
    grid.x = 100
    grid.y = 100
    for i, image in ipairs({
        'assets/Square (outline)/bear.png',
        'assets/Square (outline)/buffalo.png',
        'assets/Square (outline)/chick.png',
        'assets/Square (outline)/chicken.png',
        'assets/Square (outline)/cow.png',
        'assets/Square (outline)/crocodile.png',
        'assets/Square (outline)/giraffe.png',
        'assets/Square (outline)/hippo.png',
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
    love.graphics.print("Plan Phase", 400, 300)
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
