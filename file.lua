-- Simpliness UI Library
-- A modern, sleek UI library for Roblox

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Simpliness = {}

-- Color scheme
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(255, 100, 100),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(45, 45, 45),
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 200, 100)
}

-- Animation settings
local AnimInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local QuickAnimInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Main Library
function Simpliness:CreateWindow(title)
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SimplinessUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true
    
    -- Corner rounding
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Colors.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Title text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "Simpliness"
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 20
    
    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 16
    
    -- Content area
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Colors.Accent
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = ContentFrame
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = ContentFrame
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    
    -- Window functionality
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, AnimInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            TweenService:Create(MainFrame, AnimInfo, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}):Play()
            isMinimized = true
        else
            TweenService:Create(MainFrame, AnimInfo, {Size = originalSize}):Play()
            isMinimized = false
        end
    end)
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Auto-resize content
    local function updateContentSize()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 30)
    end
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentSize)
    
    -- Window methods
    function Window:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = ContentFrame
        Button.BackgroundColor3 = Colors.Secondary
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Colors.Text
        Button.TextSize = 14
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button
        
        -- Button hover effect
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, QuickAnimInfo, {BackgroundColor3 = Colors.Border}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, QuickAnimInfo, {BackgroundColor3 = Colors.Secondary}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play()
            wait(0.1)
            TweenService:Create(Button, QuickAnimInfo, {BackgroundColor3 = Colors.Secondary}):Play()
            if callback then callback() end
        end)
        
        return Button
    end
    
    function Window:AddToggle(text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Parent = ContentFrame
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = default and Colors.Accent or Colors.Border
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(1, -35, 0.5, -8)
        ToggleButton.Size = UDim2.new(0, 30, 0, 16)
        ToggleButton.Text = ""
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(0, 8)
        ToggleButtonCorner.Parent = ToggleButton
        
        local ToggleKnob = Instance.new("Frame")
        ToggleKnob.Parent = ToggleButton
        ToggleKnob.BackgroundColor3 = Colors.Text
        ToggleKnob.BorderSizePixel = 0
        ToggleKnob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        ToggleKnob.Size = UDim2.new(0, 12, 0, 12)
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(0, 6)
        KnobCorner.Parent = ToggleKnob
        
        local toggled = default or false
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            if toggled then
                TweenService:Create(ToggleButton, AnimInfo, {BackgroundColor3 = Colors.Accent}):Play()
                TweenService:Create(ToggleKnob, AnimInfo, {Position = UDim2.new(1, -14, 0.5, -6)}):Play()
            else
                TweenService:Create(ToggleButton, AnimInfo, {BackgroundColor3 = Colors.Border}):Play()
                TweenService:Create(ToggleKnob, AnimInfo, {Position = UDim2.new(0, 2, 0.5, -6)}):Play()
            end
            
            if callback then callback(toggled) end
        end)
        
        return ToggleFrame
    end
    
    function Window:AddSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Parent = ContentFrame
        SliderFrame.BackgroundColor3 = Colors.Secondary
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Parent = SliderFrame
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Position = UDim2.new(0, 10, 0, 0)
        SliderLabel.Size = UDim2.new(1, -50, 0, 25)
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.Text = text
        SliderLabel.TextColor3 = Colors.Text
        SliderLabel.TextSize = 14
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Parent = SliderFrame
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -40, 0, 0)
        ValueLabel.Size = UDim2.new(0, 30, 0, 25)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Colors.TextSecondary
        ValueLabel.TextSize = 12
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Parent = SliderFrame
        SliderBar.BackgroundColor3 = Colors.Border
        SliderBar.BorderSizePixel = 0
        SliderBar.Position = UDim2.new(0, 10, 1, -20)
        SliderBar.Size = UDim2.new(1, -20, 0, 4)
        
        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(0, 2)
        SliderBarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = Colors.Accent
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(0, 2)
        SliderFillCorner.Parent = SliderFill
        
        local SliderKnob = Instance.new("Frame")
        SliderKnob.Parent = SliderBar
        SliderKnob.BackgroundColor3 = Colors.Text
        SliderKnob.BorderSizePixel = 0
        SliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        SliderKnob.Size = UDim2.new(0, 12, 0, 12)
        
        local SliderKnobCorner = Instance.new("UICorner")
        SliderKnobCorner.CornerRadius = UDim.new(0, 6)
        SliderKnobCorner.Parent = SliderKnob
        
        local dragging = false
        local currentValue = default
        
        local function updateSlider(input)
            local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * percentage)
            ValueLabel.Text = tostring(currentValue)
            
            TweenService:Create(SliderFill, QuickAnimInfo, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
            TweenService:Create(SliderKnob, QuickAnimInfo, {Position = UDim2.new(percentage, -6, 0.5, -6)}):Play()
            
            if callback then callback(currentValue) end
        end
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        SliderBar.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return SliderFrame
    end
    
    function Window:AddDropdown(text, options, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = ContentFrame
        DropdownFrame.BackgroundColor3 = Colors.Secondary
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
        DropdownFrame.ClipsDescendants = true
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 4)
        DropdownCorner.Parent = DropdownFrame
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 0, 35)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.Text = text
        DropdownButton.TextColor3 = Colors.Text
        DropdownButton.TextSize = 14
        DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local DropdownPadding = Instance.new("UIPadding")
        DropdownPadding.Parent = DropdownButton
        DropdownPadding.PaddingLeft = UDim.new(0, 10)
        
        local DropdownArrow = Instance.new("TextLabel")
        DropdownArrow.Parent = DropdownFrame
        DropdownArrow.BackgroundTransparency = 1
        DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
        DropdownArrow.Size = UDim2.new(0, 30, 0, 35)
        DropdownArrow.Font = Enum.Font.Gotham
        DropdownArrow.Text = "▼"
        DropdownArrow.TextColor3 = Colors.TextSecondary
        DropdownArrow.TextSize = 12
        
        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Parent = DropdownFrame
        OptionsFrame.BackgroundColor3 = Colors.Border
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Position = UDim2.new(0, 0, 0, 35)
        OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        
        local OptionsLayout = Instance.new("UIListLayout")
        OptionsLayout.Parent = OptionsFrame
        OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local isOpen = false
        
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Parent = OptionsFrame
            OptionButton.BackgroundColor3 = Colors.Border
            OptionButton.BorderSizePixel = 0
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = option
            OptionButton.TextColor3 = Colors.Text
            OptionButton.TextSize = 14
            OptionButton.TextXAlignment = Enum.TextXAlignment.Left
            
            local OptionPadding = Instance.new("UIPadding")
            OptionPadding.Parent = OptionButton
            OptionPadding.PaddingLeft = UDim.new(0, 10)
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, QuickAnimInfo, {BackgroundColor3 = Colors.Secondary}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, QuickAnimInfo, {BackgroundColor3 = Colors.Border}):Play()
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                if callback then callback(option) end
                
                -- Close dropdown
                isOpen = false
                TweenService:Create(DropdownFrame, AnimInfo, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                TweenService:Create(DropdownArrow, AnimInfo, {Rotation = 0}):Play()
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                TweenService:Create(DropdownFrame, AnimInfo, {Size = UDim2.new(1, 0, 0, 35 + #options * 30)}):Play()
                TweenService:Create(DropdownArrow, AnimInfo, {Rotation = 180}):Play()
            else
                TweenService:Create(DropdownFrame, AnimInfo, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                TweenService:Create(DropdownArrow, AnimInfo, {Rotation = 0}):Play()
            end
        end)
        
        return DropdownFrame
    end
    
    function Window:AddTextbox(text, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Name = "TextboxFrame"
        TextboxFrame.Parent = ContentFrame
        TextboxFrame.BackgroundColor3 = Colors.Secondary
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Size = UDim2.new(1, 0, 0, 35)
        
        local TextboxCorner = Instance.new("UICorner")
        TextboxCorner.CornerRadius = UDim.new(0, 4)
        TextboxCorner.Parent = TextboxFrame
        
        local TextboxLabel = Instance.new("TextLabel")
        TextboxLabel.Parent = TextboxFrame
        TextboxLabel.BackgroundTransparency = 1
        TextboxLabel.Position = UDim2.new(0, 10, 0, -20)
        TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
        TextboxLabel.Font = Enum.Font.Gotham
        TextboxLabel.Text = text
        TextboxLabel.TextColor3 = Colors.Text
        TextboxLabel.TextSize = 12
        TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local Textbox = Instance.new("TextBox")
        Textbox.Parent = TextboxFrame
        Textbox.BackgroundTransparency = 1
        Textbox.Position = UDim2.new(0, 10, 0, 0)
        Textbox.Size = UDim2.new(1, -20, 1, 0)
        Textbox.Font = Enum.Font.Gotham
        Textbox.PlaceholderText = placeholder
        Textbox.PlaceholderColor3 = Colors.TextSecondary
        Textbox.Text = ""
        Textbox.TextColor3 = Colors.Text
        Textbox.TextSize = 14
        Textbox.TextXAlignment = Enum.TextXAlignment.Left
        
        Textbox.FocusLost:Connect(function()
            if callback then callback(Textbox.Text) end
        end)
        
        return TextboxFrame
    end
    
    return Window
end

return Simpliness
