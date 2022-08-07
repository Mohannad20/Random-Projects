Boxxx = Class{}

local BoxxxScroll = 0
local BoxxxScroll_Speed = 80

function Boxxx:init()
    self.image = love.graphics.newImage('img/Box.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.y = Virtual_height / 2.9 - (self.height / 2)
    self.x = 295
end

function Boxxx:reset()
    self.x = 295
end

function Boxxx:update(dt)
    BoxxxScroll = ( BoxxxScroll_Speed * dt) 
    self.x = self.x - BoxxxScroll
    if self.x < -47 then
        self.x = 330
    end
end

function Boxxx:render()
    love.graphics.draw(self.image, self.x, self.y)
end