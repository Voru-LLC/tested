-- Simpliness UI Library for Roblox
-- Dark grey and magenta theme with 80% transparency and smooth animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Simpliness = {}
Simpliness.__index = Simpliness

-- Theme Configuration
local Theme = {
    Colors = {
        Background = Color3.fromRGB(45, 45, 45),
        WindowBg = Color3.fromRGB(40, 40, 40),
        ElementBg = Color3.fromRGB(60, 60, 60),
        Accent = Color3.fromRGB(255, 64, 129), -- Magenta/Pink
        Text = Color3.fromRGB(224, 224, 224),
        TextDim = Color3.fromRGB(160, 160, 160),
        Border = Color3.fromRGB(255, 255, 255),
        MacRed = Color3.fromRGB(255, 95, 87),
        MacYellow = Color3.fromRGB(255, 189, 46),
        MacGreen = Color3.fromRGB(40, 202, 66)
    },
    Transparency = {
        Window = 0.2, -- 80% transparency
        Element = 0.4,
        ElementHover = 0.3,
        ElementActive = 0.1
    },
    Animation = {
        Speed = 0.3,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }
}

-- Create main window
function Simpliness.new(title)
    local self = setmetatable({}, Simpliness)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SimplinessUI"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main window frame
    self.Window = Instance.new("Frame")
    self.Window.Name = "Window"
    self.Window.Parent = self.ScreenGui
    self.Window.Size = UDim2.new(0, 400, 0, 600)
    self.Window.Position = UDim2.new(0.5, -200, 0.5, -300)
    self.Window.BackgroundColor3 = Theme.Colors.Background
    self.Window.BackgroundTransparency = Theme.Transparency.Window
    self.Window.BorderSizePixel = 0
    
    -- Corner radius
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 12)
    windowCorner.Parent = self.Window
    
    -- Window border
    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Theme.Colors.Border
    windowStroke.Transparency = 0.9
    windowStroke.Thickness = 1
    windowStroke.Parent = self.Window
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.Window
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = Theme.Colors.WindowBg
    self.TitleBar.BackgroundTransparency = 0.1
    self.TitleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    -- Traffic lights (macOS style)
    self:CreateTrafficLights()
    
    -- Title text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Parent = self.TitleBar
    self.TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 60, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "Simpliness"
    self.TitleLabel.TextColor3 = Theme.Colors.Text
    self.TitleLabel.TextSize = 14
    self.TitleLabel.Font = Enum.Font.GothamMedium
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Content area
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Name = "Content"
    self.Content.Parent = self.Window
    self.Content.Size = UDim2.new(1, -40, 1, -60)
    self.Content.Position = UDim2.new(0, 20, 0, 50)
    self.Content.BackgroundTransparency = 1
    self.Content.BorderSizePixel = 0
    self.Content.ScrollBarThickness = 4
    self.Content.ScrollBarImageColor3 = Theme.Colors.Accent
    self.Content.ScrollBarImageTransparency = 0.3
    self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = self.Content
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Make window draggable
    self:MakeWindowDraggable()
    
    self.TabSystem = {}
    self.CurrentTab = nil
    
    return self
end

-- Create traffic lights (macOS window controls)
function Simpliness:CreateTrafficLights()
    local lightContainer = Instance.new("Frame")
    lightContainer.Name = "TrafficLights"
    lightContainer.Parent = self.TitleBar
    lightContainer.Size = UDim2.new(0, 60, 0, 20)
    lightContainer.Position = UDim2.new(0, 15, 0.5, -10)
    lightContainer.BackgroundTransparency = 1
    
    local lightLayout = Instance.new("UIListLayout")
    lightLayout.Parent = lightContainer
    lightLayout.FillDirection = Enum.FillDirection.Horizontal
    lightLayout.Padding = UDim.new(0, 8)
    lightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
    -- Close button
    local closeBtn = self:CreateTrafficLight(Theme.Colors.MacRed, function()
        self:Destroy()
    end)
    closeBtn.Parent = lightContainer
    closeBtn.LayoutOrder = 1
    
    -- Minimize button
    local minimizeBtn = self:CreateTrafficLight(Theme.Colors.MacYellow, function()
        self:ToggleMinimize()
    end)
    minimizeBtn.Parent = lightContainer
    minimizeBtn.LayoutOrder = 2
    
    -- Maximize button (unused but for aesthetics)
    local maximizeBtn = self:CreateTrafficLight(Theme.Colors.MacGreen, function()
        -- Could implement maximize functionality
    end)
    maximizeBtn.Parent = lightContainer
    maximizeBtn.LayoutOrder = 3
