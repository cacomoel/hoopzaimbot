getgenv().keytoclick = Enum.KeyCode.X -- Change this to the desired key
local BUTTONR2 = Enum.KeyCode.ButtonR2 -- Change this to the desired button

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;
Notify({
    Description = "Controller Loaded";
    Title = "syntaxsucks";
    Duration = 10;
})

-- Simulate 'X' key press and release on BUTTONR2 press (controller) and mouse click
local vim = game:GetService("VirtualInputManager")

local function handleInput(input)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == BUTTONR2 then
            vim:SendKeyEvent(true, keytoclick, false, game)
            wait(0.2) -- Wait for 0.2 seconds
            vim:SendKeyEvent(false, keytoclick, false, game) -- Release the key
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        vim:SendKeyEvent(true, keytoclick, false, game)
        wait(0.2) -- Wait for 0.2 seconds
        vim:SendKeyEvent(false, keytoclick, false, game) -- Release the key
    end
end

local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(input, processed)
    if not processed then
        handleInput(input)
    end
end)

player.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.Gamepad1 then
        handleInput(input)
    end
end)
