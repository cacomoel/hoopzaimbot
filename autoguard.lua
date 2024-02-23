local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local chasingEnabled = false
local lastChasingState = false -- Initialize the last chasing state
local maxChaseDistance = 75 -- Maximum distance to chase

-- UI setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Text = "Chasing: OFF"
button.Position = UDim2.new(0.5, 0, 0.9, 0)
button.Size = UDim2.new(0, 150, 0, 30)
button.Parent = screenGui

local function toggleChasing()
    chasingEnabled = not chasingEnabled
    button.Text = chasingEnabled and "Chasing: ON" or "Chasing: OFF"
end

button.MouseButton1Click:Connect(toggleChasing)

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

-- Function to handle chasing logic
local function handleChasingLogic()
     wait(0.01)
    if chasingEnabled and not hasLocalPlayerBasketball() then
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
            showNotification("Not Chasing Basketball", "Chasing is disabled or you already have a basketball.")
            lastChasingState = false
        end
    end
end

-- Connect the function to the RenderStepped event
RunService.RenderStepped:Connect(handleChasingLogic)
