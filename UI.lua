-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v9.0 - MASTERPIECE]
-- 绝对边界物理锁定、UIStroke 高清渲染、极致柔性美学
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LOGO_ASSET_ID = "rbxthumb://type=Asset&id=139886244319763&w=150&h=150"

-- 艺术级色彩调优 (更深邃，对比度更清晰)
local C_BG = Color3.fromRGB(10, 10, 15)        
local C_BORDER = Color3.fromRGB(70, 50, 100)  
local C_ACCENT = Color3.fromRGB(160, 120, 255)
local C_TEXT = Color3.fromRGB(240, 240, 245)  
local C_DIM = Color3.fromRGB(120, 120, 135)   

local containerParent = (gethui and gethui()) or CoreGui

local MainGui = Instance.new("ScreenGui", containerParent)
MainGui.Name = "ProjectX_Main"
MainGui.DisplayOrder = 10 
MainGui.IgnoreGuiInset = true 
MainGui.ResetOnSpawn = false

local NotifGui = Instance.new("ScreenGui", containerParent)
NotifGui.Name = "ProjectX_Notif"
NotifGui.DisplayOrder = 100 
NotifGui.IgnoreGuiInset = true

local LoadGui = Instance.new("ScreenGui", containerParent)
LoadGui.Name = "ProjectX_Loading"
LoadGui.DisplayOrder = 999 
LoadGui.IgnoreGuiInset = true

-- ==========================================
-- 🔔 艺术级弹窗引擎
-- ==========================================
local NotifArea = Instance.new("Frame", NotifGui)
NotifArea.Size = UDim2.new(0, 280, 1, -30)
NotifArea.Position = UDim2.new(1, -300, 0, 20)
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
        Toast.Size = UDim2.new(1, 60, 0, 0)
        Toast.BackgroundColor3 = C_BG
        Toast.ClipsDescendants = true
        Toast.BorderSizePixel = 0
        Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 6)
        
        -- 高清描边
        local ToastStroke = Instance.new("UIStroke", Toast)
        ToastStroke.Color = C_BORDER
        ToastStroke.Thickness = 1.2
        ToastStroke.Transparency = 0.3
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 3, 1, 0)
        Accent.BackgroundColor3 = C_ACCENT
        Accent.BorderSizePixel = 0
        
        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 22)
        Title.Position = UDim2.new(0, 16, 0, 6)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = C_TEXT
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 22)
        Desc.Position = UDim2.new(0, 16, 0, 24)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = C_DIM
        Desc.Font = Enum.Font.Code
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        TweenService:Create(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 52)}):Play()

        task.spawn(function()
            task.wait(3.5)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1})
            TweenService:Create(ToastStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
            closeTween:Play()
            closeTween.Completed:Wait()
            Toast:Destroy()
        end)
        task.wait(0.8) 
    end
    isProcessingQueue = false
end

function Library:Notify(title, desc)
    table.insert(NotificationQueue, {title = ">> " .. title, desc = desc})
    task.spawn(ProcessQueue)
end

