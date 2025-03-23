Class = require 'libraries.middleclass'
Grid = require 'scripts.grid'

local GameManager = Class('GameManager')

local shopAnimals = {
    'zebra',
    'bear',
    'buffalo',
    'chick',
    'chicken',
    'cow',
    'crocodile',
    'dog',
    'duck',
    'elephant',
    'frog',
    'giraffe',
    'goat',
    'gorilla',
    'hippo',
    'horse',
    'monkey',
    'moose',
    'narwhal',
    'owl',
    'panda',
    'parrot',
    'penguin',
    'pig',
    'rabbit',
    'rhino',
    'sloth',
    'snake',
    'walrus',
    'whale'
}

local levelData = {
    [1] = {
        cards = {
            [1] = {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
                x = 3,
                y = 1
            }
        },
        board = {
            { 0, 0, 1, 0, 0 },
            { 0, 0, 0, 0, 0 },
            { 0, 0, 0, 0, 0 }
        }
    },
    [2] = {
        cards = {
            [1] = {
                name = "bear",
                hp = 10,
                damage = 1,
                block = 0,
            }
        },
        board = {
            { 0, 1, 0, 1, 0 },
            { 0, 0, 1, 0, 0 },
            { 0, 0, 0, 0, 0 }
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
    self.animals = shopAnimals

    -- Shuffle the animals
    for i = #self.animals, 2, -1 do
        local j = math.random(i)
        self.animals[i], self.animals[j] = self.animals[j], self.animals[i]
    end
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
        for i = 1, 5 do
            local animal = table.remove(self.animals, 1)
            grid:add(i, 1, Card:new(animal))
            -- Add the animal back to the end of the table
            self.animals[#self.animals + 1] = animal
        end
    end
    if self.state == "game" then
        -- Load level data
        local level = levelData[self.currentLevel]
        local board = level.board
        local cards = level.cards
        for i = 1, #board do
            for j = 1, #board[i] do
                if board[i][j] > 0 then
                    local card = Card:new(cards[board[i][j]].name)
                    card.hp = cards[board[i][j]].hp
                    card.damage = cards[board[i][j]].damage
                    card.block = cards[board[i][j]].block
                    card.isEnemy = true
                    grid:add(j, i, card)
                end
            end
        end
    end
    return grid
end

return GameManager
