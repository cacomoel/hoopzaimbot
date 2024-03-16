local hasBall = false
local jumping = false
local player
local ground

local function updateNearestPlayerWithBall()
    local dist = 9e9
    for i, v in pairs(game.Players:GetPlayers()) do
        if
            v.Name ~= plr.Name and v.Character and v.Character:FindFirstChild("Basketball") and
            not plr.Character:FindFirstChild("Basketball") and
            (plr.Character.Torso.Position - v.Character.Torso.Position).Magnitude < 50
        then
            local mag = (plr.Character.Torso.Position - v.Character.Torso.Position).Magnitude
            if dist > mag then
                dist = mag
                player = v
            end
        end
    end
end

local function setup()
    local dist, goal = 9e9, nil
    for i, v in pairs(workspace.Courts:GetDescendants()) do
        if v.Name == "Swish" and v:IsA("Sound") and plr.Character and plr.Character:FindFirstChild("Torso") then
            local mag = (plr.Character.Torso.Position - v.Parent.Position).Magnitude
            if dist > mag then
                dist = mag
                goal = v.Parent
            end
        end
    end
    return dist, goal
end

local function power(dist)
    if dist == 12 or dist == 13 then
        return 15
    elseif dist == 14 or dist == 15 then
        return 20
    elseif dist == 16 or dist == 17 then
        return 15
    elseif dist == 18 then
        return 25
    elseif dist == 19 then
        return 20
    elseif dist == 20 or dist == 21 then
        return 20
    elseif dist == 22 or dist == 23 then
        return 25
    elseif dist == 24 or dist == 25 then
        return 20
    elseif dist == 26 then
        return 15
    elseif dist == 27 or dist == 28 then
        return 25
    elseif dist == 29 or dist == 30 then
        return 20
    elseif dist == 31 then
        return 15
    elseif dist == 32 or dist == 33 then
        return 30
    elseif dist == 34 or dist == 35 or dist == 36 then
        return 25
    elseif dist == 37 or dist == 38 then
        return 35
    elseif dist == 39 or dist == 40 then
        return 30
    elseif dist == 41 then
        return 25
    elseif dist == 42 or dist == 43 then
        return 40
    elseif dist == 44 then
        return 35
    elseif dist == 45 or dist == 46 then
        return 30
    elseif dist == 47 or dist == 48 then
        return 45
    elseif dist == 49 then
        return 40
    elseif dist == 50 then
        return 35
    elseif dist == 51 then
        return 50
    elseif dist == 52 then
        return 55
    elseif dist == 53 or dist == 54 then
        return 50
    elseif dist == 55 then
        return 45
    elseif dist == 56 then
        return 40
    elseif dist == 57 or dist == 58 then
        return 55
    elseif dist == 59 or dist == 60 or dist == 61 then
        return 50
    elseif dist == 62 or dist == 63 then
        return 65
    elseif dist == 64 then
        return 55
    elseif dist == 65 then
        return 60
    elseif dist == 66 or dist == 67 then
        return 50
    elseif dist == 68 or dist == 69 then
        return 75
    elseif dist == 70 or dist == 71 then
        return 70
    elseif dist == 72 then
        return 65
    elseif dist == 73 then
        return 60
    elseif dist == 74 then
        return 50
    elseif jumping then
        if dist == 9 or dist == 10 then
            return 20
        elseif dist == 11 or dist == 12 then
            return 15
        end
    end
end

local function updatePower()
    local dist, _ = setup()
    local pwr = power(dist)
    plr.Power.Value = pwr
end

local function stepped()
    pcall(
        function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and _G.Aimbot then
                local dist, goal = setup()
                local root = plr.Character.HumanoidRootPart

                dist = math.floor(dist)

                if root and hasBall then
                    root.Size = Vector3.new(2.1, 2.1, 1.1)
                    root.BrickColor = BrickColor.new("Lime green")
                    root.Material = Enum.Material.Neon

                    if dist >= 13 and dist <= 74 then
                        root.Transparency = 0
                    else
                        root.Transparency = 1
                    end
                elseif root and not hasBall and _G.Aimbot then
                    root.Transparency = 1
                elseif root and not _G.Aimbot then
                    root.Transparency = 1
                end
            end

            updateNearestPlayerWithBall()

            if _G.WS ~= 16 and plr.Character:WaitForChild("Humanoid").WalkSpeed ~= 0 then
                plr.Character:WaitForChild("Humanoid").WalkSpeed = _G.WS
            end
        end
    )
end

local function jumped()
    if _G.Aimbot and plr.Character and hasBall and plr.Character:FindFirstChild("HumanoidRootPart") then
        jumping = true
        task.wait(0.1)
        updatePower() -- Update power when the player jumps
        task.wait(0.225)
        shoot()
        task.wait(0.1)
        jumping = false
    end
end

local function began(key, gpe)
    if not gpe and key.KeyCode == Enum.KeyCode.U and _G.Autogaurd then
        updateNearestPlayerWithBall()
        if not tracking then
            tracking = true
        else
            tracking = false
        end
    end
end

_G.input = plr.Character.Humanoid.Jumping:Connect(jumped)
_G.stepped = rs.Stepped:Connect(stepped)
_G.began = uis.InputBegan:Connect(began)