-- ==========================================
-- ⏳ 全屏加载与呼吸灯
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0) 
    LoadFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.15}):Play()

    local Ripple = Instance.new("Frame", LoadFrame)
    Ripple.Position = UDim2.new(0.5, 0, 0.45, 0)
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.BackgroundColor3 = C_ACCENT
    Ripple.BackgroundTransparency = 0.6
    Ripple.BorderSizePixel = 0
    Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)

    local Logo = Instance.new("ImageLabel", LoadFrame)
    Logo.Position = UDim2.new(0.5, 0, 0.45, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = LOGO_ASSET_ID
    Logo.ImageTransparency = 1

    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.58, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = C_ACCENT
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 13
    LoadText.TextTransparency = 1

    TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 110), ImageTransparency = 0}):Play()
    TweenService:Create(LoadText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local pulsing = true
    task.spawn(function()
        while pulsing do
            Ripple.Size = UDim2.new(0, 110, 0, 110)
            Ripple.BackgroundTransparency = 0.4
            local ripTween = TweenService:Create(Ripple, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 180, 0, 180), BackgroundTransparency = 1})
            ripTween:Play()
            ripTween.Completed:Wait()
        end
    end)

    task.wait(duration)
    pulsing = false
    Ripple:Destroy()
    
    local hideTween = TweenService:Create(Logo, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1})
    TweenService:Create(LoadText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 主窗口 (UIStroke 渲染 + 边界铁臂锁定)
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    local MainFrame = Instance.new("CanvasGroup", MainGui)
    MainFrame.BackgroundColor3 = C_BG
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- 核心渲染：UIStroke 高清外发光描边
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = C_BORDER
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.2

    local function RespondToScreen()
        local screenSize = MainGui.AbsoluteSize
        local targetW = math.min(540, screenSize.X - 30)
        local targetH = math.min(350, screenSize.Y - 30)
        MainFrame.Size = UDim2.new(0, targetW, 0, targetH)
        
        -- 确保居中初始化
        if not MainFrame:GetAttribute("HasMoved") then
            MainFrame.Position = UDim2.new(0.5, -targetW / 2, 0.5, -targetH / 2)
        end
    end
    MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(RespondToScreen)
    RespondToScreen() 
    
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 34)
    TopBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    TopBar.BorderSizePixel = 0
    
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 34)
    TopLine.BackgroundColor3 = C_BORDER
    TopLine.BorderSizePixel = 0
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = C_TEXT
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local BtnContainer = Instance.new("Frame", TopBar)
    BtnContainer.Size = UDim2.new(0, 80, 1, 0)
    BtnContainer.Position = UDim2.new(1, -80, 0, 0)
    BtnContainer.BackgroundTransparency = 1

    local MinBtn = Instance.new("TextButton", BtnContainer)
    MinBtn.Size = UDim2.new(0, 40, 1, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "" 
    local MinLine = Instance.new("Frame", MinBtn)
    MinLine.Size = UDim2.new(0, 12, 0, 2)
    MinLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinLine.AnchorPoint = Vector2.new(0.5, 0.5)
    MinLine.BackgroundColor3 = C_DIM
    MinLine.BorderSizePixel = 0
    Instance.new("UICorner", MinLine).CornerRadius = UDim.new(1, 0)

    local CloseBtn = Instance.new("TextButton", BtnContainer)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Position = UDim2.new(0, 40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "" 
    local CloseLine1 = Instance.new("Frame", CloseBtn)
    CloseLine1.Size = UDim2.new(0, 14, 0, 2)
    CloseLine1.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseLine1.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseLine1.BackgroundColor3 = C_DIM
    CloseLine1.Rotation = 45
    CloseLine1.BorderSizePixel = 0
    Instance.new("UICorner", CloseLine1).CornerRadius = UDim.new(1, 0)
    local CloseLine2 = CloseLine1:Clone()
    CloseLine2.Rotation = -45
    CloseLine2.Parent = CloseBtn

    MinBtn.MouseEnter:Connect(function() TweenService:Create(MinLine, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play() end)
    MinBtn.MouseLeave:Connect(function() TweenService:Create(MinLine, TweenInfo.new(0.2), {BackgroundColor3 = C_DIM}):Play() end)
    CloseBtn.MouseEnter:Connect(function() 
        TweenService:Create(CloseLine1, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play()
        TweenService:Create(CloseLine2, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function() 
        TweenService:Create(CloseLine1, TweenInfo.new(0.2), {BackgroundColor3 = C_DIM}):Play()
        TweenService:Create(CloseLine2, TweenInfo.new(0.2), {BackgroundColor3 = C_DIM}):Play()
    end)

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetH = isMinimized and 34 or math.min(350, MainGui.AbsoluteSize.Y - 30)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, targetH)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 0)}):Play()
        task.wait(0.3)
        MainGui:Destroy()
    end)

    -- 🛡️ 【核心修复：绝对边界物理锁定拖拽】
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            MainFrame:SetAttribute("HasMoved", true)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local screen = MainGui.AbsoluteSize
            local size = MainFrame.AbsoluteSize
            
            -- 将原始坐标全部转换为纯粹的像素绝对值 (Absolute Position)
            local startAbsX = (startPos.X.Scale * screen.X) + startPos.X.Offset
            local startAbsY = (startPos.Y.Scale * screen.Y) + startPos.Y.Offset
            
            -- 使用 math.clamp 画出绝对的四面墙壁
            -- 最小值为0，最大值为屏幕尺寸减去UI自身的尺寸
            local clampedX = math.clamp(startAbsX + delta.X, 0, screen.X - size.X)
            local clampedY = math.clamp(startAbsY + delta.Y, 0, screen.Y - size.Y)
            
            -- 抛弃Scale，直接以绝对像素定位，彻底消除越界可能
            MainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- 侧边栏重构 (更精致的比例)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 120, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
    Sidebar.BorderSizePixel = 0

    local SidebarRightLine = Instance.new("Frame", Sidebar)
    SidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarRightLine.BackgroundColor3 = C_BORDER
    SidebarRightLine.BorderSizePixel = 0

    local SideLogo = Instance.new("ImageLabel", Sidebar)
    SideLogo.Size = UDim2.new(0, 44, 0, 44)
    SideLogo.Position = UDim2.new(0, 14, 0, 14)
    SideLogo.BackgroundTransparency = 1
    SideLogo.Image = LOGO_ASSET_ID
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -75)
    TabContainer.Position = UDim2.new(0, 0, 0, 75)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 6)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -120, 1, -35)
    ContentArea.Position = UDim2.new(0, 120, 0, 35)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.85, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = C_DIM
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

        local LeftLine = Instance.new("Frame", TabBtn)
        LeftLine.Size = UDim2.new(0, 3, 0, 16)
        LeftLine.Position = UDim2.new(0, 0, 0.5, -8)
        LeftLine.BackgroundColor3 = C_ACCENT
        LeftLine.BorderSizePixel = 0
        LeftLine.Visible = false
        Instance.new("UICorner", LeftLine).CornerRadius = UDim.new(0, 2)

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 1
        Page.ScrollBarImageColor3 = C_BORDER
        Page.Visible = firstTab
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local Spacer = Instance.new("Frame", Page)
        Spacer.Size = UDim2.new(1, 0, 0, 6)
        Spacer.BackgroundTransparency = 1

        if firstTab then
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = C_TEXT
            LeftLine.Visible = true
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = C_DIM}):Play()
                    if child:FindFirstChild("Frame") then child.Frame.Visible = false end
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = C_TEXT}):Play()
            LeftLine.Visible = true
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.92, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            Btn.BorderSizePixel = 0
            Btn.Text = btnText
            Btn.TextColor3 = C_TEXT
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            local BtnStroke = Instance.new("UIStroke", Btn)
            BtnStroke.Color = C_BORDER
            BtnStroke.Thickness = 1
            BtnStroke.Transparency = 0.5

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 30)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = C_ACCENT, Transparency = 0.1}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 20)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = C_BORDER, Transparency = 0.5}):Play()
            end)

            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabData:CreateLabel(text)
            local LblContainer = Instance.new("Frame", Page)
            LblContainer.Size = UDim2.new(0.92, 0, 0, 22)
            LblContainer.BackgroundTransparency = 1

            local Lbl = Instance.new("TextLabel", LblContainer)
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = "» " .. text
            Lbl.TextColor3 = C_ACCENT
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