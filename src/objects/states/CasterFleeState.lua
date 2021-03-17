--[[
	Tetromancer

	Alex Friberg

	Created:		12.07.20
]]

CasterFleeState = Class{__includes = EnemyWalkState}

function CasterFleeState:enter()
	self.entity:resetTimer("panic")

	-- set flee speed and orient direction away from player
	self.entity.speed = self.entity.abilities["flee"].speed
	self.entity:orientAwayFromPlayer()
end


function CasterFleeState:update(dt)
	local caster = self.entity

	EnemyWalkState.update(self, dt)

	-- when the panic time hits attack the player
	if caster:isTimerComplete("panic") then
		caster:orientToPlayer()
		caster:changeState("attack")
		return
	end

	-- when player is out of flee range slow down and return to walk state
	if caster:getPlayerDistance() > caster.abilities["flee"].range then
		caster.speed = caster.baseSpeed
		caster:changeState("walk")
	end
end