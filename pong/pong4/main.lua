push = require "push"
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

   -- Default paddle position
   player1Y = 30
   player2Y = VIRTUAL_HEIGHT - 40

   -- Default ball position
   ballX = VIRTUAL_WIDTH / 2 - 2
   ballY = VIRTUAL_HEIGHT / 2 - 2

   ballDX = math.random(2) == 1 and -100 or 100 -- this is the same as (math.random == 1) ? -100 : 100 
   ballDY = math.random(-50, 50)

   gameState = "start"
end

--[[
    Key config
]]

function love.update(dt) -- dt = deltaTime

    -- player 1 movement
    if love.keyboard.isDown("w") then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("s") then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt) -- VIRTUAL_HEIGHT - PADDLE SIZE
    end

    -- player 2 movement
    if love.keyboard.isDown("up") then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("down") then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == "play" then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
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
        elseif gameState == "play" then
            gameState = "start"

            -- reset the ball position
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and -100 or 100 
            ballDY = math.random(-50, 50)
        end  
    end   
end

function love.draw()
    -- start rendering virtual resolution
    push:apply("start")

    -- change background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- map the 0-255 values to 0-1 so we divide by 255

    -- ball (center)
    love.graphics.rectangle('fill', ballX, ballY, 5, 5)

    -- first paddle
    love.graphics.rectangle('fill', 5, player1Y, 5, 20)

    -- second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- activating font and text placement
    love.graphics.setFont(smallFont)

    if gameState == "start" then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, "center")   
    elseif gameState == "play" then
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, "center") 
    end
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    push:apply("end")    
end