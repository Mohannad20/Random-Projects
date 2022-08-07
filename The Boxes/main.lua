-- classic OOP class library
Class = require 'class'

-- virtual resolution handling library
push = require 'push'

-- Car class
require 'Car'

-- Truck class
require 'Truck'

-- Boxes classes
require 'boxes/Box'
require 'boxes/Boxx'
require 'boxes/Boxxx'

-- physical screen dimensions
Window_width = 1280
Window_height = 720

-- virtual resolution dimensions
Virtual_width = 512
Virtual_height = 288

-- Car speed
speed = 200

-- background image
local background = love.graphics.newImage('img/Long BG.png')
-- background scroll location X
local bckgScroll = 0
-- background speed scrolling
local bckgScroll_Speed = 50
-- point at which we should loop our background back to X 0
local bckg_loop = 387

-- initialize truck car and boxes
local truck = Truck()
local car = Car()
local box = Box()
local boxx = Boxx()
local boxxx = Boxxx()


function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- title of our game
    love.window.setTitle("The Boxes")

    -- initialize our table of sounds
    sounds = {
        -- fesliyanstudios.com/royalty-free-music/download/8-bit-surf/568
        ['gameTrack'] = love.audio.newSource('sounds/gameTrack.mp3', 'static'),
        ['gameOver'] = love.audio.newSource('sounds/GameOver.wav', 'static'),
    }

    -- initialize score variable
    Score = 0
    
    -- initialize our retro text fonts
    boxesFont = love.graphics.newFont('font.TTF', 25)
    smallFont = love.graphics.newFont('font.TTF', 16)
    gmoverFont = love.graphics.newFont('font.TTF', 30)

    -- initialize our virtual resolution
    push:setupScreen(Virtual_width, Virtual_height, Window_width, Window_height, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize input table
    love.keyboard.keysPressed = {}

    gameState = 'start'
end
 
function resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    -- update our background
    bckgScroll = (bckgScroll + bckgScroll_Speed * dt) % bckg_loop

    -- update the limits of truck
    if truck.y == math.max(5, truck.y + truck.dy * dt) then
        truck.dy = -truck.dy
    elseif truck.y == math.min(Virtual_height - 186, truck.y + truck.dy * dt) then
        truck.dy = -truck.dy 
    end

    -- update car movment
    if love.keyboard.isDown('up') then
        car.dy = -speed
    elseif love.keyboard.isDown('down') then
        car.dy = speed
    else
        car.dy = 0 
    end
    -- update car
    car:update(dt)

    -- update our boxes and truck only if we're in play state;
    if gameState == 'play' then
        boxx:update(dt)
        boxxx:update(dt)
        box:update(dt)
        truck:update(dt)
    end
    
    -- update our collisions variables
    collisionA = AABB(car.x, car.y, car.width, car.height, box.x, box.y, box.width, box.height)
    collisionB = AABB(car.x, car.y, car.width, car.height, boxx.x, boxx.y, boxx.width, boxx.height)
    collisionC = AABB(car.x, car.y, car.width, car.height, boxxx.x, boxxx.y, boxxx.width, boxxx.height)

    -- reset input table
    love.keyboard.keysPressed = {}
end

-- collision function AABB (axis-aligned bounding box)
function AABB(x1, y1, width1, height1, x2, y2, width2, height2)
    if x1 + width1 > x2 and x1 < x2 + width2 and y1 + height1 > y2 and y1 < y2 + height2 then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    -- by pressing enter change the game state
    if key == 'space' then
        love.event.quit()
    -- by pressing enter change the game state
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'game over' then
            gameState = 'start'

            -- reset boxes and truck and score to 0
            box:reset()
            boxx:reset()
            boxxx:reset()
            truck:reset()
            Score = 0
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
    love.keyboard.keysPressed[key] = true
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.draw()
    push:start()
    -- draw background
    love.graphics.draw(background,-bckgScroll,0)
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.setFont(boxesFont) 
        love.graphics.printf('Welcome to The Boxes', 0, 16, Virtual_width, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Enter to Play', 0, 46, Virtual_width, 'center')
        sounds['gameTrack']:play()
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Enter to Play', 0, 46, Virtual_width, 'center')
    elseif gameState == 'game over' then
        love.graphics.setFont(gmoverFont)
        love.graphics.printf('Game Over', 0, 78, Virtual_width, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Enter to play again', 0, 122, Virtual_width, 'center')
        love.graphics.printf('Your Score: ' .. tostring(Score), 0, 158, Virtual_width, 'center')
        sounds['gameTrack']:stop()
    elseif gameState == 'play' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Score: ' .. tostring(Score), 10, 20, Virtual_width )
        box:render()
        boxx:render()
        boxxx:render()
    end

    -- score count
    if gameState == 'play' then
        Score = Score + 1
    end

    -- when car collides with boxes, the gamestate should change to GO
    if collisionA then
        gameState = 'game over'
        sounds['gameOver']:play()
    elseif collisionB then
        gameState = 'game over'
        sounds['gameOver']:play()
    elseif collisionC then
        gameState = 'game over'
        sounds['gameOver']:play()
    end
    
    car:render()
    truck:render()
    push:finish()
end
