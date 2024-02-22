function getClosestBasketball()
    local closestDistance = math.huge
    local closestBasketball = nil
    for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v.Name == "Ball" then
            local distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestBasketball = v
            end
        end
    end
    return closestBasketball
end
 
 
local humRootPart = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
 
 
spawn(function()
while mag do
wait()
local magDistance = (humRootPart.Position - getClosestBasketball().Position).magnitude
if magDistance <= magRange then
firetouchinterest(humRootPart, getClosestBasketball(), 0)
wait(0.001)
firetouchinterest(humRootPart, getClosestBasketball(), 1)
end
end
end)
end)
