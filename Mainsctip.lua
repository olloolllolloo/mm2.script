if not pcall(function() return game:GetService("Players") end) then return end
-- // MM ESP - Murder Mystery ESP Hack with Auto Aim
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- // Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM_ESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- // Minimized Button (квадратик с буквой М)
local minimizedButton = Instance.new("TextButton")
minimizedButton.Name = "MinimizedButton"
minimizedButton.Size = UDim2.new(0, 50, 0, 50)
minimizedButton.Position = UDim2.new(0.5, -25, 0.5, -25)
minimizedButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizedButton.BorderSizePixel = 0
minimizedButton.Text = "M"
minimizedButton.TextSize = 24
minimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedButton.Font = Enum.Font.GothamBold
minimizedButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = minimizedButton

-- // Main Frame (развернутое окно)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 170)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -85)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = mainFrame

-- // Сделать окно перетаскиваемым пальцем
mainFrame.Active = true
mainFrame.Draggable = true

-- // Свернуть кнопка (сверху)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeButton

-- // Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 150, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MM ESP Control"
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.Gotham
titleLabel.Parent = mainFrame

-- // MM ESP Button
local mmEspButton = Instance.new("TextButton")
mmEspButton.Name = "MMEspButton"
mmEspButton.Size = UDim2.new(1, -20, 0, 40)
mmEspButton.Position = UDim2.new(0, 10, 0, 45)
mmEspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mmEspButton.BorderSizePixel = 0
mmEspButton.Text = "MM ESP: OFF"
mmEspButton.TextSize = 14
mmEspButton.TextColor3 = Color3.fromRGB(255, 100, 100)
mmEspButton.Font = Enum.Font.Gotham
mmEspButton.Parent = mainFrame

local espButtonCorner = Instance.new("UICorner")
espButtonCorner.CornerRadius = UDim.new(0, 10)
espButtonCorner.Parent = mmEspButton

-- // Auto Aim Button
local autoAimButton = Instance.new("TextButton")
autoAimButton.Name = "AutoAimButton"
autoAimButton.Size = UDim2.new(1, -20, 0, 40)
autoAimButton.Position = UDim2.new(0, 10, 0, 95)
autoAimButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
autoAimButton.BorderSizePixel = 0
autoAimButton.Text = "Auto Aim: OFF"
autoAimButton.TextSize = 14
autoAimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
autoAimButton.Font = Enum.Font.Gotham
autoAimButton.Parent = mainFrame

local aimButtonCorner = Instance.new("UICorner")
aimButtonCorner.CornerRadius = UDim.new(0, 10)
aimButtonCorner.Parent = autoAimButton

-- // Статус текст
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 140)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Red=Knife | Blue=Gun | Green=No Weapon"
statusLabel.TextSize = 10
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- // Переменные
local mmEspEnabled = false
local autoAimEnabled = false
local mmEspHighlights = {}
local autoAimConnection = nil

-- // Weapon detection functions
local function isKnife(name)
    name = string.lower(name)
    return string.find(name, "knife") or 
           string.find(name, "machete") or 
           string.find(name, "dagger") or
           string.find(name, "blade") or
           string.find(name, "sword") or
           string.find(name, "нож")
end

local function isGun(name)
    name = string.lower(name)
    return string.find(name, "gun") or 
           string.find(name, "pistol") or 
           string.find(name, "revolver") or 
           string.find(name, "rifle") or 
           string.find(name, "smg") or 
           string.find(name, "shotgun") or 
           string.find(name, "weapon") or
           string.find(name, "пистолет")
end

