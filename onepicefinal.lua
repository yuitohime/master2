local player = game.Players.LocalPlayer
local guiName = "ProScannerAndTeleportMenu"

-- 1. XÓA GUI CŨ NẾU CÓ
local existingGui = game.CoreGui:FindFirstChild(guiName) or player.PlayerGui:FindFirstChild(guiName)
if existingGui then existingGui:Destroy() end

-- 2. TẠO GIAO DIỆN CHÍNH
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
local success, _ = pcall(function() screenGui.Parent = game.CoreGui end)
if not success then screenGui.Parent = player.PlayerGui end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = " Island Teleport & Mob Scanner"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = mainFrame

-- Nút Đóng (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Nút Thu Nhỏ / Mở Rộng (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 20
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = mainFrame

-- Container chứa nội dung bên trong để ẩn/hiện khi thu nhỏ
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -40)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentContainer.Visible = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 380, 0, 40)
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 380, 0, 480)
        minimizeBtn.Text = "-"
    end
end)

-- Trạng thái
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Trạng thái: Sẵn sàng."
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = contentContainer

-- Tab Chức năng 1: Khu vực Quét Quái (Scanner & Logger)
local scannerBox = Instance.new("Frame")
scannerBox.Size = UDim2.new(1, -20, 0, 75)
scannerBox.Position = UDim2.new(0, 10, 0, 35)
scannerBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scannerBox.BorderSizePixel = 0
scannerBox.Parent = contentContainer

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.32, 0, 0, 30)
scanBtn.Position = UDim2.new(0.01, 0, 0, 5)
scanBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Text = "1. Quét Monster"
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 14
scanBtn.Parent = scannerBox

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.32, 0, 0, 30)
saveBtn.Position = UDim2.new(0.34, 0, 0, 5)
saveBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Text = "2. Lưu Note"
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextSize = 14
saveBtn.Parent = scannerBox

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.32, 0, 0, 30)
copyBtn.Position = UDim2.new(0.67, 0, 0, 5)
copyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Text = "3. Copy Code"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 14
copyBtn.Parent = scannerBox

local switchModeBtn = Instance.new("TextButton")
switchModeBtn.Size = UDim2.new(0.98, 0, 0, 25)
switchModeBtn.Position = UDim2.new(0.01, 0, 0, 42)
switchModeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
switchModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
switchModeBtn.Text = "Đang hiển thị: [ Sổ Ghi Chú Quái ] - Bấm để đổi sang Menu Teleport Đảo"
switchModeBtn.Font = Enum.Font.SourceSans
switchModeBtn.TextSize = 13
switchModeBtn.Parent = scannerBox

-- Khung danh sách (Dùng chung cho cả 2 chế độ: Sổ ghi chú & Danh sách đảo Teleport)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -120)
scrollFrame.Position = UDim2.new(0, 10, 0, 115)
scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = contentContainer

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

-- ==========================================
-- LOGIC XỬ LÝ DỮ LIỆU
-- ==========================================

local globalDatabase = {} 
local tempScannedMobs = {} 
local currentMode = "Logger" -- "Logger" hoặc "Teleport"

