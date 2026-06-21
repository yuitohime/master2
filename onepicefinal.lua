-- ===================== KEY SYSTEM =====================
local DEPLOY_URL = "https://script.google.com/macros/s/AKfycbzKuYH2xXsADaLbevWIl7j0p6iZ-xQ3Ss08wXWEkAiGcOq2fzLAvDDQ-1AW9NdwqGUmKg/exec"

local function getHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function checkKey(key)
return true,  "OK"
end

local keyGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
keyGui.ResetOnSpawn = false
keyGui.Name = "TuanhKeySystem"

local _bg = Instance.new("Frame", keyGui)
_bg.Size=UDim2.new(1,0,1,0); _bg.BackgroundColor3=Color3.fromRGB(0,0,0)
_bg.BackgroundTransparency=0.4; _bg.BorderSizePixel=0

local _box = Instance.new("Frame", keyGui)
_box.Size=UDim2.new(0,340,0,190); _box.Position=UDim2.new(0.5,-170,0.5,-95)
_box.BackgroundColor3=Color3.fromRGB(12,12,22); _box.BorderSizePixel=0
local _bc=Instance.new("UICorner",_box); _bc.CornerRadius=UDim.new(0,10)
local _bs=Instance.new("UIStroke",_box); _bs.Color=Color3.fromRGB(120,55,255); _bs.Thickness=1.5

local _title=Instance.new("TextLabel",_box)
_title.Size=UDim2.new(1,0,0,36); _title.BackgroundColor3=Color3.fromRGB(120,55,255)
_title.BorderSizePixel=0; _title.Text="TUANH FARM HUB - KEY SYSTEM"
_title.TextColor3=Color3.fromRGB(255,255,255); _title.TextSize=12; _title.Font=Enum.Font.GothamBold
local _tc=Instance.new("UICorner",_title); _tc.CornerRadius=UDim.new(0,10)
local _tf=Instance.new("Frame",_title)
_tf.Size=UDim2.new(1,0,0.5,0); _tf.Position=UDim2.new(0,0,0.5,0)
_tf.BackgroundColor3=Color3.fromRGB(120,55,255); _tf.BorderSizePixel=0

local _statusLbl=Instance.new("TextLabel",_box)
_statusLbl.Size=UDim2.new(1,-20,0,20); _statusLbl.Position=UDim2.new(0,10,0,44)
_statusLbl.BackgroundTransparency=1; _statusLbl.Text="Nhap key de tiep tuc..."
_statusLbl.TextColor3=Color3.fromRGB(100,100,130); _statusLbl.TextSize=11; _statusLbl.Font=Enum.Font.Gotham
_statusLbl.TextXAlignment=Enum.TextXAlignment.Center

local _input=Instance.new("TextBox",_box)
_input.Size=UDim2.new(1,-20,0,32); _input.Position=UDim2.new(0,10,0,72)
_input.BackgroundColor3=Color3.fromRGB(26,26,46); _input.BorderSizePixel=0
_input.PlaceholderText="Nhap key cua ban..."; _input.Text=""
_input.TextColor3=Color3.fromRGB(230,230,245); _input.PlaceholderColor3=Color3.fromRGB(100,100,130)
_input.TextSize=12; _input.Font=Enum.Font.GothamBold; _input.ClearTextOnFocus=false
local _ic=Instance.new("UICorner",_input); _ic.CornerRadius=UDim.new(0,6)
local _is=Instance.new("UIStroke",_input); _is.Color=Color3.fromRGB(120,55,255); _is.Thickness=1
local _ip2=Instance.new("UIPadding",_input); _ip2.PaddingLeft=UDim.new(0,8)

local _submitBtn=Instance.new("TextButton",_box)
_submitBtn.Size=UDim2.new(1,-20,0,32); _submitBtn.Position=UDim2.new(0,10,0,114)
_submitBtn.BackgroundColor3=Color3.fromRGB(120,55,255); _submitBtn.BorderSizePixel=0
_submitBtn.Text="XAC NHAN KEY"; _submitBtn.TextColor3=Color3.fromRGB(255,255,255)
_submitBtn.TextSize=12; _submitBtn.Font=Enum.Font.GothamBold
local _sc=Instance.new("UICorner",_submitBtn); _sc.CornerRadius=UDim.new(0,6)

local _hwidLbl=Instance.new("TextLabel",_box)
_hwidLbl.Size=UDim2.new(1,-20,0,16); _hwidLbl.Position=UDim2.new(0,10,0,162)
_hwidLbl.BackgroundTransparency=1; _hwidLbl.Text="HWID: "..getHWID()
_hwidLbl.TextColor3=Color3.fromRGB(60,60,80); _hwidLbl.TextSize=8; _hwidLbl.Font=Enum.Font.Gotham
_hwidLbl.TextXAlignment=Enum.TextXAlignment.Center; _hwidLbl.TextTruncate=Enum.TextTruncate.AtEnd

local _verified=false
local function _verify()
    local key=_input.Text
    if key=="" then _statusLbl.Text="Hay nhap key!"; _statusLbl.TextColor3=Color3.fromRGB(255,80,80); return end
    _submitBtn.Text="Dang kiem tra..."; _submitBtn.BackgroundColor3=Color3.fromRGB(60,30,120)
    _statusLbl.Text="Connecting to server..."; _statusLbl.TextColor3=Color3.fromRGB(255,200,60)
    local ok,msg=checkKey(key)
    if ok then
        _statusLbl.Text="Key hop le! Dang tai..."; _statusLbl.TextColor3=Color3.fromRGB(80,255,140)
        task.wait(1); keyGui:Destroy(); _verified=true
    else
        _statusLbl.Text=msg; _statusLbl.TextColor3=Color3.fromRGB(255,80,80)
        _submitBtn.Text="XAC NHAN KEY"; _submitBtn.BackgroundColor3=Color3.fromRGB(120,55,255)
    end
end
_submitBtn.MouseButton1Click:Connect(_verify)
_input.FocusLost:Connect(function(enter) if enter then _verify() end end)
_G.Key = "SalunaToiChoi"
if _G.Key and _G.Key~= "" then
    local ok=checkKey(_G.Key)
    if ok then keyGui:Destroy(); _verified=true end
end

repeat task.wait(0.1) until _verified
-- ===================== END KEY SYSTEM =====================

local Players         = game:GetService("Players")
local VirtualUser     = game:GetService("VirtualUser")
local VIM             = game:GetService("VirtualInputManager")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local TweenService    = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local player          = Players.LocalPlayer

-- ===================== STATE =====================
local selectedMobs     = {}
local autoAttack       = false
local autoSpawnTP      = false
local autoSpawnClick   = false
local smeltMethod      = false
local equippedWeapon   = nil
local autoChestOn      = false
local autoFishOn       = false
local fishRunning      = false
local CAST_X           = 532
local CAST_Y           = 133
local spawnSkills      = {Z=false,X=false,C=false,V=false,E=false,R=false}
local loopSkills       = {Z=false,X=false,C=false,V=false,E=false,R=false}
local skillLoopThreads = {}
local kaitunOn         = false

-- Boss state
local autoVokun        = false
local autoWhiteBeard   = false
local autoCrocodile    = false
local autoGunnerCap    = false
local vokunThread      = nil
local whiteBeardThread = nil
local crocoThread      = nil
local gunnerThread     = nil
local ITEM_DROP_CF     = CFrame.new(6671.069824, 566.312866, -1941.518433)

-- Auto Sam state
local autoSamOn        = false
local samThread        = nil

-- ===================== LOAD CONFIG =====================
if _G.TuanhConfig then
    local cfg = _G.TuanhConfig
    autoAttack     = cfg.autoAttack     or false
    autoSpawnTP    = cfg.autoSpawnTP    or false
    autoSpawnClick = cfg.autoSpawnClick or false
    smeltMethod    = cfg.smeltMethod    or false
    equippedWeapon = cfg.equippedWeapon or nil
    if cfg.selectedMobs then
        for _,name in ipairs(cfg.selectedMobs) do selectedMobs[name]=true end
    end
    if cfg.spawnSkills then
        for k,v in pairs(cfg.spawnSkills) do spawnSkills[k]=v end
    end
    if cfg.loopSkills then
        for k,v in pairs(cfg.loopSkills) do loopSkills[k]=v end
    end
end

-- ===================== HELPERS =====================
local function pressKey(key)
    VIM:SendKeyEvent(true,key,false,game); task.wait(0.05); VIM:SendKeyEvent(false,key,false,game)
end
local function clickPos(x,y)
    VIM:SendMouseButtonEvent(x,y,0,true,game,0); task.wait(0.08); VIM:SendMouseButtonEvent(x,y,0,false,game,0)
end
local function getMobs()
    local seen,list={},{}
    for _,mob in ipairs(workspace:WaitForChild("Alive"):GetChildren()) do
        local hum=mob:FindFirstChild("Humanoid")
        local isPlayer=false
        for _,p in ipairs(Players:GetPlayers()) do if p.Character==mob then isPlayer=true; break end end
        if hum and hum.Health>0 and not seen[mob.Name] and not isPlayer then
            seen[mob.Name]=true; table.insert(list,mob.Name)
        end
    end
    table.sort(list); return list
end
local function getAliveCount(name)
    local count=0
    for _,mob in ipairs(workspace.Alive:GetChildren()) do
        local hum=mob:FindFirstChild("Humanoid")
        if mob.Name==name and hum and hum.Health>0 then count+=1 end
    end
    return count
end
local function getNearestMob()
    local char=player.Character; if not char then return nil,nil end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil,nil end
    local nearest,dist=nil,math.huge
    for _,mob in ipairs(workspace.Alive:GetChildren()) do
        local hum=mob:FindFirstChild("Humanoid"); local mobHrp=mob:FindFirstChild("HumanoidRootPart")
        if selectedMobs[mob.Name] and hum and hum.Health>0 and mobHrp then
            local d=(hrp.Position-mobHrp.Position).Magnitude
            if d<dist then dist=d; nearest=mob end
        end
    end
    return nearest,dist
end
local function countSelected()
    local c=0; for _ in pairs(selectedMobs) do c+=1 end; return c
end

-- ===================== WEAPON =====================
local function getWeapons()
    local list={}
    local bp=player:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(list,t.Name) end end end
    local char=player.Character
    if char then for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(list,t.Name) end end end
    table.sort(list); return list
end
local function equipWeapon(name)
    if not name then return end
    local char=player.Character; if not char then return end
    local bp=player:FindFirstChild("Backpack")
    if bp then
        local tool=bp:FindFirstChild(name)
        if tool then local hum=char:FindFirstChild("Humanoid"); if hum then hum:EquipTool(tool) end end
    end
end
player.CharacterAdded:Connect(function(char) task.wait(3); if equippedWeapon then equipWeapon(equippedWeapon) end end)
-- FIX: Giảm weapon check từ 1.5s → 3s để nhẹ hơn
task.spawn(function()
    while true do
        task.wait(3)
        if not equippedWeapon then continue end
        local char=player.Character; if not char then continue end
        local holding=false
        for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") and t.Name==equippedWeapon then holding=true; break end end
        if not holding then pcall(function() equipWeapon(equippedWeapon) end) end
    end
end)

-- ===================== SMELT METHOD =====================
local smeltLoop=0
local function startSmeltMethod(char)
    smeltLoop+=1; local myLoop=smeltLoop
    local hum=char:WaitForChild("Humanoid"); task.wait(3.5)
    if myLoop~=smeltLoop then return end
    pressKey(Enum.KeyCode.Z); task.wait(0.5); pressKey(Enum.KeyCode.X)
    task.spawn(function()
        while hum.Health>0 and myLoop==smeltLoop and smeltMethod do pressKey(Enum.KeyCode.C); task.wait(0.1) end
    end)
end
player.CharacterAdded:Connect(function(char)
    if smeltMethod then task.spawn(function() startSmeltMethod(char) end) end
end)

-- ===================== AUTO SPAWN CLICK =====================
local function clickGuiObject(obj)
    local ok,pos=pcall(function() return obj.AbsolutePosition end)
    local ok2,sz=pcall(function() return obj.AbsoluteSize end)
    if not ok or not ok2 then return end
    local x=pos.X+sz.X/2; local y=pos.Y+sz.Y/2+50
    VIM:SendMouseButtonEvent(x,y,0,true,game,0); task.wait(0.05); VIM:SendMouseButtonEvent(x,y,0,false,game,0)
