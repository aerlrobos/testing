--[[
    OTC Hub v1.0.3
    Color Picker element (saturation/value square + hue bar + hex input)
    by Aerlro
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local ColorPicker = {}

local BODY_HEIGHT = 150

local function create(Class, Properties)
    local Object = Instance.new(Class)
    local Parent = Properties.Parent

    for Key, Value in pairs(Properties) do
        if Key ~= "Parent" then
            Object[Key] = Value
        end
    end

    Object.Parent = Parent

    return Object
end

local function tween(Object, Time, Properties)
    local Animation = TweenService:Create(
        Object,
        TweenInfo.new(Time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        Properties
    )

    Animation:Play()

    return Animation
end

-- ScreenGui uses IgnoreGuiInset = true, so use raw screen coordinates
local function getPointer(Input)
    if Input.UserInputType == Enum.UserInputType.Touch then
        local Inset = GuiService:GetGuiInset()
        return Vector2.new(Input.Position.X + Inset.X, Input.Position.Y + Inset.Y)
    end

    return UserInputService:GetMouseLocation()
end

local function toHex(Color)
    return string.format(
        "#%02X%02X%02X",
        math.floor(Color.R * 255 + 0.5),
        math.floor(Color.G * 255 + 0.5),
        math.floor(Color.B * 255 + 0.5)
    )
end

local function fromHex(Text)
    Text = tostring(Text):gsub("#", ""):gsub("%s", "")

    if #Text ~= 6 or not Text:match("^%x+$") then
        return nil
    end

    return Color3.fromRGB(
        tonumber(Text:sub(1, 2), 16),
        tonumber(Text:sub(3, 4), 16),
        tonumber(Text:sub(5, 6), 16)
    )
end

--[[
    Settings = {
        Name = "ESP Color",
        Description = "optional",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "EspColor",
        Callback = function(Color3) end
    }
]]
function ColorPicker.Create(Tab, OTC, Settings)
    Settings = Settings or {}

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Tab.Window.Theme]
            or OTC._Themes.Default
    end

    local Theme = getTheme()

    local Name = Settings.Name or "Color Picker"
    local Description = Settings.Description
    local Flag = Settings.Flag
    local Callback = Settings.Callback or function() end
    local HeaderHeight = Description and 62 or 48

    local CurrentColor = Settings.Color or Settings.CurrentValue or Color3.fromRGB(255, 255, 255)
    local Hue, Sat, Val = CurrentColor:ToHSV()

    local Expanded = false
    local DraggingSV = false
    local DraggingHue = false
    local Connections = {}

    local Frame = create("Frame", {
        Name = "ColorPicker",
        Parent = Tab.Page,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = Theme.Transparency and Theme.Transparency.Element or 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, HeaderHeight)
    })

    local FrameCorner = create("UICorner", {
        Parent = Frame,
        CornerRadius = UDim.new(0, Theme.Corners and Theme.Corners.Element or 8)
    })

    local Stroke = create("UIStroke", {
        Parent = Frame,
        Color = Theme.Border,
        Thickness = Theme.Stroke and Theme.Stroke.Thickness or 1,
        Transparency = Theme.Stroke and Theme.Stroke.Transparency or 0
    })

    local Header = create("TextButton", {
        Name = "Header",
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, HeaderHeight),
        Text = "",
        AutoButtonColor = false
    })

    local Title = create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = Description and UDim2.fromOffset(15, 7) or UDim2.new(0, 15, 0.5, -12),
        Size = UDim2.new(1, -90, 0, 24),
        Font = Enum.Font.GothamMedium,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local DescriptionLabel

    if Description then
        DescriptionLabel = create("TextLabel", {
            Name = "Description",
            Parent = Header,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 31),
            Size = UDim2.new(1, -90, 0, 20),
            Font = Enum.Font.Gotham,
            Text = Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
    end

    local Swatch = create("Frame", {
        Name = "Swatch",
        Parent = Header,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(42, 22),
        BackgroundColor3 = CurrentColor,
        BorderSizePixel = 0
    })

    create("UICorner", { Parent = Swatch, CornerRadius = UDim.new(0, 6) })

    local SwatchStroke = create("UIStroke", {
        Parent = Swatch,
        Color = Theme.Border,
        Thickness = 1
    })

    -- Body (shown when expanded)
    local Body = create("Frame", {
        Name = "Body",
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, HeaderHeight),
        Size = UDim2.new(1, 0, 0, BODY_HEIGHT)
    })

    local SV = create("Frame", {
        Name = "SV",
        Parent = Body,
        Position = UDim2.fromOffset(15, 4),
        Size = UDim2.fromOffset(170, 130),
        BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
        BorderSizePixel = 0,
        Active = true
    })

    create("UICorner", { Parent = SV, CornerRadius = UDim.new(0, 6) })

    local White = create("Frame", {
        Name = "White",
        Parent = SV,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0
    })

    create("UICorner", { Parent = White, CornerRadius = UDim.new(0, 6) })

    create("UIGradient", {
        Parent = White,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    local Black = create("Frame", {
        Name = "Black",
        Parent = SV,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    })

    create("UICorner", { Parent = Black, CornerRadius = UDim.new(0, 6) })

    create("UIGradient", {
        Parent = Black,
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
    })

    local SVCursor = create("Frame", {
        Name = "Cursor",
        Parent = SV,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })

    create("UICorner", { Parent = SVCursor, CornerRadius = UDim.new(1, 0) })
    create("UIStroke", { Parent = SVCursor, Color = Color3.new(1, 1, 1), Thickness = 2 })

    local HueBar = create("Frame", {
        Name = "Hue",
        Parent = Body,
        Position = UDim2.fromOffset(197, 4),
        Size = UDim2.fromOffset(18, 130),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true
    })

    create("UICorner", { Parent = HueBar, CornerRadius = UDim.new(0, 6) })

    create("UIGradient", {
        Parent = HueBar,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
            ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
            ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
        })
    })

    local HueCursor = create("Frame", {
        Name = "Cursor",
        Parent = HueBar,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 6, 0, 6),
        Position = UDim2.fromScale(0.5, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })

    create("UICorner", { Parent = HueCursor, CornerRadius = UDim.new(1, 0) })
    create("UIStroke", { Parent = HueCursor, Color = Color3.new(1, 1, 1), Thickness = 2 })

    local HexBox = create("TextBox", {
        Name = "Hex",
        Parent = Body,
        Position = UDim2.fromOffset(231, 4),
        Size = UDim2.fromOffset(100, 30),
        BackgroundColor3 = Theme.Input or Theme.Background,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.GothamMedium,
        PlaceholderText = "#FFFFFF",
        Text = toHex(CurrentColor),
        TextColor3 = Theme.Text,
        TextSize = 12
    })

    create("UICorner", {
        Parent = HexBox,
        CornerRadius = UDim.new(0, Theme.Corners and Theme.Corners.Input or 8)
    })

    local HexStroke = create("UIStroke", {
        Parent = HexBox,
        Color = Theme.Border,
        Thickness = 1
    })

    local RGBLabel = create("TextLabel", {
        Name = "RGB",
        Parent = Body,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(231, 40),
        Size = UDim2.fromOffset(150, 18),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local function refresh(RunCallback)
        CurrentColor = Color3.fromHSV(Hue, Sat, Val)

        Swatch.BackgroundColor3 = CurrentColor
        SV.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
        SVCursor.Position = UDim2.fromScale(Sat, 1 - Val)
        HueCursor.Position = UDim2.fromScale(0.5, Hue)

        if not HexBox:IsFocused() then
            HexBox.Text = toHex(CurrentColor)
        end

        RGBLabel.Text = string.format(
            "R %d   G %d   B %d",
            math.floor(CurrentColor.R * 255 + 0.5),
            math.floor(CurrentColor.G * 255 + 0.5),
            math.floor(CurrentColor.B * 255 + 0.5)
        )

        if Flag then
            OTC:SetFlag(Flag, CurrentColor)
        end

        if RunCallback then
            local Success, Error = pcall(Callback, CurrentColor)

            if not Success then
                warn("[OTC Hub] ColorPicker callback error:", Error)
            end
        end
    end

    local function updateSV(Input)
        local Pointer = getPointer(Input)

        Sat = math.clamp((Pointer.X - SV.AbsolutePosition.X) / math.max(SV.AbsoluteSize.X, 1), 0, 1)
        Val = 1 - math.clamp((Pointer.Y - SV.AbsolutePosition.Y) / math.max(SV.AbsoluteSize.Y, 1), 0, 1)

        refresh(true)
    end

    local function updateHue(Input)
        local Pointer = getPointer(Input)

        Hue = math.clamp((Pointer.Y - HueBar.AbsolutePosition.Y) / math.max(HueBar.AbsoluteSize.Y, 1), 0, 0.999)

        refresh(true)
    end

    local function isPress(Input)
        return Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
    end

    SV.InputBegan:Connect(function(Input)
        if isPress(Input) then
            DraggingSV = true
            updateSV(Input)
        end
    end)

    HueBar.InputBegan:Connect(function(Input)
        if isPress(Input) then
            DraggingHue = true
            updateHue(Input)
        end
    end)

    table.insert(Connections, UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if DraggingSV then
            updateSV(Input)
        elseif DraggingHue then
            updateHue(Input)
        end
    end))

    table.insert(Connections, UserInputService.InputEnded:Connect(function(Input)
        if isPress(Input) then
            DraggingSV = false
            DraggingHue = false
        end
    end))

    HexBox.FocusLost:Connect(function()
        local Parsed = fromHex(HexBox.Text)

        if Parsed then
            Hue, Sat, Val = Parsed:ToHSV()
            refresh(true)
        else
            HexBox.Text = toHex(CurrentColor)
        end
    end)

    Header.MouseButton1Click:Connect(function()
        Expanded = not Expanded

        tween(Frame, 0.25, {
            Size = UDim2.new(1, 0, 0, HeaderHeight + (Expanded and BODY_HEIGHT or 0))
        })
    end)

    Header.MouseEnter:Connect(function()
        tween(Stroke, 0.15, { Color = getTheme().BorderHover or getTheme().Border })
    end)

    Header.MouseLeave:Connect(function()
        tween(Stroke, 0.15, { Color = getTheme().Border })
    end)

    Frame.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            for _, Connection in ipairs(Connections) do
                Connection:Disconnect()
            end

            table.clear(Connections)
        end
    end)

    refresh(false)

    local Object = {}

    Object.Type = "ColorPicker"
    Object.Instance = Frame
    Object.Flag = Flag

    function Object:SetValue(Value)
        if type(Value) == "string" then
            Value = fromHex(Value)
        end

        if typeof(Value) ~= "Color3" then
            return
        end

        Hue, Sat, Val = Value:ToHSV()
        refresh(true)
    end

    function Object:GetValue()
        return CurrentColor
    end

    function Object:SetName(NewName)
        Name = tostring(NewName)
        Title.Text = Name
    end

    function Object:SetCallback(NewCallback)
        if type(NewCallback) == "function" then
            Callback = NewCallback
        end
    end

    function Object:RefreshTheme()
        if not Frame or not Frame.Parent then
            return
        end

        local CurrentTheme = getTheme()
        local StrokeSettings = CurrentTheme.Stroke or {}

        Frame.BackgroundColor3 = CurrentTheme.Element
        Frame.BackgroundTransparency = CurrentTheme.Transparency and CurrentTheme.Transparency.Element or 0
        FrameCorner.CornerRadius = UDim.new(0, CurrentTheme.Corners and CurrentTheme.Corners.Element or 8)
        Stroke.Color = CurrentTheme.Border
        Stroke.Thickness = StrokeSettings.Thickness or 1
        Stroke.Enabled = StrokeSettings.Enabled ~= false
        Title.TextColor3 = CurrentTheme.Text

        if DescriptionLabel then
            DescriptionLabel.TextColor3 = CurrentTheme.SubText
        end

        SwatchStroke.Color = CurrentTheme.Border
        HexBox.BackgroundColor3 = CurrentTheme.Input or CurrentTheme.Background
        HexBox.TextColor3 = CurrentTheme.Text
        HexStroke.Color = CurrentTheme.Border
        RGBLabel.TextColor3 = CurrentTheme.SubText
    end

    function Object:Destroy()
        if Frame and Frame.Parent then
            Frame:Destroy()
        end
    end

    Tab:AddElement(Object)

    return Object
end

return ColorPicker
