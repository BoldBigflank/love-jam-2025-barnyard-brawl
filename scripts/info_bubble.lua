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
end

function InfoBubble:update(dt)
    Sprite.update(self, dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    if mouseX < screenWidth / 2 then
        self.x = mouseX + 32
    else
        self.x = mouseX - self.width - 32
    end

    if mouseY > screenHeight / 2 then
        self.y = mouseY - self.height - 32
    else
        self.y = mouseY + 32
    end

    local maxWidth = self.width - self.padding * 2
    local _, wrappedText = self.font:getWrap(self.text, maxWidth)
    local lineCount = #wrappedText
    self.height = self.font:getHeight() * lineCount + self.padding * 2
end

function InfoBubble:render()
    Sprite.render(self)

    love.graphics.setColor(COLOR_BLACK)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 16, 16)

    love.graphics.setColor(COLOR_WHITE)
    love.graphics.printf(self.text, self.x + self.padding, self.y + self.padding, self.width - self.padding * 2)
end

return InfoBubble
