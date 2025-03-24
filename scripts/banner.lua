require('scripts.constants')
local Sprite = require("scripts.sprite")
local Banner = class('Banner', Sprite)

function Banner:initialize()
    Sprite.initialize(self)
    self.name = "Banner"
    self.x = love.graphics.getWidth()
    self.y = 0.25 * love.graphics.getHeight()
    self.width = love.graphics.getWidth()
    self.height = 0.25 * love.graphics.getHeight()
    self.color = COLOR_WHITE
    self.text = ""
    self.font = Font_96
    self.levelWon = false
end

function Banner:render()
    local color = self.levelWon and COLOR_BLUE_BUTTON or COLOR_RED_BUTTON
    love.graphics.setColor(color.border)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(color.innerBorder)
    love.graphics.rectangle('fill', self.x, self.y + 16, self.width, self.height - 32)


    love.graphics.setColor(color.fill)
    love.graphics.rectangle('fill', self.x, self.y + 32, self.width, self.height - 64)

    love.graphics.setColor(COLOR_BLACK)
    love.graphics.printf(self.text, self.font, self.x, self.y + 0.5 * self.height - 0.5 * self.font:getHeight(self.text),
        self.width, 'center')
end

return Banner
