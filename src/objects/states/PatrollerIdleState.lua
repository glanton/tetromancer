--[[
	Tetromancer

	Alex Friberg

	Created:		12.07.20
]]

PatrollerIdleState = Class{__includes = EntityIdleState}

function PatrollerIdleState:enter()
	-- reset the waits timer to control how long the patroller waits for
	self.entity:resetTimer("wait")
end


function PatrollerIdleState:update(dt)
	-- wait for a set period of time, then begin patrolling
	if self.entity:isTimerComplete("wait") then
		self.entity:changeState("walk")
	end
end