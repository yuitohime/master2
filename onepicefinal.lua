-- Danh sách từ khóa rác cần chặn để tránh lag đt
local blacklisted = {"mouse", "move", "camera", "walk", "update", "ping", "input", "step", "dash", "jump", "anim", "attack", "damage", "hit", "skill"}

-- Bảng lưu để chống spam copy
local loggedRemotes = {}

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    -- Chỉ bắt FireServer và InvokeServer (Giao tiếp với máy chủ)
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = string.lower(self.Name)
        local isSpam = false
        
        -- Lọc bỏ các remote rác
        for _, badWord in pairs(blacklisted) do
            if string.find(remoteName, badWord) then
                isSpam = true
                break
            end
        end
        
        if not isSpam then
            local args = {...}
            local argsStr = ""
            
            -- Ép kiểu tham số để tạo code chuẩn xác
            for i, v in ipairs(args) do
                if type(v) == "string" then
                    argsStr = argsStr .. '"' .. v .. '"'
                elseif type(v) == "number" or type(v) == "boolean" then
                    argsStr = argsStr .. tostring(v)
                elseif typeof(v) == "Instance" then
                    argsStr = argsStr .. v:GetFullName()
                else
                    argsStr = argsStr .. "nil"
                end
                if i < #args then argsStr = argsStr .. ", " end
            end
            
            -- Gộp thành code hoàn chỉnh
            local fullCode = string.format('%s:%s(%s)', self:GetFullName(), method, argsStr)
            
            if not loggedRemotes[fullCode] then
                loggedRemotes[fullCode] = true 
                
                print("====================================")
                print("🛒 ĐÃ BẮT ĐƯỢC REMOTE MUA RAID:")
                print(fullCode)
                print("====================================")
                
                -- Tự động copy
                if setclipboard then
                    setclipboard(fullCode)
                end
                
                -- Báo Notification
                game.StarterGui:SetCore("SendNotification", {
                    Title = "✅ Bắt Remote Thành Công",
                    Text = "Đã copy code mua Raid!",
                    Duration = 5
                })
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

print("✅ Đã bật Mini Spy! Hãy thao tác mua Raid để lấy Code...")
