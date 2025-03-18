Plan = require 'scripts.plan'
Button = require 'scripts.button'
local Title = {}
require('scripts.constants')

function Title:enter(previous, ...)
    print('title')
    self.button = Button:new('Play')
    self.button.x = 0.5 * love.graphics.getWidth() - 0.5 * self.button.width
    self.button.y = 0.75 * love.graphics.getHeight() - 0.5 * self.button.height
    self.button.onTouch = function()
        Manager:push(Plan)
    end
    --button:new(code, text, x, y, textColor, font, color)
end

function Title:update(dt)
    self.button:update(dt)
end

function Title:draw()
    love.graphics.setColor(1, 1, 1)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    love.graphics.printf("Intro Screen", 0, screenHeight / 2 - 32, screenWidth, 'center')
    self.button:render()
end

function Title:leave(next, ...)
    print('title leave')
end

function Title:buttonPressed()
    Manager:push(Plan)
end

function Title:keypressed(key)
    if key == 'space' then
        Manager:push(Plan)
    end
end

return Title
