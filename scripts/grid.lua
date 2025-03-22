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

function Grid:cardDropped(card)
    if self.state ~= "shop" then
        return
    end
    local closestX, closestY = self:findClosestPosition(card)
    local currentX, currentY = self:findCardPosition(card)
    local returnToOriginal = false

    -- Check if we have valid positions
    if not closestX or not closestY or not currentX or not currentY then
        returnToOriginal = true
    elseif closestX == currentX and closestY == currentY then -- Same position
        returnToOriginal = true
    elseif card.purchased and closestY < 4 then
        returnToOriginal = true
    elseif not card.purchased and GameManager:getInstance().currentGold < card.price then
        returnToOriginal = true
    end

    -- Check if target position is within bounds
    if not returnToOriginal and (closestX < 1 or closestX > self.columns or closestY < 1 or closestY > self.rows) then
        returnToOriginal = true
    end

    -- Check target card if it exists
    if not returnToOriginal then
        local targetCard = self.grid[closestX][closestY]
        if not card.purchased and targetCard and targetCard.purchased then
            returnToOriginal = true
        elseif card.purchased and targetCard and not targetCard.purchased then
            returnToOriginal = true
        end
    end

    if returnToOriginal then
        Flux.to(card, TWEEN_DURATION, {
            x = card.dragging.originalX,
            y = card.dragging.originalY
        }):ease(TWEEN_EASE)
        return
    end

    -- Purchase card if necessary
    if not card.purchased and closestY > 3 then
        if GameManager:getInstance().currentGold >= card.price then
            card.purchased = true
            GameManager:getInstance():addGold(-1 * card.price)
        end
    end

    -- Swap cards if necessary
    self:swapPositions(closestX, closestY, currentX, currentY)
end

function Grid:swapPositions(gridX1, gridY1, gridX2, gridY2)
    -- Validate input coordinates
    if not gridX1 or not gridY1 or not gridX2 or not gridY2 then
        return
    end

    -- Check if coordinates are within bounds
    if gridX1 < 1 or gridX1 > self.columns or gridY1 < 1 or gridY1 > self.rows or
        gridX2 < 1 or gridX2 > self.columns or gridY2 < 1 or gridY2 > self.rows then
        return
    end

    -- Get cards at positions
    local card1 = self.grid[gridX1][gridY1]
    local card2 = self.grid[gridX2][gridY2]

    -- Swap cards if they exist
    if card1 then
        self.grid[gridX2][gridY2] = card1
        Flux.to(card1, TWEEN_DURATION, {
            x = (gridX2 - 1) * CELL_SIZE,
            y = (gridY2 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
    else
        self.grid[gridX2][gridY2] = nil
    end

    if card2 then
        self.grid[gridX1][gridY1] = card2
        Flux.to(card2, TWEEN_DURATION, {
            x = (gridX1 - 1) * CELL_SIZE,
            y = (gridY1 - 1) * CELL_SIZE
        }):ease(TWEEN_EASE)
    else
        self.grid[gridX1][gridY1] = nil
    end
end

function Grid:toObject()
    local object = {}
    object.columns = self.columns
    object.rows = self.rows
    object.grid = {}
    for i = 1, self.columns do
        object.grid[i] = {}
        for j = 4, self.rows do
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

function Grid:listCards()
    local cards = {}
    for i = 1, self.columns do
        for j = 1, self.rows do
            if self.grid[i][j] then
                table.insert(cards, self.grid[i][j])
            end
        end
    end
    return cards
end

function Grid:validPosition(x, y, pos)
    -- Validate input parameters
    if not x or not y then
        return false
    end

    -- Apply position offset if provided
    if pos then
        x = x + pos[1]
        y = y + pos[2]
    end

    -- Check if the resulting position is within grid bounds
    return x >= 1 and x <= self.columns and y >= 1 and y <= self.rows
end

function Grid:cardAtDirection(x, y, coordinates, direction)
    local newX = x + coordinates[1]
    local newY = y + coordinates[2] * direction
    if not self:validPosition(newX, newY) then
        return nil
    end
    return self.grid[newX][newY]
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

function Grid:remove(x, y)
    local card = self.grid[x][y]
    if card then
        self:removeChild(card)
        card:destroy()
    end
    self.grid[x][y] = nil
end

return Grid
