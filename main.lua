class = require('libraries.middleclass')
local roomy = require('libraries.roomy')
Sprite = require('scripts.sprite')
Title = require('scripts.title')
Flux = require('libraries.flux')
Game = require('scripts.game')
GameManager = require('scripts.game_manager')

Manager = roomy.new()

function love.load()
    print('love.load')
    Manager:hook({})
    Manager:push(Title)
end

function love.update(dt)
    Flux.update(dt)
end

love.window.setTitle('Love Jam')