end
local SPAWN_KEYWORDS={"spawn","respawn","load","เลือก","เกิด","play","continue","tiếp tục","hồi sinh"}
local function isSpawnButton(btn)
    local txt=string.lower(btn.Text or "")
    for _,kw in ipairs(SPAWN_KEYWORDS) do if txt==kw or txt:find(kw,1,true) then return true end end
    local nm=string.lower(btn.Name or "")
    for _,kw in ipairs(SPAWN_KEYWORDS) do if nm==kw or nm:find(kw,1,true) then return true end end
    return false
end
local function clickSpawnScan()
    local ok,directBtn=pcall(function()
        return player.PlayerGui:WaitForChild("Load",0.1):WaitForChild("Frame",0.1):WaitForChild("Load",0.1)
    end)
    if ok and directBtn and directBtn:IsA("GuiObject") and directBtn.Visible then clickGuiObject(directBtn); return end
    for _,obj in ipairs(player.PlayerGui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible and isSpawnButton(obj) then
            if not obj:IsDescendantOf(game:GetService("CoreGui")) then clickGuiObject(obj); return end
        end
    end
end
local function isFullyAlive()
    local char=player.Character; if not char then return false end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
    local hum=char:FindFirstChild("Humanoid"); if not hum or hum.Health<=0 then return false end
    local ok,btn=pcall(function() return player.PlayerGui:WaitForChild("Load",0):WaitForChild("Frame",0):WaitForChild("Load",0) end)
    if ok and btn and btn.Visible then return false end
    return true
end

local isSpawning=false
local function hookSpawnOnDied(char)
    local hum=char:WaitForChild("Humanoid",10); if not hum then return end
    hum.Died:Connect(function()
        if not autoSpawnClick then return end
        isSpawning=true
        for i=1,60 do
            task.wait(0.5)
            if not autoSpawnClick then isSpawning=false; break end
            if isFullyAlive() then
                task.wait(2)
                for _=1,4 do clickSpawnScan(); task.wait(0.4) end
                isSpawning=false; break
            end
            clickSpawnScan()
        end
        isSpawning=false
    end)
end
player.CharacterAdded:Connect(function(char) hookSpawnOnDied(char) end)
if player.Character then hookSpawnOnDied(player.Character) end
-- FIX: Tăng interval spawn check từ 0.4s → 1s
task.spawn(function()
    while true do
        task.wait(1)
        if not autoSpawnClick then continue end
        if not player.Character then clickSpawnScan(); continue end
        local hum=player.Character:FindFirstChild("Humanoid")
        if hum and hum.Health<=0 then clickSpawnScan(); continue end
        if isSpawning then clickSpawnScan() end
    end
end)

-- Auto click spawn 15 giây khi vào game
task.spawn(function()
    task.wait(2)
    local deadline = tick() + 15
    while tick() < deadline do
        task.wait(0.5)
        clickSpawnScan()
        if isFullyAlive() then break end
    end
end)

-- ===================== ANTI-AFK (tích hợp, không cần nút) =====================
-- FIX: Dùng VirtualUser thay vì loop nặng, tự động chạy nền
task.spawn(function()
    while true do
        task.wait(60)  -- Mỗi 60 giây giả lập 1 action nhỏ
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
    end
end)

-- ===================== AUTO ATTACK + SPAWN TP =====================
-- FIX: Tăng từ 0.03s → 0.07s để giảm CPU load
task.spawn(function()
    while task.wait(0.07) do
        if countSelected()==0 or not autoAttack then continue end
        local char=player.Character; if not char then continue end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local nearest=getNearestMob(); if not nearest then continue end
        local mobHrp=nearest:FindFirstChild("HumanoidRootPart"); if not mobHrp then continue end
        if autoSpawnTP then hrp.CFrame=mobHrp.CFrame*CFrame.new(0,0,2) end
        VirtualUser:Button1Down(Vector2.new(500,500),workspace.CurrentCamera.CFrame)
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(500,500),workspace.CurrentCamera.CFrame)
    end
end)

-- ===================== AUTO CHEST =====================
local function hopServer()
    local gameId=game.PlaceId
    local ok,result=pcall(function()
        return HttpService:JSONDecode(game:HttpGetAsync(
            ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(gameId)
        ))
    end)
    if not ok then return end
    for _,server in ipairs(result.data) do
        if server.playing>=9 and server.playing<server.maxPlayers and server.id~=game.JobId then
            TeleportService:TeleportToPlaceInstance(gameId,server.id,player); return
        end
    end
end
local function tweenToChest(chest)
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local ok,targetPos=pcall(function() return chest:GetPivot().Position end)
    if not ok or not chest.Parent then return end
    local startPos=hrp.Position
    hrp.CFrame=CFrame.new(Vector3.new(startPos.X,startPos.Y+400,startPos.Z)); task.wait(0.3)
    if not chest.Parent then return end
    hrp.CFrame=CFrame.new(targetPos+Vector3.new(0,3,0)); task.wait(0.3)
end
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj.Name=="TreasureChest" and autoChestOn then task.wait(0.3); tweenToChest(obj) end
end)

-- ===================== AUTO FISHING =====================
local fishCount=0; local fishRemote=nil; local ropeConn=nil
local function findMyRope()
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local closest,closestDist=nil,math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name=="Bobber" and v:IsA("BasePart") then
            local dist=(v.Position-hrp.Position).Magnitude
            if dist<closestDist then closestDist=dist; closest=v.Parent end
        end
    end
    return closest
end
local function setupFishing()
    pcall(function()
        fishRemote=game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FishingEvent",5)
    end)
    if not fishRemote then return end
    local function handleMinigame()
        local done=false
        local conn=fishRemote.OnClientEvent:Connect(function(event) if event=="FishingReeled" then done=true end end)
        for i=1,80 do
            if done or not fishRunning then break end
            for _,v in pairs(player.PlayerGui:GetDescendants()) do
                local ok,visible=pcall(function() return v.Visible end)
                if ok and visible and v:IsA("TextButton") and v:GetFullName():find("FishingMinigame") then
                    if v.BackgroundColor3.R>0.8 then
                        local abs=v.AbsolutePosition; local size=v.AbsoluteSize
                        clickPos(abs.X+size.X/2,abs.Y+size.Y/2+30); break
                    end
                end
            end
            task.wait(0.4)
        end
        conn:Disconnect(); fishCount+=1; task.wait(1.5)
        if fishRunning then clickPos(CAST_X,CAST_Y) end
    end
    fishRemote.OnClientEvent:Connect(function(event)
        if not fishRunning then return end
        if event=="FishingLaunched" then
            if ropeConn then pcall(function() ropeConn:Disconnect() end); ropeConn=nil end
            task.wait(1.5); local rope=findMyRope(); if not rope then return end
            ropeConn=rope.DescendantAdded:Connect(function(obj)
                if obj.Name=="Sparkles" then
                    pcall(function() ropeConn:Disconnect() end); ropeConn=nil; task.wait(0.1)
                    clickPos(CAST_X,CAST_Y)
                    local gotMinigame=false; local checkConn
                    checkConn=fishRemote.OnClientEvent:Connect(function(e)
                        if e=="FishingMinigame" then gotMinigame=true; checkConn:Disconnect() end
                    end)
                    task.wait(1.5); checkConn:Disconnect()
                    if not gotMinigame then fishCount+=1; task.wait(1.5); if fishRunning then clickPos(CAST_X,CAST_Y) end end
                end
            end)
        end
        if event=="FishingMinigame" then task.spawn(handleMinigame) end
    end)
end

-- ===================== AUTO SKILL on Spawn =====================
player.CharacterAdded:Connect(function(char)
    task.wait(3)
    local keyMap={Z=Enum.KeyCode.Z,X=Enum.KeyCode.X,C=Enum.KeyCode.C,V=Enum.KeyCode.V,E=Enum.KeyCode.E,R=Enum.KeyCode.R}
    for k,on in pairs(spawnSkills) do if on then pressKey(keyMap[k]) end end
end)

-- ===================== KAITUN UI LOGIC =====================
local kaitunGui = nil
local _setKaitunToggle = nil

local function buildKaitunUI()
    if kaitunGui then pcall(function() kaitunGui:Destroy() end) end
    kaitunGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    kaitunGui.Name = "TuanhKaitunUI"; kaitunGui.ResetOnSpawn = false; kaitunGui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", kaitunGui)
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(0,0,0); bg.BorderSizePixel = 0

    local function mkLbl(text, color, posY)
        local l = Instance.new("TextLabel", bg); l.BackgroundTransparency = 1
        l.AnchorPoint = Vector2.new(0.5,0); l.Position = UDim2.new(0.5,0,posY,0)
        l.Size = UDim2.new(0,700,0,40); l.Font = Enum.Font.GothamBold; l.TextScaled = true
        l.TextColor3 = color; l.Text = text
        local c = Instance.new("UITextSizeConstraint",l); c.MaxTextSize = 36; c.MinTextSize = 14
        return l
    end

    local titleL = Instance.new("TextLabel", bg); titleL.BackgroundTransparency = 1
    titleL.AnchorPoint = Vector2.new(0.5,0); titleL.Position = UDim2.new(0.5,0,0.25,0)
    titleL.Size = UDim2.new(0,700,0,80); titleL.Text = "TuanhKaitun"
    titleL.Font = Enum.Font.GothamBlack; titleL.TextScaled = true
    titleL.TextColor3 = Color3.fromRGB(255,230,120); titleL.TextStrokeTransparency = 0.3
    titleL.TextStrokeColor3 = Color3.fromRGB(180,140,0)
    local tc = Instance.new("UITextSizeConstraint", titleL); tc.MaxTextSize = 80; tc.MinTextSize = 50

    local hideBtn = Instance.new("TextButton", bg)
    hideBtn.Size = UDim2.new(0,40,0,40); hideBtn.Position = UDim2.new(1,-50,0,10)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255,60,60); hideBtn.BorderSizePixel = 0
    hideBtn.Text = "X"; hideBtn.TextScaled = true; hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextColor3 = Color3.new(1,1,1)
    hideBtn.MouseButton1Click:Connect(function()
        kaitunOn = false
        bg.Visible = false
        if _setKaitunToggle then _setKaitunToggle(false) end
    end)

    local beriLbl   = mkLbl("Beri : Loading...",   Color3.fromRGB(255,215,0),  0.38)
    local killsLbl  = mkLbl("Kills : Loading...",  Color3.fromRGB(255,120,120),0.43)
    local bountyLbl = mkLbl("Bounty : Loading...", Color3.fromRGB(255,100,255),0.48)
    local gameLbl   = mkLbl("Game : Loading...",   Color3.fromRGB(255,255,255),0.53)
    local timeLbl   = mkLbl("Time : 0s",           Color3.fromRGB(0,255,255),  0.58)
    mkLbl("Status : Farm Beri", Color3.fromRGB(0,255,100), 0.63)

    local gameName = "Unknown"
    pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    gameLbl.Text = "Game : " .. gameName

    local elapsed = 0
    task.spawn(function()
        while kaitunOn and kaitunGui and kaitunGui.Parent do
            task.wait(1); elapsed += 1; timeLbl.Text = "Time : " .. elapsed .. "s"
        end
    end)
    task.spawn(function()
        while kaitunOn and kaitunGui and kaitunGui.Parent do
            task.wait(1)
            pcall(function()
                local stats = player.PlayerGui.Menu.Frame.MenuList.Stats.Frame.A
                beriLbl.Text   = "Beri : "   .. stats.Beri.BeriAmount.Text
                killsLbl.Text  = "Kills : "  .. stats.Kills.KillsAmount.Text
                bountyLbl.Text = "Bounty : " .. stats.Bounty.BountyAmount.Text
            end)
        end
    end)
end

-- ===================== BOSS HELPERS =====================
local function getBackpackItemCount(itemName)
    local count = 0
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool.Name == itemName then count += 1 end
        end
    end
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == itemName then count += 1 end
        end
    end
    return count
end

