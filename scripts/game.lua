Grid = require 'scripts.grid'
Card = require 'scripts.card'
Button = require 'scripts.button'
Sprite = require 'scripts.sprite'
Banner = require 'scripts.banner'
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
    grid.state = "game"

    -- Load buttons
    local button = Button:new('Start')
    button.name = "StartButton"
    button.color = "red"
    button.x = love.graphics.getWidth() - button.width - 20
    button.y = love.graphics.getHeight() - button.height - 20
    table.insert(self.sprites, button)
    button.onTouch = function()
        self.shopBubble.text = "Attack in progress!"
        GameManager:getInstance():changeState("game-active")

        grid.state = "action"
        button:destroy()
    end
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)
    self.banner = Banner:new()
    table.insert(self.sprites, self.banner)
    self.shopBubble = InfoBubble:new("Arrange your animals to attack this gang.")
    self.shopBubble.width = 200
    self.shopBubble.x = love.graphics.getWidth() - self.shopBubble.width - 20
    self.shopBubble.y = 20
    table.insert(self.sprites, self.shopBubble)
    self.actionTimer = 0
end

function Game:activeUpdate(dt)
    self.actionTimer = self.actionTimer + dt
    if self.actionTimer > 10 then
        GameManager:getInstance():changeState("failure")
        self.banner.text = "You Lose!"
        self.shopBubble.text = "Attack failed!"
    end
    local grid = Sprite.findByName(self.sprites, "Grid")
    if not grid then
        return
    end
    -- Go through the grid and do move and attack
    local cards = grid:listCards()
    -- Start Generation Here
    local allCardsAreEnemies = true
    local allCardsAreFriends = true
    for _, card in pairs(cards) do
        if not card.isEnemy then
            allCardsAreEnemies = false
        end
        if card.isEnemy then
            allCardsAreFriends = false
        end
    end

    if allCardsAreEnemies then
        GameManager:getInstance():changeState("failure")
        self.banner.text = "You Lose!"
        self.shopBubble.text = "Attack failed!"
        Flux.to(self.banner, 1, {
            x = 0
        })
            :ease("quadout")
            :after(self.banner, 1, {
                x = -1 * love.graphics.getWidth()
            }):ease("quadout")
            :delay(1):oncomplete(function()
            GameManager:getInstance():levelLost()
            Manager:enter(Title)
        end)
        return
    end
    if allCardsAreFriends then
        GameManager:getInstance():changeState("success")
        self.banner.text = "You Win!"
        self.shopBubble.text = "Attack successful!"
        Flux.to(self.banner, 1, {
            x = 0
        })
            :ease("quadout")
            :after(self.banner, 1, {
                x = -1 * love.graphics.getWidth()
            }):ease("quadout")
            :delay(1):oncomplete(function()
            GameManager:getInstance():levelWon()
            Manager:enter(Title)
        end)
        return
    end
    for i, card in pairs(cards) do
        local i, j = grid:findCardPosition(card)
        if not i or not j then
            return
        end
        if card.attackCooldown <= 0 then
            for _, pos in ipairs(card.attackPositions) do
                local enemy = grid:cardAtDirection(i, j, pos, card.direction)
                if enemy then
                    if enemy.isEnemy ~= card.isEnemy then
                        local particle = Sprite:new()
                        particle.x, particle.y = card:globalPosition()
                        particle.width = 0.5 * CELL_SIZE
                        particle.height = 0.5 * CELL_SIZE
                        particle.color = COLOR_RED
                        local enemyX, enemyY = enemy:globalPosition()
                        local distance = math.abs(pos[1]) + math.abs(pos[2])
                        Flux.to(particle, 0.3 * distance, {
                            x = enemyX,
                            y = enemyY
                        }):ease("linear"):oncomplete(function()
                            particle:destroy()
                            if enemy:takeDamage(card.damage) then
                                self.actionTimer = 0
                            end
                        end)
                        table.insert(self.sprites, particle)

                        card.attackCooldown = card.attackRate
                        break
                    end
                end
            end
        end
        if card.moveCooldown <= 0 then
            local bestDistance = 1000
            local bestX, bestY = i, j
            -- Get the closest enemy card
            local enemyCard = grid:findClosestEnemyCard(card)
            if not enemyCard then
                return
            end
            local enemyCardX, enemyCardY = grid:findCardPosition(enemyCard)
            bestDistance = math.abs(i - enemyCardX) + math.abs(j - enemyCardY)
            for _, pos in ipairs(card.movePositions) do
                local newX = i + pos[1]
                local newY = j + pos[2]
                if grid:validPosition(newX, newY) and grid.grid[newX][newY] == nil then
                    local distance = math.abs(newX - enemyCardX) + math.abs(newY - enemyCardY)
                    if distance < bestDistance then
                        bestDistance = distance
                        bestX, bestY = newX, newY
                    end
                end
            end
            grid:swapPositions(i, j, bestX, bestY)
            card.moveCooldown = card.moveRate
        end
    end
end

function Game:update(dt)
    for _, sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
    for i, sprite in pairs(self.sprites) do
        if sprite.isDead then
            table.remove(self.sprites, i)
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

return Game
