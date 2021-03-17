--[[
	Tetromancer

	Alex Friberg
	
	Created:		11.30.20
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
	self.entity = entity

	self.entity:changeAnimation("idle-" .. self.entity.direction)
end