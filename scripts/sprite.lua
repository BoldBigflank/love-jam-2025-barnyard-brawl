local class = require 'libraries.middleclass'
getImage = require 'scripts.images'
local Sprite = class('Sprite')

function Sprite.findByName(sprites, name)
    for _, sprite in ipairs(sprites) do
        if sprite.name == name then
            return sprite
        end
    end
end

function Sprite:initialize(imagePath)
    self.x = 0
    self.y = 0
    self.speed = 0 -- pixels per second
    self.imagePath = imagePath
    if imagePath then
        self.image = getImage(imagePath)
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
    end
    self.rotation = 0
    self.rotationSpeed = 0 -- degrees per second
    self.parent = nil
    self.children = {}
    self.color = nil
    self.isDead = false
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
    if self.children then
        for i, c in ipairs(self.children) do
            if c == child then
                table.remove(self.children, i)
                child.parent = nil
                return
            end
        end
    end
end

function Sprite:removeChildren()
    if self.children then
        for _, child in ipairs(self.children) do
            child.parent = nil
        end
        self.children = {}
    end
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
    if self.image and self.x > love.graphics.getWidth() then
        self.x = -self.image:getWidth()
    end
    if self.children then
        for _, child in ipairs(self.children) do
            child:update(dt)
        end
    end
end

function Sprite:render()
    love.graphics.push()
    if self.parent then
        local parentX, parentY = self.parent:globalPosition()
        love.graphics.translate(parentX, parentY)
    end

    -- Calculate scale to fit while maintaining aspect ratio
    if self.image then
        local scale = 1
        local scaleX = self.width / self.image:getWidth()
        local scaleY = self.height / self.image:getHeight()
        scale = math.min(scaleX, scaleY)
        -- Center the image within the sprite bounds
        local imageWidth = self.image:getWidth() * scale
        local imageHeight = self.image:getHeight() * scale
        local offsetX = (self.width - imageWidth) / 2
        local offsetY = (self.height - imageHeight) / 2

        love.graphics.draw(
            self.image,
            self.x + offsetX, -- x
            self.y + offsetY, -- y
            self.rotation,
            scale,            -- scaleX
            scale,            -- scaleY
            0,                -- originX
            0                 -- originY
        )
        for _, child in ipairs(self.children) do
            child:render()
        end
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

function Sprite:destroy()
    self:removeChildren()
    self.parent = nil
    self.image = nil
    self.children = nil
end

return Sprite
