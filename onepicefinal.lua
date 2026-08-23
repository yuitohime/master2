-- ==========================================
-- 🛠️ YUI SKILL TESTER: VƯỢT ANTI-CHEAT SKILL
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("Yui_SkillTester") then SafeParent["Yui_SkillTester"]:Destroy() end

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "Yui_SkillTester"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 150, 50)

-- Tiêu đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "⚡ YUI SKILL TESTER (BYPASS)"
Title.TextColor3 = Color3.fromRGB(255, 150, 50); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -20, 0, 30); StatusLbl.Position = UDim2.new(0, 10, 0, 40)
StatusLbl.BackgroundTransparency = 1; StatusLbl.Text = "Trạng thái: Vui lòng cầm vũ khí lên..."
StatusLbl.TextColor3 = Color3.fromRGB(150, 255, 150); StatusLbl.Font = Enum.Font.Gotham; StatusLbl.TextSize = 12

local GridFrame = Instance.new("Frame", MainFrame)
GridFrame.Size = UDim2.new(1, -20, 1, -80); GridFrame.Position = UDim2.new(0, 10, 0, 70)
GridFrame.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", GridFrame)
UIGrid.CellSize = UDim2.new(0, 75, 0, 40); UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

-- ================= HÀM XỬ LÝ ÉP SKILL =================
local function ForceUseSkill(key)
    local char = LocalPlayer.Character
    if not char then StatusLbl.Text = "❌ Không tìm thấy nhân vật!"; return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then 
        StatusLbl.Text = "❌ Bạn chưa cầm vũ khí trên tay!"
        return 
    end

    -- Tìm Remote mang tên chiêu (Z, X, C...) bên trong vũ khí
    local skillRemote = tool:FindFirstChild(key)
    if not skillRemote then
        StatusLbl.Text = "⚠️ Vũ khí [" .. tool.Name .. "] không có chiêu " .. key
        return
    end

    -- Nếu tìm thấy, thực hiện ép gửi lệnh lên Server (Invoke/Fire)
    StatusLbl.Text = "⚡ Đang ép xuất chiêu " .. key .. " của " .. tool.Name
    pcall(function()
        if skillRemote:IsA("RemoteFunction") then
            skillRemote:InvokeServer(key)
        elseif skillRemote:IsA("RemoteEvent") then
            skillRemote:FireServer(key)
        end
    end)
end

-- Tạo các nút chiêu thức
local keys = {"Z", "X", "C", "V", "B", "N", "F"}
for _, key in ipairs(keys) do
    local Btn = Instance.new("TextButton", GridFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = "Chiêu " .. key
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        -- Hiệu ứng bấm nút
        Btn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        task.delay(0.1, function() Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end)
        
        ForceUseSkill(key)
    end)
end
