local class = require 'libraries.middleclass'

local Sprite = class('Sprite')

function Sprite:initialize(imagePath)
    self.x = 0
    self.y = 0
    self.speed = 0 -- pixels per second
    self.image = love.graphics.newImage(imagePath)
    self.rotation = 0
    self.rotationSpeed = 0 -- degrees per second
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.parent = nil
    self.children = {}
    self.color = nil
end

function Sprite:globalPosition()
    if self.parent then
        local parentX, parentY = self.parent:globalPosition()
        return parentX + self.x, parentY + self.y
    else
        return self.x, self.y
    end
end

function Sprite:addChild(child)
    table.insert(self.children, child)
    child.parent = self
end

function Sprite:removeChild(child)
    table.remove(self.children, child)
    child.parent = nil
end

function Sprite:removeChildren()
    for _, child in ipairs(self.children) do
        child.parent = nil
    end
    self.children = {}
end

function Sprite:setParent(parent)
    self.parent = parent
    for _, child in ipairs(self.children) do
        child.parent = self
    end
end

function Sprite:update(dt)
    self.x = self.x + (self.speed * dt)
    self.rotation = self.rotation + (self.rotationSpeed * dt)
    if self.x > love.graphics.getWidth() then
        self.x = -self.image:getWidth()
    end
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Sprite:render()
    love.graphics.push()
    if self.parent then
        local parentX, parentY = self.parent:globalPosition()
        love.graphics.translate(parentX, parentY)
    end

    love.graphics.draw(
        self.image,
        self.x,                               -- x
        self.y,                               -- y
        self.rotation,
        self.width / self.image:getWidth(),   -- scaleX
        self.height / self.image:getHeight(), -- scaleY
        0,                                    -- originX
        0                                     -- originY
    )
    for _, child in ipairs(self.children) do
        child:render()
    end
    love.graphics.pop()
end

function Sprite:draw()
    if self.image then
        love.graphics.draw(
            self.image,
            self.x,
            self.y,
            self.rotation,
            self.width / self.image:getWidth(),
            self.height / self.image:getHeight()
        )
    elseif self.color then
        love.graphics.setColor(self.color)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    end
end

return Sprite
