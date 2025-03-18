Plan = require 'scripts.plan'

local Title = {}

function Title:enter(previous, ...)
    print('title')
end

function Title:update(dt)
    -- print('title update')
end

function Title:draw()
    love.graphics.setColor(1, 1, 1)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    love.graphics.printf("Intro Screen", 0, screenHeight / 2 - 32, screenWidth, 'center')
end

function Title:leave(next, ...)
    print('title leave')
end

function Title:keypressed(key)
    if key == 'space' then
        Manager:push(Plan)
    end
end

return Title
