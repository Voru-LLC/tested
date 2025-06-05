-- Modern UI Library for Roblox
-- Features: Smooth animations, magenta theme, all components

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UILibrary = {}
UILibrary.__index = UILibrary

-- Theme Configuration
local Theme = {
    Primary = Color3.fromRGB(255, 20, 147), -- Magenta/Pink
    Secondary = Color3.fromRGB(200, 15, 120),
    Background = Color3.fromRGB(30, 30, 35),
    Surface = Color3.fromRGB(40, 40, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(60, 60, 65),
    Success = Color3.fromRGB(50, 205, 50),
    Warning = Color3.fromRGB(255, 165, 0),
    Error = Color3.fromRGB(220, 20, 60)
}

-- Animation Settings
local AnimationInfo = TweenInfo.new(
    0.3,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

local FastAnimationInfo = TweenInfo.new(
    0.15,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Utility Functions
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Theme.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

-- Main Library Constructor
function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Window
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    CreateCorner(self.MainFrame, 12)
    CreateStroke(self.MainFrame, 2, Theme.Primary)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = Theme.Surface
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    CreateCorner(self.TitleBar, 12)
    CreateGradient(self.TitleBar, Theme.Primary, Theme.Secondary, 45)
    
    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "Modern UI"
    self.TitleLabel.TextColor3 = Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.TitleBar
    
    -- macOS Style Buttons
    self:CreateMacOSButtons()
    
    -- Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 6
    self.ContentFrame.ScrollBarImageColor3 = Theme.Primary
    self.ContentFrame.Parent = self.MainFrame
    
    -- Layout
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, 10)
    self.Layout.Parent = self.ContentFrame
    
    -- Make draggable
    self:MakeDraggable()
    
    -- Track content size
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
    end)
    
    return self
end

-- macOS Style Window Controls
function UILibrary:CreateMacOSButtons()
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "WindowControls"
    buttonContainer.Size = UDim2.new(0, 70, 0, 20)
    buttonContainer.Position = UDim2.new(1, -85, 0, 10)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = self.TitleBar
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonLayout.Padding = UDim.new(0, 8)
    buttonLayout.Parent = buttonContainer
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = buttonContainer
    
    CreateCorner(closeBtn, 10)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.BackgroundColor3 = Theme.Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 14
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = buttonContainer
    
    CreateCorner(minimizeBtn, 10)
    
    self.isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Hover effects
    for _, btn in pairs({closeBtn, minimizeBtn}) do
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, FastAnimationInfo, {Size = UDim2.new(0, 22, 0, 22)}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, FastAnimationInfo, {Size = UDim2.new(0, 20, 0, 20)}):Play()
        end)
    end
end

-- Toggle Minimize
function UILibrary:ToggleMinimize()
    self.isMinimized = not self.isMinimized
    local targetSize = self.isMinimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 400)
    
    TweenService:Create(self.MainFrame, AnimationInfo, {Size = targetSize}):Play()
end

-- Make Window Draggable
function UILibrary:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Button Component
function UILibrary:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Theme.Surface
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = self.ContentFrame
    
    CreateCorner(button, 8)
    CreateStroke(button, 1, Theme.Border)
    
    -- Hover Effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, FastAnimationInfo, {
            BackgroundColor3 = Theme.Primary,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, FastAnimationInfo, {
            BackgroundColor3 = Theme.Surface,
            TextColor3 = Theme.Text
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 38)}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        
        if callback then callback() end
    end)
    
    return button
end

-- Toggle Component
function UILibrary:CreateToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Theme.Surface
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = self.ContentFrame
    
    CreateCorner(toggleFrame, 8)
    CreateStroke(toggleFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 45, 0, 20)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -10)
    toggleButton.BackgroundColor3 = default and Theme.Primary or Theme.Border
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    CreateCorner(toggleButton, 10)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    toggleIndicator.Position = default and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleIndicator.BackgroundColor3 = Theme.Text
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    CreateCorner(toggleIndicator, 8)
    
    local isToggled = default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        local targetColor = isToggled and Theme.Primary or Theme.Border
        local targetPosition = isToggled and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        TweenService:Create(toggleButton, AnimationInfo, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(toggleIndicator, AnimationInfo, {Position = targetPosition}):Play()
        
        if callback then callback(isToggled) end
    end)
    
    return toggleFrame
end

