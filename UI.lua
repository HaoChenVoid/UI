-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v5.0 - APEX EDITION]
-- 专属徽标、脉冲加载动画、尖锐暗黑赛博视觉
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 专属徽标无损高清ID
local LOGO_ASSET_ID = "rbxassetid://139886244319763"

-- ==========================================
-- ⚙️ [系统层级引擎] 严格锁定弹窗永远在最上层
-- ==========================================
local containerParent = (gethui and gethui()) or CoreGui

local MainGui = Instance.new("ScreenGui", containerParent)
MainGui.Name = "ProjectX_Main"
MainGui.DisplayOrder = 10 
MainGui.IgnoreGuiInset = false

local NotifGui = Instance.new("ScreenGui", containerParent)
NotifGui.Name = "ProjectX_Notif"
NotifGui.DisplayOrder = 100 
NotifGui.IgnoreGuiInset = true

local LoadGui = Instance.new("ScreenGui", containerParent)
LoadGui.Name = "ProjectX_Loading"
LoadGui.DisplayOrder = 999 
LoadGui.IgnoreGuiInset = true

-- ==========================================
-- 🔔 [弹窗引擎] 赛博右下角列阵
-- ==========================================
local NotifArea = Instance.new("Frame", NotifGui)
NotifArea.Size = UDim2.new(0, 280, 1, -20)
NotifArea.Position = UDim2.new(1, -300, 0, 0)
NotifArea.BackgroundTransparency = 1
local ListLayout = Instance.new("UIListLayout", NotifArea)
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ListLayout.Padding = UDim.new(0, 10)

local NotificationQueue = {}
local isProcessingQueue = false

local function ProcessQueue()
    if isProcessingQueue then return end
    isProcessingQueue = true
    
    while #NotificationQueue > 0 do
        local msg = table.remove(NotificationQueue, 1)
        
        local Toast = Instance.new("Frame", NotifArea)
        Toast.Size = UDim2.new(1, 60, 0, 0)
        Toast.BackgroundColor3 = Color3.fromRGB(9, 6, 13) -- 极深紫黑
        Toast.ClipsDescendants = true
        Toast.BorderSizePixel = 1
        Toast.BorderColor3 = Color3.fromRGB(69, 43, 114) -- 赛博紫边框
        Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 2) -- 尖锐倒角
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 3, 1, 0)
        Accent.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
        
        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 22)
        Title.Position = UDim2.new(0, 15, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 22)
        Desc.Position = UDim2.new(0, 15, 0, 25)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = Color3.fromRGB(150, 140, 170)
        Desc.Font = Enum.Font.Code
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        -- 凌厉滑入动画
        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 55)}):Play()

        task.spawn(function()
            task.wait(4.5)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1})
            closeTween:Play()
            closeTween.Completed:Wait()
            Toast:Destroy()
        end)
        task.wait(1.2) 
    end
    isProcessingQueue = false
end

function Library:Notify(title, desc)
    table.insert(NotificationQueue, {title = ">> " .. title, desc = desc})
    task.spawn(ProcessQueue)
end

