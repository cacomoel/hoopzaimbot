-- Set the correct key
local correctKey = "KLWJH92iojc98j2k;la902"
local scriptUrl = "https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/controllermap.lua"

local playersService = game:GetService("Players")
local player = playersService.LocalPlayer

-- Check if the player is valid
if not player or not player:IsA("Player") then
    warn("Script should be run by a player.")
    return
end

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ControllerSimulatorGui"
gui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = gui

-- Create a function to create labels
local function createLabel(text, size, position, parent)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = size
    label.Size = UDim2.new(1, 0, 0.2, 0)
    label.Position = position
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Parent = parent
    return label
end

-- Labels
createLabel("Enter Key:", 18, UDim2.new(0, 0, 0, 0), mainFrame)

-- TextBox
local keyTextBox = Instance.new("TextBox")
keyTextBox.PlaceholderText = "Enter key here"
keyTextBox.Size = UDim2.new(1, 0, 0.3, 0)
keyTextBox.Position = UDim2.new(0, 0, 0.2, 0)
keyTextBox.TextColor3 = Color3.new(0, 0, 0)
keyTextBox.BackgroundTransparency = 0.8
keyTextBox.Parent = mainFrame

-- Check Key Button
local checkKeyButton = Instance.new("TextButton")
checkKeyButton.Text = "Check Key"
checkKeyButton.Size = UDim2.new(1, 0, 0.2, 0)
checkKeyButton.Position = UDim2.new(0, 0, 0.5, 0)
checkKeyButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
checkKeyButton.TextColor3 = Color3.new(1, 1, 1)
checkKeyButton.Parent = mainFrame

-- Loading Frame
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.5, 0, 0.2, 0)
loadingFrame.Position = UDim2.new(0.25, 0, 0.4, 0)
loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.5
loadingFrame.BorderSizePixel = 2
loadingFrame.BorderColor3 = Color3.new(1, 1, 1)
loadingFrame.Visible = false
loadingFrame.Parent = gui

-- Loading Label
local loadingLabel = createLabel("Loading...", 18, UDim2.new(0, 0, 0, 0), loadingFrame)

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Text = "Get Key"
getKeyButton.Size = UDim2.new(1, 0, 0.2, 0)
getKeyButton.Position = UDim2.new(0, 0, 0.7, 0)
getKeyButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
getKeyButton.TextColor3 = Color3.new(1, 1, 1)
getKeyButton.Parent = mainFrame

-- Notification Function
local function notify(title, description, duration)
    local Notification = Instance.new("TextLabel")
    Notification.Text = title .. "\n" .. description
    Notification.Size = UDim2.new(0.2, 0, 0.1, 0)
    Notification.Position = UDim2.new(0.5, 0, 0.8, 0)
    Notification.BackgroundTransparency = 0.5
    Notification.BackgroundColor3 = Color3.new(0, 0, 0)
    Notification.TextColor3 = Color3.new(1, 1, 1)
    Notification.Font = Enum.Font.SourceSansBold
    Notification.TextSize = 18
    Notification.Parent = gui

    wait(duration or 5)

    Notification:Destroy()
end

-- Tweening function for animations
local function tweenObject(obj, propertyTable)
    local tweenInfo = TweenInfo.new(0.5)
    local tween = game:GetService("TweenService"):Create(obj, tweenInfo, propertyTable)
    tween:Play()
end

-- Simulate 'X' key press and release on BUTTONR2 press (controller) and mouse click
local vim = game:GetService("VirtualInputManager")

local function handleInput(input)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonR2 then
            vim:SendKeyEvent(true, Enum.KeyCode.X, false, game)
            wait(0.2) -- Wait for 0.2 seconds
            vim:SendKeyEvent(false, Enum.KeyCode.X, false, game) -- Release the key
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        vim:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        wait(0.2) -- Wait for 0.2 seconds
        vim:SendKeyEvent(false, Enum.KeyCode.X, false, game) -- Release the key
    end
end

-- Check Key Button Click Event
checkKeyButton.MouseButton1Click:Connect(function()
    if keyTextBox.Text == correctKey then
        mainFrame.Visible = false
        notify("SyntaxSucks", "Controller Loaded", 5)
        loadingFrame.Visible = true

        -- Animation for loadingFrame
        tweenObject(loadingFrame, {Size = UDim2.new(0.2, 0, 0.1, 0), Position = UDim2.new(0.4, 0, 0.45, 0)})

        wait(2) -- Simulating loading time

        -- Check if the key belongs to the local player
        if player.UserId == tonumber(keyTextBox.Text) then
            -- Load the external script from the specified URL
            local success, error = pcall(function()
                loadstring(game:HttpGet(scriptUrl))()
            end)

            if not success then
                warn("Failed to load the script: " .. error)
            end
        else
            warn("Invalid key for the current player.")
        end
    else
        notify("SyntaxSucks", "Incorrect key. Please try again.", 3)
    end
end)

-- Get Key Button Click Event
getKeyButton.MouseButton1Click:Connect(function()
    -- Copy script link to clipboard
    local success, message = pcall(function()
        if game:IsA("GuiService") and game:GetService("GuiService"):IsTenFootInterface() then
            -- For console platforms
            game:GetService("GuiService").Clipboard = scriptUrl
        else
            -- For PC and mobile
            local userInputService = game:GetService("UserInputService")
            if userInputService.TouchEnabled then
                -- Mobile
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "SyntaxSucks",
                    Text = "Script link copied to clipboard",
                    Duration = 5
                })
            else
                -- PC
                setclipboard(scriptUrl)
                notify("SyntaxSucks", "Script link copied to clipboard", 5)
            end
        end
    end)

    if not success then
        warn("Failed to copy script link to clipboard: " .. message)
    end
end)
