-- Ball Mag

_G.magRange = 15 -- Set the magnet range
_G.mag = true -- Enable the magnet initially

function getClosestBasketball()
    local closestDistance = math.huge
    local closestBasketball = nil
    for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.Name == "Basketball" then
            local distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Ball.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestBasketball = v.Ball
            end
        end
    end
    return closestBasketball
end

spawn(function()
    while true do
        wait()
        if _G.mag then
            local closestBall = getClosestBasketball()
            if closestBall then
                local distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - closestBall.Position).magnitude
                if distance <= _G.magRange then
                    wait()
                    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, closestBall, 0)
                    wait(0.001)
                    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, closestBall, 1)
                end
            end
        else
            return
        end
    end
end)