-- ==========================================
-- ⏳ [全局动画] 脉冲徽标高阶加载
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(5, 3, 8)
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()

    -- 脉冲光环 (底层)
    local Ripple = Instance.new("Frame", LoadFrame)
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0.5, 0, 0.45, 0)
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    Ripple.BackgroundTransparency = 0.5
    Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)

    -- 用户专属 X 徽标 (顶层)
    local Logo = Instance.new("ImageLabel", LoadFrame)
    Logo.Size = UDim2.new(0, 0, 0, 0)
    Logo.Position = UDim2.new(0.5, 0, 0.45, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = LOGO_ASSET_ID
    Logo.ImageTransparency = 1

    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.58, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = ""
    LoadText.TextColor3 = Color3.fromRGB(180, 150, 255)
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 13

    -- 1. 徽标弹性炸出
    TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 110), ImageTransparency = 0}):Play()
    
    -- 2. 脉冲波纹无限循环引擎
    local pulsing = true
    task.spawn(function()
        while pulsing do
            Ripple.Size = UDim2.new(0, 100, 0, 100)
            Ripple.BackgroundTransparency = 0.3
            local ripTween = TweenService:Create(Ripple, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 200), BackgroundTransparency = 1})
            ripTween:Play()
            ripTween.Completed:Wait()
        end
    end)

    -- 3. 打字机文字效果
    task.spawn(function()
        for i = 1, #text do
            LoadText.Text = string.sub(text, 1, i)
            task.wait(0.03)
        end
    end)

    task.wait(duration)

    pulsing = false
    Ripple:Destroy()
    
    local hideTween = TweenService:Create(Logo, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1})
    TweenService:Create(LoadText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 [控制面板] 尖锐哥特紫黑架构
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    -- 主窗口
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(9, 6, 13) -- 核心深紫黑
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(69, 43, 114)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 2) -- 极微小尖锐倒角
    MainFrame.ClipsDescendants = true
    
    -- 顶部极简控制栏
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 28)
    TopBar.BackgroundColor3 = Color3.fromRGB(14, 9, 21)
    TopBar.BorderSizePixel = 0
    
    -- 赛博霓虹顶边线
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
    TopLine.BorderSizePixel = 0
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(190, 180, 210)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 控制按钮
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 35, 1, 0)
    MinBtn.Position = UDim2.new(1, -70, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
    
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextSize = 14
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)

    -- 折叠逻辑
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 500, 0, 28) or UDim2.new(0, 500, 0, 320)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    -- 销毁逻辑
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 500, 0, 0)}):Play()
        task.wait(0.2)
        MainGui:Destroy()
    end)

    -- 顺滑拖拽
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.08), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- 侧边栏
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -28)
    Sidebar.Position = UDim2.new(0, 0, 0, 28)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
    Sidebar.BorderSizePixel = 1
    Sidebar.BorderColor3 = Color3.fromRGB(30, 20, 45)

    -- 专属图片徽标 (精确居中)
    local SideLogo = Instance.new("ImageLabel", Sidebar)
    SideLogo.Size = UDim2.new(0, 60, 0, 60)
    SideLogo.Position = UDim2.new(0.5, 0, 0, 45)
    SideLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    SideLogo.BackgroundTransparency = 1
    SideLogo.Image = LOGO_ASSET_ID
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -90)
    TabContainer.Position = UDim2.new(0, 0, 0, 90)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 4)

    -- 内容区
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -130, 1, -28)
    ContentArea.Position = UDim2.new(0, 130, 0, 28)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.85, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 13, 33)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(120, 110, 140)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 2)

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(139, 92, 246)
        Page.Visible = firstTab
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local Spacer = Instance.new("Frame", Page)
        Spacer.Size = UDim2.new(1, 0, 0, 5)
        Spacer.BackgroundTransparency = 1

        if firstTab then
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(220, 210, 255)
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    child.BackgroundTransparency = 1
                    child.TextColor3 = Color3.fromRGB(120, 110, 140) 
                end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(220, 210, 255)
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.9, 0, 0, 34)
            Btn.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = Color3.fromRGB(45, 28, 75)
            Btn.Text = btnText
            Btn.TextColor3 = Color3.fromRGB(210, 200, 220)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 2)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 45, 140)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(18, 12, 28)}):Play()
                pcall(callback)
            end)
        end

        function TabData:CreateLabel(text)
            local LblContainer = Instance.new("Frame", Page)
            LblContainer.Size = UDim2.new(0.9, 0, 0, 20)
            LblContainer.BackgroundTransparency = 1

            local Lbl = Instance.new("TextLabel", LblContainer)
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.fromRGB(167, 139, 250)
            Lbl.Font = Enum.Font.Code
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            return Lbl
        end

        return TabData
    end

    return WindowData
end

return Library
