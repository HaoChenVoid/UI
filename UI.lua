-- =======================================================
-- [PROJECT-X / VOID UI LIBRARY v7.0 - ULTIMATE RAZOR]
-- 绝对尖锐、纯手绘按键、强制图元解析、完整弹窗引擎修复版
-- =======================================================
local Library = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 强制 rbxthumb 解析
local LOGO_ASSET_ID = "rbxthumb://type=Asset&id=139886244319763&w=150&h=150"

-- 极简冷峻调色板
local C_BG = Color3.fromRGB(8, 8, 12)        -- 深渊黑
local C_BORDER = Color3.fromRGB(60, 40, 90)  -- 幽暗紫
local C_ACCENT = Color3.fromRGB(150, 110, 255)-- 赛博亮紫
local C_TEXT = Color3.fromRGB(220, 220, 230)  -- 冷白
local C_DIM = Color3.fromRGB(100, 100, 115)   -- 哑光灰

local containerParent = (gethui and gethui()) or CoreGui

-- ==========================================
-- ⚙️ 核心 GUI 容器架构
-- ==========================================
local MainGui = Instance.new("ScreenGui", containerParent)
MainGui.Name = "ProjectX_Main"
MainGui.DisplayOrder = 10 
local NotifGui = Instance.new("ScreenGui", containerParent)
NotifGui.Name = "ProjectX_Notif"
NotifGui.DisplayOrder = 100 
local LoadGui = Instance.new("ScreenGui", containerParent)
LoadGui.Name = "ProjectX_Loading"
LoadGui.DisplayOrder = 999 

