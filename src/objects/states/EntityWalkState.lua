--[[
	Tetromancer

	Alex Friberg

	Created:		11.30.20
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
	self.entity = entity
end


function EntityWalkState:update(dt)
	local entity = self.entity

	-- update entity's animation based on direction
	entity:changeAnimation("walk-" .. entity.direction)

	-- move entity based on speed and direction
	entity:move(dt)
end

