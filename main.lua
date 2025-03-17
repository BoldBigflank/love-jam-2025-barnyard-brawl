class = require('libraries.middleclass')
local roomy = require('libraries.roomy')
Sprite = require('scripts.sprite')
Title = require('scripts.title')
Game = require('scripts.game')
Manager = roomy.new()

function love.load()
    print('love.load')
    Manager:hook({})
    Manager:push(Title)
end

love.window.setTitle('Love Jam')
