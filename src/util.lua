--[[
    Tetromancer

    Author attribution given in function comments.

    Created:        11.28.20
    Last Updated:   12.10.20
]]

--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


--[[
    Author: Alex Friberg

    Prints the specified text in title size in the specified color.
]]
function printTitleText(text, color)
    love.graphics.setColor(color)
    love.graphics.setFont(gFonts['title'])
    local yCentered = math.floor((VIRTUAL_HEIGHT / 2) - (love.graphics.getFont():getHeight()))
    love.graphics.printf(text, 0, yCentered, VIRTUAL_WIDTH, "center")
end


--[[
    Author: Alex Friberg

    Prints the specified text in interface size and location in the specified color.
]]
function printPromptText(text, color)
    love.graphics.setColor(color)
    love.graphics.setFont(gFonts['interface'])
    local yCentered = math.floor((3 * (VIRTUAL_HEIGHT / 4)) - (love.graphics.getFont():getHeight() / 2))
    love.graphics.printf(text, 0, yCentered, VIRTUAL_WIDTH, "center")
end


--[[
    Author: Alex Friberg

    Render boxes in debug mode illustrating the actual sizes of various objects.
]]
function renderDebugBox(object, color)
    if DEBUG then
        love.graphics.setColor(color)
        love.graphics.setLineWidth(1)

        love.graphics.rectangle(
            "line", math.floor(object.x), math.floor(object.y), 
            math.floor(object.width), math.floor(object.height)
        )

        love.graphics.setColor(COLORS["lightest"])
    end
end


--[[
    Author: Michal Kottman
    https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
]]
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end