local function findBossByName(bossName)
    for _, mob in ipairs(workspace.Alive:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        if mob.Name == bossName and hum and hum.Health > 0 then
            return mob
        end
    end
    return nil
end

local function tpToBoss(mob)
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local mobHrp = mob:FindFirstChild("HumanoidRootPart"); if not mobHrp then return end
    hrp.CFrame = mobHrp.CFrame * CFrame.new(0, 0, 3)
end

local function doAutoClick()
    VirtualUser:Button1Down(Vector2.new(500,500), workspace.CurrentCamera.CFrame)
    task.wait(0.05)
    VirtualUser:Button1Up(Vector2.new(500,500), workspace.CurrentCamera.CFrame)
end

-- FIX: Tăng task.wait boss loop từ 0.03 → 0.1 để tránh crash
local function farmBossUntilDrop(bossName, dropItemName, statusLbl, getToggle)
    local startCount = getBackpackItemCount(dropItemName)
    while getToggle() do
        local boss = findBossByName(bossName)
        if boss then
            tpToBoss(boss)
            doAutoClick()
        end
        local currentCount = getBackpackItemCount(dropItemName)
        if currentCount > startCount then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = ITEM_DROP_CF end
            if statusLbl then
                statusLbl.Text = "✅ Nhận được " .. dropItemName .. "! Đã TP!"
                statusLbl.TextColor3 = Color3.fromRGB(80,255,140)
            end
            task.wait(2)
            return true
        end
        if statusLbl then
            statusLbl.Text = "⚔ Đang đánh " .. bossName .. "..."
        end
        task.wait(0.1)  -- FIX: 0.03 → 0.1
    end
    return false
end

local function farmBossLoop(bossName, statusLbl, getToggle)
    while getToggle() do
        local boss = findBossByName(bossName)
        if boss then
            tpToBoss(boss)
            doAutoClick()
            if statusLbl then
                statusLbl.Text = "⚔ Đang đánh " .. bossName .. "..."
                statusLbl.TextColor3 = Color3.fromRGB(0,200,255)
            end
        else
            if statusLbl then
                statusLbl.Text = "🔍 Tìm " .. bossName .. "..."
                statusLbl.TextColor3 = Color3.fromRGB(255,200,60)
            end
        end
        task.wait(0.1)  -- FIX: 0.03 → 0.1
    end
end

-- ===================== AUTO SAM QUEST LOGIC =====================
local function clickBtn(btn)
    local pos = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + 47
    VIM:SendMouseMoveEvent(x, y, game)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function doQuestTurnIn(statusLbl)
    if statusLbl then statusLbl.Text = "🚶 Đang TP đến Sam..."; statusLbl.TextColor3 = Color3.fromRGB(255,200,60) end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local samHrp = workspace.Ignore.NPCs.DailyQuest.Sam:FindFirstChild("HumanoidRootPart")
    if hrp and samHrp then
        hrp.CFrame = samHrp.CFrame * CFrame.new(0, 0, 3)
    end
    task.wait(0.5)
    local cd = workspace.Ignore.NPCs.DailyQuest.Sam.HumanoidRootPart:FindFirstChild("ClickDetector")
    if cd then fireclickdetector(cd) end
    task.wait(2)
    if statusLbl then statusLbl.Text = "💬 Đang chọn dialogue..."; statusLbl.TextColor3 = Color3.fromRGB(0,200,255) end
    for i = 1, 2 do
        local ok, btn = pcall(function()
            return player.PlayerGui.QuestGui.Dialogue.Options.Option
        end)
        if ok and btn and btn.Visible then
            clickBtn(btn)
        end
        task.wait(2)
    end
    local ok2, leaveBtn = pcall(function()
        return player.PlayerGui.QuestGui.Dialogue.Options.Leave
    end)
    if ok2 and leaveBtn and leaveBtn.Visible then
        clickBtn(leaveBtn)
    end
    if statusLbl then statusLbl.Text = "✅ Đã nộp quest!"; statusLbl.TextColor3 = Color3.fromRGB(80,255,140) end
end

-- ===================== TELEPORT DATA =====================
local LOCATIONS={
    {name="Sam Island",          pos=Vector3.new(-1281.50,219.50,-1355.40)},
    {name="Cave Island",         pos=Vector3.new(-130.49,217.50,-803.63)},
    {name="Sand Island",         pos=Vector3.new(4.90,217.50,-253.72)},
    {name="Cave Demon Island",   pos=Vector3.new(2057.88,491.57,-710.08)},
    {name="Cooker Island",       pos=Vector3.new(1935.53,219.12,624.92)},
    {name="Island",              pos=Vector3.new(3200.91,363.87,1656.79)},
    {name="Bar Island",          pos=Vector3.new(1510.47,257.50,2107.28)},
    {name="Anna Island",         pos=Vector3.new(1104.84,224.48,3309.76)},
    {name="Crocodile Island",    pos=Vector3.new(613.63,413.34,5062.39)},
    {name="Small Snow",          pos=Vector3.new(-2045.68,299.77,3408.32)},
    {name="Rayleigh Island",     pos=Vector3.new(-1037.89,4013.46,10146.07)},
    {name="Vokun Island",        pos=Vector3.new(4897.70,539.82,5125.11)},
    {name="Jungle Island",       pos=Vector3.new(-6018.12,409.00,22.71)},
    {name="Marin Island",        pos=Vector3.new(-2981.21,1113.81,-4255.74)},
    {name="Purple Island",       pos=Vector3.new(-5265.23,529.01,-7842.21)},
    {name="Small Desert Island", pos=Vector3.new(960.25,288.26,-3211.81)},
    {name="Boss Island",         pos=Vector3.new(4856.36,583.45,-7150.02)},
    {name="Big Snow",            pos=Vector3.new(6378.64,543.45,-1330.23)},
    {name="Jung Island",         pos=Vector3.new(-10757.76,226.18,-2886.13)},
    {name="??? Island",          pos=Vector3.new(-11522.04,217.43,5992.07)},
}

-- ===================== GUI SETUP =====================
local oldGui=game:GetService("CoreGui"):FindFirstChild("TuanhFarmHub_V8")
if oldGui then oldGui:Destroy() end
local oldV7=game:GetService("CoreGui"):FindFirstChild("TuanhFarmHub_V7")
if oldV7 then oldV7:Destroy() end
local oldToggle=game:GetService("CoreGui"):FindFirstChild("TuanhToggleBtn")
if oldToggle then oldToggle:Destroy() end

local C={
    bg=Color3.fromRGB(12,12,22), panel=Color3.fromRGB(18,18,34),
    card=Color3.fromRGB(26,26,46), sidebar=Color3.fromRGB(15,15,28),
    accent=Color3.fromRGB(120,55,255), accentHi=Color3.fromRGB(160,100,255),
    green=Color3.fromRGB(80,255,140), cyan=Color3.fromRGB(0,200,255),
    yellow=Color3.fromRGB(255,200,60), red=Color3.fromRGB(255,80,80),
    orange=Color3.fromRGB(255,140,0), white=Color3.fromRGB(230,230,245),
    muted=Color3.fromRGB(100,100,130), selBg=Color3.fromRGB(50,18,140),
    border=Color3.fromRGB(40,35,80),
}
local function corner(r,obj) local c=Instance.new("UICorner",obj); c.CornerRadius=UDim.new(0,r) end
local function stroke(obj,color,thick) local s=Instance.new("UIStroke",obj); s.Color=color or C.border; s.Thickness=thick or 1 end
local function newLabel(parent,text,size,color,xAlign)
    local l=Instance.new("TextLabel",parent); l.BackgroundTransparency=1
    l.Text=text; l.TextColor3=color or C.white; l.TextSize=size or 12
    l.Font=Enum.Font.GothamBold; l.TextXAlignment=xAlign or Enum.TextXAlignment.Left
    return l
end
local function secLabel(parent,text,y)
    local l=newLabel(parent,text,9,C.muted); l.Size=UDim2.new(1,0,0,14); l.Position=UDim2.new(0,2,0,y)
end

local TOTAL_W=700; local TOTAL_H=440; local SIDEBAR_W=165

local gui=Instance.new("ScreenGui",game:GetService("CoreGui"))
gui.ResetOnSpawn=false; gui.Name="TuanhFarmHub_V8"; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,TOTAL_W,0,TOTAL_H); main.Position=UDim2.new(0.5,-TOTAL_W/2,0.5,-TOTAL_H/2)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.Active=true; main.Draggable=true
corner(10,main); stroke(main,C.accent,1.5)
main.Visible=false

local titleBar=Instance.new("Frame",main)
titleBar.Size=UDim2.new(1,0,0,34); titleBar.BackgroundColor3=C.accent; titleBar.BorderSizePixel=0; corner(10,titleBar)
local tbFlat=Instance.new("Frame",titleBar); tbFlat.Size=UDim2.new(1,0,0.5,0); tbFlat.Position=UDim2.new(0,0,0.5,0); tbFlat.BackgroundColor3=C.accent; tbFlat.BorderSizePixel=0
local tGrad=Instance.new("UIGradient",titleBar)
tGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(145,65,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(75,20,200))})
tGrad.Rotation=90
local titleTxt=newLabel(titleBar,"⚔  TUANH FARM HUB  V.008",13,Color3.fromRGB(255,255,255))
titleTxt.Size=UDim2.new(1,-90,1,0); titleTxt.Position=UDim2.new(0,12,0,0)
local freeTag=Instance.new("Frame",titleBar); freeTag.Size=UDim2.new(0,72,0,18); freeTag.Position=UDim2.new(1,-130,0.5,-9)
freeTag.BackgroundColor3=Color3.fromRGB(255,200,0); freeTag.BorderSizePixel=0; corner(4,freeTag)
local freeTxt=newLabel(freeTag,"FREEMIUM",9,Color3.fromRGB(20,20,20),Enum.TextXAlignment.Center); freeTxt.Size=UDim2.new(1,0,1,0)
local closeBtn=Instance.new("TextButton",titleBar)
closeBtn.Size=UDim2.new(0,26,0,20); closeBtn.Position=UDim2.new(1,-32,0.5,-10)
closeBtn.BackgroundColor3=Color3.fromRGB(200,50,50); closeBtn.BorderSizePixel=0
closeBtn.Text="✕"; closeBtn.TextColor3=Color3.fromRGB(255,255,255); closeBtn.TextSize=11; closeBtn.Font=Enum.Font.GothamBold; corner(5,closeBtn)

local sidebar=Instance.new("Frame",main)
sidebar.Size=UDim2.new(0,SIDEBAR_W,1,-34); sidebar.Position=UDim2.new(0,0,0,34); sidebar.BackgroundColor3=C.sidebar; sidebar.BorderSizePixel=0
local divider=Instance.new("Frame",main); divider.Size=UDim2.new(0,1,1,-34); divider.Position=UDim2.new(0,SIDEBAR_W,0,34); divider.BackgroundColor3=C.border; divider.BorderSizePixel=0
local contentArea=Instance.new("Frame",main)
contentArea.Size=UDim2.new(0,TOTAL_W-SIDEBAR_W-1,1,-34); contentArea.Position=UDim2.new(0,SIDEBAR_W+1,0,34)
contentArea.BackgroundColor3=C.panel; contentArea.BorderSizePixel=0; corner(10,contentArea)
local caFlat=Instance.new("Frame",contentArea); caFlat.Size=UDim2.new(0,10,1,0); caFlat.BackgroundColor3=C.panel; caFlat.BorderSizePixel=0

local tabs={}; local activeTab=nil
local tabLayout=Instance.new("UIListLayout",sidebar); tabLayout.Padding=UDim.new(0,3); tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
local tabPad=Instance.new("UIPadding",sidebar); tabPad.PaddingTop=UDim.new(0,10); tabPad.PaddingLeft=UDim.new(0,8); tabPad.PaddingRight=UDim.new(0,8)

local function newPage()
    local page=Instance.new("Frame",contentArea)
    page.Size=UDim2.new(1,-12,1,-10); page.Position=UDim2.new(0,6,0,5)
    page.BackgroundTransparency=1; page.Visible=false; return page
end
local function makeTab(name,icon,order)
    local page=newPage()
    local btn=Instance.new("TextButton",sidebar)
    btn.Size=UDim2.new(1,0,0,32); btn.BackgroundColor3=C.card; btn.BorderSizePixel=0
    btn.Text=icon.."  "..name; btn.TextColor3=C.muted; btn.TextSize=11
    btn.Font=Enum.Font.GothamBold; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.LayoutOrder=order; corner(7,btn)
    local p=Instance.new("UIPadding",btn); p.PaddingLeft=UDim.new(0,10)
    local activeBar=Instance.new("Frame",btn)
    activeBar.Size=UDim2.new(0,3,0.7,0); activeBar.Position=UDim2.new(0,-10,0.15,0)
    activeBar.BackgroundColor3=C.accent; activeBar.BorderSizePixel=0; activeBar.Visible=false; corner(2,activeBar)
    tabs[name]={btn=btn,page=page,bar=activeBar}
    btn.MouseButton1Click:Connect(function()
        for _,t in pairs(tabs) do t.page.Visible=false; t.btn.BackgroundColor3=C.card; t.btn.TextColor3=C.muted; t.bar.Visible=false end
        page.Visible=true; btn.BackgroundColor3=C.selBg; btn.TextColor3=C.white; activeBar.Visible=true; activeTab=name
    end)
    return page
