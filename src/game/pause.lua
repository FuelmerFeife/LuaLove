pause = {}

function pause:enter(from)
    self.from = from -- record previous state
end

function pause:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    -- overlay with pause message
    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle('fill', 0, 0, w, h)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('PAUSE', 0, h / 2, w, 'center')
end

function pause:update(dt)
    -- pauseTimer starts ticking
    pauseTimer = pauseTimer + dt

    -- wait a moment before checking agian if 'p' is pressed
    if love.keyboard.isScancodeDown('p') and pauseTimer > 0.3 then
        -- reset timer
        pauseTimer = 0
        -- remove pause gamestate from the stack
        return Gamestate.pop()
    end
end

