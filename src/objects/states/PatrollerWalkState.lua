--[[
	Tetromancer

	Alex Friberg

	Created:		12.07.20
]]

PatrollerWalkState = Class{__includes = EnemyWalkState}

function PatrollerWalkState:enter()
	-- reset the patrol timer to control how long the patroller walks for
	self.entity:resetTimer("patrol")

	-- choose a random direction
	self.entity.direction = self.entity:pickRandomDirection()
end


function PatrollerWalkState:update(dt)
	local patroller = self.entity

	-- whenever the search timer ends look for the player
	if patroller:isTimerComplete("search") then
		patroller:resetTimer("search")

		-- check if the player is along patroller's x or y axis
		local pDirection = patroller:findPlayerAlignment()
		if pDirection ~= "none" then
			patroller.direction = pDirection

			-- check if player within attack range
			local pDistance = patroller:getPlayerDistanceByDirection(pDirection)
			local range = patroller.abilities["attack"].range
			if  pDistance <= range then
				patroller:changeState("attack")
				return
			end
		end
	end

	EnemyWalkState.update(self, dt)

	-- when patrol timer ends return to idle state
	if patroller:isTimerComplete("patrol") then
		patroller:changeState("idle")
	end
end