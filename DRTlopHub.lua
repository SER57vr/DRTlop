local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 20, 0.5, -150)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Name = "DRTlopHub"

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextScaled = true

CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Клавиша K открывает/закрывает меню
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        Frame.Visible = not Frame.Visible
    end
end)

local function CreateButton(text, yPos, callback)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, yPos)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.MouseButton1Click:Connect(callback)
end

-- ESP Function
function CreateESP(player)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "DRTlopESP"
    BillboardGui.Adornee = player.Character:WaitForChild("Head")
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = BillboardGui
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.TextScaled = true

    BillboardGui.Parent = player.Character
end

function EnableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not player.Character:FindFirstChild("DRTlopESP") then
            CreateESP(player)
        end
    end

    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            CreateESP(player)
        end)
    end)
end

-- Buttons
CreateButton("ESP", 10, function()
    EnableESP()
end)

CreateButton("Aimbot", 50, function()
    print("Aimbot активирован (пока пусто)")
end)

CreateButton("Auto Collect", 90, function()
    print("Автосбор активирован (пока пусто)")
end)

CreateButton("SpeedHack", 130, function()
    print("Спидхак активирован (пока пусто)")
end)

CreateButton("Fly", 170, function()
    print("Полёт активирован (пока пусто)")
end)

CreateButton("TP", 210, function()
    print("Телепорт активирован (пока пусто)")
end)

CreateButton("Kill Aura", 250, function()
    print("Kill Aura активирован (пока пусто)")
end)    print("Спидхак активирован (пока пусто)")
end)

CreateButton("Fly", 170, function()
    print("Полёт активирован (пока пусто)")
end)

CreateButton("TP", 210, function()
    print("Телепорт активирован (пока пусто)")
end)

CreateButton("Kill Aura", 250, function()
    print("Kill Aura активирован (пока пусто)")
end)
