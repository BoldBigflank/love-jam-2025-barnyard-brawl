local title = {}

function title:enter(previous, ...)
    print('title')
end

function title:update(dt)
    -- print('title update')
end

function title:draw()
    -- print('title draw')
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', 200, 200, 50)

    love.graphics.setColor(0, 0, .4)
    love.graphics.circle('fill', 200, 200, 15)
end

function title:leave(next, ...)
    print('title leave')
end

function title:keypressed(key)
    if key == 'space' then
        manager:pop()
    end
end

return title
