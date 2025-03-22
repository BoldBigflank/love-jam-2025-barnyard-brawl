Grid = require 'scripts.grid'
Card = require 'scripts.card'
Button = require 'scripts.button'
GameManager = require 'scripts.game_manager'
InfoBubble = require 'scripts.info_bubble'
require('scripts.constants')
local Game = {}

function Game:enter(previous, ...)
    love.mouse.setCursor(CURSOR_HAND)
    self.sprites = {}
    GameManager:getInstance():changeState("game")
    Card.currentlyDragged = nil
    local grid = GameManager:getInstance():loadGrid()
    table.insert(self.sprites, grid)
    grid.x = love.graphics.getWidth() / 2 - grid.width / 2
    grid.y = love.graphics.getHeight() / 2 - grid.height / 2

    -- Load buttons
    local button = Button:new('Start')
    button.name = "StartButton"
    button.color = "red"
    button.x = love.graphics.getWidth() - button.width - 20
    button.y = love.graphics.getHeight() - button.height - 20
    table.insert(self.sprites, button)
    button.onTouch = function()
        GameManager:getInstance():changeState("game-active")
        button:destroy()
    end
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)
end

function Game:activeUpdate(dt)
    local grid = Sprite.findByName(self.sprites, "Grid")
    if not grid then
        return
    end
    -- Go through the grid and do move and attack
    for _, card in pairs(grid:listCards()) do
        if card.attackCooldown <= 0 then
            for _, pos in ipairs(card.attackPositions) do
                local enemy = grid:cardAtDirection(card.x, card.y, pos, card.direction)
                if enemy then
                    if enemy.isEnemy ~= card.isEnemy then
                        enemy:takeDamage(card.damage)
                        card.attackCooldown = card.attackRate
                        break
                    end
                end
            end
        end
        if card.moveCooldown <= 0 then
            local bestX, bestY = card.x, card.y
            local bestDistance = 1000
            for _, pos in ipairs(card.movePositions) do
                local newX = card.x + pos[1]
                local newY = card.y + pos[2]
                if grid:validPosition(x, y, pos) then
                    for _, card2 in pairs(grid:listCards()) do
                        if card2.isEnemy ~= card.isEnemy then
                            local distance = math.abs(newX - card2.x) + math.abs(newY - card2.y)
                            if distance < bestDistance then
                                bestDistance = distance
                                bestX, bestY = newX, newY
                            end
                        end
                    end
                end
            end
            grid:swapPositions(card.x, card.y, bestX, bestY)
            card.moveCooldown = card.moveRate
        end
    end
end

function Game:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
    for _, sprite in pairs(self.sprites) do
        if sprite.isDead then
            table.remove(self.sprites, sprite)
        end
    end

    self.infoBubble.text = ""
    local grid = Sprite.findByName(self.sprites, "Grid")
    if grid then
        for x = 1, grid.rows do
            for y = 1, grid.columns do
                local card = grid.grid[y][x]
                if card and card:isHovering() then
                    self.infoBubble.text = card.description
                    break
                end
            end
        end
    end
    if GameManager:getInstance().state == "game-active" then
        self:activeUpdate(dt)
    end
end

function Game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Game Phase", 0, 16, love.graphics.getWidth(), 'center')
    for _, sprite in pairs(self.sprites) do
        sprite:render()
    end
end

function Game:leave(next, ...)
    for _, sprite in pairs(self.sprites) do
        sprite:destroy()
    end
end

function Game:keypressed(key)
    if key == 'escape' then
        Manager:push(Title)
    end
end

return Game
