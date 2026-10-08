--[[
    OTC Hub v1
    Dropdown Element
    by Aerlro
]]

local Dropdown = {}

local RunService = game:GetService("RunService")

local function Create(ClassName, Properties)
    local Object = Instance.new(ClassName)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    return Object
end

local function NormalizeOptions(Options)
    local Result = {}

    if type(Options) ~= "table" then
        return Result
    end

    for _, Value in ipairs(Options) do
        local StringValue = tostring(Value)

        if not table.find(Result, StringValue) then
            table.insert(Result, StringValue)
        end
    end

    return Result
end

local function ApplyGradient(Object, GradientData)
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

function Dropdown.Create(TabObject, OTC, Settings)

    Settings = Settings or {}

    local function GetTheme()

        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[TabObject.Window.Theme]
            or OTC._Themes.Default

    end

    local Theme =
        GetTheme()

    local Name =
        Settings.Name
        or "Dropdown"

    local Options =
        NormalizeOptions(
            Settings.Options or {}
        )

    local MultiSelect =
        Settings.MultiSelect == true

    local Callback =
        Settings.Callback
        or function()
        end

    local DROPDOWN_WIDTH =
        Settings.Width or 260

    local OPTION_HEIGHT = 32
    local OPTION_PADDING = 4

    local SEARCH_HEIGHT = 36
    local SEARCH_TOP = 7

    local OPTIONS_TOP =
        SEARCH_TOP
        + SEARCH_HEIGHT
        + 7

    local OPTIONS_BOTTOM = 7

    local MIN_HEIGHT = 86
    local MAX_HEIGHT = 270

    local OPEN_OFFSET = 5

    local Frame =
        Create("Frame", {
            Name = "Dropdown",

            Parent =
                TabObject.Page,

            Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    48
                ),

            BackgroundColor3 =
                Theme.Dropdown
                or Theme.Element,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            ClipsDescendants = false,

            ZIndex = 10
        })

    local FrameCorner =
        Create("UICorner", {
            Parent = Frame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Dropdown
                    or 7
                )
        })

    local Stroke =
        Create("UIStroke", {
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

    local NameLabel =
        Create("TextLabel", {
            Name = "Name",

            Parent = Frame,

            BackgroundTransparency = 1,

            AnchorPoint =
                Vector2.new(
                    0,
                    0.5
                ),

            Position =
                UDim2.new(
                    0,
                    14,
                    0.5,
                    0
                ),

            Size =
                UDim2.new(
                    0.48,
                    -14,
                    0,
                    24
                ),

            Font =
                Enum.Font.GothamMedium,

            Text =
                Name,

            TextColor3 =
                Theme.Text,

            TextSize = 14,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            TextTruncate =
                Enum.TextTruncate.AtEnd,

            ZIndex = 11
        })

    local ValueLabel =
        Create("TextLabel", {
            Name = "Value",

            Parent = Frame,

            BackgroundTransparency = 1,

            AnchorPoint =
                Vector2.new(
                    0,
                    0.5
                ),

            Position =
                UDim2.new(
                    0.48,
                    0,
                    0.5,
                    0
                ),

            Size =
                UDim2.new(
                    0.52,
                    -42,
                    0,
                    24
                ),

            Font =
                Enum.Font.Gotham,

            Text = "",

            TextColor3 =
                Theme.SubText,

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Right,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            TextTruncate =
                Enum.TextTruncate.AtEnd,

            ZIndex = 11
        })

    local Arrow =
        Create("TextLabel", {
            Name = "Arrow",

            Parent = Frame,

            BackgroundTransparency = 1,

            AnchorPoint =
                Vector2.new(
                    1,
                    0.5
                ),

            Position =
                UDim2.new(
                    1,
                    -12,
                    0.5,
                    0
                ),

            Size =
                UDim2.fromOffset(
                    18,
                    18
                ),

            Font =
                Enum.Font.GothamBold,

            Text = "⌄",

            TextColor3 =
                Theme.SubText,

            TextSize = 16,

            TextXAlignment =
                Enum.TextXAlignment.Center,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            ZIndex = 11
        })

    local Button =
        Create("TextButton", {
            Name = "Button",

            Parent = Frame,

            BackgroundTransparency = 1,

            Size =
                UDim2.fromScale(
                    1,
                    1
                ),

            Text = "",

            AutoButtonColor = false,

            ZIndex = 12
        })

    local ScreenGui

    if TabObject.Window
        and TabObject.Window.ScreenGui then

        ScreenGui =
            TabObject.Window.ScreenGui

    elseif OTC.Window
        and OTC.Window.ScreenGui then

        ScreenGui =
            OTC.Window.ScreenGui

    end

    if not ScreenGui then

        error(
            "[OTC Hub] Dropdown could not find ScreenGui"
        )

    end

    local Overlay =
        ScreenGui:FindFirstChild(
            "OTC_DropdownOverlay"
        )

    if not Overlay then

        Overlay =
            Create("Frame", {
                Name =
                    "OTC_DropdownOverlay",

                Parent =
                    ScreenGui,

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Position =
                    UDim2.fromScale(
                        0,
                        0
                    ),

                Size =
                    UDim2.fromScale(
                        1,
                        1
                    ),

                ClipsDescendants = false,

                Visible = true,

                Active = false,

                ZIndex = 1000
            })

    end

    local OutsideButton =
        Overlay:FindFirstChild(
            "OutsideButton"
        )

    if not OutsideButton then

        OutsideButton =
            Create(
                "TextButton",
                {
                    Name =
                        "OutsideButton",

                    Parent =
                        Overlay,

                    BackgroundTransparency = 1,

                    BorderSizePixel = 0,

                    Position =
                        UDim2.fromScale(
                            0,
                            0
                        ),

                    Size =
                        UDim2.fromScale(
                            1,
                            1
                        ),

                    Text = "",

                    AutoButtonColor = false,

                    Visible = false,

                    Active = false,

                    ZIndex = 1000
                }
            )

    end

    local DropdownFrame =
        Create("Frame", {
            Name =
                "DropdownFrame",

            Parent =
                Overlay,

            BackgroundColor3 =
                Theme.PopupBackground
                or Theme.Secondary,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Popup
                or 0,

            BorderSizePixel = 0,

            Size =
                UDim2.fromOffset(
                    DROPDOWN_WIDTH,
                    MIN_HEIGHT
                ),

            Position =
                UDim2.fromOffset(
                    0,
                    0
                ),

            Visible = false,

            ClipsDescendants = false,

            ZIndex = 1001
        })

    local DropdownStroke =
        Create("UIStroke", {
            Parent =
                DropdownFrame,

            Color =
                Theme.PopupBorder
                or Theme.Border,

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
        DropdownStroke.Enabled =
            Theme.Stroke.Enabled ~= false
    end

    local DropdownCorner =
        Create("UICorner", {
            Parent =
                DropdownFrame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Popup
                    or 10
                )
        })

    local SearchFrame =
        Create("Frame", {
            Name =
                "SearchFrame",

            Parent =
                DropdownFrame,

            BackgroundColor3 =
                Theme.Input
                or Theme.Element,

            BackgroundTransparency =
                Theme.Transparency
                and Theme.Transparency.Element
                or 0,

            BorderSizePixel = 0,

            Position =
                UDim2.fromOffset(
                    7,
                    SEARCH_TOP
                ),

            Size =
                UDim2.new(
                    1,
                    -14,
                    0,
                    SEARCH_HEIGHT
                ),

            ZIndex = 1002
        })

    local SearchStroke =
        Create("UIStroke", {
            Parent =
                SearchFrame,

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

    local SearchCorner =
        Create("UICorner", {
            Parent =
                SearchFrame,

            CornerRadius =
                UDim.new(
                    0,
                    Theme.Corners
                    and Theme.Corners.Input
                    or 7
                )
        })

    local SearchIcon =
        Create("TextLabel", {
            Name =
                "Icon",

            Parent =
                SearchFrame,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(
                    8,
                    0
                ),

            Size =
                UDim2.fromOffset(
                    22,
                    SEARCH_HEIGHT
                ),

            Font =
                Enum.Font.Gotham,

            Text = "⌕",

            TextColor3 =
                Theme.SubText,

            TextSize = 18,

            TextXAlignment =
                Enum.TextXAlignment.Center,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            ZIndex = 1003
        })

    local SearchLucideIcon

    if OTC._Lucide then

        local LucideIcon =
            OTC._Lucide:GetIcon(
                "search"
            )

        if LucideIcon then

            SearchIcon.Text = ""

            SearchLucideIcon =
                Create(
                    "ImageLabel",
                    {
                        Name =
                            "LucideIcon",

                        Parent =
                            SearchFrame,

                        BackgroundTransparency = 1,

                        Position =
                            UDim2.fromOffset(
                                10,
                                9
                            ),

                        Size =
                            UDim2.fromOffset(
                                18,
                                18
                            ),

                        Image =
                            LucideIcon.Url,

                        ImageColor3 =
                            Theme.SubText,

                        ImageRectSize =
                            LucideIcon.ImageRectSize,

                        ImageRectOffset =
                            LucideIcon.ImageRectOffset,

                        ZIndex = 1003
                    }
                )

        end

    end

    local SearchBox =
        Create("TextBox", {
            Name =
                "SearchBox",

            Parent =
                SearchFrame,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(
                    35,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -42,
                    1,
                    0
                ),

            Font =
                Enum.Font.Gotham,

            PlaceholderText =
                "Search...",

            PlaceholderColor3 =
                Theme.SubText,

            Text = "",

            TextColor3 =
                Theme.Text,

            TextSize = 13,

            ClearTextOnFocus = false,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center,

            ZIndex = 1003
        })

    local OptionsList =
        Create(
            "ScrollingFrame",
            {
                Name =
                    "Options",

                Parent =
                    DropdownFrame,

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Position =
                    UDim2.fromOffset(
                        7,
                        OPTIONS_TOP
                    ),

                Size =
                    UDim2.new(
                        1,
                        -14,
                        1,
                        -(
                            OPTIONS_TOP
                            + OPTIONS_BOTTOM
                        )
                    ),

                CanvasSize =
                    UDim2.fromOffset(
                        0,
                        0
                    ),

                ScrollBarThickness = 4,

                ScrollBarImageColor3 =
                    Theme.Scrollbar
                    or Theme.SubText,

                ScrollingDirection =
                    Enum.ScrollingDirection.Y,

                ScrollingEnabled = true,

                ClipsDescendants = true,

                ZIndex = 1002
            }
        )

    Create("UIListLayout", {
        Parent =
            OptionsList,

        Padding =
            UDim.new(
                0,
                OPTION_PADDING
            ),

        SortOrder =
            Enum.SortOrder.LayoutOrder
    })

    Create("UIPadding", {
        Parent =
            OptionsList,

        PaddingBottom =
            UDim.new(
                0,
                5
            )
    })

    local Selected = {}

    if MultiSelect then

        if type(
            Settings.CurrentOption
        ) == "table" then

            for _, Value in ipairs(
                Settings.CurrentOption
            ) do

                Selected[
                    tostring(Value)
                ] = true

            end

        end

    else

        if Settings.CurrentOption ~= nil then

            local Value =
                tostring(
                    Settings.CurrentOption
                )

            if table.find(
                Options,
                Value
            ) then

                Selected[Value] = true

            end

        elseif #Options > 0 then

            Selected[
                Options[1]
            ] = true

        end

    end

    local OptionObjects = {}

    local Open = false

    local RenderConnection

    local Object = {}

    local function UpdateValueText()

        if MultiSelect then

            local Count = 0

            for _, Option in ipairs(
                Options
            ) do

                if Selected[Option] then
                    Count += 1
                end

            end

            if Count == 0 then

                ValueLabel.Text =
                    "None"

            elseif Count == 1 then

                local SelectedName

                for _, Option in ipairs(
                    Options
                ) do

                    if Selected[Option] then

                        SelectedName =
                            Option

                        break

                    end

                end

                ValueLabel.Text =
                    SelectedName
                    or "1 Selected"

            else

                ValueLabel.Text =
                    tostring(Count)
                    .. " Selected"

            end

            return

        end

        local Current

        for _, Option in ipairs(
            Options
        ) do

            if Selected[Option] then

                Current =
                    Option

                break

            end

        end

        ValueLabel.Text =
            Current
            or "None"

    end

    local function FireCallback()
        if Settings.Flag and type(Object.GetValue) == "function" then
            OTC:SetFlag(Settings.Flag, Object:GetValue())
        end


        if MultiSelect then

            local Values = {}

            for _, Option in ipairs(
                Options
            ) do

                if Selected[Option] then

                    table.insert(
                        Values,
                        Option
                    )

                end

            end

            local Success, Error =
                pcall(
                    Callback,
                    Values
                )

            if not Success then

                warn(
                    "[OTC Hub] Dropdown callback error:",
                    Error
                )

            end

        else

            local Current

            for _, Option in ipairs(
                Options
            ) do

                if Selected[Option] then

                    Current =
                        Option

                    break

                end

            end

            local Success, Error =
                pcall(
                    Callback,
                    Current
                )

            if not Success then

                warn(
                    "[OTC Hub] Dropdown callback error:",
                    Error
                )

            end

        end
    end

    local function GetVisibleCount()

        local Count = 0

        for _, OptionObject in pairs(
            OptionObjects
        ) do

            if OptionObject.Button.Visible then
                Count += 1
            end

        end

        return Count
    end

    local function UpdateCanvas()

        local VisibleCount =
            GetVisibleCount()

        if VisibleCount <= 0 then

            OptionsList.CanvasSize =
                UDim2.fromOffset(
                    0,
                    0
                )

            return

        end

        local ContentHeight =
            VisibleCount
            * OPTION_HEIGHT
            +
            math.max(
                VisibleCount - 1,
                0
            )
            * OPTION_PADDING
            + 5

        OptionsList.CanvasSize =
            UDim2.fromOffset(
                0,
                ContentHeight
            )
    end

    local function UpdateSize()

        local VisibleCount =
            GetVisibleCount()

        local ContentHeight = 0

        if VisibleCount > 0 then

            ContentHeight =
                VisibleCount
                * OPTION_HEIGHT
                +
                math.max(
                    VisibleCount - 1,
                    0
                )
                * OPTION_PADDING
                + 5

        end

        local RequiredHeight =
            OPTIONS_TOP
            + ContentHeight
            + OPTIONS_BOTTOM

        local Height =
            math.clamp(
                RequiredHeight,
                MIN_HEIGHT,
                MAX_HEIGHT
            )

        DropdownFrame.Size =
            UDim2.fromOffset(
                DROPDOWN_WIDTH,
                Height
            )

        task.defer(
            UpdateCanvas
        )
    end

    local function UpdatePosition()

        if not Open then
            return
        end

        local Camera =
            workspace.CurrentCamera

        if not Camera then
            return
        end

        local Viewport =
            Camera.ViewportSize

        local ButtonPosition =
            Button.AbsolutePosition

        local ButtonSize =
            Button.AbsoluteSize

        local DropdownSize =
            DropdownFrame.AbsoluteSize

        local X =
            ButtonPosition.X

        local BelowY =
            ButtonPosition.Y
            + ButtonSize.Y
            + OPEN_OFFSET

        local AboveY =
            ButtonPosition.Y
            - DropdownSize.Y
            - OPEN_OFFSET

        local Y =
            BelowY

        if X + DropdownSize.X
            > Viewport.X - 8 then

            X =
                Viewport.X
                - DropdownSize.X
                - 8

        end

        if X < 8 then
            X = 8
        end

        if BelowY + DropdownSize.Y
            > Viewport.Y - 8 then

            Y =
                AboveY

        end

        if Y < 8 then
            Y = 8
        end

        DropdownFrame.Position =
            UDim2.fromOffset(
                math.floor(X),
                math.floor(Y)
            )
    end

    local function RefreshOption(
        Option
    )

        local Data =
            OptionObjects[Option]

        if not Data then
            return
        end

        local CurrentTheme =
            GetTheme()

        local IsSelected =
            Selected[Option] == true

        Data.Label.TextColor3 =
            CurrentTheme.Text

        Data.Check.TextColor3 =
            CurrentTheme.Accent

        if MultiSelect then

            Data.Check.Visible = true

            if IsSelected then

                Data.Check.Text =
                    "✓"

                Data.Button.BackgroundColor3 =
                    CurrentTheme.DropdownSelected
                    or CurrentTheme.Hover

            else

                Data.Check.Text = ""

                Data.Button.BackgroundColor3 =
                    CurrentTheme.Dropdown
                    or CurrentTheme.Element

            end

        else

            Data.Check.Visible = false

            if IsSelected then

                Data.Button.BackgroundColor3 =
                    CurrentTheme.DropdownSelected
                    or CurrentTheme.Hover

            else

                Data.Button.BackgroundColor3 =
                    CurrentTheme.Dropdown
                    or CurrentTheme.Element

            end

        end

    end

    function Object:Close()

        if not Open then
            return
        end

        Open = false

        if RenderConnection then

            RenderConnection:Disconnect()

            RenderConnection = nil

        end

        if OTC._OpenDropdown ==
            Object then

            OTC._OpenDropdown =
                nil

        end

        DropdownFrame.Visible =
            false

        OutsideButton.Visible =
            false

        OutsideButton.Active =
            false

        Overlay.Active =
            false

        Arrow.Rotation = 0
    end

    function Object:Open()

        if Open then
            return
        end

        if OTC._OpenDropdown
            and OTC._OpenDropdown ~= Object then

            pcall(function()

                OTC._OpenDropdown:Close()

            end)

        end

        OTC._OpenDropdown =
            Object

        Open = true

        Overlay.Active = true

        OutsideButton.Visible =
            true

        OutsideButton.Active =
            true

        DropdownFrame.Visible =
            true

        UpdateSize()

        task.defer(function()

            UpdateCanvas()
            UpdatePosition()

        end)

        if OTC.Tween then

            OTC:Tween(
                DropdownFrame,
                0.12,
                {
                    BackgroundTransparency = 0
                }
            )

            OTC:Tween(
                Arrow,
                0.12,
                {
                    Rotation = 180
                }
            )

        else

            DropdownFrame.BackgroundTransparency =
                0

            Arrow.Rotation =
                180

        end

        if RenderConnection then

            RenderConnection:Disconnect()

        end


        RenderConnection =
            RunService.RenderStepped:Connect(
                function()

                    if not Open then
                        return
                    end

                    if not Button.Parent then

                        Object:Close()

                        return

                    end

                    UpdatePosition()

                end
            )
    end

    OutsideButton.MouseButton1Click:Connect(
        function()

            if Open then
                Object:Close()
            end

        end
    )

    local function CreateOption(
        Option
    )

        local CurrentTheme =
            GetTheme()

        local OptionButton =
            Create(
                "TextButton",
                {
                    Name = "Option",

                    Parent =
                        OptionsList,

                    BackgroundColor3 =
                        CurrentTheme.Dropdown
                        or CurrentTheme.Element,

                    BackgroundTransparency =
                        CurrentTheme.Transparency
                        and CurrentTheme.Transparency.Element
                        or 0,

                    BorderSizePixel = 0,

                    Size =
                        UDim2.new(
                            1,
                            -2,
                            0,
                            OPTION_HEIGHT
                        ),

                    Text = "",

                    AutoButtonColor = false,

                    ZIndex = 1003
                }
            )

        local OptionCorner =
            Create("UICorner", {
                Parent =
                    OptionButton,

                CornerRadius =
                    UDim.new(
                        0,
                        CurrentTheme.Corners
                        and CurrentTheme.Corners.Dropdown
                        or 7
                    )
            })

        local OptionStroke =
            Create("UIStroke", {
                Parent =
                    OptionButton,

                Color =
                    CurrentTheme.Border,

                Thickness =
                    CurrentTheme.Stroke
                    and CurrentTheme.Stroke.Thickness
                    or 1,

                Transparency =
                    CurrentTheme.Stroke
                    and CurrentTheme.Stroke.Transparency
                    or 0
            })

        if CurrentTheme.Stroke then
            OptionStroke.Enabled =
                CurrentTheme.Stroke.Enabled ~= false
        end

        local OptionLabel =
            Create(
                "TextLabel",
                {
                    Name = "Label",

                    Parent =
                        OptionButton,

                    BackgroundTransparency = 1,

                    Position =
                        UDim2.fromOffset(
                            10,
                            0
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -45,
                                                       1,
                            0
                        ),

                    Font =
                        Enum.Font.Gotham,

                    Text =
                        Option,

                    TextColor3 =
                        CurrentTheme.Text,

                    TextSize = 13,

                    TextXAlignment =
                        Enum.TextXAlignment.Left,

                    TextYAlignment =
                        Enum.TextYAlignment.Center,

                    TextTruncate =
                        Enum.TextTruncate.AtEnd,

                    ZIndex = 1004
                }
            )

        local Check =
            Create(
                "TextLabel",
                {
                    Name = "Check",

                    Parent =
                        OptionButton,

                    BackgroundTransparency = 1,

                    AnchorPoint =
                        Vector2.new(
                            1,
                            0.5
                        ),

                    Position =
                        UDim2.new(
                            1,
                            -9,
                            0.5,
                            0
                        ),

                    Size =
                        UDim2.fromOffset(
                            22,
                            22
                        ),

                    Font =
                        Enum.Font.GothamBold,

                    Text = "",

                    TextColor3 =
                        CurrentTheme.Accent,

                    TextSize = 15,

                    TextXAlignment =
                        Enum.TextXAlignment.Center,

                    TextYAlignment =
                        Enum.TextYAlignment.Center,

                    Visible =
                        MultiSelect,

                    ZIndex = 1004
                }
            )

        local OptionObject = {
            Button =
                OptionButton,

            Label =
                OptionLabel,

            Check =
                Check,

            Stroke =
                OptionStroke,

            Corner =
                OptionCorner,

            Name =
                Option
        }

        OptionObjects[Option] =
            OptionObject

        OptionButton.MouseEnter:Connect(
            function()

                local CurrentTheme =
                    GetTheme()

                OptionButton.BackgroundColor3 =
                    CurrentTheme.DropdownHover
                    or CurrentTheme.Hover

                OptionStroke.Color =
                    CurrentTheme.BorderHover
                    or CurrentTheme.AccentDark
                    or CurrentTheme.Border

            end
        )

        OptionButton.MouseLeave:Connect(
            function()

                local CurrentTheme =
                    GetTheme()

                if Selected[Option] then

                    OptionButton.BackgroundColor3 =
                        CurrentTheme.DropdownSelected
                        or CurrentTheme.Hover

                else

                    OptionButton.BackgroundColor3 =
                        CurrentTheme.Dropdown
                        or CurrentTheme.Element

                end

                OptionStroke.Color =
                    CurrentTheme.Border

            end
        )

        OptionButton.MouseButton1Click:Connect(
            function()

                if MultiSelect then

                    Selected[Option] =
                        not Selected[Option]

                    RefreshOption(
                        Option
                    )

                    UpdateValueText()

                    FireCallback()

                    return
                end

                for _, Existing in ipairs(
                    Options
                ) do

                    Selected[Existing] =
                        false

                end

                Selected[Option] =
                    true

                for _, Existing in ipairs(
                    Options
                ) do

                    RefreshOption(
                        Existing
                    )

                end

                UpdateValueText()

                FireCallback()

                Object:Close()

            end
        )

        RefreshOption(
            Option
        )

        return OptionObject
    end

    local function RebuildOptions()

        for _, Child in ipairs(
            OptionsList:GetChildren()
        ) do

            if Child:IsA(
                "TextButton"
            ) then

                Child:Destroy()

            end
        end

        OptionObjects = {}

        local SearchText =
            string.lower(
                SearchBox.Text
                or ""
            )

        for _, Option in ipairs(
            Options
        ) do

            local LowerOption =
                string.lower(
                    Option
                )

            local Matches =
                SearchText == ""
                or string.find(
                    LowerOption,
                    SearchText,
                    1,
                    true
                )

            if Matches then

                CreateOption(
                    Option
                )

            end
        end

        UpdateValueText()

        UpdateSize()

        task.defer(function()

            UpdateCanvas()

            if Open then
                UpdatePosition()
            end

        end)
    end

    SearchBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()

            RebuildOptions()

        end
    )

    Button.MouseEnter:Connect(
        function()

            local CurrentTheme =
                GetTheme()

            if OTC.Tween then

                OTC:Tween(
                    Frame,
                    0.08,
                    {
                        BackgroundColor3 =
                            CurrentTheme.DropdownHover
                            or CurrentTheme.Hover
                            or CurrentTheme.Element
                    }
                )

                OTC:Tween(
                    Stroke,
                    0.08,
                    {
                        Color =
                            CurrentTheme.BorderHover
                            or CurrentTheme.AccentDark
                            or CurrentTheme.Border
                    }
                )

            else

                Frame.BackgroundColor3 =
                    CurrentTheme.DropdownHover
                    or CurrentTheme.Hover
                    or CurrentTheme.Element

                Stroke.Color =
                    CurrentTheme.BorderHover
                    or CurrentTheme.Border

            end
        end
    )

    Button.MouseLeave:Connect(
        function()

            local CurrentTheme =
                GetTheme()

            if OTC.Tween then

                OTC:Tween(
                    Frame,
                    0.08,
                    {
                        BackgroundColor3 =
                            CurrentTheme.Dropdown
                            or CurrentTheme.Element
                    }
                )

                OTC:Tween(
                    Stroke,
                    0.08,
                    {
                        Color =
                            CurrentTheme.Border
                    }
                )

            else

                Frame.BackgroundColor3 =
                    CurrentTheme.Dropdown
                    or CurrentTheme.Element

                Stroke.Color =
                    CurrentTheme.Border

            end
        end
    )

    Button.MouseButton1Click:Connect(
        function()

            if Open then

                Object:Close()

            else

                Object:Open()

            end
        end
    )

    function Object:SetValue(Value)

        if MultiSelect then

            if type(Value) ~= "table" then
                return
            end

            Selected = {}

            for _, Item in ipairs(Value) do

                local StringValue =
                    tostring(Item)

                if table.find(
                    Options,
                    StringValue
                ) then

                    Selected[
                        StringValue
                    ] = true

                end
            end

        else

            local StringValue =
                tostring(Value)

            Selected = {}

            if table.find(
                Options,
                StringValue
            ) then

                Selected[
                    StringValue
                ] = true

            end
        end

        for _, Option in ipairs(
            Options
        ) do

            RefreshOption(
                Option
            )

        end

        UpdateValueText()

        FireCallback()
    end

    function Object:GetValue()

        if MultiSelect then

            local Values = {}

            for _, Option in ipairs(
                Options
            ) do

                if Selected[Option] then

                    table.insert(
                        Values,
                        Option
                    )

                end
            end

            return Values
        end

        for _, Option in ipairs(
            Options
        ) do

            if Selected[Option] then

                return Option

            end
        end

        return nil
    end

    function Object:SetOptions(
        NewOptions
    )

        Options =
            NormalizeOptions(
                NewOptions
            )

        local NewSelected = {}

        for _, Option in ipairs(
            Options
        ) do

            if Selected[Option] then

                NewSelected[
                    Option
                ] = true

            end
        end

        Selected =
            NewSelected

        if not MultiSelect
            and not next(Selected)
            and #Options > 0 then

            Selected[
                Options[1]
            ] = true

        end

        RebuildOptions()
    end

    function Object:AddOption(
        Option
    )

        Option =
            tostring(Option)

        if table.find(
            Options,
            Option
        ) then

            return
        end

        table.insert(
            Options,
            Option
        )

        RebuildOptions()
    end

    function Object:RemoveOption(
        Option
    )

        Option =
            tostring(Option)

        local Index =
            table.find(
                Options,
                Option
            )

        if Index then

            table.remove(
                Options,
                Index
            )
        end

        Selected[
            Option
        ] = nil

        RebuildOptions()
    end

    function Object:SetName(
        NewName
    )

        Name =
            tostring(NewName)

        NameLabel.Text =
            Name
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

    function Object:ClearSearch()

        SearchBox.Text = ""

    end

    function Object:RefreshTheme()

        if not Frame
            or not Frame.Parent then
            return
        end

        local CurrentTheme =
            GetTheme()

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
            CurrentTheme.Dropdown
            or CurrentTheme.Element

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
                Corners.Dropdown
                or 7
            )

        NameLabel.TextColor3 =
            CurrentTheme.Text

        ValueLabel.TextColor3 =
            CurrentTheme.SubText

        Arrow.TextColor3 =
            CurrentTheme.SubText

        DropdownFrame.BackgroundColor3 =
            CurrentTheme.PopupBackground
            or CurrentTheme.Secondary

        DropdownFrame.BackgroundTransparency =
            Transparency.Popup
            or 0

        DropdownStroke.Color =
            CurrentTheme.PopupBorder
            or CurrentTheme.Border

        DropdownStroke.Thickness =
            StrokeSettings.Thickness
            or 1

        DropdownStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        DropdownStroke.Enabled =
            StrokeSettings.Enabled ~= false

        DropdownCorner.CornerRadius =
            UDim.new(
                0,
                Corners.Popup
                or 10
            )

        SearchFrame.BackgroundColor3 =
            CurrentTheme.Input
            or CurrentTheme.Element

        SearchFrame.BackgroundTransparency =
            Transparency.Element
            or 0

        SearchStroke.Color =
            CurrentTheme.Border

        SearchStroke.Thickness =
            StrokeSettings.Thickness
            or 1

        SearchStroke.Transparency =
            StrokeSettings.Transparency
            or 0

        SearchStroke.Enabled =
            StrokeSettings.Enabled ~= false

        SearchCorner.CornerRadius =
            UDim.new(
                0,
                Corners.Input
                or 7
            )

        SearchIcon.TextColor3 =
            CurrentTheme.SubText

        if SearchLucideIcon then

            SearchLucideIcon.ImageColor3 =
                CurrentTheme.SubText

        end

        SearchBox.TextColor3 =
            CurrentTheme.Text

        SearchBox.PlaceholderColor3 =
            CurrentTheme.SubText

        OptionsList.ScrollBarImageColor3 =
            CurrentTheme.Scrollbar
            or CurrentTheme.SubText

        for Option, Data in pairs(
            OptionObjects
        ) do

            Data.Label.TextColor3 =
                CurrentTheme.Text

            Data.Check.TextColor3 =
                CurrentTheme.Accent

            Data.Button.BackgroundTransparency =
                Transparency.Element
                or 0

            Data.Stroke.Color =
                CurrentTheme.Border

            Data.Stroke.Thickness =
                StrokeSettings.Thickness
                or 1

            Data.Stroke.Transparency =
                StrokeSettings.Transparency
                or 0

            Data.Stroke.Enabled =
                StrokeSettings.Enabled ~= false

            Data.Corner.CornerRadius =
                UDim.new(
                    0,
                    Corners.Dropdown
                    or 7
                )

            RefreshOption(
                Option
            )
        end

        if Effects.Gradient
            and Gradients.Popup then

            ApplyGradient(
                DropdownFrame,
                Gradients.Popup
            )

        elseif Effects.Gradient
            and Gradients.Main then

            ApplyGradient(
                DropdownFrame,
                Gradients.Main
            )

        else

            local Existing =
                DropdownFrame:FindFirstChild(
                    "OTCGradient"
                )

            if Existing then
                Existing:Destroy()
            end
        end
    end

    function Object:Destroy()

        Object:Close()

        if DropdownFrame then
            DropdownFrame:Destroy()
        end

        if Frame then
            Frame:Destroy()
        end
    end

    Object.Type =
        "Dropdown"

    Object.Instance =
        Frame

    Object.Frame =
        Frame

    Object.Button =
        Button

    Object.DropdownFrame =
        DropdownFrame

    Object.SearchBox =
        SearchBox

    Object.OptionsList =
        OptionsList

    Object.MultiSelect =
        MultiSelect

    Object.Stroke =
        Stroke

    Object.DropdownStroke =
        DropdownStroke

    Object.Flag = Settings.Flag


    TabObject:AddElement(
        Object
    )

    RebuildOptions()

    return Object
end

return Dropdown