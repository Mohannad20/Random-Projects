Box = Class{}

local boxScroll = 0
local boxScroll_Speed = 140

function Box:init()
    self.image = love.graphics.newImage('img/Box.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.y = Virtual_height / 2 - (self.height / 2)
    self.x = 295
end

function Box:reset()
    self.x = 295
end

function Box:update(dt)
    boxScroll = (boxScroll_Speed * dt)
    self.x = self.x - boxScroll
    if self.x < -65 then
        self.x = 330
    end
end 

function Box:render()
    love.graphics.draw(self.image, self.x, self.y)    
end