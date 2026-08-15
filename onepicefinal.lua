-- ==========================================
-- DELTA UI V10 - AUTO RAID TEST MENU
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("Raid_TestUI") then SafeParent["Raid_TestUI"]:Destroy() end

-- --- BIẾN TOÀN CỤC ---
local _G_Raid = {
    AutoRaid = false,
    RaidEntrance = Vector3.new(-1346, 79, 3989)
}

-- ==========================================
-- TẠO GIAO DIỆN ĐƠN GIẢN
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "Raid_TestUI"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 160); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 100, 100)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
Title.Text = "🔥 AUTO RAID TEST"; Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 16

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -20, 0, 20); StatusLbl.Position = UDim2.new(0, 10, 0, 35)
StatusLbl.BackgroundTransparency = 1; StatusLbl.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusLbl.Text = "Trạng thái: Đang chờ..."; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT BẬT/TẮT AUTO RAID
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 40); ToggleBtn.Position = UDim2.new(0, 10, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Text = "BẬT AUTO RAID"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

ToggleBtn.MouseButton1Click:Connect(function()
    _G_Raid.AutoRaid = not _G_Raid.AutoRaid
    if _G_Raid.AutoRaid then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        ToggleBtn.Text = "ĐANG BẬT AUTO RAID (BẤM ĐỂ TẮT)"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleBtn.Text = "BẬT AUTO RAID"
        StatusLbl.Text = "Trạng thái: Đã tắt Auto Raid."
    end
end)

-- Nút đóng UI
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ==========================================
-- LOGIC AUTO RAID
-- ==========================================
task.spawn(function()
    while task.wait(2) do -- Chạy mỗi 2 giây để tránh spam lag game
        if not _G_Raid.AutoRaid then continue end
        
        local char = LocalPlayer.Character
        local HRP = char and char:FindFirstChild("HumanoidRootPart")
        
        if not char or not HRP or char.Humanoid.Health <= 0 then continue end
        
        -- Tính khoảng cách từ chỗ đứng đến cửa vào Raid
        local distanceToRaid = (HRP.Position - _G_Raid.RaidEntrance).Magnitude
        
        -- Nếu khoảng cách lớn hơn 150 stud (Nghĩa là chưa vô Raid)
        if distanceToRaid > 150 then
            StatusLbl.Text = "Trạng thái: Đang mua Raid..."
            
            -- 1. Gọi lệnh Mua Raid
            local success, err = pcall(function()
                ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(Workspace.NPC.Dazzl, Workspace.NPC.Dazzl, Workspace.NPC.Dazzl)
            end)
            
            task.wait(1) -- Chờ game xử lý việc mua Raid
            
            -- 2. Teleport vô cửa Raid
            StatusLbl.Text = "Trạng thái: Đang dịch chuyển vào Raid..."
            HRP.CFrame = CFrame.new(_G_Raid.RaidEntrance)
            
        else
            -- Đã ở ngay tọa độ Raid hoặc ở trong Map Raid
            StatusLbl.Text = "Trạng thái: Đang ở trong Raid."
        end
    end
end)
