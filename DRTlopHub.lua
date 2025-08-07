-- DRTlop Hub для Steal a Brainrot
-- Поддерживает ESP, авто-сбор, авто-полет к базе и другие функции

local DRTlopHub = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- Переменные состояния функций
local isESPEnabled = false
local isGodMode = false
local isFlyToBase = false
local isSpeedHack = false
local isAutoBuySecrets = false

-- UI
DRTlopHub.Name = "DRTlopHub"
DRTlopHub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = DRTlopHub
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.Visible = true

UICorner.Parent = Frame

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.Size = UDim2.new(0.9, 0, 0.1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "DRTlop Hub (Steal a Brainrot)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextWrapped = true

-- Функция для создания кнопок
function createButton(name, posY, callback)
	local button = Instance.new("TextButton")
	button.Parent = Frame
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Position = UDim2.new(0.1, 0, posY, 0)
	button.Size = UDim2.new(0.8, 0, 0.1, 0)
	button.Font = Enum.Font.GothamBold
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.MouseButton1Click:Connect(callback)
end

-- КНОПКИ

createButton("ESP (игроки + секретки + базы)", 0.15, function()
	isESPEnabled = not isESPEnabled
	if isESPEnabled then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yourrepo/esp.lua"))()
	end
end)

createButton("Годмод", 0.27, function()
	isGodMode = not isGodMode
	if isGodMode then
		local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				humanoid.Health = humanoid.MaxHealth
			end)
		end
	end
end)

createButton("Авто-Полет к базе", 0.39, function()
	isFlyToBase = not isFlyToBase
	if isFlyToBase then
		local base = workspace:FindFirstChild("YourBase")
		if base then
			game.Players.LocalPlayer.Character:MoveTo(base.Position + Vector3.new(0, 10, 0))
		end
	end
end)

createButton("Скорость x5", 0.51, function()
	isSpeedHack = not isSpeedHack
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = isSpeedHack and 80 or 16
	end
end)

createButton("Авто-Покупка секретов", 0.63, function()
	isAutoBuySecrets = not isAutoBuySecrets
	if isAutoBuySecrets then
		for _, v in pairs(workspace:GetDescendants()) do
			if v.Name == "BuyZone" and v:IsA("Part") then
				local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					firetouchinterest(hrp, v, 0)
					task.wait(0.1)
					firetouchinterest(hrp, v, 1)
				end
			end
		end
	end
end)

-- Кнопка открыть/закрыть интерфейс
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = DRTlopHub
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Position = UDim2.new(0, 0, 0.9, 0)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Открыть/Закрыть"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true

ToggleButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)
