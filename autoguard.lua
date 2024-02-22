local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
 
local lastChasingState = false -- Initialize the last chasing state
local maxChaseDistance = 45 -- Maximum distance to chase
 
-- Function to check if the local player has a basketball
function hasLocalPlayerBasketball()
    local localPlayer = Players.LocalPlayer
    local basketball = localPlayer.Character and localPlayer.Character:FindFirstChild("Basketball")
 
    return basketball and basketball:FindFirstChild("Ball") ~= nil
end
 
-- Function to find the nearest basketball tool in the workspace
function findNearestBasketball()
    local localPlayer = Players.LocalPlayer
    local basketballTools = {}
 
    -- Collect all basketball tools from all players in the workspace
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local basketball = player.Character and player.Character:FindFirstChild("Basketball")
 
            if basketball and basketball:FindFirstChild("Ball") then
                table.insert(basketballTools, basketball.Ball)
            end
        end
    end
 
    -- Find the nearest basketball tool
    local nearestBasketball = nil
    local nearestDistance = math.huge -- Initialize to a large finite value
 
    local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
 
    if not humanoidRootPart then
        return nil, nearestDistance
    end
 
    for _, ball in pairs(basketballTools) do
        local distance = (humanoidRootPart.Position - ball.Position).magnitude
 
        if distance < nearestDistance then
            nearestDistance = distance
            nearestBasketball = ball
        end
    end
 
    return nearestBasketball, nearestDistance
end
 
-- Function to show a notification with credits
local function showNotification(title, description)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = description .. "\nMade by Jermy",
        Duration = 2
    })
end
 
-- Move towards the target position
local function moveTo(targetPosition)
    local localPlayer = Players.LocalPlayer
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
 
    if humanoid then
        humanoid:MoveTo(targetPosition)
    end
end
 
-- Continuous loop to find the nearest basketball and move towards it
while true do
    wait(0.1) -- Adjust the wait time as needed
 
    if not hasLocalPlayerBasketball() then
        local nearestBasketball, nearestDistance = findNearestBasketball()
 
        if nearestBasketball then
            if nearestDistance < maxChaseDistance and not lastChasingState then
                -- Notify when changing from not chasing to chasing
                showNotification("Chasing Basketball", "Locked onto a basketball!")
                lastChasingState = true
            elseif nearestDistance >= maxChaseDistance and lastChasingState then
                -- Notify when changing from chasing to out of range
                showNotification("Out of Range", "The basketball is out of range.")
                lastChasingState = false
            end
 
            if nearestDistance < maxChaseDistance then
                moveTo(nearestBasketball.Position)
            end
        else
            if lastChasingState then
                -- Notify when changing from chasing to not chasing
                showNotification("Not Chasing Basketball", "No basketball found.")
                lastChasingState = false
            end
        end
    else
        if lastChasingState then
            -- Notify when changing from chasing to not chasing
            showNotification("Not Chasing Basketball", "You already have a basketball.")
            lastChasingState = false
        end
    end
end
