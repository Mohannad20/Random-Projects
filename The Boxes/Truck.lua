Truck = Class{}

function Truck:init()
    self.image = love.graphics.newImage('img/Truck.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = Virtual_width / 1.2 - (self.width / 2)
    self.y = Virtual_height / 2 - (self.height / 2)
    self.dx = 0
    self.dy = math.random(-50, 62)
end
function Truck:reset()
    self.x = Virtual_width / 1.2 - (self.width / 2)
    self.y = Virtual_height / 2 - (self.height / 2)
end

function Truck:update(dt)
    if self.dy < 0 then
        self.y = math.max(5, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(Virtual_height - 186, self.y + self.dy * dt)
    end
end

function Truck:render()
    love.graphics.draw(self.image, self.x, self.y)

end
