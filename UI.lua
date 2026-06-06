-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v4.0 - CYBER-GOTHIC EDITION]
-- 包含：色差故障X徽标、全屏覆盖动画、最小化/关闭控制
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 全局保护容器
local UIContainer = Instance.new("ScreenGui")
UIContainer.Name = "ProjectX_Interface"
UIContainer.Parent = (gethui and gethui()) or CoreGui
UIContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UIContainer.IgnoreGuiInset = true -- [修复核心] 强制忽略顶部安全区，实现绝对全屏

-- ==========================================
-- ❌ [独家组件] 哥特赛博风：色差故障 X 徽标
-- ==========================================
local function CreateXLogo(parent, size, position)
    local LogoContainer = Instance.new("Frame", parent)
    LogoContainer.Size = size
    LogoContainer.Position = position
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.AnchorPoint = Vector2.new(0.5, 0.5)

    -- 赛博朋克经典：色差分离效果 (Chromatic Aberration)
    -- 1. 底层：深红偏移 (右下)
    local GlitchRed = Instance.new("TextLabel", LogoContainer)
    GlitchRed.Size = UDim2.new(1, 0, 1, 0)
    GlitchRed.Position = UDim2.new(0, 3, 0, 2)
    GlitchRed.BackgroundTransparency = 1
    GlitchRed.Text = "X"
    GlitchRed.TextColor3 = Color3.fromRGB(220, 20, 60) -- 腥红
    GlitchRed.Font = Enum.Font.Oswald -- 高瘦、规整、尖锐的字体
    GlitchRed.TextScaled = true
    GlitchRed.TextTransparency = 0.3

    -- 2. 底层：青蓝偏移 (左上)
    local GlitchCyan = Instance.new("TextLabel", LogoContainer)
    GlitchCyan.Size = UDim2.new(1, 0, 1, 0)
    GlitchCyan.Position = UDim2.new(0, -3, 0, -2)
    GlitchCyan.BackgroundTransparency = 1
    GlitchCyan.Text = "X"
    GlitchCyan.TextColor3 = Color3.fromRGB(0, 255, 255) -- 赛博青
    GlitchCyan.Font = Enum.Font.Oswald
    GlitchCyan.TextScaled = true
    GlitchCyan.TextTransparency = 0.3

    -- 3. 表层：冷酷的主体纯白
    local MainX = Instance.new("TextLabel", LogoContainer)
    MainX.Size = UDim2.new(1, 0, 1, 0)
    MainX.BackgroundTransparency = 1
    MainX.Text = "X"
    MainX.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainX.Font = Enum.Font.Oswald
    MainX.TextScaled = true
    
    local Stroke = Instance.new("UIStroke", MainX)
    Stroke.Color = Color3.fromRGB(20, 20, 25)
    Stroke.Thickness = 2

    return LogoContainer, GlitchRed, GlitchCyan, MainX
end

-- ==========================================
-- 🔔 [内置引擎] 右下角排队通知系统 (保持不变，已很完美)
-- ==========================================
local NotifArea = Instance.new("Frame", UIContainer)
NotifArea.Size = UDim2.new(0, 300, 1, -50)
NotifArea.Position = UDim2.new(1, -320, 0, 0)
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
        Toast.Size = UDim2.new(1, 0, 0, 0)
        Toast.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        Toast.BorderColor3 = Color3.fromRGB(40, 40, 45)
        Toast.ClipsDescendants = true
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 2, 1, 0)
        Accent.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- 哥特红点缀

        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 25)
        Title.Position = UDim2.new(0, 15, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 25)
        Desc.Position = UDim2.new(0, 15, 0, 25)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = Color3.fromRGB(161, 161, 170)
        Desc.Font = Enum.Font.Code
        Desc.TextSize = 12
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 60)}):Play()

        task.spawn(function()
            task.wait(6)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
            closeTween:Play()
            closeTween.Completed:Wait()
            Toast:Destroy()
        end)
        task.wait(3) 
    end
    isProcessingQueue = false
