--[[
	Tetromancer

	Alex Friberg

	Created:		11.30.20
	Last Updated:	12.10.20
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:update(dt)
	local player = self.entity

	-- key stroke input ordered by priority (abilities take precedence over movement)
	if love.keyboard.wasPressed("z") then
		player:activateTetromino()
		return
	elseif love.keyboard.wasPressed("x") then
		player:changeState("slash", "slash")
		return
	elseif love.keyboard.getNewestDirection() == "left" then
		player.direction = "left"
	elseif love.keyboard.getNewestDirection() == "right" then
		player.direction = "right"
	elseif love.keyboard.getNewestDirection() == "up" then
		player.direction = "up"
	elseif love.keyboard.getNewestDirection() == "down" then
		player.direction = "down"
	else
		player:changeState("idle")
		return
	end

	EntityWalkState.update(self, dt)

	-- if colliding then reset to the origin position from before moving
	if player:isTileColliding() or player:isEntityColliding() then
		player:resetPosition()
	end
end