-- ==========================================
-- 🔔 通知弹窗引擎 (修复完毕，完全适配冷酷风格)
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
        
        -- 尖锐直角底板
        local Toast = Instance.new("Frame", NotifArea)
        Toast.Size = UDim2.new(1, 60, 0, 0)
        Toast.BackgroundColor3 = C_BG
        Toast.ClipsDescendants = true
        Toast.BorderSizePixel = 1
        Toast.BorderColor3 = C_BORDER
        
        -- 左侧高亮边条
        local Accent = Instance.new("Frame", Toast)
        Accent.Size = UDim2.new(0, 2, 1, 0)
        Accent.BackgroundColor3 = C_ACCENT
        Accent.BorderSizePixel = 0
        
        local Title = Instance.new("TextLabel", Toast)
        Title.Size = UDim2.new(1, -20, 0, 22)
        Title.Position = UDim2.new(0, 15, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = msg.title
        Title.TextColor3 = C_TEXT
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Desc = Instance.new("TextLabel", Toast)
        Desc.Size = UDim2.new(1, -20, 0, 22)
        Desc.Position = UDim2.new(0, 15, 0, 25)
        Desc.BackgroundTransparency = 1
        Desc.Text = msg.desc
        Desc.TextColor3 = C_DIM
        Desc.Font = Enum.Font.Code
        Desc.TextSize = 11
        Desc.TextXAlignment = Enum.TextXAlignment.Left

        -- 凌厉滑入动画
        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 55)}):Play()

        task.spawn(function()
            task.wait(3.5)
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
-- ⏳ 全局加载动画 (接入 rbxthumb)
-- ==========================================
function Library:ShowLoading(text, duration)
    local LoadFrame = Instance.new("Frame", LoadGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadFrame.BackgroundColor3 = C_BG
    LoadFrame.BackgroundTransparency = 1

    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()

    local Ripple = Instance.new("Frame", LoadFrame)
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0.5, 0, 0.45, 0)
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.BackgroundColor3 = C_ACCENT
    Ripple.BackgroundTransparency = 0.5
    Ripple.BorderSizePixel = 0

    local Logo = Instance.new("ImageLabel", LoadFrame)
    Logo.Size = UDim2.new(0, 0, 0, 0)
    Logo.Position = UDim2.new(0.5, 0, 0.45, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = LOGO_ASSET_ID
    Logo.ImageTransparency = 1

    local LoadText = Instance.new("TextLabel", LoadFrame)
    LoadText.Size = UDim2.new(1, 0, 0, 30)
    LoadText.Position = UDim2.new(0, 0, 0.55, 0)
    LoadText.BackgroundTransparency = 1
    LoadText.Text = text
    LoadText.TextColor3 = C_ACCENT
    LoadText.Font = Enum.Font.Code
    LoadText.TextSize = 14
    LoadText.TextTransparency = 1

    TweenService:Create(Logo, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 120, 0, 120), ImageTransparency = 0}):Play()
    TweenService:Create(LoadText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local pulsing = true
    task.spawn(function()
        while pulsing do
            Ripple.Size = UDim2.new(0, 120, 0, 120)
            Ripple.BackgroundTransparency = 0.2
            local ripTween = TweenService:Create(Ripple, TweenInfo.new(1, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 180, 0, 180), BackgroundTransparency = 1})
            ripTween:Play()
            ripTween.Completed:Wait()
        end
    end)

    task.wait(duration)
    pulsing = false
    Ripple:Destroy()
    
    local hideTween = TweenService:Create(Logo, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1})
    TweenService:Create(LoadText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    hideTween:Play()
    hideTween.Completed:Wait()
    LoadFrame:Destroy()
end

-- ==========================================
-- 🪟 主窗口引擎 (纯手绘按键 + 极致规整)
-- ==========================================
function Library:CreateWindow(titleText)
    local WindowData = {}

    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = C_BG
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = C_BORDER
    MainFrame.ClipsDescendants = true
    
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    TopBar.BorderSizePixel = 0
    
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 1)
    TopLine.Position = UDim2.new(0, 0, 0, 30)
    TopLine.BackgroundColor3 = C_ACCENT
    TopLine.BorderSizePixel = 0
    
    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = C_TEXT
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- [纯代码手绘按键]
    local BtnContainer = Instance.new("Frame", TopBar)
    BtnContainer.Size = UDim2.new(0, 80, 1, 0)
    BtnContainer.Position = UDim2.new(1, -80, 0, 0)
    BtnContainer.BackgroundTransparency = 1

    local MinBtn = Instance.new("TextButton", BtnContainer)
    MinBtn.Size = UDim2.new(0, 40, 1, 0)
    MinBtn.Position = UDim2.new(0, 0, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "" 
    
    local MinLine = Instance.new("Frame", MinBtn)
    MinLine.Size = UDim2.new(0, 12, 0, 2)
    MinLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinLine.AnchorPoint = Vector2.new(0.5, 0.5)
    MinLine.BackgroundColor3 = C_DIM
    MinLine.BorderSizePixel = 0

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
    
    local CloseLine2 = CloseLine1:Clone()
    CloseLine2.Rotation = -45
    CloseLine2.Parent = CloseBtn

    MinBtn.MouseEnter:Connect(function() MinLine.BackgroundColor3 = C_ACCENT end)
    MinBtn.MouseLeave:Connect(function() MinLine.BackgroundColor3 = C_DIM end)
    CloseBtn.MouseEnter:Connect(function() 
        CloseLine1.BackgroundColor3 = C_ACCENT; CloseLine2.BackgroundColor3 = C_ACCENT 
    end)
    CloseBtn.MouseLeave:Connect(function() 
        CloseLine1.BackgroundColor3 = C_DIM; CloseLine2.BackgroundColor3 = C_DIM 
    end)

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 520, 0, 31) or UDim2.new(0, 520, 0, 340)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 520, 0, 0)}):Play()
        task.wait(0.2)
        MainGui:Destroy()
    end)

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

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 140, 1, -31)
    Sidebar.Position = UDim2.new(0, 0, 0, 31)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    Sidebar.BorderSizePixel = 1
    Sidebar.BorderColor3 = C_BORDER

    local SideLogo = Instance.new("ImageLabel", Sidebar)
    SideLogo.Size = UDim2.new(0, 70, 0, 70)
    SideLogo.Position = UDim2.new(0.5, 0, 0, 50)
    SideLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    SideLogo.BackgroundTransparency = 1
    SideLogo.Image = LOGO_ASSET_ID
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.Position = UDim2.new(0, 0, 0, 110)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -140, 1, -31)
    ContentArea.Position = UDim2.new(0, 140, 0, 31)
    ContentArea.BackgroundTransparency = 1

    local firstTab = true

    function WindowData:CreateTab(tabName)
        local TabData = {}

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = C_BG
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = C_DIM
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12

        local LeftLine = Instance.new("Frame", TabBtn)
        LeftLine.Size = UDim2.new(0, 2, 1, 0)
        LeftLine.BackgroundColor3 = C_ACCENT
        LeftLine.BorderSizePixel = 0
        LeftLine.Visible = false

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
        Spacer.Size = UDim2.new(1, 0, 0, 5)
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
                    child.BackgroundTransparency = 1
                    child.TextColor3 = C_DIM
                    if child:FindFirstChild("Frame") then child.Frame.Visible = false end
                end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = C_TEXT
            LeftLine.Visible = true
        end)

        function TabData:CreateButton(btnText, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(0.9, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = C_BORDER
            Btn.Text = btnText
            Btn.TextColor3 = C_TEXT
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BorderColor3 = C_ACCENT, BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BorderColor3 = C_BORDER, BackgroundColor3 = Color3.fromRGB(12, 12, 16)}):Play()
            end)

            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabData:CreateLabel(text)
            local LblContainer = Instance.new("Frame", Page)
            LblContainer.Size = UDim2.new(0.9, 0, 0, 20)
            LblContainer.BackgroundTransparency = 1

            local Lbl = Instance.new("TextLabel", LblContainer)
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = "> " .. text
            Lbl.TextColor3 = C_ACCENT
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