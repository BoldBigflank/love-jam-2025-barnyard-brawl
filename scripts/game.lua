local game = {}

function game:enter(previous, ...)
    print('game enter')
end

function game:update(dt)
    print('game update')
end

function game:draw()
    print('game draw')
    love.graphics.print("Hello World", 400, 300)
end

function game:leave(next, ...)
    print('game leave')
end

function game:keypressed(key)
    print('game keypressed', key)
end

return game
