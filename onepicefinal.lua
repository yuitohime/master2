-- ==========================================
-- 🛠️ DEV TOOLS V2: SKILL & ANTI-CHEAT ANALYZER
-- (Chuyên dụng để phân tích tại sao Skill không Auto được)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("DevTools_V2") then SafeParent["DevTools_V2"]:Destroy() end

_G.SpyEnabled = false
_G.CapturedLogs = {}
_G.LogFilterSpam = true

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "DevTools_V2"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 50, 50)

-- Thanh tiêu đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "🛠️ DEV TOOLS V2: ANTI-CHEAT SPY"
Title.TextColor3 = Color3.fromRGB(255, 50, 50); Title.Font = Enum.Font.GothamBold
Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Khu vực Nút Bấm
local ButtonsFrame = Instance.new("Frame", MainFrame)
ButtonsFrame.Size = UDim2.new(1, -20, 0, 75); ButtonsFrame.Position = UDim2.new(0, 10, 0, 40)
ButtonsFrame.BackgroundTransparency = 1

local ToggleSpyBtn = Instance.new("TextButton", ButtonsFrame)
ToggleSpyBtn.Size = UDim2.new(0.65, -5, 0, 35)
ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); ToggleSpyBtn.Text = "🔴 ĐANG TẮT SPY REMOTE"
ToggleSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleSpyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleSpyBtn).CornerRadius = UDim.new(0, 6)

local ClearBtn = Instance.new("TextButton", ButtonsFrame)
ClearBtn.Size = UDim2.new(0.35, 0, 0, 35); ClearBtn.Position = UDim2.new(0.65, 5, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); ClearBtn.Text = "🗑️ XÓA LOG"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ClearBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 6)

local GetCoordsBtn = Instance.new("TextButton", ButtonsFrame)
GetCoordsBtn.Size = UDim2.new(1, 0, 0, 35); GetCoordsBtn.Position = UDim2.new(0, 0, 0, 40)
GetCoordsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); GetCoordsBtn.Text = "📍 LẤY TỌA ĐỘ CHỖ ĐANG ĐỨNG"
GetCoordsBtn.TextColor3 = Color3.fromRGB(255, 255, 255); GetCoordsBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GetCoordsBtn).CornerRadius = UDim.new(0, 6)

-- Khu vực Log
local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -20, 1, -130); ScrollList.Position = UDim2.new(0, 10, 0, 120)
ScrollList.BackgroundTransparency = 1; ScrollList.ScrollBarThickness = 4
local UIListLayout = Instance.new("UIListLayout", ScrollList); UIListLayout.Padding = UDim.new(0, 6)

-- ================= HÀM XỬ LÝ GIAO DIỆN =================
local function AddLog(displayText, copyText, color)
    local EntryFrame = Instance.new("Frame", ScrollList)
    EntryFrame.Size = UDim2.new(1, 0, 0, 60)
    EntryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", EntryFrame).CornerRadius = UDim.new(0, 6)
    
    local CodeBox = Instance.new("TextBox", EntryFrame)
    CodeBox.Size = UDim2.new(1, -55, 1, 0); CodeBox.Position = UDim2.new(0, 5, 0, 0)
    CodeBox.BackgroundTransparency = 1; CodeBox.Text = displayText; CodeBox.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    CodeBox.Font = Enum.Font.Code; CodeBox.TextSize = 11; CodeBox.TextWrapped = true; CodeBox.TextXAlignment = Enum.TextXAlignment.Left; CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.ClearTextOnFocus = false; CodeBox.TextEditable = false
    
    local CopyBtn = Instance.new("TextButton", EntryFrame)
    CopyBtn.Size = UDim2.new(0, 45, 0, 45); CopyBtn.Position = UDim2.new(1, -50, 0.5, -22.5)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); CopyBtn.Text = "📋"; CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Font = Enum.Font.GothamBold; CopyBtn.TextSize = 18
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
    
    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard and copyText and copyText ~= "" then
            setclipboard(copyText)
            CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); CopyBtn.Text = "✅"
            task.wait(1); CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); CopyBtn.Text = "📋"
        end
    end)
    
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

ToggleSpyBtn.MouseButton1Click:Connect(function()
    _G.SpyEnabled = not _G.SpyEnabled
    if _G.SpyEnabled then
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        ToggleSpyBtn.Text = "🟢 ĐANG BẬT SPY (CHỜ NHẬN SKILL...)"
    else
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleSpyBtn.Text = "🔴 ĐANG TẮT SPY REMOTE"
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(ScrollList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

GetCoordsBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        local coordCode = string.format("Vector3.new(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z)
        AddLog("📍 [TỌA ĐỘ MỚI]:\n" .. coordCode, coordCode, Color3.fromRGB(0, 255, 150))
    end
end)

-- ================= BỘ GIẢI MÃ ANTI-CHEAT (SERIALIZER) =================
local function Serialize(v)
    if type(v) == "string" then return '"' .. v .. '"'
    elseif type(v) == "number" or type(v) == "boolean" then return tostring(v)
    elseif type(v) == "userdata" then
        if typeof(v) == "Vector3" then return string.format("Vector3.new(%f, %f, %f)", v.X, v.Y, v.Z)
        elseif typeof(v) == "CFrame" then return string.format("CFrame.new(%f, %f, %f)", v.Position.X, v.Position.Y, v.Position.Z)
        elseif typeof(v) == "Instance" then return "workspace." .. v.Name -- Giả lập đơn giản
        else return tostring(typeof(v)) end
    elseif type(v) == "table" then
        local res = "{"
        for k, val in pairs(v) do res = res .. tostring(k) .. "=" .. Serialize(val) .. ", " end
        return res .. "}"
    end
    return "nil"
end

-- ================= HỆ THỐNG SPY BẮT SỰ KIỆN =================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.SpyEnabled and not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local name = self.Name
        local isSpam = name:match("Move") or name:match("Walk") or name:match("Mouse") or name:match("Ping")
        
        -- Nếu bạn đang nghi ngờ bị lỗi Skill thì bắt buộc phải phân tích kỹ, bỏ qua mấy cái đi dạo
        if not _G.LogFilterSpam or not isSpam then
            local argsStr = ""
            for i, v in ipairs(args) do
                argsStr = argsStr .. Serialize(v)
                if i < #args then argsStr = argsStr .. ", " end
            end
            
            local fullCode = string.format('game:GetService("ReplicatedStorage").%s:%s(%s)', name, method, argsStr)
            
            -- Đẩy ra UI bằng luồng khác để không kẹt game
            task.spawn(function()
                -- Highlight nếu là remote liên quan đến Skill hoặc Attack
                local c = Color3.fromRGB(220, 220, 220)
                if name:match("Skill") or name:match("Attack") or name:match("Combat") then c = Color3.fromRGB(255, 255, 50) end
                AddLog("📡 Bắt được Remote:\n" .. fullCode, fullCode, c)
            end)
        end
    end
    return oldNamecall(self, ...)
end)
