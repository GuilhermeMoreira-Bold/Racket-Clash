Paddle = Class{}

function Paddle:init(x,y,sprite,invert)
    self.sprite = love.graphics.newImage(sprite)
    self.x = x
    self.y = y
    self.width = self.sprite:getWidth() 
    self.height = self.sprite:getHeight() 
    self.dY = 0
    self.invert = invert
end

function Paddle:update(dt)
    if self.dY < 0 then
        self.y = math.max(0,self.y + self.dY * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dY * dt)
    end
end

function Paddle:render()
    local scaleX = self.invert and -1 or 1
    love.graphics.draw(self.sprite,self.x,self.y,0,scaleX,1, self.invert and self.width or 0)
end