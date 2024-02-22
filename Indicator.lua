-- Get references to game services and objects
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Variable to store the previous closest rim and distance
local previousClosestRim = nil
local previousDistance = nil
local wasOutOfRange = false -- Track if the player was previously out of range

-- Function to get the closest hoop
function getClosest()
    local closestDistance = math.huge
    local closestRim = nil

    for _, v in pairs(Workspace.Courts:GetDescendants()) do
        if v.Name == "hoop" then
            local distance = (Players.LocalPlayer.Character and Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude

            if distance and distance < closestDistance then
                closestDistance = distance
                closestRim = v
            end
        end
    end

    if previousClosestRim ~= closestRim then
        previousClosestRim = closestRim
    end

    return closestRim
end

-- Function to create and update the torso outline
function updateTorsoOutline(playerCharacter, inRange)
    local torso = playerCharacter and playerCharacter:FindFirstChild("Torso")

    if torso then
        local outline = torso:FindFirstChild("Outline") or Instance.new("SelectionBox")
        outline.Name = "Outline"
        outline.Adornee = torso
        outline.LineThickness = 0.05

        local playerAndHoopDistance = (playerCharacter.HumanoidRootPart.Position - (getClosest() and getClosest().Position or Vector3.new())).magnitude

        if inRange and playerAndHoopDistance >= 61.5 and playerAndHoopDistance <= 77.5 then
            outline.SurfaceTransparency = 0
            outline.Color3 = Color3.new(0, 1, 0) -- Green when in range and between 61.5 and 77.5 units away
            wasOutOfRange = false -- Player is now in range, reset the out of range flag
        else
            outline.SurfaceTransparency = 0.5
            outline.Color3 = Color3.new(1, 0, 0) -- Red when out of range, below 61.5, or above 77.5 units

            -- Send built-in notification when player becomes out of range
            if not wasOutOfRange then
                StarterGui:SetCore("SendNotification", {
                    Title = "Out of Range",
                    Text = "You are out of range. Credits to SyntaxSucks.",
                    Icon = "rbxassetid://445890139", -- Replace with the actual asset ID for the notification icon
                    Duration = 3 -- Adjust as needed
                })
                wasOutOfRange = true -- Set the out of range flag
            end
        end

        outline.Parent = torso
    end
end

-- In Range And Out Of Range
spawn(function()
    while wait() do
        local player = Players.LocalPlayer
        local playerCharacter = player.Character

        if playerCharacter then
            local inRange = false
            local playerAndHoopDistance = (playerCharacter.HumanoidRootPart.Position - (getClosest() and getClosest().Position or Vector3.new())).magnitude

            if playerAndHoopDistance >= 61.5 and playerAndHoopDistance <= 77.5 then
                inRange = true
            end

            updateTorsoOutline(playerCharacter, inRange)
        end
    end
end)
