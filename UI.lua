local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- 核心配色方案（紫灰）
local Theme = {
    Background = Color3.fromRGB(25, 22, 30),     -- 深暗灰紫
    NavBg = Color3.fromRGB(35, 30, 42),          -- 导航暗紫
    Accent = Color3.fromRGB(157, 78, 221),       -- 霓虹亮紫
    Text = Color3.fromRGB(240, 240, 240),         -- 主文本白
    SubText = Color3.fromRGB(150, 140, 160),      -- 次要灰紫文本
    Border = Color3.fromRGB(50, 44, 60),          -- 边框暗灰
}

function Library:CreateWindow(titleText)
    local Window = {}
    
    -- 1. 创建外壳保护
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PurpleGray_Lib_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- 2. 主框架 (Main Frame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    local defaultSize = UDim2.new(0, 450, 0, 300) -- 记住默认大小用于缩放
    MainFrame.Size = defaultSize
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Theme.Border
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- 3. 顶部标题栏
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.NavBg
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -95, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = titleText or "紫色科技脚本"
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar
    
    -- 4. 内容滚动区域 (Container)
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 1, -55)
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = Theme.Accent
    Container.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- =================【全自动防移出屏幕核心算法】=================
    
    -- 函数：强制将窗口卡在屏幕有效范围内
    local function clampToScreen(targetPosition)
        local screen = ScreenGui.AbsoluteSize
        local frameSize = MainFrame.AbsoluteSize
        
        -- 计算当前拖拽或缩放后的绝对坐标 X 和 Y
        local targetX = targetPosition.X.Offset
        local targetY = targetPosition.Y.Offset
        
        -- 核心锁死逻辑：不能小于0（左/上边界），不能大于“屏幕宽/高减去窗口自身宽/高”（右/下边界）
        local clampedX = math.clamp(targetX, 0, screen.X - frameSize.X)
        local clampedY = math.clamp(targetY, 0, screen.Y - frameSize.Y)
        
        return UDim2.new(0, clampedX, 0, clampedY)
    end

    -- 监听拖拽逻辑
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            -- 尝试移动到的新位置
            local tentativePos = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
            -- 经过安全过滤，强行卡在屏幕内
            MainFrame.Position = clampToScreen(tentativePos)
        end
    end)

    -- =================【最小化与放大逻辑（带防飞出）】=================
    
    local isMinimized = false
    
    -- 最小化/折叠按钮
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -65, 0, 5)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Theme.SubText
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.SourceSansBold
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Parent = TopBar
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            -- 缩小：把高度变成 40 (只留顶部栏)，隐藏内容
            isMinimized = true
            MinimizeBtn.Text = "+"
            Container.Visible = false
            MainFrame.Size = UDim2.new(0, 450, 0, 40)
            -- 缩小后也要做一次边界检查，防止手滑
            MainFrame.Position = clampToScreen(MainFrame.Position)
        else
            -- 放大恢复：恢复默认大小
            isMinimized = false
            MinimizeBtn.Text = "-"
            MainFrame.Size = defaultSize
            Container.Visible = true
            -- 【核心】放大的一瞬间立刻触发卡死算法，如果因为放大导致右边或底部溢出屏幕，自动吸附弹回
            MainFrame.Position = clampToScreen(MainFrame.Position)
        end
    end)

    -- 关闭按钮
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = TopBar
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- 监听玩家游戏屏幕大小发生变化（比如手机横竖屏切换），自动重新调整位置防止出界
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        MainFrame.Position = clampToScreen(MainFrame.Position)
    end)

    -- =================【下属组件创建功能保持不变】=================
    
    function Window:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.BackgroundColor3 = Theme.NavBg
        Label.Text = text
        Label.TextColor3 = Theme.SubText
        Label.TextSize = 14
        Label.Font = Enum.Font.SourceSans
        Label.Parent = Container
        
        local LCorner = Instance.new("UICorner")
        LCorner.CornerRadius = UDim.new(0, 4)
        LCorner.Parent = Label
        
        local function UpdateText(newText)
            Label.Text = newText
        end
        return {UpdateText = UpdateText}
    end

    function Window:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Theme.NavBg
        Button.Text = text
        Button.TextColor3 = Theme.Text
        Button.TextSize = 14
        Button.Font = Enum.Font.SourceSansBold
        Button.AutoButtonColor = false
        Button.Parent = Container
        
        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 4)
        BCorner.Parent = Button
        
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Theme.Border
        UIStroke.Thickness = 1
        UIStroke.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Border}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.NavBg}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            Button.BackgroundColor3 = Theme.Accent
            task.wait(0.05)
            Button.BackgroundColor3 = Theme.Border
            pcall(callback)
        end)
    end

    return Window
end

return Library
