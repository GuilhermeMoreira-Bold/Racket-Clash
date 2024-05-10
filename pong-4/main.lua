push = require  'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243;

PADDLE_SPEED = 200;

function love.load()
    
        love.graphics.setDefaultFilter('nearest','nearest')

        math.randomseed(os.time())

        love.window.setTitle("Birulinhas pong")
    
        sounds = {
            ['hit_paddle'] = love.audio.newSource('songs/hit_wooden.wav','static'),
            ['scoring'] = love.audio.newSource('songs/scoring.wav', 'static')
        }


        scoreFont = love.graphics.newFont('font2.ttf',32);
        fpsFont = love.graphics.newFont('font.ttf',16);
        smallFont = love.graphics.newFont('font2.ttf',16);

        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true})

        player1Score = 0
        player2Score = 0

       player1 = Paddle(10,30,'sprites/default_padle.png',false)
       player2 = Paddle(VIRTUAL_WIDTH - 44, VIRTUAL_HEIGHT - 30,'sprites/default_padle.png', true)

       ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2,'sprites/ball.png',360)
        
        gameState = 'start'
end

function love.resize(w,h)
    push:resize(w,h)
end
function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        ball.speed = 1
        if servingPlayer == 1 then
            ball.dX = math.random(140,200)
        else
            ball.dX = -math.random(140,200)
        end
    elseif gameState == 'play' then 
    
        if love.keyboard.isDown('w') then
            player1.dY = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dY = PADDLE_SPEED
        else
            player1.dY = 0
        end


        -- player2
        
        --[[if love.keyboard.isDown('up') then
            player2.dY = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dY = PADDLE_SPEED
        else
            player2.dY = 0
        end ]]--
        
        if(ball.x > VIRTUAL_WIDTH/4) then
            if(player2.y < ball.y) then
                player2.dY = 50
            else
                player2.dY = -50
            end
        end
       -- player2.y = ball.dY
      

        if gameState == 'play' then
            if ball:collides(player1) then
                increaseBallSpeed()
                ball.dX = -ball.dX * 1.03
                ball.x = player1.x + 30
                if ball.dY < 0 then
                    ball.dY = -math.random(10,150)
                else
                    ball.dY = math.random(10,150)
                end
                sounds['hit_paddle']:play()
            end

            if ball:collides(player2) then
                increaseBallSpeed()
                ball.dX = -ball.dX * 1.05
                ball.x = player2.x - 20
                if ball.dY < 0 then
                    ball.dY = -math.random(10,100)
                else
                    ball.dY = math.random(10,100)
                end
                sounds['hit_paddle']:play()
            end

            if ball.y >= VIRTUAL_HEIGHT - 4 then
                    ball.dY = -math.random(50,55)
                    sounds['hit_paddle']:play()
            end

            if ball.y <= 0 then
                ball.dY = math.random(50,55)
                sounds['hit_paddle']:play()
            end

            if ball.x > VIRTUAL_WIDTH then
                servingPlayer = 2
                player1Score = player1Score + 1
                ball:reset()
                sounds['scoring']:play()
                gameState = 'serve'
            elseif ball.x < 0 then
                servingPlayer = 1
                player2Score = player2Score + 1
                sounds['scoring']:play()
                ball:reset()
                gameState = 'serve'
            end

            if player1Score == 10 or player2Score == 10 then
                gameState = 'start'
                player1Score = 0
                player2Score = 0
            end

            ball:update(dt)
        end

        player1:update(dt)
        player2:update(dt)
    end
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then 
            gameState = 'play'
        
        elseif gameState == 'serve' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end



function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)

    love.graphics.printf(
        'Birulinhas Pong',
        0,
        20,
        VIRTUAL_WIDTH,
        'center')

    love.graphics.setFont(scoreFont)

    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT /3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)
    
    player1:render()
    player2:render()
    
    ball:render()
    displayFPS()

    if gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            'Player ' .. tostring(servingPlayer) .. ' servin',
        0,
        40,
        VIRTUAL_WIDTH,
        'center')
    end
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(fpsFont)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),10,10)
end

function increaseBallSpeed()
    if(ball.speed >= 2) then
        return
    else
        ball.speed = ball.speed + (ball.speed * 0.05)
    end
end

