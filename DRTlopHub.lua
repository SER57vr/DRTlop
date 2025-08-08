-- Miranda-style DRTlop Hub (Steal a Brainrot) - рабочий скрипт
-- Вставь в Delta Executor и Execute
-- Кнопка показа/скрытия UI: RightControl

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then return end

-- ---------- UI ----------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MirandaHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui -- Delta обычно разрешает CoreGui

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0.35, 0, 0.18, 0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Miranda Hub (DRTlop)"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local function makeButton(text, y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, 44 + (y-1)*44)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.AutoButtonColor = true
    btn.TextScaled = false
    return btn
end

-- status labels
local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -10, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 44 + 7*44)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Text = "Статус: готов"
statusLabel.TextScaled = true

-- ---------- State ----------
local espEnabled = false
local speedEnabled = false
local godEnabled = false
local flyToBaseEnabled = false
local autoBuyEnabled = false
local infJumpEnabled = false

local savedBaseCFrame = nil -- если игрок сам задаст базу
local origWalkSpeed = nil

-- container for created ESP GUIs so we can remove them if needed
local createdBillboards = {}
local createdHighlights = {}

-- ---------- UTIL ----------
local function safeFindHumanoid(character)
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

local function makeBillboard(parentPart, text, color)
    if not parentPart or not parentPart:IsA("BasePart") then return end
    local key = tostring(parentPart)
    if createdBillboards[key] then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = "DRT_Billboard"
    bg.Adornee = parentPart
    bg.Size = UDim2.new(0, 160, 0, 40)
    bg.StudsOffset = Vector3.new(0, 2.5, 0)
    bg.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextScaled = true
    lbl.TextColor3 = color or Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold
    bg.Parent = parentPart
    createdBillboards[key] = bg
end

local function clearAllESP()
    for k,v in pairs(createdBillboards) do
        if v and v.Parent then
            v:Destroy()
        end
        createdBillboards[k] = nil
    end
    for k,v in pairs(createdHighlights) do
        if v and v.Parent then
            v:Destroy()
        end
        createdHighlights[k] = nil
    end
end

-- ---------- ESP ----------
local function updateESPPlayers()
    clearAllESP()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("Head") then
            -- highlight (if available)
            local ok, highlight = pcall(function()
                local h = Instance.new("Highlight", pl.Character)
                h.Name = "DRT_Highlight"
                h.Adornee = pl.Character
                h.FillTransparency = 0.6
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineTransparency = 0.6
                h.OutlineColor = Color3.new(1,1,1)
                return h
            end)
            if ok and highlight then
                createdHighlights[tostring(pl.Character)] = highlight
            end
            -- name billboard
            makeBillboard(pl.Character:FindFirstChild("Head"), pl.Name, Color3.fromRGB(255,200,0))
        end
    end
end

local function updateESPWorld()
    -- find parts that look like bases/secrets
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("base") or n:find("open") or n:find("buy") or n:find("secret") or n:find("brainrot") then
                local color = Color3.fromRGB(0,255,0)
                if n:find("base") or n:find("open") then color = Color3.fromRGB(0,170,255) end
                makeBillboard(obj, obj.Name, color)
            end
        end
    end
end

-- toggle esp
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        statusLabel.Text = "Статус: ESP включён"
        updateESPPlayers()
        updateESPWorld()
        -- also refresh periodically to catch new objects/players
        spawn(function()
            while espEnabled do
                updateESPPlayers()
                updateESPWorld()
                wait(2)
            end
        end)
    else
        statusLabel.Text = "Статус: ESP выключен"
        clearAllESP()
    end
end

-- ---------- SpeedHack ----------
local speedConn = nil
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local hum = safeFindHumanoid(char)
    if not hum then return end
    if speedEnabled then
        origWalkSpeed = hum.WalkSpeed or 16
        hum.WalkSpeed = math.max(origWalkSpeed * 4, 60) -- x4 but at least 60
        statusLabel.Text = "Статус: Speed ON"
    else
        if origWalkSpeed then hum.WalkSpeed = origWalkSpeed else hum.WalkSpeed = 16 end
        statusLabel.Text = "Статус: Speed OFF"
    end
end

-- ---------- GodMode ----------
local godConns = {}
local function setGodMode(on)
    godEnabled = on
    local char = LocalPlayer.Character
    if not char then return end
    local hum = safeFindHumanoid(char)
    if not hum then return end
    if godEnabled then
        statusLabel.Text = "Статус: GodMode ON"
        -- connect to changes and restore health
        local conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
        end)
        table.insert(godConns, conn)
    else
        statusLabel.Text = "Статус: GodMode OFF"
        for _,c in ipairs(godConns) do
            pcall(function() c:Disconnect() end)
        end
        godConns = {}
    end
end

-- ---------- Infinite Jump ----------
local function enableInfiniteJump()
    if infJumpEnabled then return end
    infJumpEnabled = true
    statusLabel.Text = "Статус: Infinite Jump ON"
    UIS.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local char = LocalPlayer.Character
        if char then
            local hum = safeFindHumanoid(char)
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function disableInfiniteJump()
    infJumpEnabled = false
    statusLabel.Text = "Статус: Infinite Jump OFF"
