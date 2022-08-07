Car = Class{}

function Car:init(x, y, width, height)
    self.image = love.graphics.newImage('img/Car.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    

    self.x = Virtual_width / 9 - (self.width / 2)
    self.y = Virtual_height / 2 - (self.height / 2)
    self.dy = 0
end

function Car:update(dt)
    if self.dy < 0 then
        self.y = math.max(77, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(Virtual_height - 110, self.y + self.dy * dt)
    end
end
 
function Car:render()
    love.graphics.draw(self.image, self.x, self.y)
end