-- Libraries
Class = require "class"
push = require "push"

-- Classes
require "Paddle"
require "Ball"

--Constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 


-- Functions

function love.load()
    math.randomseed(os.time())

    -- Title
    love.window.setTitle("Pong")

    -- Filter
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
        })

    -- Fonts 
    smallFont = love.graphics.newFont("04B_03__.ttf", 8) 
    scoreFont = love.graphics.newFont("04B_03__.ttf", 32) 
    victoryFont = love.graphics.newFont("04B_03__.ttf", 24)

    -- Sounds
    sounds = {
        ["paddle_hit"] = love.audio.newSource("paddle_hit.wav", "static"),
        ["wall_hit"] = love.audio.newSource("wall_hit.wav", "static"),
        ["point"] = love.audio.newSource("point.wav", "static")
    }    

    -- Score variables
    player1Score = 0
    player2Score = 0 

    -- Paddles and Ball (Classes)    
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    -- Player variables
    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    -- Starting Game State
    gameState = "start"

end

function love.update(dt) -- dt = deltaTime
    
    paddle1:update(dt)
    paddle2:update(dt)

    
    -- Serving Player
    if gameState == "serve" then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = 100
        else
            ball.dx = -100
        end
   
    elseif gameState == "play" then
        
        -- Score settings 
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            ball:reset()
            sounds["point"]:play()

            if player2Score >= 10 then
                gameState = "victory"
                winningPlayer = 2
            else
                gameState = "serve"
            end 

        end

        if ball.x > VIRTUAL_WIDTH - 4 then
            servingPlayer = 2
            player1Score = player1Score + 1
            ball:reset()
            sounds["point"]:play()

            if player1Score >= 10 then
                gameState = "victory"
                winningPlayer = 1
            else
                gameState = "serve"
            end 
            
        end

        -- Player 1 Collide
        if ball:collides(paddle1) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + 5

            sounds["paddle_hit"]:play()

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Player 2 Collide
        if ball:collides(paddle2) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - 4

            sounds["paddle_hit"]:play()

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Top Collide
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds["wall_hit"]:play()
        end

        -- Bottom Collide
        if ball.y >= VIRTUAL_HEIGHT - 4 then 
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds["wall_hit"]:play()
        end

        -- Player 1 Movement
        if love.keyboard.isDown("w") then
            paddle1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("s") then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        -- Player 2 Movement
        if love.keyboard.isDown("up") then
            paddle2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("down") then
            paddle2.dy = PADDLE_SPEED
        else 
            paddle2.dy = 0
        end

        ball:update(dt)
    end
    
end

function love.keypressed(key)
    
    -- Game State settings
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
           gameState = "serve"
        elseif gameState == "victory" then 
            gameState = "start"
            player1Score = 0
            player2Score = 0
        elseif gameState == "serve" then     
            gameState = "play"
        end  
    end   
end

function love.draw()
    -- Virtual Resolution
    push:apply("start")

    -- Background 
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) 

    -- Render Paddles and Ball 
    ball:render()
    paddle1:render()
    paddle2:render()
    
    -- FPS Counter
    displayFPS()

    -- Score Counter 
    displayScore()
   
    -- Text and Messages
    if gameState == "start" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to begin!", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont) 
        love.graphics.printf("Player ".. tostring(servingPlayer).. "'s serve!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to serve!", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "victory" then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player ".. tostring(winningPlayer).. " wins!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to play again!", 0, 42, VIRTUAL_WIDTH, "center")
    end

    -- End Push
    push:apply("end") 
end

function displayFPS()

    -- FPS settings
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 40, 20) -- ".." = string concatenation
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()

    --Score settings
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)  
end