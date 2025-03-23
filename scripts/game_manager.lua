Class = require 'libraries.middleclass'
Grid = require 'scripts.grid'

local GameManager = Class('GameManager')

local shopAnimals = {
    'bear',
    'buffalo',
    'chick',
    'chicken',
    'cow',
    'crocodile',
    'giraffe',
    'hippo'
}

local levelData = {
    [1] = {
        cards = {
            {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
                x = 3,
                y = 1
            }
        }
    },
    [2] = {
        cards = {
            {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
                x = 3,
                y = 2
            },
            {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
                x = 2,
                y = 1
            },
            {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
                x = 4,
                y = 1
            }
        }
    }
}

function GameManager:initialize()
    self.gameInProgress = false
    self.state = "shop"
    self.currentLevel = 1
    self.maxLevel = #levelData
    self.highScore = 0
    self.currentGold = 3
    self.maxLives = 3
    self.lives = self.maxLives
    self.grid = nil
end

function GameManager:getInstance()
    if not GameManager.instance then
        GameManager.instance = GameManager()
    end
    return GameManager.instance
end

function GameManager:changeState(state)
    self.state = state
end

function GameManager:endGame()
    self.gameInProgress = false
end

function GameManager:addGold(amount)
    self.currentGold = self.currentGold + amount
end

function GameManager:saveGrid(grid)
    self.grid = grid:toObject()
end

function GameManager:levelWon()
    self.currentLevel = self.currentLevel + 1
    self.currentGold = self.currentGold + 3
end

function GameManager:levelLost()
    self.lives = self.lives - 1
    self.currentGold = self.currentGold + 2
end

function GameManager:loadGrid()
    local grid = nil
    if self.grid then
        grid = Grid.fromObject(self.grid)
    else
        grid = Grid:new(5, 6)
    end
    -- Clear the first 3 rows
    for i = 1, 5 do
        for j = 1, 3 do
            grid:remove(i, j)
        end
    end
    if self.state == "shop" then
        -- shuffle the shop animals
        local animals = {}
        for _, animal in ipairs(shopAnimals) do
            table.insert(animals, animal)
        end
        -- Shuffle the animals
        for i = #animals, 2, -1 do
            local j = math.random(i)
            animals[i], animals[j] = animals[j], animals[i]
        end
        for i = 1, 5 do
            local animal = table.remove(animals)
            grid:add(i, 1, Card:new(animal))
        end
    end
    if self.state == "game" then
        -- Load level data
        local level = levelData[self.currentLevel]
        for _, data in ipairs(level.cards) do
            local card = Card:new(data.name)
            card.hp = data.hp
            card.damage = data.damage
            card.block = data.block
            card.isEnemy = true
            grid:add(data.x, data.y, card)
        end
    end
    return grid
end

return GameManager
