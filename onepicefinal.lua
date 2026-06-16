-- =========================================================================
-- [ULTIMATE MASTER] YUIHUB V26 - FIX FISH, SKILLS, FARM NEAR & TOKEN ESP
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local TargetGui = (gethui and pcall(gethui) and gethui()) or CoreGui
if not pcall(function() local _ = TargetGui.Name end) then TargetGui = LocalPlayer:WaitForChild("PlayerGui") end

for _, gui in pairs(TargetGui:GetChildren()) do 
    if gui.Name == "YuiHub" or gui.Name == "YuiIntro" or gui.Name == "YuiNotif" or gui.Name == "YuiGunDot" then gui:Destroy() end 
end

LocalPlayer.Idled:Connect(function()
    if _G.Yui and _G.Yui.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

_G.Yui = {
    AntiAFK = true, MoveMethod = "Teleport", CollectMethod = "Teleport (Continuous)", MoveSpeed = 300, HoverOnKill = true,
    AutoFarm = false, SelectedMobs = {}, SelectedWeapons = {}, FastAttack = false, 
    AutoClickFarming = false, AutoClickAlways = false, ClickPosition = "Center", AutoGunFarm = false,
    MobLevelFilter = "All", FarmNear = false,
    AttackDist = 5, AttackPos = "Above", AutoSpawn = false,
    AutoSkill = {E=false, R=false, T=false, Z=false, X=false, C=false, V=false, B=false, N=false, F=false}, 
    HoldSkill = {E=false, R=false, T=false, Z=false, X=false, C=false, V=false, B=false, N=false, F=false}, HoldTime = 1, SkillDelay = 0.1,
    AutoAimSkillPlayer = false, -- TÍNH NĂNG MỚI: GHIM SKILL NGƯỜI
    AutoHaki = {E=false, R=false, T=false},
    SelectedNormalQuest = "", AutoNormalQuest = false,
    SelectedDailyQuest = "", AutoDailyQuest = false, AutoAcceptQuest = false, TeleportToNPC = true,
    AutoSam = false, AutoSamInf = false, AutoSamAmount = "x1", AutoUpgradeCap = false, SamLoopCount = 1, AutoFindBox = false, FindBoxDelay = 0.3,
    CollectChest = false, CollectBarrel = false, CollectCompass = false, CollectSpeed = 0.05, 
    AutoFruit = false, AutoSpawnBox = false, CamUnderground = false,
    AutoJuice = false, JuiceDelay = 5, AutoDrink = false, DrinkDelay = 1, AutoEatApple = false, AppleDelay = 3, 
    WalkSpeed = 16, EnableWS = false, JumpPower = 50, EnableJP = false, 
    Fly = false, FlySpeed = 50, Noclip = false, WalkOnWater = false, InfJump = false, AutoSafe = false, SafeHealth = 30,
    AutoGetRod = false, AutoFish = false, AutoShake = false, AutoPin = false,
    TargetPlayer = "None", AutoHunt = false, HuntDist = 5, ESPPlayer = false, Spectate = false,
    ESPItems = false, SelectedESPItems = {}, TargetItemTeleport = "None",
    AutoRejoin = false, AutoExecute = false, ExecuteScript = "", 
    AutoLoadConfig = false, AutoLoadName = "", ConfigName = "Default", AutoHop = false, HopDelay = 3,
    CustomHue = 330, TextHue = 0, BgHue = 240
}

local CurrentTarget = nil
local AllDropdowns = {}
local TimedBlacklist = {}
local ESPTracers = {}
local ActiveTween = nil
_G.PinnedCFrame = nil _G.SavedLocations = {} _G.SavedCount = 0 _G.SelectedSavedCFrame = nil
local HakiStates = {E = false, R = false}

LocalPlayer.CharacterAdded:Connect(function(char) 
    HakiStates.E = false HakiStates.R = false 
    task.delay(1, function()
        if _G.Yui.Fly and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local bv = Instance.new("BodyVelocity") bv.Name = "YuiFlyBV" bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) bv.Parent = root
            local bg = Instance.new("BodyGyro") bg.Name = "YuiFlyBG" bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5) bg.P = 1e4 bg.Parent = root
        end
    end)
end)

local function PlayUISound()
    pcall(function()
        local s = Instance.new("Sound", CoreGui)
        s.SoundId = "rbxassetid://6895079853" 
        s.Volume = 1 s:Play() game.Debris:AddItem(s, 2)
    end)
end

local function MoveTo(targetCFrame, speedOverride)
    local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then return end
    if _G.Yui.MoveMethod == "Fly (Tween)" or speedOverride then
        local spd = speedOverride or _G.Yui.MoveSpeed
        local dist = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(dist / spd, Enum.EasingStyle.Linear)
        if ActiveTween then ActiveTween:Cancel() end
        ActiveTween = TweenService:Create(root, info, {CFrame = targetCFrame}) ActiveTween:Play() ActiveTween.Completed:Wait()
    else
        root.CFrame = targetCFrame root.Velocity = Vector3.zero
    end
end

local HoverBV = Instance.new("BodyVelocity") HoverBV.Name = "YuiHover" HoverBV.MaxForce = Vector3.zero HoverBV.Velocity = Vector3.zero
RunService.Heartbeat:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if _G.Yui.AutoFarm and not CurrentTarget and _G.Yui.HoverOnKill then 
            if HoverBV.Parent ~= root then HoverBV.Parent = root end
            HoverBV.MaxForce = Vector3.new(1e5, 1e5, 1e5) HoverBV.Velocity = Vector3.zero 
        else HoverBV.MaxForce = Vector3.zero end
    end
end)

local function BindTap(element, callback)
    local debounce = false
    element.Activated:Connect(function()
        if not debounce then debounce = true PlayUISound() callback() task.wait(0.1) debounce = false end
    end)
end

local function MakeDraggable(dragArea, targetFrame)
    local dragToggle = false local dragStart = nil local startPos = nil
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true dragStart = input.Position startPos = targetFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =========================================================================
-- CONFIG SYSTEM
-- =========================================================================
local ConfigFolder = "YuiHub_Configs"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
local CoreFile = ConfigFolder .. "/CoreSettings.json"

local function SaveCoreSettings()
    if writefile and HttpService then
        writefile(CoreFile, HttpService:JSONEncode({
            AutoRejoin = _G.Yui.AutoRejoin, AutoExecute = _G.Yui.AutoExecute, ExecuteScript = _G.Yui.ExecuteScript,
            AutoLoadConfig = _G.Yui.AutoLoadConfig, AutoLoadName = _G.Yui.AutoLoadName, LastConfig = _G.Yui.ConfigName,
            CustomHue = _G.Yui.CustomHue, TextHue = _G.Yui.TextHue, BgHue = _G.Yui.BgHue
        }))
    end
end

if isfile and isfile(CoreFile) then
    local s, data = pcall(function() return HttpService:JSONDecode(readfile(CoreFile)) end)
    if s and data then
        if data.AutoRejoin ~= nil then _G.Yui.AutoRejoin = data.AutoRejoin end
        if data.AutoExecute ~= nil then _G.Yui.AutoExecute = data.AutoExecute end
        if data.ExecuteScript ~= nil then _G.Yui.ExecuteScript = data.ExecuteScript end
        if data.AutoLoadConfig ~= nil then _G.Yui.AutoLoadConfig = data.AutoLoadConfig end
        if data.AutoLoadName ~= nil then _G.Yui.AutoLoadName = data.AutoLoadName end
        if data.LastConfig ~= nil then _G.Yui.ConfigName = data.LastConfig end
        if data.CustomHue ~= nil then _G.Yui.CustomHue = data.CustomHue end
        if data.TextHue ~= nil then _G.Yui.TextHue = data.TextHue end
        if data.BgHue ~= nil then _G.Yui.BgHue = data.BgHue end
    end
end

-- =========================================================================
-- THEME LOGIC
-- =========================================================================
local Theme = {
    MainBg = Color3.fromHSV(_G.Yui.BgHue / 360, 0.4, 0.1), HeaderBg = Color3.fromHSV(_G.Yui.BgHue / 360, 0.4, 0.15), BoxBg = Color3.fromHSV(_G.Yui.BgHue / 360, 0.4, 0.13), 
    Accent = Color3.fromHSV(_G.Yui.CustomHue / 360, 1, 1),
    TextTitle = Color3.fromHSV(_G.Yui.TextHue / 360, 0.8, 1), 
    TextSub = Color3.fromRGB(140, 140, 140), Stroke = Color3.fromRGB(35, 35, 40), SelectedGreen = Color3.fromRGB(50, 255, 100)
}
local DynamicUIElements = {}

local function UpdateThemeColor(hueVal)
    _G.Yui.CustomHue = hueVal Theme.Accent = Color3.fromHSV(hueVal / 360, 1, 1)
    for _, item in pairs(DynamicUIElements) do
        if item.Obj and item.Obj.Parent then
            if item.IsToggle then if item.Obj.BackgroundColor3 ~= Theme.MainBg then item.Obj[item.Prop] = Theme.Accent end 
            elseif item.Type == "Accent" then item.Obj[item.Prop] = Theme.Accent end
        end
    end
end

local function UpdateTextColor(hueVal)
    _G.Yui.TextHue = hueVal Theme.TextTitle = Color3.fromHSV(hueVal / 360, 0.8, 1)
    for _, item in pairs(DynamicUIElements) do
        if item.Obj and item.Obj.Parent and item.Type == "Text" then item.Obj[item.Prop] = Theme.TextTitle end
    end
end

local function UpdateBgColor(hueVal)
    _G.Yui.BgHue = hueVal 
    Theme.MainBg = Color3.fromHSV(hueVal / 360, 0.4, 0.1)
    Theme.HeaderBg = Color3.fromHSV(hueVal / 360, 0.4, 0.15)
    Theme.BoxBg = Color3.fromHSV(hueVal / 360, 0.4, 0.13)
    for _, item in pairs(DynamicUIElements) do
        if item.Obj and item.Obj.Parent then
            if item.Type == "MainBg" then item.Obj[item.Prop] = Theme.MainBg
            elseif item.Type == "HeaderBg" then item.Obj[item.Prop] = Theme.HeaderBg
            elseif item.Type == "BoxBg" then item.Obj[item.Prop] = Theme.BoxBg
            elseif item.IsToggle and item.Obj.BackgroundColor3 ~= Theme.Accent then item.Obj[item.Prop] = Theme.MainBg end
        end
    end
end

-- =========================================================================
-- HỆ THỐNG THÔNG BÁO GỘP (STACKING NOTIFICATION)
-- =========================================================================
local NotifGui = Instance.new("ScreenGui") NotifGui.Name = "YuiNotif" NotifGui.Parent = TargetGui NotifGui.ResetOnSpawn = false

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.Size = UDim2.new(0, 250, 0, 400)
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Position = UDim2.new(1, -20, 1, -20) 
NotifContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom 

local ActiveNotifs = {}

