--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    local img=love.graphics.newImage('graphics/images.jpg')
    
    particle=love.graphics.newParticleSystem(img,10)
    particle:setParticleLifetime(0.5)
    particle:setEmissionRate(100)
    particle:setSizes(0.5, 0)

    --particle:setColors(2, 1, 1, 1, 1, 1, 1, 0)
    --particle:setParticleLifetime(1,60)
    --particle:setEmissionRate(10)
    particle:setLinearAcceleration(-200, -200, 200, 200)
    particle:setSpread(math.pi * 2)
   particle:setEmissionArea('borderellipse',2,2)
   particle:setSizeVariation(0.9)
    --particle:setLinearAcceleration(-40,-40,40,40)
    --particle:setColors(1,1,1,1,1,1,1,1)
    particle:emit(100)
    --particle:setColors(255, 255, 255, 255, 255, 255, 255, 0)
   --[[if Leve==1 then
       
        level1={}
        self.gridX=x
        self.gridY=y
        self.x=0
        self.x1=6*32+32
        self.y=(self.gridY-1)*32
        self.color = color
        self.variety = variety
        for k,v in pairs(level1) do
          table.insert(level1,k,self.y)    
          self.y=(self.gridY-1)*32
        end]]--
    --table that hold values for shinny tile
   --Shiny={tileX=math.random(8),tileY=math.random(8),love.graphics.setColor(255,255,255,255),math.random(1)}
    -- board positions
    self.gridX = x
    self.gridY = y
    
    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    
   
    
    self.color=color
    
    self.variety = variety
    if self.color==(math.random(3)==3) then
        Color1=true 
        
    else
        Color1=false
       
    end
end
function Tile:update(dt)
particle:update(dt)
    
end
function Tile:render(x, y)
if self.color==3 then
    --love.graphics.draw(particle,self.x+x+15,self.y+y+15)
    --love.graphics.setColor(0,0,255,0.8)
    --love.graphics.setColor(0,25,0,10)
    --love.graphics.setColor(0,0,55,10)
   love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
       self.x + x + 2, self.y + y + 2)
        love.graphics.draw(particle,self.x+x+16,self.y+y+16)
        --love.graphics.draw(particle,0,0)

    else
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

   --[[] -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)]]--

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end
end