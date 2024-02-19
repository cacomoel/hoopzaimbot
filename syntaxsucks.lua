local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

-- Customize these variables
local keyUIName = "KeyUI"
local frameSize = UDim2.new(0, 300, 0, 200)
local framePosition = UDim2.new(0.5, -150, 0.5, -100)
local frameBackgroundColor = Color3.new(1, 1, 1)
local frameBorderSize = 2
local keyTextBoxSize = UDim2.new(0, 200, 0, 30)
local keyTextBoxPosition = UDim2.new(0.5, -100, 0.5, -15)
local keyTextBoxPlaceholder = "Enter key..."
local submitButtonSize = UDim2.new(0, 100, 0, 30)
local submitButtonPosition = UDim2.new(0.5, -50, 0.5, 20)
local submitButtonText = "Submit"
local getKeyButtonSize = UDim2.new(0, 100, 0, 30)
local getKeyButtonPosition = UDim2.new(0.5, -50, 0.5, -60)
local getKeyButtonText = "Get Key"
local correctKey = "123" -- Your key
local linkToExecute = "YOUR_LINK_HERE" -- Replace with the actual link

-- Create a ScreenGui
local keyUI = Instance.new("ScreenGui")
keyUI.Name = keyUIName
keyUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame to hold the key input UI
local frame = Instance.new("Frame")
frame.Size = frameSize
frame.Position = framePosition
frame.BackgroundColor3 = frameBackgroundColor
frame.BorderSizePixel = frameBorderSize
frame.Parent = keyUI

-- Create a TextBox for key input
local keyTextBox = Instance.new("TextBox")
keyTextBox.Size = keyTextBoxSize
keyTextBox.Position = keyTextBoxPosition
keyTextBox.PlaceholderText = keyTextBoxPlaceholder
keyTextBox.Parent = frame

-- Create a TextButton for submitting the key
local submitButton = Instance.new("TextButton")
submitButton.Size = submitButtonSize
submitButton.Position = submitButtonPosition
submitButton.Text = submitButtonText
submitButton.Parent = frame

-- Create a TextButton for getting the key
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = getKeyButtonSize
getKeyButton.Position = getKeyButtonPosition
getKeyButton.Text = getKeyButtonText
getKeyButton.Parent = frame

-- Function to handle key submission
local function handleKeySubmission()
    local input = keyTextBox.Text

    if input == correctKey then
        keyUI:Destroy() -- Close the UI
        -- Replace the link with the actual link you want to execute
        loadstring(game:HttpGet(linkToExecute))()
    else
        keyTextBox.Text = ""
        warn("Invalid key. Try again.")
    end
end

-- Function to copy link to clipboard
local function copyLinkToClipboard()
    GuiService.Clipboard:SetText(linkToExecute)
    warn("Link copied to clipboard!")
end

-- Connect functions to the buttons' Click events
submitButton.MouseButton1Click:Connect(handleKeySubmission)
getKeyButton.MouseButton1Click:Connect(copyLinkToClipboard)
