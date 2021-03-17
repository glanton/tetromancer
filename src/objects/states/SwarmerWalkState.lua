--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.07.20
]]

SwarmerWalkState = Class{__includes = EnemyWalkState}

function SwarmerWalkState:enter()
	-- randomize timer start so all swarmers do not re-orient at exactly the same time
	self.entity:setTimer("search", -math.random())

	-- collision with a swarmer body causes damage to the player
	self.hitbox = Hitbox(self.entity, self.entity.abilities["collide"])
end


function SwarmerWalkState:update(dt)
	local swarmer = self.entity

	-- whenever the search timer ends look for the player and re-orient
	if swarmer:isTimerComplete("search") then
		swarmer:resetTimer("search")
		swarmer:orientToPlayer()
	end

	EnemyWalkState.update(self, dt)

	-- update the hitbox to track with the swarmer after it has moved
	self.hitbox:moveWithParent()

	-- process hits
	self.hitbox:update()
end


function SwarmerWalkState:render()
	self.hitbox:render()
end