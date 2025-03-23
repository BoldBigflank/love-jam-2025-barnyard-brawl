class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
getImage = require 'scripts.images'
flux = require 'libraries.flux'
require 'scripts.constants'
local Card = class('Card', Sprite)

-- Static variable to track currently dragged card
Card.currentlyDragged = nil

-- price, hp, block, damage, damageMultiplier, attackRate, moveRate
local animalNumbers = {
    --                price,  hp, block,  damage, damageMultiplier,   attackRate, moveRate
    -- air tier 1
    ['chick'] =     { 1,      4,  0,      1,      1,                  0.5,          0.5 },
    ['duck'] =      { 1,      5,  0,      1,      1,                  0.5,          0.8 },
    ['parrot'] =    { 1,      5,  0,      1,      1,                  0.5,          0.6 },
    ['penguin'] =   { 2,      6,  1,      1,      1,                  0.5,          0.4 },
    -- air tier 2
    ['chicken'] =   { 3,      11, 1,      3,      1,                  0.4,          0.7 },
    ['owl'] =       { 3,      11, 2,      3,      1,                  0.4,          0.4 },
    --air tier 3

    -- tree tier 1
    ['monkey'] =    { 1,      6,  0,      1,      1,                  0.33,          1 },
    ['sloth'] =     { 1,      6,  1,      3,      1,                  3,          3 },
    ['snake'] =     { 2,      4,  0,      2,      1,                  0.5,          1 },
    -- tree tier 2
    ['gorilla'] =   { 3,      11, 2,      6,      1,                  0.8,          1 },


    -- land tier 1
    ['giraffe'] =   { 1,      4,  0,      1,      1,                  1,          1 },
    ['elephant'] =  { 1,      4,  0,      1,      1,                  1,          1 },
    ['horse'] =     { 1,      4,  0,      1,      1,                  1,          1 },
    ['hippo'] =     { 1,      4,  0,      1,      1,                  1,          1 },
    ['goat'] =      { 1,      4,  0,      1,      1,                  1,          1 },
    ['dog'] =       { 1,      4,  0,      1,      1,                  1,          1 },
    ['cow'] =       { 1,      4,  0,      1,      1,                  1,          1 },
    ['panda'] =     { 1,      4,  0,      1,      1,                  1,          1 },
    ['pig'] =       { 1,      4,  0,      1,      1,                  1,          1 },
    ['rabbit'] =    { 1,      4,  0,      1,      1,                  1,          1 },
    -- land tier 2
    ['bear'] =      { 3,      10, 0,      3,      1,                  1,          1 },
    ['zebra'] =     { 3,      10, 0,      3,      1,                  1,          1 },
    ['moose'] =     { 3,      10, 0,      3,      1,                  1,          1 },
    ['buffalo'] =   { 3,      10, 0,      3,      1,                  1,          1 },
    ['rhino'] =     { 3,      10, 0,      3,      1,                  1,          1 },
    -- land tier 3

    -- water tier 1
    ['crocodile'] = { 1,      4,  0,      1,      1,                  1,          1 },
    ['frog'] =      { 1,      4,  0,      1,      1,                  1,          1 },
    ['walrus'] =    { 1,      4,  0,      1,      1,                  1,          1 },
    -- water tier 2
    ['narwhal'] =   { 3,      10, 0,      3,      1,                  1,          1 },
    ['whale'] =     { 3,      10, 0,      3,      1,                  1,          1 },
    -- water tier 3
}


