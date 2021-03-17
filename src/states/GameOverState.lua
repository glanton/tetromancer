--[[
	Tetromancer

	Alex Friberg

	Created:		12.09.20
	Last Updated:	12.10.20
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
	gSounds["play"]:stop()
	gSounds["game_over"]:play()
end

function GameOverState:update()
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		-- return to the title state
		gStateStack:pop()
		gStateStack:pop()

		-- restart title music
		gSounds["title"]:play()
	end
end


function GameOverState:render()
	-- set background color
	love.graphics.clear(COLORS["darkest"])

	-- print game over
	printTitleText("GAME OVER", COLORS["dark"])

	-- print start new game prompt
	printPromptText("press enter", COLORS["lightest"])
end