Boxx = Class{}

local BoxxScroll = 0
local BoxxScroll_Speed = 75

function Boxx:init()
    self.image = love.graphics.newImage('img/Box.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.y = Virtual_height / 1.49 - (self.height / 2)
    self.x = 295
end

function Boxx:reset()
    self.x = 295
end

function Boxx:update(dt)
    BoxxScroll = ( BoxxScroll_Speed * dt)  
    self.x = self.x - BoxxScroll
    if self.x < -96 then
        self.x = 330
    end
end 

function Boxx:render()
    love.graphics.draw(self.image, self.x, self.y)
end