end

function Library:Notify(title, desc)
    table.insert(NotificationQueue, {title = title, desc = desc})
    task.spawn(ProcessQueue)
end

-- ==========================================
-- ⏳ [API 导出] 绝对全屏故障加载动画
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", UIContainer)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0) -- 配合 IgnoreGuiInset 实现真正全屏
    LoadFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 7) -- 极暗背景
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()

    -- 召唤哥特 X
    local LogoCenter = CreateXLogo(LoadFrame, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.45, 0))
    
    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.55, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = Color3.fromRGB(200, 200, 200)
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 15
    LoadText.TextTransparency = 1

    -- X 猛烈展开 (像心跳一样的颤动效果)
    TweenService:Create(LogoCenter, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 120, 0, 120)}):Play()
    TweenService:Create(LoadText, TweenInfo.new(1), {TextTransparency = 0}):Play()

    task.wait(duration)

    -- 瞬间收拢
    local hideTween = TweenService:Create(LogoCenter, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    TweenService:Create(LoadText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 [API 导出] 主控制面板 (带折叠与关闭系统)
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    local MainFrame = Instance.new("Frame", UIContainer)
    MainFrame.Size = UDim2.new(0, 600, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    MainFrame.ClipsDescendants = true -- 极其重要：保证缩小时内容不溢出
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(30, 30, 35)

    -- 顶部控制栏 (用于拖拽和放置按钮)
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    TopBar.BorderSizePixel = 0

    local TopTitle = Instance.new("TextLabel", TopBar)
    TopTitle.Size = UDim2.new(1, -100, 1, 0)
    TopTitle.Position = UDim2.new(0, 15, 0, 0)
    TopTitle.BackgroundTransparency = 1
    TopTitle.Text = titleText
    TopTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.TextSize = 12
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- [控制按键] 最小化 (-)
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 40, 1, 0)
    MinBtn.Position = UDim2.new(1, -80, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 12
    
    -- [控制按键] 关闭 (X)
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14

    -- 按钮悬停动画
    MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45), BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
    MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150,150,150)}):Play() end)
    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 20, 60), BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150,150,150)}):Play() end)

    -- 最小化折叠逻辑
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 35)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 380)}):Play()
        end
    end)

    -- 关闭销毁逻辑
    CloseBtn.MouseButton1Click:Connect(function()
        local closeAnim = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        closeAnim:Play()
        closeAnim.Completed:Wait()
        UIContainer:Destroy()
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
            TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- 侧边栏
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Sidebar.BorderSizePixel = 0

    -- 在侧边栏也放置一个微型 X Logo
    local MiniLogo = CreateXLogo(Sidebar, UDim2.new(0, 50, 0, 50), UDim2.new(0, 75, 0, 40))

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.Position = UDim2.new(0, 0, 0, 80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- 内容区
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -150, 1, -35)
    ContentArea.Position = UDim2.new(0, 150, 0, 35)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 110)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = firstTab
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)

        if firstTab then
            TabBtn.TextColor3 = Color3.fromRGB(220, 20, 60) -- 选中态为猩红色
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(100, 100, 110) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(220, 20, 60)
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            Btn.Text = btnText
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
            local BtnStroke = Instance.new("UIStroke", Btn)
            BtnStroke.Color = Color3.fromRGB(40, 40, 45)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 20, 60), TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 24), TextColor3 = Color3.fromRGB(180,180,180)}):Play()
                pcall(callback)
            end)
        end

        function TabData:CreateLabel(text)
            local Lbl = Instance.new("TextLabel", Page)
            Lbl.Size = UDim2.new(1, -10, 0, 25)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.fromRGB(220, 20, 60)
            Lbl.Font = Enum.Font.Code
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            return Lbl
        end

        return TabData
    end

    return WindowData
end

return Library