--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
self.Onconsume=def.Onconsume
    -- default empty collision callback
   -- self.onCollide = function() end
--end
self.Oncollide=def.Oncollide
end
function GameObject:collides(target)
  
        return not (target.x > self.x + self.width or self.x > target.x + target.width or
                target.y > self.y + self.height or self.y > target.y + target.height)
                
    end
    

    function GameObject:update(dt)
        if self.animation then
            self.animation:update(dt)
            self.animationFrameOffset = self.animation:getCurrentFrame()
        end
    end
function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
        
end