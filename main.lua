local roomy = require('libraries.roomy')
local title = require('scripts.title')
local game = require('scripts.game')
manager = roomy.new()

function love.load()
    print('love.load')
    manager:hook({})
    manager:enter(game)
    manager:push(title)
end