local function SendNotification(text, color, stackId)
    stackId = stackId or text
    
    if ActiveNotifs[stackId] then
        ActiveNotifs[stackId].Count = ActiveNotifs[stackId].Count + 1
        ActiveNotifs[stackId].Label.Text = text .. " (x" .. ActiveNotifs[stackId].Count .. ")"
        ActiveNotifs[stackId].Tick = tick()
        
        local sizeTween = TweenService:Create(ActiveNotifs[stackId].Frame, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(1, 10, 0, 35)})
        sizeTween:Play()
        sizeTween.Completed:Connect(function() TweenService:Create(ActiveNotifs[stackId].Frame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 35)}):Play() end)
        return
    end
    
    local frame = Instance.new("Frame", NotifContainer)
    frame.Size = UDim2.new(1, 0, 0, 35) 
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BackgroundTransparency = 0.1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Theme.Accent
    table.insert(DynamicUIElements, {Obj = stroke, Prop = "Color", Type = "Accent"})
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -15, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Theme.TextTitle
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    ActiveNotifs[stackId] = {Frame = frame, Label = lbl, Stroke = stroke, Count = 1, Tick = tick()}
    
    frame.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not ActiveNotifs[stackId] then break end
            if tick() - ActiveNotifs[stackId].Tick > 3 then 
                local outTween = TweenService:Create(ActiveNotifs[stackId].Frame, TweenInfo.new(0.4), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
                TweenService:Create(ActiveNotifs[stackId].Label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                TweenService:Create(ActiveNotifs[stackId].Stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
                outTween:Play()
                
                local toDestroy = ActiveNotifs[stackId].Frame
                ActiveNotifs[stackId] = nil
                task.wait(0.4)
                toDestroy:Destroy()
                break
            end
        end
    end)
end

-- =========================================================================
-- GUN DOT (AIMBOT MỤC TIÊU)
-- =========================================================================
local GunDotGui = Instance.new("ScreenGui", TargetGui) GunDotGui.Name = "YuiGunDot" GunDotGui.ResetOnSpawn = false
local GunDot = Instance.new("Frame", GunDotGui)
GunDot.Size = UDim2.new(0, 20, 0, 20)
GunDot.Position = UDim2.new(0.5, -10, 0.5, -10)
GunDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
GunDot.Visible = _G.Yui.AutoGunFarm
Instance.new("UICorner", GunDot).CornerRadius = UDim.new(1, 0)
local GunDotStroke = Instance.new("UIStroke", GunDot) GunDotStroke.Color = Color3.fromRGB(255,255,255) GunDotStroke.Thickness = 2
local GunDotCenter = Instance.new("Frame", GunDot)
GunDotCenter.Size = UDim2.new(0, 4, 0, 4) GunDotCenter.Position = UDim2.new(0.5, -2, 0.5, -2) GunDotCenter.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", GunDotCenter).CornerRadius = UDim.new(1,0)
MakeDraggable(GunDot, GunDot)


local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "YuiHub" ScreenGui.Parent = TargetGui ScreenGui.ResetOnSpawn = false
local ESPFolder = Instance.new("Folder") ESPFolder.Name = "YuiESPFolder" ESPFolder.Parent = CoreGui
local ItemESPFolder = Instance.new("Folder") ItemESPFolder.Name = "YuiItemESPFolder" ItemESPFolder.Parent = CoreGui

-- =========================================================================
-- MAIN GUI CONSTRUCTION
-- =========================================================================
local OpenIconBtn = Instance.new("ImageButton", ScreenGui) OpenIconBtn.Name = "OpenIconBtn"
OpenIconBtn.Size = UDim2.new(0, 45, 0, 45) OpenIconBtn.Position = UDim2.new(0, 15, 0.5, -22) OpenIconBtn.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = OpenIconBtn, Prop = "BackgroundColor3", Type = "HeaderBg"})
OpenIconBtn.Image = "rbxassetid://14457317772" OpenIconBtn.Visible = true OpenIconBtn.Active = true
Instance.new("UICorner", OpenIconBtn).CornerRadius = UDim.new(0, 8) 
local OpenStroke = Instance.new("UIStroke", OpenIconBtn) OpenStroke.Color = Theme.Accent table.insert(DynamicUIElements, {Obj = OpenStroke, Prop = "Color", Type = "Accent"})
MakeDraggable(OpenIconBtn, OpenIconBtn)

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Name = "YuiMainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 380) MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190) MainFrame.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = MainFrame, Prop = "BackgroundColor3", Type = "MainBg"})
MainFrame.BorderSizePixel = 0 MainFrame.Active = true MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", MainFrame).Color = Theme.Stroke
MakeDraggable(MainFrame, MainFrame)

BindTap(OpenIconBtn, function() MainFrame.Visible = true OpenIconBtn.Visible = false end)

local Header = Instance.new("Frame", MainFrame) Header.Size = UDim2.new(1, -20, 0, 60) Header.Position = UDim2.new(0, 10, 0, 10) Header.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = Header, Prop = "BackgroundColor3", Type = "HeaderBg"})
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", Header).Color = Theme.Stroke
MakeDraggable(Header, MainFrame)

local BlueLine = Instance.new("Frame", Header) BlueLine.Size = UDim2.new(0, 3, 0, 30) BlueLine.Position = UDim2.new(0, 15, 0, 15) BlueLine.BackgroundColor3 = Theme.Accent Instance.new("UICorner", BlueLine).CornerRadius = UDim.new(1, 0) table.insert(DynamicUIElements, {Obj = BlueLine, Prop = "BackgroundColor3", Type = "Accent"})
local WelcomeText = Instance.new("TextLabel", Header) WelcomeText.Size = UDim2.new(0, 150, 0, 15) WelcomeText.Position = UDim2.new(0, 25, 0, 15) WelcomeText.BackgroundTransparency = 1 WelcomeText.Text = "Ultimate Script Hub" WelcomeText.TextColor3 = Theme.TextSub WelcomeText.Font = Enum.Font.Gotham WelcomeText.TextSize = 10 WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
local HubName = Instance.new("TextLabel", Header) HubName.Size = UDim2.new(0, 200, 0, 25) HubName.Position = UDim2.new(0, 25, 0, 25) HubName.BackgroundTransparency = 1 HubName.Text = "Yui HUB V26" HubName.TextColor3 = Theme.Accent HubName.Font = Enum.Font.GothamBold HubName.TextSize = 20 HubName.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = HubName, Prop = "TextColor3", Type = "Accent"})

local MinBtn = Instance.new("TextButton", Header) MinBtn.Size = UDim2.new(0, 30, 0, 30) MinBtn.Position = UDim2.new(1, -65, 0, 15) MinBtn.BackgroundTransparency = 1 MinBtn.Text = "—" MinBtn.TextColor3 = Theme.TextTitle MinBtn.Font = Enum.Font.GothamBold MinBtn.TextSize = 14 table.insert(DynamicUIElements, {Obj = MinBtn, Prop = "TextColor3", Type = "Text"})
BindTap(MinBtn, function() MainFrame.Visible = false OpenIconBtn.Visible = true for _, dd in ipairs(AllDropdowns) do dd.Visible = false end end)

local CloseBtn = Instance.new("TextButton", Header) CloseBtn.Size = UDim2.new(0, 30, 0, 30) CloseBtn.Position = UDim2.new(1, -35, 0, 15) CloseBtn.BackgroundTransparency = 1 CloseBtn.Text = "✕" CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80) CloseBtn.Font = Enum.Font.GothamBold CloseBtn.TextSize = 14
BindTap(CloseBtn, function() ScreenGui:Destroy() NotifGui:Destroy() GunDotGui:Destroy() ESPFolder:Destroy() ItemESPFolder:Destroy() for _, line in pairs(ESPTracers) do if line then line.Visible = false line:Remove() end end ESPTracers = {} end)

local Sidebar = Instance.new("ScrollingFrame", MainFrame) Sidebar.Size = UDim2.new(0, 130, 1, -85) Sidebar.Position = UDim2.new(0, 10, 0, 75) Sidebar.BackgroundTransparency = 1 Sidebar.ScrollBarThickness = 0 local SidebarLayout = Instance.new("UIListLayout", Sidebar) SidebarLayout.Padding = UDim.new(0, 5)
local ContentArea = Instance.new("Frame", MainFrame) ContentArea.Size = UDim2.new(1, -155, 1, -85) ContentArea.Position = UDim2.new(0, 145, 0, 75) ContentArea.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name, isActive)
    local TabBtn = Instance.new("TextButton", Sidebar) TabBtn.Size = UDim2.new(1, 0, 0, 30) TabBtn.BackgroundColor3 = isActive and Theme.BoxBg or Theme.MainBg TabBtn.Text = "  " .. name TabBtn.TextColor3 = isActive and Theme.TextTitle or Theme.TextSub TabBtn.Font = Enum.Font.GothamBold TabBtn.TextSize = 11 TabBtn.TextXAlignment = Enum.TextXAlignment.Left Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    table.insert(DynamicUIElements, {Obj = TabBtn, Prop = "BackgroundColor3", Type = isActive and "BoxBg" or "MainBg"})
    table.insert(DynamicUIElements, {Obj = TabBtn, Prop = "TextColor3", Type = "Text"})
    
    local ActiveLine = Instance.new("Frame", TabBtn) ActiveLine.Size = UDim2.new(0, 3, 0.6, 0) ActiveLine.Position = UDim2.new(0, 0, 0.2, 0) ActiveLine.BackgroundColor3 = Theme.Accent ActiveLine.Visible = isActive Instance.new("UICorner", ActiveLine).CornerRadius = UDim.new(1, 0) table.insert(DynamicUIElements, {Obj = ActiveLine, Prop = "BackgroundColor3", Type = "Accent"})

    local Page = Instance.new("Frame", ContentArea) Page.Size = UDim2.new(1, 0, 1, 0) Page.BackgroundTransparency = 1 Page.Visible = isActive
    local LeftCol = Instance.new("ScrollingFrame", Page) LeftCol.Size = UDim2.new(0.49, 0, 1, 0) LeftCol.BackgroundTransparency = 1 LeftCol.ScrollBarThickness = 2 local LeftLayout = Instance.new("UIListLayout", LeftCol) LeftLayout.Padding = UDim.new(0, 8)
    local RightCol = Instance.new("ScrollingFrame", Page) RightCol.Size = UDim2.new(0.49, 0, 1, 0) RightCol.Position = UDim2.new(0.51, 0, 0, 0) RightCol.BackgroundTransparency = 1 RightCol.ScrollBarThickness = 2 local RightLayout = Instance.new("UIListLayout", RightCol) RightLayout.Padding = UDim.new(0, 8)

    LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() LeftCol.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10) end)
    RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() RightCol.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10) end)

    table.insert(Tabs, {Btn = TabBtn, Line = ActiveLine, Page = Page})
    BindTap(TabBtn, function()
        for _, tab in pairs(Tabs) do tab.Btn.BackgroundColor3 = Theme.MainBg tab.Line.Visible = false tab.Page.Visible = false end
        TabBtn.BackgroundColor3 = Theme.BoxBg ActiveLine.Visible = true Page.Visible = true
        for _, dd in ipairs(AllDropdowns) do dd.Visible = false end
    end)
    Sidebar.CanvasSize = UDim2.new(0,0,0, SidebarLayout.AbsoluteContentSize.Y + 10)
    return LeftCol, RightCol
end

local function CreateSection(titleText, parentCol)
    local Box = Instance.new("Frame", parentCol) Box.BackgroundColor3 = Theme.BoxBg Box.Size = UDim2.new(1, 0, 0, 50) Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", Box).Color = Theme.Stroke table.insert(DynamicUIElements, {Obj = Box, Prop = "BackgroundColor3", Type = "BoxBg"})
    local Title = Instance.new("TextLabel", Box) Title.Size = UDim2.new(1, -20, 0, 20) Title.Position = UDim2.new(0, 10, 0, 5) Title.BackgroundTransparency = 1 Title.Text = titleText Title.TextColor3 = Theme.Accent Title.Font = Enum.Font.GothamBold Title.TextSize = 10 Title.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Title, Prop = "TextColor3", Type = "Accent"})
    local Container = Instance.new("Frame", Box) Container.Size = UDim2.new(1, -20, 1, -30) Container.Position = UDim2.new(0, 10, 0, 25) Container.BackgroundTransparency = 1 local Layout = Instance.new("UIListLayout", Container) Layout.Padding = UDim.new(0, 6)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Box.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 35) end)
    return Container
end

local function CreateToggle(labelText, default, parentBox, callback)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 26) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(1, -40, 1, 0) Label.BackgroundTransparency = 1 Label.Text = labelText Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    local Bg = Instance.new("TextButton", Frame) Bg.Size = UDim2.new(0, 32, 0, 16) Bg.Position = UDim2.new(1, -32, 0.5, -8) Bg.BackgroundColor3 = default and Theme.Accent or Theme.MainBg Bg.Text = "" Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0) Instance.new("UIStroke", Bg).Color = Theme.Stroke table.insert(DynamicUIElements, {Obj = Bg, Prop = "BackgroundColor3", IsToggle = true})
    local Knob = Instance.new("Frame", Bg) Knob.Size = UDim2.new(0, 12, 0, 12) Knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local isOn = default
    BindTap(Bg, function()
        isOn = not isOn TweenService:Create(Knob, TweenInfo.new(0.2), {Position = isOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and Theme.Accent or Theme.MainBg}):Play() 
        callback(isOn)
        SendNotification((isOn and "Enabled: " or "Disabled: ") .. labelText, isOn and Theme.SelectedGreen or Color3.fromRGB(255, 100, 100), labelText.."_Toggle")
    end)
    return function(state) isOn = state Knob.Position = isOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) Bg.BackgroundColor3 = isOn and Theme.Accent or Theme.MainBg callback(isOn) end
end

local function CreateSlider(labelText, min, max, default, parentBox, callback, allowFloat)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 35) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(1, 0, 0, 15) Label.BackgroundTransparency = 1 Label.Text = labelText Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    local ValLabel = Instance.new("TextLabel", Frame) ValLabel.Size = UDim2.new(1, 0, 0, 15) ValLabel.BackgroundTransparency = 1 ValLabel.Text = tostring(default) ValLabel.TextColor3 = Theme.TextSub ValLabel.Font = Enum.Font.Gotham ValLabel.TextSize = 10 ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    local Track = Instance.new("Frame", Frame) Track.Size = UDim2.new(1, 0, 0, 4) Track.Position = UDim2.new(0, 0, 0, 22) Track.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = Track, Prop = "BackgroundColor3", Type = "MainBg"}) Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0) Instance.new("UIStroke", Track).Color = Theme.Stroke
    local Fill = Instance.new("Frame", Track) Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0) Fill.BackgroundColor3 = Theme.Accent Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0) table.insert(DynamicUIElements, {Obj = Fill, Prop = "BackgroundColor3", Type = "Accent"})
    local Knob = Instance.new("TextButton", Fill) Knob.Size = UDim2.new(0, 10, 0, 10) Knob.Position = UDim2.new(1, -5, 0.5, -5) Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Knob.Text = "" Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local drag = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1) Fill.Size = UDim2.new(rel, 0, 1, 0) 
        local val = min + (max - min) * rel if not allowFloat then val = math.floor(val) else val = math.floor(val * 100) / 100 end
        ValLabel.Text = tostring(val) callback(val)
    end
    Knob.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    Track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true update(inp) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(inp) if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp) end end)
    return function(val) val = math.clamp(val, min, max) Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0) ValLabel.Text = tostring(val) callback(val) end