end

local pageAutoFarm  = makeTab("Auto Farm",   "⚔",1)
local pageMethod    = makeTab("Method Farm", "✈",2)
local pageBoss      = makeTab("Boss",        "💀",3)
local pageAutoSam   = makeTab("Auto Sam",    "📋",4)
local pageAutoChest = makeTab("Auto Chest",  "🎁",5)
local pageAutoFish  = makeTab("Auto Fish",   "🎣",6)
local pageAutoSkill = makeTab("Auto Skill",  "⚡",7)
local pageTeleport  = makeTab("Teleport",    "🗺",8)
local pageTpFruit   = makeTab("TP Fruit",    "🍎",9)
local pageKaitun    = makeTab("Kaitun UI",   "👁",10)
local pageSetting   = makeTab("Setting",     "⚙",11)

local verLbl=newLabel(sidebar,"V.008",9,C.muted,Enum.TextXAlignment.Center)
verLbl.Size=UDim2.new(1,0,0,14); verLbl.Position=UDim2.new(0,0,1,-18)

-- ===================== REUSABLE TOGGLE =====================
local function makeToggle(parent,text,yPos,onColor,initState)
    local frame=Instance.new("Frame",parent)
    frame.Size=UDim2.new(1,0,0,30); frame.Position=UDim2.new(0,0,0,yPos)
    frame.BackgroundColor3=C.card; frame.BorderSizePixel=0; corner(7,frame); stroke(frame,C.border,1)
    local pill=Instance.new("Frame",frame)
    pill.Size=UDim2.new(0,30,0,14); pill.Position=UDim2.new(1,-36,0.5,-7)
    pill.BackgroundColor3=C.muted; pill.BorderSizePixel=0; corner(7,pill)
    local dot=Instance.new("Frame",pill)
    dot.Size=UDim2.new(0,12,0,12); dot.Position=UDim2.new(0,1,0,1)
    dot.BackgroundColor3=Color3.fromRGB(180,180,200); dot.BorderSizePixel=0; corner(6,dot)
    local btn=Instance.new("TextButton",frame)
    btn.Size=UDim2.new(1,-42,1,0); btn.BackgroundTransparency=1
    btn.Text=text; btn.TextColor3=C.muted; btn.TextSize=11
    btn.Font=Enum.Font.GothamBold; btn.TextXAlignment=Enum.TextXAlignment.Left
    local pp=Instance.new("UIPadding",btn); pp.PaddingLeft=UDim.new(0,10)
    local state=false
    local function set(v)
        state=v
        if v then frame.BackgroundColor3=Color3.fromRGB(22,12,55); pill.BackgroundColor3=onColor; dot.Position=UDim2.new(0,17,0,1); dot.BackgroundColor3=Color3.fromRGB(255,255,255); btn.TextColor3=onColor
        else frame.BackgroundColor3=C.card; pill.BackgroundColor3=C.muted; dot.Position=UDim2.new(0,1,0,1); dot.BackgroundColor3=Color3.fromRGB(180,180,200); btn.TextColor3=C.muted end
    end
    btn.MouseButton1Click:Connect(function() set(not state) end)
    if initState then set(true) end
    return btn,function() return state end,set
end

-- ===================== PAGE: AUTO FARM =====================
do
    local page=pageAutoFarm
    secLabel(page,"MOB LIST",0)
    local searchBox=Instance.new("TextBox",page)
    searchBox.Size=UDim2.new(0.62,0,0,26); searchBox.Position=UDim2.new(0,0,0,16)
    searchBox.BackgroundColor3=C.card; searchBox.BorderSizePixel=0
    searchBox.PlaceholderText="🔍 Search..."; searchBox.Text=""
    searchBox.TextColor3=C.white; searchBox.PlaceholderColor3=C.muted
    searchBox.TextSize=11; searchBox.Font=Enum.Font.Gotham; searchBox.ClearTextOnFocus=false
    corner(6,searchBox); stroke(searchBox,C.accent,1)
    local sp=Instance.new("UIPadding",searchBox); sp.PaddingLeft=UDim.new(0,7)
    local reloadBtn=Instance.new("TextButton",page)
    reloadBtn.Size=UDim2.new(0.35,0,0,26); reloadBtn.Position=UDim2.new(0.65,0,0,16)
    reloadBtn.BackgroundColor3=C.accent; reloadBtn.BorderSizePixel=0
    reloadBtn.Text="🔄 Reload"; reloadBtn.TextColor3=Color3.fromRGB(255,255,255)
    reloadBtn.TextSize=10; reloadBtn.Font=Enum.Font.GothamBold; corner(6,reloadBtn)
    local scroll=Instance.new("ScrollingFrame",page)
    scroll.Size=UDim2.new(1,0,0,118); scroll.Position=UDim2.new(0,0,0,46)
    scroll.BackgroundColor3=C.card; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3; scroll.ScrollBarImageColor3=C.accent
    scroll.CanvasSize=UDim2.new(0,0,0,0); corner(7,scroll); stroke(scroll,C.border,1)
    local ll=Instance.new("UIListLayout",scroll); ll.Padding=UDim.new(0,2)
    local lp2=Instance.new("UIPadding",scroll); lp2.PaddingTop=UDim.new(0,4); lp2.PaddingLeft=UDim.new(0,4); lp2.PaddingRight=UDim.new(0,4); lp2.PaddingBottom=UDim.new(0,4)
    secLabel(page,"TARGET INFO",170)
    local infoFrame=Instance.new("Frame",page)
    infoFrame.Size=UDim2.new(1,0,0,64); infoFrame.Position=UDim2.new(0,0,0,186)
    infoFrame.BackgroundColor3=C.card; infoFrame.BorderSizePixel=0; corner(7,infoFrame); stroke(infoFrame,C.border,1)
    local ip=Instance.new("UIPadding",infoFrame); ip.PaddingLeft=UDim.new(0,8); ip.PaddingTop=UDim.new(0,6)
    local selLabel=newLabel(infoFrame,"🎯  Selected: --",11,C.cyan); selLabel.Size=UDim2.new(1,-8,0,18)
    local alvLabel=newLabel(infoFrame,"📊  Alive: --",11,C.yellow); alvLabel.Size=UDim2.new(0.5,0,0,18); alvLabel.Position=UDim2.new(0,0,0,22)
    local dstLabel=newLabel(infoFrame,"📏  Dist: --",11,C.green); dstLabel.Size=UDim2.new(0.5,0,0,18); dstLabel.Position=UDim2.new(0.5,0,0,22)
    local hpLbl=newLabel(infoFrame,"❤️  HP: --",11,C.red); hpLbl.Size=UDim2.new(1,-8,0,18); hpLbl.Position=UDim2.new(0,0,0,44)
    secLabel(page,"CONTROLS",258)
    local _,getAA,setAA=makeToggle(page,"⚔  Auto Attack",274,C.green,autoAttack)
    local _,getATP,setATP=makeToggle(page,"✈  Auto Spawn TP",308,C.cyan,autoSpawnTP)
    local _,getASC,setASC=makeToggle(page,"🖱  Auto Spawn Click",342,C.yellow,autoSpawnClick)
    local spawnDebugLbl=newLabel(page,"SpawnClick: OFF",9,C.muted)
    spawnDebugLbl.Size=UDim2.new(1,0,0,12); spawnDebugLbl.Position=UDim2.new(0,2,0,376)
    local statusLbl=newLabel(page,"● Idle",10,C.muted)
    statusLbl.Size=UDim2.new(1,0,0,14); statusLbl.Position=UDim2.new(0,2,1,-16)

    -- FIX: Dùng task.spawn poll thay vì Heartbeat để tránh 60fps UI update
    task.spawn(function()
        while true do
            task.wait(0.2)
            autoAttack=getAA(); autoSpawnTP=getATP(); autoSpawnClick=getASC()
            if autoSpawnClick then spawnDebugLbl.Text="SpawnClick: ON ✅"; spawnDebugLbl.TextColor3=C.green
            else spawnDebugLbl.Text="SpawnClick: OFF"; spawnDebugLbl.TextColor3=C.muted end
        end
    end)

    local allMobs={}
    local function buildList(filter)
        for _,v in ipairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        for _,name in ipairs(allMobs) do
            if filter=="" or name:lower():find(filter:lower(),1,true) then
                local row=Instance.new("Frame",scroll)
                row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=selectedMobs[name] and C.selBg or C.card; row.BorderSizePixel=0; corner(5,row)
                local bar=Instance.new("Frame",row); bar.Size=UDim2.new(0,3,0.7,0); bar.Position=UDim2.new(0,2,0.15,0); bar.BackgroundColor3=C.accent; bar.BorderSizePixel=0; bar.Visible=selectedMobs[name]==true; corner(2,bar)
                local rbtn=Instance.new("TextButton",row); rbtn.Size=UDim2.new(1,0,1,0); rbtn.BackgroundTransparency=1
                rbtn.Text="👾  "..name; rbtn.TextColor3=selectedMobs[name] and C.white or C.muted; rbtn.TextSize=10; rbtn.Font=Enum.Font.GothamBold; rbtn.TextXAlignment=Enum.TextXAlignment.Left
                local pp=Instance.new("UIPadding",rbtn); pp.PaddingLeft=UDim.new(0,10)
                rbtn.MouseButton1Click:Connect(function()
                    if selectedMobs[name] then selectedMobs[name]=nil; row.BackgroundColor3=C.card; rbtn.TextColor3=C.muted; bar.Visible=false
                    else selectedMobs[name]=true; row.BackgroundColor3=C.selBg; rbtn.TextColor3=C.white; bar.Visible=true end
                    local cnt=countSelected()
                    if cnt==0 then selLabel.Text="🎯  Selected: --"; statusLbl.Text="● Idle"; statusLbl.TextColor3=C.muted
                    elseif cnt==1 then local n=next(selectedMobs); selLabel.Text="🎯  Selected: "..n; statusLbl.Text="● Farming "..n; statusLbl.TextColor3=C.green
                    else selLabel.Text="🎯  Selected: "..cnt.." mobs"; statusLbl.Text="● Multi-farm ("..cnt..")"; statusLbl.TextColor3=C.green end
                end)
            end
        end
        scroll.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+8)
    end
    local function refreshMobs() allMobs=getMobs(); buildList(searchBox.Text) end
    reloadBtn.MouseButton1Click:Connect(function() reloadBtn.Text="⏳"; refreshMobs(); task.delay(0.4,function() reloadBtn.Text="🔄 Reload" end) end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function() buildList(searchBox.Text) end)

    -- FIX: Mob list chỉ rebuild mỗi 3 giây thay vì mỗi khi có ChildAdded/Removed
    local mobRefreshThrottle = 0
    workspace.Alive.ChildAdded:Connect(function()
        local now = tick()
        if now - mobRefreshThrottle > 3 then
            mobRefreshThrottle = now
            task.wait(0.5); refreshMobs()
        end
    end)
    workspace.Alive.ChildRemoved:Connect(function()
        local now = tick()
        if now - mobRefreshThrottle > 3 then
            mobRefreshThrottle = now
            task.wait(0.5); refreshMobs()
        end
    end)

    -- FIX: Info update mỗi 1s thay vì 0.5s
    task.spawn(function()
        while true do
            task.wait(1)
            if countSelected()>0 then
                local nearest,dist=getNearestMob()
                local total=0; for n in pairs(selectedMobs) do total+=getAliveCount(n) end
                alvLabel.Text="📊  Alive: "..total
                if nearest then
                    local hum=nearest:FindFirstChild("Humanoid"); local hp=hum and math.floor(hum.Health/hum.MaxHealth*100) or 0
                    dstLabel.Text="📏  Dist: "..math.floor(dist or 0); hpLbl.Text="❤️  HP: "..hp.."%"
                else dstLabel.Text="📏  Dist: --"; hpLbl.Text="❤️  HP: --" end
            end
        end
    end)
    refreshMobs()
