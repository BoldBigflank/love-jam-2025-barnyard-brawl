Grid = require 'scripts.grid'
Card = require 'scripts.card'
Button = require 'scripts.button'
GameManager = require 'scripts.game_manager'
InfoBubble = require 'scripts.info_bubble'
require('scripts.constants')
local Game = {}

function Game:enter(previous, ...)
    love.mouse.setCursor(CURSOR_HAND)
    self.sprites = {}
    GameManager:getInstance():changeState("game")
    Card.currentlyDragged = nil
    local grid = GameManager:getInstance():loadGrid()
    table.insert(self.sprites, grid)
    grid.x = love.graphics.getWidth() / 2 - grid.width / 2
    grid.y = love.graphics.getHeight() / 2 - grid.height / 2

    -- Load buttons
    local button = Button:new('Start')
    button.color = "red"
    button.x = love.graphics.getWidth() - button.width - 20
    button.y = love.graphics.getHeight() - button.height - 20
    button.onTouch = function()
        GameManager:getInstance():changeState("game-active")
    end
    table.insert(self.sprites, button)
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)
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
        sprite:render()
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
