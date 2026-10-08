--[[
    OTC Hub v1.0.2
    Progress element (read-only bar)
    by Aerlro
]]

local TweenService = game:GetService("TweenService")

local Progress = {}

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

--[[
    Settings = {
        Name = "Farm progress",
        Range = {0, 100},
        CurrentValue = 25,
        Suffix = "%",           -- optional: shows "<value><Suffix>" instead of a percentage
        Flag = "Progress"
    }
]]
function Progress.Create(Tab, OTC, Settings)
    Settings = Settings or {}

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Tab.Window.Theme]
            or OTC._Themes.Default
    end

    local Theme = getTheme()

    local Name = Settings.Name or "Progress"
    local Range = Settings.Range or { 0, 100 }
    local Min = tonumber(Range[1]) or 0
    local Max = tonumber(Range[2]) or 100
    local Suffix = Settings.Suffix
    local Flag = Settings.Flag
    local Value = tonumber(Settings.CurrentValue) or Min

    local Frame = create("Frame", {
        Name = "Progress",
        Parent = Tab.Page,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = Theme.Transparency and Theme.Transparency.Element or 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56)
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

    local Title = create("TextLabel", {
        Name = "Title",
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 8),
        Size = UDim2.new(1, -90, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local ValueLabel = create("TextLabel", {
        Name = "Value",
        Parent = Frame,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 0, 8),
        Size = UDim2.fromOffset(70, 20),
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local Track = create("Frame", {
        Name = "Track",
        Parent = Frame,
        BackgroundColor3 = Theme.SliderBackground or Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 1, -20),
        Size = UDim2.new(1, -30, 0, 8)
    })

    create("UICorner", { Parent = Track, CornerRadius = UDim.new(1, 0) })

    local Fill = create("Frame", {
        Name = "Fill",
        Parent = Track,
        BackgroundColor3 = Theme.SliderFill or Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1)
    })

    create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })

    local function alpha()
        if Max == Min then
            return 0
        end

        return math.clamp((Value - Min) / (Max - Min), 0, 1)
    end

    local function render(Instant)
        local Target = UDim2.fromScale(alpha(), 1)

        if Instant then
            Fill.Size = Target
        else
            TweenService:Create(
                Fill,
                TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Size = Target }
            ):Play()
        end

        if Suffix then
            ValueLabel.Text = tostring(math.floor(Value * 100 + 0.5) / 100) .. tostring(Suffix)
        else
            ValueLabel.Text = tostring(math.floor(alpha() * 100 + 0.5)) .. "%"
        end

        if Flag then
            OTC:SetFlag(Flag, Value)
        end
    end

    render(true)

    local Object = {}

    Object.Type = "Progress"
    Object.Instance = Frame
    Object.Flag = Flag
    Object.NoSave = true

    function Object:SetValue(NewValue)
        NewValue = tonumber(NewValue)

        if not NewValue then
            return
        end

        Value = math.clamp(NewValue, math.min(Min, Max), math.max(Min, Max))
        render(false)
    end

    function Object:GetValue()
        return Value
    end

    function Object:SetMax(NewMax)
        Max = tonumber(NewMax) or Max
        render(false)
    end

    function Object:SetName(NewName)
        Name = tostring(NewName)
        Title.Text = Name
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
        ValueLabel.TextColor3 = CurrentTheme.Accent
        Track.BackgroundColor3 = CurrentTheme.SliderBackground or CurrentTheme.Secondary
        Fill.BackgroundColor3 = CurrentTheme.SliderFill or CurrentTheme.Accent
    end

    function Object:Destroy()
        if Frame and Frame.Parent then
            Frame:Destroy()
        end
    end

    Tab:AddElement(Object)

    return Object
end

return Progress
