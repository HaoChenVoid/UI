local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local SCRIPT_ID = "X-骗" 

for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name:match("ProjectX") then v:Destroy() end
end

local CacheBuster = "?t=" .. tostring(os.time())
local LibURL = "https://raw.githubusercontent.com/HaoChenVoid/UI/refs/heads/main/UI.lua" .. CacheBuster
local success, Library = pcall(function() return loadstring(game:HttpGet(LibURL))() end)

if not success or type(Library) ~= "table" then 
    warn("[XUVOID-X ERROR] UI 库拉取失败！请检查 GitHub 是否有语法错误。") 
    return 
end

Library:ShowLoading("XUVOID-X // 正在连接云端数据库...", 2)

local Window = Library:CreateWindow("XUVOID-X TERMINAL")
local Tab_Main = Window:CreateTab("标题") 
Tab_Main:CreateLabel("以下是我想说的")
Tab_Main:CreateButton("恭喜您的个人信息已经被我骗走了,已经上传至服务器端", function() Library:Notify("温馨提示", "受着呗，我早说过了。") end)

task.spawn(function()
    local PROJECT_ID = "lalbdlwfpzrxzyfdiksi"
    local API_KEY = "sb_publishable_veUbBkgwlXivnX6VmT01cQ_4M25Yptv"
    
    local BASE_URL = "https://" .. PROJECT_ID .. ".supabase.co/rest/v1/USER" 
    
    local executor_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not executor_request then 
        warn("[XUVOID-X ERROR] 执行器不支持 request 协议！")
        return 
    end

    local headers = { 
        ["apikey"] = API_KEY, 
        ["Authorization"] = "Bearer " .. API_KEY, 
        ["Content-Type"] = "application/json" 
    }

    local targetFilter = "?id=eq." .. tostring(Player.UserId) .. "&script_id=eq." .. HttpService:UrlEncode(SCRIPT_ID)
    
    local getOk, getRes = pcall(function()
        return executor_request({ 
            Url = BASE_URL .. targetFilter, 
            Method = "GET", 
            Headers = headers 
        })
    end)

    if getOk and getRes and (getRes.StatusCode == 200 or getRes.StatusCode == 201) then
        local dbData = HttpService:JSONDecode(getRes.Body)
        
        if #dbData > 0 then
 
            local userData = dbData[1]
            local currentStatus = userData.status or "Active"
            
            if currentStatus == "Banned" or currentStatus == "禁止" then
                Library:Notify("DENIED", "您的权限已被拉黑。")
                task.wait(1.5)
                Player:Kick("\n服务器拒绝访问\n您已被管理员封禁。")
                return
            end
            
            local currentCount = userData.usage_count or 1
            local newCount = currentCount + 1
            
            local patchData = HttpService:JSONEncode({ usage_count = newCount })
            local patchRes = executor_request({
                Url = BASE_URL .. targetFilter,
                Method = "PATCH",
                Headers = headers,
                Body = patchData
            })
            
            if patchRes and patchRes.StatusCode >= 200 and patchRes.StatusCode < 300 then
                Library:Notify("验证通过", "欢迎归来，这是您第 " .. tostring(newCount) .. " 次使用本脚本。")
            else
                warn("[Supabase PATCH 失败] 状态码:", patchRes and patchRes.StatusCode, "返回:", patchRes and patchRes.Body)
            end
        else
        
            local postData = HttpService:JSONEncode({
                id = Player.UserId,          
                script_id = SCRIPT_ID,       
                status = "Active",
                usage_count = 1
            })

            local postHeaders = table.clone(headers)
            postHeaders["Prefer"] = "return=representation"
            
            local postRes = executor_request({
                Url = BASE_URL,
                Method = "POST",
                Headers = postHeaders,
                Body = postData
            })

            if postRes and (postRes.StatusCode == 201 or postRes.StatusCode == 200) then
                Library:Notify("注册成功", "这是您初次使用本脚本，已为您自动建档。")
            else
                warn("[Supabase POST 失败] 状态码:", postRes and postRes.StatusCode, "返回:", postRes and postRes.Body)
            end
        end
    else
        Library:Notify("TIMEOUT", "无法连接到云端服务器。")
        warn("[Supabase GET 失败] 状态码:", getRes and getRes.StatusCode, "返回:", getRes and getRes.Body)
    end
end)