-- // Function to determine player role
local function getPlayerRole(plr)
    if not plr.Character then
        return "unknown"
    end
    
    local hasKnife = false
    local hasGun = false
    
    -- Check backpack FIRST (items about to be equipped)
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name
                if isKnife(name) then hasKnife = true end
                if isGun(name) then hasGun = true end
            end
        end
    end
    
    -- Check character (equipped items)
    for _, item in pairs(plr.Character:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name
            if isKnife(name) then hasKnife = true end
            if isGun(name) then hasGun = true end
        end
    end
    
    if hasKnife then
        return "murderer"
    elseif hasGun then
        return "sheriff"
    else
        return "innocent"
    end
end

-- // Function to find closest target
local function findClosestTarget(role)
    if not camera then return nil end
    
    local closestTarget = nil
    local closestDistance = math.huge
    local myPos = camera.CFrame.Position
    
    if role == "murderer" then
        -- First priority: find sheriff
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local targetRole = getPlayerRole(plr)
                if targetRole == "sheriff" then
                    local distance = (myPos - plr.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = plr
                    end
                end
            end
        end
        
        -- Second priority: find innocent if no sheriff found
        if not closestTarget then
            closestDistance = math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                    local targetRole = getPlayerRole(plr)
                    if targetRole == "innocent" then
                        local distance = (myPos - plr.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = plr
                        end
                    end
                end
            end
        end
    elseif role == "sheriff" then
        -- Sheriff targets murderer
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local targetRole = getPlayerRole(plr)
                if targetRole == "murderer" then
                    local distance = (myPos - plr.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = plr
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- // Auto aim function - INSTANT LOCK
local function startAutoAim()
    if autoAimConnection then
        autoAimConnection:Disconnect()
        autoAimConnection = nil
    end
    
    autoAimConnection = RunService.RenderStepped:Connect(function()
        if not autoAimEnabled then
            if autoAimConnection then
                autoAimConnection:Disconnect()
                autoAimConnection = nil
            end
            return
        end
        
        if not camera then
            camera = Workspace.CurrentCamera
            return
        end
        
        local myRole = getPlayerRole(player)
        
        -- Only aim if not innocent
        if myRole == "innocent" then
            return
        end
        
        local target = findClosestTarget(myRole)
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
            local targetPos = target.Character.HumanoidRootPart.Position
            local cameraPos = camera.CFrame.Position
            
            -- INSTANT lock - camera directly looks at target without interpolation
            camera.CFrame = CFrame.lookAt(cameraPos, targetPos)
        end
    end)
end

-- // Функция для перетаскивания мини-кнопки
local dragging = false
local dragStart = nil
local startPos = nil

minimizedButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = minimizedButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

minimizedButton.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        minimizedButton.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- // Развернуть/Свернуть
minimizedButton.MouseButton1Click:Connect(function()
    if not dragging then
        minimizedButton.Visible = false
        mainFrame.Visible = true
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedButton.Visible = true
end)

-- // MM ESP function
local function toggleMMESP()
    if mmEspEnabled then
        -- Выключить ESP
        mmEspEnabled = false
        for _, h in pairs(mmEspHighlights) do 
            if h and h.Parent then 
                h:Destroy() 
            end 
        end
        mmEspHighlights = {}
        mmEspButton.Text = "MM ESP: OFF"
        mmEspButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        -- Включить ESP
        mmEspEnabled = true
        mmEspButton.Text = "MM ESP: ON"
        mmEspButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        spawn(function()
            while mmEspEnabled do
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr == player or not plr.Character then 
                        continue 
                    end
                    
                    local role = getPlayerRole(plr)
                    
                    -- Создать или получить Highlight
                    local highlight = plr.Character:FindFirstChild("MMEspHighlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "MMEspHighlight"
                        highlight.FillTransparency = 0.2
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = plr.Character
                        table.insert(mmEspHighlights, highlight)
                    end
                    
                    -- Установка цвета
                    if role == "murderer" then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный = Убийца
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "sheriff" then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Синий = Шериф
                        highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Зеленый = Невинный
                        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    end
                end
                wait(0.1)
            end
        end)
    end
end

-- // Auto Aim toggle function
local function toggleAutoAim()
    autoAimEnabled = not autoAimEnabled
    
    if autoAimEnabled then
        autoAimButton.Text = "Auto Aim: ON"
        autoAimButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        -- Ensure camera reference is fresh
        camera = Workspace.CurrentCamera
        startAutoAim()
    else
        autoAimButton.Text = "Auto Aim: OFF"
        autoAimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        if autoAimConnection then
            autoAimConnection:Disconnect()
            autoAimConnection = nil
        end
    end
end

-- // Подключение кнопок
mmEspButton.MouseButton1Click:Connect(toggleMMESP)
autoAimButton.MouseButton1Click:Connect(toggleAutoAim)

-- // Очистка при уходе игрока
Players.PlayerRemoving:Connect(function(plr)
    local highlight = plr.Character and plr.Character:FindFirstChild("MMEspHighlight")
    if highlight then
        highlight:Destroy()
        for i, h in pairs(mmEspHighlights) do
            if h == highlight then
                table.remove(mmEspHighlights, i)
                break
            end
        end
    end
end)

-- // Clean up on player respawn
player.CharacterAdded:Connect(function()
    if autoAimEnabled then
        wait(0.5) -- Small delay for character to load
        camera = Workspace.CurrentCamera
        startAutoAim()
    end
end)

print("MM ESP Hack with Instant Auto Aim Loaded!")
print("Tap 'M' to open control panel")
print("Red = Murderer | Blue = Sheriff | Green = Innocent")
print("Auto Aim: INSTANT LOCK - Murderer -> Sheriff (or Innocent), Sheriff -> Murderer")
