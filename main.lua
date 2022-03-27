function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    red = math.random(0.1, 0.9)
    green = math.random(0.1, 0.9)
    blue = math.random(0.1, 0.9)

    score = 0
    highscore = 0

    gamefont = love.graphics.newFont(40)

end

function love.update(dt)
   
    if score > highscore then
        highscore=score
    end

    if target.radius > 0 then
        target.radius = target.radius - 0.5
    else
        love.graphics.setFont(love.graphics.newFont(400))
        love.graphics.print(score, 200, 200)
        love.event.wait(500)

        score = 0
        target.radius = 50
    end
end

function love.draw()

    love.graphics.setColor(red, green, blue)
    love.graphics.circle("fill", target.x, target.y, target.radius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gamefont)
    love.graphics.print(score, 0, 0)

    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(gamefont)
    love.graphics.print(highscore, 60, 0)

end

function love.mousepressed(x, y, button, istouch, pressed)
    if button == 1 then
        local mousToTarget = distanceBetween(x, target.x, y, target.y)
        if mousToTarget < target.radius then
            score = score + 1
            red = math.random(0.1, 0.9)
            green = math.random(0.1, 0.9)
            blue = math.random(0.1, 0.9)
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
            if (target.radius * 2) < 50 then
                target.radius = target.radius + target.radius
            else
                target.radius = 50
            end

        end

    end
end

function distanceBetween(x1, x2, y1, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

