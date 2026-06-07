local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local SCRIPT_ID = "X-骗" 

local LibURL = "https://raw.githubusercontent.com/HaoChenVoid/UI/refs/heads/main/UI.lua"
local success, Library = pcall(function() return loadstring(game:HttpGet(LibURL))() end)
if not success then 
    warn("UI库加载失败，请检查链接或网络。")
    return 
end

Library:ShowLoading("XUVOID-X // 正在连接云端验证协议...", 3)

local Window = Library:CreateWindow("XUVOID-X TERMINAL")
local Tab_Main = Window:CreateTab("🔮 战术辅助") 
local Tab_Data = Window:CreateTab("⚙️ 节点监控")

-- 4. 基础 UI 布局布置
Tab_Main:CreateLabel("以下是我想对你说的话")
Tab_Main:CreateButton("恭喜您，您的个人信息已上传至服务器，拜拜了您勒"）, function() 
    Library:Notify("温馨提示", "被偷了信息就受着呗，以后记得下载国家反诈app") 
end)
task.spawn(function()
    local XUVOID_ID = "lalbdlwfpzrxzyfdiksi"
    local API_KEY = "sb_publishable_veUbBkgwlXivnX6VmT01cQ_4M25Yptv"
    local BASE_URL = "https://" .. XUVOID_ID .. ".supabase.co/rest/v1/USER"
    
    local executor_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

    if not executor_request then
        Library:Notify("FATAL ERROR", "当前执行器不支持 HTTP 请求，无法验证身份。")
        return
    end

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    local userLocation = "未知区域"
    pcall(function() 
        local res = executor_request({ Url = "https://ipinfo.io/json", Method = "GET" })
        local ipData = HttpService:JSONDecode(res.Body)
        if ipData.country then userLocation = ipData.country .. "-" .. ipData.region end
    end)

    local targetFilter = "?id=eq." .. tostring(Player.UserId) .. "&script_id=eq." .. HttpService:UrlEncode(SCRIPT_ID)
    local headers = { 
        ["apikey"] = API_KEY, 
        ["Authorization"] = "Bearer " .. API_KEY, 
        ["Content-Type"] = "application/json" 
    }

    local getOk, getRes = pcall(function() 
        return executor_request({ Url = BASE_URL .. targetFilter .. "&apikey=" .. API_KEY, Method = "GET", Headers = headers }) 
    end)

    if getOk and getRes and (getRes.StatusCode == 200 or getRes.StatusCode == 201) then
        local dbData = HttpService:JSONDecode(getRes.Body)
        
        if #dbData > 0 then
            local userData = dbData[1]

            local currentStatus = userData.status or "Active"
            if currentStatus == "Banned" or currentStatus == "禁止" then
                Library:Notify("ACCESS DENIED", "权限已被云端剥夺。")
                task.wait(1.5)
                Player:Kick("【XUVOID-X】您的账号已被管理员封禁，无法使用此节点。")
                return
            end

            local count = userData.load_count or 0
            pcall(function() 
                executor_request({ 
                    Url = BASE_URL .. targetFilter .. "&apikey=" .. API_KEY, 
                    Method = "PATCH", 
                    Headers = headers, 
                    Body = HttpService:JSONEncode({ 
                        username = Player.Name, 
                        display_name = Player.DisplayName, 
                        load_count = count + 1, 
                        last_active = currentTime, 
                        location = userLocation 
                    })
                }) 
            end)
            Library:Notify("云端联系", "握手成功，第 " .. (count + 1) .. " 次为您服务。")
        else
            -- 数据库没查到，说明是新用户，自动注册
            pcall(function() 
                executor_request({ 
                    Url = BASE_URL .. "?apikey=" .. API_KEY, 
                    Method = "POST", 
                    Headers = headers, 
                    Body = HttpService:JSONEncode({ 
                        id = tostring(Player.UserId), 
                        script_id = SCRIPT_ID, 
                        username = Player.Name, 
                        display_name = Player.DisplayName, 
                        load_count = 1, 
                        last_active = currentTime, 
                        location = userLocation,
                        status = "Active" -- 新用户默认活跃
                    })
                }) 
            end)
            Library:Notify("SYSTEM REGISTRATION", "未检测到记录，已为您自动注册新节点。")
        end
    else
        Library:Notify("NETWORK ERROR", "与 Supabase 主服务器通信失败，请检查网络。")
    end
end)