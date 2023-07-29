GameMenuState = Class{__includes = BaseState}

function GameMenuState:init(def)
    def=def or {}
    -- self.gamemenu = Panel{
    --     x = 0,
    --     y = 0,
    --     width = 170,
    --     height = 150,
    --     visible = true
    -- }
  self.items=def.items or {}
    
    self.gamemenu=Menu{
        x=VIRTUAL_WIDTH-150,
        y=0,
        width=150,
        height=150,
        CursorOn=false,
        items=self.items
    }

end

function GameMenuState:update(dt)
    self.gamemenu:update(dt)
    if love.keyboard.isDown('return') then
    Timer.after(0.1, function()
        gStateStack:push(FadeInState({
            r = 1, g = 1, b = 1
        }, 1,
        
        -- pop message and battle state and add a fade to blend in the field
        function()

            -- resume field music
            gSounds['field-music']:play()
          
            -- pop message state
            --gStateStack:pop()

            -- pop battle state
            gStateStack:pop()

            gStateStack:push(FadeOutState({
                r = 1, g = 1, b = 1
            }, 1, function()
                -- do nothing after fade out ends
            end))
        end))
    end)
end
end
function GameMenuState:render()
    self.gamemenu:render()
      -- love.graphics.print('my name is sakur',VIRTUAL_WIDTH-100, 10)
    -- for k,v in pairs(tablecalcu) do
    --     love.graphics.print(tablecalcu[v],self.gamemenu.x,self.gamemenu.y*k)
    -- end
--for i = 1, 4 do
--love.graphics.clear(188/255, 188/255, 188/255, 1)

-- for k,v in pairs(tablecalcu) do
-- love.graphics.origin()
--     love.graphics.setColor(255,255,0,1)

-- love.graphics.print(v,VIRTUAL_WIDTH-140, 30*k)

-- end

end
