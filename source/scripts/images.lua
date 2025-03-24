local images = {}

function getImage(path)
    if not images[path] then
        images[path] = love.graphics.newImage(path)
    end
    return images[path]
end

return getImage