end

-- ===================== PAGE: METHOD FARM =====================
do
    local page=pageMethod; secLabel(page,"METHOD",0)
    local smeltFrame=Instance.new("Frame",page); smeltFrame.Size=UDim2.new(1,0,0,34); smeltFrame.Position=UDim2.new(0,0,0,16); smeltFrame.BackgroundColor3=C.card; smeltFrame.BorderSizePixel=0; corner(7,smeltFrame); stroke(smeltFrame,C.border,1)
    local sPill=Instance.new("Frame",smeltFrame); sPill.Size=UDim2.new(0,32,0,16); sPill.Position=UDim2.new(1,-38,0.5,-8); sPill.BackgroundColor3=C.muted; sPill.BorderSizePixel=0; corner(8,sPill)
    local sDot=Instance.new("Frame",sPill); sDot.Size=UDim2.new(0,14,0,14); sDot.Position=UDim2.new(0,1,0,1); sDot.BackgroundColor3=Color3.fromRGB(180,180,200); sDot.BorderSizePixel=0; corner(7,sDot)
    local sBtn=Instance.new("TextButton",smeltFrame); sBtn.Size=UDim2.new(1,-46,1,0); sBtn.BackgroundTransparency=1; sBtn.Text="🔥  Smelt Method Farm"; sBtn.TextColor3=C.muted; sBtn.TextSize=12; sBtn.Font=Enum.Font.GothamBold; sBtn.TextXAlignment=Enum.TextXAlignment.Left
    local sp2=Instance.new("UIPadding",sBtn); sp2.PaddingLeft=UDim.new(0,12)
    local function setSmelt(v)
        smeltMethod=v
        if v then smeltFrame.BackgroundColor3=Color3.fromRGB(28,14,65); sPill.BackgroundColor3=C.yellow; sDot.Position=UDim2.new(0,17,0,1); sDot.BackgroundColor3=Color3.fromRGB(255,255,255); sBtn.TextColor3=C.yellow
            local char=player.Character; if char then task.spawn(function() startSmeltMethod(char) end) end
        else smeltFrame.BackgroundColor3=C.card; sPill.BackgroundColor3=C.muted; sDot.Position=UDim2.new(0,1,0,1); sDot.BackgroundColor3=Color3.fromRGB(180,180,200); sBtn.TextColor3=C.muted; smeltLoop+=1 end
    end
    sBtn.MouseButton1Click:Connect(function() setSmelt(not smeltMethod) end)
    if smeltMethod then setSmelt(true) end
    local descCard=Instance.new("Frame",page); descCard.Size=UDim2.new(1,0,0,80); descCard.Position=UDim2.new(0,0,0,56); descCard.BackgroundColor3=C.card; descCard.BorderSizePixel=0; corner(7,descCard); stroke(descCard,C.border,1)
    local dp=Instance.new("UIPadding",descCard); dp.PaddingLeft=UDim.new(0,10); dp.PaddingTop=UDim.new(0,8); dp.PaddingRight=UDim.new(0,10)
    local descTxt=Instance.new("TextLabel",descCard); descTxt.Size=UDim2.new(1,0,1,0); descTxt.BackgroundTransparency=1
    descTxt.Text="Smelt Method:\n• Z → skill 1 (1 lần)\n• X → skill 2 (1 lần)\n• Spam C → skill 3 liên tục\n• Re-activates sau mỗi lần chết"
    descTxt.TextColor3=C.muted; descTxt.TextSize=11; descTxt.Font=Enum.Font.Gotham; descTxt.TextXAlignment=Enum.TextXAlignment.Left; descTxt.TextYAlignment=Enum.TextYAlignment.Top; descTxt.TextWrapped=true
    secLabel(page,"WEAPON",142)
    local weaponDisplay=Instance.new("TextButton",page); weaponDisplay.Size=UDim2.new(1,-68,0,30); weaponDisplay.Position=UDim2.new(0,0,0,158); weaponDisplay.BackgroundColor3=C.card; weaponDisplay.BorderSizePixel=0
    weaponDisplay.Text=equippedWeapon and ("🗡  "..equippedWeapon.."  ▼") or "🗡  None selected  ▼"; weaponDisplay.TextColor3=equippedWeapon and C.white or C.muted; weaponDisplay.TextSize=11; weaponDisplay.Font=Enum.Font.GothamBold; weaponDisplay.TextXAlignment=Enum.TextXAlignment.Left
    corner(6,weaponDisplay); stroke(weaponDisplay,C.accent,1); local wdp=Instance.new("UIPadding",weaponDisplay); wdp.PaddingLeft=UDim.new(0,10)
    local weaponDropdown=Instance.new("Frame",page); weaponDropdown.Size=UDim2.new(1,0,0,0); weaponDropdown.Position=UDim2.new(0,0,0,190); weaponDropdown.BackgroundColor3=C.selBg; weaponDropdown.BorderSizePixel=0; weaponDropdown.Visible=false; weaponDropdown.ClipsDescendants=true; corner(6,weaponDropdown); stroke(weaponDropdown,C.accent,1)
    local wScroll=Instance.new("ScrollingFrame",weaponDropdown); wScroll.Size=UDim2.new(1,0,1,0); wScroll.BackgroundTransparency=1; wScroll.BorderSizePixel=0; wScroll.ScrollBarThickness=3; wScroll.ScrollBarImageColor3=C.accent; wScroll.CanvasSize=UDim2.new(0,0,0,0)
    local wll=Instance.new("UIListLayout",wScroll); wll.Padding=UDim.new(0,2)
    local wlp2=Instance.new("UIPadding",wScroll); wlp2.PaddingTop=UDim.new(0,4); wlp2.PaddingLeft=UDim.new(0,4); wlp2.PaddingRight=UDim.new(0,4); wlp2.PaddingBottom=UDim.new(0,4)
    local dropOpen=false
    local function buildWeaponList()
        for _,v in ipairs(wScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local weapons=getWeapons(); table.insert(weapons,1,"(None)")
        for _,wname in ipairs(weapons) do
            local wb=Instance.new("TextButton",wScroll); wb.Size=UDim2.new(1,0,0,24); wb.BackgroundColor3=(equippedWeapon==wname) and C.accent or Color3.fromRGB(30,20,60); wb.BorderSizePixel=0; wb.Text="  "..wname; wb.TextColor3=C.white; wb.TextSize=10; wb.Font=Enum.Font.GothamBold; wb.TextXAlignment=Enum.TextXAlignment.Left; corner(4,wb)
            wb.MouseButton1Click:Connect(function()
                if wname=="(None)" then equippedWeapon=nil; weaponDisplay.Text="🗡  None selected  ▼"; weaponDisplay.TextColor3=C.muted
                else equippedWeapon=wname; weaponDisplay.Text="🗡  "..wname.."  ▼"; weaponDisplay.TextColor3=C.white; equipWeapon(wname) end
                dropOpen=false; weaponDropdown.Visible=false; buildWeaponList()
            end)
        end
        wScroll.CanvasSize=UDim2.new(0,0,0,wll.AbsoluteContentSize.Y+8)
        weaponDropdown.Size=UDim2.new(1,0,0,math.min(120,wll.AbsoluteContentSize.Y+10))
    end
    weaponDisplay.MouseButton1Click:Connect(function() dropOpen=not dropOpen; if dropOpen then buildWeaponList(); weaponDropdown.Visible=true else weaponDropdown.Visible=false end end)
    local wReload=Instance.new("TextButton",page); wReload.Size=UDim2.new(0,60,0,30); wReload.Position=UDim2.new(1,-64,0,158); wReload.BackgroundColor3=C.accent; wReload.BorderSizePixel=0; wReload.Text="🔄"; wReload.TextColor3=Color3.fromRGB(255,255,255); wReload.TextSize=11; wReload.Font=Enum.Font.GothamBold; corner(5,wReload)
    wReload.MouseButton1Click:Connect(function() buildWeaponList() end)
    if equippedWeapon then task.delay(4,function() equipWeapon(equippedWeapon) end) end
end

-- ===================== PAGE: BOSS =====================
do
    local page = pageBoss
    local bossScroll = Instance.new("ScrollingFrame", page)
    bossScroll.Size = UDim2.new(1,0,1,0); bossScroll.Position = UDim2.new(0,0,0,0)
    bossScroll.BackgroundTransparency = 1; bossScroll.BorderSizePixel = 0
    bossScroll.ScrollBarThickness = 3; bossScroll.ScrollBarImageColor3 = C.accent
    bossScroll.CanvasSize = UDim2.new(0,0,0,600); bossScroll.ClipsDescendants = true

    local function makeBossCard(parent, yPos, titleText, titleColor, infoText)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(1,0,0,68); card.Position = UDim2.new(0,0,0,yPos)
        card.BackgroundColor3 = C.card; card.BorderSizePixel = 0; corner(7, card); stroke(card, C.border, 1)
        local cp = Instance.new("UIPadding", card); cp.PaddingLeft = UDim.new(0,8); cp.PaddingTop = UDim.new(0,6)
        local titleLbl = newLabel(card, titleText, 11, titleColor); titleLbl.Size = UDim2.new(1,-8,0,18)
        local infoLbl = newLabel(card, infoText, 9, C.muted); infoLbl.Size = UDim2.new(1,-8,0,14); infoLbl.Position = UDim2.new(0,0,0,20); infoLbl.TextWrapped = true
        local statusLbl = newLabel(card, "● Idle", 9, C.muted); statusLbl.Size = UDim2.new(1,-8,0,14); statusLbl.Position = UDim2.new(0,0,0,36)
        return card, statusLbl
    end

    secLabel(bossScroll, "BOSS: FARM CHO ĐẾN KHI NHẬN ITEM", 0)
    local _, vStatusLbl = makeBossCard(bossScroll, 16, "💀  Auto Farm Vokun Lv2000 (Reset Token)", C.red, "Chỉ đánh Lv2000 Vokun • Nhận Reset Token → TP + Dừng")
    local _, getVokun, setVokun = makeToggle(bossScroll, "💀  Auto Farm Vokun (ResetToken)", 88, C.red, false)
    local _, wStatusLbl = makeBossCard(bossScroll, 130, "🔥  Auto Farm WhiteBeard Lv20000 (WB Essence)", C.orange, "Chỉ đánh Lv20000 WhiteBeard • Nhận WB Essence → TP + Dừng")
    local _, getWB, setWB = makeToggle(bossScroll, "🔥  Auto Farm WhiteBeard (WB Essence)", 202, C.orange, false)
    secLabel(bossScroll, "BOSS: ĐÁNH LIÊN TỤC", 246)
    local _, getCroco, setCroco   = makeToggle(bossScroll, "🐊  Auto Boss Lv2000 Crocodile",     262, C.cyan,   false)
    local _, getGunner, setGunner = makeToggle(bossScroll, "🔫  Auto Boss Lv8000 Gunner Captain", 296, C.yellow, false)
    local bossLoopStatusLbl = newLabel(bossScroll, "● Idle", 10, C.muted)
    bossLoopStatusLbl.Size = UDim2.new(1,0,0,14); bossLoopStatusLbl.Position = UDim2.new(0,2,0,336)
    local noteCard = Instance.new("Frame", bossScroll); noteCard.Size = UDim2.new(1,0,0,44); noteCard.Position = UDim2.new(0,0,0,360)
    noteCard.BackgroundColor3 = Color3.fromRGB(18,10,40); noteCard.BorderSizePixel = 0; corner(7, noteCard); stroke(noteCard, C.border, 1)
    local np = Instance.new("UIPadding", noteCard); np.PaddingLeft = UDim.new(0,8); np.PaddingTop = UDim.new(0,6)
    local noteLbl = newLabel(noteCard, "⚠ Tên boss phải khớp với workspace.Alive\nItem name phải khớp với tên trong Backpack", 9, C.muted)
    noteLbl.Size = UDim2.new(1,-8,1,0); noteLbl.TextWrapped = true; noteLbl.TextYAlignment = Enum.TextYAlignment.Top

    -- FIX: Watcher dùng task.wait(0.5) thay vì while true do task.wait(0.2) để nhẹ hơn
    local lastVokun = false
    task.spawn(function()
        while true do
            task.wait(0.5)
            local cur = getVokun()
            if cur ~= lastVokun then
                lastVokun = cur
                if cur then
                    setWB(false); setCroco(false); setGunner(false)
                    if whiteBeardThread then task.cancel(whiteBeardThread); whiteBeardThread = nil end
                    if crocoThread then task.cancel(crocoThread); crocoThread = nil end
                    if gunnerThread then task.cancel(gunnerThread); gunnerThread = nil end
                    vokunThread = task.spawn(function()
                        vStatusLbl.Text = "⚔ Bắt đầu đánh Vokun..."; vStatusLbl.TextColor3 = C.red
                        local dropped = farmBossUntilDrop("Lv2000 Vokun", "Reset Token", vStatusLbl, getVokun)
                        if dropped then vStatusLbl.Text = "✅ Reset Token nhận được! Dừng."; vStatusLbl.TextColor3 = C.green
                        else vStatusLbl.Text = "● Dừng"; vStatusLbl.TextColor3 = C.muted end
                        setVokun(false); vokunThread = nil
                    end)
                else
                    if vokunThread then task.cancel(vokunThread); vokunThread = nil end
                    vStatusLbl.Text = "● Idle"; vStatusLbl.TextColor3 = C.muted
                end
            end
        end
    end)

    local lastWB = false
    task.spawn(function()
        while true do
            task.wait(0.5)
            local cur = getWB()
            if cur ~= lastWB then
                lastWB = cur
                if cur then
                    setVokun(false); setCroco(false); setGunner(false)
                    if vokunThread then task.cancel(vokunThread); vokunThread = nil end
                    if crocoThread then task.cancel(crocoThread); crocoThread = nil end
                    if gunnerThread then task.cancel(gunnerThread); gunnerThread = nil end
                    whiteBeardThread = task.spawn(function()
                        wStatusLbl.Text = "⚔ Bắt đầu đánh WhiteBeard..."; wStatusLbl.TextColor3 = C.orange
                        local dropped = farmBossUntilDrop("Lv20000 WhiteBeard", "WhiteBeard Essence", wStatusLbl, getWB)
                        if dropped then wStatusLbl.Text = "✅ WB Essence nhận được! Dừng."; wStatusLbl.TextColor3 = C.green
                        else wStatusLbl.Text = "● Dừng"; wStatusLbl.TextColor3 = C.muted end
                        setWB(false); whiteBeardThread = nil
                    end)
                else
                    if whiteBeardThread then task.cancel(whiteBeardThread); whiteBeardThread = nil end
                    wStatusLbl.Text = "● Idle"; wStatusLbl.TextColor3 = C.muted
                end
            end
        end
    end)

    local lastCroco = false
    task.spawn(function()
        while true do
            task.wait(0.5)
            local cur = getCroco()
            if cur ~= lastCroco then
                lastCroco = cur
                if cur then
                    setVokun(false); setWB(false); setGunner(false)
                    if vokunThread then task.cancel(vokunThread); vokunThread = nil end
                    if whiteBeardThread then task.cancel(whiteBeardThread); whiteBeardThread = nil end
                    if gunnerThread then task.cancel(gunnerThread); gunnerThread = nil end
                    crocoThread = task.spawn(function()
                        farmBossLoop("Lv2000 Crocodile", bossLoopStatusLbl, getCroco)
                        bossLoopStatusLbl.Text = "● Idle"; bossLoopStatusLbl.TextColor3 = C.muted
                        crocoThread = nil
                    end)
                else
                    if crocoThread then task.cancel(crocoThread); crocoThread = nil end
                    bossLoopStatusLbl.Text = "● Idle"; bossLoopStatusLbl.TextColor3 = C.muted
                end
            end
        end
    end)

    local lastGunner = false
    task.spawn(function()
        while true do
            task.wait(0.5)
            local cur = getGunner()
            if cur ~= lastGunner then
                lastGunner = cur
                if cur then
                    setVokun(false); setWB(false); setCroco(false)
                    if vokunThread then task.cancel(vokunThread); vokunThread = nil end
                    if whiteBeardThread then task.cancel(whiteBeardThread); whiteBeardThread = nil end
                    if crocoThread then task.cancel(crocoThread); crocoThread = nil end
                    gunnerThread = task.spawn(function()
                        farmBossLoop("Lv8000 Gunner Captain", bossLoopStatusLbl, getGunner)
                        bossLoopStatusLbl.Text = "● Idle"; bossLoopStatusLbl.TextColor3 = C.muted
                        gunnerThread = nil
                    end)
                else
                    if gunnerThread then task.cancel(gunnerThread); gunnerThread = nil end
                    bossLoopStatusLbl.Text = "● Idle"; bossLoopStatusLbl.TextColor3 = C.muted
                end
            end
        end
    end)
end

-- ===================== PAGE: AUTO SAM =====================
do
    local page = pageAutoSam

    secLabel(page, "AUTO SAM QUEST", 0)

    local infoCard = Instance.new("Frame", page)
    infoCard.Size = UDim2.new(1,0,0,68); infoCard.Position = UDim2.new(0,0,0,16)
    infoCard.BackgroundColor3 = C.card; infoCard.BorderSizePixel = 0; corner(7, infoCard); stroke(infoCard, C.border, 1)
    local icp = Instance.new("UIPadding", infoCard); icp.PaddingLeft = UDim.new(0,10); icp.PaddingTop = UDim.new(0,8)
    local i1 = newLabel(infoCard, "📋  Tự động nộp quest Sam khi sẵn sàng", 11, C.cyan); i1.Size = UDim2.new(1,-10,0,18)
    local i2 = newLabel(infoCard, "TP đến Sam NPC → Click → Chọn Option → Leave", 9, C.muted); i2.Size = UDim2.new(1,-10,0,16); i2.Position = UDim2.new(0,0,0,20)
    local i3 = newLabel(infoCard, "Claim khi có ít nhất 1 slot sẵn sàng (A/B)", 9, C.yellow); i3.Size = UDim2.new(1,-10,0,16); i3.Position = UDim2.new(0,0,0,36)

    local statusCard = Instance.new("Frame", page)
    statusCard.Size = UDim2.new(1,0,0,44); statusCard.Position = UDim2.new(0,0,0,90)
    statusCard.BackgroundColor3 = C.card; statusCard.BorderSizePixel = 0; corner(7, statusCard); stroke(statusCard, C.border, 1)
    local scp = Instance.new("UIPadding", statusCard); scp.PaddingLeft = UDim.new(0,10); scp.PaddingTop = UDim.new(0,8)
    local samStatusLbl = newLabel(statusCard, "● Idle - Chưa bật", 11, C.muted); samStatusLbl.Size = UDim2.new(1,-10,0,18)
    local samTimerLbl  = newLabel(statusCard, "⏳ Timer: --", 9, C.muted); samTimerLbl.Size = UDim2.new(1,-10,0,16); samTimerLbl.Position = UDim2.new(0,0,0,22)

    secLabel(page, "CONTROLS", 140)
    local _, getSam, setSam = makeToggle(page, "📋  Auto Sam Quest", 156, C.green, false)

    local manualBtn = Instance.new("TextButton", page)
    manualBtn.Size = UDim2.new(1,0,0,30); manualBtn.Position = UDim2.new(0,0,0,192)
    manualBtn.BackgroundColor3 = C.cyan; manualBtn.BorderSizePixel = 0
    manualBtn.Text = "▶  Nộp Quest Ngay (Thủ Công)"; manualBtn.TextColor3 = Color3.fromRGB(10,10,10)
    manualBtn.TextSize = 11; manualBtn.Font = Enum.Font.GothamBold; corner(7, manualBtn)
    manualBtn.MouseButton1Click:Connect(function()
        task.spawn(function() doQuestTurnIn(samStatusLbl) end)
    end)

    -- Hàm check có thể claim không
    local function samIsClaimable(text)
        if text:find("Ready!") then return true end
        local current, total = text:match("%((%d+)/(%d+)%)")
        if current and total then
            return tonumber(current) >= 1
        end
        return false
    end

    -- Cập nhật hiển thị timer
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                local timerLbl = player.PlayerGui.Menu.Frame.MenuList.Stats.Frame.A.Sam.SamTimer
                samTimerLbl.Text = "⏳ Timer: " .. timerLbl.Text
            end)
        end
    end)

    local samTimerConn = nil
    local isClaiming = false  -- tránh claim 2 lần cùng lúc

    task.spawn(function()
        while true do
            task.wait(0.3)
            local on = getSam()
            autoSamOn = on
            if on then
                samStatusLbl.Text = "🟢 Đang theo dõi..."; samStatusLbl.TextColor3 = C.green
                -- Check ngay khi bật
                pcall(function()
                    local timerLbl = player.PlayerGui.Menu.Frame.MenuList.Stats.Frame.A.Sam.SamTimer
                    if samIsClaimable(timerLbl.Text) and not isClaiming then
                        isClaiming = true
                        samStatusLbl.Text = "🚀 Đang nộp quest..."; samStatusLbl.TextColor3 = C.yellow
                        task.spawn(function()
                            doQuestTurnIn(samStatusLbl)
                            isClaiming = false
                        end)
                    end
                end)
                -- Kết nối theo dõi nếu chưa có
                if not samTimerConn then
                    pcall(function()
                        local timerLbl = player.PlayerGui.Menu.Frame.MenuList.Stats.Frame.A.Sam.SamTimer
                        samTimerConn = timerLbl:GetPropertyChangedSignal("Text"):Connect(function()
                            if not autoSamOn or isClaiming then return end
                            if samIsClaimable(timerLbl.Text) then
                                isClaiming = true
                                samStatusLbl.Text = "🚀 Quest Ready! Đang nộp..."; samStatusLbl.TextColor3 = C.yellow
                                task.spawn(function()
                                    doQuestTurnIn(samStatusLbl)
                                    isClaiming = false
                                end)
                            end
                        end)
                    end)
                end
            else
                if samTimerConn then
                    pcall(function() samTimerConn:Disconnect() end)
                    samTimerConn = nil
                end
                isClaiming = false
                samStatusLbl.Text = "● Idle - Đã tắt"; samStatusLbl.TextColor3 = C.muted
            end
        end
    end)
