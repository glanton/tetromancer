--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.10.20
	Last Updated:	12.10.20
]]

PlayerAttackState = Class{__includes = BaseState}

function PlayerAttackState:init(entity)
	self.entity = entity

	self.entity.xRenderOffset = ABILITY_X_OFFSET
	self.entity.yRenderOffset = ABILITY_Y_OFFSET
end


function PlayerAttackState:enter(ability)
	self.entity.speed = self.entity.abilities[ability].speed

	self.hitbox = Hitbox(self.entity, self.entity.abilities[ability])

	self.entity:changeAnimation(ability .. "-" .. self.entity.direction)
end


function PlayerAttackState:update(dt)
	local player = self.entity

	-- move player based on speed and direction
	player:move(dt)

	-- if colliding with tile reset to the origin position before moving
	if player:isTileColliding() or player:isEntityColliding() then
		player:resetPosition()
	end

	-- update the hitbox to track with the charger as it charges
	self.hitbox:moveWithParent()

	-- process hits
	self.hitbox:update()

	-- it is expected that implementors of this class will handle exit logic
end


function PlayerAttackState:render()
	self.hitbox:render()
end