local correctKey = "KLWJH92iojc98j2k;la902" -- Set the correct key
        local scriptUrl = "https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/controllermap.lua" -- Replace with your script URL

local player = game.Players.LocalPlayer

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
mainFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = gui

local keyLabel = Instance.new("TextLabel")
keyLabel.Text = "Enter Key:"
keyLabel.Font = Enum.Font.SourceSansBold
keyLabel.TextSize = 18
keyLabel.Size = UDim2.new(1, 0, 0.2, 0)
keyLabel.Position = UDim2.new(0, 0, 0, 0)
keyLabel.TextColor3 = Color3.new(1, 1, 1)
keyLabel.Parent = mainFrame

local keyTextBox = Instance.new("TextBox")
keyTextBox.PlaceholderText = "Enter key here"
keyTextBox.Size = UDim2.new(1, 0, 0.3, 0)
keyTextBox.Position = UDim2.new(0, 0, 0.2, 0)
keyTextBox.TextColor3 = Color3.new(0, 0, 0)
keyTextBox.BackgroundTransparency = 0.8
keyTextBox.Parent = mainFrame

local checkKeyButton = Instance.new("TextButton")
checkKeyButton.Text = "Check Key"
checkKeyButton.Size = UDim2.new(1, 0, 0.2, 0)
checkKeyButton.Position = UDim2.new(0, 0, 0.5, 0)
checkKeyButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
checkKeyButton.TextColor3 = Color3.new(1, 1, 1)
checkKeyButton.Parent = mainFrame

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.5, 0, 0.2, 0)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.5
loadingFrame.BorderSizePixel = 2
loadingFrame.BorderColor3 = Color3.new(1, 1, 1)
loadingFrame.Visible = false
loadingFrame.Parent = gui

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Text = "Loading..."
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextSize = 18
loadingLabel.Size = UDim2.new(1, 0, 1, 0)
loadingLabel.Position = UDim2.new(0, 0, 0, 0)
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Parent = loadingFrame

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
        loadingFrame.Visible = true
        notify("SyntaxSucks", "Controller Loaded", 5)

        -- Check if the key belongs to the local player
        if player.UserId == tonumber(keyTextBox.Text) then
            -- Load the external script (replace "your_script_url_here" with the actual URL)
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
