class = require('libraries.middleclass')
local roomy = require('libraries.roomy')
Sprite = require('scripts.sprite')
Title = require('scripts.title')
Flux = require('libraries.flux')
Game = require('scripts.game')
require('scripts.constants')
GameManager = require('scripts.game_manager')

Manager = roomy.new()

font = love.graphics.setNewFont('assets/fonts/compass_9.ttf', 32)

function love.load()
    print('love.load')
    love.mouse.setCursor(CURSOR_HAND)
    Manager:hook({})
    Manager:push(Title)
end

function love.update(dt)
    Flux.update(dt)
end

love.window.setTitle('Love Jam')
