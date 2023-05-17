--[[
    PauseState Class
    Author: Mohannad Moujib
    mohannadmoujiib@gmail.com

    The PauseState is the pause screen of the game, shown when player press space. It should
    display "Pause" and also "Press space to continue playing".
]]

PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    -- parameters of the last case in our game
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.score = params.score
    self.lastY = params.lastY
    self.previousState = params.previousState
end

function PauseState:update(dt)
    -- resume playing if space is pressed again
    if love.keyboard.wasPressed('space') then
        gStateMachine:change('play',{
            bird = self.bird,
            pipePairs = self.pipePairs,
            score = self.score,
            lastY = self.lastY,
            previousState = 'paused'})
            
        -- resume sound track
        sounds['music']:play()
    end
end

function PauseState:render()
    -- simple UI code in the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Pause', 0, 84, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press space to continue playing', 0, 160, VIRTUAL_WIDTH, 'center')
end