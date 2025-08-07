-- DRTlop Hub v1.1 [Steal a Brainrot]
-- Работает в Delta Executor

-- UI Toggle на клавишу G
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Создание GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "DRTlopHub"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 260)
mainFrame.Position = UDim2.new(0, 20, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.Visible = true

-- Открытие/Закрытие меню
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

local function createButton(name, callback)
    local button = Instance.new("TextButton", mainFrame)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, #mainFrame:GetChildren() * 35)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.MouseButton1Click:Connect(callback)
end

-- ESP Игроков
createButton("ESP Игроков", function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight", plr.Character)
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- SpeedHack
local speedOn = false
createButton("SpeedHack", function()
    speedOn = not speedOn
    if speedOn then
        player.Character.Humanoid.WalkSpeed = 50
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Бессмертие
local godmode = false
createButton("Бессмертие", function()
    godmode = not godmode
    if godmode then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.Health = hum.MaxHealth
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end
end)