end

function Simpliness:CreateTrafficLight(color, callback)
    local light = Instance.new("TextButton")
    light.Size = UDim2.new(0, 12, 0, 12)
    light.BackgroundColor3 = color
    light.BorderSizePixel = 0
    light.Text = ""
    light.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = light
    
    -- Hover animation
    light.MouseEnter:Connect(function()
        TweenService:Create(light, TweenInfo.new(0.2), {Size = UDim2.new(0, 13, 0, 13)}):Play()
    end)
    
    light.MouseLeave:Connect(function()
        TweenService:Create(light, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12)}):Play()
    end)
    
    light.MouseButton1Click:Connect(callback)
    
    return light
end

-- Make window draggable
function Simpliness:MakeWindowDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            self.Window.Position = newPos
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create tab system
function Simpliness:CreateTabs()
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = self.Content
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.BackgroundTransparency = 1
    tabContainer.LayoutOrder = 0
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    
    self.TabContainer = tabContainer
    return self
end

function Simpliness:AddTab(name)
    if not self.TabContainer then
        self:CreateTabs()
    end
    
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Parent = self.TabContainer
    tab.Size = UDim2.new(0, 80, 1, 0)
    tab.BackgroundColor3 = Theme.Colors.ElementBg
    tab.BackgroundTransparency = Theme.Transparency.Element
    tab.BorderSizePixel = 0
    tab.Text = name
    tab.TextColor3 = Theme.Colors.TextDim
    tab.TextSize = 12
    tab.Font = Enum.Font.Gotham
    tab.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tab
    
    -- Tab content
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Parent = self.Content
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.LayoutOrder = 1
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = tabContent
    contentLayout.Padding = UDim.new(0, 10)
    
    -- Auto-resize tab content
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
    end)
    
    self.TabSystem[name] = {
        Button = tab,
        Content = tabContent
    }
    
    tab.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Hover effects
    tab.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundTransparency = Theme.Transparency.ElementHover,
                Position = UDim2.new(0, 0, 0, -2)
            }):Play()
        end
    end)
    
    tab.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundTransparency = Theme.Transparency.Element,
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
    end)
    
    -- If this is the first tab, make it active
    if not self.CurrentTab then
        self:SwitchTab(name)
    end
    
    return tabContent
end

function Simpliness:SwitchTab(tabName)
    -- Deactivate current tab
    if self.CurrentTab and self.TabSystem[self.CurrentTab] then
        local oldTab = self.TabSystem[self.CurrentTab]
        TweenService:Create(oldTab.Button, TweenInfo.new(0.3), {
            BackgroundTransparency = Theme.Transparency.Element,
            TextColor3 = Theme.Colors.TextDim,
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        oldTab.Content.Visible = false
    end
    
    -- Activate new tab
    if self.TabSystem[tabName] then
        local newTab = self.TabSystem[tabName]
        TweenService:Create(newTab.Button, TweenInfo.new(0.3), {
            BackgroundTransparency = Theme.Transparency.ElementActive,
            TextColor3 = Theme.Colors.Accent,
            Position = UDim2.new(0, 0, 0, -2)
        }):Play()
        newTab.Content.Visible = true
        self.CurrentTab = tabName
    end
end

-- Create input field
function Simpliness:CreateInput(parent, placeholder, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Parent = parent
    inputFrame.Size = UDim2.new(1, 0, 0, 35)
    inputFrame.BackgroundTransparency = 1
    
    local input = Instance.new("TextBox")
    input.Parent = inputFrame
    input.Size = UDim2.new(1, 0, 1, 0)
    input.BackgroundColor3 = Theme.Colors.ElementBg
    input.BackgroundTransparency = Theme.Transparency.Element
    input.BorderSizePixel = 0
    input.PlaceholderText = placeholder or ""
    input.Text = ""
    input.TextColor3 = Theme.Colors.Text
    input.PlaceholderColor3 = Theme.Colors.TextDim
    input.TextSize = 13
    input.Font = Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = input
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Border
    stroke.Transparency = 0.9
    stroke.Thickness = 1
    stroke.Parent = input
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = input
    
    -- Focus animations
    input.Focused:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.3), {
            BackgroundTransparency = Theme.Transparency.ElementHover
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Color = Theme.Colors.Accent,
            Transparency = 0.5
        }):Play()
    end)
    
    input.FocusLost:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.3), {
            BackgroundTransparency = Theme.Transparency.Element
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Color = Theme.Colors.Border,
            Transparency = 0.9
        }):Play()
        
        if callback then
            callback(input.Text)
        end
    end)
    
    return input
