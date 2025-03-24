CURSOR_HAND = love.mouse.newCursor('assets/cursors/hand_point.png', 0, 0)
CURSOR_HAND_OPEN = love.mouse.newCursor('assets/cursors/hand_open.png', 0, 0)
CURSOR_HAND_CLOSED = love.mouse.newCursor('assets/cursors/hand_closed.png', 0, 0)

-- Grid and Card dimensions
CELL_SIZE = 110
CARD_WIDTH = 100
CARD_HEIGHT = 100
CARD_SCALE = 0.75
CARD_ICON_OFFSET = 48
CARD_ICON_Y_SPACING = 40
CARD_TEXT_Y_OFFSET = 8

-- Animation
TWEEN_DURATION = 0.3
TWEEN_EASE = "quadout"

-- Default values
DEFAULT_PRICE = 1
DEFAULT_HP = 10
DEFAULT_BLOCK = 0
DEFAULT_DAMAGE = 1
DEFAULT_DAMAGE_MULTIPLIER = 1
DEFAULT_ATTACK_RATE = 1
DEFAULT_MOVE_RATE = 1

-- Colors
COLOR_WHITE = { 1, 1, 1, 1 }
COLOR_WHITE_TRANSPARENT = { 1, 1, 1, 0.5 }
COLOR_GREY = { 229 / 255, 229 / 255, 229 / 255 } -- #e5e5e5
COLOR_YELLOW = { 255 / 255, 215 / 255, 0 / 255 } -- #E9BD0A
COLOR_RED = { 215 / 255, 28 / 255, 65 / 255 }    -- #d71c41
COLOR_BLACK = { 0, 0, 0 }
COLOR_BUTTON_SHADOW = { 0, 0, 0, 0.5 }
COLOR_BUTTON_BLUE_INNER_BORDER = { 54 / 255, 189 / 255, 247 / 255 } -- #36bdf7
COLOR_BUTTON_BLUE_HOVER = { 216 / 255, 240 / 255, 250 / 255 }       -- #d8f0fa
COLOR_BLUE = { 28 / 255, 159 / 255, 215 / 255 }                     -- #1c9fd7
COLOR_BUTTON_BLUE_BORDER = { 22 / 255, 165 / 255, 168 / 255 }
COLOR_BUTTON_RED_INNER_BORDER = { 255 / 255, 159 / 255, 132 / 255 } -- #ff9f84
COLOR_BUTTON_RED_HOVER = { 255 / 255, 204 / 255, 188 / 255 }        -- #ffcccc
COLOR_BUTTON_RED_BORDER = { 255 / 255, 128 / 255, 100 / 255 }       -- #ff8064
COLOR_GREEN = { 159 / 255, 215 / 255, 28 / 255 }                    -- #9fd736

COLOR_BLUE_BUTTON = {
    innerBorder = COLOR_BUTTON_BLUE_INNER_BORDER,
    hover = COLOR_BUTTON_BLUE_HOVER,
    fill = COLOR_BLUE,
    border = COLOR_BUTTON_BLUE_BORDER,
}
COLOR_RED_BUTTON = {
    innerBorder = COLOR_BUTTON_RED_INNER_BORDER,
    hover = COLOR_BUTTON_RED_HOVER,
    fill = COLOR_RED,
    border = COLOR_BUTTON_RED_BORDER,
}
