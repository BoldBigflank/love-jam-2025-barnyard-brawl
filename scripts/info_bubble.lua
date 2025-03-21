class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
getImage = require 'scripts.images'
flux = require 'libraries.flux'
require 'scripts.constants'
local InfoBubble = class('InfoBubble', Sprite)

function InfoBubble:initialize(text)
    Sprite.initialize(self)
    self.text = text
    self.width = 200
    self.height = 100
    self.padding = 16
    self.font = love.graphics.getFont()
    self.children = {}
    self.x = 16
    self.y = 16
end

function InfoBubble:update(dt)
    Sprite.update(self, dt)
    -- local mouseX, mouseY = love.mouse.getPosition()
    -- local screenWidth = love.graphics.getWidth()
    -- local screenHeight = love.graphics.getHeight()

    -- if mouseX < screenWidth / 2 then
    --     self.x = mouseX + 32
    -- else
    --     self.x = mouseX - self.width - 32
    -- end

    -- if mouseY > screenHeight / 2 then
    --     self.y = mouseY - self.height - 32
    -- else
    --     self.y = mouseY + 32
    -- end

    local maxWidth = self.width - self.padding * 2
    local _, wrappedText = self.font:getWrap(self.text, maxWidth)
    local lineCount = #wrappedText
    self.height = self.font:getHeight() * lineCount + self.padding * 2
end

function InfoBubble:render()
    if self.text == "" then
        return
    end
    Sprite.render(self)
    local buttonColor = COLOR_BLUE_BUTTON
    -- Shadow
    love.graphics.setColor(COLOR_BUTTON_SHADOW)
    love.graphics.rectangle("fill", self.x + 8, self.y + 8, self.width, self.height, 16, 16)
    -- Inner border
    love.graphics.setColor(buttonColor.innerBorder)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 16, 16)

    -- Fill
    love.graphics.setColor(buttonColor.fill)
    love.graphics.rectangle("fill", self.x + 4, self.y + 4, self.width - 8, self.height - 8, 16, 16)

    -- Border
    love.graphics.setColor(buttonColor.border)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 16, 16)

    love.graphics.setColor(COLOR_WHITE)
    love.graphics.printf(self.text, self.x + self.padding, self.y + self.padding, self.width - self.padding * 2)
end

return InfoBubble
