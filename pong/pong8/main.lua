-- Libraries
Class = require "class"
push = require "push"


require "Paddle"
require "Ball"

--Constants

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 


--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]

function love.load()
   math.randomseed(os.time())

   love.graphics.setDefaultFilter("nearest", "nearest") 

   love.window.setTitle("Pong")
   
   -- Initialize our virtual resolution
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
    })
   -- Setting up fonts 
   smallFont = love.graphics.newFont("04B_03__.ttf", 8) -- name of the font file and size of the font
   scoreFont = love.graphics.newFont("04B_03__.ttf", 32) 

   -- Score variables
    player1Score = 0
    player2Score = 0 

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    gameState = "start"
end

--[[
    Key config
]]

function love.update(dt) -- dt = deltaTime
    
    paddle1:update(dt)
    paddle2:update(dt)

    if gameState == "play" then
        
        if ball.x <= 0 then
            player2Score = player2Score + 1
            ball:reset()
            gameState = "start"
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1
            ball:reset()
            gameState = "start"
        end

        if ball:collides(paddle1) then
            -- deflect ball to the right
            ball.dx = -ball.dx
        end

        if ball:collides(paddle2) then
            -- deflect ball to left
            ball.dx = -ball.dx
        end

        if ball.y <= 0 then
            -- deflect ball down
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then -- size of ball
            -- deflect ball up
            ball.dy = -ball.dy
        end

        -- player 1 movement
        if love.keyboard.isDown("w") then
            paddle1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("s") then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        -- player 2 movement
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

--[[
    Keypressed = one single input
]]
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
           gameState = "play"       
        end  
    end   
end

function love.draw()
    -- start rendering virtual resolution
    push:apply("start")

    -- change background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- map the 0-255 values to 0-1 so we divide by 255

    -- ball (center)
    ball:render()

    -- paddles
    paddle1:render()
    paddle2:render()
    
    -- FPS counter
    displayFPS()


    -- activating font and text placement
    love.graphics.setFont(smallFont)
   
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    push:apply("end")    
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 40, 20) -- ".." = string concatenation
    love.graphics.setColor(1, 1, 1, 1)
end