function love.load()
    -- initializations
    love.window.setMode(1000, 1000, {fullscreen=false, resizable=true, borderless= false, centered=true})
    love.window.setVSync(-1)
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    width, height, mode = love.window.getMode()
    x = width / 2
    y = height
    x2 = width / 2
    y2 = height / 2
    repeats = 0
    i = 0
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(3)
    radius = love.graphics.getLineWidth() + 2
    speed = 1500
    linecolor = "yellow"
    poly = false
    polycolor = {}
    for i = 0, 255 do
        polycolor[i] = {math.random(), 
                        math.random(), 
                        math.random()}
    end
end

function love.update(dt)
    -- skip input step if no joystick connected to prevent errors
    if not joystick then return end

    -- setting cursor speed boost with right trigger, scales up with amount of reflections (repeats)
    boost = speed * (joystick:getGamepadAxis("triggerright")*(repeats+1)*2 + 1)

    -- update window state for accurate reflection edge calculations
    width, height, mode = love.window.getMode()

-- line color modulation
    trigmod1 = ((joystick:getGamepadAxis("triggerleft") + math.random()) / 1.5)
    trigmod2 = ((joystick:getGamepadAxis("triggerleft") + math.random()) / 1.5)
    trigmod3 = ((joystick:getGamepadAxis("triggerleft") + math.random()) / 1.5)
    if linecolor == "green" then
        color = {trigmod1,1-trigmod2,trigmod3}
        if joystick:getGamepadAxis("triggerleft") == 0 then
            color = {0,1,0}
        end
    elseif linecolor == "red" then
        color = {1-trigmod1,trigmod2,trigmod3}
        if joystick:getGamepadAxis("triggerleft") == 0 then
            color = {1,0,0}
        end
    elseif linecolor == "yellow" then
        color = {1.627-trigmod1,1.125-trigmod2,trigmod3}
        if joystick:getGamepadAxis("triggerleft") == 0 then
            color = {1,1,0}
        end
    elseif linecolor == "blue" then
        color = {trigmod1,trigmod2-.6,1-trigmod3}
        if joystick:getGamepadAxis("triggerleft") == 0 then
            color = {0,0,1}
        end
    elseif linecolor == "random" then
        color = {trigmod1*1.5, trigmod2*1.5, trigmod3*1.5}
    elseif linecolor == "srandom" then
        color = {
            polycolor[i][1] + joystick:getGamepadAxis("triggerleft"),
            polycolor[i][2] + joystick:getGamepadAxis("triggerleft"),
            polycolor[i][3] + joystick:getGamepadAxis("triggerleft")}
    end
    love.graphics.setColor(color)
    
-- scale down speed with number of reflections for visual clarity
    dt = dt * boost / (1 + repeats * 3.5)

-- extra speed boost to escape corners
    if (x2 == 0 and (y2 == 0 or y2 == height)) or (x2 == width and (y2 == 0 or y2 == height)) then
        dt = dt * 12
    end

-- joystick movement
    -- origin point left stick movement
    if joystick:getGamepadAxis("leftx") > 0.1 or joystick:getGamepadAxis("leftx") < -0.1 then
        x = x + dt*joystick:getGamepadAxis("leftx")
    end
    if joystick:getGamepadAxis("lefty") > 0.1 or joystick:getGamepadAxis("lefty") < -0.1 then
        y = y + dt*joystick:getGamepadAxis("lefty")
    end

    -- destination point right stick movement
    if joystick:getGamepadAxis("rightx") > 0.1 or joystick:getGamepadAxis("rightx") < -0.1 then
        x2 = x2 + dt*joystick:getGamepadAxis("rightx")
    end
    if joystick:getGamepadAxis("righty") > 0.1 or joystick:getGamepadAxis("righty") < -0.1 then
        y2 = y2 + dt*joystick:getGamepadAxis("righty")
    end

