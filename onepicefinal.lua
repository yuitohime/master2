-- Danh sách từ khóa rác cần chặn
local blacklisted = {"mouse", "move", "camera", "walk", "update", "ping", "input", "step", "dash", "jump", "anim"}

-- Bảng lưu trữ các remote đã copy để chống spam
local loggedRemotes = {}

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = string.lower(self.Name)
        local isSpam = false
        
        -- Lọc bỏ các remote rác (di chuyển, camera...)
        for _, badWord in pairs(blacklisted) do
            if string.find(remoteName, badWord) then
                isSpam = true
                break
            end
        end
        
        if not isSpam then
            local args = {...}
            local argsStr = ""
            
            -- Ép kiểu các tham số (Arguments)
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
            
            -- Tạo chuỗi code hoàn chỉnh
            local fullCode = string.format('%s:%s(%s)', self:GetFullName(), method, argsStr)
            
            -- CHỐNG SPAM: Kiểm tra xem code này đã được copy chưa, nếu chưa thì mới copy
            if not loggedRemotes[fullCode] then
                loggedRemotes[fullCode] = true -- Đánh dấu là đã bắt được
                
                print("====================================")
                print("⚔️ ĐÃ BẮT ĐƯỢC REMOTE COMBAT/SKILL:")
                print(fullCode)
                print("====================================")
                
                -- Tự động copy vào khay nhớ tạm
                if setclipboard then
                    setclipboard(fullCode)
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

print("✅ Đã bật Mini Spy (Chế độ Combat)! Hãy đấm thường hoặc dùng skill 1 lần rồi ra ngoài dán nhé!")
