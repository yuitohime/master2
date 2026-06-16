-- =======================================================
-- BẢNG BẮT CODE KHÔNG CHE (BẮT TẤT CẢ MỌI THỨ)
-- =======================================================
local CoreGui = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
if CoreGui:FindFirstChild("AttackSpyGUI") then CoreGui.AttackSpyGUI:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "AttackSpyGUI"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 280)
frame.Position = UDim2.new(0.5, -175, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(255, 170, 0)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🕵️ SPY SIÊU CẤP"
title.TextColor3 = Color3.fromRGB(255, 170, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT XÓA RÁC
local btnClear = Instance.new("TextButton", header)
btnClear.Size = UDim2.new(0, 60, 0, 25)
btnClear.Position = UDim2.new(1, -140, 0, 5)
btnClear.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnClear.Text = "🗑️ XÓA"
btnClear.TextColor3 = Color3.fromRGB(255, 255, 255)
btnClear.Font = Enum.Font.GothamBold
btnClear.TextSize = 11
Instance.new("UICorner", btnClear).CornerRadius = UDim.new(0, 4)

-- NÚT TẠM DỪNG
local btnPause = Instance.new("TextButton", header)
btnPause.Size = UDim2.new(0, 70, 0, 25)
btnPause.Position = UDim2.new(1, -75, 0, 5)
btnPause.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
btnPause.Text = "⏸️ DỪNG"
btnPause.TextColor3 = Color3.fromRGB(255, 255, 255)
btnPause.Font = Enum.Font.GothamBold
btnPause.TextSize = 11
Instance.new("UICorner", btnPause).CornerRadius = UDim.new(0, 4)

-- Logic Kéo thả
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then 
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Khung hiển thị code
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scroll.ScrollBarThickness = 4
scroll.BorderSizePixel = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 8)

local isLogging = true

local function logMsg(txt, isRemote)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, -5, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.TextColor3 = isRemote and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.BackgroundTransparency = 1
end

logMsg("Đang lắng nghe... Hãy đánh TRÚNG quái 1 cái!", false)

-- Xử lý nút
btnClear.Activated:Connect(function()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
end)

btnPause.Activated:Connect(function()
    isLogging = not isLogging
    if isLogging then
        btnPause.Text = "⏸️ DỪNG"
        btnPause.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    else
        btnPause.Text = "▶️ BẮT"
        btnPause.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
end)

-- BẮT CODE GỐC (BẮT TẤT CẢ)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if isLogging and (method == "FireServer" or method == "InvokeServer") then
        local path = self:GetFullName()
        
        -- Lọc bớt mấy cái hệ thống của Roblox (Camera, v.v) cho đỡ rác
        if not path:match("RobloxReplicatedStorage") and not path:match("DefaultChatSystem") then
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                argStr = argStr .. "   ["..i.."] = " .. tostring(v) .. "\n"
            end
            
            local finalTxt = "🔥 " .. self.Name .. "\n📂 " .. path .. "\n⚙️ ARGS:\n" .. (argStr == "" and "   (Không có args)" or argStr) .. "-----------------------"
            
            task.spawn(function() logMsg(finalTxt, true) end)
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
