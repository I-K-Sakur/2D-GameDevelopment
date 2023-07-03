--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
if Potsate==true and love.keyboard.isDown('return') then
    Potsate=false

elseif Potsate==true then
--Potwalk=true
        --gSounds['door']:play()
    self.entity:changeState('PotState')

--[[elseif  love.keyboard.isDown('return') then
    
  self.entity:changeState('walk')
  self.entity:changeAnimation('walk-'..self.entity.direction)]]--
elseif love.keyboard.isDown('left') then
    --Potanim=false
    Potwalk=true
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
       -- Potanim=false
       Potwalk=true
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
       --Potanim=false
       Potwalk=true
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        --Potanim=false
        Potwalk=true
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    -- perform base collision detection against walls
    if Potwalk then
    EntityWalkState.update(self, dt)
    end
    
    --playerswingsword heart
if Heart==true then
    --Heart collision with AABB
    if self.entity.x+16>=Lovex and self.entity.x-16<=Lovex+10 and self.entity.y+16>=Lovey and self.entity.y-16<=Lovey+10 then
      Heartlevel=true
        --Lovex=-60
        gSounds['power']:play()
    end
    Heart=false
end

--player pot heart
-- if Potheart==true then
--     if self.entity.x+16>=Potheartx and self.entity.x-16<=Potheartx+10 and self.entity.y+16>=Pothearty and self.entity.y-16<=Pothearty+10 then
--         Heartlevel=true
--           --Lovex=-60
--           gSounds['door']:play()
--       end
--     Potheart=false
-- end
    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
          
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end
         --Checking heart collision
        --  if self.entity.x<=Lovex+16 and self.entity.y+4>=Lovey or self.entity.y<=Lovey+16 then
          --  gSounds['door']:play()
         -- end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            if Colli==true then
                Potx=self.entity.x+16
            end
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end
            --Checking heart collision for right side
           -- if self.entity.x+4>=Lovex  and self.entity.y+4>=Lovey or self.entity.y<=Lovey+16 then
              --  gSounds['door']:play()
           -- end
            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            if Colli==true then
                Potx=self.entity.x+16
            end
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end
         -- if self.entity.x+4>=Lovex or self.entity.x<=Lovex+16 and self.entity.y+4>=Lovey then
            --gSounds['door']:play()
          --end
            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            if Colli==true then
                Potx=self.entity.x+16
            end
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end
        -- if self.entity.x+4>=Lovex or self.entity.x<=Lovex+16 and self.entity.y<=Lovey+16 then
            --gSounds['door']:play()
         --end
            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            if Colli==true then
                Potx=self.entity.x+16
            end
        end
        --if x1 + w1 >= x2 and x1 <= x2 + w2 and y1 + h1 >= y2 and y1 <= y2 + h2
   
    end
    
end