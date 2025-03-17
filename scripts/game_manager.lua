Class = require 'libraries.middleclass'

local GameManager = Class('GameManager')

function GameManager:initialize()
    self.gameInProgress = false
    self.currentLevel = 1
    self.highScore = 0
    self.currentGold = 0
end

function GameManager:getInstance()
    if not GameManager.instance then
        GameManager.instance = GameManager()
    end
    return GameManager.instance
end

function GameManager:startGame()
    self.gameInProgress = true
    self.currentLevel = 1
    self.currentGold = 3
end

function GameManager:endGame()
    self.gameInProgress = false
end

function GameManager:addGold(amount)
    self.currentGold = self.currentGold + amount
end

return GameManager
