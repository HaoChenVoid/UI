-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v4.0 - CYBER-GOTHIC EDITION]
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- ⚙️ [系统层级隔离引擎]
-- ==========================================
-- 保护环境适配
local containerParent = (gethui and gethui()) or CoreGui

-- 1. 主窗口层 (底层)
local MainGui = Instance.new("ScreenGui", containerParent)
MainGui.Name = "ProjectX_Main"
MainGui.DisplayOrder = 10 
MainGui.IgnoreGuiInset = false

-- 2. 弹窗通知层 (中层 - 永远在窗口之上)
local NotifGui = Instance.new("ScreenGui", containerParent)
NotifGui.Name = "ProjectX_Notif"
NotifGui.DisplayOrder = 100 
NotifGui.IgnoreGuiInset = true

-- 3. 加载动画层 (顶层 - 覆盖全屏)
local LoadGui = Instance.new("ScreenGui", containerParent)
LoadGui.Name = "ProjectX_Loading"
LoadGui.DisplayOrder = 999 
LoadGui.IgnoreGuiInset = true

-- ==========================================
-- ❌ [独家视觉] 赛博哥特风色散 'X'
-- ==========================================
local function CreateGothicX(parent, size, position)
    local LogoContainer = Instance.new("Frame", parent)
    LogoContainer.Size = size
    LogoContainer.Position = position
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.AnchorPoint = Vector2.new(0.5, 0.5)

    -- 赛博朋克色散效果: 底层幽蓝，中层猩红，顶层亮紫
    local colors = {
        Color3.fromRGB(0, 255, 255),  -- 左偏移 (青蓝)
        Color3.fromRGB(255, 0, 85),   -- 右偏移 (深红)
        Color3.fromRGB(167, 139, 250) -- 主体 (纯紫)
    }
    local offsets = { UDim2.new(0, -2, 0, 2), UDim2.new(0, 2, 0, -2), UDim2.new(0, 0, 0, 0) }
    
    local topLayer = nil
    for i = 1, 3 do
        local XText = Instance.new("TextLabel", LogoContainer)
        XText.Size = UDim2.new(1, 0, 1, 0)
        XText.Position = offsets[i]
        XText.BackgroundTransparency = 1
        XText.Text = "X"
        XText.TextColor3 = colors[i]
        XText.Font = Enum.Font.Michroma -- 科技锐利感字体
        XText.TextScaled = true
        XText.TextTransparency = (i == 3) and 0 or 0.6
        if i == 3 then
            topLayer = XText
            local stroke = Instance.new("UIStroke", XText)
            stroke.Color = Color3.fromRGB(139, 92, 246)
            stroke.Thickness = 1
        end
    end
    return LogoContainer, topLayer
end

-- ==========================================
-- 🔔 [内置引擎] 右下角赛博弹窗系统
-- ==========================================
local NotifArea = Instance.new("Frame", NotifGui)
NotifArea.Size = UDim2.new(0, 280, 1, -20)
NotifArea.Position = UDim2.new(1, -300, 0, 0)
NotifArea.BackgroundTransparency = 1
local ListLayout = Instance.new("UIListLayout", NotifArea)
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ListLayout.Padding = UDim.new(0, 12)

local NotificationQueue = {}
local isProcessingQueue = false

local function ProcessQueue()
    if isProcessingQueue then return end
    isProcessingQueue = true
    
    while #NotificationQueue > 0 do
        local msg = table.remove(NotificationQueue, 1)
        
        local Toast = Instance.new("Frame", NotifArea)
        Toast.Size = UDim2.new(1, 40, 0, 0) -- 初始稍微偏右
        Toast.BackgroundColor3 = Color3.fromRGB(11, 7, 16) -- 极深紫黑
        Toast.ClipsDescendants = true
        Toast.BorderSizePixel = 1
        Toast.BorderColor3 = Color3.fromRGB(40, 20, 60)
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 2, 1, 0)
        Accent.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        
        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 22)
        Title.Position = UDim2.new(0, 12, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = Color3.fromRGB(220, 220, 235)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 22)
        Desc.Position = UDim2.new(0, 12, 0, 25)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = Color3.fromRGB(140, 140, 150)
        Desc.Font = Enum.Font.Code
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        -- 弹出：同时展开高度并向左滑入
        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 55)}):Play()

        task.spawn(function()
            task.wait(5)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1})
            closeTween:Play()
            closeTween.Completed:Wait()
            Toast:Destroy()
        end)
        
        task.wait(1.5) 
    end
    isProcessingQueue = false