-- Slider Component
function UILibrary:CreateSlider(text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Theme.Surface
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = self.ContentFrame
    
    CreateCorner(sliderFrame, 8)
    CreateStroke(sliderFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -80, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 70, 0, 20)
    valueLabel.Position = UDim2.new(1, -80, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Theme.Primary
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, -30, 0, 6)
    sliderTrack.Position = UDim2.new(0, 15, 0, 35)
    sliderTrack.BackgroundColor3 = Theme.Border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    CreateCorner(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    CreateCorner(sliderFill, 3)
    
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    sliderHandle.BackgroundColor3 = Theme.Text
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.Parent = sliderTrack
    
    CreateCorner(sliderHandle, 8)
    
    local currentValue = default
    local dragging = false
    
    local function updateSlider(value)
        currentValue = math.clamp(value, min, max)
        local percentage = (currentValue - min) / (max - min)
        
        valueLabel.Text = string.format("%.1f", currentValue)
        
        TweenService:Create(sliderFill, FastAnimationInfo, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        TweenService:Create(sliderHandle, FastAnimationInfo, {Position = UDim2.new(percentage, -8, 0, -5)}):Play()
        
        if callback then callback(currentValue) end
    end
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local trackX = sliderTrack.AbsolutePosition.X
            local trackWidth = sliderTrack.AbsoluteSize.X
            local percentage = math.clamp((mouseX - trackX) / trackWidth, 0, 1)
            local newValue = min + (max - min) * percentage
            updateSlider(newValue)
        end
    end)
    
    return sliderFrame
end

-- Color Picker Component
function UILibrary:CreateColorPicker(text, default, callback)
    local colorFrame = Instance.new("Frame")
    colorFrame.Name = "ColorPicker"
    colorFrame.Size = UDim2.new(1, 0, 0, 40)
    colorFrame.BackgroundColor3 = Theme.Surface
    colorFrame.BorderSizePixel = 0
    colorFrame.Parent = self.ContentFrame
    
    CreateCorner(colorFrame, 8)
    CreateStroke(colorFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = colorFrame
    
    local colorPreview = Instance.new("TextButton")
    colorPreview.Name = "Preview"
    colorPreview.Size = UDim2.new(0, 35, 0, 25)
    colorPreview.Position = UDim2.new(1, -45, 0.5, -12.5)
    colorPreview.BackgroundColor3 = default or Theme.Primary
    colorPreview.BorderSizePixel = 0
    colorPreview.Text = ""
    colorPreview.Parent = colorFrame
    
    CreateCorner(colorPreview, 6)
    CreateStroke(colorPreview, 2, Theme.Border)
    
    -- Simple color picker (cycles through preset colors)
    local colors = {
        Theme.Primary,
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0)
    }
    
    local currentColorIndex = 1
    
    colorPreview.MouseButton1Click:Connect(function()
        currentColorIndex = (currentColorIndex % #colors) + 1
        local newColor = colors[currentColorIndex]
        
        TweenService:Create(colorPreview, AnimationInfo, {BackgroundColor3 = newColor}):Play()
        
        if callback then callback(newColor) end
    end)
    
    return colorFrame
end

-- Dropdown/Options List Component
function UILibrary:CreateDropdown(text, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundColor3 = Theme.Surface
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = self.ContentFrame
    
    CreateCorner(dropdownFrame, 8)
    CreateStroke(dropdownFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.Size = UDim2.new(0.5, -25, 0, 30)
    dropdownButton.Position = UDim2.new(0.5, 10, 0, 5)
    dropdownButton.BackgroundColor3 = Theme.Background
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = default or options[1] or "Select..."
    dropdownButton.TextColor3 = Theme.Text
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    CreateCorner(dropdownButton, 6)
    CreateStroke(dropdownButton, 1, Theme.Border)
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.Primary
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = dropdownButton
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Size = UDim2.new(0.5, -25, 0, #options * 30)
    optionsFrame.Position = UDim2.new(0.5, 10, 1, 5)
    optionsFrame.BackgroundColor3 = Theme.Background
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdownFrame
    
    CreateCorner(optionsFrame, 6)
    CreateStroke(optionsFrame, 1, Theme.Border)
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame
    
    local isOpen = false
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. i
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Theme.Background
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Theme.Text
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionsFrame
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, FastAnimationInfo, {BackgroundColor3 = Theme.Surface}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, FastAnimationInfo, {BackgroundColor3 = Theme.Background}):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            optionsFrame.Visible = false
            isOpen = false
            TweenService:Create(arrow, FastAnimationInfo, {Rotation = 0}):Play()
            
            if callback then callback(option, i) end
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        
        local targetRotation = isOpen and 180 or 0
        TweenService:Create(arrow, FastAnimationInfo, {Rotation = targetRotation}):Play()
    end)
    
    return dropdownFrame
end

-- TextBox/Input Component
function UILibrary:CreateTextBox(text, placeholder, callback)
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "TextBox"
    textboxFrame.Size = UDim2.new(1, 0, 0, 40)
    textboxFrame.BackgroundColor3 = Theme.Surface
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = self.ContentFrame
    
    CreateCorner(textboxFrame, 8)
    CreateStroke(textboxFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = textboxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "Input"
    textBox.Size = UDim2.new(0.7, -25, 0, 30)
    textBox.Position = UDim2.new(0.3, 10, 0, 5)
    textBox.BackgroundColor3 = Theme.Background
    textBox.BorderSizePixel = 0
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.TextColor3 = Theme.Text
    textBox.PlaceholderColor3 = Theme.TextSecondary
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = textboxFrame
    
    CreateCorner(textBox, 6)
    CreateStroke(textBox, 1, Theme.Border)
    
    textBox.Focused:Connect(function()
        TweenService:Create(textBox:FindFirstChild("UIStroke"), FastAnimationInfo, {Color = Theme.Primary}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(textBox:FindFirstChild("UIStroke"), FastAnimationInfo, {Color = Theme.Border}):Play()
        if callback then callback(textBox.Text) end
    end)
    
    return textboxFrame
end

-- Keybind Selector Component
function UILibrary:CreateKeybind(text, default, callback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "Keybind"
    keybindFrame.Size = UDim2.new(1, 0, 0, 40)
    keybindFrame.BackgroundColor3 = Theme.Surface
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = self.ContentFrame
    
    CreateCorner(keybindFrame, 8)
    CreateStroke(keybindFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = keybindFrame
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0.4, -25, 0, 30)
    keybindButton.Position = UDim2.new(0.6, 10, 0, 5)
    keybindButton.BackgroundColor3 = Theme.Background
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = default and default.Name or "None"
    keybindButton.TextColor3 = Theme.Text
    keybindButton.TextSize = 12
    keybindButton.Font = Enum.Font.Gotham
    keybindButton.Parent = keybindFrame
    
    CreateCorner(keybindButton, 6)
    CreateStroke(keybindButton, 1, Theme.Border)
    
    local currentKey = default
    local isListening = false
    
    keybindButton.MouseButton1Click:Connect(function()
        if isListening then return end
        
        isListening = true
        keybindButton.Text = "Press a key..."
        keybindButton.TextColor3 = Theme.Primary
        
        TweenService:Create(keybindButton:FindFirstChild("UIStroke"), FastAnimationInfo, {Color = Theme.Primary}):Play()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keybindButton.Text = input.KeyCode.Name
                keybindButton.TextColor3 = Theme.Text
                isListening = false
                
                TweenService:Create(keybindButton:FindFirstChild("UIStroke"), FastAnimationInfo, {Color = Theme.Border}):Play()
                
                if callback then callback(currentKey) end
                connection:Disconnect()
            end
        end)
        
        -- Timeout after 10 seconds
        wait(10)
        if isListening then
            isListening = false
            keybindButton.Text = currentKey and currentKey.Name or "None"
            keybindButton.TextColor3 = Theme.Text
            TweenService:Create(keybindButton:FindFirstChild("UIStroke"), FastAnimationInfo, {Color = Theme.Border}):Play()
            connection:Disconnect()
        end
    end)
    
    return keybindFrame
end

-- Section/Divider Component
function UILibrary:CreateSection(text)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = self.ContentFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Size = UDim2.new(0, 0, 1, 0)
    sectionLabel.Position = UDim2.new(0, 0, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = text
    sectionLabel.TextColor3 = Theme.Primary
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = sectionFrame
    
    -- Auto-size the label
    sectionLabel.Size = UDim2.new(0, sectionLabel.TextBounds.X, 1, 0)
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -sectionLabel.TextBounds.X - 10, 0, 1)
    divider.Position = UDim2.new(0, sectionLabel.TextBounds.X + 10, 0.5, 0)
    divider.BackgroundColor3 = Theme.Border
    divider.BorderSizePixel = 0
    divider.Parent = sectionFrame
    
    return sectionFrame
end

-- Notification System
function UILibrary:CreateNotification(title, message, duration, notificationType)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 20)
    notification.BackgroundColor3 = Theme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    
    CreateCorner(notification, 8)
    CreateStroke(notification, 2, notificationType == "error" and Theme.Error or 
                                 notificationType == "warning" and Theme.Warning or 
                                 notificationType == "success" and Theme.Success or Theme.Primary)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -20, 0, 45)
    messageLabel.Position = UDim2.new(0, 10, 0, 25)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Theme.TextSecondary
    messageLabel.TextSize = 12
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    -- Slide in animation
    notification.Position = UDim2.new(1, 0, 0, 20)
    TweenService:Create(notification, AnimationInfo, {Position = UDim2.new(1, -320, 0, 20)}):Play()
    
    -- Auto-hide after duration
    local hideDelay = duration or 3
    wait(hideDelay)
    
    TweenService:Create(notification, AnimationInfo, {Position = UDim2.new(1, 0, 0, 20)}):Play()
    wait(0.3)
    notification:Destroy()
end

-- Progress Bar Component
function UILibrary:CreateProgressBar(text, value, maxValue)
    local progressFrame = Instance.new("Frame")
    progressFrame.Name = "ProgressBar"
    progressFrame.Size = UDim2.new(1, 0, 0, 50)
    progressFrame.BackgroundColor3 = Theme.Surface
    progressFrame.BorderSizePixel = 0
    progressFrame.Parent = self.ContentFrame
    
    CreateCorner(progressFrame, 8)
    CreateStroke(progressFrame, 1, Theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = progressFrame
    
    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "Track"
    progressTrack.Size = UDim2.new(1, -20, 0, 8)
    progressTrack.Position = UDim2.new(0, 10, 0, 30)
    progressTrack.BackgroundColor3 = Theme.Border
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = progressFrame
    
    CreateCorner(progressTrack, 4)
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(math.clamp(value / maxValue, 0, 1), 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Theme.Primary
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressTrack
    
    CreateCorner(progressFill, 4)
    CreateGradient(progressFill, Theme.Primary, Theme.Secondary, 0)
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = "Percent"
    percentLabel.Size = UDim2.new(0, 50, 0, 20)
    percentLabel.Position = UDim2.new(1, -60, 0, 5)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = math.floor((value / maxValue) * 100) .. "%"
    percentLabel.TextColor3 = Theme.Primary
    percentLabel.TextSize = 12
    percentLabel.TextXAlignment = Enum.TextXAlignment.Right
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Parent = progressFrame
    
    -- Update method
    progressFrame.UpdateProgress = function(newValue)
        local percentage = math.clamp(newValue / maxValue, 0, 1)
        TweenService:Create(progressFill, AnimationInfo, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        percentLabel.Text = math.floor(percentage * 100) .. "%"
    end
    
    return progressFrame
end

-- Destroy Method
function UILibrary:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Example Usage Function
function UILibrary:CreateExample()
    -- Create sections and components
    self:CreateSection("Buttons & Toggles")
    
    self:CreateButton("Example Button", function()
        print("Button clicked!")
    end)
    
    self:CreateToggle("Enable Feature", false, function(state)
        print("Toggle state:", state)
    end)
    
    self:CreateSection("Inputs & Selection")
    
    self:CreateSlider("Volume", 0, 100, 50, function(value)
        print("Slider value:", value)
    end)
    
    self:CreateDropdown("Theme", {"Dark", "Light", "Auto"}, "Dark", function(selected)
        print("Selected theme:", selected)
    end)
    
    self:CreateTextBox("Username", "Enter your username", function(text)
        print("Username entered:", text)
    end)
    
    self:CreateKeybind("Toggle Key", Enum.KeyCode.F, function(key)
        print("Keybind set to:", key.Name)
    end)
    
    self:CreateSection("Visual Elements")
    
    self:CreateColorPicker("Accent Color", Theme.Primary, function(color)
        print("Color selected:", color)
    end)
    
    local progressBar = self:CreateProgressBar("Loading Progress", 75, 100)
    
    -- Example notification
    spawn(function()
        wait(2)
        self:CreateNotification("Welcome!", "UI Library loaded successfully", 3, "success")
    end)
end

return UILibrary
