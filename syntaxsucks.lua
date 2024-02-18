local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local aimbotURL = "https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/aimbot.lua"
local controllerMapURL = "https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/controllermap.lua"

-- Function to display a notification
local function showNotification(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Script Loaded",
        Text = message,
        Icon = "rbxassetid://1299491401",
        Duration = 5, -- Duration in seconds
    })
end

-- Function to create and display a styled temporary GUI with fade-in animation
local function showTemporaryGUI(message, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = "TemporaryGUI"
    gui.Parent = Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Dark background color
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.8, -50)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NotificationText"
    textLabel.Parent = frame
    textLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Match the background color
    textLabel.BackgroundTransparency = 0.8
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = message
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextSize = 18
    textLabel.TextWrapped = true

    -- Fade-in animation using TweenService
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    local goal = {}
    goal.BackgroundTransparency = 0
    goal.Position = UDim2.new(0.5, -150, 0.8, -50)

    local tween = TweenService:Create(frame, tweenInfo, goal)
    tween:Play()

    wait(duration or 10) -- Wait for the specified duration

    gui:Destroy()
end

-- Load and execute the controller map script using loadstring
local controllerMapScript, controllerMapError = loadstring(game:HttpGet(controllerMapURL))
if controllerMapScript then
    local success, errorMessage = pcall(controllerMapScript)
    if not success then
        warn("Error executing controller script: " .. errorMessage)
    else
        showNotification("Controller script loaded successfully!")
        showTemporaryGUI("To use it, bind your controller shoot button to something you do not use and just jump and press your R2 button.")
    end
else
    warn("Error loading controller script: " .. controllerMapError)
end

-- Load and execute the aimbot script using loadstring
local aimbotScript, aimbotError = loadstring(game:HttpGet(aimbotURL))
if aimbotScript then
    local success, errorMessage = pcall(aimbotScript)
    if not success then
        warn("Error executing aimbot script: " .. errorMessage)
    else
        showNotification("Aimbot script loaded successfully!")
        showTemporaryGUI("To use it, bind your shoot button to something you do not use and just jump and press your R2 button.")
    end
else
    warn("Error loading aimbot script: " .. aimbotError)
end