-- edge detection:
    -- left stick
    if x < 0  then
        x = 0
    elseif x > width then
        x = width
    end
    if y < 0  then
        y = 0
    elseif y > height then
        y = height
    end
    -- right stick (sticky to edges, must use right trigger speed boost to break free)
    if x2 < 12  then
        x2 = 0
    elseif x2 > width - 12 then
        x2 = width
    end
    if y2 < 12  then
        y2 = 0
    elseif y2 > height - 12 then
        y2 = height
    end
    -- preventing getting stuck in corners
    -- if x2 == 0 then
    --     if y2 == 0 or y2 == height then
    --         x2 = 2
    --     end
    -- elseif x2 == width then
    --     if y2 == 0 or y2 == height then
    --         x2 = width - 2
    --     end
    -- elseif y2 == 0 then
    --     if x2 == 0 or x2 == width then
    --         y2 = 2
    --     end
    -- elseif y2 == height then
    --     if x2 == 0 or x2 == width then
    --         y2 = height - 2
    --     end
    -- end
end


function love.draw()
-- constant parent line btw the two controller input points
    points = {x, y, x2, y2}
    love.graphics.line(points)
-- recursive reflection algo
    reflect(points)
-- polygon mode
    if poly and #points > 4 then
        love.graphics.stencil(polydraw, "incrementwrap", 0, true)
        for i = 0, 255 do
            love.graphics.setStencilTest("greater", i)
            love.graphics.rectangle("fill", 0, 0, width, height)
        -- seizure glitch mode
            if linecolor == "random" then
                if i % 2 == 0 then
                    love.graphics.setColor(
                        0 - joystick:getGamepadAxis("triggerleft")/2 + math.random(), 
                        0 - joystick:getGamepadAxis("triggerleft")/2 + math.random(), 
                        0 - joystick:getGamepadAxis("triggerleft")/2 + math.random())
                else
                    love.graphics.setColor(
                        joystick:getGamepadAxis("triggerleft")/2 + math.random(), 
                        joystick:getGamepadAxis("triggerleft")/2 + math.random(), 
                        joystick:getGamepadAxis("triggerleft")/2 + math.random())
                end
        -- static random colors mode
            elseif linecolor == "srandom" then
                if i % 2 == 0 then
                    love.graphics.setColor(
                        polycolor[i][1] + joystick:getGamepadAxis("triggerleft"),
                        polycolor[i][2] + joystick:getGamepadAxis("triggerleft"),
                        polycolor[i][3] + joystick:getGamepadAxis("triggerleft"))
                else
                    love.graphics.setColor(
                        polycolor[i][1] - joystick:getGamepadAxis("triggerleft"),
                        polycolor[i][2] - joystick:getGamepadAxis("triggerleft"),
                        polycolor[i][3] - joystick:getGamepadAxis("triggerleft"))
                end
        -- color gradient default
            else
                if i % 2 == 0 then
                    love.graphics.setColor(
                        color[1] + i/(repeats/2.17), 
                        color[2] + i/(repeats/2.17), 
                        color[3] + i/(repeats/2.17))
                else
                    love.graphics.setColor(
                        color[1] - i/(repeats/3), 
                        color[2] - i/(repeats/3), 
                        color[3] - i/(repeats/3))
                end
            end
            love.graphics.setStencilTest()
        end
    end
-- default line mode
    love.graphics.line(points)

-- indicator dot for left stick (origin point)
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill", x, y, radius)

-- indicator dot for right stick (dest point)
    love.graphics.setColor(0,1,0)
    love.graphics.circle("fill", x2, y2, radius)

-- repeats (no. of reflections) indicator
    love.graphics.print(repeats, width - 30, height - 30)
end


