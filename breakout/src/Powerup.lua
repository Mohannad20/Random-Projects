--[[
    GD50
    -- Project 2

    -- Powerup Class --

    Author: Mohannad Moujib
    mohannadmoujiib@gmail.com

    represent powerup class
]]

Powerup = Class{}

function Powerup:init(skin, x, y)
    -- simple positional and dimensional variables
    self.width = 18
    self.height = 18

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the Powerup can move in two dimensions
    self.dy = 20
    self.dx = 0
    self.x = x
    self.y = y
    

    -- this will effectively be the color of our Powerup, and we will index
    self.skin = skin
    self.inPlay = true

end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end


function Powerup:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + self.dy * dt
    end
end

function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
        gFrames['powerups'][self.skin],
        self.x, self.y)
    end
end