local animalMovePositions = {
    ['bear'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['buffalo'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['chick'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['chicken'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['cow'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['crocodile'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['dog'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['duck'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['elephant'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['frog'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['giraffe'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['goat'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['gorilla'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['hippo'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['horse'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['monkey'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['moose'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['narwhal'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['owl'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['panda'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['parrot'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['penguin'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['pig'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['rabbit'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['rhino'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['sloth'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['snake'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['walrus'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['whale'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['zebra'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
}

local animalAttackPositions = {
    ['bear'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['buffalo'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['chick'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['chicken'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['cow'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['crocodile'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['dog'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['duck'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['elephant'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['frog'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['giraffe'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['goat'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['gorilla'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['hippo'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['horse'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['monkey'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['moose'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['narwhal'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['owl'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['panda'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['parrot'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['penguin'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['pig'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['rabbit'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['rhino'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['sloth'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['snake'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['walrus'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['whale'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
    ['zebra'] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } },
}

local animalDescriptions = {
    ['zebra'] = "Zebra is a fast animal that can move quickly.",
    ['bear'] = "Bear is a strong animal that can take a lot of damage.",
    ['buffalo'] = "Buffalo is a strong animal that can take a lot of damage.",
    ['chick'] = "Chick is a small animal that can move quickly.",
    ['chicken'] = "Chicken is a small animal that can move quickly.",
    ['cow'] = "Cow is a strong animal that can take a lot of damage.",
    ['crocodile'] = "A good animal.",
    ['dog'] = "A good animal.",
    ['duck'] = "A good animal.",
    ['elephant'] = "A good animal.",
    ['frog'] = "A good animal.",
    ['giraffe'] = "A good animal.",
    ['goat'] = "A good animal.",
    ['gorilla'] = "A good animal.",
    ['hippo'] = "A good animal.",
    ['horse'] = "A good animal.",
    ['monkey'] = "A good animal.",
    ['moose'] = "A good animal.",
    ['narwhal'] = "A good animal.",
    ['owl'] = "A good animal.",
    ['panda'] = "A good animal.",
    ['parrot'] = "A good animal.",
    ['penguin'] = "A good animal.",
    ['pig'] = "A good animal.",
    ['rabbit'] = "A good animal.",
    ['rhino'] = "A good animal.",
    ['sloth'] = "A good animal.",
    ['snake'] = "A good animal.",
    ['walrus'] = "A good animal.",
    ['whale'] = "A good animal.",
}
function Card:initialize(name)
    local animalStats = animalNumbers[name]
    local price = animalStats[1]
    local hp = animalStats[2]
    local block = animalStats[3]
    local damage = animalStats[4]
    local damageMultiplier = animalStats[5]
    local attackRate = animalStats[6]
    local moveRate = animalStats[7]

    local imagePath = 'assets/Square (outline)/' .. name .. '.png'
    Sprite.initialize(self, imagePath)
    self.dragging = {
        diffX = 0,
        diffY = 0,
        active = false,
        originalX = 0,
        originalY = 0,
    }
    self.description = animalDescriptions[name]
    self.width = CARD_WIDTH
    self.height = CARD_HEIGHT
    self.purchased = false
    self.price = price
    self.hp = hp
    self.block = block
    self.damage = damage
    self.damageMultiplier = damageMultiplier
    self.attackRate = attackRate
    self.moveRate = moveRate
    self.attackCooldown = 0
    self.attackPositions = {}
    for _, pos in ipairs(animalAttackPositions[name]) do
        table.insert(self.attackPositions, { pos[1], pos[2] })
    end
    self.moveCooldown = 0
    self.movePositions = {}
    for _, pos in ipairs(animalMovePositions[name]) do
        table.insert(self.movePositions, { pos[1], pos[2] })
    end
    self.name = name
    self.hpImage = getImage('assets/icons/suit_hearts_outline.png')
    self.damageImage = getImage('assets/icons/sword_outline.png')
    self.blockImage = getImage('assets/icons/shield_outline.png')
    self.isEnemy = false
    self.direction = 1
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
    object.attackRate = self.attackRate
    object.moveRate = self.moveRate
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
    return card
end

function Card:isHovering()
    local x, y = love.mouse.getPosition()
    local globalX, globalY = self:globalPosition()
    return x > globalX and x < globalX + self.width and y > globalY and y < globalY + self.height
end

function Card:onDragStart()
    local x, y = love.mouse.getPosition()
    local globalX, globalY = self:globalPosition()
    self.dragging.active = true
    Card.currentlyDragged = self
    love.mouse.setCursor(CURSOR_HAND_CLOSED)
    self.dragging.diffX = x - globalX
    self.dragging.diffY = y - globalY
    -- Store original position when starting to drag
    self.dragging.originalX = self.x
    self.dragging.originalY = self.y
end

function Card:onDragEnd()
    -- Card is dropped
    self.dragging.active = false
    Card.currentlyDragged = nil
    love.mouse.setCursor(CURSOR_HAND_OPEN)

    if self.parent then
        self.parent:cardDropped(self, closestX, closestY)
    end
end

function Card:takeDamage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self.isDead = true
        self:destroy()
    end
end

function Card:dragUpdate(dt)
    Sprite.update(self, dt)
    local x, y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        if not self.dragging.active and
            not Card.currentlyDragged and
            self:isHovering() and
            not self.isEnemy
        then
            self:onDragStart()
        end
    else
        if self.dragging.active then
            self:onDragEnd()
        end
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

function Card:update(dt)
    Sprite.update(self, dt)
    self.direction = self.isEnemy and -1 or 1
    if GameManager:getInstance().state == "shop" or
        GameManager:getInstance().state == "game" then
        self:dragUpdate(dt)
    end
    self.moveCooldown = self.moveCooldown - dt
    self.attackCooldown = self.attackCooldown - dt
end

function Card:render()
    love.graphics.setColor(COLOR_WHITE)

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
                    globalY + (self.direction * pos[2] + 0.5) * CELL_SIZE, 16)
                love.graphics.setColor(COLOR_BLACK)
                love.graphics.circle('line', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (self.direction * pos[2] + 0.5) * CELL_SIZE, 16)
            end
            -- Attack positions
            for _, pos in ipairs(self.attackPositions) do
                love.graphics.setColor(COLOR_RED)
                love.graphics.circle('fill', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (self.direction * pos[2] + 0.5) * CELL_SIZE, 8)
                love.graphics.setColor(COLOR_BLACK)
                love.graphics.circle('line', globalX + (pos[1] + 0.5) * CELL_SIZE,
                    globalY + (self.direction * pos[2] + 0.5) * CELL_SIZE, 8)
            end
        end
    end
    love.graphics.setColor(COLOR_WHITE)
end

return Card
