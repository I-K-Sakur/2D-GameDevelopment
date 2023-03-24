require 'StateMachine'
require 'states/BaseState'
require 'states/ScoreState'


medal=class{}
function medal: init()
    self.image1(bronze.png)
    self.image2(silver.png)
    self.image3(gold.webp)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x=VIRTUAL_WIDTH/2
    self.y=VIRTUAL_HEIGHT/2
    self.dy=0
end
if state<=1 then
function medal:render()
    
        love.graphics.draw(self.image1, self.x, self.y)
  
        --love.graphics.draw(self.image2, self.x, self.y)
    
        --love.graphics.draw(self.image3, self.x, self.y)
end
end
