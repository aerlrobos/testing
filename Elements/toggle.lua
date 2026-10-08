--[[
    OTC Hub v1
    Toggle Element
    by Aerlro
]]

local Toggle = {}

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

function Toggle.Create(Tab, OTC, Settings)

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
        or "Toggle"

    local Description =
        Settings.Description

    local Flag =
        Settings.Flag

    local CurrentValue =
        Settings.CurrentValue == true

    local Callback =
        Settings.Callback
        or function()
        end

    local FrameHeight =
        Description
        and 62
        or 48

    local Frame =
        create("Frame", {
            Name = "Toggle",

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

    local Button =
        create("TextButton", {
            Name = "Button",

            Parent = Frame,

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Size =
                UDim2.fromScale(
                    1,
                    1
                ),

            AutoButtonColor = false,

            Text = ""
        })

    local Title

    if Description then

        Title =
            create("TextLabel", {
                Name = "Title",

                Parent = Button,

                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        15,
                        7
                    ),

                Size =
                    UDim2.new(
                        1,
                        -90,
                        0,
                        24
                    ),

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    Name,

                TextColor3 =
                    Theme.Text,

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            })

    else

        Title =
            create("TextLabel", {
                Name = "Title",

                Parent = Button,

                BackgroundTransparency = 1,

                AnchorPoint =
                    Vector2.new(
                        0,
                        0.5
                    ),

                Position =
                    UDim2.new(
                        0,
                        15,
                        0.5,
                        0
                    ),

                Size =
                    UDim2.new(
                        1,
                        -90,
                        0,
                        24
                    ),

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    Name,

                TextColor3 =
                    Theme.Text,

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            })

    end

    local DescriptionLabel

    if Description then

        DescriptionLabel =
            create("TextLabel", {
                Name = "Description",

                Parent = Button,

                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        15,
                        31
                    ),

                Size =
                    UDim2.new(
                        1,
                        -90,
                        0,
                        20
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    Description,

                TextColor3 =
                    Theme.SubText,

                TextSize = 11,

                TextWrapped = true,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            })

    end

    local ToggleBackground =
        create("Frame", {
            Name =
                "ToggleBackground",

            Parent =
                Button,

            BackgroundColor3 =
                Theme.ToggleOff
                or Theme.Background,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            AnchorPoint =
                Vector2.new(
                    1,
                    0.5
                ),

            Position =
                UDim2.new(
                    1,
                    -15,
                    0.5,
                    0
                ),

            Size =
                UDim2.fromOffset(
                    42,
                    22
                )
        })

    local ToggleCorner =
        create("UICorner", {
            Parent =
                ToggleBackground,

            CornerRadius =
                UDim.new(
                    1,
                    0
                )
        })

    local ToggleStroke =
        create("UIStroke", {
            Parent =
                ToggleBackground,

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
        ToggleStroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local Circle =
        create("Frame", {
            Name = "Circle",

            Parent =
                ToggleBackground,

            BackgroundColor3 =
                Theme.ToggleCircle
                or Theme.SubText,

            BorderSizePixel = 0,

            Position =
                UDim2.fromOffset(
                    3,
                    3
                ),

            Size =
                UDim2.fromOffset(
                    16,
                    16
                )
        })

    local CircleCorner =
        create("UICorner", {
            Parent = Circle,

            CornerRadius =
                UDim.new(
                    1,
                    0
                )
        })

    local function updateVisual(Animated)

        local CurrentTheme =
            getTheme()

        local OnColor =
            CurrentTheme.ToggleOn
            or CurrentTheme.Accent

        local OffColor =
            CurrentTheme.ToggleOff
            or CurrentTheme.Background

        local CircleColor =
            CurrentTheme.ToggleCircle
            or CurrentTheme.Text

        local OnStroke =
            CurrentTheme.Accent

        local OffStroke =
            CurrentTheme.Border

        if CurrentValue then

            local PropertiesBackground = {
                BackgroundColor3 =
                    OnColor
            }

            local PropertiesStroke = {
                Color =
                    OnStroke
            }

            local PropertiesCircle = {
                Position =
                    UDim2.new(
                        1,
                        -19,
                        0,
                        3
                    ),

                BackgroundColor3 =
                    CircleColor
            }

            if Animated then

                tween(
                    ToggleBackground,
                    0.2,
                    PropertiesBackground
                )

                tween(
                    ToggleStroke,
                    0.2,
                    PropertiesStroke
                )

                tween(
                    Circle,
                    0.2,
                    PropertiesCircle
                )

            else

                ToggleBackground.BackgroundColor3 =
                    OnColor

                ToggleStroke.Color =
                    OnStroke

                Circle.Position =
                    PropertiesCircle.Position

                Circle.BackgroundColor3 =
                    CircleColor

            end

        else

            local PropertiesBackground = {
                BackgroundColor3 =
                    OffColor
            }

            local PropertiesStroke = {
                Color =
                    OffStroke
            }

            local PropertiesCircle = {
                Position =
                    UDim2.fromOffset(
                        3,
                        3
                    ),

                BackgroundColor3 =
                    CircleColor
            }

            if Animated then

                tween(
                    ToggleBackground,
                    0.2,
                    PropertiesBackground
                )

                tween(
                    ToggleStroke,
                    0.2,
                    PropertiesStroke
                )

                tween(
                    Circle,
                    0.2,
                    PropertiesCircle
                )

            else

                ToggleBackground.BackgroundColor3 =
                    OffColor

                ToggleStroke.Color =
                    OffStroke

                Circle.Position =
                    PropertiesCircle.Position

                Circle.BackgroundColor3 =
                    CircleColor

            end
        end

        local Effects =
            CurrentTheme.Effects
            or {}

        local Gradients =
            CurrentTheme.Gradients
            or {}

        if Effects.Gradient then

            local GradientData

            if CurrentValue then
                GradientData =
                    Gradients.Accent
                    or Gradients.Element
            else
                GradientData =
                    Gradients.Element
            end

            if GradientData then

                applyGradient(
                    ToggleBackground,
                    GradientData
                )

            end

        else

            local Existing =
                ToggleBackground:FindFirstChild(
                    "OTCGradient"
                )

            if Existing then
                Existing:Destroy()
            end
        end
    end

    local function setValue(
        Value,
        RunCallback
    )

        CurrentValue =
            Value == true

        updateVisual(true)

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
                    "[OTC Hub] Toggle callback error:",
                    Error
                )

            end
        end
    end

    Button.MouseEnter:Connect(
        function()

            local CurrentTheme =
                getTheme()

            tween(
                Frame,
                0.15,
                {
                    BackgroundColor3 =
                        CurrentTheme.Element
                        and (
                            CurrentTheme.Hover
                            or CurrentTheme.Element
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

    Button.MouseLeave:Connect(
        function()

            local CurrentTheme =
                getTheme()

            tween(
                Frame,
                0.15,
                {
                    BackgroundColor3 =
                        CurrentTheme.Element
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
    )

    Button.MouseButton1Click:Connect(
        function()

            setValue(
                not CurrentValue,
                true
            )

        end
    )

    setValue(
        CurrentValue,
        false
    )

    local Object = {}

    Object.Type =
        "Toggle"

    Object.Instance =
        Frame

    Object.Button =
        Button

    Object.ToggleBackground =
        ToggleBackground

    Object.ToggleStroke =
        ToggleStroke

    Object.Circle =
        Circle

    Object.Stroke =
        Stroke

    function Object:SetValue(Value)

        setValue(
            Value,
            true
        )

    end

    function Object:GetValue()

        return CurrentValue

    end

    function Object:SetName(NewName)

        Name =
            tostring(
                NewName
            )

        Title.Text =
            Name

    end

    function Object:SetDescription(
        NewDescription
    )

        Description =
            NewDescription

        if DescriptionLabel then

            DescriptionLabel.Text =
                tostring(
                    NewDescription
                )

        end
    end

    function Object:SetCallback(
        NewCallback
    )

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

        if DescriptionLabel then

            DescriptionLabel.TextColor3 =
                CurrentTheme.SubText
        end

        ToggleBackground.BackgroundTransparency =
            Transparency.Element
            or 0

        ToggleCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        ToggleStroke.Thickness =
            StrokeSettings.Thickness
            or 1

        ToggleStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        ToggleStroke.Enabled =
            StrokeSettings.Enabled ~= false

        CircleCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        updateVisual(false)
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

return Toggle