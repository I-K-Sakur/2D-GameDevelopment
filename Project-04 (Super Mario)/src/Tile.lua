--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
    self.tileset = tileset
    self.topper = topper
    self.topperset = topperset
    LockTile=love.graphics.newImage('graphics/keys_and_locks.png')
    LockQuad=love.graphics.newQuad(0,16,16,16,LockTile)
    LockKey=love.graphics.newQuad(0,0,16,16,LockTile)

 
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
function Tile:collidable(target)
--Lock:collide()
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end

function Tile:render()
    --[[if Show==true then
     love.graphics.draw(LockTile,LockQuad,Posx+32,Posy+32,0,0.6)
     love.graphics.draw(LockTile,LockKey,Posx+32,Posy+32,0,0.6)
    end]]--
  
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
    
    -- tile top layer for graphical variety
    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppersets'][self.topperset][self.id],
            (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
    end
end