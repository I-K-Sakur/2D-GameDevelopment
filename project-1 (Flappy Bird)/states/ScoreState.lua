--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

H=Pause
  
function ScoreState:enter(params)
    self.score = params.score
 
    if self.score==0 then
        function ScoreState:update(dt)
      

                
            -- go back to play if enter is pressed
            if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gStateMachine:change('countdown')
            end
            function ScoreState:render()
                -- simply render the score to the middle of the screen
                
                love.graphics.setFont(mediumFont)
                love.graphics.printf('Oops! You lost!\n'..'To earn a medal your minimum score \n has to be "1"', 0, 10, VIRTUAL_WIDTH, 'center')
                love.graphics.setFont(flappyFont)
                love.graphics.printf('Press Enter to Play Again!', 0, 140, VIRTUAL_WIDTH, 'center')
            end
            
        end
    else if self.score>=1 and self.score<=10 then
         medal=love.graphics.newImage('bronze.jpg')
        self.x=VIRTUAL_WIDTH/2-20
        self.y=VIRTUAL_HEIGHT/2
         state="bronze"

         function ScoreState:update(dt)

            -- go back to play if enter is pressed
            if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gStateMachine:change('countdown')
            
            end
        end
        function ScoreState:render()
            -- simply render the score to the middle of the screen
            
            love.graphics.setFont(flappyFont)
            love.graphics.printf('Oops! You lost!', 0, 10, VIRTUAL_WIDTH, 'center')
        
            love.graphics.setFont(mediumFont)
            love.graphics.printf('Score: ' .. tostring(self.score), 0, 50, VIRTUAL_WIDTH, 'center')
        
            love.graphics.printf('Press Enter to Play Again!', 0, 90, VIRTUAL_WIDTH, 'center')
            love.graphics.draw(medal,self.x,self.y)
            love.graphics.printf('You Have obtained a '.. (state) ..' medal', 0, 120, VIRTUAL_WIDTH, 'center')
        end
    else if self.score>=11 and self.score<=20 then 
         self.x=VIRTUAL_WIDTH/2-130   
        self.y=VIRTUAL_HEIGHT/2-70
        medal=love.graphics.newImage('silver-medal-photo-9.png')
        state="silver"

        function ScoreState:update(dt)

            -- go back to play if enter is pressed
            if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gStateMachine:change('countdown')
            end
        
        
        function ScoreState:render()
            -- simply render the score to the middle of the screen
            
            love.graphics.setFont(flappyFont)
            love.graphics.printf('Oops! You lost!', 0, 10, VIRTUAL_WIDTH, 'center')
        
            love.graphics.setFont(mediumFont)
            love.graphics.printf('Score: ' .. tostring(self.score), 0, 50, VIRTUAL_WIDTH, 'center')
        
            love.graphics.printf('Press Enter to Play Again!', 0, 90, VIRTUAL_WIDTH, 'center')
            love.graphics.draw(medal,self.x,self.y)
            love.graphics.printf('You Have obtained a '.. (state) ..' medal', 0, 120, VIRTUAL_WIDTH, 'center')   
        end
    end 
    
    else if self.score>=21 then 
        medal=love.graphics.newImage('gold-medal-2-d9z.png')
        self.x=VIRTUAL_WIDTH/2-20
        self.y=VIRTUAL_HEIGHT/2
         state="gold"

         function ScoreState:update(dt)

            -- go back to play if enter is pressed
            if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                gStateMachine:change('countdown')
            end
           



        function ScoreState:render()
            -- simply render the score to the middle of the screen
            
            love.graphics.setFont(flappyFont)
            love.graphics.printf('Oops! You lost!', 0, 10, VIRTUAL_WIDTH, 'center')
        
            love.graphics.setFont(mediumFont)
            love.graphics.printf('Score: ' .. tostring(self.score), 0, 50, VIRTUAL_WIDTH, 'center')
        
            love.graphics.printf('Press Enter to Play Again!', 0, 90, VIRTUAL_WIDTH, 'center')
            love.graphics.draw(medal,self.x,self.y)
            love.graphics.printf('You Have obtained a '.. (state) ..' medal', 0, 120, VIRTUAL_WIDTH, 'center')
        end     
    
    end
end 
end
end
end
end



     


