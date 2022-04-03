game = {}

function game:enter()
    background = love.graphics.newImage("/media/img/background.png")
    targetImage = love.graphics.newImage("/media/img/target.png")

    shootSound = love.audio.newSource("/media/sfx/laserShoot.wav", "stream")
    hitSound = love.audio.newSource("/media/sfx/hit.wav", "stream")
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    katha = {}
    katha.x = 100
    katha.y = 650
    katha.speed = 2
    katha.spriteSheet = love.graphics.newImage('/media/character/katha.png')
    katha.grid = anim8.newGrid(64, 64, katha.spriteSheet:getWidth(), katha.spriteSheet:getHeight())

    katha.animations = {}
    katha.animations.left = anim8.newAnimation(katha.grid(('1-9'), 10), 0.2)
    katha.animations.right = anim8.newAnimation(katha.grid(('1-9'), 12), 0.2)
    katha.animations.up = anim8.newAnimation(katha.grid(('1-9'), 9), 0.2)
    katha.animations.down = anim8.newAnimation(katha.grid(('1-9'), 11), 0.2)
    katha.animations.fall = anim8.newAnimation(katha.grid(('1-6'), 21), 0.2)
    katha.anim = katha.animations.down

    alpaka = {}
    alpaka.x = katha.x - 70
    alpaka.y = katha.y + 20
    alpaka.speed = 2
    alpaka.spriteSheet = love.graphics.newImage('/media/character/llama_walk.png')
    alpaka.spriteSheetEat = love.graphics.newImage('/media/character/llama_eat.png')
    alpaka.grid = anim8.newGrid(128, 128, alpaka.spriteSheet:getWidth(), alpaka.spriteSheet:getHeight())
    alpaka.gridEat = anim8.newGrid(128, 128, alpaka.spriteSheetEat:getWidth(), alpaka.spriteSheetEat:getHeight())

    alpaka.animations = {}
    alpaka.animations.left = anim8.newAnimation(alpaka.grid(('1-4'), 2), 0.2)
    alpaka.animations.right = anim8.newAnimation(alpaka.grid(('1-4'), 4), 0.2)
    alpaka.animations.up = anim8.newAnimation(alpaka.grid(('1-4'), 1), 0.2)
    alpaka.animations.down = anim8.newAnimation(alpaka.grid(('1-4'), 3), 0.2)
    alpaka.animations.eat = anim8.newAnimation(alpaka.gridEat(('1-4'), 3), 0.5)
    alpaka.anim = alpaka.animations.left

    moveX = math.random(-5, 5)
    moveY = math.random(-5, 5)
    scalFactor = 1

    score = 0
    highscore = love.filesystem.read("data.sav")
    highscore = tonumber(highscore)

    impossibility = 0.08
    maxSpeed = 10

    pauseTimer = 0

end

function game:update(dt)

    love.mouse.setCursor(cursorGame)
    local isMoving = false
    isEating = false

    if love.keyboard.isDown("left") then
        katha.anim = katha.animations.left
        alpaka.anim = alpaka.animations.left
        katha.x = katha.x - katha.speed
        alpaka.x = katha.x - 70
        isMoving = true
    end

    if love.keyboard.isDown("right") then
        katha.anim = katha.animations.right
        alpaka.anim = alpaka.animations.right
        katha.x = katha.x + katha.speed
        alpaka.x = katha.x - 70
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        katha.anim = katha.animations.up
        alpaka.anim = alpaka.animations.up
        katha.y = katha.y - katha.speed
        alpaka.y = katha.y + 20
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        katha.anim = katha.animations.down
        alpaka.anim = alpaka.animations.down
        katha.y = katha.y + katha.speed
        alpaka.y = katha.y + 20
        isMoving = true
    end

    if love.keyboard.isDown("space") then
        katha.anim = katha.animations.fall
        isMoving = true
    end

    if isMoving == false and alpaka.y > 580 then
        alpaka.anim = alpaka.animations.eat
        isEating = true
    end

    if (target.x - target.radius) < 0 and moveX < 0 then
        moveX = moveX * (-1)
    end

    if (target.x + target.radius) > 800 and moveX > 0 then
        moveX = moveX * (-1)
    end

    if (target.y - target.radius) < 0 and moveY < 0 then
        moveY = moveY * (-1)
    end

    if (target.y + target.radius) > 700 and moveY > 0 then
        moveY = moveY * (-1)
    end

    target.x = target.x + moveX
    target.y = target.y + moveY

    if score > highscore then
        highscore = score
        love.filesystem.write("data.sav", highscore)
    end

    if target.radius > 0 then
        target.radius = target.radius - impossibility
        scalFactor = target.radius / 50
    else
        love.filesystem.write("data.sav", highscore)
        gamestate.switch(menu)
    end

    if isMoving == false then
        katha.anim:gotoFrame(1)
        if isEating == false then
            alpaka.anim:gotoFrame(3)
        end
    end

    katha.anim:update(dt)
    alpaka.anim:update(dt)
end

function game:draw()
    love.graphics.draw(background)
    love.graphics.draw(targetImage, target.x - target.radius, target.y - target.radius, 0, scalFactor)
    love.graphics.circle("line", target.x, target.y, target.radius)
    love.graphics.setFont(gamefont)
    love.graphics.print(score, 0, 0)
    love.graphics.print(highscore, 60, 0)

    katha.anim:draw(katha.spriteSheet, katha.x, katha.y, nil, 2)
    if isEating == true then
        alpaka.anim:draw(alpaka.spriteSheetEat, alpaka.x, alpaka.y, nil, 1.2)
    else
        alpaka.anim:draw(alpaka.spriteSheet, alpaka.x, alpaka.y, nil, 1.2)
    end

end

function game:mousepressed(x, y, button, istouch, pressed)
    if button == 1 then
        love.audio.play(shootSound)
        local mousToTarget = game:distanceBetween(x, target.x, y, target.y)
        if mousToTarget < target.radius then
            love.audio.play(hitSound)
            score = score + 1

            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - (target.radius + 100))

            moveX = math.random(-(maxSpeed), maxSpeed)
            moveY = math.random(-(maxSpeed), maxSpeed)

            if (target.radius * 2) < 50 then
                target.radius = target.radius + target.radius
            else
                target.radius = 50
            end

        end

    end
end

function game:keypressed(key)
    if key == 'p' then
        gamestate.push(pause)
    end
    if key == 'escape' then
        gamestate.switch(menu)
    end
end

function game:distanceBetween(x1, x2, y1, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

