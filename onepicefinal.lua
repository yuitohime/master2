-- ==========================================
-- 🛠️ YUI DEV TOOLS V3: TÌM TỌA ĐỘ & BẮT REMOTE SKILL
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("Yui_SpyTools") then SafeParent["Yui_SpyTools"]:Destroy() end

_G.YuiSpyEnabled = false

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "Yui_SpyTools"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 400) -- Kéo dài ra thêm một chút
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

-- Thanh tiêu đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "🕵️ YUI DEV TOOLS V3"
Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.Font = Enum.Font.GothamBold
Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Khu vực Nút Bấm (Sắp xếp lại 3 hàng)
local ButtonsFrame = Instance.new("Frame", MainFrame)
ButtonsFrame.Size = UDim2.new(1, -20, 0, 120); ButtonsFrame.Position = UDim2.new(0, 10, 0, 40)
ButtonsFrame.BackgroundTransparency = 1

-- Hàng 1: Nút Lấy Tọa Độ (Đã trả lại cho bạn!)
local GetCoordsBtn = Instance.new("TextButton", ButtonsFrame)
GetCoordsBtn.Size = UDim2.new(1, 0, 0, 35); GetCoordsBtn.Position = UDim2.new(0, 0, 0, 0)
GetCoordsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); GetCoordsBtn.Text = "📍 LẤY TỌA ĐỘ CHỖ ĐANG ĐỨNG (COPY NGAY)"
GetCoordsBtn.TextColor3 = Color3.fromRGB(255, 255, 255); GetCoordsBtn.Font = Enum.Font.GothamBold; GetCoordsBtn.TextSize = 12
Instance.new("UICorner", GetCoordsBtn).CornerRadius = UDim.new(0, 6)

-- Hàng 2: Bật Simple Spy (Nhẹ & xịn hơn Hydroxide)
local SimpleSpyBtn = Instance.new("TextButton", ButtonsFrame)
SimpleSpyBtn.Size = UDim2.new(1, 0, 0, 35); SimpleSpyBtn.Position = UDim2.new(0, 0, 0, 40)
SimpleSpyBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255); SimpleSpyBtn.Text = "👁️ BẬT SIMPLE SPY (BẮT TẤT CẢ SKILL)"
SimpleSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SimpleSpyBtn.Font = Enum.Font.GothamBold; SimpleSpyBtn.TextSize = 12
Instance.new("UICorner", SimpleSpyBtn).CornerRadius = UDim.new(0, 6)

-- Hàng 3: Custom Spy & Clear Log
local ToggleSpyBtn = Instance.new("TextButton", ButtonsFrame)
ToggleSpyBtn.Size = UDim2.new(0.65, -5, 0, 35); ToggleSpyBtn.Position = UDim2.new(0, 0, 0, 80)
ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); ToggleSpyBtn.Text = "🔴 CUSTOM SPY NHẸ (TẮT)"
ToggleSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleSpyBtn.Font = Enum.Font.GothamBold; ToggleSpyBtn.TextSize = 12
Instance.new("UICorner", ToggleSpyBtn).CornerRadius = UDim.new(0, 6)

local ClearBtn = Instance.new("TextButton", ButtonsFrame)
ClearBtn.Size = UDim2.new(0.35, 0, 0, 35); ClearBtn.Position = UDim2.new(0.65, 5, 0, 80)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); ClearBtn.Text = "🗑️ XÓA LOG"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ClearBtn.Font = Enum.Font.GothamBold; ClearBtn.TextSize = 12
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 6)

-- Khu vực Log hiển thị
local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -20, 1, -175); ScrollList.Position = UDim2.new(0, 10, 0, 165)
ScrollList.BackgroundTransparency = 1; ScrollList.ScrollBarThickness = 4
local UIListLayout = Instance.new("UIListLayout", ScrollList); UIListLayout.Padding = UDim.new(0, 6)

