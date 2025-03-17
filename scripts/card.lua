class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
flux = require 'libraries.flux'
local Card = class('Card', Sprite)

-- Static variable to track currently dragged card
Card.currentlyDragged = nil

local cardData = {
    ['bear'] = {
        image = 'bear',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['buffalo'] = {
        image = 'buffalo',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['chick'] = {
        image = 'chick',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['chicken'] = {
        image = 'chicken',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['cow'] = {
        image = 'cow',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['crocodile'] = {
        image = 'crocodile',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['giraffe'] = {
        image = 'giraffe',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
    ['hippo'] = {
        image = 'hippo',
        price = 1,
        hp = 1,
        damageMultiplier = 1,
    },
}
function Card:initialize(name)
    local data = cardData[name]
    local image = 'assets/Square (outline)/' .. data.image .. '.png'
    Sprite.initialize(self, image)
    self.dragging = {
        diffX = 0,
        diffY = 0,
        active = false,
        originalX = 0,
        originalY = 0,
    }
    self.purchased = false
    self.price = data.price
    self.hp = data.hp
    self.damageMultiplier = data.damageMultiplier
    self.speedMultiplier = data.speedMultiplier
    self.name = name
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
            -- Store original position when starting to drag
            self.dragging.originalX = self.x
            self.dragging.originalY = self.y
        end
    elseif self.dragging.active then
        -- Card is dropped
        self.dragging.active = false
        Card.currentlyDragged = nil

        -- Find closest position and swap if needed
        if self.parent then
            local closestX, closestY = self.parent:findClosestPosition(self)
            local currentX, currentY = self.parent:findCardPosition(self)

            if closestX ~= nil and closestY ~= nil and currentX and currentY and (closestX ~= currentX or closestY ~= currentY) then
                if not self.purchased and closestY > 3 then
                    self.purchased = true
                    GameManager:getInstance():addGold(-1 * self.price)
                end
                local targetCard = self.parent.grid[closestX][closestY]
                if targetCard then
                    self.parent:swapCards(self, targetCard)
                else
                    -- If target position is empty, just move the card there
                    self.parent.grid[currentX][currentY] = nil
                    self.parent.grid[closestX][closestY] = self
                    Flux.to(self, 0.3, {
                        x = (closestX - 1) * 110,
                        y = (closestY - 1) * 110
                    }):ease("quadout")
                end
            else
                -- If no valid new position found, reset to original position
                Flux.to(self, 0.3, {
                    x = self.dragging.originalX,
                    y = self.dragging.originalY
                }):ease("quadout")
            end
        end
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
    if not self.purchased then
        love.graphics.setColor(1, 1, 1, 0.5)
    end

    Sprite.render(self)
    love.graphics.setColor(1, 1, 1, 1)
end

return Card