end

-- ===================== PAGE: AUTO CHEST =====================
do
    local page=pageAutoChest; secLabel(page,"AUTO CHEST",0)
    local infoCard=Instance.new("Frame",page); infoCard.Size=UDim2.new(1,0,0,68); infoCard.Position=UDim2.new(0,0,0,16); infoCard.BackgroundColor3=C.card; infoCard.BorderSizePixel=0; corner(7,infoCard); stroke(infoCard,C.border,1)
    local icp=Instance.new("UIPadding",infoCard); icp.PaddingLeft=UDim.new(0,10); icp.PaddingTop=UDim.new(0,8)
    local chestStatusLbl=newLabel(infoCard,"🎁  Status: OFF",11,C.muted); chestStatusLbl.Size=UDim2.new(1,-10,0,18)
    local chestCountLbl=newLabel(infoCard,"📦  Chests Collected: 0",9,C.yellow); chestCountLbl.Size=UDim2.new(1,-10,0,16); chestCountLbl.Position=UDim2.new(0,0,0,20)
    local hopLbl=newLabel(infoCard,"🌐  Server Hop: Inactive",9,C.muted); hopLbl.Size=UDim2.new(1,-10,0,16); hopLbl.Position=UDim2.new(0,0,0,38)
    secLabel(page,"CONTROLS",90)
    local _,getChest,setChest=makeToggle(page,"🎁  Auto Chest",106,C.green,false)
    local _,getHop,setHop=makeToggle(page,"🌐  Auto Server Hop",140,C.cyan,false)
    local chestCount=0
    local hopConn=nil
    local chestLoopThread=nil

    local function tweenToChest(chest)
        local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local ok,targetPos=pcall(function() return chest:GetPivot().Position end)
        if not ok or not chest.Parent then return end
        local startPos=hrp.Position
        hrp.CFrame=CFrame.new(Vector3.new(startPos.X,startPos.Y+400,startPos.Z)); task.wait(0.1)
        if not chest.Parent then return end
        hrp.CFrame=CFrame.new(targetPos+Vector3.new(0,3,0)); task.wait(0.1)
    end

    local function startChestLoop()
        if chestLoopThread then return end
        chestLoopThread=task.spawn(function()
            while autoChestOn do
                local chests={}
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name=="TreasureChest" then
                        table.insert(chests,v)
                    end
                end
                for _,chest in ipairs(chests) do
                    if not autoChestOn then break end
                    if chest and chest.Parent then
                        tweenToChest(chest)
                        chestCount+=1
                        chestCountLbl.Text="📦  Chests Collected: "..chestCount
                        task.wait(0.1)
                    end
                end
                task.wait(0.5)
            end
            chestLoopThread=nil
        end)
    end

    local function stopChestLoop()
        if chestLoopThread then
            pcall(function() task.cancel(chestLoopThread) end)
            chestLoopThread=nil
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Model") and obj.Name=="TreasureChest" and autoChestOn then
            task.wait(0.1)
            tweenToChest(obj)
            chestCount+=1
            chestCountLbl.Text="📦  Chests Collected: "..chestCount
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            local chestOn=getChest()
            autoChestOn=chestOn
            if chestOn then
                chestStatusLbl.Text="🎁  Status: ACTIVE ✅"; chestStatusLbl.TextColor3=C.green
                startChestLoop()
            else
                chestStatusLbl.Text="🎁  Status: OFF"; chestStatusLbl.TextColor3=C.muted
                stopChestLoop()
            end
            local hopOn=getHop()
            if hopOn and not hopConn then
                hopLbl.Text="🌐  Server Hop: Watching"; hopLbl.TextColor3=C.cyan
                hopConn=workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("Model") and obj.Name=="TreasureChest" then
                        task.wait(5)
                        if getHop() then
                            hopLbl.Text="🌐  Server Hopping..."; hopLbl.TextColor3=C.yellow
                            hopServer()
                        end
                    end
                end)
            elseif not hopOn and hopConn then
                pcall(function() hopConn:Disconnect() end); hopConn=nil
                hopLbl.Text="🌐  Server Hop: Inactive"; hopLbl.TextColor3=C.muted
            end
        end
    end)
