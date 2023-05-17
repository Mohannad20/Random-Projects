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
function ScoreState:enter(params)
    self.score = params.score

    -- our medals images
    self.gold = love.graphics.newImage('gold1.png')
    self.silver = love.graphics.newImage('silver2.png')
    self.bronze = love.graphics.newImage('bronze3.png')
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Ops! You lost!', 0, 44, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')


    -- we used this varaible to represent the absence of a useful value.
    local ReceivedMedal = nil

    -- we get gold if scoor >= 10
    if self.score >= 10 then
        ReceivedMedal = self.gold
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Good one you get Gold medal', 0, 134, VIRTUAL_WIDTH, 'center')
    -- we get silver if scoor >= 7
    elseif self.score >= 7 then
        ReceivedMedal = self.silver
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Nice you get Silver medal', 0, 134, VIRTUAL_WIDTH, 'center')
    -- we get bronze if scoor >= 4
    elseif self.score >= 4 then
        ReceivedMedal = self.bronze
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Not bad you get bronze medal', 0, 134, VIRTUAL_WIDTH, 'center')
    -- we get nothing
    elseif self.score < 4 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Try next time to get better!', 0, 134, VIRTUAL_WIDTH, 'center')
    end

    if ReceivedMedal ~= nil then
        love.graphics.draw(ReceivedMedal, VIRTUAL_WIDTH / 2 - ReceivedMedal:getWidth() / 2, 155)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 210, VIRTUAL_WIDTH, 'center')
end