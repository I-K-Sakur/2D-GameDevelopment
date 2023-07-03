--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['love']={
  
  type='love',
  texture='love',
  frame=5,
  width=16,
  height=16,
  solid=true,
 Oncollide=true
    },
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        -- TODO
        --x=150,
        --y=150,
             type='pot',
            texture='tiles',
            width=16,
            height=16,
            solid=true,
            
            defaultState='unpicked',
            frame=
                14,
            
            states={
                ['picked']={
                    frame=34
                },
                ['unpicked']={
                   frame= 14
                },
                ['follow']={
                    frame=14
                   
                    
                }
            }
        }
}
