Grid = require 'scripts.grid'
Card = require 'scripts.card'
Button = require 'scripts.button'
GameManager = require 'scripts.game_manager'
InfoBubble = require 'scripts.info_bubble'
require('scripts.constants')
local Plan = {}

function Plan:enter(previous, ...)
    love.mouse.setCursor(CURSOR_HAND)
    self.sprites = {}
    -- Load grid
    local grid = GameManager:getInstance():loadGrid()
    table.insert(self.sprites, grid)
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
    -- Load buttons
    local button = Button:new('Battle')
    button.color = "red"
    button.x = love.graphics.getWidth() - button.width - 20
    button.y = love.graphics.getHeight() - button.height - 20
    button.onTouch = function()
        Manager:enter(Game)
    end
    table.insert(self.sprites, button)
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)
end

function Plan:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
    -- Check for dragged card first (highest priority)
    if Card.currentlyDragged then
        love.mouse.setCursor(CURSOR_HAND_CLOSED)
    else
        -- Default cursor
        love.mouse.setCursor(CURSOR_HAND_OPEN)

        -- Check if hovering over any card in the grid
        local grid = Sprite.findByName(self.sprites, "Grid")
        self.infoBubble.text = ""
        if grid then
            for x = 1, grid.rows do
                for y = 1, grid.columns do
                    local card = grid.grid[y][x]
                    if card and card:isHovering() then
                        love.mouse.setCursor(CURSOR_HAND_OPEN)
                        self.infoBubble.text = card.description
                        break
                    end
                end
            end
        end
    end
end

function Plan:draw()
    love.graphics.setColor(1, 1, 1)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    love.graphics.printf("Gold: " .. GameManager:getInstance().currentGold,
        0,
        0,
        screenWidth,
        'center'
    )
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
