class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
getImage = require 'scripts.images'
flux = require 'libraries.flux'
require 'scripts.constants'
local Card = class('Card', Sprite)

-- Static variable to track currently dragged card
Card.currentlyDragged = nil

local cardData = {
    ['bear'] = {
        image = 'bear',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['buffalo'] = {
        image = 'buffalo',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['chick'] = {
        image = 'chick',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['chicken'] = {
        image = 'chicken',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['cow'] = {
        image = 'cow',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['crocodile'] = {
        image = 'crocodile',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['giraffe'] = {
        image = 'giraffe',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
    },
    ['hippo'] = {
        image = 'hippo',
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
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
    self.width = CARD_WIDTH
    self.height = CARD_HEIGHT
    self.purchased = false
    self.price = data.price
    self.hp = data.hp
    self.block = data.block
    self.damage = data.damage
    self.damageMultiplier = data.damageMultiplier
    self.speedMultiplier = data.speedMultiplier
    self.name = name
    self.hpImage = getImage('assets/icons/suit_hearts_outline.png')
    self.damageImage = getImage('assets/icons/sword_outline.png')
    self.blockImage = getImage('assets/icons/shield_outline.png')
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

function Card:isHovering()
    local x, y = love.mouse.getPosition()
    local globalX, globalY = self:globalPosition()
    return x > globalX and x < globalX + self.width and y > globalY and y < globalY + self.height
end

function Card:update(dt)
    Sprite.update(self, dt)

    local x, y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        local globalX, globalY = self:globalPosition()
        if not self.dragging.active and
            not Card.currentlyDragged and -- Only allow dragging if no other card is being dragged
            self:isHovering()
        then
            self.dragging.active = true
            Card.currentlyDragged = self
            love.mouse.setCursor(CURSOR_HAND_CLOSED)
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
        love.mouse.setCursor(CURSOR_HAND_OPEN)

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
                    Flux.to(self, TWEEN_DURATION, {
                        x = (closestX - 1) * CELL_SIZE,
                        y = (closestY - 1) * CELL_SIZE
                    }):ease(TWEEN_EASE)
                end
            else
                -- If no valid new position found, reset to original position
                Flux.to(self, TWEEN_DURATION, {
                    x = self.dragging.originalX,
                    y = self.dragging.originalY
                }):ease(TWEEN_EASE)
            end
        end
    else
        self.dragging.active = false
        if self:isHovering() then
            love.mouse.setCursor(CURSOR_HAND_OPEN)
        else
            love.mouse.setCursor(CURSOR_HAND)
        end
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
        love.graphics.setColor(COLOR_WHITE_TRANSPARENT)
    end

    Sprite.render(self)
    local globalX, globalY = self:globalPosition()
    if self:isHovering() then
        love.graphics.draw(self.hpImage, globalX + self.width - CARD_ICON_OFFSET, globalY, 0,
            CARD_SCALE, CARD_SCALE)
        love.graphics.draw(self.blockImage, globalX + self.width - CARD_ICON_OFFSET,
            globalY + CARD_ICON_Y_SPACING, 0, CARD_SCALE, CARD_SCALE)
        love.graphics.draw(self.damageImage, globalX, globalY, 0, CARD_SCALE, CARD_SCALE)

        love.graphics.setColor(COLOR_RED)
        love.graphics.printf(self.hp, globalX + self.width - CARD_ICON_OFFSET,
            globalY + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET, 'center')
        love.graphics.printf(self.block, globalX + self.width - CARD_ICON_OFFSET,
            globalY + CARD_ICON_Y_SPACING + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET, 'center')
        love.graphics.printf(self.damage, globalX, globalY + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET,
            'center')
    end
    love.graphics.setColor(COLOR_WHITE)
end

return Card
