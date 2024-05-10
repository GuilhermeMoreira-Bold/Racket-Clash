
Ball = Class{}

function Ball:init (x,y,sprite,rotation)
    self.x = x
    self.y = y
    self.sprite = love.graphics.newImage(sprite)
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.speed = 1
    self.dX = math.random(2) == 1 and 100 or -100
    self.dY = math.random(-50,50) * 1.5
    self.rotation = rotation
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dX = math.random(2) == 1 and 100 or -100
    self.dY = math.random(-50,50) 
end

function Ball:update(dt)
    self.x = self.x + self.dX * dt * self.speed
    self.y = self.y + self.dY * dt  * self.speed
end

function Ball:render()
    local angle  = love.timer.getTime() * 2*math.pi / 2.5 -- Rotate one turn per 2.5 seconds.
	love.graphics.draw(self.sprite, self.x,self.y, angle, 1,1, self.width/2, self.height/2)
    
   -- love.graphics.draw(self.sprite, self.x,self.y)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    return true
end