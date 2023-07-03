PotWalkState = Class { __includes = EntityWalkState }
--PotState=Class{__include=PlayerWalkState}
Potwalk = false
Potanim = true

--Walkanim=false
function PotWalkState:init(player, dungeon)
    --Print=false
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PotWalkState:update(dt)
    if Walkanim == false then
        if love.keyboard.isDown('left') then
            Potidle = true
            -- Potex=true
            -- Walkanim=false
            self.entity.direction = 'left'
            -- self.entity:changeAnimation('lift-pot-left')
            self.entity:changeAnimation('pot-walk-left')
            Potx = self.entity.x
            Poty = self.entity.y - 48
            DistanceTravel = DistanceTravel + PLAYER_WALK_SPEED * dt
        elseif love.keyboard.isDown('right') then
            -- Walkanim=false
            Potidle = true
            self.entity.direction = 'right'
            -- Potex=true
            --self.entity:changeAnimation('lift-pot-right')
            self.entity:changeAnimation('pot-walk-right')
            Potx = self.entity.x
            Poty = self.entity.y - 48
        elseif love.keyboard.isDown('up') then
            -- Walkanim=false
            Potidle = true
            -- Potex=true
            self.entity.direction = 'up'
            --self.entity:changeAnimation('lift-pot-up')
            self.entity:changeAnimation('pot-walk-up')
            Potx = self.entity.x
            Poty = self.entity.y - 48
        elseif love.keyboard.isDown('down') then
            --Walkanim=false
            Potidle = true
            -- Potex=true
            self.entity.direction = 'down'
            --self.entity:changeAnimation('lift-pot-down')
            self.entity:changeAnimation('pot-walk-down')
            Potx = self.entity.x
            Poty = self.entity.y + 48
        elseif love.keyboard.isDown('return') then
            -- Potex=true
            Potex=false
            Potidle = false
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
            self.entity:changeState('walk')
            Walkanim = true
        else
        -- Potex=true
            Potidle = false
        end
    end


    -- perform base collision detection against walls
    if Walkanim == true then
        if love.keyboard.isDown('left') then
            Potidle = true
            --Walkanim=false
            self.entity.direction = 'left'

            self.entity:changeAnimation('walk-left')
        elseif love.keyboard.isDown('right') then
            --Walkanim=false
            Potidle = true
            self.entity.direction = 'right'

            self.entity:changeAnimation('walk-right')
        elseif love.keyboard.isDown('up') then
            --Walkanim=false
            Potidle = true
            self.entity.direction = 'up'
            self.entity:changeAnimation('walk-up')
        elseif love.keyboard.isDown('down') then
            --Walkanim=false
            Potidle = true
            self.entity.direction = 'down'
            self.entity:changeAnimation('walk-down')
            --self.entity:changeAnimation('lift-pot-down')
        elseif love.keyboard.isDown('return') then
            --Potidle=false
            -- self.entity:changeAnimation('walk-'..tostring(self.entity.direction))
            --self.entity:changeState('walk')
            --Walkanim=false
        else
            Potidle = false
            self.entity:changeState('idle')
        end
    end
    if Walkanim == true then
        if love.keyboard.wasPressed('space') then
            self.entity:changeState('swing-sword')
        end
    end
    if Potidle then
        EntityWalkState.update(self, dt)
    end

    if Heart == true then
        --Heart collision with AABB
        if self.entity.x + 16 >= Lovex and self.entity.x - 16 <= Lovex + 10 and self.entity.y + 16 >= Lovey and self.entity.y - 16 <= Lovey + 10 then
            Heartlevel = true
            --Lovex=-60
            gSounds['door']:play()
        end
        Heart = false
    end



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
        end
        --if x1 + w1 >= x2 and x1 <= x2 + w2 and y1 + h1 >= y2 and y1 <= y2 + h2
    end
end
