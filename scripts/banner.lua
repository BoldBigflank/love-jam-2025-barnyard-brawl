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
end

function Banner:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(COLOR_BLACK)
    love.graphics.print(self.text, self.x, self.y)
end

return Banner