-- takes a line and recursively draws reflective lines up to the repeat limit, only activates when the parent line end point collides with an edge
function reflect(points)
    -- base case, terminates when repeats limit is reached
    if #points > (repeats * 2 + 4) then 
        return 
    end
    local x = points[#points - 3]
    local y = points[#points - 2]
    local x2 = points[#points - 1]
    local y2 = points[#points]
    local x3, y3 = nil
    -- reflecting off left edge
    if x2 == 0 then
        -- reflecting to opposite (right) edge
        x3 = width
        y3 = y2 - (width * (y - y2) / x)
        -- reflecting to top edge
        if y3 < 0 then
            x3 = (x * y2) / (y - y2)
            y3 = 0
        -- reflecting to bottom edge
        elseif y3 > height then
            x3 =  x / (y2 - y) * (height - y2) 
            y3 = height
        end
    -- reflecting off right edge
    elseif x2 == width then
        -- reflecting to left side
        x3 = 0
        y3 = y2 - (width * (y - y2) / (width - x))
        -- reflecting to top edge
        if y3 < 0 then
            x3 = width - (y2 * (width - x) / (y - y2))
            y3 = 0
        -- reflecting to bottom edge
        elseif y3 > height then
            x3 = width - ((height - y2) * (width - x) / (y2 - y))
            y3 = height
        end
    -- reflecting off top edge
    elseif y2 == 0 then
        -- reflecting to bottom edge
        x3 = (height * (x2 - x) / y) + x2
        y3 = height
        -- reflecting to left edge
        if x3 < 0 then
            x3 = 0
            y3 = x2 * y / (x - x2)
        -- reflecting to right edge
        elseif x3 > width then
            x3 = width
            y3 = y * (width - x2) / (x2 - x)
        end
    -- reflecting off bottom edge
    elseif y2 == height then
        -- reflecting to top edge
        x3 = height * (x2 - x) / (height - y) + x2
        y3 = 0
        -- reflecting to left edge
        if x3 < 0 then
            x3 = 0
            y3 = height - (x2 * (height - y) / (x - x2))
        -- reflecting to right edge
        elseif x3 > width then
            x3 = width
            y3 = height - ((height - y) * (width - x2) / (x2 - x))
        end
    -- no reflection if not touching edge (do nothing)
    else
        return
    end
    -- recursive case, draws reflective line then runs the reflection algo on it
    table.insert(points, #points + 1, x3)
    table.insert(points, #points + 1, y3)
    reflect(points)
    return          
end


function love.gamepadpressed(joystick, button)
-- dpad up/down reflection amount control (right trigger boosts)
    if button == "dpup" then
        repeats = math.floor(repeats + 1 + 9*joystick:getGamepadAxis("triggerright"))
    elseif button == "dpdown" then
        repeats = math.floor(repeats - 1 - 9*joystick:getGamepadAxis("triggerright"))
    end
    if repeats < 0 then
        repeats = 0
    end

-- face button color control
    if button == "a" then
        linecolor = "green"
    elseif button == "y" then
        linecolor = "yellow"
    elseif button == "x" then
        linecolor = "blue"
    elseif button == "b" then
        linecolor = "red"
    elseif button == "rightstick" then
        linecolor = "random"
    end

-- dpad left/right adjusting line thickness (right trigger boosts)
    if button == "dpright" then
        love.graphics.setLineWidth(love.graphics.getLineWidth() + 1 + 9*joystick:getGamepadAxis("triggerright"))
    elseif button == "dpleft" then
        love.graphics.setLineWidth(love.graphics.getLineWidth() - 1 - 9*joystick:getGamepadAxis("triggerright"))
    end
    if love.graphics.getLineWidth() < 1 then
        love.graphics.setLineWidth(1)
    end

-- non linear dynamic scaling of indicator dots with line thickness for visibility 
    radius = love.graphics.getLineWidth() / 2 + 1
    if radius < 5 then
        radius = 5
    end

-- fullscreen toggle
    if button == "back" then
        -- if mode["fullscreen"] == false then
        --     mode["fullscreen"] = true
        --     prevwidth, prevheight = love.window.getMode()
        --     love.window.setMode(width, height, mode)
        --     print(width, height, table.concat(mode))
        -- else
        --     mode["centered"] = true
        --     mode["borderless"] = false
        --     mode["fullscreen"] = false
        --     love.window.setMode(prevwidth, prevheight, mode)
        --     print(width, height, table.concat(mode))
        -- end
        fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen, "desktop")
    end
-- left stick click toggle poly or line
    if button == "leftstick" then
        poly = not poly
    end
-- guide button reinitialize colors
    if button == "guide" then
        linecolor = "srandom"
        for i = 0, 255 do
            polycolor[i] = {math.random(), 
                            math.random(), 
                            math.random()}
        end
    end
end


function polydraw()
    love.graphics.polygon("fill", points)
end