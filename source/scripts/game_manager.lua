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

local airCards = {
    { name = 'chick' },
    { name = 'duck' },
    { name = 'parrot' },
    { name = 'penguin' },
    { name = 'owl' }
}

local treeCards = {
    { name = 'monkey' },
    { name = 'sloth' },
    { name = 'snake' },
    { name = 'gorilla', block = 2 }
}
local farmCards = {
    { name = 'cow' },
    { name = 'pig' },
    { name = 'horse' },
    { name = 'goat' },
    { name = 'dog',  block = 2 }
}

local landCards = {
    { name = 'giraffe' },
    { name = 'bear' },
    { name = 'hippo' },
    { name = 'elephant' },
    { name = 'panda' },
    { name = 'zebra' },
    { name = 'moose' },
    { name = 'buffalo' },
    { name = 'rhino',   block = 2 }
}

local waterCards = {
    { name = 'crocodile' },
    { name = 'frog' },
    { name = 'walrus' },
    { name = 'whale' },
    { name = 'narwhal',  block = 3 }
}

local levelData = {
    [1] = {
        cards = farmCards,
        board = {
            { 0, 1, 0, 2, 0 },
            { 0, 0, 0, 0, 0 },
            { 0, 0, 0, 0, 0 }
        }
    },
    [2] = {
        cards = landCards,
        board = {
            { 0, 0, 0, 0, 3 },
            { 0, 2, 0, 0, 0 },
            { 1, 0, 0, 0, 0 }
        }
    },
    [3] = {
        cards = treeCards,
        board = {
            { 2, 1, 0, 0, 2 },
            { 0, 0, 2, 0, 0 },
            { 0, 0, 0, 0, 0 }
        }
    },
    [4] = {
        cards = airCards,
        board = {
            { 0, 1, 2, 3, 0 },
            { 0, 1, 2, 0, 0 },
            { 0, 1, 2, 3, 0 }
        }
    },
    [5] = {
        cards = waterCards,
        board = {
            { 0, 1, 0, 1, 0 },
            { 2, 1, 2, 1, 2 },
            { 0, 1, 0, 1, 0 }
        }
    },
    [6] = {
        cards = farmCards,
        board = {
            { 0, 1, 0, 1, 0 },
            { 2, 0, 4, 0, 2 },
            { 0, 3, 0, 3, 0 }
        }
    },
    [7] = {
        cards = landCards,
        board = {
            { 0, 4, 5, 5, 6 },
            { 1, 3, 2, 1, 6 },
            { 0, 4, 0, 0, 0 }
        }
    },
    [8] = {
        cards = treeCards,
        board = {
            { 0, 3, 0, 2, 1 },
            { 1, 3, 2, 3, 1 },
            { 1, 2, 0, 3, 0 }
        }
    },
    [9] = {
        cards = airCards,
        board = {
            { 0, 2, 2, 2, 0 },
            { 3, 0, 3, 0, 3 },
            { 0, 5, 5, 5, 0 }
        }
    },
    [10] = {
        cards = waterCards,
        board = {
            { 0, 0, 1, 1, 4 },
            { 3, 5, 2, 5, 3 },
            { 4, 1, 1, 0, 0 }
        }
    },
    [11] = {
        cards = farmCards,
        board = {
            { 0, 5, 4, 0, 0 },
            { 1, 3, 5, 3, 1 },
            { 0, 0, 4, 5, 0 }
        }
    },
    [12] = {
        cards = landCards,
        board = {
            { 9, 8, 7, 8, 9 },
            { 1, 7, 2, 7, 1 },
            { 6, 3, 6, 3, 6 }
        }
    },
    [13] = {
        cards = treeCards,
        board = {
            { 1, 2, 4, 2, 1 },
            { 4, 1, 2, 1, 4 },
            { 3, 4, 1, 4, 3 }
        }
    }
}
function GameManager:initialize()
    self.gameInProgress = false
    self.state = "intro"
    self.currentLevel = 1
    self.highScore = 0
    self.currentGold = 3
    self.maxLives = 3
    self.lives = self.maxLives
    self.grid = nil
    self.animals = shopAnimals
    self.lastOutcome = ""
    self.outcomes = {}

    self:reset()
end

function GameManager:reset()
    self.gameInProgress = false
    self.state = "intro"
    self.currentLevel = 1
    self.maxLevel = #levelData
    self.highScore = 0
    self.currentGold = 3
    self.lives = self.maxLives
    self.grid = nil
    self.animals = shopAnimals
    self.lastOutcome = ""
    self.outcomes = {}
    for i = 1, self.maxLevel do
        self.outcomes[i] = "Pending"
    end
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
    self.currentGold = self.currentGold + 5
    self.lastOutcome = 'Won and earned 5 gold.'
    self.outcomes[self.currentLevel] = "Win"

    self.currentLevel = self.currentLevel + 1
end

function GameManager:levelLost()
    self.lives = self.lives - 1
    self.currentGold = self.currentGold + 2
    self.lastOutcome = 'Lost and earned 2 gold.'
    self.outcomes[self.currentLevel] = "Loss"
    self.currentLevel = self.currentLevel + 1
end

function GameManager:levelCompleted(levelWon)
    if levelWon then
        self:levelWon()
    else
        self:levelLost()
    end
end

function GameManager:loadGrid()
    self.gameInProgress = true
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
                    local cardData = cards[board[i][j]]
                    local card = Card:new(cardData.name)
                    if cardData.hp then card.hp = cardData.hp end
                    if cardData.damage then card.damage = cardData.damage end
                    if cardData.block then card.block = cardData.block end
                    if cardData.attackRate then card.attackRate = cardData.attackRate end
                    if cardData.moveRate then card.moveRate = cardData.moveRate end
                    card.isEnemy = true
                    grid:add(j, i, card)
                end
            end
        end
    end
    return grid
end

return GameManager
