-- Get the Players service
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- Insert a ScreenGui into StarterGui in the Explorer
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "KeySystemGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Key configuration
local validKey = "WelcomeToBreadHub"  -- Replace with your actual key
local getKeyLink = "https://discord.gg/SYkwKXU78Y"  -- Replace with your actual text

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)  -- Centered using AnchorPoint
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Parent = gui

-- Create Bread Hub logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 200, 0, 50)
logo.Position = UDim2.new(0.5, 0, 0.15, -25)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://1234567890" -- Replace with your actual logo asset ID
logo.Parent = mainFrame

-- Create Bread Hub text at the top
local breadHubText = Instance.new("TextLabel")
breadHubText.Size = UDim2.new(1, 0, 0, 30)
breadHubText.Position = UDim2.new(0, 0, 0, 10)
breadHubText.AnchorPoint = Vector2.new(0, 0)
breadHubText.BackgroundTransparency = 1
breadHubText.Text = "Bread Hub"
breadHubText.Font = Enum.Font.SourceSansBold
breadHubText.TextSize = 24
breadHubText.TextColor3 = Color3.new(0, 0, 0)
breadHubText.Parent = mainFrame

-- Create the key input TextBox
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 300, 0, 30)
keyInput.Position = UDim2.new(0.5, 0, 0.5, -20)
keyInput.AnchorPoint = Vector2.new(0.5, 0.5)
keyInput.BackgroundColor3 = Color3.new(1, 1, 1)
keyInput.BorderSizePixel = 0
keyInput.PlaceholderText = "Enter Key"
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 18
keyInput.Parent = mainFrame

-- Create the Check button
local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(0, 150, 0, 40)
checkButton.Position = UDim2.new(0.25, 0, 0.7, -20)
checkButton.AnchorPoint = Vector2.new(0.5, 0.5)
checkButton.BackgroundColor3 = Color3.new(0.4, 0.8, 0.4)
checkButton.BorderSizePixel = 1
checkButton.BorderColor3 = Color3.new(0.2, 0.6, 0.2)
checkButton.Text = "Check"
checkButton.Font = Enum.Font.SourceSansBold
checkButton.TextSize = 20
checkButton.Parent = mainFrame

-- Create the Get button
local getButton = Instance.new("TextButton")
getButton.Size = UDim2.new(0, 150, 0, 40)
getButton.Position = UDim2.new(0.75, 0, 0.7, -20)
getButton.AnchorPoint = Vector2.new(0.5, 0.5)
getButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.8)
getButton.BorderSizePixel = 1
getButton.BorderColor3 = Color3.new(0.2, 0.2, 0.6)
getButton.Text = "Get Key"
getButton.Font = Enum.Font.SourceSansBold
getButton.TextSize = 20
getButton.Parent = mainFrame

-- Event handlers
checkButton.MouseButton1Click:Connect(function()
    local enteredKey = keyInput.Text
    if enteredKey == validKey then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cacomoel/hoopzaimbot/main/2fa"))()
        StarterGui:SetCore("SendNotification", {
            Title = "Key Check",
            Text = "You entered the correct key!",
            Duration = 5
        })
        tweenButton(checkButton)
        mainFrame.Visible = false  -- Hide the UI when correct key is entered
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Key Check",
            Text = "Incorrect key. Please try again.",
            Duration = 5
        })
    end
end)

getButton.MouseButton1Click:Connect(function()
    getButton.MouseButton1Click:Connect(function(plr)
        StarterGui:SetCore("SendNotification", {
            Title = "Get Key",
            Text = "Key link copied to clipboard!",
            Duration = 5
        })
        setclipboard(tostring(getKeyLink))
        tweenButton(getButton)
    end)
end)

-- Function to perform tween animation on a button
function tweenButton(button)
    local originalColor = button.BackgroundColor3
    local tweenInfo = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)})
    tweenInfo:Play()

    tweenInfo.Completed:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end
