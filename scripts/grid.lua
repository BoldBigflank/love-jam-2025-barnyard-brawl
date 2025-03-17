class = require 'libraries.middleclass'
Sprite = require 'scripts.sprite'

local Grid = class('Grid', Sprite)

function Grid:initialize(columns, rows)
    self.columns = columns
    self.rows = rows
    self.grid = {}
    for i = 1, columns do
        self.grid[i] = {}
    end
    self.width = columns * 110
    self.height = rows * 110
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
    for i = 1, self.columns do
        for j = 1, self.rows do
            if self.grid[i][j] ~= nil then
                if self.grid[i][j].dragging.active then
                    selected = self.grid[i][j]
                else
                    self.grid[i][j]:render()
                end
            else
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle('fill', self.x + (i - 1) * 110, self.y + (j - 1) * 110, 100, 100)
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
    cell.x = (x - 1) * 110
    cell.y = (y - 1) * 110
end

return Grid
