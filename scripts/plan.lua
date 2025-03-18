Grid = require 'scripts.grid'
Card = require 'scripts.card'
GameManager = require 'scripts.game_manager'
local Plan = {}

local hand_cursor = love.mouse.newCursor('assets/cursors/hand_point.png', 0, 0)
local hand_open = love.mouse.newCursor('assets/cursors/hand_open.png', 0, 0)
local hand_closed = love.mouse.newCursor('assets/cursors/hand_closed.png', 0, 0)

function Plan:enter(previous, ...)
    local hand_cursor = love.mouse.newCursor('assets/cursors/hand_point.png', 0, 0)
    love.mouse.setCursor(hand_cursor)
    self.sprites = {}
    -- local grid = Grid:new(5, 6)
    local grid = GameManager:getInstance():loadGrid()
    self.sprites[1] = grid
    grid.x = love.graphics.getWidth() / 2 - grid.width / 2
    grid.y = love.graphics.getHeight() / 2 - grid.height / 2
    if grid:cardCount() == 0 then
        print("Adding cards")
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
            grid:add(math.floor(i / 3) + 1, i % 3 + 1, card)
        end
    end
end

function Plan:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
    -- Check for dragged card first (highest priority)
    if Card.currentlyDragged then
        love.mouse.setCursor(hand_closed)
    else
        -- Default cursor
        love.mouse.setCursor(hand_cursor)

        -- Check if hovering over any card in the grid
        local grid = self.sprites[1]
        for x = 1, grid.rows do
            for y = 1, grid.columns do
                local card = grid.grid[y][x]
                if card and card:isHovering() then
                    love.mouse.setCursor(hand_open)
                    break
                end
            end
        end
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
    GameManager:getInstance():saveGrid(self.sprites[1]:toObject())
    for _, sprite in pairs(self.sprites) do
        sprite:destroy()
    end
end

function Plan:keypressed(key)
    if key == 'escape' then
        Manager:enter(Game)
    end
end

return Plan
