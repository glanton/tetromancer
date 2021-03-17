--[[
	Tetromancer

	Alex Friberg

	Created:		12.09.20
	Last Updated:	12.09.20
]]

NextLevelState = Class{__includes = BaseState}

function NextLevelState:init(level)
	self.text = "Level " .. level

	Timer.after(NEXT_LEVEL_DELAY, function()
		gStateStack:pop()
	end)
end


function NextLevelState:render()
	-- set background color
	love.graphics.clear(COLORS["darkest"])

	-- print next level number
	printTitleText(self.text, COLORS["light"])
end