end

function Library:Notify(title, desc)
    table.insert(NotificationQueue, {title = ">_ " .. title, desc = desc})
    task.spawn(ProcessQueue)
end

-- ==========================================
-- ⏳ [动态引擎] 沉浸式全局加载
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0) -- 完美全屏
    LoadFrame.BackgroundColor3 = Color3.fromRGB(5, 3, 8)
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.15}):Play()

    local LogoContainer, TopX = CreateGothicX(LoadFrame, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.45, 0))
    
    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.55, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = Color3.fromRGB(180, 150, 255)
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 14
    LoadText.TextTransparency = 1

    -- 爆发出现
    TweenService:Create(LogoContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 90, 0, 90)}):Play()
    TweenService:Create(LoadText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    -- 【真实动画】呼吸缩放 + 持续锐利旋转
    local pulseIn = TweenService:Create(LogoContainer, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.new(0, 105, 0, 105)})
    local spin = TweenService:Create(LogoContainer, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    pulseIn:Play()
    spin:Play()

    task.wait(duration)

    pulseIn:Cancel()
    spin:Cancel()
    
    local hideTween = TweenService:Create(LogoContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    TweenService:Create(LoadText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 [核心UI] 紧凑紫黑面板 (带折叠关闭)
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    -- 主窗口 (缩小尺寸，比例更精致)
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 480, 0, 310)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 7, 16)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(40, 25, 60)
    MainFrame.ClipsDescendants = true
    
    -- 顶部控制栏 (拖拽区 + 按钮)
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 10, 22)
    TopBar.BorderSizePixel = 0
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(200, 190, 220)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 控制按钮 (最小化与关闭)
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 40, 1, 0)
    MinBtn.Position = UDim2.new(1, -80, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
    
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextSize = 18
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)

    -- 缩小功能逻辑
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 480, 0, 30) or UDim2.new(0, 480, 0, 310)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    -- 关闭功能逻辑
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 480, 0, 0)}):Play()
        task.wait(0.3)
        MainGui:Destroy()
    end)

    -- 顺滑拖拽逻辑 (绑定在 TopBar 上)
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

    -- 侧边栏 (缩窄至 120，比例更协调)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 120, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 10, 22)
    Sidebar.BorderSizePixel = 0

    local MiniLogo, _ = CreateGothicX(Sidebar, UDim2.new(0, 35, 0, 35), UDim2.new(0.5, 0, 0, 30))
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 2)

    -- 内容区
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -120, 1, -30)
    ContentArea.Position = UDim2.new(0, 120, 0, 30)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(120, 110, 140)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(139, 92, 246)
        Page.Visible = firstTab
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- 【修复】组件绝对居中

        -- 页面顶部留白
        local Spacer = Instance.new("Frame", Page)
        Spacer.Size = UDim2.new(1, 0, 0, 5)
        Spacer.BackgroundTransparency = 1

        if firstTab then
            TabBtn.TextColor3 = Color3.fromRGB(200, 190, 255)
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(120, 110, 140) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(200, 190, 255)
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.9, 0, 0, 32) -- 宽度90%，配合居中对齐
            Btn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = Color3.fromRGB(45, 30, 70)
            Btn.Text = btnText
            Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(110, 60, 200)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 15, 30)}):Play()
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
            Lbl.TextColor3 = Color3.fromRGB(139, 92, 246)
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
