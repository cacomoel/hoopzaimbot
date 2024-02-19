local Player = game:GetService("Players").LocalPlayer

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local TI = TweenInfo.new(0.1)

local NormalSize = Vector3.new(1, 2, 1)
local BigSize = Vector3.new(20, 2, 1)

local Toggled = false

local RemoveConnections = function()
    for _, Connection in next, getconnections(Player.Character["Left Arm"]:GetPropertyChangedSignal("Size")) do
        Connection:Disable()
    end
    for _, Connection in next, getconnections(Player.Character["Right Arm"]:GetPropertyChangedSignal("Size")) do
        Connection:Disable()
    end
end

UIS.InputBegan:Connect(function(Key, GPE)
    if GPE == false and Key.KeyCode == Enum.KeyCode.Y then
        Toggled = not Toggled
        
        RemoveConnections()

        if Toggled == true then
            TS:Create(Player.Character["Left Arm"], TI, {Size = BigSize}):Play()
            TS:Create(Player.Character["Right Arm"], TI, {Size = BigSize}):Play()
        else
            TS:Create(Player.Character["Left Arm"], TI, {Size = NormalSize}):Play()
            TS:Create(Player.Character["Right Arm"], TI, {Size = NormalSize}):Play()
        end
    end
end)

if getgenv().Hooked ~= true then
    getgenv().Hooked = true
    
    local Hook do
        Hook = hookmetamethod(game, "__index", newcclosure(function(Self, Index)
            if Self:IsA("BasePart") and tostring(Self) == "Left Arm" or tostring(Self) == "Right Arm" and Index == "Size" then
                return NormalSize
            end
            
            return Hook(Self, Index)
        end))
    end
end