local function getClosestIsland()
    local islandFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
    if not islandFolder then return "Unknown_Island" end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return "Unknown_Island" end

    local closestIsland = nil
    local shortestDistance = math.huge
    for _, island in ipairs(islandFolder:GetChildren()) do
        local pivot = island:GetPivot()
        local dist = (pivot.Position - hrp.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestIsland = island.Name
        end
    end
    return closestIsland or "Unknown_Island"
end

local function refreshListDisplay()
    -- Xóa các thành phần cũ trong scrollFrame
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") and child ~= listLayout then
            child:Destroy()
        end
    end

    if currentMode == "Logger" then
        -- Hiển thị Sổ ghi chú quái đã lưu
        for mobName, data in pairs(globalDatabase) do
            local note = Instance.new("TextLabel")
            note.Size = UDim2.new(1, 0, 0, 25)
            note.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            note.TextColor3 = Color3.fromRGB(255, 255, 255)
            note.Font = Enum.Font.SourceSans
            note.TextSize = 14
            note.Text = string.format(" [%s] -> %s", data.Island, mobName)
            note.TextXAlignment = Enum.TextXAlignment.Left
            note.Parent = scrollFrame
        end
    elseif currentMode == "Teleport" then
        -- Hiển thị danh sách các đảo để bấm Teleport nhanh
        local islandFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
        if islandFolder then
            for _, island in ipairs(islandFolder:GetChildren()) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 14
                btn.Text = " Teleport tới đảo: " .. island.Name
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = scrollFrame
                
                btn.MouseButton1Click:Connect(function()
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = island:GetPivot() + Vector3.new(0, 50, 0)
                        statusLabel.Text = "Đã bay đến: " .. island.Name
                    end
                end)
            end
        end
    end
end

-- Đổi qua lại giữa chế độ Sổ Ghi Chú và Menu Teleport Đảo
switchModeBtn.MouseButton1Click:Connect(function()
    if currentMode == "Logger" then
        currentMode = "Teleport"
        switchModeBtn.Text = "Đang hiển thị: [ Menu Teleport Đảo ] - Bấm để đổi về Sổ Quái"
        scannerBox.Visible = Ẩn nút quét khi ở chế độ tele cho rộng chỗ (hoặc để nguyên, ở đây ta ẩn phần scan)
        scannerBox.Size = UDim2.new(1, -20, 0, 30)
        scrollFrame.Size = UDim2.new(1, -20, 1, -75)
        scrollFrame.Position = UDim2.new(0, 10, 0, 70)
        scanBtn.Visible = false
        saveBtn.Visible = false
        copyBtn.Visible = false
    else
        currentMode = "Logger"
        switchModeBtn.Text = "Đang hiển thị: [ Sổ Ghi Chú Quái ] - Bấm để đổi sang Menu Teleport Đảo"
        scannerBox.Size = UDim2.new(1, -20, 0, 75)
        scrollFrame.Size = UDim2.new(1, -20, 1, -120)
        scrollFrame.Position = UDim2.new(0, 10, 0, 115)
        scanBtn.Visible = true
        saveBtn.Visible = true
        copyBtn.Visible = true
    end
    refreshListDisplay()
end)

-- 1. Quét Quái từ workspace.Monster
scanBtn.MouseButton1Click:Connect(function()
    tempScannedMobs = {}
    currentIslandName = getClosestIsland()
    local monsterFolder = workspace:FindFirstChild("Monster")
    
    if not monsterFolder then
        statusLabel.Text = "Lỗi: Không tìm thấy thư mục Workspace.Monster!"
        return
    end

    local count = 0
    -- Quét toàn bộ các con quái nằm trong thư mục Monster
    for _, mob in ipairs(monsterFolder:GetChildren()) do
        local mobHrp = mob:FindFirstChild("HumanoidRootPart") or (mob:IsA("Model") and mob.PrimaryPart)
        if mobHrp then
            if not tempScannedMobs[mob.Name] then
                tempScannedMobs[mob.Name] = mobHrp.CFrame
                count = count + 1
            end
        end
    end

    if count > 0 then
        statusLabel.Text = string.format("Quét thấy %d loại quái tại [%s]. Bấm 'Lưu Note'!", count, currentIslandName)
    else
        statusLabel.Text = string.format("Không thấy quái trong thư mục Monster tại [%s]!", currentIslandName)
    end
end)

-- 2. Lưu vào Note
saveBtn.MouseButton1Click:Connect(function()
    local count = 0
    for mobName, cframe in pairs(tempScannedMobs) do
        if not globalDatabase[mobName] then
            globalDatabase[mobName] = {CFrame = cframe, Island = currentIslandName}
            count = count + 1
        end
    end
    
    if count > 0 then
        statusLabel.Text = "Đã lưu thêm " .. count .. " quái vào sổ!"
        refreshListDisplay()
    else
        statusLabel.Text = "Không có quái mới để lưu!"
    end
    tempScannedMobs = {} 
end)

-- 3. Copy Code
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        local codeString = "local MobSpawnLocations = {\n"
        for mobName, data in pairs(globalDatabase) do
            local cf = data.CFrame
            local cfString = string.format("CFrame.new(%f, %f, %f)", cf.X, cf.Y, cf.Z)
            codeString = codeString .. string.format('    ["%s"] = %s, -- Đảo: %s\n', mobName, cfString, data.Island)
        end
        codeString = codeString .. "}\n"
        setclipboard(codeString)
        statusLabel.Text = "Đã copy Code chuẩn Lua vào Clipboard!"
    else
        statusLabel.Text = "Executor không hỗ trợ setclipboard!"
    end
end)
