_G.ReachPlayer = true
--- Huamnoid RootPart or Torso ---
function getNearestPart(HumanoidRootPart)
	local dist, part = math.huge
	for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Part") and HumanoidRootPart then
			local mag = (v.Position - HumanoidRootPart.Position).Magnitude
			if dist > mag then
				dist = mag
				part = v
			end
		end
	end
	return part
end

function findClosestPlayerWithBall()
	local closestPlayer, closestDistance = nil, math.huge
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Name ~= game.Players.LocalPlayer.Name and player.Character:FindFirstChildOfClass("Tool") then
			local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = player
			end
		end
	end
	return closestPlayer
end

spawn(function()
	local RunService = game:GetService("RunService")
	RunService.RenderStepped:Connect(function()
		if _G.ReachPlayer then
			local localPlayer = game.Players.LocalPlayer
			local localCharacter = localPlayer.Character

			if not localCharacter:FindFirstChildOfClass("Tool") then
				local closestPlayer = findClosestPlayerWithBall()

				if closestPlayer and (localCharacter.HumanoidRootPart.Position - closestPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
					local nearestPart = getNearestPart(closestPlayer.Character.Torso)
					local ball = closestPlayer.Character.Basketball.Ball

					firetouchinterest(nearestPart, ball, 0)
					firetouchinterest(nearestPart, ball, 1)
				end
			end
		end
	end)
end)

_G.magRange = 25
_G.mag = true


function getClosestBasketball()
	local closestBasketball, closestDistance = nil, math.huge
	for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
		if obj.Name == "Ball" then
			local distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestBasketball = obj.Ball
			end
		end
	end
	return closestBasketball
end

spawn(function()
	while _G.mag do
		wait()

		local localPlayer = game.Players.LocalPlayer
		local localCharacter = localPlayer.Character
		local closestBasketball = getClosestBasketball()

		if closestBasketball and (localCharacter.HumanoidRootPart.Position - closestBasketball.Position).Magnitude <= _G.magRange then
			wait()
			firetouchinterest(localCharacter.HumanoidRootPart, closestBasketball, 0)
			wait(0.001)
			firetouchinterest(localCharacter.HumanoidRootPart, closestBasketball, 1)

			if not _G.mag then
				return
			end
		end
	end
end)
