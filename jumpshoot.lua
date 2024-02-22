local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local GUI = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local function getClosestHoop()
	local closestDistance = math.huge
	local closestHoop = nil

	for _, v in pairs(Workspace.Courts:GetDescendants()) do
		if v.Name == "hoop" then
			local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestHoop = v -- <3
			end
		end
	end

	return closestHoop
end

local function aimbot()
	local keyToClick = Enum.KeyCode.X
    local ping = LocalPlayer.Ping
	local waitTime = (ping.Value <= 83 and 0.195) or (ping.Value <= 120 and 0.155) or 0.125
	local vim = game:GetService("VirtualInputManager")
	spawn(function()
        wait(waitTime)
		vim:SendKeyEvent(true, keyToClick, false, game)
		wait(0.1)
		vim:SendKeyEvent(false, keyToClick, false, game)
    end)

	-- Check if aim is still enabled before entering the loop
	if not _G.aim then
		return
	end

	while _G.aim do
		local playerAndHoopDistance = (LocalPlayer.Character.HumanoidRootPart.Position - getClosestHoop().Position).magnitude

		if playerAndHoopDistance <= 61.999999 and playerAndHoopDistance >= 59 then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, getClosestHoop().Position + Vector3.new(0, 60, 0))
		elseif playerAndHoopDistance <= 47.2 and playerAndHoopDistance >= 39 then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, getClosestHoop().Position + Vector3.new(0, 65, 0))
			-- Add more conditions as needed
		else
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, getClosestHoop().Position + Vector3.new(0, 70, 0))
		end

		wait()  -- No delay between checks
	end
end

-- Use Humanoid.Jumping event to trigger aimbot
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	humanoid.Jumping:Connect(function(isJumping)
		if isJumping then
			print("Player jumped")
			GUI:SetCore("SendNotification", {
				Title = "Aimbotting...",
				Text = "Made by syntaxsucks.",
				Duration = 5
			})
			aimbot()
			wait(1)  -- Wait for 1 second after calling aimbot
			_G.aim = false  -- Disable aimbot after 1 second
			print("Aimbot disabled")
		end
	end)
end	
