--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.06.20
]]

SwarmerIdleState = Class{__includes = EntityIdleState}

function SwarmerIdleState:update(dt)
	-- every entity must start with an idle state, but swarmers only walk
	self.entity:changeState("walk")
end