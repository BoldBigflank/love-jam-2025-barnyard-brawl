Plan = require 'scripts.plan'
Button = require 'scripts.button'
require('scripts.constants')
getImage = require 'scripts.images'
local Title = {}

function Title:enter(previous, ...)
    local gm = GameManager:getInstance()
    local buttonText = gm.gameInProgress and 'Continue' or 'New Game'
    if gm.lives <= 0 then
        buttonText = 'New Game'
    end
    self.button = Button:new(buttonText)
    self.button.x = 0.5 * love.graphics.getWidth() - 0.5 * self.button.width
    self.button.y = 0.75 * love.graphics.getHeight() - 0.5 * self.button.height
    self.button.onTouch = function()
        local gm = GameManager:getInstance()
        if not gm.gameInProgress then
            gm:reset()
        end
        Manager:enter(Plan)
    end
    if gm.gameInProgress then
        self.abandonButton = Button:new('Abandon Run')
        self.abandonButton.color = 'red'
        self.abandonButton.x = 0.5 * love.graphics.getWidth() - 0.5 * self.abandonButton.width
        self.abandonButton.y = 0.85 * love.graphics.getHeight() - 0.5 * self.abandonButton.height
        self.abandonButton.onTouch = function()
            gm:reset()
            Manager:enter(Title)
        end
    end
    --button:new(code, text, x, y, textColor, font, color)
    self.winImage = getImage('assets/icons/award.png')
    self.lossImage = getImage('assets/icons/skull.png')
    self.pendingImage = getImage('assets/icons/rhombus_outline.png')
end

function Title:update(dt)
    self.button:update(dt)
    if self.abandonButton then
        self.abandonButton:update(dt)
    end
end

function Title:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    -- Title
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Barnyard Brawl", 0, 32, screenWidth, 'center')
    self.button:render()
    if self.abandonButton then
        self.abandonButton:render()
    end
    local gm = GameManager:getInstance()
    if gm.gameInProgress then
        love.graphics.setColor(COLOR_WHITE)
        -- Lives left
        love.graphics.printf("Lives left: " .. gm.lives, 0, 100, screenWidth, 'center')
        -- Current Gold
        love.graphics.printf("Current Gold: " .. gm.currentGold, 0, 132, screenWidth, 'center')
        -- Last outcome
        love.graphics.setColor(COLOR_YELLOW)
        love.graphics.printf(gm.lastOutcome, 0, 164, screenWidth, 'center')
        love.graphics.setColor(COLOR_WHITE)
        -- Outcomes
        local latestOutcomeIndex = 0
        for i = 1, gm.maxLevel do
            if gm.outcomes[i] ~= "Pending" then
                latestOutcomeIndex = i
            end
        end

        local flashDuration = 0.4 -- 400ms
        self.flashTimer = (self.flashTimer or 0) + love.timer.getDelta()
        local flashColor = (math.floor(self.flashTimer / flashDuration) % 2 == 0) and COLOR_YELLOW or
            COLOR_WHITE

        for i = 1, gm.maxLevel do
            local iconWidth = self.pendingImage:getWidth()
            local x = 0.5 * love.graphics.getWidth() - 0.5 * (iconWidth * gm.maxLevel) + (iconWidth * (i - 1))
            local y = 196
            love.graphics.setColor(i == latestOutcomeIndex and flashColor or COLOR_WHITE)
            if gm.outcomes[i] == "Pending" then
                love.graphics.draw(self.pendingImage, x, y)
            elseif gm.outcomes[i] == "Win" then
                love.graphics.draw(self.winImage, x, y)
            elseif gm.outcomes[i] == "Loss" then
                love.graphics.draw(self.lossImage, x, y)
            end
        end
    end
    -- Game Over line
    if gm.lives <= 0 then
        love.graphics.printf("Game Over", 0, 260, screenWidth, 'center')
    end
end

function Title:leave(next, ...)
    print('title leave')
end

return Title
