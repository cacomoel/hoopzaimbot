local reset = false

pcall(function()
	if _G.stepped then
		reset = true
		_G.stepped:Disconnect()
		_G.input:Disconnect()
		_G.charAdded:Disconnect()
		_G.charAdded = nil
		_G.stepped = nil
		_G.input = nil
		print("RESET")
	end

	if not reset then
		print("LOADED")
	end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Task = require(game:GetService("ReplicatedStorage"):WaitForChild("Task"))

_G.Aimbot = true


local shootingEvent = ReplicatedStorage.shootingEvent
local plr = Players.LocalPlayer
local hasBall = false
local jumping = false

if workspace:FindFirstChild("PracticeArea") then
	workspace.PracticeArea.Parent = workspace.Courts
end

local function updateNearestPlayerWithBall()
	local dist = 9e9
	local nearestPlayer = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= plr and player.Character and player.Character:FindFirstChild("Basketball") and not plr.Character:FindFirstChild("Basketball") then
			local magnitude = (plr.Character.Torso.Position - player.Character.Torso.Position).Magnitude
			if dist > magnitude then
				dist = magnitude
				nearestPlayer = player
			end
		end
	end

	return nearestPlayer
end

local function setup()
	local dist, goal = 9e9, nil

	for _, court in ipairs(workspace.Courts:GetDescendants()) do
		if court.Name == "Swish" and court:IsA("Sound") and plr.Character and plr.Character:FindFirstChild("Torso") then
			local magnitude = (plr.Character.Torso.Position - court.Parent.Position).Magnitude
			if dist > magnitude then
				dist = magnitude
				goal = court.Parent
			end
		end
	end

	return dist, goal
end

local function changePower(value)
	pcall(function()
		plr.Power.Value = value
	end)
end

local function power()
	return plr.Power
end

local function table(a, b)
	local args = {
		X1 = a.X,
		Y1 = a.Y,
		Z1 = a.Z,
		X2 = b.X,
		Y2 = b.Y,
		Z2 = b.Z
	}

	return {
		args[_G.method[1]],
		args[_G.method[2]],
		args[_G.method[3]],
		args[_G.method[4]],
		args[_G.method[5]],
		args[_G.method[6]]
	}
end

local function arc()
	local dist, goal = setup()
	dist = math.floor(dist)

	if dist >= 12 and dist <= 67 then
		return (dist % 2 == 0) and 20 or 15
	elseif dist == 68 or dist == 69 then
		return 75
	elseif dist == 70 or dist == 71 then
		return 70
	elseif dist >= 72 and dist <= 74 then
		return (dist % 2 == 0) and 65 or 60
	end
end

local function stepped()
	local player = updateNearestPlayerWithBall()
	local ground = workspace:FindPartOnRay(Ray.new(plr.Character.Torso.Position, Vector3.new(0, -100, 5)))

	if player and (player.Character.Torso.Position.Y - ground.Position.Y) > 2.5 then
		plr.Character.Humanoid.Jump = true
	end
end

local function shoot()
	local dist, goal = setup()
	local pwr = power()
	local arc = arc()

	if arc and plr.Character and plr.Character:FindFirstChild("Humanoid") then
		local args = table(plr.Character.Torso.Position, (goal.Position + Vector3.new(0, arc, 0) - plr.Character.HumanoidRootPart.Position + plr.Character.Humanoid.MoveDirection).Unit)
		shootingEvent:FireServer(plr.Character.Basketball, pwr.Value, args, _G.key)
	end
end

local function jumped()
	if _G.Aimbot and plr.Character and hasBall and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Transparency == 0 then
		jumping = true
		Task.Wait(0.325)
		shoot()
		Task.Wait(0.1)
		jumping = false
	end
end

local function added(child)
	if child.Name == "Basketball" then
		Task.Wait(0.5)
		hasBall = true
	end
end

local function removed(child)
	if child.Name == "Basketball" then
		hasBall = false
	end
end

local function began(input, isProcessed)
	if not isProcessed and input.KeyCode == Enum.KeyCode.U and _G.Autogaurd then
		if not tracking then
			tracking = true
		else
			tracking = false
		end
	end
end

_G.input = plr.Character.Humanoid.Jumping:Connect(jumped)
_G.added = plr.Character.ChildAdded:Connect(added)
_G.removed = plr.Character.ChildRemoved:Connect(removed)
_G.stepped = RunService.Stepped:Connect(stepped)
_G.began = UserInputService.InputBegan:Connect(began)

_G.charAdded = plr.CharacterAdded:Connect(function(ch)
	_G.input = ch:WaitForChild("Humanoid").Jumping:Connect(jumped)
	_G.added = ch.ChildAdded:Connect(added)
	_G.removed = ch.ChildRemoved:Connect(removed)

	for _, connection in ipairs(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Size"):GetConnections()) do
		connection:Disable()
	end

	for _, connection in ipairs(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("BrickColor"):GetConnections()) do
		connection:Disable()
	end

	for _, connection in ipairs(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Color"):GetConnections()) do
		connection:Disable()
	end

	for _, connection in ipairs(ch:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):GetConnections()) do
		connection:Disable()
	end
end)
