local Sprite = require("scripts.sprite")

local Button = class('Button', Sprite)

local hand_cursor = love.mouse.newCursor('assets/cursors/hand_point.png', 0, 0)
local hand_open = love.mouse.newCursor('assets/cursors/hand_open.png', 0, 0)
local hand_closed = love.mouse.newCursor('assets/cursors/hand_closed.png', 0, 0)

function Button:initialize(text)
    Sprite.initialize(self)
    self.text = text
    self.hovered = false
    self.pressed = false
    self.font = love.graphics.setNewFont('assets/fonts/compass_9.ttf', 32)
    self.width = self.font:getWidth(self.text) + 20
    self.height = self.font:getHeight(self.text) + 20
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
    Sprite.draw(self)

    local buttonX = self.pressed and self.x + 4 or self.x
    local buttonY = self.pressed and self.y + 4 or self.y

    -- Shadow
    local shadowColor = { 0, 0, 0, 0.5 }
    love.graphics.setColor(shadowColor)
    love.graphics.rectangle('fill', self.x + 4, self.y + 4, self.width, self.height, 6, 6)

    -- Inner border
    local innerBorderColor = { 54 / 255, 189 / 255, 247 / 255 }
    love.graphics.setColor(innerBorderColor)
    love.graphics.rectangle('fill', buttonX, buttonY, self.width, self.height, 6, 6)

    -- Fill
    local fillColor = self.hovered and { 216 / 255, 240 / 255, 250 / 255 } or { 28 / 255, 159 / 255, 215 / 255 }
    love.graphics.setColor(fillColor)
    love.graphics.rectangle('fill', buttonX + 2, buttonY + 2, self.width - 4, self.height - 4, 6, 6)

    -- Border
    local borderColor = { 22 / 255, 165 / 255, 168 / 255 }
    love.graphics.setColor(borderColor)
    love.graphics.rectangle('line', buttonX, buttonY, self.width, self.height, 6, 6)

    local textColor = self.hovered and { 0, 0, 0 } or { 1, 1, 1 }
    love.graphics.setColor(textColor)
    love.graphics.printf(self.text, buttonX, buttonY + 10, self.width, 'center')
end

return Button
