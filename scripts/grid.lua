class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'
require 'scripts.constants'

local Grid = class('Grid', Sprite)

function Grid:initialize(columns, rows)
    self.name = "Grid"
    self.state = "shop"
    self.columns = columns
    self.rows = rows
    self.grid = {}
    for i = 1, columns do
        self.grid[i] = {}
    end
    self.width = columns * CELL_SIZE
    self.height = rows * CELL_SIZE
end

function Grid:cardCount()
    local count = 0
    for i = 1, self.columns do
        for j = 1, self.rows do
            if self.grid[i][j] then
                count = count + 1
            end
        end
    end
    return count
end

function Grid:findClosestPosition(card)
    -- Get card position
    local cardX, cardY = card:globalPosition()

    -- If card is outside grid bounds, return nothing
    if cardX + card.width < self.x or cardX > self.x + self.width or
        cardY + card.height < self.y or cardY > self.y + self.height then
        return nil, nil
    end
    local closestX, closestY = 1, 1
    local minDistance = math.huge

    for i = 1, self.columns do
        for j = 1, self.rows do
            local gridX = self.x + (i - 1) * CELL_SIZE
            local gridY = self.y + (j - 1) * CELL_SIZE
            local distance = math.sqrt((cardX - gridX) ^ 2 + (cardY - gridY) ^ 2)

            if distance < minDistance then
                minDistance = distance
                closestX, closestY = i, j
            end
        end
    end

    return closestX, closestY
end

function Grid:findCardPosition(card)
    for i = 1, self.columns do
        for j = 1, self.rows do
            if self.grid[i][j] == card then
                return i, j
            end
        end
    end
    return nil, nil
end

function Grid:swapCards(card1, card2)
    local x1, y1 = self:findCardPosition(card1)
    local x2, y2 = self:findCardPosition(card2)

    if x1 and y1 and x2 and y2 then
        -- Swap positions in grid
        self.grid[x1][y1] = card2
        self.grid[x2][y2] = card1

        -- Update card positions with tweening
        Flux.to(card1, TWEEN_DURATION, {
            x = (x2 - 1) * CELL_SIZE,
            y = (y2 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
        Flux.to(card2, TWEEN_DURATION, {
            x = (x1 - 1) * CELL_SIZE,
            y = (y1 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
    end
end

function Grid:swapPositions(x1, y1, x2, y2)
    local card1 = self.grid[x1][y1]
    local card2 = self.grid[x2][y2]
    if card1 then
        self.grid[x2][y2] = card1
        Flux.to(card1, TWEEN_DURATION, {
            x = (x2 - 1) * CELL_SIZE,
            y = (y2 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
    else
        self.grid[x2][y2] = nil
    end
    if card2 then
        self.grid[x1][y1] = card2
        Flux.to(card2, TWEEN_DURATION, {
            x = (x1 - 1) * CELL_SIZE,
            y = (y1 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
    else
        self.grid[x1][y1] = nil
    end
end

function Grid:toObject()
    local object = {}
    object.columns = self.columns
    object.rows = self.rows
    object.grid = {}
    for i = 1, self.columns do
        object.grid[i] = {}
        for j = 1, self.rows do
            if self.grid[i][j] then
                object.grid[i][j] = self.grid[i][j]:toObject()
            end
        end
    end
    return object
end

function Grid.fromObject(object)
    local grid = Grid:new(object.columns, object.rows)
    grid.grid = {}
    for i = 1, grid.columns do
        grid.grid[i] = {}
    end
    for i = 1, grid.columns do
        for j = 1, grid.rows do
            if object.grid[i][j] then
                grid:add(i, j, Card.fromObject(object.grid[i][j]))
            end
        end
    end
    return grid
end

function Grid:update(dt)
    for i = 1, self.columns do
        for j = 1, self.rows do
            -- If the cell isn't empty, call update on it
            if self.grid[i][j] ~= nil then
                self.grid[i][j]:update(dt)
            end
        end
    end
end

function Grid:render()
    local selected = nil
    -- First render empty cells
    for i = 1, self.columns do
        for j = 1, self.rows do
            love.graphics.setColor(j < 4 and COLOR_BLUE or COLOR_GREEN)
            love.graphics.rectangle('fill', self.x + (i - 1) * CELL_SIZE,
                self.y + (j - 1) * CELL_SIZE, CARD_WIDTH, CARD_HEIGHT, 4, 4)
        end
    end
    -- Then render cards
    for i = 1, self.columns do
        for j = 1, self.rows do
            if self.grid[i][j] ~= nil then
                if self.grid[i][j].dragging.active then
                    selected = self.grid[i][j]
                else
                    self.grid[i][j]:render()
                end
            end
        end
    end
    if selected then
        selected:render()
    end
end

function Grid:add(x, y, cell)
    self.grid[x][y] = cell
    cell:setParent(self)
    cell.x = (x - 1) * CELL_SIZE
    cell.y = (y - 1) * CELL_SIZE
end

return Grid
