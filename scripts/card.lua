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
        description = "Bear can take a lot of damage.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['buffalo'] = {
        image = 'buffalo',
        description = "Buffalo can take a lot of damage.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK + 1,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['chick'] = {
        image = 'chick',
        description = "Chick is quick and hits a lot.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,

        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['chicken'] = {
        image = 'chicken',
        description = "Chicken is quick and hits a lot.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['cow'] = {
        image = 'cow',
        description = "Cow is a tank that can block a lot of damage.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['crocodile'] = {
        image = 'crocodile',
        description = "Crocodile does damage up to two spaces ahead.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackRate = DEFAULT_ATTACK_RATE,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        moveRate = DEFAULT_MOVE_RATE,
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['giraffe'] = {
        image = 'giraffe',
        description = "Giraffe does damage in a wide range.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
    },
    ['hippo'] = {
        image = 'hippo',
        description = "Hippo does heavy damage to nearby enemies.",
        price = DEFAULT_PRICE,
        hp = DEFAULT_HP,
        block = DEFAULT_BLOCK,
        damage = DEFAULT_DAMAGE,
        damageMultiplier = DEFAULT_DAMAGE_MULTIPLIER,
        attackPositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
        movePositions = {
            { 1,  0 },
            { -1, 0 },
            { 0,  1 },
            { 0,  -1 },
        },
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
    self.description = data.description
    self.width = CARD_WIDTH
    self.height = CARD_HEIGHT
    self.purchased = false
    self.price = data.price
    self.hp = data.hp
    self.block = data.block
    self.damage = data.damage
    self.damageMultiplier = data.damageMultiplier
    self.speedMultiplier = data.speedMultiplier
    self.attackRate = data.attackRate
    self.moveRate = data.moveRate
    self.attackPositions = {}
    for _, pos in ipairs(data.attackPositions) do
        table.insert(self.attackPositions, { pos[1], pos[2] })
    end
    self.movePositions = {}
    for _, pos in ipairs(data.movePositions) do
        table.insert(self.movePositions, { pos[1], pos[2] })
    end
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
    if self.parent.state ~= "shop" then
        return
    end
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
            local returnToOriginal = false
            if closestX == nil or closestY == nil or currentX == nil or currentY == nil then
                returnToOriginal = true
            elseif closestX == currentX and closestY == currentY then -- Same position
                returnToOriginal = true
            elseif self.purchased and closestY < 4 then
                returnToOriginal = true
            elseif not self.purchased and GameManager:getInstance().currentGold < self.price then
                returnToOriginal = true
            end
            local targetCard = self.parent.grid[closestX][closestY]
            if not self.purchased and targetCard and targetCard.purchased then
                returnToOriginal = true
            end
            if self.purchased and targetCard and not targetCard.purchased then
                returnToOriginal = true
            end
            if returnToOriginal then
                Flux.to(self, TWEEN_DURATION, {
                    x = self.dragging.originalX,
                    y = self.dragging.originalY
                }):ease(TWEEN_EASE)
                return
            end

            -- Purchase card if necessary
            if not self.purchased and closestY > 3 then
                if GameManager:getInstance().currentGold >= self.price then
                    self.purchased = true
                    GameManager:getInstance():addGold(-1 * self.price)
                end
            end

            -- Swap cards if necessary
            self.parent:swapPositions(currentX, currentY, closestX, closestY)
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
        -- Icon
        love.graphics.draw(self.hpImage, globalX + self.width - CARD_ICON_OFFSET, globalY, 0,
            CARD_SCALE, CARD_SCALE)
        if self.block > 0 then
            love.graphics.draw(self.blockImage, globalX + self.width - CARD_ICON_OFFSET,
                globalY + CARD_ICON_Y_SPACING, 0, CARD_SCALE, CARD_SCALE)
        end
        love.graphics.draw(self.damageImage, globalX, globalY, 0, CARD_SCALE, CARD_SCALE)

        -- Shadow
        love.graphics.setColor(COLOR_BUTTON_SHADOW)
        love.graphics.printf(self.hp, globalX + self.width - CARD_ICON_OFFSET + 2,
            globalY + CARD_TEXT_Y_OFFSET + 2, CARD_ICON_OFFSET, 'center')
        if self.block > 0 then
            love.graphics.printf(self.block, globalX + self.width - CARD_ICON_OFFSET + 2,
                globalY + CARD_ICON_Y_SPACING + CARD_TEXT_Y_OFFSET + 2, CARD_ICON_OFFSET, 'center')
        end
        love.graphics.printf(self.damage, globalX + 2, globalY + CARD_TEXT_Y_OFFSET + 2,
            CARD_ICON_OFFSET, 'center')

        -- Text
        love.graphics.setColor(COLOR_RED)
        love.graphics.printf(self.hp, globalX + self.width - CARD_ICON_OFFSET,
            globalY + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET, 'center')
        if self.block > 0 then
            love.graphics.printf(self.block, globalX + self.width - CARD_ICON_OFFSET,
                globalY + CARD_ICON_Y_SPACING + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET, 'center')
        end
        love.graphics.printf(self.damage, globalX, globalY + CARD_TEXT_Y_OFFSET, CARD_ICON_OFFSET,
            'center')

        if not self.dragging.active and not Card.currentlyDragged then
            -- Move positions
            for _, pos in ipairs(self.movePositions) do
                love.graphics.setColor(COLOR_BLUE)
                love.graphics.circle('fill', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (pos[2] + 0.5) * CELL_SIZE, 16)
                love.graphics.setColor(COLOR_BLACK)
                love.graphics.circle('line', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (pos[2] + 0.5) * CELL_SIZE, 16)
            end
            -- Attack positions
            for _, pos in ipairs(self.attackPositions) do
                love.graphics.setColor(COLOR_RED)
                love.graphics.circle('fill', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (pos[2] + 0.5) * CELL_SIZE, 8)
                love.graphics.setColor(COLOR_BLACK)
                love.graphics.circle('line', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (pos[2] + 0.5) * CELL_SIZE, 8)
            end
        end
    end
    love.graphics.setColor(COLOR_WHITE)
end

return Card
