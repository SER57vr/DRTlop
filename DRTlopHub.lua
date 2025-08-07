-- DRTlop Hub: безопасный и рабочий скрипт для Delta Executor
-- Работает в игре "Steal a Brainrot"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DRTlopHub"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0, 20, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.Active = true
MainFrame.Draggable = true

local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + #MainFrame:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

-- ESP Игроков
local function enablePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(2, 3, 1)
            box.Adornee = player.Character
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
            box.Parent = player.Character
        end
    end
end

-- SpeedHack
local speedEnabled = false
local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end)
    else
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end

-- Бессмертие
local function enableGodMode()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            humanoid.Health = humanoid.MaxHealth
        end)
    end
end

-- Кнопки
CreateButton("ESP Игроков", enablePlayerESP)
CreateButton("SpeedHack", toggleSpeed)
CreateButton("Бессмертие", enableGodMode)

-- Открытие/закрытие хаба по клавише G
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("DRTlop Hub загружен!")