end

local function CreateThickColorPicker(labelText, defaultHue, parentBox, callback)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 45) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(1, 0, 0, 15) Label.BackgroundTransparency = 1 Label.Text = labelText Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    
    local Track = Instance.new("Frame", Frame) Track.Size = UDim2.new(1, 0, 0, 16) Track.Position = UDim2.new(0, 0, 0, 22) Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Track).Color = Theme.Stroke
    local UIGradient = Instance.new("UIGradient", Track)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    
    local Knob = Instance.new("TextButton", Track) Knob.Size = UDim2.new(0, 16, 0, 20) Knob.Position = UDim2.new(defaultHue/360, -8, 0.5, -10) Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Knob.Text = "" Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Knob).Color = Color3.fromRGB(0,0,0)

    local drag = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(rel, -8, 0.5, -10) callback(math.floor(rel * 360))
    end
    Knob.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    Track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true update(inp) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(inp) if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp) end end)
end

local function CreateButton(text, parentBox, callback)
    local Btn = Instance.new("TextButton", parentBox) Btn.Size = UDim2.new(1, 0, 0, 24) Btn.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = Btn, Prop = "BackgroundColor3", Type = "MainBg"}) Btn.TextColor3 = Theme.TextTitle Btn.Font = Enum.Font.GothamBold Btn.TextSize = 10 Btn.Text = text Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Btn).Color = Theme.Stroke table.insert(DynamicUIElements, {Obj = Btn, Prop = "TextColor3", Type = "Text"})
    BindTap(Btn, callback) return Btn
end

local function CreateTextBox(placeholder, parentBox, defaultText, callback)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 24) Frame.BackgroundTransparency = 1
    local Box = Instance.new("TextBox", Frame) Box.Size = UDim2.new(1, 0, 1, 0) Box.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = Box, Prop = "BackgroundColor3", Type = "MainBg"}) Box.TextColor3 = Theme.TextTitle Box.Font = Enum.Font.Gotham Box.TextSize = 10 Box.PlaceholderText = placeholder Box.Text = defaultText or "" Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Box).Color = Theme.Stroke
    Box.FocusLost:Connect(function() callback(Box.Text) end) return function(str) Box.Text = str end
end

local function CreateDropdown(labelStr, defaultStr, parentBox, callback)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 26) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(0.4, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Text = labelStr Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 9 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    local Btn = Instance.new("TextButton", Frame) Btn.Size = UDim2.new(0.6, 0, 1, 0) Btn.Position = UDim2.new(0.4, 0, 0, 0) Btn.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = Btn, Prop = "BackgroundColor3", Type = "MainBg"}) Btn.TextColor3 = Theme.TextSub Btn.Font = Enum.Font.Gotham Btn.TextSize = 9 Btn.Text = defaultStr .. " ▼" Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Btn).Color = Theme.Stroke
    
    local FloatFrame = Instance.new("ScrollingFrame", ScreenGui) FloatFrame.Size = UDim2.new(0, 160, 0, 130) FloatFrame.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = FloatFrame, Prop = "BackgroundColor3", Type = "HeaderBg"}) FloatFrame.ZIndex = 999 FloatFrame.Visible = false FloatFrame.ScrollBarThickness = 2 Instance.new("UICorner", FloatFrame).CornerRadius = UDim.new(0, 4) 
    local Stroke = Instance.new("UIStroke", FloatFrame) Stroke.Color = Theme.Accent table.insert(DynamicUIElements, {Obj = Stroke, Prop = "Color", Type = "Accent"})
    local listLayout = Instance.new("UIListLayout", FloatFrame) table.insert(AllDropdowns, FloatFrame)
    RunService.RenderStepped:Connect(function() if FloatFrame.Visible then FloatFrame.Position = UDim2.new(0, Btn.AbsolutePosition.X - (160 - Btn.AbsoluteSize.X), 0, Btn.AbsolutePosition.Y + Btn.AbsoluteSize.Y + 2) end end)

    local isOpen = false
    BindTap(Btn, function() for _, dd in ipairs(AllDropdowns) do if dd~=FloatFrame then dd.Visible = false end end isOpen = not isOpen FloatFrame.Visible = isOpen end)

    local SearchBox = Instance.new("TextBox", FloatFrame) SearchBox.Size = UDim2.new(1, -10, 0, 25) SearchBox.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = SearchBox, Prop = "BackgroundColor3", Type = "MainBg"}) SearchBox.TextColor3 = Theme.TextTitle SearchBox.PlaceholderText = "Search..." SearchBox.Text = "" SearchBox.Font = Enum.Font.Gotham SearchBox.TextSize = 10 Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text) for _, v in pairs(FloatFrame:GetChildren()) do if v:IsA("TextButton") then if q == "" or string.find(string.lower(v.Text), q) then v.Visible = true else v.Visible = false end end end
    end)

    local function populate(itemList)
        for _, v in pairs(FloatFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local h = 30
        for _, item in ipairs(itemList) do
            local b = Instance.new("TextButton", FloatFrame) b.Size = UDim2.new(1, 0, 0, 25) b.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = b, Prop = "BackgroundColor3", Type = "HeaderBg"}) b.TextColor3 = Theme.TextTitle b.Text = "  " .. item b.Font = Enum.Font.Gotham b.TextSize = 9 b.TextXAlignment = Enum.TextXAlignment.Left b.ZIndex = 1000
            table.insert(DynamicUIElements, {Obj = b, Prop = "TextColor3", Type = "Text"})
            h = h + 25 BindTap(b, function() Btn.Text = item .. " ▼" isOpen = false FloatFrame.Visible = false callback(item) end)
        end
        FloatFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
    local function setText(str) Btn.Text = str .. " ▼" end return populate, setText
end

