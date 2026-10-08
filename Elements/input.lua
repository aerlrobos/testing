local Input = {}

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

function Input.Create(Tab, OTC, Settings)

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
        or "Input"

    local Description =
        Settings.Description

    local Placeholder =
        Settings.Placeholder
        or "Enter text..."

    local CurrentValue =
        tostring(
            Settings.CurrentValue
            or ""
        )

    local Flag =
        Settings.Flag

    local ClearTextOnFocus =
        Settings.ClearTextOnFocus == true

    local Numeric =
        Settings.Numeric == true

    local MaxLength =
        tonumber(
            Settings.MaxLength
        )

    local Callback =
        Settings.Callback
        or function()
        end

    local FrameHeight =
        Description
        and 82
        or 68

    local Frame =
        create("Frame", {
            Name = "Input",

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
                    and Theme.Corners.Input
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

    --------------------------------------------------
    -- TEXT GROUP CENTER
    --------------------------------------------------

    local TitleHeight = 20
    local DescriptionHeight = 18
    local TextGap = 3

    local TextGroupHeight

    if Description then

        TextGroupHeight =
            TitleHeight
            + TextGap
            + DescriptionHeight

    else

        TextGroupHeight =
            TitleHeight

    end

    local TextGroupTop =
        (FrameHeight - TextGroupHeight) / 2

    --------------------------------------------------
    -- TITLE
    --------------------------------------------------

    local Title =
        create("TextLabel", {
            Name = "Title",

            Parent = Frame,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(
                    15,
                    TextGroupTop
                ),

            Size =
                UDim2.new(
                    1,
                    -185,
                    0,
                    TitleHeight
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
                Enum.TextYAlignment.Center
        })

    --------------------------------------------------
    -- DESCRIPTION
    --------------------------------------------------

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
                        TextGroupTop
                            + TitleHeight
                            + TextGap
                    ),

                Size =
                    UDim2.new(
                        1,
                        -185,
                        0,
                        DescriptionHeight
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    Description,

                TextColor3 =
                    Theme.SubText,

                TextSize = 10,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center
            })
    end

    --------------------------------------------------
    -- INPUT
    --------------------------------------------------

    local InputFrame =
        create("Frame", {
            Name = "InputFrame",

            Parent = Frame,

            BackgroundColor3 =
                Theme.Input
                or Theme.Background,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            Position =
                UDim2.new(
                    1,
                    -165,
                    0.5,
                    -16
                ),

            Size =
                UDim2.new(
                    0,
                    150,
                    0,
                    32
                )
        })

    local InputCorner =
        create("UICorner", {
            Parent = InputFrame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Input
                    or 6
                )
        })

    local InputStroke =
        create("UIStroke", {
            Parent = InputFrame,

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
        InputStroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local TextBox =
        create("TextBox", {
            Name = "TextBox",

            Parent = InputFrame,

            BackgroundTransparency = 1,

            ClearTextOnFocus =
                ClearTextOnFocus,

            Position =
                UDim2.fromOffset(
                    10,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -20,
                    1,
                    0
                ),

            Font =
                Enum.Font.Gotham,

            PlaceholderText =
                Placeholder,

            PlaceholderColor3 =
                Theme.SubText,

            Text =
                CurrentValue,

            TextColor3 =
                Theme.Text,

            TextSize = 9,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center
        })

    --------------------------------------------------
    -- SANITIZE
    --------------------------------------------------

    local function sanitize(Text)

        if Numeric then

            Text =
                Text:gsub(
                    "[^%d%.%-]",
                    ""
                )

        end

        if MaxLength then

            Text =
                string.sub(
                    Text,
                    1,
                    MaxLength
                )

        end

        return Text
    end

    --------------------------------------------------
    -- INPUT STROKE
    --------------------------------------------------

    local function updateInputStroke(Animated)

        local CurrentTheme =
            getTheme()

        local Color

        if TextBox:IsFocused() then

            Color =
                CurrentTheme.InputFocus
                or CurrentTheme.Accent

        else

            Color =
                CurrentTheme.Border

        end

        if Animated then

            tween(
                InputStroke,
                0.15,
                {
                    Color = Color
                }
            )

        else

            InputStroke.Color =
                Color

        end
    end

    --------------------------------------------------
    -- FOCUS
    --------------------------------------------------

    TextBox.Focused:Connect(
        function()

            local CurrentTheme =
                getTheme()

            tween(
                InputStroke,
                0.15,
                {
                    Color =
                        CurrentTheme.InputFocus
                        or CurrentTheme.Accent
                }
            )

            local Effects =
                CurrentTheme.Effects
                or {}

            local Gradients =
                CurrentTheme.Gradients
                or {}

            if Effects.Gradient
                and Gradients.Accent then

                applyGradient(
                    InputFrame,
                    Gradients.Accent
                )

            end

        end
    )

    --------------------------------------------------
    -- FOCUS LOST
    --------------------------------------------------

    TextBox.FocusLost:Connect(
        function()

            local Text =
                sanitize(
                    TextBox.Text
                )

            TextBox.Text =
                Text

            CurrentValue =
                Text

            updateInputStroke(true)

            local CurrentTheme =
                getTheme()

            local Effects =
                CurrentTheme.Effects
                or {}

            local Gradients =
                CurrentTheme.Gradients
                or {}

            if Effects.Gradient
                and Gradients.Element then

                applyGradient(
                    InputFrame,
                    Gradients.Element
                )

            else

                local Existing =
                    InputFrame:FindFirstChild(
                        "OTCGradient"
                    )

                if Existing then
                    Existing:Destroy()
                end

            end

            if Flag then

                OTC:SetFlag(
                    Flag,
                    CurrentValue
                )

            end

            local Success, Error =
                pcall(
                    Callback,
                    CurrentValue
                )

            if not Success then

                warn(
                    "[OTC Hub] Input callback error:",
                    Error
                )

            end

        end
    )

    --------------------------------------------------
    -- TEXT CHANGED
    --------------------------------------------------

    TextBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()

            local Text =
                sanitize(
                    TextBox.Text
                )

            if Text ~= TextBox.Text then

                TextBox.Text =
                    Text

            end

        end
    )

    --------------------------------------------------
    -- HOVER
    --------------------------------------------------

    InputFrame.MouseEnter:Connect(
        function()

            if not TextBox:IsFocused() then

                local CurrentTheme =
                    getTheme()

                tween(
                    InputStroke,
                    0.15,
                    {
                        Color =
                            CurrentTheme.InputHover
                            or CurrentTheme.AccentDark
                            or CurrentTheme.Border
                    }
                )

            end

        end
    )

    InputFrame.MouseLeave:Connect(
        function()

            if not TextBox:IsFocused() then

                local CurrentTheme =
                    getTheme()

                tween(
                    InputStroke,
                    0.15,
                    {
                        Color =
                            CurrentTheme.Border
                    }
                )

            end

        end
    )

    --------------------------------------------------
    -- FLAG
    --------------------------------------------------

    if Flag then

        OTC:SetFlag(
            Flag,
            CurrentValue
        )

    end

    --------------------------------------------------
    -- OBJECT
    --------------------------------------------------

    local Object = {}

    Object.Type =
        "Input"

    Object.Instance =
        Frame

    Object.InputFrame =
        InputFrame

    Object.TextBox =
        TextBox

    Object.Title =
        Title

    Object.Description =
        DescriptionLabel

    Object.Stroke =
        Stroke

    Object.InputStroke =
        InputStroke

    --------------------------------------------------
    -- SET VALUE
    --------------------------------------------------

    function Object:SetValue(Value)

        CurrentValue =
            tostring(
                Value or ""
            )

        TextBox.Text =
            CurrentValue

        if Flag then

            OTC:SetFlag(
                Flag,
                CurrentValue
            )

        end

    end

    --------------------------------------------------
    -- GET VALUE
    --------------------------------------------------

    function Object:GetValue()

        return CurrentValue

    end

    --------------------------------------------------
    -- PLACEHOLDER
    --------------------------------------------------

    function Object:SetPlaceholder(Value)

        Placeholder =
            tostring(
                Value or ""
            )

        TextBox.PlaceholderText =
            Placeholder

    end

    --------------------------------------------------
    -- NAME
    --------------------------------------------------

    function Object:SetName(NewName)

        Name =
            tostring(
                NewName
            )

        Title.Text =
            Name

    end

    --------------------------------------------------
    -- CALLBACK
    --------------------------------------------------

    function Object:SetCallback(NewCallback)

        if type(NewCallback)
            == "function" then

            Callback =
                NewCallback

        end

    end

    --------------------------------------------------
    -- FOCUS
    --------------------------------------------------

    function Object:Focus()

        TextBox:CaptureFocus()

    end

    --------------------------------------------------
    -- CLEAR
    --------------------------------------------------

    function Object:Clear()

        CurrentValue =
            ""

        TextBox.Text =
            ""

        if Flag then

            OTC:SetFlag(
                Flag,
                ""
            )

        end

    end

    --------------------------------------------------
    -- REFRESH THEME
    --------------------------------------------------

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
                Corners.Input
                or 8
            )

        Title.TextColor3 =
            CurrentTheme.Text

        if DescriptionLabel then

            DescriptionLabel.TextColor3 =
                CurrentTheme.SubText

        end

        InputFrame.BackgroundColor3 =
            CurrentTheme.Input
            or CurrentTheme.Background

        InputFrame.BackgroundTransparency =
            Transparency.Element
            or 0

        InputCorner.CornerRadius =
            UDim.new(
                0,
                Corners.Input
                or 6
            )

        InputStroke.Color =
            CurrentTheme.Border

        InputStroke.Thickness =
            StrokeSettings.Thickness
            or 1

        InputStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        InputStroke.Enabled =
            StrokeSettings.Enabled ~= false

        TextBox.TextColor3 =
            CurrentTheme.Text

        TextBox.PlaceholderColor3 =
            CurrentTheme.SubText

        updateInputStroke(false)

        if Effects.Gradient
            and Gradients.Element then

            applyGradient(
                InputFrame,
                Gradients.Element
            )

        else

            local Existing =
                InputFrame:FindFirstChild(
                    "OTCGradient"
                )

            if Existing then
                Existing:Destroy()
            end

        end

    end

    --------------------------------------------------
    -- DESTROY
    --------------------------------------------------

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

return Input