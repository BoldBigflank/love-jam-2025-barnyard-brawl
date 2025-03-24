require('scripts.constants')
local Sprite = require("scripts.sprite")
local Button = class('Button', Sprite)

function Button:initialize(text)
    Sprite.initialize(self)
    self.text = text
    self.hovered = false
    self.pressed = false
    self.font = love.graphics.setNewFont('assets/fonts/compass_9.ttf', 32)
    self.width = self.font:getWidth(self.text) + 20
    self.height = self.font:getHeight(self.text) + 20
    self.color = "blue"
end

function Button:isHovering()
    return love.mouse.getX() > self.x and love.mouse.getX() < self.x + self.width and
        love.mouse.getY() > self.y and love.mouse.getY() < self.y + self.height
end

function Button:onTouch()
    print("Button touched")
end

function Button:update(dt)
    local newHovered = self:isHovering()
    if self.hovered then
        if love.mouse.isDown(1) and not self.pressed then
            -- Initial press
            self.pressed = true
        elseif not love.mouse.isDown(1) and self.pressed then
            -- Release
            self.pressed = false
            self:onTouch()
        end
    else
        self.pressed = false
    end
    self.hovered = newHovered
end

function Button:render()
    -- Sprite.draw(self)

    local buttonX = self.pressed and self.x + 4 or self.x
    local buttonY = self.pressed and self.y + 4 or self.y

    local buttonColor = self.color == "blue" and COLOR_BLUE_BUTTON or COLOR_RED_BUTTON
    -- Shadow
    love.graphics.setColor(COLOR_BUTTON_SHADOW)
    love.graphics.rectangle('fill', self.x + 4, self.y + 4, self.width, self.height, 6, 6)

    -- Inner border
    love.graphics.setColor(buttonColor.innerBorder)
    love.graphics.rectangle('fill', buttonX, buttonY, self.width, self.height, 6, 6)

    -- Fill
    love.graphics.setColor(self.hovered and buttonColor.hover or buttonColor.fill)
    love.graphics.rectangle('fill', buttonX + 2, buttonY + 2, self.width - 4, self.height - 4, 6, 6)

    -- Border
    love.graphics.setColor(buttonColor.border)
    love.graphics.rectangle('line', buttonX, buttonY, self.width, self.height, 6, 6)

    love.graphics.setColor(self.hovered and COLOR_BLACK or COLOR_WHITE)
    love.graphics.printf(self.text, buttonX, buttonY + 10, self.width, 'center')
    love.graphics.setColor(1, 1, 1)
end

return Button
