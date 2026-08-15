-- ==========================================
-- DELTA UI V10 - SEA EVENT TEST MENU
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
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
    IsFighting = false -- Trạng thái đang đánh quái
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
Title.Text = "🌊 AUTO SEA EVENT TEST"; Title.TextColor3 = Color3.fromRGB(0, 200, 255)
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
    end)
end

CreateToggle(60, "BẬT AUTO SEA EVENT", "AutoSea")
CreateToggle(95, "Auto Click (Đánh Thường)", "AutoClick")
CreateToggle(130, "Dùng Skill Z", "Skill_Z")
CreateToggle(165, "Dùng Skill X", "Skill_X")
CreateToggle(200, "Dùng Skill C", "Skill_C")

-- ==========================================
-- CƠ CHẾ CỐT LÕI (Từ Menu Cũ)
-- ==========================================
local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

local function TweenToSafe(targetCFrame)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local time = (HRP.Position - targetCFrame.Position).Magnitude / 250 -- Tốc độ 250
    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play(); tween.Completed:Wait()
end

-- Vòng lặp NoClip & Combat (chạy liên tục)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- NoClip khi đang farm
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
            if char then
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
-- LOGIC AUTO SEA EVENT (Mua thuyền -> Lái -> Đánh -> Về)
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
    while task.wait(0.5) do
        if not _G_Sea.AutoSea then 
            StatusLbl.Text = "Trạng thái: Đã tắt."
            continue 
        end
        
        local char = LocalPlayer.Character
        local HRP = char and char:FindFirstChild("HumanoidRootPart")
        local Hum = char and char:FindFirstChild("Humanoid")
        if not HRP or not Hum then continue end

        local targetMonster = GetSeaMonster()
        local myBoatName = LocalPlayer.Name .. "Boat"
        local boatFolder = Workspace:FindFirstChild("Boats")
        local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        -- TRẠNG THÁI 1: CÓ QUÁI XUẤT HIỆN -> ĐI ĐÁNH
        if targetMonster then
            _G_Sea.IsFighting = true
            StatusLbl.Text = "Trạng thái: Đang tiêu diệt " .. targetMonster.Name
            
            -- Nếu đang ngồi trên thuyền, nhảy ra
            if Hum.Sit then Hum.Sit = false task.wait(0.2) end

            -- Vòng lặp bay trên đầu quái để đánh
            while targetMonster and targetMonster.Parent and targetMonster:FindFirstChild("Humanoid") and targetMonster.Humanoid.Health > 0 and _G_Sea.AutoSea do
                task.wait()
                -- Bay trên đầu quái cách 15 stud, cắm mặt xuống
                HRP.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90),0,0)
            end
            
            _G_Sea.IsFighting = false
            
            -- TRẠNG THÁI 2: ĐÁNH XONG -> QUAY VỀ THUYỀN
            if myBoat then
                StatusLbl.Text = "Trạng thái: Đánh xong, đang quay về thuyền..."
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    TweenToSafe(seat.CFrame + Vector3.new(0, 10, 0)) -- Bay về cách ghế 10 stud
                    task.wait(0.5)
                    HRP.CFrame = seat.CFrame
                    task.wait(0.2)
                    seat:Sit(Hum) -- Ép nhân vật ngồi lại
                end
            end
            
        -- TRẠNG THÁI 3: KHÔNG CÓ QUÁI -> XỬ LÝ THUYỀN VÀ CHỜ
        elseif not _G_Sea.IsFighting then
            if not myBoat then
                StatusLbl.Text = "Trạng thái: Đang mua thuyền..."
                pcall(function()
                    ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner, Workspace.NPC.BoatSpawner)
                end)
                task.wait(2) -- Chờ thuyền spawn
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    -- Nếu chưa ngồi lên thuyền thì bay ra ngồi
                    if not Hum.Sit then
                        HRP.CFrame = seat.CFrame
                        task.wait(0.2)
                        seat:Sit(Hum)
                    end
                    
                    -- Kiểm tra khoảng cách thuyền tới Zone 4
                    local distToZone = (seat.Position - _G_Sea.Zone4).Magnitude
                    if distToZone > 500 then
                        StatusLbl.Text = "Trạng thái: Đang lái thuyền ra Vùng 4..."
                        -- Tween cái thuyền ra biển (Dùng TweenService lên VehicleSeat)
                        local tweenInfo = TweenInfo.new(15, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(seat, tweenInfo, {CFrame = CFrame.new(_G_Sea.Zone4)})
                        tween:Play()
                        tween.Completed:Wait()
                    else
                        StatusLbl.Text = "Trạng thái: Đang chờ Sea/Ghost xuất hiện tại Vùng 4..."
                    end
                end
            end
        end
    end
end)