end

-- ===================== PAGE: AUTO FISH =====================
do
    local page=pageAutoFish; secLabel(page,"AUTO FISHING",0)
    local infoCard=Instance.new("Frame",page); infoCard.Size=UDim2.new(1,0,0,52); infoCard.Position=UDim2.new(0,0,0,16); infoCard.BackgroundColor3=C.card; infoCard.BorderSizePixel=0; corner(7,infoCard); stroke(infoCard,C.border,1)
    local icp=Instance.new("UIPadding",infoCard); icp.PaddingLeft=UDim.new(0,10); icp.PaddingTop=UDim.new(0,8)
    local fishStatusLbl=newLabel(infoCard,"🎣  Status: OFF",11,C.muted); fishStatusLbl.Size=UDim2.new(1,-10,0,18)
    local fishCountLbl=newLabel(infoCard,"🐟  Fish Caught: 0",9,C.cyan); fishCountLbl.Size=UDim2.new(1,-10,0,16); fishCountLbl.Position=UDim2.new(0,0,0,22)
    secLabel(page,"CAST POSITION",74)
    local xCard=Instance.new("Frame",page); xCard.Size=UDim2.new(0.48,0,0,48); xCard.Position=UDim2.new(0,0,0,90); xCard.BackgroundColor3=C.card; xCard.BorderSizePixel=0; corner(7,xCard); stroke(xCard,C.border,1)
    local yCard=Instance.new("Frame",page); yCard.Size=UDim2.new(0.48,0,0,48); yCard.Position=UDim2.new(0.52,0,0,90); yCard.BackgroundColor3=C.card; yCard.BorderSizePixel=0; corner(7,yCard); stroke(yCard,C.border,1)
    local xp=Instance.new("UIPadding",xCard); xp.PaddingLeft=UDim.new(0,8); xp.PaddingTop=UDim.new(0,6)
    local yp=Instance.new("UIPadding",yCard); yp.PaddingLeft=UDim.new(0,8); yp.PaddingTop=UDim.new(0,6)
    local xLbl=newLabel(xCard,"Cast X",9,C.muted); xLbl.Size=UDim2.new(1,0,0,14)
    local xBox=Instance.new("TextBox",xCard); xBox.Size=UDim2.new(1,-8,0,20); xBox.Position=UDim2.new(0,0,0,16); xBox.BackgroundColor3=Color3.fromRGB(20,20,40); xBox.BorderSizePixel=0; xBox.Text=tostring(CAST_X); xBox.TextColor3=C.white; xBox.TextSize=11; xBox.Font=Enum.Font.GothamBold; xBox.ClearTextOnFocus=false; corner(4,xBox)
    local yLbl=newLabel(yCard,"Cast Y",9,C.muted); yLbl.Size=UDim2.new(1,0,0,14)
    local yBox=Instance.new("TextBox",yCard); yBox.Size=UDim2.new(1,-8,0,20); yBox.Position=UDim2.new(0,0,0,16); yBox.BackgroundColor3=Color3.fromRGB(20,20,40); yBox.BorderSizePixel=0; yBox.Text=tostring(CAST_Y); yBox.TextColor3=C.white; yBox.TextSize=11; yBox.Font=Enum.Font.GothamBold; yBox.ClearTextOnFocus=false; corner(4,yBox)
    xBox:GetPropertyChangedSignal("Text"):Connect(function() local n=tonumber(xBox.Text); if n then CAST_X=n end end)
    yBox:GetPropertyChangedSignal("Text"):Connect(function() local n=tonumber(yBox.Text); if n then CAST_Y=n end end)
    secLabel(page,"CONTROLS",144)
    local _,getFish,setFish=makeToggle(page,"🎣  Auto Fish",160,C.cyan,false)
    local castBtn=Instance.new("TextButton",page); castBtn.Size=UDim2.new(1,0,0,28); castBtn.Position=UDim2.new(0,0,0,196); castBtn.BackgroundColor3=C.accent; castBtn.BorderSizePixel=0; castBtn.Text="🎣  Cast Now"; castBtn.TextColor3=Color3.fromRGB(255,255,255); castBtn.TextSize=11; castBtn.Font=Enum.Font.GothamBold; corner(7,castBtn)
    castBtn.MouseButton1Click:Connect(function() clickPos(CAST_X,CAST_Y) end)
    task.spawn(function()
        local wasOn=false
        while true do
            task.wait(0.5)
            local on=getFish(); autoFishOn=on
            if on~=wasOn then
                wasOn=on; fishRunning=on
                if on then
                    fishStatusLbl.Text="🎣  Status: FISHING ✅"; fishStatusLbl.TextColor3=C.cyan
                    if not fishRemote then task.spawn(setupFishing) end
                    task.delay(1,function() if fishRunning then clickPos(CAST_X,CAST_Y) end end)
                else
                    fishStatusLbl.Text="🎣  Status: OFF"; fishStatusLbl.TextColor3=C.muted
                end
            end
            fishCountLbl.Text="🐟  Fish Caught: "..fishCount
        end
    end)
end

-- ===================== PAGE: AUTO SKILL =====================
do
    local page=pageAutoSkill
    local skillScroll=Instance.new("ScrollingFrame",page); skillScroll.Size=UDim2.new(1,0,1,0); skillScroll.BackgroundTransparency=1; skillScroll.BorderSizePixel=0; skillScroll.ScrollBarThickness=3; skillScroll.ScrollBarImageColor3=C.accent; skillScroll.CanvasSize=UDim2.new(0,0,0,500); skillScroll.ClipsDescendants=true
    secLabel(skillScroll,"ON SPAWN (1x)",0)
    local spawnToggles={}
    local skillColors={Z=C.red,X=C.orange,C=C.yellow,V=C.green,E=C.cyan,R=C.accent}
    local keyOrder={"Z","X","C","V","E","R"}
    for i,k in ipairs(keyOrder) do
        local _,get,set=makeToggle(skillScroll,"🔑  Skill "..k.." (spawn once)",(i-1)*34+16,skillColors[k],spawnSkills[k])
        spawnToggles[k]={get=get,set=set}
    end
    secLabel(skillScroll,"LOOP SKILLS (liên tục)",228)
    local loopToggles={}
    for i,k in ipairs(keyOrder) do
        local _,get,set=makeToggle(skillScroll,"🔄  Skill "..k.." (loop)",244+(i-1)*34,skillColors[k],loopSkills[k])
        loopToggles[k]={get=get,set=set}
    end
    local keyMap={Z=Enum.KeyCode.Z,X=Enum.KeyCode.X,C=Enum.KeyCode.C,V=Enum.KeyCode.V,E=Enum.KeyCode.E,R=Enum.KeyCode.R}
    task.spawn(function()
        while true do
            task.wait(0.3)
            for _,k in ipairs(keyOrder) do
                spawnSkills[k]=spawnToggles[k].get()
                local loopOn=loopToggles[k].get()
                loopSkills[k]=loopOn
                if loopOn and not skillLoopThreads[k] then
                    skillLoopThreads[k]=task.spawn(function()
                        while loopSkills[k] do pressKey(keyMap[k]); task.wait(0.2) end
                        skillLoopThreads[k]=nil
                    end)
                elseif not loopOn and skillLoopThreads[k] then
                    task.cancel(skillLoopThreads[k]); skillLoopThreads[k]=nil
                end
            end
        end
    end)
end

-- ===================== PAGE: TELEPORT =====================
do
    local page=pageTeleport; secLabel(page,"TELEPORT",0)
    local tpScroll=Instance.new("ScrollingFrame",page); tpScroll.Size=UDim2.new(1,0,1,0); tpScroll.BackgroundTransparency=1; tpScroll.BorderSizePixel=0; tpScroll.ScrollBarThickness=3; tpScroll.ScrollBarImageColor3=C.accent; tpScroll.ClipsDescendants=true
    local tll=Instance.new("UIListLayout",tpScroll); tll.Padding=UDim.new(0,3)
    local tlp=Instance.new("UIPadding",tpScroll); tlp.PaddingTop=UDim.new(0,16); tlp.PaddingLeft=UDim.new(0,2); tlp.PaddingRight=UDim.new(0,2)
    for _,loc in ipairs(LOCATIONS) do
        local btn=Instance.new("TextButton",tpScroll); btn.Size=UDim2.new(1,0,0,26); btn.BackgroundColor3=C.card; btn.BorderSizePixel=0
        btn.Text="🗺  "..loc.name; btn.TextColor3=C.muted; btn.TextSize=10; btn.Font=Enum.Font.GothamBold; btn.TextXAlignment=Enum.TextXAlignment.Left
        corner(6,btn); stroke(btn,C.border,1)
        local bp=Instance.new("UIPadding",btn); bp.PaddingLeft=UDim.new(0,10)
        btn.MouseButton1Click:Connect(function()
            local char=player.Character; if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            hrp.CFrame=CFrame.new(loc.pos)
            btn.BackgroundColor3=C.selBg; btn.TextColor3=C.white
            task.delay(1,function() btn.BackgroundColor3=C.card; btn.TextColor3=C.muted end)
        end)
    end
    tpScroll.CanvasSize=UDim2.new(0,0,0,tll.AbsoluteContentSize.Y+20)
end

-- ===================== PAGE: TP FRUIT =====================
do
    local page=pageTpFruit; secLabel(page,"TP TO FRUIT",0)
    local countLbl=newLabel(page,"🍎 Fruits: 0",10,C.orange); countLbl.Size=UDim2.new(0.5,0,0,14); countLbl.Position=UDim2.new(0,0,0,0)
    local refreshBtn=Instance.new("TextButton",page); refreshBtn.Size=UDim2.new(0.45,0,0,22); refreshBtn.Position=UDim2.new(0.55,0,0,0)
    refreshBtn.BackgroundColor3=C.accent; refreshBtn.BorderSizePixel=0; refreshBtn.Text="🔄 Refresh"; refreshBtn.TextColor3=Color3.fromRGB(255,255,255); refreshBtn.TextSize=9; refreshBtn.Font=Enum.Font.GothamBold; corner(5,refreshBtn)
    local scroll=Instance.new("ScrollingFrame",page); scroll.Size=UDim2.new(1,0,1,-22); scroll.Position=UDim2.new(0,0,0,22)
    scroll.BackgroundColor3=C.card; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=3; scroll.ScrollBarImageColor3=C.accent; scroll.ClipsDescendants=true; corner(7,scroll); stroke(scroll,C.border,1)
    local ll=Instance.new("UIListLayout",scroll); ll.Padding=UDim.new(0,2)
    local lp=Instance.new("UIPadding",scroll); lp.PaddingTop=UDim.new(0,4); lp.PaddingLeft=UDim.new(0,4); lp.PaddingRight=UDim.new(0,4); lp.PaddingBottom=UDim.new(0,4)
    local function refreshFruits()
        for _,v in ipairs(scroll:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
        local count=0
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:find("Fruit") then
                count+=1
                local row=Instance.new("TextButton",scroll); row.Size=UDim2.new(1,0,0,24); row.BackgroundColor3=C.selBg; row.BorderSizePixel=0; corner(5,row)
                row.Text="🍎  "..obj.Name; row.TextColor3=C.white; row.TextSize=10; row.Font=Enum.Font.GothamBold; row.TextXAlignment=Enum.TextXAlignment.Left
                local rp=Instance.new("UIPadding",row); rp.PaddingLeft=UDim.new(0,10)
                row.MouseButton1Click:Connect(function()
                    local char=player.Character; if not char then return end
                    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                    local ok,pos=pcall(function() return obj:GetPivot().Position end)
                    if ok then hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0)) end
                end)
            end
        end
        countLbl.Text="🍎 Fruits: "..count
        scroll.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+10)
    end
    refreshBtn.MouseButton1Click:Connect(function()
        refreshBtn.Text="⏳"; refreshFruits(); task.delay(0.4,function() refreshBtn.Text="🔄 Refresh" end)
    end)
    tabs["TP Fruit"].btn.MouseButton1Click:Connect(function() refreshFruits() end)
    refreshFruits()
