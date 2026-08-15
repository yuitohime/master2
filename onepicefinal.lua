-- ==========================================
-- DELTA UI V10 - SEA EVENT TEST MENU (PRO FIX)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("SeaEvent_TestUI") then SafeParent["SeaEvent_TestUI"]:Destroy() end

-- --- BIẾN TOÀN CỤC ---
local _G_Sea = {
    AutoSea = false,
    AutoClick = true,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false,
    Zone4 = Vector3.new(-15610, 39, 37071),
    IsFighting = false,
    ArrivedAtZone = false -- KIỂM SOÁT TELE 1 LẦN
}

-- ==========================================
-- TẠO UI ĐƠN GIẢN
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "SeaEvent_TestUI"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250); MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
Title.Text = "🌊 AUTO SEA EVENT (PRO VERSION)"; Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 16

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -20, 0, 20); StatusLbl.Position = UDim2.new(0, 10, 0, 35)
StatusLbl.BackgroundTransparency = 1; StatusLbl.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusLbl.Text = "Trạng thái: Đang chờ..."; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local function CreateToggle(yPos, text, varName)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(1, -20, 0, 30); Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = _G_Sea[varName] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 60)
    Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function()
        _G_Sea[varName] = not _G_Sea[varName]
        Btn.BackgroundColor3 = _G_Sea[varName] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 60)
        
        if not _G_Sea.AutoSea then 
            -- Nhả phím W và reset trạng thái khi tắt Auto
            VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game) 
            _G_Sea.ArrivedAtZone = false
        else
            _G_Sea.ArrivedAtZone = false -- Bật lại auto thì check tele lại
        end
    end)
end

CreateToggle(60, "BẬT AUTO SEA EVENT", "AutoSea")
CreateToggle(95, "Auto Click (Đánh Thường)", "AutoClick")
CreateToggle(130, "Dùng Skill Z", "Skill_Z")
CreateToggle(165, "Dùng Skill X", "Skill_X")
CreateToggle(200, "Dùng Skill C", "Skill_C")

-- ==========================================
-- CƠ CHẾ CỐT LÕI (NOCLIP & COMBAT)
-- ==========================================
local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Xuyên tường khi đang đánh quái
    if _G_Sea.AutoSea and _G_Sea.IsFighting then
        for _, v in pairs(char:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if _G_Sea.AutoSea and _G_Sea.IsFighting then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if _G_Sea.AutoClick then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then tool:Activate() end
                end
                if _G_Sea.Skill_Z then PressKey("Z") end
                if _G_Sea.Skill_X then PressKey("X") end
                if _G_Sea.Skill_C then PressKey("C") end
            end
        end
    end
end)

-- ==========================================
-- LOGIC AUTO SEA (STATE MACHINE SIÊU TỐC)
-- ==========================================
local function GetSeaMonster()
    local monsterFolder = Workspace:FindFirstChild("Monster")
    if not monsterFolder then return nil end
    
    -- Dùng GetDescendants() để tìm quái ở mọi ngóc ngách, quét siêu xa không giới hạn
    for _, v in pairs(monsterFolder:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Sea Monster" or string.find(v.Name, "The Starving Ghost")) then
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                return v
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait() do 
        if not _G_Sea.AutoSea then 
            StatusLbl.Text = "Trạng thái: Đã tắt."
            continue 
        end
        
        local char = LocalPlayer.Character
        local HRP = char and char:FindFirstChild("HumanoidRootPart")
        local Hum = char and char:FindFirstChild("Humanoid")
        
        if not char or not HRP or not Hum or Hum.Health <= 0 then continue end

        local targetMonster = GetSeaMonster()
        local myBoatName = LocalPlayer.Name .. "Boat"
        local boatFolder = Workspace:FindFirstChild("Boats")
        local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        -- TRẠNG THÁI 1: CÓ QUÁI XUẤT HIỆN
        if targetMonster then
            _G_Sea.IsFighting = true
            StatusLbl.Text = "Trạng thái: Đang tiêu diệt " .. targetMonster.Name
            
            -- Dừng lái thuyền
            VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            if Hum.Sit then Hum.Sit = false end
            
            -- LOGIC BAY & NÉ CHIÊU TÙY THEO LOẠI QUÁI
            if targetMonster.Name == "Sea Monster" then
                -- Bay vòng tròn né chiêu (Bán kính 25, độ cao 20)
                local radius = 25
                local speed = 2 -- Tốc độ bay vòng tròn
                local angle = tick() * speed
                
                local rootPos = targetMonster.HumanoidRootPart.Position
                local targetPos = rootPos + Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius)
                
                -- CFrame.new(Vị trí muốn tới, Vị trí nhìn vào) -> Giúp xoay mặt bắn skill chuẩn xác
                HRP.CFrame = CFrame.new(targetPos, rootPos)
            else
                -- The Starving Ghost (Thuyền) -> Đứng yên trên đầu xả skill
                HRP.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(-90),0,0)
            end

        -- TRẠNG THÁI 2: KHÔNG CÓ QUÁI (Xử lý thuyền)
        else
            if _G_Sea.IsFighting then
                _G_Sea.IsFighting = false
                VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end

            -- Nếu chưa có thuyền (hoặc thuyền hỏng)
            if not myBoat then
                _G_Sea.ArrivedAtZone = false -- Reset trạng thái để chuẩn bị tele chiếc thuyền mới
                StatusLbl.Text = "Trạng thái: Đang mua thuyền mới..."
                
                local npcFolder = Workspace:FindFirstChild("NPC")
                local spawner = npcFolder and npcFolder:FindFirstChild("BoatSpawner")
                
                if spawner and spawner:FindFirstChild("LowerTorso") then
                    HRP.CFrame = spawner.LowerTorso.CFrame * CFrame.new(0, 0, 4)
                    task.wait(0.5)
                    pcall(function()
                        ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner)
                    end)
                    task.wait(1.5)
                end
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    -- Nếu chưa từng tele ra Vùng 4 lần nào
                    if not _G_Sea.ArrivedAtZone then
                        StatusLbl.Text = "Trạng thái: Teleport thuyền ra biển 4 (1 LẦN DUY NHẤT)..."
                        
                        if Hum.Sit then Hum.Sit = false; task.wait(0.2) end
                        
                        if myBoat:IsA("Model") and myBoat.PrimaryPart then
                            myBoat:PivotTo(CFrame.new(_G_Sea.Zone4))
                        else
                            seat.CFrame = CFrame.new(_G_Sea.Zone4)
                        end
                        task.wait(0.3)
                        
                        HRP.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        seat:Sit(Hum)
                        
                        -- Khóa lệnh tele lại, từ giờ chỉ có chạy thẳng
                        _G_Sea.ArrivedAtZone = true 
                        
                    -- Nếu đã tele rồi, bắt đầu lái thẳng liên tục
                    else
                        StatusLbl.Text = "Trạng thái: Đang lái tự động (Auto Drive)..."
                        
                        if not Hum.Sit then
                            HRP.CFrame = seat.CFrame
                            task.wait(0.1)
                            seat:Sit(Hum)
                        end
                        
                        -- Liên tục đè phím W chạy thẳng tới vô tận để săn event
                        VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    end
                end
            end
        end
    end
end)