local function CreateMultiDropdown(labelStr, parentBox, globalList)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 26) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(0.4, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Text = labelStr Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 9 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    local Btn = Instance.new("TextButton", Frame) Btn.Size = UDim2.new(0.6, 0, 1, 0) Btn.Position = UDim2.new(0.4, 0, 0, 0) Btn.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = Btn, Prop = "BackgroundColor3", Type = "MainBg"}) Btn.TextColor3 = Theme.TextSub Btn.Font = Enum.Font.Gotham Btn.TextSize = 9 Btn.Text = "Select Multi ▼" Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Btn).Color = Theme.Stroke
    
    local FloatFrame = Instance.new("ScrollingFrame", ScreenGui) FloatFrame.Size = UDim2.new(0, 160, 0, 150) FloatFrame.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = FloatFrame, Prop = "BackgroundColor3", Type = "HeaderBg"}) FloatFrame.ZIndex = 999 FloatFrame.Visible = false FloatFrame.ScrollBarThickness = 2 Instance.new("UICorner", FloatFrame).CornerRadius = UDim.new(0, 4) 
    local Stroke = Instance.new("UIStroke", FloatFrame) Stroke.Color = Theme.Accent table.insert(DynamicUIElements, {Obj = Stroke, Prop = "Color", Type = "Accent"})
    local listLayout = Instance.new("UIListLayout", FloatFrame) table.insert(AllDropdowns, FloatFrame)
    RunService.RenderStepped:Connect(function() if FloatFrame.Visible then FloatFrame.Position = UDim2.new(0, Btn.AbsolutePosition.X - (160 - Btn.AbsoluteSize.X), 0, Btn.AbsolutePosition.Y + Btn.AbsoluteSize.Y + 2) end end)

    local isOpen = false
    BindTap(Btn, function() for _, dd in ipairs(AllDropdowns) do if dd~=FloatFrame then dd.Visible = false end end isOpen = not isOpen FloatFrame.Visible = isOpen end)

    local SearchBox = Instance.new("TextBox", FloatFrame) SearchBox.Size = UDim2.new(1, -10, 0, 25) SearchBox.BackgroundColor3 = Theme.MainBg table.insert(DynamicUIElements, {Obj = SearchBox, Prop = "BackgroundColor3", Type = "MainBg"}) SearchBox.TextColor3 = Theme.TextTitle SearchBox.PlaceholderText = "Search..." SearchBox.Text = "" SearchBox.Font = Enum.Font.Gotham SearchBox.TextSize = 10 Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text) for _, v in pairs(FloatFrame:GetChildren()) do if v:IsA("TextButton") then if q == "" or string.find(string.lower(v.Text), q) then v.Visible = true else v.Visible = false end end end
    end)

    local function populate(itemList)
        for _, v in pairs(FloatFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local h = 30
        for _, item in ipairs(itemList) do
            local isSelected = globalList[item]
            local b = Instance.new("TextButton", FloatFrame) b.Size = UDim2.new(1, 0, 0, 25) b.BackgroundColor3 = Theme.HeaderBg table.insert(DynamicUIElements, {Obj = b, Prop = "BackgroundColor3", Type = "HeaderBg"})
            b.TextColor3 = isSelected and Theme.SelectedGreen or Theme.TextTitle 
            b.Text = "  " .. item b.Font = Enum.Font.GothamBold b.TextSize = 9 b.TextXAlignment = Enum.TextXAlignment.Left b.ZIndex = 1000
            h = h + 25 BindTap(b, function() globalList[item] = not globalList[item] b.TextColor3 = globalList[item] and Theme.SelectedGreen or Theme.TextTitle end)
        end
        FloatFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end
    return populate
end

local function GetButtonText(btn)
    local txt = btn.Text or ""
    for _, child in pairs(btn:GetChildren()) do
        if child:IsA("TextLabel") and child.Text ~= "" then txt = txt .. " " .. child.Text end
    end
    return string.lower(txt)
end

local function SilentClick(btn)
    if not btn then return end
    pcall(function() firesignal(btn.MouseButton1Click) end) pcall(function() firesignal(btn.Activated) end) pcall(function() for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end end)
end

local function FireNPC(npcName, teleport)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == npcName and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            if teleport then MoveTo(obj.HumanoidRootPart.CFrame * CFrame.new(0,0,3)) task.wait(0.3) end
            local cd = obj.HumanoidRootPart:FindFirstChildOfClass("ClickDetector")
            if cd then fireclickdetector(cd, 0) return true end
        end
    end
    return false
end

-- ============================
-- MENU TABS & SECTIONS
-- ============================
local MainL, MainR = CreateTab("Main Farm", true)
local QuestL, QuestR = CreateTab("Quests & Sam", false)
local FruitL, FruitR = CreateTab("Fruits & Spawns", false)
local SkillL, SkillR = CreateTab("Skills & Haki", false)
local ResL, ResR = CreateTab("Resources", false)
local PlayerL, PlayerR = CreateTab("Player", false)
local BountyL, BountyR = CreateTab("Bounty & PvP", false)
local FishL, FishR = CreateTab("Fish & Teleport", false)
local ServerL, ServerR = CreateTab("Server & FPS", false)
local SetL, SetR = CreateTab("Settings", false)

local Setters = {}

-- MAIN FARM
local FarmSetBox = CreateSection("Farming Mechanics", MainL)
local UpdateMoveDrop, SetMoveDrop = CreateDropdown("Move Method", _G.Yui.MoveMethod, FarmSetBox, function(v) _G.Yui.MoveMethod = v end)
UpdateMoveDrop({"Teleport", "Fly (Tween)"})
Setters.MoveSpeed = CreateSlider("Move Speed", 50, 5000, _G.Yui.MoveSpeed, FarmSetBox, function(v) _G.Yui.MoveSpeed = v end)
Setters.HoverOnKill = CreateToggle("Hover In Air On Kill", _G.Yui.HoverOnKill, FarmSetBox, function(v) _G.Yui.HoverOnKill = v end)

local FarmMobBox = CreateSection("Farming Mobs", MainR)
local UpdateLvlFilter, SetLvlFilter = CreateDropdown("Level Filter", "All", FarmMobBox, function(v) _G.Yui.MobLevelFilter = v end)
UpdateLvlFilter({"All", "< 1000", "> 1000"})
Setters.FarmNear = CreateToggle("Farm Near (Tất cả quái thỏa Lv)", false, FarmMobBox, function(v) _G.Yui.FarmNear = v end)

Setters.AutoSpawn = CreateToggle("Auto Spawn (Fix Anti-Death)", false, FarmMobBox, function(v) _G.Yui.AutoSpawn = v end)
local UpdateMultiMob = CreateMultiDropdown("Select Mobs", FarmMobBox, _G.Yui.SelectedMobs)
CreateButton("Refresh All Mobs & Bosses", FarmMobBox, function()
    local temp, list = {}, {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
                local rawNameL = string.lower(obj.Name)
                if string.find(rawNameL, "lv") or string.find(rawNameL, "level") then
                    local cleanName = string.gsub(obj.Name, "%[.-%]", "") cleanName = string.gsub(cleanName, "%d+$", "") cleanName = string.match(cleanName, "^%s*(.-)%s*$") or cleanName
                    if cleanName ~= "" and obj.Parent and not string.find(string.lower(obj.Parent.Name), "quest") then
                        if not temp[cleanName] then temp[cleanName] = true table.insert(list, cleanName) end
                    end
                end
            end
        end
    end
    table.sort(list) UpdateMultiMob(list)
    SendNotification("Refreshed Mobs List", Theme.Accent, "System")
end)
Setters.AutoFarm = CreateToggle("Auto Farm Mobs", false, FarmMobBox, function(v) _G.Yui.AutoFarm = v end)

local AtkBox = CreateSection("Attack Setting", MainL)
local UpdateWepDrop = CreateMultiDropdown("Select Weapons", AtkBox, _G.Yui.SelectedWeapons)
CreateButton("Refresh Weapons", AtkBox, function()
    local t = {} 
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(t, v.Name) end end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then table.insert(t, v.Name) end end
    UpdateWepDrop(t)
    SendNotification("Refreshed Weapons List", Theme.Accent, "System")
end)
Setters.FastAttack = CreateToggle("Auto Fast Attack (Silent)", false, AtkBox, function(v) _G.Yui.FastAttack = v end)
local UpdateClickPos, SetClickPos = CreateDropdown("Click Position", "Center", AtkBox, function(v) _G.Yui.ClickPosition = v end)
UpdateClickPos({"Center", "Edge", "Off-Screen"})
Setters.AutoClickFarming = CreateToggle("Auto Click (Khi Bật Farm)", false, AtkBox, function(v) _G.Yui.AutoClickFarming = v end)
Setters.AutoClickAlways = CreateToggle("Auto Click (Luôn Luôn)", false, AtkBox, function(v) _G.Yui.AutoClickAlways = v end)
Setters.AutoGunFarm = CreateToggle("Gun Farm (Aimbot Camera)", false, AtkBox, function(v) _G.Yui.AutoGunFarm = v GunDot.Visible = v end)

local ConfigBox = CreateSection("Position & Safe", MainR)
local UpdatePosDropdown, SetPosDrop = CreateDropdown("Position", "Above", ConfigBox, function(v) _G.Yui.AttackPos = v end)
UpdatePosDropdown({"Above", "Below", "Behind", "Front"})
Setters.AttackDist = CreateSlider("Melee Distance", 1, 25, 5, ConfigBox, function(v) _G.Yui.AttackDist = v end)
Setters.GunAttackDist = CreateSlider("Gun Distance", 5, 100, 25, ConfigBox, function(v) _G.Yui.GunAttackDist = v end)
Setters.AutoSafe = CreateToggle("Auto Safe (Fly up if low HP)", false, ConfigBox, function(v) _G.Yui.AutoSafe = v end)
Setters.SafeHealth = CreateSlider("Safe HP %", 10, 90, 30, ConfigBox, function(v) _G.Yui.SafeHealth = v end)

-- QUEST & SAM
local QuestBox = CreateSection("Normal Quest", QuestL)
Setters.AutoNormalQuest = CreateToggle("Auto Normal Quest (Silent)", false, QuestBox, function(v) _G.Yui.AutoNormalQuest = v end)
local UpdateNormalDrop, SetNormalDrop = CreateDropdown("Target NPC", "None", QuestBox, function(v) _G.Yui.SelectedNormalQuest = v end)
CreateButton("Teleport to Normal NPC", QuestBox, function() if _G.Yui.SelectedNormalQuest ~= "" then FireNPC(_G.Yui.SelectedNormalQuest, true) end end)

local DailyBox = CreateSection("Daily Quest", QuestR)
Setters.AutoDailyQuest = CreateToggle("Auto Daily Quest (Silent)", false, DailyBox, function(v) _G.Yui.AutoDailyQuest = v end)
local UpdateDailyDrop, SetDailyDrop = CreateDropdown("Target Daily NPC", "None", DailyBox, function(v) _G.Yui.SelectedDailyQuest = v end)
CreateButton("Teleport to Daily NPC", DailyBox, function() if _G.Yui.SelectedDailyQuest ~= "" then FireNPC(_G.Yui.SelectedDailyQuest, true) end end)

Setters.TeleportToNPC = CreateToggle("Teleport & Wait for NPC [ON]", true, QuestL, function(v) _G.Yui.TeleportToNPC = v end)
Setters.AutoAcceptQuest = CreateToggle("Auto Accept Any Quest GUI", false, QuestL, function(v) _G.Yui.AutoAcceptQuest = v end)

CreateButton("Refresh All Quests", QuestL, function() 
    local nList, dList, tempN, tempD = {}, {}, {}, {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local pN, oN = string.lower(obj.Parent and obj.Parent.Name or ""), string.lower(obj.Name)
            if string.find(pN, "daily") or string.find(oN, "daily") then
                if not tempD[obj.Name] then tempD[obj.Name] = true table.insert(dList, obj.Name) end
            elseif string.find(pN, "quest") or string.find(oN, "quest") then
                if not tempN[obj.Name] then tempN[obj.Name] = true table.insert(nList, obj.Name) end
            end
        end
    end
    table.sort(nList) table.sort(dList) UpdateNormalDrop(nList) UpdateDailyDrop(dList)
    SendNotification("Refreshed Quests List", Theme.Accent, "System")
end)

local SamBox = CreateSection("Sam NPC (Compass/Box)", QuestR)
Setters.AutoSam = CreateToggle("Auto Buy Compass (Sam)", false, SamBox, function(v) _G.Yui.AutoSam = v end)
Setters.AutoSamInf = CreateToggle("Auto Buy Sam (Infinite)", false, SamBox, function(v) _G.Yui.AutoSamInf = v end)
local UpdateSamAmount, SetSamAmount = CreateDropdown("Amount", "x1", SamBox, function(v) _G.Yui.AutoSamAmount = v end)
UpdateSamAmount({"x1", "x10"})
Setters.SamLoopCount = CreateSlider("Buy Loop Count", 1, 100, 1, SamBox, function(v) _G.Yui.SamLoopCount = v end)
Setters.AutoFindBox = CreateToggle("Auto Find Box (Compass)", false, SamBox, function(v) _G.Yui.AutoFindBox = v end)
Setters.FindBoxDelay = CreateSlider("Find Box Tele Delay (s)", 0.1, 2, 0.3, SamBox, function(v) _G.Yui.FindBoxDelay = v end, true)
Setters.AutoUpgradeCap = CreateToggle("Auto Upgrade Capacity", false, SamBox, function(v) _G.Yui.AutoUpgradeCap = v end)

-- ESP & TELEPORT ITEMS
local ScannedItems = {}
local ScannerBox = CreateSection("Map Items Scanner & ESP", FruitL)
Setters.ESPItems = CreateToggle("ESP Selected Items", false, ScannerBox, function(v) _G.Yui.ESPItems = v end)
local UpdateESPItemsDrop = CreateMultiDropdown("Select ESP Items", ScannerBox, _G.Yui.SelectedESPItems)

CreateButton("Refresh ESP Items List", ScannerBox, function()
    local list = {}
    local seen = {}
    for _, itemData in ipairs(ScannedItems) do
        if not seen[itemData.Name] then
            seen[itemData.Name] = true
            table.insert(list, itemData.Name)
        end
    end
    table.sort(list)
    UpdateESPItemsDrop(list)
    SendNotification("Refreshed Items ESP List", Theme.Accent, "System")
end)

local ItemTeleBox = CreateSection("Item Teleport", FruitL)
local UpdateItemTeleDrop, SetItemTeleDrop = CreateDropdown("Select Item to Teleport", "None", ItemTeleBox, function(v) _G.Yui.TargetItemTeleport = v end)
CreateButton("Teleport to Selected Item", ItemTeleBox, function()
    if _G.Yui.TargetItemTeleport and _G.Yui.TargetItemTeleport ~= "None" then
        for _, itemData in ipairs(ScannedItems) do
            if itemData.Name == _G.Yui.TargetItemTeleport and itemData.Part then
                MoveTo(itemData.Part.CFrame * CFrame.new(0, 2, 0)) break
            end
        end
    end
end)
CreateButton("Refresh Item Lists", ItemTeleBox, function()
    local teleList, seenTele = {}, {}
    for _, itemData in ipairs(ScannedItems) do
        local lName = string.lower(itemData.Name)
        if not (string.find(lName, "chest") or string.find(lName, "barrel") or string.find(lName, "crate")) then
            if not seenTele[itemData.Name] then seenTele[itemData.Name] = true table.insert(teleList, itemData.Name) end
        end
    end
    table.sort(teleList) UpdateItemTeleDrop(teleList)
    SendNotification("Refreshed Teleport Items List", Theme.Accent, "System")
end)

local TrackerContainer = Instance.new("Frame", ScannerBox)
TrackerContainer.Size = UDim2.new(1, 0, 0, 20)
TrackerContainer.BackgroundTransparency = 1
TrackerContainer.AutomaticSize = Enum.AutomaticSize.Y

local ItemTrackerLabel = Instance.new("TextLabel", TrackerContainer)
ItemTrackerLabel.Size = UDim2.new(1, -10, 1, 0) ItemTrackerLabel.Position = UDim2.new(0, 5, 0, 0) ItemTrackerLabel.BackgroundTransparency = 1 ItemTrackerLabel.TextColor3 = Theme.TextSub ItemTrackerLabel.TextXAlignment = Enum.TextXAlignment.Left ItemTrackerLabel.TextYAlignment = Enum.TextYAlignment.Top ItemTrackerLabel.Font = Enum.Font.Gotham ItemTrackerLabel.TextSize = 10 ItemTrackerLabel.TextWrapped = true ItemTrackerLabel.AutomaticSize = Enum.AutomaticSize.Y
ItemTrackerLabel.RichText = true 
ItemTrackerLabel.Text = "Scanning map for items..."

local FBox = CreateSection("Devil Fruits", FruitR)
Setters.AutoFruit = CreateToggle("Auto Collect Fruit", false, FBox, function(v) _G.Yui.AutoFruit = v end)
CreateButton("Drop All Fruits", FBox, function()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if string.find(string.lower(tool.Name), "fruit") then tool.Parent = LocalPlayer.Character task.wait(0.1) tool.Parent = workspace end
    end
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), "fruit") then tool.Parent = workspace end
    end
end)

local SBox = CreateSection("SpawnBoxes & Teleport", FruitR)
Setters.AutoSpawnBox = CreateToggle("Auto Collect SpawnBox", false, SBox, function(v) _G.Yui.AutoSpawnBox = v end)
local UpdateSpawnDrop, SetSpawnDrop = CreateDropdown("Select Spawn", "None", SBox, function(v)
    for _, box in pairs(workspace:GetDescendants()) do
        if box.Name == v and box:IsA("BasePart") then MoveTo(box.CFrame * CFrame.new(0, 3, 0)) break end
    end
end)
CreateButton("Refresh Spawns", SBox, function()
    local t = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        local pN = string.lower(obj.Parent and obj.Parent.Name or "")
        if (string.find(pN, "spawnbox") or string.find(pN, "spawns")) and obj:IsA("BasePart") then
            if not table.find(t, obj.Name) then table.insert(t, obj.Name) end
        end
    end
    table.sort(t) UpdateSpawnDrop(t)
    SendNotification("Refreshed Spawns List", Theme.Accent, "System")
end)

-- SKILLS & HAKI
local WepSkillBox = CreateSection("Normal Skills", SkillL)
Setters.SkillDelay = CreateSlider("Skill Delay (s)", 0, 5, 0.1, WepSkillBox, function(v) _G.Yui.SkillDelay = v end, true)
Setters.AutoAimSkillPlayer = CreateToggle("Aim Skill Nearest Player", false, WepSkillBox, function(v) _G.Yui.AutoAimSkillPlayer = v end)
for _, key in ipairs({"E", "R", "T", "Z", "X", "C", "V", "B", "N", "F"}) do
    Setters["Skill"..key] = CreateToggle("Auto Skill ["..key.."]", false, WepSkillBox, function(v) _G.Yui.AutoSkill[key] = v end) 
end

local HoldSkillBox = CreateSection("Hold Skills", SkillR)
Setters.HoldTime = CreateSlider("Hold Time (s)", 1, 5, 1, HoldSkillBox, function(v) _G.Yui.HoldTime = v end)
for _, key in ipairs({"E", "R", "T", "Z", "X", "C", "V", "B", "N", "F"}) do
    Setters["Hold"..key] = CreateToggle("Hold Skill ["..key.."]", false, HoldSkillBox, function(v) _G.Yui.HoldSkill[key] = v end) 
end

local HakiBox = CreateSection("Auto Haki", SkillL)
Setters.HakiE = CreateToggle("Armament Haki [E]", false, HakiBox, function(v) _G.Yui.AutoHaki.E = v end)
Setters.HakiR = CreateToggle("Observation Haki [R]", false, HakiBox, function(v) _G.Yui.AutoHaki.R = v end)
Setters.HakiT = CreateToggle("Conqueror Haki [T] (Spam)", false, HakiBox, function(v) _G.Yui.AutoHaki.T = v end)

-- RESOURCES
local SkyBaseBox = CreateSection("Collection Modes", ResL)
local UpdateColDrop, SetColDrop = CreateDropdown("Collect Method", _G.Yui.CollectMethod, SkyBaseBox, function(v) _G.Yui.CollectMethod = v end)
UpdateColDrop({"Teleport (Return)", "Teleport (Continuous)", "Fly"})
Setters.CamUnderground = CreateToggle("Hide Camera Underground", false, SkyBaseBox, function(v) _G.Yui.CamUnderground = v end)
Setters.CollectSpeed = CreateSlider("Sweep Delay (s)", 0.01, 1, 0.05, SkyBaseBox, function(v) _G.Yui.CollectSpeed = v end, true)

local CrateBox = CreateSection("Chest & Barrel Sweep", ResL)
Setters.CollectChest = CreateToggle("Auto Chests (Liên Tục)", false, CrateBox, function(v) _G.Yui.CollectChest = v end)
Setters.CollectBarrel = CreateToggle("Auto Barrels/Crates (Liên Tục)", false, CrateBox, function(v) _G.Yui.CollectBarrel = v end)
Setters.CollectCompass = CreateToggle("Auto Collect Compass", false, CrateBox, function(v) _G.Yui.CollectCompass = v end)

local JuiceBox = CreateSection("Juice & Drinks", ResR)
Setters.AutoJuice = CreateToggle("Auto Make Juice", false, JuiceBox, function(v) _G.Yui.AutoJuice = v end)
Setters.JuiceDelay = CreateSlider("Make Delay (s)", 1, 30, 5, JuiceBox, function(v) _G.Yui.JuiceDelay = v end)
Setters.AutoDrink = CreateToggle("Auto Drink All (Mass Consume)", false, JuiceBox, function(v) _G.Yui.AutoDrink = v end)
Setters.DrinkDelay = CreateSlider("Drink Delay (s)", 1, 10, 1, JuiceBox, function(v) _G.Yui.DrinkDelay = v end)

local AppleBox = CreateSection("Auto Golden Apple", ResR)
Setters.AutoEatApple = CreateToggle("Auto Eat All Apples (Mass)", false, AppleBox, function(v) _G.Yui.AutoEatApple = v end)
Setters.AppleDelay = CreateSlider("Eat Delay (s)", 1, 10, 3, AppleBox, function(v) _G.Yui.AppleDelay = v end)

-- PLAYER
local MoveBox = CreateSection("Movement", PlayerL)
local FlyBV, FlyBG = nil, nil
Setters.Fly = CreateToggle("Enable Fly", false, MoveBox, function(v)
    _G.Yui.Fly = v
    local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        if v then
            FlyBV = Instance.new("BodyVelocity") FlyBV.Name = "YuiFlyBV" FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5) FlyBV.Parent = root
            FlyBG = Instance.new("BodyGyro") FlyBG.Name = "YuiFlyBG" FlyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5) FlyBG.P = 1e4 FlyBG.Parent = root
        else
            if root:FindFirstChild("YuiFlyBV") then root.YuiFlyBV:Destroy() end
            if root:FindFirstChild("YuiFlyBG") then root.YuiFlyBG:Destroy() end
        end
    end