-- ================= HÀM XỬ LÝ GIAO DIỆN =================
local function AddLog(displayText, copyText, color)
    local EntryFrame = Instance.new("Frame", ScrollList)
    EntryFrame.Size = UDim2.new(1, 0, 0, 60)
    EntryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", EntryFrame).CornerRadius = UDim.new(0, 6)
    
    local CodeBox = Instance.new("TextBox", EntryFrame)
    CodeBox.Size = UDim2.new(1, -70, 1, 0); CodeBox.Position = UDim2.new(0, 5, 0, 0)
    CodeBox.BackgroundTransparency = 1; CodeBox.Text = displayText; CodeBox.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    CodeBox.Font = Enum.Font.Code; CodeBox.TextSize = 11; CodeBox.TextWrapped = true; CodeBox.TextXAlignment = Enum.TextXAlignment.Left; CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.ClearTextOnFocus = false; CodeBox.TextEditable = false
    
    -- NÚT SAO CHÉP
    local CopyBtn = Instance.new("TextButton", EntryFrame)
    CopyBtn.Size = UDim2.new(0, 60, 0, 40); CopyBtn.Position = UDim2.new(1, -65, 0.5, -20)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); CopyBtn.Text = "COPY"; CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Font = Enum.Font.GothamBold; CopyBtn.TextSize = 12
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
    
    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard and copyText and copyText ~= "" then
            setclipboard(copyText)
            CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); CopyBtn.Text = "ĐÃ LẤY"
            task.wait(1); CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); CopyBtn.Text = "COPY"
        end
    end)
    
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- ================= CÁC NÚT BẤM CHÍNH =================
-- 1. NÚT LẤY TỌA ĐỘ
GetCoordsBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        local coordCode = string.format("Vector3.new(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z)
        AddLog("📍 [TỌA ĐỘ HIỆN TẠI]:\n" .. coordCode, coordCode, Color3.fromRGB(0, 255, 150))
    else
        AddLog("❌ KHÔNG TÌM THẤY NHÂN VẬT!", "", Color3.fromRGB(255, 50, 50))
    end
end)

-- 2. NÚT TẢI SIMPLE SPY (Thay cho Hydroxide)
SimpleSpyBtn.MouseButton1Click:Connect(function()
    SimpleSpyBtn.Text = "⏳ ĐANG TẢI SIMPLE SPY..."
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
    end)
    task.wait(1)
    SimpleSpyBtn.Text = "✅ ĐÃ MỞ SIMPLE SPY (KIỂM TRA GÓC TRÁI/PHẢI)"
end)

-- 3. NÚT BẬT SPY CŨ
ToggleSpyBtn.MouseButton1Click:Connect(function()
    _G.YuiSpyEnabled = not _G.YuiSpyEnabled
    if _G.YuiSpyEnabled then
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        ToggleSpyBtn.Text = "🟢 CUSTOM SPY (ĐANG TÌM SKILL)"
    else
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleSpyBtn.Text = "🔴 CUSTOM SPY NHẸ (TẮT)"
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(ScrollList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- ================= BỘ GIẢI MÃ ANTI-CHEAT =================
local function Serialize(v)
    if type(v) == "string" then return '"' .. v .. '"'
    elseif type(v) == "number" or type(v) == "boolean" then return tostring(v)
    elseif type(v) == "userdata" then
        if typeof(v) == "Vector3" then return string.format("Vector3.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
        elseif typeof(v) == "CFrame" then return string.format("CFrame.new(%.2f, %.2f, %.2f)", v.Position.X, v.Position.Y, v.Position.Z)
        elseif typeof(v) == "Instance" then return "workspace." .. v.Name
        else return tostring(typeof(v)) end
    elseif type(v) == "table" then
        local res = "{"
        for k, val in pairs(v) do res = res .. tostring(k) .. "=" .. Serialize(val) .. ", " end
        return res .. "}"
    end
    return "nil"
end

-- ================= HỆ THỐNG CUSTOM SPY =================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.YuiSpyEnabled and not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local name = self.Name
        local isSpam = name:match("Move") or name:match("Walk") or name:match("Mouse") or name:match("Ping")
        
        if not isSpam then
            local argsStr = ""
            for i, v in ipairs(args) do
                argsStr = argsStr .. Serialize(v)
                if i < #args then argsStr = argsStr .. ", " end
            end
            
            local fullCode = string.format('game:GetService("ReplicatedStorage").%s:%s(%s)', name, method, argsStr)
            
            task.spawn(function()
                local c = Color3.fromRGB(220, 220, 220)
                if name:match("Skill") or name:match("Attack") or name:match("Combat") then c = Color3.fromRGB(255, 255, 50) end
                AddLog("📡 [" .. method .. "] " .. name .. "\nArgs: " .. argsStr, fullCode, c)
            end)
        end
    end
    return oldNamecall(self, ...)
end)
