class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
getImage = require 'scripts.images'
flux = require 'libraries.flux'
local Card = class('Card', Sprite)

-- Static variable to track currently dragged card
Card.currentlyDragged = nil

local cardData = {
    ['bear'] = {
        image = 'bear',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['buffalo'] = {
        image = 'buffalo',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['chick'] = {
        image = 'chick',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['chicken'] = {
        image = 'chicken',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['cow'] = {
        image = 'cow',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['crocodile'] = {
        image = 'crocodile',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['giraffe'] = {
        image = 'giraffe',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
    ['hippo'] = {
        image = 'hippo',
        price = 1,
        hp = 1,
        block = 1,
        damage = 1,
        damageMultiplier = 1,
    },
}
function Card:initialize(name)
    local data = cardData[name]
    local imagePath = 'assets/Square (outline)/' .. data.image .. '.png'
    Sprite.initialize(self, imagePath)
    self.dragging = {
        diffX = 0,
        diffY = 0,
        active = false,
        originalX = 0,
        originalY = 0,
    }
    self.width = 100
    self.height = 100
    self.purchased = false
    self.price = data.price
    self.hp = data.hp
    self.block = data.block
    self.damage = data.damage
    self.damageMultiplier = data.damageMultiplier
    self.speedMultiplier = data.speedMultiplier
    self.name = name
    self.hpImage = getImage('assets/icons/suit_hearts.png')
    self.damageImage = getImage('assets/icons/sword.png')
    self.blockImage = getImage('assets/icons/shield.png')
end

function Card:toObject()
    local object = {}
    object.name = self.name
    object.imagePath = self.imagePath
    object.purchased = self.purchased
    object.price = self.price
    object.hp = self.hp
    object.block = self.block
    object.damage = self.damage
    object.damageMultiplier = self.damageMultiplier
    object.speedMultiplier = self.speedMultiplier
    return object
end

function Card.fromObject(object)
    local card = Card:new(object.name)
    card.purchased = object.purchased
    card.price = object.price
    card.hp = object.hp
    card.block = object.block
    card.damage = object.damage
    card.damageMultiplier = object.damageMultiplier
    card.speedMultiplier = object.speedMultiplier
    return card
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
    local globalX, globalY = self:globalPosition()
    if not self.dragging.active then
        love.graphics.draw(self.hpImage, globalX + self.width - 48, globalY, 0, 0.75, 0.75)
        love.graphics.draw(self.blockImage, globalX + self.width - 48, globalY + 32, 0, 0.75, 0.75)
        love.graphics.draw(self.damageImage, globalX, globalY, 0, 0.75, 0.75)

        love.graphics.setColor(1, 0, 0)
        love.graphics.printf(self.hp, globalX + self.width - 48, globalY + 8, 48, 'center')
        love.graphics.printf(self.block, globalX + self.width - 48, globalY + 32 + 8, 48, 'center')
        love.graphics.printf(self.damage, globalX, globalY + 8, 48, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Card
