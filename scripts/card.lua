class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'

local Card = class('Card', Sprite)

-- Static variable to track currently dragged card
Card.currentlyDragged = nil

function Card:initialize(image)
    Sprite.initialize(self, image)
    self.dragging = {
        diffX = 0,
        diffY = 0,
        active = false
    }
end

function Card:update(dt)
    Sprite.update(self, dt)

    local x, y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        local globalX, globalY = self:globalPosition()
        if not self.dragging.active and
            not Card.currentlyDragged and -- Only allow dragging if no other card is being dragged
            x > globalX and
            x < globalX + self.width and
            y > globalY and
            y < globalY + self.height
        then
            self.dragging.active = true
            Card.currentlyDragged = self
            self.dragging.diffX = x - globalX
            self.dragging.diffY = y - globalY
        end
    elseif self.dragging.active then
        -- Card is dropped
        self.dragging.active = false
        Card.currentlyDragged = nil
    else
        self.dragging.active = false
    end

    if self.dragging.active then
        local parentX, parentY = 0, 0
        if self.parent then
            parentX, parentY = self.parent:globalPosition()
        end
        self.x = x - self.dragging.diffX - parentX
        self.y = y - self.dragging.diffY - parentY
    end
end

function Card:render()
    Sprite.render(self)
end

return Card
