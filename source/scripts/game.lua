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
        GameManager:getInstance():saveGrid(grid)
        grid.state = "action"
        button:destroy()
    end
    self.infoBubble = InfoBubble:new("Hello")
    table.insert(self.sprites, self.infoBubble)
    self.banner = Banner:new()
    table.insert(self.sprites, self.banner)
    self.shopBubble = InfoBubble:new("Plan your attack by arranging your animals.")
    self.shopBubble.width = 200
    self.shopBubble.x = love.graphics.getWidth() - self.shopBubble.width - 20
    self.shopBubble.y = 20
    table.insert(self.sprites, self.shopBubble)
    self.actionTimer = 0
end

function Game:roundOver(levelWon)
    GameManager:getInstance():changeState(levelWon and "success" or "failure")
    self.banner.text = levelWon and "Round Won!" or "Round Lost!"
    self.banner.levelWon = levelWon
    self.shopBubble.text = levelWon and "Attack successful!" or "Attack failed!"
    Flux.to(self.banner, 0.5, {
        x = 0
    })
        :ease("quadout")
        :after(self.banner, 0.7, {
            y = levelWon and -1 * self.banner.height or love.graphics.getHeight()
        }):ease("quadin")
        :delay(0.7):oncomplete(function()
        GameManager:getInstance():levelCompleted(levelWon)
        Manager:enter(Title)
    end)
end

function Game:activeUpdate(dt)
    self.actionTimer = self.actionTimer + dt
    if self.actionTimer > 10 then
        self:roundOver(false)
        return
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
        self:roundOver(false)
        return
    end
    if allCardsAreFriends then
        self:roundOver(true)
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
                        local path = card.isEnemy and "assets/puzzle/ballBlue_07.png" or
                            "assets/puzzle/ballYellow_07.png"
                        local particle = Sprite:new(path)
                        particle.width = card.damage * 8 + 8
                        particle.height = card.damage * 8 + 8
                        particle.x, particle.y = card:globalPosition()
                        particle.x = particle.x + 0.5 * CARD_WIDTH - 0.5 * particle.width
                        particle.y = particle.y + 0.5 * CARD_HEIGHT - 0.5 * particle.height
                        particle.color = COLOR_RED
                        local enemyX, enemyY = enemy:globalPosition()
                        enemyX = enemyX + 0.5 * CARD_WIDTH - 0.5 * particle.width
                        enemyY = enemyY + 0.5 * CARD_HEIGHT - 0.5 * particle.height
                        local distance = math.abs(pos[1]) + math.abs(pos[2])
                        Flux.to(particle, 0.3 * distance, {
                            x = enemyX,
                            y = enemyY
                        }):ease("sineout"):oncomplete(function()
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
    local time = love.timer.getTime()
    local rainbowColor = {
        (math.sin(time * 2 + 0) + 1) / 2,
        (math.sin(time * 2 + 2) + 1) / 2,
        (math.sin(time * 2 + 4) + 1) / 2
    }
    love.graphics.setColor(rainbowColor)
    love.graphics.printf("Game Phase", 0, 16, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
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