end

-- Create toggle/switch
function Simpliness:CreateToggle(parent, text, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = toggleFrame
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBg = Instance.new("TextButton")
    toggleBg.Parent = toggleFrame
    toggleBg.Size = UDim2.new(0, 44, 0, 24)
    toggleBg.Position = UDim2.new(1, -44, 0.5, -12)
    toggleBg.BackgroundColor3 = Theme.Colors.ElementBg
    toggleBg.BackgroundTransparency = Theme.Transparency.Element
    toggleBg.BorderSizePixel = 0
    toggleBg.Text = ""
    toggleBg.AutoButtonColor = false
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = toggleBg
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Parent = toggleBg
    toggleKnob.Size = UDim2.new(0, 20, 0, 20)
    toggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = toggleKnob
    
    local isToggled = defaultState or false
    
    local function updateToggle()
        if isToggled then
            TweenService:Create(toggleBg, TweenInfo.new(0.3), {
                BackgroundColor3 = Theme.Colors.Accent
            }):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 22, 0.5, -10)
            }):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.3), {
                BackgroundColor3 = Theme.Colors.ElementBg
            }):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 2, 0.5, -10)
            }):Play()
        end
    end
    
    toggleBg.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if callback then
            callback(isToggled)
        end
    end)
    
    -- Initial state
    updateToggle()
    
    return toggleFrame
end

-- Create dropdown/select
function Simpliness:CreateDropdown(parent, options, defaultText, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Parent = parent
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.ZIndex = 10
    
    local dropdown = Instance.new("TextButton")
    dropdown.Parent = dropdownFrame
    dropdown.Size = UDim2.new(1, 0, 1, 0)
    dropdown.BackgroundColor3 = Theme.Colors.ElementBg
    dropdown.BackgroundTransparency = Theme.Transparency.Element
    dropdown.BorderSizePixel = 0
    dropdown.Text = defaultText or "Select Option"
    dropdown.TextColor3 = Theme.Colors.Text
    dropdown.TextSize = 13
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = dropdown
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 32)
    padding.Parent = dropdown
    
    -- Arrow icon
    local arrow = Instance.new("TextLabel")
    arrow.Parent = dropdown
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.Colors.TextDim
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Gotham
    
    -- Options frame
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Parent = dropdownFrame
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Theme.Colors.ElementBg
    optionsFrame.BackgroundTransparency = Theme.Transparency.ElementHover
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 15
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame
    
    local isOpen = false
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Parent = optionsFrame
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.BackgroundTransparency = 1
        optionBtn.Text = option
        optionBtn.TextColor3 = Theme.Colors.Text
        optionBtn.TextSize = 13
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        optionBtn.AutoButtonColor = false
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 12)
        optionPadding.Parent = optionBtn
        
        optionBtn.MouseEnter:Connect(function()
            TweenService:Create(optionBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Colors.Accent,
                BackgroundTransparency = 0.8
            }):Play()
        end)
        
        optionBtn.MouseLeave:Connect(function()
            TweenService:Create(optionBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Text = option
            optionsFrame.Visible = false
            isOpen = false
            TweenService:Create(arrow, TweenInfo.new(0.3), {
                Rotation = 0
            }):Play()
            if callback then
                callback(option, i)
            end
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.3), {
            Rotation = isOpen and 180 or 0
        }):Play()
    end)
    
    return dropdown
end

