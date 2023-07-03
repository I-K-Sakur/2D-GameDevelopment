--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}
No_Grond=false
Colli=false
Hascoli=false
Collided=false
Show=false
State=false

--Consu=false
function LevelMaker.generate(width, height)
    local spon=false
    local lowGround=8
    local blockHeight=lowGround-3
    local keyLocation = math.floor(math.random(8,width - 4))
    --local keyLocation = 8
	local lockLocation = math.floor(math.random(10,width - 4))
    --local lockLocation =10

    while (math.abs(lockLocation - keyLocation) < 2) do
		lockLocation = math.random(width - 4)+10
	end
     tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        if x==1 then
        Ground=true
        else
            Ground=false
        end
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and not Ground then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))   
            end
        else
            tileID = TILE_ID_GROUND
            -- height at which we would spawn a potential jump block
            local blockHeight = 4
            for y = 7, height do
             
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

--lock starts
--if x==lockLocation then
--if math.random(1)==1 then
if spon==false then
    -- for lock tile
   lock= GameObject {
       texture = 'lock',
       x = (lockLocation- 1) * TILE_SIZE,
    --y = (blockHeight - 1) * TILE_SIZE,
       y=30,
       --x=40,
       --y=16,
       width = 16,
       height =16,
       frame =9,
       collidable =true,
       hit = false,
       solid = true,
      onCollide=function (obj)
        Show=true
        --Collided=true
        if Collided==true then
        obj.x=-50
        pole=GameObject{
            texture='pole',
           x = (width - 3) * TILE_SIZE,
           y = (lowGround - 4) * TILE_SIZE-16,
            --x=10,
            --y=10,
            width=6,
            height=64,
            frame=1,
            hit=false,
            solid=false,
            consumable=true,
            collidable=false,
            onConsume=function (player,obj)
               -- flag.x=-50
                State=true
                Collided=false
               -- gSounds['pickup']:play()
                --gStateMachine:change('start')
                gStateMachine:change('play', {
                    ['score'] = Levelscore,
                    ['width'] = width + 10,
                Lev=Lev+1,
                  Level=true
                })
            end
        }     
        table.insert(objects,pole)
        flag=GameObject{
            texture='flag',
            x = (width - 5) * TILE_SIZE  + 40,
            y = (lowGround - 4) * TILE_SIZE -16,
           --x=10,
           --y=12,
            width=10,
            height=16,   
          frame=5,
          consumable=true,
          collidable=false,
          hit=true,
          solid=false,
          onConsume=function(obj)
             State=true
             Collided=false
        --pole.x=-50
       -- gStateMachine:change('play')
            --gSounds['pickup']:play()
            --Player.score=Player.score
            gStateMachine:change('play', {
                --['score']= player.score,
                Lev=Lev+1,
                Level=true,
                ['score']=Levelscore,
                ['width']=width + 10
            })
         end
        }
        table.insert(objects,flag)
    end
      end,
       consumable = false,
       -- don't do anything special on a collision
       -- the key makes the lock consumable, onConsume first remove it
       onConsume = function(player,object)      
          return
       end
   }
   gSounds['powerup-reveal']:play()
  
   table.insert(objects,lock)  
   --end
end
--lock finish
--if x==keyLocation then
--if math.random(1)==1 then
if spon==false then
 -- for lock tile
key= GameObject {
    texture = 'lock',
    x = (keyLocation - 1) * TILE_SIZE,
    --y = (blockHeight - 1) * TILE_SIZE - 4,
    y=16,
    --x=30,
   -- y=20,
    width = 16,
    height =16,
    frame =4,
    collidable =false,
    hit = true,
    solid = false,
   
    consumable = true,
    -- don't do anything special on a collision
    -- the key makes the lock consumable, onConsume first remove it
    onConsume = function(player,object)
       --lock['consumable']=true
       --lock['solid']=false
       --lock['x']=-50
       
        Collided=true
       gSounds['pickup']:play()
        --player.score = player.score+50 
    end
}
gSounds['powerup-reveal']:play()

table.insert(objects,key)  
end
--end
--finish



            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not  obj.hit then
                              
                                --lockKeytile
                                --[[if math.random(1)==1 then
                                 local key = GameObject {
                                    texture = 'key',
                                    x =40,
                                    y =40,
                                    width = 16,
                                    height =16,
                                    frame = 10,
                                    collidable = true,
                                    consumable = true,
                                    solid = false,
                                    hit=false,
                                    
                                    -- gem has its own function to add to the player's score
                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        player.score = player.score+50 
                                    end
                                }
                            end]]--

                                   --lock tile ends here
                                   
                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                            Levelscore=player.score
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
 
    return GameLevel(entities, objects, map)
end