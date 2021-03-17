--[[
	Tetromancer

	Alex Friberg

	Created:		12.09.20
	Last Updated:	12.09.20

]]

EnemyWalkState = Class{__includes = EntityWalkState}

function EnemyWalkState:update(dt)
	local enemy = self.entity

	EntityWalkState.update(self, dt)

	-- if colliding with tile reset to origin and turn perpendicular randomly
	if enemy:isTileColliding() then
		enemy:resetPosition()
		enemy.direction = enemy:pickRandomPerpendicular(enemy.direction)
	-- if colliding with entity reset to origin
	elseif enemy:isEntityColliding() then
		enemy:resetPosition()
	end
end