end)
Setters.FlySpeed = CreateSlider("Fly Speed", 10, 5000, 50, MoveBox, function(v) _G.Yui.FlySpeed = v end)
Setters.EnableWS = CreateToggle("WalkSpeed", false, MoveBox, function(v) _G.Yui.EnableWS = v end)
Setters.WalkSpeed = CreateSlider("Speed", 16, 5000, 100, MoveBox, function(v) _G.Yui.WalkSpeed = v end)
Setters.EnableJP = CreateToggle("JumpPower", false, MoveBox, function(v) _G.Yui.EnableJP = v end)
Setters.JumpPower = CreateSlider("Power", 50, 1000, 100, MoveBox, function(v) _G.Yui.JumpPower = v end)

local ExploitBox = CreateSection("Exploits", PlayerR)
Setters.InfJump = CreateToggle("Infinite Jump", false, ExploitBox, function(v) _G.Yui.InfJump = v end)
Setters.Noclip = CreateToggle("Noclip (Through walls)", false, ExploitBox, function(v) _G.Yui.Noclip = v end)
Setters.WalkOnWater = CreateToggle("Walk On Water", false, ExploitBox, function(v) _G.Yui.WalkOnWater = v end)

-- BOUNTY
local BountyBox = CreateSection("Player Tracker", BountyL)
local UpdatePlayerDrop, SetPlayerDrop = CreateDropdown("Target Player", "None", BountyBox, function(v) _G.Yui.TargetPlayer = v end)
CreateButton("Refresh Players", BountyBox, function()
    local t = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(t, p.Name) end end UpdatePlayerDrop(t)
    SendNotification("Refreshed Players", Theme.Accent, "System")
end)
CreateButton("Teleport to Target", BountyBox, function()
    if _G.Yui.TargetPlayer ~= "None" then
        local p = Players:FindFirstChild(_G.Yui.TargetPlayer)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then MoveTo(p.Character.HumanoidRootPart.CFrame) end
    end
end)
Setters.Spectate = CreateToggle("Spectate Target", false, BountyBox, function(v) 
    _G.Yui.Spectate = v if not v then workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid") end
end)

local HuntBox = CreateSection("Auto Hunt & ESP", BountyR)
Setters.AutoHunt = CreateToggle("Auto Hunt Target (Aimbot)", false, HuntBox, function(v) _G.Yui.AutoHunt = v end)
Setters.HuntDist = CreateSlider("Hunt Distance", 1, 25, 5, HuntBox, function(v) _G.Yui.HuntDist = v end)
Setters.ESPPlayer = CreateToggle("ESP Players (Tracer + Dist)", false, HuntBox, function(v) 
    _G.Yui.ESPPlayer = v 
    if not v then 
        ESPFolder:ClearAllChildren() 
        for _, line in pairs(ESPTracers) do if line then line.Visible = false line:Remove() end end 
        ESPTracers = {} 
    end
end)

-- FISH & TELEPORT
local FishBox = CreateSection("Fishing System", FishL)
Setters.AutoGetRod = CreateToggle("Auto Get Rod", false, FishBox, function(v) _G.Yui.AutoGetRod = v end)
Setters.AutoFish = CreateToggle("Auto Fish", false, FishBox, function(v) _G.Yui.AutoFish = v end)
Setters.AutoShake = CreateToggle("Auto Shake (Tự Giật Cá)", false, FishBox, function(v) _G.Yui.AutoShake = v end)

local TeleBox = CreateSection("Teleports", FishR)
local UpdateIsland1, SetIsland1 = CreateDropdown("Select Island", "None", TeleBox, function(v) if _G.Yui.iMap1 and _G.Yui.iMap1[v] then MoveTo(_G.Yui.iMap1[v]) end end)
local UpdateNPC1, SetNPC1 = CreateDropdown("Select Normal NPC", "None", TeleBox, function(v) if _G.Yui.nMap1 and _G.Yui.nMap1[v] then MoveTo(_G.Yui.nMap1[v] * CFrame.new(0,0,3)) end end)
local UpdateSpecialNPC, SetSpecialNPC = CreateDropdown("Special NPCs (Shop, Secret...)", "None", TeleBox, function(v) if _G.Yui.SpecialNPCMap and _G.Yui.SpecialNPCMap[v] then MoveTo(_G.Yui.SpecialNPCMap[v] * CFrame.new(0,0,3)) end end)

CreateButton("Scan Map & All NPCs", TeleBox, function()
    local tIsland, tNPC, sNPCs, iMap, nMap, sMap = {}, {}, {}, {}, {}, {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
            local nName = string.lower(obj.Name)
            if not string.find(nName, "lv") and not string.find(nName, "level") then
                if not nMap[obj.Name] then nMap[obj.Name] = obj.HumanoidRootPart.CFrame table.insert(tNPC, obj.Name) end
            end
        end
        if obj:IsA("Model") or obj:IsA("Folder") then
            local pName = string.lower(obj.Name)
            if string.find(pName, "island") or string.find(pName, "town") or string.find(pName, "location") then
                local spawnPart = obj:FindFirstChildWhichIsA("BasePart", true)
                if spawnPart and not iMap[obj.Name] then iMap[obj.Name] = spawnPart.CFrame * CFrame.new(0, 10, 0) table.insert(tIsland, obj.Name) end
            end
        end
        local p = obj.Parent
        if p and (string.lower(p.Name) == "shop" or string.lower(p.Name) == "secret" or string.lower(p.Name) == "information") and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local formatName = obj.Name .. " [" .. p.Name .. "]"
            if not sMap[formatName] then sMap[formatName] = obj.HumanoidRootPart.CFrame table.insert(sNPCs, formatName) end
        end
    end
    table.sort(tIsland) table.sort(tNPC) table.sort(sNPCs)
    _G.Yui.iMap1 = iMap _G.Yui.nMap1 = nMap _G.Yui.SpecialNPCMap = sMap
    UpdateIsland1(tIsland) UpdateNPC1(tNPC) UpdateSpecialNPC(sNPCs)
    SendNotification("Map Scanned!", Theme.SelectedGreen, "System")
end)

local PinBox = CreateSection("Location Pins", FishL)
Setters.AutoPin = CreateToggle("Pin Location", false, PinBox, function(v) 
    _G.Yui.AutoPin = v 
    if v and _G.SelectedSavedCFrame then _G.PinnedCFrame = _G.SelectedSavedCFrame elseif v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then _G.PinnedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
end)
CreateButton("Save New Location", PinBox, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        _G.SavedCount = _G.SavedCount + 1 local locName = "Loc_" .. _G.SavedCount _G.SavedLocations[locName] = char.HumanoidRootPart.CFrame
        local tList = {} for n, _ in pairs(_G.SavedLocations) do table.insert(tList, n) end UpdateSavedDrop(tList)
        SendNotification("Saved " .. locName, Theme.SelectedGreen, "System")
    end
end)
UpdateSavedDrop = CreateDropdown("Saved Locations", "None", PinBox, function(v) _G.SelectedSavedName = v _G.SelectedSavedCFrame = _G.SavedLocations[v] if _G.Yui.AutoPin then _G.PinnedCFrame = _G.SelectedSavedCFrame end end)
CreateButton("Teleport to Pin", PinBox, function() if _G.SelectedSavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then MoveTo(_G.SelectedSavedCFrame) end end)

-- SERVER & FPS
local ServerBox = CreateSection("Server Hopping", ServerL)
CreateButton("Hop Random Server", ServerBox, function()
    local req = (syn and syn.request) or request or http_request or (http and http.request)
    if req then
        local res = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(res)
        if data and data.data then local s = data.data[math.random(1, #data.data)] TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) end
    end
end)
CreateButton("Hop Low Player Server", ServerBox, function()
    local req = (syn and syn.request) or request or http_request or (http and http.request)
    if req then
        local res = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(res)
        if data and data.data then for _, v in ipairs(data.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer) break end end end
    end
end)
Setters.AutoHopServer = CreateToggle("Auto Hop Server", false, ServerBox, function(v) _G.Yui.AutoHop = v if Setters.AutoHopMain then Setters.AutoHopMain(v) end end)
Setters.HopDelay = CreateSlider("Delay Hop (Min 3s)", 3, 300, 10, ServerBox, function(v) _G.Yui.HopDelay = v end)

local OptBox = CreateSection("Optimization", ServerR)
CreateButton("Boost FPS", OptBox, function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
    end
    game:GetService("Lighting").GlobalShadows = false game:GetService("Lighting").FogEnd = 9e9
    SendNotification("Boosted FPS!", Theme.SelectedGreen, "System")
end)

-- SETTINGS & CONFIGS
local SysBox = CreateSection("System Core", SetL)
Setters.AntiAFK = CreateToggle("Anti AFK (No Kick)", _G.Yui.AntiAFK, SysBox, function(v) _G.Yui.AntiAFK = v end)
Setters.AutoRejoin = CreateToggle("Auto Rejoin", _G.Yui.AutoRejoin, SysBox, function(v) _G.Yui.AutoRejoin = v SaveCoreSettings() end)
Setters.AutoExecute = CreateToggle("Auto Execute on Rejoin", _G.Yui.AutoExecute, SysBox, function(v) _G.Yui.AutoExecute = v SaveCoreSettings() end)
CreateTextBox("Paste Loadstring URL Here", SysBox, _G.Yui.ExecuteScript, function(text) _G.Yui.ExecuteScript = text SaveCoreSettings() end)
CreateButton("Reset All Toggles", SysBox, function() for _, func in pairs(Setters) do pcall(function() func(false) end) end end)

local ThemeBox = CreateSection("Theme Customizer (To Bản)", SetL)
local function CreateThickColorPicker(labelText, defaultHue, parentBox, callback)
    local Frame = Instance.new("Frame", parentBox) Frame.Size = UDim2.new(1, 0, 0, 45) Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(1, 0, 0, 15) Label.BackgroundTransparency = 1 Label.Text = labelText Label.TextColor3 = Theme.TextTitle Label.Font = Enum.Font.GothamBold Label.TextSize = 10 Label.TextXAlignment = Enum.TextXAlignment.Left table.insert(DynamicUIElements, {Obj = Label, Prop = "TextColor3", Type = "Text"})
    local Track = Instance.new("Frame", Frame) Track.Size = UDim2.new(1, 0, 0, 16) Track.Position = UDim2.new(0, 0, 0, 22) Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Track).Color = Theme.Stroke
    local UIGradient = Instance.new("UIGradient", Track)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    local Knob = Instance.new("TextButton", Track) Knob.Size = UDim2.new(0, 16, 0, 20) Knob.Position = UDim2.new(defaultHue/360, -8, 0.5, -10) Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Knob.Text = "" Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 4) Instance.new("UIStroke", Knob).Color = Color3.fromRGB(0,0,0)

    local drag = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Knob.Position = UDim2.new(rel, -8, 0.5, -10) callback(math.floor(rel * 360))
    end
    Knob.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    Track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = true update(inp) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UserInputService.InputChanged:Connect(function(inp) if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp) end end)
