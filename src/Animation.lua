--[[
    GD50
    Legend of Zelda

    -- Animation Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Note: This version of Animation includes small changes to the original code
    to fix a visual glitch with non-looping animations.
]]

Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.nonlooping = def.nonlooping    -- original implementation forced looping to be true

    self.timer = 0
    self.currentFrame = 1

    -- used to see if we've seen a whole loop of the animation
    self.timesPlayed = 0
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    -- if not a looping animation and we've played at least once, exit
    if self.nonlooping and self.timesPlayed > 0 then
        return
    end

    -- no need to update if animation is only one frame
    if #self.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            -- change to fix a visual glitch: non-looping animations should not progress back to the first frame
            local nextFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
            if nextFrame == 1 then
                if not self.nonlooping then
                    self.currentFrame = 1
                end

                self.timesPlayed = self.timesPlayed + 1
            else
                self.currentFrame = nextFrame
            end
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end