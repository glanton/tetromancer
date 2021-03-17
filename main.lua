--[[
	Tetromancer

	Alex Friberg

	Created:		11.28.20
	Last Updated:	12.09.20
]]

require "src/dependencies"


function love.load()
	love.window.setTitle("Tetromancer")
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())

	push:setupScreen(
		VIRTUAL_WIDTH,VIRTUAL_HEIGHT,
		WINDOW_WIDTH, WINDOW_HEIGHT,
		{fullscreen = false, vsync = true, resizable = true}
	)

	gStateStack = StateStack()
	gStateStack:push(TitleState())

	love.keyboard.keysPressed = {}
	love.keyboard.keyDirections = {}
end


function love.resize(width, height)
	push:resize(width, height)
end


function love.keypressed(key)
	-- quit the game if the escape key is pressed
	if key == "escape" then
		love.event.quit()
	end

	-- if direction key then store in order (oldest to newest)
	if key == "left" or key == "right" or key == "up" or key == "down" then
		local directionsSize = #love.keyboard.keyDirections
		love.keyboard.keyDirections[directionsSize + 1] = key
	end

	-- otherwise record the keystroke in unindexed table
	love.keyboard.keysPressed[key] = true
end


function love.keyreleased(key)
	-- if direction key then remove from directions table
	if key == "left" or key == "right" or key == "up" or key == "down" then
		local directionsSize = #love.keyboard.keyDirections
		for i = directionsSize, 1, -1 do
			if love.keyboard.keyDirections[i] == key then
				table.remove(love.keyboard.keyDirections, i)
				break
			end
		end
	end
end


-- checks if the specified key is pressed (excludes direction keys) 
function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end


-- returns the most recent direction key pressed
function love.keyboard.getNewestDirection()
	local directionsSize = #love.keyboard.keyDirections
	return love.keyboard.keyDirections[directionsSize]
end


--[[
	Caps delta time to a minimum framerate for crash protection: Otherwise, the
	game crashes when moving the window, since that freezes execution leading
	to a massive dt spike when the window is released that leads to out of index
	table references.
]]
function love.update(dt)
	local capped_dt = math.min(dt, MIN_FPS)

	Timer.update(capped_dt)
	gStateStack:update(capped_dt)

	love.keyboard.keysPressed = {}
end


function love.draw()
	push:start()
	gStateStack:render()
	push:finish()
end