end

CreateThickColorPicker("UI Accent Color Bar", _G.Yui.CustomHue, ThemeBox, function(hue) UpdateThemeColor(hue) end)
CreateThickColorPicker("Text Color Bar", _G.Yui.TextHue, ThemeBox, function(hue) UpdateTextColor(hue) end)
CreateThickColorPicker("Background Color Bar", _G.Yui.BgHue, ThemeBox, function(hue) UpdateBgColor(hue) end)
CreateButton("Save Theme Color", ThemeBox, function() SaveCoreSettings() SendNotification("Theme Saved!", Theme.SelectedGreen, "System") end)

local ConfigBox2 = CreateSection("Configurations", SetR)
local ConfigInput = CreateTextBox("Enter New Config Name", ConfigBox2, "", function(text) _G.Yui.ConfigName = text end)

local function GetConfigList()
    local list = {}
    if listfiles then for _, file in pairs(listfiles(ConfigFolder)) do table.insert(list, file:gsub(ConfigFolder.."\\", ""):gsub(ConfigFolder.."/", ""):gsub(".json", "")) end end
    local found = false for _, n in ipairs(list) do if n == _G.Yui.ConfigName then found = true break end end
    if not found and _G.Yui.ConfigName ~= "" then table.insert(list, _G.Yui.ConfigName) end
    return list
end

local UpdateConfigDrop, SetConfigDrop = CreateDropdown("Select Config", _G.Yui.ConfigName, ConfigBox2, function(v) _G.Yui.ConfigName = v SaveCoreSettings() end)

CreateButton("Create New Config", ConfigBox2, function()
    if _G.Yui.ConfigName ~= "" and writefile and HttpService then 
        writefile(ConfigFolder .. "/" .. _G.Yui.ConfigName .. ".json", HttpService:JSONEncode(_G.Yui)) 
        UpdateConfigDrop(GetConfigList()) SetConfigDrop(_G.Yui.ConfigName) SaveCoreSettings() ConfigInput("")
        SendNotification("Config Created: " .. _G.Yui.ConfigName, Theme.SelectedGreen, "Config")
    end
end)

CreateButton("Save / Overwrite Selected", ConfigBox2, function()
    if writefile and HttpService and _G.Yui.ConfigName ~= "" then 
        writefile(ConfigFolder .. "/" .. _G.Yui.ConfigName .. ".json", HttpService:JSONEncode(_G.Yui)) 
        UpdateConfigDrop(GetConfigList()) 
        SendNotification("Config Saved: " .. _G.Yui.ConfigName, Theme.SelectedGreen, "Config")
    end
end)
CreateButton("Load Selected Config", ConfigBox2, function()
    if readfile and isfile and isfile(ConfigFolder .. "/" .. _G.Yui.ConfigName .. ".json") then
        local data = HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. _G.Yui.ConfigName .. ".json"))
        if data then 
            for k, v in pairs(data) do _G.Yui[k] = v if Setters[k] then pcall(function() Setters[k](v) end) end end 
            SendNotification("Config Loaded: " .. _G.Yui.ConfigName, Theme.SelectedGreen, "Config")
        end
    end
end)

local AutoLoadStatus = Instance.new("TextLabel", ConfigBox2)
AutoLoadStatus.Size = UDim2.new(1, 0, 0, 15) AutoLoadStatus.BackgroundTransparency = 1
AutoLoadStatus.TextColor3 = Theme.SelectedGreen AutoLoadStatus.Font = Enum.Font.Gotham AutoLoadStatus.TextSize = 10 table.insert(DynamicUIElements, {Obj = AutoLoadStatus, Prop = "TextColor3", Type = "Text"})
AutoLoadStatus.Text = _G.Yui.AutoLoadConfig and ("Auto Loading: " .. _G.Yui.AutoLoadName) or "Auto Load: OFF"

CreateButton("Set as Auto Load", ConfigBox2, function()
    _G.Yui.AutoLoadConfig = true _G.Yui.AutoLoadName = _G.Yui.ConfigName AutoLoadStatus.Text = "Auto Loading: " .. _G.Yui.AutoLoadName SaveCoreSettings()
    SendNotification("Set AutoLoad: " .. _G.Yui.AutoLoadName, Theme.SelectedGreen, "Config")
end)
CreateButton("Remove Auto Load", ConfigBox2, function()
    _G.Yui.AutoLoadConfig = false _G.Yui.AutoLoadName = "" AutoLoadStatus.Text = "Auto Load: OFF" SaveCoreSettings()
    SendNotification("AutoLoad Removed", Theme.Accent, "Config")
end)

-- =========================================================================
-- ITEM SCANNER & ESP THREAD (THÊM TOKEN)
-- =========================================================================
local BlacklistModels = {"spawnbox", "fruitreceptical", "safeboxwall", "threedtextboundingbox", "science textbook"}

local function IsBlacklisted(itemName)
    local lName = string.lower(itemName)
    for _, b in ipairs(BlacklistModels) do
        if string.find(lName, b) then return true end
    end
    return false
end

task.spawn(function()
    while task.wait(1.5) do
        local counts = {}
        local tempItems = {}

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart") then
                local n = string.lower(obj.Name)
                if not IsBlacklisted(n) and (string.find(n, "fruit") or string.find(n, "box") or string.find(n, "book") or string.find(n, "compass") or string.find(n, "chest") or string.find(n, "barrel") or string.find(n, "crate") or string.find(n, "scroll") or string.find(n, "token") or string.find(n, "reset")) then
                    
                    local isChar = false
                    if obj.Parent and obj.Parent:FindFirstChild("Humanoid") then isChar = true end
                    if obj:FindFirstChild("Humanoid") then isChar = true end
                    
                    if not isChar then
                        local posPart = obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
                        if posPart and not Players:GetPlayerFromCharacter(obj.Parent) then
                            local rawName = obj.Name
                            counts[rawName] = (counts[rawName] or 0) + 1
                            table.insert(tempItems, {Obj = obj, Part = posPart, Name = rawName})
                        end
                    end
                end
            end
        end

        ScannedItems = tempItems

        local f_str, b_str, c_str, o_str = "", "", "", ""
        for name, amt in pairs(counts) do
            local ln = string.lower(name)
            if string.find(ln, "fruit") then f_str = f_str .. "• " .. name .. " x" .. amt .. "\n"
            elseif string.find(ln, "box") then b_str = b_str .. "• " .. name .. " x" .. amt .. "\n"
            elseif string.find(ln, "chest") or string.find(ln, "barrel") or string.find(ln, "crate") then
                c_str = c_str .. "• " .. name .. " x" .. amt .. "\n"
            else o_str = o_str .. "• " .. name .. " x" .. amt .. "\n" end
        end

        local text = "<font color='rgb(255, 200, 50)'><b>[ FRUITS ]</b></font>\n"
        text = text .. (f_str ~= "" and f_str or "\n")
        
        text = text .. "<font color='rgb(50, 255, 100)'><b>[ BOXES ]</b></font>\n"
        text = text .. (b_str ~= "" and b_str or "\n")
        
        text = text .. "<font size='12' color='rgb(255, 100, 100)'><b>[ CHESTS & BARRELS ]</b></font>\n"
        text = text .. (c_str ~= "" and c_str or "\n")
        
        text = text .. "<font color='rgb(200, 200, 255)'><b>[ OTHERS (Tokens/Compass...) ]</b></font>\n"
        text = text .. (o_str ~= "" and o_str or "\n")
        
        if ItemTrackerLabel then ItemTrackerLabel.Text = text end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.Yui.ESPItems then
        local currentESP = {}
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        for _, itemData in ipairs(ScannedItems) do
            if itemData.Obj and itemData.Obj.Parent and itemData.Part and _G.Yui.SelectedESPItems[itemData.Name] then
                local espId = "ItemESP_" .. tostring(itemData.Obj:GetDebugId())
                currentESP[espId] = true

                local bg = ItemESPFolder:FindFirstChild(espId)
                if not bg then
                    bg = Instance.new("BillboardGui", ItemESPFolder)
                    bg.Name = espId
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 100, 0, 40)
                    bg.StudsOffset = Vector3.new(0, 1.5, 0)
                    
                    local txt = Instance.new("TextLabel", bg)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 255, 0) 
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 10
                    txt.TextStrokeTransparency = 0
                end
                
                local dist = root and math.floor((root.Position - itemData.Part.Position).Magnitude) or 0
                bg.Adornee = itemData.Part
                bg.TextLabel.Text = itemData.Name .. " [" .. dist .. "m]"
            end
        end

        for _, bg in pairs(ItemESPFolder:GetChildren()) do
            if not currentESP[bg.Name] then bg:Destroy() end
        end
    else
        ItemESPFolder:ClearAllChildren()
    end
end)

-- =========================================================================
-- BỘ NÃO ĐỐI THOẠI & NHẬN QUEST
-- =========================================================================
local function HasActiveQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    local questGui = pGui and pGui:FindFirstChild("QuestGui")
    if questGui then
        local qFrame = questGui:FindFirstChild("QuestsFrame")
        if qFrame and qFrame.Visible then
            local scroll = qFrame:FindFirstChild("QuestsScroll")
            if scroll and (scroll:FindFirstChild("QuestName") or scroll:FindFirstChild("Objective")) then
                return true
            end
        end
    end
    return false
end

local function SmartClickDialog(opts)
    local btnNext = opts:FindFirstChild("Next")
    local btnOption = opts:FindFirstChild("Option")
    local btnOption2 = opts:FindFirstChild("Option2")
    local btnLeave = opts:FindFirstChild("Leave")

    if btnNext and btnNext.Visible then SilentClick(btnNext) return true end
    if btnOption and btnOption.Visible then SilentClick(btnOption) return true end
    if btnOption2 and btnOption2.Visible then SilentClick(btnOption2) return true end
    if btnLeave and btnLeave.Visible and HasActiveQuest() then SilentClick(btnLeave) return true end
    return false
end