end

-- ---------- Fly to Base ----------
-- allow user to set base to their current position or to nearest base object
local function setBaseToCurrentPos()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedBaseCFrame = hrp.CFrame
        statusLabel.Text = "Статус: база сохранена (текущая позиция)"
    else
        statusLabel.Text = "Статус: не удалось сохранить базу"
    end
end

local function setBaseToNearestBaseObject()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local best,bdist = nil,math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("base") or n:find("home") or n:find("open") then
                local d = (obj.Position - hrp.Position).Magnitude
                if d < bdist then
                    bdist = d
                    best = obj
                end
            end
        end
    end
    if best then
        savedBaseCFrame = best.CFrame + Vector3.new(0, 5, 0)
        statusLabel.Text = "Статус: база сохранена (найдена в мире)"
    else
        statusLabel.Text = "Статус: база не найдена"
    end
end

local flyActiveConn = nil
local function flyToSavedBase()
    if not savedBaseCFrame then
        statusLabel.Text = "Статус: база не задана. Нажми Set Base"
        return
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = safeFindHumanoid(LocalPlayer.Character)
    if not hrp or not hum then
        statusLabel.Text = "Статус: персонаж не готов"
        return
    end
    -- create bodyvelocity and move until near
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6,1e6,1e6)
    bv.Parent = hrp
    local reached = false
    statusLabel.Text = "Статус: летим к базе..."
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not hrp or not savedBaseCFrame then
            conn:Disconnect()
            if bv and bv.Parent then bv:Destroy() end
            return
        end
        local dir = (savedBaseCFrame.Position - hrp.Position)
        local dist = dir.Magnitude
        if dist < 4 then
            reached = true
            conn:Disconnect()
            if bv and bv.Parent then bv:Destroy() end
            statusLabel.Text = "Статус: достигнута база"
            return
        end
        if dir.Magnitude > 0 then
            bv.Velocity = dir.Unit * math.clamp(120, 30, 200)
        end
    end)
end

-- ---------- AutoBuy Secrets ----------
local function doAutoBuySecrets()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("buy") or n:find("buyzone") or n:find("secretshop") then
                local dist = (obj.Position - hrp.Position).Magnitude
                if dist < 10 then
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        task.wait(0.08)
                        firetouchinterest(hrp, obj, 1)
                    end)
                end
            end
        end
    end
end

local autoBuyLoop = nil
local function toggleAutoBuy()
    autoBuyEnabled = not autoBuyEnabled
    if autoBuyEnabled then
        statusLabel.Text = "Статус: AutoBuy ON"
        autoBuyLoop = RunService.Heartbeat:Connect(function()
            doAutoBuySecrets()
        end)
    else
        statusLabel.Text = "Статус: AutoBuy OFF"
        if autoBuyLoop then
            pcall(function() autoBuyLoop:Disconnect() end)
            autoBuyLoop = nil
        end
    end
end

-- ---------- Buttons ----------
local row = 1
local bESP = makeButton("ESP Игроков / Секреты / Базы", row); row = row + 1
bESP.MouseButton1Click:Connect(toggleESP)

local bSpeed = makeButton("Speed x4", row); row = row + 1
bSpeed.MouseButton1Click:Connect(toggleSpeed)

local bGod = makeButton("GodMode (toggle)", row); row = row + 1
bGod.MouseButton1Click:Connect(function() setGodMode(not godEnabled) end)

local bInfJump = makeButton("Infinite Jump (toggle)", row); row = row + 1
bInfJump.MouseButton1Click:Connect(function()
    if not infJumpEnabled then enableInfiniteJump() else disableInfiniteJump() end
end)

local bSetBaseCurrent = makeButton("Set Base = Current Pos", row); row = row + 1
bSetBaseCurrent.MouseButton1Click:Connect(setBaseToCurrentPos)

local bSetBaseNearest = makeButton("Set Base = Nearest Base", row); row = row + 1
bSetBaseNearest.MouseButton1Click:Connect(setBaseToNearestBaseObject)

local bFlyToBase = makeButton("Fly to Saved Base", row); row = row + 1
bFlyToBase.MouseButton1Click:Connect(flyToSavedBase)

local bAutoBuy = makeButton("Auto Buy Secrets (toggle)", row); row = row + 1
bAutoBuy.MouseButton1Click:Connect(toggleAutoBuy)

local bClearESP = makeButton("Clear ESP", row); row = row + 1
bClearESP.MouseButton1Click:Connect(function() clearAllESP() statusLabel.Text = "Статус: ESP очищено" end)

local bHide = makeButton("Скрыть/Показать Меню (RightCtrl)", row); row = row + 1
bHide.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- ---------- GUI Toggle via RightControl ----------
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

-- ---------- Ensure Character available ----------
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if espEnabled then updateESPPlayers() end
end)

-- initial
statusLabel.Text = "Статус: готов. Нажми кнопки."

-- End of script
