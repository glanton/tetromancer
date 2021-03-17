--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.07.20
]]

CasterWalkState = Class{__includes = PatrollerWalkState}

function CasterWalkState:update(dt)
	local caster = self.entity

	-- flee if the player gets too close
	if caster:getPlayerDistance() <= caster.abilities["flee"].range then
		caster:changeState("flee")
		return
	end

	PatrollerWalkState.update(self, dt)
end