task.spawn(function()
    while task.wait(_G.Yui.FindBoxDelay) do
        if _G.Yui.AutoFindBox then
            local char = LocalPlayer.Character
            if not char then continue end
            local compass = LocalPlayer.Backpack:FindFirstChild("Compass") or char:FindFirstChild("Compass")
            if compass then
                char.Humanoid:EquipTool(compass)
                for _, tree in pairs(Workspace:GetDescendants()) do
                    if not _G.Yui.AutoFindBox then break end
                    if not (char:FindFirstChild("Compass") or LocalPlayer.Backpack:FindFirstChild("Compass")) then break end
                    
                    if tree:IsA("Model") and (string.find(string.lower(tree.Name), "tree") or string.find(string.lower(tree.Name), "wood") or string.find(string.lower(tree.Name), "pine")) then
                        local tpPart = tree:FindFirstChildWhichIsA("BasePart")
                        if tpPart then
                            MoveTo(tpPart.CFrame * CFrame.new(0, 3, 0))
                            task.wait(0.3)
                            for i = 1, 8 do
                                VirtualUser:CaptureController()
                                local cam = workspace.CurrentCamera
                                VirtualUser:ClickButton1(Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2))
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pGui then continue end

        if _G.Yui.AutoSpawn then
            local loadFrame = pGui:FindFirstChild("Load") and pGui.Load:FindFirstChild("Frame") and pGui.Load.Frame:FindFirstChild("Load")
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if (hum and hum.Health == 0) or (loadFrame and loadFrame.Visible) then
                if loadFrame then SilentClick(loadFrame) end
                pcall(function() local cam = Workspace.CurrentCamera local char = LocalPlayer.Character if cam and char and char:FindFirstChild("Humanoid") then cam.CameraSubject = char.Humanoid cam.CameraType = Enum.CameraType.Custom end end)
            end
        end
        
        if _G.Yui.AutoUpgradeCap then
            for _, gui in pairs(pGui:GetDescendants()) do
                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                    if gui.Text and string.find(string.lower(gui.Text), "upgrade capacity") then SilentClick(gui) end
                end
            end
        end

        local targetQuestName = nil
        if _G.Yui.AutoDailyQuest and _G.Yui.SelectedDailyQuest ~= "" and _G.Yui.SelectedDailyQuest ~= "None" then targetQuestName = _G.Yui.SelectedDailyQuest
        elseif _G.Yui.AutoNormalQuest and _G.Yui.SelectedNormalQuest ~= "" and _G.Yui.SelectedNormalQuest ~= "None" then targetQuestName = _G.Yui.SelectedNormalQuest end

        if targetQuestName then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and not HasActiveQuest() then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == targetQuestName and obj:IsA("Model") and obj.Parent and string.find(string.lower(obj.Parent.Name), "quest") then
                        local npcRoot = obj:FindFirstChild("HumanoidRootPart")
                        local cd = npcRoot and npcRoot:FindFirstChildOfClass("ClickDetector")
                        
                        if npcRoot and cd then
                            local dist = (root.Position - npcRoot.Position).Magnitude
                            
                            if _G.Yui.TeleportToNPC and dist > 10 then
                                local oldPos = root.CFrame
                                MoveTo(npcRoot.CFrame * CFrame.new(0, 0, 4)) 
                                root.Velocity = Vector3.zero
                                task.wait(0.3)
                                
                                if fireclickdetector then fireclickdetector(cd, 1) end
                                
                                local timeout = tick()
                                while tick() - timeout < 5 do
                                    task.wait(0.2)
                                    if HasActiveQuest() then break end 
                                    
                                    local questGui = pGui:FindFirstChild("QuestGui")
                                    local dialogue = questGui and questGui:FindFirstChild("Dialogue")
                                    if dialogue and dialogue.Visible then
                                        pcall(function() dialogue.Position = UDim2.new(5, 0, 5, 0) end) 
                                        local opts = dialogue:FindFirstChild("Options")
                                        if opts then SmartClickDialog(opts) end
                                    end
                                end
                                task.wait(0.1)
                                MoveTo(oldPos)
                            else
                                if fireclickdetector then fireclickdetector(cd, 1) end
                                local questGui = pGui:FindFirstChild("QuestGui")
                                local dialogue = questGui and questGui:FindFirstChild("Dialogue")
                                if dialogue and dialogue.Visible then
                                    pcall(function() dialogue.Position = UDim2.new(5, 0, 5, 0) end)
                                    local opts = dialogue:FindFirstChild("Options")
                                    if opts then SmartClickDialog(opts) end
                                end
                            end
                        end
                        break 
                    end
                end
            end
        end

        local questGui = pGui:FindFirstChild("QuestGui")
        local dialogue = questGui and questGui:FindFirstChild("Dialogue")
        
        local wantsSam = false
        if _G.Yui.AutoSam then
            if _G.Yui.SamLoopCount > 0 then wantsSam = true end
        elseif _G.Yui.AutoSamInf then
            wantsSam = true
        end

        if not (dialogue and dialogue.Visible) and wantsSam then
            FireNPC("Sam", true)
        end

        if dialogue and dialogue.Visible then
            local shouldHide = _G.Yui.AutoAcceptQuest or wantsSam or _G.Yui.AutoGetRod or _G.Yui.AutoNormalQuest or _G.Yui.AutoDailyQuest
            if shouldHide then pcall(function() dialogue.Position = UDim2.new(5, 0, 5, 0) end) else pcall(function() dialogue.AnchorPoint = Vector2.new(0.5, 0.5) dialogue.Position = UDim2.new(0.5, 0, 0.5, 0) end) end

            local opts = dialogue:FindFirstChild("Options")
            if opts then
                if wantsSam then
                    for _, btn in pairs(opts:GetChildren()) do
                        if btn:IsA("TextButton") and btn.Visible then
                            local txt = string.lower(GetButtonText(btn))
                            local amtStr = string.lower(_G.Yui.AutoSamAmount)
                            amtStr = string.gsub(amtStr, "x", "")
                            
                            if string.find(txt, "claim " .. amtStr) then SilentClick(btn) task.wait(0.1)
                            elseif string.find(txt, "claim") then SilentClick(btn) task.wait(0.1)
                            elseif string.find(txt, "option") then SilentClick(btn) task.wait(0.1)
                            elseif string.find(txt, "leave") then 
                                SilentClick(btn) task.wait(0.1)
                                if _G.Yui.AutoSam and not _G.Yui.AutoSamInf then _G.Yui.SamLoopCount = _G.Yui.SamLoopCount - 1 end
                            end
                        end
                    end
                elseif _G.Yui.AutoAcceptQuest then
                    local btnNext = opts:FindFirstChild("Next")
                    if btnNext and btnNext.Visible then SilentClick(btnNext) 
                    else
                        for _, btn in pairs(opts:GetChildren()) do
                            if btn:IsA("TextButton") and btn.Visible and string.lower(btn.Name) ~= "leave" then
                                local txt = string.lower(GetButtonText(btn))
                                if not string.find(txt, "nevermind") and not string.find(txt, "leave") and not string.find(txt, "no") then SilentClick(btn) break end
                            end
                        end
                    end
                else
                    if _G.Yui.AutoNormalQuest or _G.Yui.AutoDailyQuest then
                        SmartClickDialog(opts)
                    end
                end
            end
        end
    end
end)

-- =========================================================================
-- [MASTER THREADS] - PHYSICS & EXPLOITS
-- =========================================================================

UserInputService.JumpRequest:Connect(function()
    if _G.Yui.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end
end)

RunService.Stepped:Connect(function()
    if _G.Yui.Noclip and LocalPlayer.Character then for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
end)

local WOWPad = Instance.new("Part") WOWPad.Size = Vector3.new(5, 1, 5) WOWPad.Transparency = 1 WOWPad.Anchored = true WOWPad.CanCollide = false WOWPad.Parent = Workspace
RunService.Heartbeat:Connect(function()
    if _G.Yui.WalkOnWater and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local params = RaycastParams.new() params.FilterType = Enum.RaycastFilterType.Whitelist params.FilterDescendantsInstances = {Workspace.Terrain}
        local result = Workspace:Raycast(root.Position, Vector3.new(0, -50, 0), params)
        if result and result.Material == Enum.Material.Water then WOWPad.Position = result.Position WOWPad.CanCollide = true
        else WOWPad.Position = Vector3.new(0, 99999, 0) WOWPad.CanCollide = false end
    else WOWPad.Position = Vector3.new(0, 99999, 0) WOWPad.CanCollide = false end
end)

-- FLY THREAD
RunService.RenderStepped:Connect(function()
    if _G.Yui.Fly then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        local cam = workspace.CurrentCamera
        
        if root and hum then
            local bv = root:FindFirstChild("YuiFlyBV")
            local bg = root:FindFirstChild("YuiFlyBG")
            if bv and bg then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local dot = moveDir:Dot(cam.CFrame.LookVector)
                    local y_vel = 0
                    if dot > 0.3 then y_vel = cam.CFrame.LookVector.Y * _G.Yui.FlySpeed 
                    elseif dot < -0.3 then y_vel = -cam.CFrame.LookVector.Y * _G.Yui.FlySpeed end 
                    bv.Velocity = Vector3.new(moveDir.X * _G.Yui.FlySpeed, y_vel, moveDir.Z * _G.Yui.FlySpeed)
                else
                    bv.Velocity = Vector3.zero
                end
                bg.CFrame = cam.CFrame
            end
        end
    end
end)

-- BỘ NÃO GOM VẬT PHẨM TỐI ƯU (ĐÃ SỬA BARREL CHỐNG KẸT)
local CachedCollectables = {}
task.spawn(function()
    while task.wait(3) do
        local newCache = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            local n = obj.Name
            if n == "TreasureChest" or n == "Barrel" or n == "Crate" or string.find(string.lower(n), "compass") or string.find(string.lower(n), "fruit") then
                table.insert(newCache, obj)
            end
        end
        CachedCollectables = newCache
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then continue end
        local didAction = false
        local anchor = root.CFrame
        if _G.Yui.CollectMethod == "Teleport (Continuous)" then anchor = nil end

        for _, obj in ipairs(CachedCollectables) do
            if not obj or not obj.Parent then continue end
            local n = obj.Name
            local ln = string.lower(n)

            if _G.Yui.AutoFruit and string.find(ln, "fruit") and not didAction then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    MoveTo(handle.CFrame)
                    for _, cd in pairs(obj:GetDescendants()) do if cd:IsA("ClickDetector") then fireclickdetector(cd, 1) end end
                    SendNotification("Collected: " .. n, Theme.SelectedGreen, "Fruit")
                    task.wait(_G.Yui.CollectSpeed) didAction = true
                end
            end

            if _G.Yui.CollectCompass and string.find(ln, "compass") and not didAction then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    MoveTo(handle.CFrame)
                    for _, cd in pairs(obj:GetDescendants()) do if cd:IsA("ClickDetector") then fireclickdetector(cd, 1) end end
                    SendNotification("Collected: Compass", Theme.SelectedGreen, "Compass")
                    task.wait(_G.Yui.CollectSpeed) didAction = true
                end
            end

            if _G.Yui.CollectChest and n == "TreasureChest" and not didAction then
                local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
                if tPart and tPart.Transparency < 1 then
                    local posKey = tostring(obj:GetDebugId()) 
                    if not TimedBlacklist[posKey] or tick() - TimedBlacklist[posKey] > 1.5 then 
                        root.CFrame = tPart.CFrame * CFrame.new(0, 1, 0) root.Velocity = Vector3.zero
                        task.wait(0.1) 
                        if firetouchinterest then for i=1,10 do for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") then firetouchinterest(part, tPart, 0) firetouchinterest(part, tPart, 1) end end end end
                        SendNotification("Collected: Chest", Theme.SelectedGreen, "Chest")
                        TimedBlacklist[posKey] = tick() didAction = true
                    end
                end
            end

            -- FIX BARREL KHÔNG KẸT
            if _G.Yui.CollectBarrel and (n == "Barrel" or n == "Crate") and not didAction then
                local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
                local cd = obj:FindFirstChildOfClass("ClickDetector")
                if tPart and cd and tPart.Transparency < 1 then
                    local posKey = tostring(obj:GetDebugId())
                    if not TimedBlacklist[posKey] or tick() - TimedBlacklist[posKey] > 1.5 then 
                        root.CFrame = tPart.CFrame * CFrame.new(0, 2, 0) root.Velocity = Vector3.zero
                        task.wait(0.2) -- Tăng thời gian đứng yên xíu cho chắc
                        if fireclickdetector then for i=1,5 do fireclickdetector(cd, 1) end end
                        SendNotification("Collected: " .. n, Theme.SelectedGreen, "Barrel")
                        TimedBlacklist[posKey] = tick() didAction = true
                    end
                end
            end
        end
        if didAction and anchor and _G.Yui.CollectMethod == "Teleport (Return)" then MoveTo(anchor) end
        if not didAction then task.wait(0.1) end
    end
end)

-- BỘ NÃO ĐÁNH QUÁI (ĐÃ FIX: FARM NEAR MẶC KỆ DANH SÁCH + CHUẨN LEVEL)
local LastAttack = tick()
local WepCycleIndex = 1
local LastWepSwap = tick()
local LastSkillTick = tick()

