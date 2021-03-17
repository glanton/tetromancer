--[[
	Tetromancer

	Alex Friberg

	Created:		11.28.20
	Last Updated:	12.10.20
]]

TitleState = Class{__includes = BaseState}

function TitleState:init()
	gSounds["title"]:setLooping(true)
	gSounds["title"]:play()
end

function TitleState:update()
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gSounds["title"]:stop()
		gSounds["start_game"]:play()
		gStateStack:push(GameState())
	end
end


function TitleState:render()
	-- draw background image
	love.graphics.draw(gTextures["title"])

	-- print title
	printTitleText("Tetromancer", COLORS["lightest"])

	-- print start new game prompt
	printPromptText("press enter", COLORS["lightest"])
end