local correctKey = "KLWJH92iojc98j2k;la902"
local scriptUrl = "https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/controllermap.lua"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer or not LocalPlayer:IsA("Player") then
    warn("Script should be run by a player.")
    return
end

local function createGuiElement(guiType, properties)
    local element = Instance.new(guiType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function tweenObject(obj, propertyTable)
    local tweenInfo = TweenInfo.new(0.5)
    local tween = game:GetService("TweenService"):Create(obj, tweenInfo, propertyTable)
    tween:Play()
end

local function notify(title, description, duration)
    local Notification = createGuiElement("TextLabel", {
        Text = title .. "\n" .. description,
        Size = UDim2.new(0.2, 0, 0.1, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        Parent = LocalPlayer.PlayerGui
    })

    wait(duration or 5)
    Notification:Destroy()
end

local function simulateKeyPress(keyCode)
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, keyCode, false, game)
    wait(0.2)
    vim:SendKeyEvent(false, keyCode, false, game)
end

local function loadScript()
    local success, error = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)

    if not success then
        warn("Failed to load the script: " .. error)
    end
end

local gui = createGuiElement("ScreenGui", {Name = "ControllerSimulatorGui", Parent = LocalPlayer.PlayerGui})

local mainFrame = createGuiElement("Frame", {
    Size = UDim2.new(0.5, 0, 0.5, 0),
    Position = UDim2.new(0.25, 0, 0.25, 0),
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    BorderSizePixel = 2,
    BorderColor3 = Color3.new(1, 1, 1),
    Parent = gui
})

createGuiElement("TextLabel", {
    Text = "Enter Key:",
    TextSize = 18,
    Size = UDim2.new(1, 0, 0.2, 0),
    Position = UDim2.new(0, 0, 0, 0),
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1,
    Parent = mainFrame
})

local keyTextBox = createGuiElement("TextBox", {
    PlaceholderText = "Enter key here",
    Size = UDim2.new(1, 0, 0.3, 0),
    Position = UDim2.new(0, 0, 0.2, 0),
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 0.8,
    BackgroundColor3 = Color3.fromRGB(51, 51, 51),
    BorderSizePixel = 0,
    Parent = mainFrame
})

local checkKeyButton = createGuiElement("TextButton", {
    Text = "Check Key",
    Size = UDim2.new(1, 0, 0.2, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(70, 70, 70),
    TextColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Parent = mainFrame
})

local loadingFrame = createGuiElement("Frame", {
    Size = UDim2.new(0.2, 0, 0.1, 0),
    Position = UDim2.new(0.4, 0, 0.45, 0),
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    BorderSizePixel = 2,
    BorderColor3 = Color3.new(1, 1, 1),
    Visible = false,
    Parent = gui
})

createGuiElement("TextLabel", {
    Text = "Loading...",
    TextSize = 18,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1,
    Parent = loadingFrame
})

local getKeyButton = createGuiElement("TextButton", {
    Text = "Get Key",
    Size = UDim2.new(1, 0, 0.2, 0),
    Position = UDim2.new(0, 0, 0.7, 0),
    BackgroundColor3 = Color3.fromRGB(70, 70, 70),
    TextColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Parent = mainFrame
})

checkKeyButton.MouseButton1Click:Connect(function()
    if keyTextBox.Text == correctKey then
        mainFrame.Visible = false
        notify("SyntaxSucks", "Controller Loaded", 5)
        loadingFrame.Visible = true
        tweenObject(loadingFrame, {Size = UDim2.new(0.2, 0, 0.1, 0), Position = UDim2.new(0.4, 0, 0.45, 0)})

        wait(2)
        if LocalPlayer.UserId == tonumber(keyTextBox.Text) then
            simulateKeyPress(Enum.KeyCode.X)
            wait(0.2) -- Allow time for the keypress simulation to take effect
            loadScript()
            loadingFrame.Visible = false -- Hide the loading frame after script execution
        else
            warn("Invalid key for the current player.")
            notify("SyntaxSucks", "Invalid key. Please try again.", 3)
            loadingFrame.Visible = false -- Hide the loading frame in case of an invalid key
        end
    else
        notify("SyntaxSucks", "Incorrect key. Please try again.", 3)
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    local success, message = pcall(function()
        if game:IsA("GuiService") and game:GetService("GuiService"):IsTenFootInterface() then
            game:GetService("GuiService").Clipboard = scriptUrl
        else
            local userInputService = game:GetService("UserInputService")
            if userInputService.TouchEnabled then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "SyntaxSucks",
                    Text = "Script link copied to clipboard",
                    Duration = 5
                })
            else
                setclipboard(scriptUrl)
                notify("SyntaxSucks", "Script link copied to clipboard", 5)
            end
        end
    end)

    if not success then
        warn("Failed to copy script link to clipboard: " .. message)
    end
end)
