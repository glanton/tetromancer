--[[
	Tetromancer

	Alex Friberg

	Created:		11.29.20
	Last Updated:	12.10.20
]]

Entity = Class{__includes = GameObject}

function Entity:init(def)
	self.abilities = def.abilities

	GameObject.init(self, def)

	-- alignment for entity sprites related to lowering the collision box
	self.yRenderOffset = -ENTITY_Y_OFFSET

	self.stateMachine = self:buildStateMachine(def.states)
	self:changeState("idle")
end


function Entity:buildStateMachine(states)
	local stateFunctions = {}
	for stateName, stateClass in pairs(states) do
		stateFunctions[stateName] = function() return _G[stateClass](self) end
	end

	return StateMachine(stateFunctions)
end


function Entity:changeState(name, enterParams)
	self.stateMachine:change(name, enterParams)
end


function Entity:update(dt)
	GameObject.update(self, dt)

	self.stateMachine:update(dt)
end


function Entity:render()
	GameObject.render(self)

	-----------------------------------------
	-- debug child hitbox rendering
	self.stateMachine.current:render()
end