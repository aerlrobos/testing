--[[
    OTC Hub v1
    Slider Element
    by Aerlro
]]

local Slider = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function create(Class, Properties)
    local Object = Instance.new(Class)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    return Object
end

local function tween(Object, Time, Properties)
    if not Object or not Object.Parent then
        return
    end

    local Animation = TweenService:Create(
        Object,
        TweenInfo.new(
            Time or 0.2,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        Properties
    )

    Animation:Play()

    return Animation
end

local function applyGradient(Object, GradientData)
    if not Object then
        return
    end

    local Existing =
        Object:FindFirstChild("OTCGradient")

    if Existing then
        Existing:Destroy()
    end

    if not GradientData
        or GradientData.Enabled ~= true
        or not GradientData.Colors then
        return
    end

    local Gradient =
        Instance.new("UIGradient")

    Gradient.Name =
        "OTCGradient"

    Gradient.Color =
        GradientData.Colors

    Gradient.Rotation =
        GradientData.Rotation or 0

    Gradient.Parent =
        Object

    return Gradient
end

function Slider.Create(Tab, OTC, Settings)

    Settings = Settings or {}

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Tab.Window.Theme]
            or OTC._Themes.Default
    end

    local Theme =
        getTheme()

    local Name =
        Settings.Name
        or "Slider"

    local Description =
        Settings.Description

    local Min =
        tonumber(Settings.Min)
        or 0

    local Max =
        tonumber(Settings.Max)
        or 100

    local Default =
        tonumber(Settings.Default)
        or Min

    local Increment =
        tonumber(Settings.Increment)
        or 1

    local Flag =
        Settings.Flag

    local Callback =
        Settings.Callback
        or function()
        end

    if Max < Min then
        Min, Max = Max, Min
    end

    local function round(Value)

        return math.floor(
            ((Value - Min) / Increment)
                + 0.5
        ) * Increment + Min

    end

    local function clamp(Value)

        return math.clamp(
            round(Value),
            Min,
            Max
        )

    end

    local CurrentValue =
        clamp(Default)

    local FrameHeight =
        Description
        and 78
        or 64

    local Frame =
        create("Frame", {
            Name = "Slider",

            Parent = Tab.Page,

            BackgroundColor3 =
                Theme.Element,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    FrameHeight
                )
        })

    local FrameCorner =
        create("UICorner", {
            Parent = Frame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Element
                    or 8
                )
        })

    local Stroke =
        create("UIStroke", {
            Parent = Frame,

            Color =
                Theme.Border,

            Thickness =
                Theme.Stroke
                and Theme.Stroke.Thickness
                or 1,

            Transparency =
                Theme.Stroke
                and Theme.Stroke.Transparency
                or 0
        })

    if Theme.Stroke then
        Stroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local Title =
        create("TextLabel", {
            Name = "Title",

            Parent = Frame,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(
                    15,
                    8
                ),

            Size =
                UDim2.new(
                    1,
                    -90,
                    0,
                    22
                ),

            Font =
                Enum.Font.GothamMedium,

            Text =
                Name,

            TextColor3 =
                Theme.Text,

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left
        })

    local ValueLabel =
        create("TextLabel", {
            Name = "Value",

            Parent = Frame,

            BackgroundTransparency = 1,

            AnchorPoint =
                Vector2.new(
                    1,
                    0
                ),

            Position =
                UDim2.new(
                    1,
                    -15,
                    0,
                    8
                ),

            Size =
                UDim2.fromOffset(
                    65,
                    22
                ),

            Font =
                Enum.Font.GothamMedium,

            Text =
                tostring(CurrentValue),

            TextColor3 =
                Theme.Accent,

            TextSize = 12,

            TextXAlignment =
                Enum.TextXAlignment.Right
        })

    local DescriptionLabel

    if Description then

        DescriptionLabel =
            create("TextLabel", {
                Name = "Description",

                Parent = Frame,

                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        15,
                        29
                    ),

                Size =
                    UDim2.new(
                        1,
                        -30,
                        0,
                        18
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    Description,

                TextColor3 =
                    Theme.SubText,

                TextSize = 10,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            })
    end

    local SliderBackground =
        create("Frame", {
            Name = "SliderBackground",

            Parent = Frame,

            BackgroundColor3 =
                Theme.SliderBackground
                or Theme.Background,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            Position =
                UDim2.new(
                    0,
                    15,
                    1,
                    -25
                ),

            Size =
                UDim2.new(
                    1,
                    -30,
                    0,
                    6
                )
        })

    local SliderBackgroundCorner =
        create("UICorner", {
            Parent =
                SliderBackground,

            CornerRadius =
                UDim.new(
                    1,
                    0
                )
        })

    local SliderBackgroundStroke =
        create("UIStroke", {
            Parent =
                SliderBackground,

            Color =
                Theme.Border,

            Thickness =
                Theme.Stroke
                and Theme.Stroke.Thickness
                or 1,

            Transparency =
                Theme.Stroke
                and Theme.Stroke.Transparency
                or 0
        })

    if Theme.Stroke then
        SliderBackgroundStroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local Fill =
        create("Frame", {
            Name = "Fill",

            Parent =
                SliderBackground,

            BackgroundColor3 =
                Theme.SliderFill
                or Theme.Accent,

            BackgroundTransparency = 0,

            BorderSizePixel = 0,

            Size =
                UDim2.new(
                    0,
                    0,
                    1,
                    0
                )
        })

    local FillCorner =
        create("UICorner", {
            Parent = Fill,

            CornerRadius =
                UDim.new(
                    1,
                    0
                )
        })

    local Knob =
        create("Frame", {
            Name = "Knob",

            Parent =
                SliderBackground,

            BackgroundColor3 =
                Theme.SliderKnob
                or Theme.Text,

            BorderSizePixel = 0,

            AnchorPoint =
                Vector2.new(
                    0.5,
                    0.5
                ),

            Position =
                UDim2.new(
                    0,
                    0,
                    0.5,
                    0
                ),

            Size =
                UDim2.fromOffset(
                    12,
                    12
                )
        })

    local KnobCorner =
        create("UICorner", {
            Parent = Knob,

            CornerRadius =
                UDim.new(
                    1,
                    0
                )
        })

    local KnobStroke =
        create("UIStroke", {
            Parent = Knob,

            Color =
                Theme.Accent,

            Thickness =
                Theme.Stroke
                and math.max(
                    Theme.Stroke.Thickness,
                    1
                )
                or 2,

            Transparency =
                Theme.Stroke
                and Theme.Stroke.Transparency
                or 0
        })

    if Theme.Stroke then
        KnobStroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local Interaction =
        create("TextButton", {
            Name = "Interaction",

            Parent =
                SliderBackground,

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                ),

            Text = "",

            AutoButtonColor = false
        })

    local Dragging = false
    local Hovered = false

    local function getValueFromPosition(X)

        local AbsolutePosition =
            SliderBackground.AbsolutePosition.X

        local AbsoluteSize =
            SliderBackground.AbsoluteSize.X

        if AbsoluteSize <= 0 then
            return CurrentValue
        end

        local Percent =
            math.clamp(
                (X - AbsolutePosition)
                    / AbsoluteSize,
                0,
                1
            )

        local Value =
            Min
                + (
                    (Max - Min)
                    * Percent
                )

        return clamp(Value)

    end

    local function update(Value, RunCallback)

        CurrentValue =
            clamp(Value)

        local Percent

        if Max == Min then

            Percent = 0

        else

            Percent =
                (
                    CurrentValue
                    - Min
                )
                / (
                    Max
                    - Min
                )

        end

        ValueLabel.Text =
            tostring(CurrentValue)

        tween(
            Fill,
            0.12,
            {
                Size =
                    UDim2.new(
                        Percent,
                        0,
                        1,
                        0
                    )
            }
        )

        tween(
            Knob,
            0.12,
            {
                Position =
                    UDim2.new(
                        Percent,
                        0,
                        0.5,
                        0
                    )
            }
        )

        if Flag then

            OTC:SetFlag(
                Flag,
                CurrentValue
            )

        end

        if RunCallback then

            local Success, Error =
                pcall(
                    Callback,
                    CurrentValue
                )

            if not Success then

                warn(
                    "[OTC Hub] Slider callback error:",
                    Error
                )

            end
        end
    end

    Interaction.MouseButton1Down:Connect(
        function()

            Dragging = true

            local Value =
                getValueFromPosition(
                    UserInputService
                        :GetMouseLocation()
                        .X
                )

            update(
                Value,
                true
            )

        end
    )

    UserInputService.InputChanged:Connect(
        function(Input)

            if not Dragging then
                return
            end

            if Input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or Input.UserInputType ==
                Enum.UserInputType.Touch then

                local Value =
                    getValueFromPosition(
                        Input.Position.X
                    )

                update(
                    Value,
                    true
                )

            end

        end
    )

    UserInputService.InputEnded:Connect(
        function(Input)

            if Input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or Input.UserInputType ==
                Enum.UserInputType.Touch then

                Dragging = false

            end
        end
    )

    Interaction.MouseEnter:Connect(
        function()

            Hovered = true

            local CurrentTheme =
                getTheme()

            tween(
                Knob,
                0.15,
                {
                    Size =
                        UDim2.fromOffset(
                            15,
                            15
                        )
                }
            )

            tween(
                Stroke,
                0.15,
                {
                    Color =
                        CurrentTheme.BorderHover
                        or CurrentTheme.AccentDark
                        or CurrentTheme.Border
                }
            )

        end
    )

    Interaction.MouseLeave:Connect(
        function()

            Hovered = false

            if not Dragging then

                local CurrentTheme =
                    getTheme()

                tween(
                    Knob,
                    0.15,
                    {
                        Size =
                            UDim2.fromOffset(
                                12,
                                12
                            )
                    }
                )

                tween(
                    Stroke,
                    0.15,
                    {
                        Color =
                            CurrentTheme.Border
                    }
                )

            end
        end
    )

    update(
        CurrentValue,
        false
    )

    local Object = {}

    Object.Type =
        "Slider"

    Object.Instance =
        Frame

    Object.Interaction =
        Interaction

    Object.Fill =
        Fill

    Object.Knob =
        Knob

    Object.Stroke =
        Stroke

    Object.ValueLabel =
        ValueLabel

    function Object:SetValue(Value)

        update(
            Value,
            true
        )

    end

    function Object:GetValue()

        return CurrentValue

    end

    function Object:SetMin(Value)

        Min =
            tonumber(Value)
            or Min

        if Max < Min then
            Max = Min
        end

        update(
            CurrentValue,
            false
        )

    end

    function Object:SetMax(Value)

        Max =
            tonumber(Value)
            or Max

        if Max < Min then
            Min = Max
        end

        update(
            CurrentValue,
            false
        )

    end

    function Object:SetName(NewName)

        Name =
            tostring(
                NewName
            )

        Title.Text =
            Name

    end

    function Object:SetCallback(NewCallback)

        if type(NewCallback)
            == "function" then

            Callback =
                NewCallback

        end

    end

    function Object:RefreshTheme()

        if not Frame
            or not Frame.Parent then
            return
        end

        local CurrentTheme =
            getTheme()

        local Transparency =
            CurrentTheme.Transparency
            or {}

        local StrokeSettings =
            CurrentTheme.Stroke
            or {}

        local Corners =
            CurrentTheme.Corners
            or {}

        local Effects =
            CurrentTheme.Effects
            or {}

        local Gradients =
            CurrentTheme.Gradients
            or {}

        Frame.BackgroundColor3 =
            CurrentTheme.Element

        Frame.BackgroundTransparency =
            Transparency.Element
            or 0

        Stroke.Color =
            CurrentTheme.Border

        Stroke.Thickness =
            StrokeSettings.Thickness
            or 1

        Stroke.Transparency =
            StrokeSettings.Transparency
            or 0

        Stroke.Enabled =
            StrokeSettings.Enabled ~= false

        FrameCorner.CornerRadius =
            UDim.new(
                0,
                Corners.Element
                or 8
            )

        Title.TextColor3 =
            CurrentTheme.Text

        ValueLabel.TextColor3 =
            CurrentTheme.Accent

        if DescriptionLabel then

            DescriptionLabel.TextColor3 =
                CurrentTheme.SubText

        end

        SliderBackground.BackgroundColor3 =
            CurrentTheme.SliderBackground
            or CurrentTheme.Background

        SliderBackground.BackgroundTransparency =
            Transparency.Element
            or 0

        SliderBackgroundStroke.Color =
            CurrentTheme.Border

        SliderBackgroundStroke.Thickness =
            StrokeSettings.Thickness
            or 1

        SliderBackgroundStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        SliderBackgroundStroke.Enabled =
            StrokeSettings.Enabled ~= false

        Fill.BackgroundColor3 =
            CurrentTheme.SliderFill
            or CurrentTheme.Accent

        Knob.BackgroundColor3 =
            CurrentTheme.SliderKnob
            or CurrentTheme.Text

        KnobStroke.Color =
            CurrentTheme.Accent

        KnobStroke.Thickness =
            math.max(
                StrokeSettings.Thickness
                or 1,
                1
            )

        KnobStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        KnobStroke.Enabled =
            StrokeSettings.Enabled ~= false

        if Effects.Gradient
            and Gradients.Accent then

            applyGradient(
                Fill,
                Gradients.Accent
            )

        else

            local Existing =
                Fill:FindFirstChild(
                    "OTCGradient"
                )

            if Existing then
                Existing:Destroy()
            end
        end

        if Effects.Gradient
            and Gradients.Element then

            applyGradient(
                Frame,
                Gradients.Element
            )

        else

            local Existing =
                Frame:FindFirstChild(
                    "OTCGradient"
                )

            if Existing then
                Existing:Destroy()
            end
        end

        update(
            CurrentValue,
            false
        )
    end

    function Object:Destroy()

        if Frame
            and Frame.Parent then

            Frame:Destroy()

        end
    end

    Object.Flag = Flag


    Tab:AddElement(
        Object
    )

    return Object
end

return Slider