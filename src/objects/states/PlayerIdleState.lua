--[[
	Tetromancer

	Alex Friberg

	Created:		11.30.20
	Last Updated:	12.10.20
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)
	local player = self.entity

	-- key stroke input ordered by priority (abilities take precedence over movement)
	if love.keyboard.wasPressed("z") then
		player:activateTetromino()
	elseif love.keyboard.wasPressed("x") then
		player:changeState("slash", "slash")
	elseif love.keyboard.getNewestDirection() ~= nil then
		player:changeState("walk")
	end
end