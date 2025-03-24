Grid = require 'scripts.grid'
Card = require 'scripts.card'
Button = require 'scripts.button'
GameManager = require 'scripts.game_manager'
InfoBubble = require 'scripts.info_bubble'
require('scripts.constants')
getImage = require 'scripts.images'
local Plan = {}

function Plan:enter(previous, ...)
    love.mouse.setCursor(CURSOR_HAND)
    self.sprites = {}
    GameManager:getInstance():changeState("shop")
    Card.currentlyDragged = nil
    -- Load grid
    local grid = GameManager:getInstance():loadGrid()
    table.insert(self.sprites, grid)
    grid.x = love.graphics.getWidth() / 2 - grid.width / 2
    grid.y = love.graphics.getHeight() / 2 - grid.height / 2

    -- Load buttons
    local button = Button:new('Battle')
    button.color = "red"
    button.x = love.graphics.getWidth() - button.width - 20
    button.y = love.graphics.getHeight() - button.height - 20
    button.onTouch = function()
        Manager:enter(Game)
    end
    self.button = button
    table.insert(self.sprites, button)
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)

    local shopBubble = InfoBubble:new("Move animals to the bottom half to purchase them.")
    shopBubble.width = 200
    shopBubble.x = love.graphics.getWidth() - shopBubble.width - 20
    shopBubble.y = 20
    table.insert(self.sprites, shopBubble)
    self.goldImage = getImage('assets/puzzle/Coins/coin_22.png')
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
    love.graphics.printf("Shop Phase", 0, 16, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    love.graphics.draw(self.goldImage, self.button.x, self.button.y - 48, 0, 0.32, 0.32)
    love.graphics.printf(GameManager:getInstance().currentGold,
        self.button.x + 48,
        self.button.y - 48,
        screenWidth,
        'left'
    )
    for _, sprite in pairs(self.sprites) do
        sprite:render()
    end
end

function Plan:leave(next, ...)
    GameManager:getInstance():saveGrid(Sprite.findByName(self.sprites, "Grid"))
    for _, sprite in pairs(self.sprites) do
        sprite:destroy()
    end
end

return Plan