-- Create slider
function Simpliness:CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = sliderFrame
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = sliderFrame
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Theme.Colors.Accent
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = sliderFrame
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Theme.Colors.ElementBg
    sliderBg.BackgroundTransparency = Theme.Transparency.Element
    sliderBg.BorderSizePixel = 0
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Theme.Colors.Accent
    sliderFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("TextButton")
    sliderKnob.Parent = sliderBg
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new(0, -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = Theme.Colors.Accent
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Text = ""
    sliderKnob.AutoButtonColor = false
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = sliderKnob
    
    local currentValue = default or min
    local isDragging = false
    
    local function updateSlider(value)
        currentValue = math.clamp(value, min, max)
        local percentage = (currentValue - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(math.floor(currentValue))
        
        if callback then
            callback(currentValue)
        end
    end
    
    local function getValueFromPosition(x)
        local relativeX = math.clamp((x - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        return min + (max - min) * relativeX
    end
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            TweenService:Create(sliderKnob, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new((currentValue - min) / (max - min), -10, 0.5, -10)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newValue = getValueFromPosition(input.Position.X)
            updateSlider(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
            isDragging = false
            TweenService:Create(sliderKnob, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
            }):Play()
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local newValue = getValueFromPosition(input.Position.X)
            updateSlider(newValue)
        end
    end)
    
    -- Initialize slider
    updateSlider(currentValue)
    
    return sliderFrame
end

-- Create button
function Simpliness:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Theme.Colors.Accent
    button.BackgroundTransparency = Theme.Transparency.ElementHover
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover and click animations
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = Theme.Transparency.ElementActive,
            Size = UDim2.new(1, 0, 0, 37)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = Theme.Transparency.ElementHover,
            Size = UDim2.new(1, 0, 0, 35)
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -4, 0, 33),
            Position = UDim2.new(0, 2, 0, 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 37),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Create section/label
function Simpliness:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Parent = parent
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = section
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Theme.Colors.TextDim
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Bottom
    
    return section
end

-- Create separator line
function Simpliness:CreateSeparator(parent)
    local separator = Instance.new("Frame")
    separator.Parent = parent
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = Theme.Colors.Border
    separator.BackgroundTransparency = 0.8
    separator.BorderSizePixel = 0
    
    return separator
end

-- Minimize functionality
function Simpliness:ToggleMinimize()
    local isMinimized = self.Window.Size.Y.Offset <= 40
    
    if isMinimized then
        -- Restore window
        TweenService:Create(self.Window, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 400, 0, 600)
        }):Play()
        self.Content.Visible = true
    else
        -- Minimize window
        TweenService:Create(self.Window, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 400, 0, 40)
        }):Play()
        wait(0.2)
        self.Content.Visible = false
    end
end

-- Destroy window
function Simpliness:Destroy()
    -- Fade out animation
    TweenService:Create(self.Window, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 350, 0, 550)
    }):Play()
    
    -- Destroy after animation
    wait(0.3)
    self.ScreenGui:Destroy()
end

-- Set window visibility
function Simpliness:SetVisible(visible)
    self.Window.Visible = visible
end

-- Get window visibility
function Simpliness:IsVisible()
    return self.Window.Visible
end

--[[
    USAGE EXAMPLE:

    -- Create main window
    local ui = Simpliness.new("Simpliness")

    -- Create tabs
    ui:CreateTabs()
    local aimTab = ui:AddTab("Aimbot")
    local miscTab = ui:AddTab("Misc")

    -- Add elements to Aimbot tab
    ui:CreateSection(aimTab, "Aimbot Settings")
    
    ui:CreateToggle(aimTab, "Toggle Aimbot", false, function(state)
        print("Aimbot:", state)
    end)

    ui:CreateInput(aimTab, "Mon Textbox", function(text)
        print("Input text:", text)
    end)

    ui:CreateDropdown(aimTab, {"Option 1", "Option 2", "Option..."}, "Select Option", function(selected, index)
        print("Selected:", selected, "Index:", index)
    end)

    ui:CreateSlider(aimTab, "Text Slider", 0, 100, 46, function(value)
        print("Slider value:", value)
    end)

    ui:CreateButton(aimTab, "Test Button", function()
        print("Button clicked!")
    end)

    -- Add elements to Misc tab
    ui:CreateSection(miscTab, "Miscellaneous")
    
    ui:CreateToggle(miscTab, "Another Toggle", true, function(state)
        print("Misc toggle:", state)
    end)

    ui:CreateSeparator(miscTab)
    
    ui:CreateButton(miscTab, "Close GUI", function()
        ui:Destroy()
    end)
]]

return Simpliness
