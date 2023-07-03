--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
Room = Class {}

function Room:init(player)
    DistanceTravel = 0
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()
    --entity=Entity
    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
    self.pot = {}
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = { 'skeleton', 'slime', 'bat', 'ghost', 'spider' }

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),

            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    Heart = false
    Potheart = false
    -- if Potheart==true then
    --     Potheart=false
    --     Potheartx=-WINDOW_HEIGHT
    -- end
    Heartlevel = false
    local switch = GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
            VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
            VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    )

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'

            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end

    -- add to list of objects in scene (only one switch for now)
    table.insert(self.objects, switch)
    --Pot
    --numpot = math.random(2, 6)
    --for k=2,numpot do
    Picked = false
    Potex = false
    Colli = false
    Walkanim = true
    Potsate = false
    Opacity = false
    Gravity = 20
    Destroy = false
    Potx = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE, VIRTUAL_WIDTH - TILE_SIZE * 2 - 16)
    Poty = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
        VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    pot = GameObject(GAME_OBJECT_DEFS['pot'], Potx, Poty)
    -- PotPosx=Potx
    -- PotPosy=Poty
    --pot picked
    pot.onCollide = function()
        if Colli == false then
            if self.player.direction == 'left' then
                self.player.x = self.player.x + 1
                --self.player:changeAnimation('lift-pot-left')
            elseif self.player.direction == 'right' then
                self.player.x = self.player.x - 1
                --self.player:changeAnimation('lift-pot-right')
            elseif self.player.direction == 'up' then
                self.player.y = self.player.y + 1
                -- self.player:changeAnimation('lift-pot-up')
            elseif self.player.direction == 'down' then
                self.player.y = self.player.y - 1
                --self.player:changeAnimation('lift-pot-down')
            end
        end
        if pot.state == 'unpicked' then
            Picked = true

            --pot.state='picked'
            if love.keyboard.isDown('return') then
                Walkanim = false
                Potsate = true
                gSounds['potup']:play()
            end
        end
    end
    table.insert(self.objects, pot)
    --end
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER

                -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end

            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)
    --PotState:update(dt)
    if Picked == true then
        if love.keyboard.isDown('return') then
            if Potsate == false then
                Potsate = true
                Colli = false
            end
        end
    end
    if Potsate == true and
        love.keyboard.isDown('return') then
        Potsate = false
    end

    --
    if Potheart == true and
        self.player.x < Potheartx + 16 and
        self.player.x + 16 > Potheartx and
        self.player.y < Pothearty + 16 and
        self.player.y + 16 > Pothearty then
        Potheart = false
        Heartlevel = true
        Potheartx = -VIRTUAL_HEIGHT
        Potheartx = -60
        Pothearty = -60
        gSounds['power']:play()
    end

    for i = #self.entities, 1, -1 do
        entity = self.entities[i]

        --
        if entity.health == 0 then
            entity.dead = true

            --
        elseif not entity.dead then
            entity:processAI({ room = self }, dt)
            entity:update(dt)
            Enosx = {}
            Enosy = {}
        end


        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)
            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
        if Heartlevel == true then
            if self.player.health <= 4 and self.player.health >= 1 then
                self.player.health = self.player.health + 2
                Heartlevel = false
            elseif self.player.health == 5 then
                self.player.health = self.player.health + 1
                Heartlevel = false
            elseif self.player.health == 6 then
                self.player.health = self.player.health
                Heartlevel = false
            elseif self.player.health <= 0 then
                gStateMachine:change('game-over')
            end
        end
    end
    -- DistanceTravel=DistanceTravel+PLAYER_WALK_SPEED*dt

    for k, object in ipairs(self.objects) do
        object:update(dt)
        if Potsate == true then
            --for i=2,numpot do
            if self.player.direction == 'left' then
                self.objects[2].x = self.player.x
                self.objects[2].y = self.player.y - 10 + self.player.height * dt
                if love.keyboard.isDown('t') then
                    pot.dx = 2
                    pot.dy = 2
                    Potex = true
                    self.objects[2].x = self.player.x - 64
                    self.objects[2].y = self.player.y - 6
                    for i, k in ipairs(self.entities) do
                        if self.objects[2].x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
                            Opacity = true
                            self.objects[2].x = MAP_RENDER_OFFSET_X + TILE_SIZE
                            Timer.tween(0.5, {
                                [self.objects[2]] = { x = MAP_RENDER_OFFSET_X }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        else
                            Timer.tween(0.6, {
                                [self.objects[2]] = { x = self.player.x - 64, y = self.player.y - 6 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        end
                        if self.entities[i].x < self.objects[2].x + 16 and
                            self.entities[i].x + 16 > self.objects[2].x and
                            self.entities[i].y < self.objects[2].y + 16 and
                            self.entities[i].y + 16 > self.objects[2].y then
                            self.entities[i].dead = true
                            Potheartx = self.entities[i].x + 15
                            Pothearty = self.entities[i].y
                            if Potheart == false then
                                Potheart = true
                            end
                        end

                        Potsate = false
                    end
                    self.player:changeState('idle')
                end
            elseif self.player.direction == 'right' then
                self.objects[2].x = self.player.x
                self.objects[2].y = self.player.y - self.player.height * dt - 10

                if love.keyboard.isDown('t') then
                    pot.dx = 2
                    pot.dy = 2
                    Potex = true
                    self.objects[2].x = self.player.x + 64
                    self.objects[2].y = self.player.y + 6
                    for i, k in ipairs(self.entities) do
                        if self.objects[2].x >= VIRTUAL_WIDTH - TILE_SIZE * 2 - 16 then
                            Opacity = true
                            self.objects[2].x = VIRTUAL_WIDTH - TILE_SIZE * 2 - 16
                            Timer.tween(0.5, {
                                [self.objects[2]] = { x = VIRTUAL_WIDTH - TILE_SIZE * 2 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        else
                            Timer.tween(0.6, {
                                [self.objects[2]] = { x = self.player.x + 64, y = self.player.y + 6 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        end
                        if self.entities[i].x < self.objects[2].x + 16 and
                            self.entities[i].x + 16 > self.objects[2].x and
                            self.entities[i].y < self.objects[2].y + 16 and
                            self.entities[i].y + 16 > self.objects[2].y then
                            self.entities[i].dead = true
                            if Potheart == false then
                                Potheart = true
                                Potheartx = self.entities[i].x - 15
                                Pothearty = self.entities[i].y
                                if Potheart == true then
                                    --Heart collision with AABB
                                    Heartlevel = true
                                    gSounds['door']:play()
                                end
                            end
                        end
                        Potsate = false
                    end
                    self.player:changeState('idle')
                end
            elseif self.player.direction == 'up' then
                self.objects[2].x = self.player.x
                self.objects[2].y = self.player.y - self.player.height * dt - 10

                if love.keyboard.isDown('t') then
                    pot.dx = 2
                    pot.dy = 2
                    Potex = true
                    self.objects[2].x = self.player.x
                    self.objects[2].y = self.player.y - TILE_SIZE * 4
                    for i, k in ipairs(self.entities) do
                        if self.objects[2].y <= MAP_RENDER_OFFSET_Y + TILE_SIZE then
                            Opacity = true
                            self.objects[2].y = MAP_RENDER_OFFSET_Y + TILE_SIZE
                            Timer.tween(0.5, {
                                [self.objects[2]] = { y = MAP_RENDER_OFFSET_Y + TILE_SIZE - 18 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        else
                            Timer.tween(0.5, {
                                [self.objects[2]] = { y = self.player.y - TILE_SIZE * 4 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        end
                        if self.entities[i].x < self.objects[2].x + 16 and
                            self.entities[i].x + 16 > self.objects[2].x and
                            self.entities[i].y < self.objects[2].y + 16 and
                            self.entities[i].y + 16 > self.objects[2].y then
                            self.entities[i].dead = true
                            if Potheart == false then
                                Potheart = true
                                Potheartx = self.entities[i].x - 10
                                Pothearty = self.entities[i].y
                                if Potheart == true then
                                    --Heart collision with AABB
                                    Heartlevel = true
                                    gSounds['door']:play()
                                end
                            end
                        end
                        Potsate = false
                    end
                    self.player:changeState('idle')
                end
            elseif self.player.direction == 'down' then
                self.objects[2].x = self.player.x
                self.objects[2].y = self.player.y - self.player.height * dt - 10

                if love.keyboard.isDown('t') then
                    pot.dx = 2
                    pot.dy = 2
                    Potex = true
                    self.objects[2].x = self.player.x
                    self.objects[2].y = self.player.y + TILE_SIZE * 4
                    for i, k in ipairs(self.entities) do
                        if self.objects[2].y >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16 then
                            Opacity = true
                            self.objects[2].y = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) +
                                MAP_RENDER_OFFSET_Y - TILE_SIZE
                            Timer.tween(0.5, {
                                [self.objects[2]] = { x = self.player.x, y = VIRTUAL_HEIGHT -
                                    (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        else
                            Timer.tween(0.5, {
                                [self.objects[2]] = { x = self.player.x, y = self.player.y + TILE_SIZE * 4 }
                            }):finish(function()
                                table.remove(self.objects, 2)
                                gSounds['potdestroy']:play()
                            end)
                        end
                        if self.entities[i].x < self.objects[2].x + 16 and
                            self.entities[i].x + 16 > self.objects[2].x and
                            self.entities[i].y < self.objects[2].y + 16 and
                            self.entities[i].y + 16 > self.objects[2].y then
                            self.entities[i].dead = true
                            if Potheart == false then
                                Potheart = true
                                Potheartx = self.entities[i].x + 10
                                Pothearty = self.entities[i].y
                                if Potheart == true then
                                    --Heart collision with AABB
                                    Heartlevel = true
                                    gSounds['door']:play()
                                end
                            end
                        end
                        Potsate = false
                    end
                    self.player:changeState('idle')
                end
            end
        end
    end



    for k, object in ipairs(self.objects) do
        object:update(dt)
        --object.pot.solid=false
        --object.x=self.player.x


        -- trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX,
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
        -- if Opacity==true then
        -- love.graphics.setColor(1, 1, 1, pot.opacity)
        -- end
        if self.adjacentOffsetX == 0 or self.adjacentOffsetY == 0 and k == 2 then
            if Potex == false then
                love.graphics.setFont(gFonts['small'])
                love.graphics.print('press "enter to pick and "t to throw the pot" ', 60, 0)
            end
        end
    end
    --     --love.graphics.draw(gTextures['tiles'],gFrames['tiles'][ GAME_OBJECT_DEFS['pot'].frame], Potx, Poty)

    if Heart == true then
        love.graphics.draw(gTextures['love'], gFrames['love'][5], Lovex, Lovey)
    end

    if Potheart == true then
        love.graphics.draw(gTextures['love'], gFrames['love'][5], Potheartx, Pothearty)
    end
    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end
    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end
    love.graphics.setStencilTest()

    --
    -- DEBUG DRAWING OF STENCIL RECTANGLES
    --

    -- love.graphics.setColor(255, 0, 0, 100)

    -- -- left
    -- love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
    -- TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- right
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
    --     MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- top
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

    -- --bottom
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

    -- love.graphics.setColor(255, 255, 255, 255)
end