end

-- ===================== PAGE: KAITUN UI =====================
do
    local page = pageKaitun; secLabel(page, "KAITUN UI", 0)
    local infoCard = Instance.new("Frame", page); infoCard.Size = UDim2.new(1,0,0,60); infoCard.Position = UDim2.new(0,0,0,16); infoCard.BackgroundColor3 = C.card; infoCard.BorderSizePixel = 0; corner(7, infoCard); stroke(infoCard, C.border, 1)
    local kcp = Instance.new("UIPadding", infoCard); kcp.PaddingLeft = UDim.new(0,10); kcp.PaddingTop = UDim.new(0,8)
    local k1 = newLabel(infoCard, "Hiển thị Beri / Kills / Bounty", 11, C.cyan); k1.Size = UDim2.new(1,-10,0,18)
    local k2 = newLabel(infoCard, "fullscreen overlay, có nút X để đóng", 9, C.muted); k2.Size = UDim2.new(1,-10,0,16); k2.Position = UDim2.new(0,0,0,20)
    local k3 = newLabel(infoCard, "Cần PlayerGui.Menu tồn tại", 9, C.muted); k3.Size = UDim2.new(1,-10,0,16); k3.Position = UDim2.new(0,0,0,36)
    secLabel(page, "CONTROLS", 82)
    local _, getKaitunOn, setKaitunOn = makeToggle(page, "👁  Kaitun UI", 98, C.yellow, false)
    _setKaitunToggle = setKaitunOn
    local lastState = false
    -- FIX: Dùng task.spawn poll thay Heartbeat
    task.spawn(function()
        while true do
            task.wait(0.3)
            local newState = getKaitunOn()
            if newState ~= lastState then
                lastState = newState
                kaitunOn = newState
                if kaitunOn then
                    buildKaitunUI()
                    main.Visible=false; guiVisible=false
                    toggleBtn.BackgroundColor3=Color3.fromRGB(60,30,100)
                else
                    if kaitunGui then pcall(function() kaitunGui:Destroy() end); kaitunGui = nil end
                end
            end
        end
    end)
end

-- ===================== PAGE: SETTING =====================
do
    local page=pageSetting; secLabel(page,"ABOUT",0)
    local infoCard=Instance.new("Frame",page); infoCard.Size=UDim2.new(1,0,0,96); infoCard.Position=UDim2.new(0,0,0,16); infoCard.BackgroundColor3=C.card; infoCard.BorderSizePixel=0; corner(7,infoCard); stroke(infoCard,C.border,1)
    local icp=Instance.new("UIPadding",infoCard); icp.PaddingLeft=UDim.new(0,10); icp.PaddingTop=UDim.new(0,8)
    local function infoRow(text,color,y) local l=newLabel(infoCard,text,11,color); l.Size=UDim2.new(1,-10,0,18); l.Position=UDim2.new(0,0,0,y) end
    infoRow("⚔  Tuanh Farm Hub V.008",       C.white,  0)
    infoRow("📦  FREEMIUM Build",             C.yellow, 18)
    infoRow("📋  Auto Sam + 💀 Boss Tab",    C.green,  36)
    infoRow("🍎  TP Fruit + 👁 Kaitun UI",  C.orange, 54)
    infoRow("🛡  Anti-AFK tích hợp",         C.cyan,   72)
    secLabel(page,"EXPORT CONFIG",118)
    local exportCard=Instance.new("Frame",page); exportCard.Size=UDim2.new(1,0,0,200); exportCard.Position=UDim2.new(0,0,0,134); exportCard.BackgroundColor3=C.card; exportCard.BorderSizePixel=0; corner(7,exportCard); stroke(exportCard,C.border,1)
    local ecp=Instance.new("UIPadding",exportCard); ecp.PaddingLeft=UDim.new(0,8); ecp.PaddingTop=UDim.new(0,8); ecp.PaddingRight=UDim.new(0,8); ecp.PaddingBottom=UDim.new(0,8)
    local instrLbl=newLabel(exportCard,"① Export  ② Copy ③ Paste trước loadstring()()",9,C.muted); instrLbl.Size=UDim2.new(1,0,0,14); instrLbl.TextWrapped=true
    local outputBox=Instance.new("TextBox",exportCard); outputBox.Size=UDim2.new(1,0,0,100); outputBox.Position=UDim2.new(0,0,0,18); outputBox.BackgroundColor3=Color3.fromRGB(8,8,18); outputBox.BorderSizePixel=0; outputBox.Text="-- press Export to generate"; outputBox.TextColor3=C.muted; outputBox.TextSize=9; outputBox.Font=Enum.Font.Code; outputBox.TextXAlignment=Enum.TextXAlignment.Left; outputBox.TextYAlignment=Enum.TextYAlignment.Top; outputBox.ClearTextOnFocus=false; outputBox.MultiLine=true; outputBox.TextWrapped=true
    corner(5,outputBox); stroke(outputBox,C.accent,1)
    local obp=Instance.new("UIPadding",outputBox); obp.PaddingLeft=UDim.new(0,6); obp.PaddingTop=UDim.new(0,5)
    local exportStatus=newLabel(exportCard,"",10,C.green,Enum.TextXAlignment.Center); exportStatus.Size=UDim2.new(1,0,0,14); exportStatus.Position=UDim2.new(0,0,0,122)
    local exportBtn=Instance.new("TextButton",exportCard); exportBtn.Size=UDim2.new(0.48,0,0,26); exportBtn.Position=UDim2.new(0,0,0,140); exportBtn.BackgroundColor3=C.accent; exportBtn.BorderSizePixel=0; exportBtn.Text="📋  Export"; exportBtn.TextColor3=Color3.fromRGB(255,255,255); exportBtn.TextSize=11; exportBtn.Font=Enum.Font.GothamBold; corner(6,exportBtn)
    local saveGBtn=Instance.new("TextButton",exportCard); saveGBtn.Size=UDim2.new(0.48,0,0,26); saveGBtn.Position=UDim2.new(0.52,0,0,140); saveGBtn.BackgroundColor3=C.green; saveGBtn.BorderSizePixel=0; saveGBtn.Text="💾  Save _G"; saveGBtn.TextColor3=Color3.fromRGB(10,10,10); saveGBtn.TextSize=11; saveGBtn.Font=Enum.Font.GothamBold; corner(6,saveGBtn)
    local function buildConfigString()
        local mobList={}
        for name in pairs(selectedMobs) do table.insert(mobList,'"'..name..'"') end
        table.sort(mobList)
        local spawnParts={}
        for k,v in pairs(spawnSkills) do if v then table.insert(spawnParts,k.."=true") end end
        local loopParts={}
        for k,v in pairs(loopSkills) do if v then table.insert(loopParts,k.."=true") end end
        return table.concat({
            "_G.TuanhConfig = {",
            "    autoAttack     = "..tostring(autoAttack)..",",
            "    autoSpawnTP    = "..tostring(autoSpawnTP)..",",
            "    autoSpawnClick = "..tostring(autoSpawnClick)..",",
            "    smeltMethod    = "..tostring(smeltMethod)..",",
            "    equippedWeapon = "..(equippedWeapon and ('"'..equippedWeapon..'"') or "nil")..",",
            "    selectedMobs   = {"..table.concat(mobList,", ").."},",
            "    spawnSkills    = {"..table.concat(spawnParts,", ").."},",
            "    loopSkills     = {"..table.concat(loopParts,", ").."},",
            "}",
        },"\n")
    end
    exportBtn.MouseButton1Click:Connect(function()
        local cfg=buildConfigString(); outputBox.Text=cfg; outputBox.TextColor3=C.cyan
        pcall(function() setclipboard(cfg) end)
        exportStatus.Text="✅ Đã copy!"; exportStatus.TextColor3=C.green
        task.delay(3,function() exportStatus.Text="" end)
    end)
    saveGBtn.MouseButton1Click:Connect(function()
        local mobList={}; for name in pairs(selectedMobs) do table.insert(mobList,name) end
        local sp={}; for k,v in pairs(spawnSkills) do sp[k]=v end
        local lp={}; for k,v in pairs(loopSkills) do lp[k]=v end
        _G.TuanhConfig={autoAttack=autoAttack,autoSpawnTP=autoSpawnTP,autoSpawnClick=autoSpawnClick,smeltMethod=smeltMethod,equippedWeapon=equippedWeapon,selectedMobs=mobList,spawnSkills=sp,loopSkills=lp}
        exportStatus.Text="💾 Saved to _G!"; exportStatus.TextColor3=C.yellow
        task.delay(3,function() exportStatus.Text="" end)
    end)
end

-- ===================== TOGGLE BUTTON =====================
local toggleGui=Instance.new("ScreenGui",game:GetService("CoreGui"))
toggleGui.ResetOnSpawn=false; toggleGui.Name="TuanhToggleBtn"; toggleGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

local toggleBtn=Instance.new("TextButton",toggleGui)
toggleBtn.Size=UDim2.new(0,38,0,38); toggleBtn.Position=UDim2.new(0,12,0.5,-19)
toggleBtn.BackgroundColor3=Color3.fromRGB(60,30,100); toggleBtn.BorderSizePixel=0
toggleBtn.Text="⚔"; toggleBtn.TextColor3=Color3.fromRGB(255,255,255); toggleBtn.TextSize=18
toggleBtn.Font=Enum.Font.GothamBold; toggleBtn.Active=true; toggleBtn.Draggable=true
corner(10,toggleBtn); stroke(toggleBtn,Color3.fromRGB(160,100,255),1.5)

local tipLbl=Instance.new("TextLabel",toggleGui)
tipLbl.Size=UDim2.new(0,100,0,18); tipLbl.Position=UDim2.new(0,54,0.5,-9)
tipLbl.BackgroundColor3=Color3.fromRGB(20,10,50); tipLbl.BorderSizePixel=0
tipLbl.Text="Mở / Đóng Hub"; tipLbl.TextColor3=Color3.fromRGB(200,180,255)
tipLbl.TextSize=9; tipLbl.Font=Enum.Font.Gotham; tipLbl.TextXAlignment=Enum.TextXAlignment.Left; tipLbl.Visible=false
corner(4,tipLbl); local tipPad=Instance.new("UIPadding",tipLbl); tipPad.PaddingLeft=UDim.new(0,6)
toggleBtn.MouseEnter:Connect(function() tipLbl.Visible=true end)
toggleBtn.MouseLeave:Connect(function() tipLbl.Visible=false end)

local guiVisible=false
closeBtn.MouseButton1Click:Connect(function()
    guiVisible=false; main.Visible=false; toggleBtn.BackgroundColor3=Color3.fromRGB(60,30,100)
end)
toggleBtn.MouseButton1Click:Connect(function()
    guiVisible=not guiVisible; main.Visible=guiVisible
    toggleBtn.BackgroundColor3=guiVisible and Color3.fromRGB(120,55,255) or Color3.fromRGB(60,30,100)
end)

-- ===================== INIT =====================
tabs["Auto Farm"].page.Visible=true; tabs["Auto Farm"].btn.BackgroundColor3=C.selBg; tabs["Auto Farm"].btn.TextColor3=C.white; tabs["Auto Farm"].bar.Visible=true; activeTab="Auto Farm"
