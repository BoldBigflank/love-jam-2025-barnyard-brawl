class = require('libraries.middleclass')
local roomy = require('libraries.roomy')
Sprite = require('scripts.sprite')
Title = require('scripts.title')
Flux = require('libraries.flux')
Game = require('scripts.game')
require('scripts.constants')
GameManager = require('scripts.game_manager')

math.randomseed(os.time())

Manager = roomy.new()

function love.load()
    love.mouse.setCursor(CURSOR_HAND)
    Manager:hook({})
    Manager:enter(Title)
end

function love.update(dt)
    Flux.update(dt)
end

love.window.setTitle('Barnyard Brawl')
