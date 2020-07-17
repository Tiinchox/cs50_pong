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
   love.graphics.setDefaultFilter("nearest", "nearest") 

   -- Setting up fonts 
   smallFont = love.graphics.newFont("04B_03__.ttf", 8) -- name of the font file and size of the font
   scoreFont = love.graphics.newFont("04B_03__.ttf", 32) 

   player1Score = 0
   player2Score = 0 

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 40

   -- Initialize our virtual resolution
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       vsync = true,
       resizable = false
   })
end

function love.update(dt)
    if love.keyboard.isDown("w") then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("s") then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown("up") then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("down") then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[
    Keyboard configuration
]]

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end    
end

function love.draw()
    -- start rendering virtual resolution
    push:apply("start")

    -- change background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- map the 0-255 values to 0-1 so we divide by 255

    -- ball (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    -- first paddle
    love.graphics.rectangle('fill', 5, player1Y, 5, 20)

    -- second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- activating font and text placement
    love.graphics.setFont(smallFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")   
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    push:apply("end")    
end