-- DRTlopHud — Steal a Brainrot
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

-- UI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "MirandaHub"
local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local offsetY = 0
local function addButton(name, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, offsetY)
    btn.Text = name
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    offsetY = offsetY + 35
end

-- ESP игроков
addButton("ESP Игроков", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = Instance.new("Highlight", p.Character)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Name = "MirandaESP"
        end
    end
end)

-- SpeedHack
local speedOn = false
addButton("Speed x5", function()
    speedOn = not speedOn
    if speedOn and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    elseif LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- GodMode (неуязвимость)
local godModeOn = false
addButton("GodMode", function()
    godModeOn = not godModeOn
    if godModeOn then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.HealthChanged:Connect(function()
                h.Health = h.MaxHealth
            end)
        end
    end
end)

-- Автополет к базе
addButton("Fly to Base", function()
    local base = workspace:FindFirstChild("YourBase") -- поменяй на реальное имя
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if base and hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        RunService.Heartbeat:Connect(function()
            if hrp and base then
                bv.Velocity = (base.Position - hrp.Position).Unit * 100
            end
        end)
    end
end)

-- GUI Toggle (G)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        Frame.Visible = not Frame.Visible
    end
end)
