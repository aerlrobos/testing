--[[
    OTC Hub v1
    Button Element
    by Aerlro
]]

local Button = {}

local TweenService = game:GetService("TweenService")

local function create(Class, Properties)
    local Object = Instance.new(Class)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    return Object
end

local function tween(Object, Time, Properties)
    if not Object
        or not Object.Parent then
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

local function getGradient(Object)
    if not Object then
        return nil
    end

    return Object:FindFirstChild("OTCGradient")
end

local function applyGradient(Object, GradientData)
    if not Object then
        return
    end

    local Existing = getGradient(Object)

    if Existing then
        Existing:Destroy()
    end

    if not GradientData
        or GradientData.Enabled ~= true then
        return
    end

    if not GradientData.Colors then
        return
    end

    local Gradient = Instance.new("UIGradient")

    Gradient.Name = "OTCGradient"
    Gradient.Color = GradientData.Colors
    Gradient.Rotation = GradientData.Rotation or 0

    Gradient.Parent = Object

    return Gradient
end

function Button.Create(
    Tab,
    OTC,
    Settings
)

    Settings = Settings or {}

    local Name =
        Settings.Name
        or "Button"

    local Description =
        Settings.Description

    local Callback =
        Settings.Callback
        or function()
        end

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Tab.Window.Theme]
            or OTC._Themes.Default
    end

    local Theme =
        getTheme()

    local Hovered = false
    local Pressed = false

    local FrameHeight =
        Description
        and 62
        or 48

    local Frame = create(
        "Frame",
        {
            Name = "Button",

            Parent = Tab.Page,

            BackgroundColor3 =
                Theme.Button
                or Theme.Element,

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
        }
    )

    create(
        "UICorner",
        {
            Parent = Frame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Button
                    or 8
                )
        }
    )

    local Stroke = create(
        "UIStroke",
        {
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
        }
    )

    if Theme.Stroke then
        Stroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local Scale = create(
        "UIScale",
        {
            Parent = Frame,

            Scale = 1
        }
    )

    local ButtonObject = create(
        "TextButton",
        {
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
        }
    )

    local Title

    if Description then

        Title = create(
            "TextLabel",
            {
                Name = "Title",

                Parent = ButtonObject,

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

                Text = Name,

                TextColor3 =
                    Theme.Text,

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            }
        )

    else

        Title = create(
            "TextLabel",
            {
                Name = "Title",

                Parent = ButtonObject,

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

                Text = Name,

                TextColor3 =
                    Theme.Text,

                TextSize = 13,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center,

                TextTruncate =
                    Enum.TextTruncate.AtEnd
            }
        )
    end

    local DescriptionLabel

    if Description then

        DescriptionLabel = create(
            "TextLabel",
            {
                Name = "Description",

                Parent = ButtonObject,

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

                Text = Description,

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
            }
        )
    end

    local Execute = create(
        "TextLabel",
        {
            Name = "Execute",

            Parent = ButtonObject,

            BackgroundTransparency = 1,

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
                    55,
                    25
                ),

            Font =
                Enum.Font.GothamMedium,

            Text = "EXECUTE",

            TextColor3 =
                Theme.Accent,

            TextSize = 10,

            TextXAlignment =
                Enum.TextXAlignment.Right,

            TextYAlignment =
                Enum.TextYAlignment.Center
        }
    )

    local function getBackgroundColor(CurrentTheme)

        if Pressed then
            return CurrentTheme.ButtonPressed
                or CurrentTheme.Pressed
                or CurrentTheme.Hover
                or CurrentTheme.Element

        elseif Hovered then
            return CurrentTheme.ButtonHover
                or CurrentTheme.Hover
                or CurrentTheme.Element

        else
            return CurrentTheme.Button
                or CurrentTheme.Element
        end
    end

    local function getStrokeColor(CurrentTheme)

        if Pressed then
            return CurrentTheme.Accent
                or CurrentTheme.Border

        elseif Hovered then
            return CurrentTheme.BorderHover
                or CurrentTheme.AccentDark
                or CurrentTheme.Border

        else
            return CurrentTheme.Border
        end
    end

    local function getExecuteColor(CurrentTheme)

        if Pressed or Hovered then
            return CurrentTheme.AccentHover
                or CurrentTheme.Text
                or CurrentTheme.Accent
        end

        return CurrentTheme.Accent
    end

    local function applyState(Animated)

        local CurrentTheme =
            getTheme()

        local BackgroundColor =
            getBackgroundColor(
                CurrentTheme
            )

        local StrokeColor =
            getStrokeColor(
                CurrentTheme
            )

        local ExecuteColor =
            getExecuteColor(
                CurrentTheme
            )

        if Animated then

            tween(
                Frame,
                0.15,
                {
                    BackgroundColor3 =
                        BackgroundColor
                }
            )

            tween(
                Stroke,
                0.15,
                {
                    Color =
                        StrokeColor
                }
            )

            tween(
                Execute,
                0.15,
                {
                    TextColor3 =
                        ExecuteColor
                }
            )

        else

            Frame.BackgroundColor3 =
                BackgroundColor

            Stroke.Color =
                StrokeColor

            Execute.TextColor3 =
                ExecuteColor
        end

        local GradientData

        if Pressed then
            GradientData =
                CurrentTheme.Gradients
                and CurrentTheme.Gradients.Accent

        elseif Hovered then
            GradientData =
                CurrentTheme.Gradients
                and CurrentTheme.Gradients.Element

        else
            GradientData =
                CurrentTheme.Gradients
                and CurrentTheme.Gradients.Element
        end

        local Effects =
            CurrentTheme.Effects
            or {}

        if Effects.Gradient
            and GradientData then

            local Existing =
                getGradient(Frame)

            if Existing then
                Existing.Color =
                    GradientData.Colors

                Existing.Rotation =
                    GradientData.Rotation or 0
            else
                applyGradient(
                    Frame,
                    GradientData
                )
            end

        else

            local Existing =
                getGradient(Frame)

            if Existing then
                Existing:Destroy()
            end
        end
    end

    ButtonObject.MouseEnter:Connect(
        function()

            Hovered = true

            applyState(true)

        end
    )

    ButtonObject.MouseLeave:Connect(
        function()

            Hovered = false
            Pressed = false

            applyState(true)

        end
    )

    ButtonObject.MouseButton1Down:Connect(
        function()

            Pressed = true

            tween(
                Scale,
                0.08,
                {
                    Scale = 0.985
                }
            )

            applyState(true)

        end
    )

    ButtonObject.MouseButton1Up:Connect(
        function()

            Pressed = false

            tween(
                Scale,
                0.12,
                {
                    Scale = 1
                }
            )

            applyState(true)

        end
    )

    ButtonObject.MouseButton1Click:Connect(
        function()

            tween(
                Scale,
                0.06,
                {
                    Scale = 0.975
                }
            )

            task.delay(
                0.06,
                function()

                    if Scale
                        and Scale.Parent then

                        tween(
                            Scale,
                            0.1,
                            {
                                Scale = 1
                            }
                        )

                    end
                end
            )

            local Success, Error =
                pcall(
                    Callback
                )

            if not Success then

                warn(
                    "[OTC Hub] Button callback error:",
                    Error
                )

            end
        end
    )

    local Object = {}

    Object.Type =
        "Button"

    Object.Instance =
        Frame

    Object.Button =
        ButtonObject

    Object.Title =
        Title

    Object.Description =
        DescriptionLabel

    Object.Execute =
        Execute

    Object.Stroke =
        Stroke

    Object.Scale =
        Scale

    function Object:SetName(NewName)

        Name =
            tostring(
                NewName
            )

        if Title
            and Title.Parent then

            Title.Text =
                Name
        end
    end

    function Object:SetDescription(
        NewDescription
    )

        Description =
            NewDescription

        if DescriptionLabel
            and DescriptionLabel.Parent then

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

        local Effects =
            CurrentTheme.Effects
            or {}

        if Title
            and Title.Parent then

            Title.TextColor3 =
                CurrentTheme.Text
        end

        if DescriptionLabel
            and DescriptionLabel.Parent then

            DescriptionLabel.TextColor3 =
                CurrentTheme.SubText
        end

        if Execute
            and Execute.Parent then

            Execute.TextColor3 =
                getExecuteColor(
                    CurrentTheme
                )
        end

        Frame.BackgroundTransparency =
            Transparency.Element
            or 0

        Stroke.Thickness =
            StrokeSettings.Thickness
            or 1

        Stroke.Transparency =
            StrokeSettings.Transparency
            or 0

        Stroke.Enabled =
            StrokeSettings.Enabled ~= false

        local Corner =
            Frame:FindFirstChildOfClass(
                "UICorner"
            )

        if Corner then

            Corner.CornerRadius =
                UDim.new(
                    0,
                    Corners.Button
                    or 8
                )
        end

        if Effects.Gradient then

            local GradientData =
                CurrentTheme.Gradients
                and CurrentTheme.Gradients.Element

            if GradientData then
                applyGradient(
                    Frame,
                    GradientData
                )
            end

        else

            local Existing =
                getGradient(Frame)

            if Existing then
                Existing:Destroy()
            end
        end

        applyState(false)
    end

    function Object:Destroy()

        if Frame
            and Frame.Parent then

            Frame:Destroy()

        end
    end

    Tab:AddElement(
        Object
    )

    return Object
end

return Button