local CachedMobs = {}
task.spawn(function()
    while task.wait(3) do
        local temp = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Parent and not string.find(string.lower(obj.Parent.Name), "quest") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChildOfClass("Humanoid").Health > 0 then
                local rawNameL = string.lower(obj.Name)
                if string.find(rawNameL, "lv") or string.find(rawNameL, "level") then
                    table.insert(temp, obj)
                end
            end
        end
        CachedMobs = temp
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if not _G.Yui.AutoFarm then CurrentTarget = nil continue end
        if CurrentTarget and CurrentTarget.Parent and CurrentTarget:FindFirstChild("Humanoid") and CurrentTarget.Humanoid.Health > 0 then
            continue
        end

        local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then continue end

        local targetMobName = ""
        local pGui = LocalPlayer.PlayerGui local questGui = pGui:FindFirstChild("QuestGui")
        if questGui and questGui:FindFirstChild("QuestsFrame") and questGui.QuestsFrame.Visible then
            local obj = questGui.QuestsFrame:FindFirstChild("QuestsScroll") and questGui.QuestsFrame.QuestsScroll:FindFirstChild("Objective")
            if obj and obj.Text ~= "" then targetMobName = string.gsub(obj.Text, "%s*%d+/%d+$", "") end
        end

        pcall(function()
            local shortest = math.huge local target = nil
            for _, obj in ipairs(CachedMobs) do
                if obj and obj.Parent and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    local rawNameL = string.lower(obj.Name)
                    local lvl = tonumber(string.match(rawNameL, "%d+")) or 0
                    
                    local validLvl = true
                    if _G.Yui.MobLevelFilter == "< 1000" and lvl >= 1000 then validLvl = false end
                    if _G.Yui.MobLevelFilter == "> 1000" and lvl < 1000 then validLvl = false end
                    
                    if validLvl then
                        local cleanName = string.gsub(obj.Name, "%[.-%]", "") cleanName = string.gsub(cleanName, "%d+$", "") cleanName = string.match(cleanName, "^%s*(.-)%s*$") or cleanName
                        
                        -- FIX: Nếu bật FarmNear thì không cần check SelectedMobs
                        local isTarget = false
                        if _G.Yui.FarmNear then
                            isTarget = true
                        elseif _G.Yui.SelectedMobs[cleanName] or (targetMobName~="" and string.find(obj.Name, targetMobName, 1, true)) then
                            isTarget = true
                        end

                        if isTarget then
                            local dist = (root.Position - obj.HumanoidRootPart.Position).Magnitude
                            if dist < shortest then shortest = dist target = obj end
                        end
                    end
                end
            end
            CurrentTarget = target
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.Yui.AutoFarm and CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if _G.Yui.AutoGunFarm then
                local dist = _G.Yui.GunAttackDist or 25
                local targetPos = CurrentTarget.HumanoidRootPart.Position
                root.CFrame = CFrame.new(targetPos + Vector3.new(0, _G.Yui.AttackDist, dist), targetPos)
            else
                local offset = CFrame.new(0, _G.Yui.AttackDist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                if _G.Yui.AttackPos == "Below" then offset = CFrame.new(0, -_G.Yui.AttackDist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                elseif _G.Yui.AttackPos == "Behind" then offset = CFrame.new(0, 0, _G.Yui.AttackDist)
                elseif _G.Yui.AttackPos == "Front" then offset = CFrame.new(0, 0, -_G.Yui.AttackDist) * CFrame.Angles(0, math.rad(180), 0) end
                root.CFrame = CurrentTarget.HumanoidRootPart.CFrame * offset
            end
            
            root.Velocity = Vector3.zero
            for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end
    end
end)

-- GUN FARM (AIMBOT CAMERA)
RunService.RenderStepped:Connect(function()
    if _G.Yui.AutoGunFarm and CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, CurrentTarget.HumanoidRootPart.Position)
    end
end)

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    local char = LocalPlayer.Character local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d closest = p.Character end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait() do
        local wantsAttack = _G.Yui.AutoClickAlways or (_G.Yui.AutoClickFarming and CurrentTarget) or _G.Yui.FastAttack or (_G.Yui.AutoGunFarm and CurrentTarget)
        
        local activeWeps = {}
        for wName, active in pairs(_G.Yui.SelectedWeapons) do if active then table.insert(activeWeps, wName) end end
        
        local currentToolName = nil
        local char = LocalPlayer.Character
        
        if #activeWeps > 0 then
            if #activeWeps > 1 then
                if tick() - LastWepSwap >= 1.5 then 
                    WepCycleIndex = WepCycleIndex + 1 if WepCycleIndex > #activeWeps then WepCycleIndex = 1 end
                    LastWepSwap = tick()
                end
            else
                WepCycleIndex = 1
            end
            currentToolName = activeWeps[WepCycleIndex]
        end

        if wantsAttack and currentToolName and char then
            pcall(function()
                local toolToEquip = LocalPlayer.Backpack:FindFirstChild(currentToolName) or char:FindFirstChild(currentToolName)
                if toolToEquip and toolToEquip.Parent ~= char then char.Humanoid:EquipTool(toolToEquip) end
                
                local equippedTool = char:FindFirstChildOfClass("Tool")
                if equippedTool and equippedTool.Name == currentToolName then
                    equippedTool:Activate()
                    if _G.Yui.AutoClickFarming or _G.Yui.AutoClickAlways or _G.Yui.FastAttack or _G.Yui.AutoGunFarm then
                        if tick() - LastAttack >= 0.1 then
                            local cam = workspace.CurrentCamera
                            local clickPos = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
                            
                            if _G.Yui.AutoGunFarm and GunDot.Visible then
                                local inset = GuiService:GetGuiInset()
                                clickPos = Vector2.new(GunDot.AbsolutePosition.X + GunDot.AbsoluteSize.X/2, GunDot.AbsolutePosition.Y + GunDot.AbsoluteSize.Y/2 + inset.Y)
                            else
                                if _G.Yui.ClickPosition == "Edge" then clickPos = Vector2.new(10, cam.ViewportSize.Y/2)
                                elseif _G.Yui.ClickPosition == "Off-Screen" then clickPos = Vector2.new(9999, 9999) end
                            end
                            
                            VirtualUser:CaptureController() 
                            VirtualUser:ClickButton1(clickPos) 
                            LastAttack = tick()
                        end
                    end
                end
            end)
        end
        
        -- FIX TỐI ƯU SKILL MƯỢT
        if tick() - LastSkillTick >= _G.Yui.SkillDelay then
            local shouldSkill = (CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart")) or _G.Yui.AutoAimSkillPlayer
            if shouldSkill then
                -- AIMBOT SKILL VÀO PLAYER NẾU BẬT
                if _G.Yui.AutoAimSkillPlayer then
                    local targetP = getClosestPlayer()
                    if targetP and targetP:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetP.HumanoidRootPart.Position.X, root.Position.Y, targetP.HumanoidRootPart.Position.Z))
                    end
                end

                for key, isEnabled in pairs(_G.Yui.AutoSkill) do 
                    if isEnabled then 
                        task.spawn(function()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game) 
                            task.wait(0.05) -- Delay siêu nhỏ để server nhận lệnh
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game) 
                        end)
                    end 
                end
                LastSkillTick = tick()
            end
        end

        if _G.Yui.AutoHaki.E and not HakiStates.E then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game) task.wait(0.1) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game) HakiStates.E = true end
        if _G.Yui.AutoHaki.R and not HakiStates.R then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game) task.wait(0.1) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game) HakiStates.R = true end
        if _G.Yui.AutoHaki.T then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.T, false, game) task.wait(0.1) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.T, false, game) end
    end
end)

local LastDrinkTick = tick()
task.spawn(function()
    while task.wait(0.1) do
        if _G.Yui.AutoDrink and tick() - LastDrinkTick > _G.Yui.DrinkDelay then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local toEquip = {}
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "juice") or string.find(string.lower(tool.Name), "milk")) then
                            table.insert(toEquip, tool)
                        end
                    end
                    if #toEquip > 0 then
                        for _, tool in ipairs(toEquip) do tool.Parent = char end
                        for _, tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "juice") or string.find(string.lower(tool.Name), "milk")) then
                                tool:Activate()
                            end
                        end
                        SendNotification("Drank " .. #toEquip .. " Juices/Milks!", Theme.Accent, "Drink")
                    end
                end
            end)
            LastDrinkTick = tick()
        end
    end
end)

local LastAppleTick = tick()
task.spawn(function()
    while task.wait(0.1) do
        if _G.Yui.AutoEatApple and tick() - LastAppleTick > _G.Yui.AppleDelay then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local toEquip = {}
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and string.find(string.lower(tool.Name), "apple") then
                            table.insert(toEquip, tool)
                        end
                    end
                    if #toEquip > 0 then
                        for _, tool in ipairs(toEquip) do tool.Parent = char end
                        for _, tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") and string.find(string.lower(tool.Name), "apple") then
                                tool:Activate()
                            end
                        end
                        SendNotification("Ate " .. #toEquip .. " Apples!", Theme.Accent, "Apple")
                    end
                end
            end)
            LastAppleTick = tick()
        end
    end
end)

local LastHoldTicks = {E=0, R=0, T=0, Z=0, X=0, C=0, V=0, B=0, N=0, F=0}
RunService.Heartbeat:Connect(function()
    if CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") then
        for key, active in pairs(_G.Yui.HoldSkill) do
            if active and tick() - LastHoldTicks[key] > (_G.Yui.HoldTime + 0.5) then
                LastHoldTicks[key] = tick()
                task.spawn(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game) task.wait(_G.Yui.HoldTime) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
            end
        end
    end
end)

-- AUTO FISH (ĐÃ LÀM LẠI HOÀN TOÀN THEO CẤU TRÚC FishingRope_[UserId])
task.spawn(function()
    while task.wait(0.2) do
        local char = LocalPlayer.Character if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart local backpack = LocalPlayer:FindFirstChild("Backpack")

        if _G.Yui.AutoGetRod then
            local hasRod = false
            if char:FindFirstChildOfClass("Tool") and (string.find(string.lower(char:FindFirstChildOfClass("Tool").Name), "rod") or string.find(string.lower(char:FindFirstChildOfClass("Tool").Name), "fish")) then hasRod = true end
            if backpack then for _, t in pairs(backpack:GetChildren()) do if t:IsA("Tool") and (string.find(string.lower(t.Name), "rod") or string.find(string.lower(t.Name), "fish")) then hasRod = true end end end

            if hasRod then
                _G.Yui.AutoGetRod = false
            else
                local package = char:FindFirstChild("Package") or (backpack and backpack:FindFirstChild("Package"))
                if not package then
                    local fisherman = nil
                    for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("Model") and obj.Name == "Fisherman" and obj:FindFirstChild("HumanoidRootPart") then fisherman = obj break end end
                    if fisherman then MoveTo(fisherman.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)) local cd = fisherman:FindFirstChildOfClass("ClickDetector", true) if cd then fireclickdetector(cd, 0) end end
                else
                    if package.Parent == backpack then char.Humanoid:EquipTool(package) task.wait(0.5) end
                    VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0))

                    local allNPCs = {}
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) and obj.Name ~= "Fisherman" then table.insert(allNPCs, obj) end
                    end
                    for _, npc in ipairs(allNPCs) do
                        local stillHavePackage = char:FindFirstChild("Package") or (backpack and backpack:FindFirstChild("Package"))
                        if not stillHavePackage then break end
                        MoveTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)) task.wait(0.3)
                    end
                end
            end
        end

        if _G.Yui.AutoFish then
            local rod = char:FindFirstChildOfClass("Tool")
            if not rod or not (string.find(string.lower(rod.Name), "rod") or string.find(string.lower(rod.Name), "fish")) then
                if backpack then for _, tool in ipairs(backpack:GetChildren()) do local tName = string.lower(tool.Name) if tool:IsA("Tool") and (string.find(tName, "rod") or string.find(tName, "fish") or string.find(tName, "pole")) then char.Humanoid:EquipTool(tool) rod = tool task.wait(1) break end end end
            end
            
            if rod then
                -- FIX THEO ẢNH: Bắt buộc dùng FishingRope_ID
                local ropeName = "FishingRope_" .. tostring(LocalPlayer.UserId)
                local isCast = Workspace:FindFirstChild(ropeName, true) ~= nil
                
                if not isCast then 
                    VirtualUser:CaptureController() 
                    VirtualUser:ClickButton1(Vector2.new(0, 0)) 
                    task.wait(1) -- Chờ thả dây xong
                end
                
                if _G.Yui.AutoShake then
                    local pGui = LocalPlayer.PlayerGui
                    if pGui then
                        for _, v in pairs(pGui:GetDescendants()) do
                            if (v:IsA("TextButton") or v:IsA("ImageButton")) and (string.find(string.lower(v.Name), "shake") or (v:IsA("TextButton") and string.find(string.lower(v.Text), "shake"))) then
                                if v.Visible then SilentClick(v) end
                            end
                        end
                    end
                end
            end
        end
    end
end)
