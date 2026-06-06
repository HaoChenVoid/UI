-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v3.0 - EXCLUSIVE EDITION]
-- 包含：专属 X 徽标、全局动画、通知阵列、全套UI组件
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

-- ==========================================
-- ❌ [独家组件] 纯代码绘制：赛博发光 X 徽标
-- ==========================================
local function CreateXLogo(parent, size, position)
    local LogoContainer = Instance.new("Frame", parent)
    LogoContainer.Size = size
    LogoContainer.Position = position
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.AnchorPoint = Vector2.new(0.5, 0.5)

    -- 左上到右下线条
    local Line1 = Instance.new("Frame", LogoContainer)
    Line1.Size = UDim2.new(1.2, 0, 0.15, 0)
    Line1.Position = UDim2.new(0.5, 0, 0.5, 0)
    Line1.AnchorPoint = Vector2.new(0.5, 0.5)
    Line1.Rotation = 45
    Line1.BackgroundColor3 = Color3.fromRGB(139, 92, 246) -- 赛博紫
    Line1.BorderSizePixel = 0
    local UIStroke1 = Instance.new("UIStroke", Line1)
    UIStroke1.Color = Color3.fromRGB(167, 139, 250)
    UIStroke1.Thickness = 1

    -- 左下到右上线条
    local Line2 = Instance.new("Frame", LogoContainer)
    Line2.Size = UDim2.new(1.2, 0, 0.15, 0)
    Line2.Position = UDim2.new(0.5, 0, 0.5, 0)
    Line2.AnchorPoint = Vector2.new(0.5, 0.5)
    Line2.Rotation = -45
    Line2.BackgroundColor3 = Color3.fromRGB(236, 72, 153) -- 霓虹粉
    Line2.BorderSizePixel = 0
    local UIStroke2 = Instance.new("UIStroke", Line2)
    UIStroke2.Color = Color3.fromRGB(244, 114, 182)
    UIStroke2.Thickness = 1
    
    return LogoContainer, Line1, Line2
end

-- ==========================================
-- 🔔 [内置引擎] 右下角排队通知系统
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
        Toast.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Toast.ClipsDescendants = true
        Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 6)
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 3, 1, 0)
        Accent.BackgroundColor3 = Color3.fromRGB(139, 92, 246)

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

        TweenService:Create(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 60)}):Play()

        task.spawn(function()
            task.wait(6)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
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
-- ⏳ [API 导出] 专属 X 徽标加载开场动画
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", UIContainer)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0) -- 全屏遮罩
    LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    LoadFrame.BackgroundTransparency = 1

    -- 背景渐变变暗
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()

    -- 创建中心徽标
    local LogoCenter, L1, L2 = CreateXLogo(LoadFrame, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.45, 0))
    
    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.55, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 16
    LoadText.TextTransparency = 1

    -- X 爆发展开动画
    TweenService:Create(LogoCenter, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 80, 0, 80)}):Play()
    TweenService:Create(LoadText, TweenInfo.new(1), {TextTransparency = 0}):Play()

    -- X 徽标匀速旋转
    local rotateTween = TweenService:Create(LogoCenter, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Rotation = 360})
    rotateTween:Play()

    task.wait(duration)

    -- 收起动画
    local hideTween = TweenService:Create(LogoCenter, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    TweenService:Create(LoadText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 [API 导出] 创建极客风主控制面板
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    -- 主框架
    local MainFrame = Instance.new("Frame", UIContainer)
    MainFrame.Size = UDim2.new(0, 600, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(40, 40, 48)

    -- 顺滑拖拽逻辑
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
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

    -- 侧边栏 (带专属 X Logo)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Sidebar.BorderSizePixel = 0

    local MiniLogo, _, _ = CreateXLogo(Sidebar, UDim2.new(0, 40, 0, 40), UDim2.new(0, 30, 0, 30))
    local TitleLabel = Instance.new("TextLabel", Sidebar)
    TitleLabel.Position = UDim2.new(0, 60, 0, 10)
    TitleLabel.Size = UDim2.new(1, -60, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- 内容区
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -150, 1, 0)
    ContentArea.Position = UDim2.new(0, 150, 0, 0)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
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
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 160) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Btn.Text = btnText
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(139, 92, 246)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
                pcall(callback)
            end)
        end

        function TabData:CreateLabel(text)
            local Lbl = Instance.new("TextLabel", Page)
            Lbl.Size = UDim2.new(1, -10, 0, 25)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.fromRGB(139, 92, 246)
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