-- ==========================================
-- DELTA UI V10 - SEA EVENT TEST MENU (FIXED)
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
    IsFighting = false
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
Title.Text = "🌊 AUTO SEA EVENT (FIXED TỐI ƯU)"; Title.TextColor3 = Color3.fromRGB(0, 200, 255)
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
        -- Nhả phím W nếu tắt Auto để tránh chạy lung tung
        if not _G_Sea.AutoSea then VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game) end
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
                -- Auto Click
                if _G_Sea.AutoClick then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then tool:Activate() end
                end
                -- Auto Skill
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
    for _, v in pairs(monsterFolder:GetChildren()) do
        if v:IsA("Model") and (v.Name == "Sea Monster" or string.find(v.Name, "The Starving Ghost")) then
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                return v
            end
        end
    end
    return nil
end

task.spawn(function()
    -- Vòng lặp chạy cực nhanh để CFrame tức thời, không bị đơ
    while task.wait() do 
        if not _G_Sea.AutoSea then 
            StatusLbl.Text = "Trạng thái: Đã tắt."
            continue 
        end
        
        local char = LocalPlayer.Character
        local HRP = char and char:FindFirstChild("HumanoidRootPart")
        local Hum = char and char:FindFirstChild("Humanoid")
        
        -- Nếu đang chết, chờ hồi sinh
        if not char or not HRP or not Hum or Hum.Health <= 0 then continue end

        local targetMonster = GetSeaMonster()
        local myBoatName = LocalPlayer.Name .. "Boat"
        local boatFolder = Workspace:FindFirstChild("Boats")
        local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        -- TRẠNG THÁI 1: CÓ QUÁI XUẤT HIỆN
        if targetMonster then
            _G_Sea.IsFighting = true
            StatusLbl.Text = "Trạng thái: Đang đấm " .. targetMonster.Name
            
            -- Nhả phím chạy thuyền ra
            VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            
            -- Nếu đang ngồi thì nhảy ra
            if Hum.Sit then Hum.Sit = false end
            
            -- Dịch chuyển bám liên tục trên đầu quái
            HRP.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90),0,0)

        -- TRẠNG THÁI 2: KHÔNG CÓ QUÁI (Xử lý thuyền)
        else
            -- Vừa đánh xong, set về false
            if _G_Sea.IsFighting then
                _G_Sea.IsFighting = false
                VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end

            if not myBoat then
                StatusLbl.Text = "Trạng thái: Đang đi tới NPC mua thuyền..."
                local npcFolder = Workspace:FindFirstChild("NPC")
                local spawner = npcFolder and npcFolder:FindFirstChild("BoatSpawner")
                
                if spawner and spawner:FindFirstChild("LowerTorso") then
                    -- Tele lại gần sát NPC BoatSpawner
                    HRP.CFrame = spawner.LowerTorso.CFrame * CFrame.new(0, 0, 4)
                    task.wait(0.5) -- Đợi load nhân vật
                    
                    pcall(function()
                        ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner)
                    end)
                    task.wait(1.5) -- Chờ thuyền spawn ra thư mục Boats
                end
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    -- Kiểm tra khoảng cách thuyền với vùng 4
                    local distToZone = (seat.Position - _G_Sea.Zone4).Magnitude
                    
                    if distToZone > 1000 then
                        StatusLbl.Text = "Trạng thái: Đang Teleport thuyền ra Vùng 4..."
                        
                        -- Phải bắt nhân vật nhảy ra khỏi ghế trước khi tele thuyền để tránh đơ vật lý game
                        if Hum.Sit then Hum.Sit = false; task.wait(0.2) end
                        
                        -- Dịch chuyển cả cái thuyền ra Vùng 4
                        if myBoat:IsA("Model") and myBoat.PrimaryPart then
                            myBoat:PivotTo(CFrame.new(_G_Sea.Zone4))
                        else
                            seat.CFrame = CFrame.new(_G_Sea.Zone4)
                        end
                        task.wait(0.3) -- Chờ thuyền load ở vị trí mới
                        
                        -- Dịch chuyển nhân vật vào đúng cái ghế và bắt ngồi xuống
                        HRP.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        seat:Sit(Hum)
                        
                    else
                        StatusLbl.Text = "Trạng thái: Đang lái thuyền săn sự kiện..."
                        
                        -- Đảm bảo chắc chắn là đang ngồi trên ghế
                        if not Hum.Sit then
                            HRP.CFrame = seat.CFrame
                            task.wait(0.1)
                            seat:Sit(Hum)
                        end
                        
                        -- Giả lập bấm đè phím W để thuyền đi thẳng liên tục
                        VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    end
                end
            end
        end
    end
end)
