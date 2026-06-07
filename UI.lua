-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v10.0 - PURE MINIMALISM]
-- 极简暗黑风、去除Logo、精简线条、绝对边界物理锁定
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 纯净高级灰调色板
local C_BG = Color3.fromRGB(18, 18, 20)        
local C_TOPBAR = Color3.fromRGB(24, 24, 28)
local C_SIDEBAR = Color3.fromRGB(20, 20, 24)
local C_ACCENT = Color3.fromRGB(130, 100, 255) -- 高级紫
local C_TEXT = Color3.fromRGB(240, 240, 240)  
local C_DIM = Color3.fromRGB(110, 110, 120)   
local C_BORDER = Color3.fromRGB(35, 35, 40)

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
-- 🔔 极简通知弹窗
-- ==========================================
local NotifArea = Instance.new("Frame", NotifGui)
NotifArea.Size = UDim2.new(0, 280, 1, -30)
NotifArea.Position = UDim2.new(1, -300, 0, 20)
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
        Toast.BackgroundColor3 = C_BG
        Toast.ClipsDescendants = true
        Toast.BorderSizePixel = 1
        Toast.BorderColor3 = C_BORDER
        Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 4)
        
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 2, 1, 0)
        Accent.BackgroundColor3 = C_ACCENT
        Accent.BorderSizePixel = 0
        
        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Position = UDim2.new(0, 12, 0, 6)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = C_TEXT
        Title.Font = Enum.Font.GothamMedium
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 20)
        Desc.Position = UDim2.new(0, 12, 0, 24)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = C_DIM
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)}):Play()

        task.spawn(function()
            task.wait(3.0)
            local closeTween = TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1})
            closeTween:Play()
            closeTween.Completed:Wait()
            Toast:Destroy()
        end)
        task.wait(0.6) 
    end
    isProcessingQueue = false
end

function Library:Notify(title, desc)
    table.insert(NotificationQueue, {title = title, desc = desc})
    task.spawn(ProcessQueue)
end

-- ==========================================
-- ⏳ 纯净无 Logo 加载动画
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0) 
    LoadFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.3}):Play()

    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.5, -15)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = C_ACCENT
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 14
    LoadText.TextTransparency = 1

    TweenService:Create(LoadText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.wait(duration)
    
    TweenService:Create(LoadText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    local hideTween = TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 极简主窗口 (去光效，物理边界锁定)
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    local MainFrame = Instance.new("CanvasGroup", MainGui)
    MainFrame.BackgroundColor3 = C_BG
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = C_BORDER
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

    local function RespondToScreen()
        local screenSize = MainGui.AbsoluteSize
        local targetW = math.min(500, screenSize.X - 30)
        local targetH = math.min(320, screenSize.Y - 30)
        MainFrame.Size = UDim2.new(0, targetW, 0, targetH)
        
        if not MainFrame:GetAttribute("HasMoved") then
            MainFrame.Position = UDim2.new(0.5, -targetW / 2, 0.5, -targetH / 2)
        end
    end
    MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(RespondToScreen)
    RespondToScreen() 
    
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = C_TOPBAR
    TopBar.BorderSizePixel = 0
    
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 30)
    TopLine.BackgroundColor3 = C_BORDER
    TopLine.BorderSizePixel = 0
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = C_TEXT
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local BtnContainer = Instance.new("Frame", TopBar)
    BtnContainer.Size = UDim2.new(0, 60, 1, 0)
    BtnContainer.Position = UDim2.new(1, -60, 0, 0)
    BtnContainer.BackgroundTransparency = 1

    local CloseBtn = Instance.new("TextButton", BtnContainer)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(0, 30, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X" 
    CloseBtn.TextColor3 = C_DIM
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12

    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = C_DIM}):Play() end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 0)}):Play()
        task.wait(0.2)
        MainGui:Destroy()
    end)

    -- 绝对边界物理锁定拖拽
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
            
            local startAbsX = (startPos.X.Scale * screen.X) + startPos.X.Offset
            local startAbsY = (startPos.Y.Scale * screen.Y) + startPos.Y.Offset
            
            local clampedX = math.clamp(startAbsX + delta.X, 0, screen.X - size.X)
            local clampedY = math.clamp(startAbsY + delta.Y, 0, screen.Y - size.Y)
            
            MainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- 侧边栏 (极简，去 Logo，顶置选项)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 110, 1, -31)
    Sidebar.Position = UDim2.new(0, 0, 0, 31)
    Sidebar.BackgroundColor3 = C_SIDEBAR
    Sidebar.BorderSizePixel = 0

    local SidebarRightLine = Instance.new("Frame", Sidebar)
    SidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarRightLine.BackgroundColor3 = C_BORDER
    SidebarRightLine.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -16)
    TabContainer.Position = UDim2.new(0, 0, 0, 8) -- 取消了 Logo，直接从顶部开始
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 4)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -110, 1, -31)
    ContentArea.Position = UDim2.new(0, 110, 0, 31)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.85, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = C_DIM
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 1
        Page.ScrollBarImageColor3 = C_BORDER
        Page.Visible = firstTab
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local Spacer = Instance.new("Frame", Page)
        Spacer.Size = UDim2.new(1, 0, 0, 6)
        Spacer.BackgroundTransparency = 1

        if firstTab then
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = C_ACCENT
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = C_DIM}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = C_ACCENT}):Play()
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.92, 0, 0, 32)
            Btn.BackgroundColor3 = C_TOPBAR
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = C_BORDER
            Btn.Text = btnText
            Btn.TextColor3 = C_TEXT
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), BorderColor3 = C_ACCENT}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = C_TOPBAR, BorderColor3 = C_BORDER}):Play()
            end)

            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabData:CreateLabel(text)
            local LblContainer = Instance.new("Frame", Page)
            LblContainer.Size = UDim2.new(0.92, 0, 0, 20)
            LblContainer.BackgroundTransparency = 1

            local Lbl = Instance.new("TextLabel", LblContainer)
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C_DIM
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            return Lbl
        end

        return TabData
    end

    return WindowData
end

return Library