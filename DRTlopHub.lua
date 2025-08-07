-- DRTlop Hub v1.0

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 20, 0.5, -150)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Name = "DRTlopHub"

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

-- ESP
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

-- Aimbot (на ПКМ)
function EnableAimbot()
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    local function GetClosestPlayer()
        local closest, distance = nil, math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos = Camera:WorldToScreenPoint(player.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < distance then
                    closest = player
                    distance = mag
                end
            end
        end
        return closest
    end

    RunService.RenderStepped:Connect(function()
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end)
end

-- Auto Collect
function AutoCollect()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("TouchTransmitter") and item.Parent then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 1)
        end
    end
end

-- SpeedHack
function SpeedHack()
    local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human.WalkSpeed = 100
    end
end

-- Fly
function Fly()
    local p = game.Players.LocalPlayer
    local mouse = p:GetMouse()
    local char = p.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local flying = true

    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bv.Velocity = Vector3.new(0, 0, 0)

    local RunService = game:GetService("RunService")
    RunService.RenderStepped:Connect(function()
        if flying then
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            bv.Velocity = move * 60
        end
    end)
end

-- Teleport to nearest player
function TeleportToPlayer()
    local lp = game.Players.LocalPlayer
    local closest, dist = nil, math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (lp.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                closest = player
                dist = mag
            end
        end
    end
    if closest then
        lp.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Kill Aura
function KillAura()
    local lp = game.Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") then
                local enemy = player.Character
                if (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude < 10 then
                    enemy.Humanoid:TakeDamage(5)
                end
            end
        end
    end)
end

-- Buttons
CreateButton("ESP", 10, EnableESP)
CreateButton("Aimbot", 50, EnableAimbot)
CreateButton("Auto Collect", 90, AutoCollect)
CreateButton("SpeedHack", 130, SpeedHack)
CreateButton("Fly", 170, Fly)
CreateButton("TP", 210, TeleportToPlayer)
CreateButton("Kill Aura", 250, KillAura)-- DRTlop Hub v1.0

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 20, 0.5, -150)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Name = "DRTlopHub"

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

-- ESP
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

-- Aimbot (на ПКМ)
function EnableAimbot()
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    local function GetClosestPlayer()
        local closest, distance = nil, math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos = Camera:WorldToScreenPoint(player.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < distance then
                    closest = player
                    distance = mag
                end
            end
        end
        return closest
    end

    RunService.RenderStepped:Connect(function()
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end)
end

-- Auto Collect
function AutoCollect()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("TouchTransmitter") and item.Parent then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 1)
        end
    end
end

-- SpeedHack
function SpeedHack()
    local human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human.WalkSpeed = 100
    end
end

-- Fly
function Fly()
    local p = game.Players.LocalPlayer
    local mouse = p:GetMouse()
    local char = p.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local flying = true

    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bv.Velocity = Vector3.new(0, 0, 0)

    local RunService = game:GetService("RunService")
    RunService.RenderStepped:Connect(function()
        if flying then
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            bv.Velocity = move * 60
        end
    end)
end

-- Teleport to nearest player
function TeleportToPlayer()
    local lp = game.Players.LocalPlayer
    local closest, dist = nil, math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (lp.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                closest = player
                dist = mag
            end
        end
    end
    if closest then
        lp.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Kill Aura
function KillAura()
    local lp = game.Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") then
                local enemy = player.Character
                if (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude < 10 then
                    enemy.Humanoid:TakeDamage(5)
                end
            end
        end
    end)
end

-- Buttons
CreateButton("ESP", 10, EnableESP)
CreateButton("Aimbot", 50, EnableAimbot)
CreateButton("Auto Collect", 90, AutoCollect)
CreateButton("SpeedHack", 130, SpeedHack)
CreateButton("Fly", 170, Fly)
CreateButton("TP", 210, TeleportToPlayer)
CreateButton("Kill Aura", 250, KillAura)            CreateESP(player)
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
