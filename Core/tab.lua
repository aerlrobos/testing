--[[
    OTC Hub v1
    Tab System
    by Aerlro
]]

local Tab = {}

local TweenService = game:GetService("TweenService")

local function tween(Object, Time, Properties)
    if not Object then
        return
    end

    local Info = TweenInfo.new(
        Time or 0.2,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

    local Animation = TweenService:Create(
        Object,
        Info,
        Properties
    )

    Animation:Play()

    return Animation
end

local function create(Class, Properties)
    local Object = Instance.new(Class)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    return Object
end

local function applyCorner(Object, Radius)
    if not Object then
        return
    end

    local Corner = Object:FindFirstChildOfClass("UICorner")

    if not Corner then
        Corner = Instance.new("UICorner")
        Corner.Parent = Object
    end

    Corner.CornerRadius = UDim.new(0, Radius or 7)
end

local function applyStroke(Object, Theme)
    if not Object or not Theme then
        return
    end

    local StrokeSettings = Theme.Stroke or {}

    if StrokeSettings.Enabled == false then
        local Existing = Object:FindFirstChildOfClass("UIStroke")

        if Existing then
            Existing.Enabled = false
        end

        return
    end

    local Stroke = Object:FindFirstChildOfClass("UIStroke")

    if not Stroke then
        Stroke = Instance.new("UIStroke")
        Stroke.Parent = Object
    end

    Stroke.Enabled = true
    Stroke.Color = Theme.Border or Color3.new(1, 1, 1)
    Stroke.Thickness = StrokeSettings.Thickness or 1
    Stroke.Transparency = StrokeSettings.Transparency or 0
end

local function createIcon(
    Button,
    IconValue,
    Theme,
    OTC
)
    if IconValue == nil then
        return create("TextLabel", {
            Name = "Icon",
            Parent = Button,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(10, 0),

            Size =
                UDim2.fromOffset(25, 38),

            Font =
                Enum.Font.GothamMedium,

            Text = "•",

            TextColor3 =
                Theme.SubText,

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Center,

            TextYAlignment =
                Enum.TextYAlignment.Center
        })
    end

    if type(IconValue) == "number" then
        IconValue =
            "rbxassetid://"
            .. tostring(IconValue)
    end

    if type(IconValue) == "string"
        and (
            IconValue:match("^rbxassetid://")
            or IconValue:match("^rbxasset://")
            or IconValue:match("^https?://")
        ) then

        return create("ImageLabel", {
            Name = "Icon",
            Parent = Button,

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Position =
                UDim2.fromOffset(12, 9),

            Size =
                UDim2.fromOffset(20, 20),

            Image = IconValue,

            ImageColor3 =
                Theme.SubText,

            ImageTransparency = 0,

            ScaleType =
                Enum.ScaleType.Fit
        })
    end

    if type(IconValue) == "string"
        and OTC
        and OTC._Lucide
        and OTC._Lucide.Available then

        local LucideIcon =
            OTC._Lucide:GetIcon(IconValue)

        if LucideIcon
            and LucideIcon.Url
            and LucideIcon.ImageRectSize
            and LucideIcon.ImageRectOffset then

            return create("ImageLabel", {
                Name = "Icon",
                Parent = Button,

                BackgroundTransparency = 1,
                BorderSizePixel = 0,

                Position =
                    UDim2.fromOffset(12, 9),

                Size =
                    UDim2.fromOffset(20, 20),

                Image =
                    LucideIcon.Url,

                ImageRectSize =
                    LucideIcon.ImageRectSize,

                ImageRectOffset =
                    LucideIcon.ImageRectOffset,

                ImageColor3 =
                    Theme.SubText,

                ImageTransparency = 0,

                ScaleType =
                    Enum.ScaleType.Fit
            })
        end
    end

    if type(IconValue) == "string" then
        return create("TextLabel", {
            Name = "Icon",
            Parent = Button,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(10, 0),

            Size =
                UDim2.fromOffset(25, 38),

            Font =
                Enum.Font.GothamMedium,

            Text =
                IconValue,

            TextColor3 =
                Theme.SubText,

            TextSize = 15,

            TextXAlignment =
                Enum.TextXAlignment.Center,

            TextYAlignment =
                Enum.TextYAlignment.Center
        })
    end

    return create("TextLabel", {
        Name = "Icon",
        Parent = Button,

        BackgroundTransparency = 1,

        Position =
            UDim2.fromOffset(10, 0),

        Size =
            UDim2.fromOffset(25, 38),

        Font =
            Enum.Font.GothamMedium,

        Text = "•",

        TextColor3 =
            Theme.SubText,

        TextSize = 15,

        TextXAlignment =
            Enum.TextXAlignment.Center,

        TextYAlignment =
            Enum.TextYAlignment.Center
    })
end

function Tab.Create(
    Window,
    OTC,
    Settings
)

    Settings = Settings or {}

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Window.Theme]
            or OTC._Themes.Default
    end

    local Theme = getTheme()

    local TabObject = {
        Window = Window,
        OTC = OTC,

        Name =
            Settings.Name
            or "Tab",

        Icon =
            Settings.Icon,

        Elements = {},

        Selected = false
    }

    local Button = create(
        "TextButton",
        {
            Name =
                TabObject.Name
                .. "_Button",

            Parent =
                Window.TabsContainer,

            BackgroundColor3 =
                Theme.Tab,

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            -- MODIFICAT: spațiu egal stânga/dreapta
            Size =
                UDim2.new(
                    1,
                    -2,
                    0,
                    38
                ),

            Position =
                UDim2.fromOffset(
                    1,
                    0
                ),

            AutoButtonColor = false,

            Text = "",

            TextColor3 =
                Theme.Text
        }
    )

    local CornerSettings =
        Theme.Corners
        or {}

    applyCorner(
        Button,
        CornerSettings.Element or 7
    )

    

    local Icon = createIcon(
        Button,
        Settings.Icon,
        Theme,
        OTC
    )

    local Name = create(
        "TextLabel",
        {
            Name = "Name",
            Parent = Button,

            BackgroundTransparency = 1,

            Position =
                UDim2.fromOffset(
                    42,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -48,
                    1,
                    0
                ),

            Font =
                Enum.Font.GothamMedium,

            Text =
                TabObject.Name,

            TextColor3 =
                Theme.SubText,

            TextSize = 13,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextYAlignment =
                Enum.TextYAlignment.Center
        }
    )

    local Indicator = create(
        "Frame",
        {
            Name = "Indicator",
            Parent = Button,

            BackgroundColor3 =
                Theme.Accent,

            BorderSizePixel = 0,

            Position =
                UDim2.new(
                    0,
                    0,
                    0.5,
                    -9
                ),

            Size =
                UDim2.fromOffset(
                    3,
                    18
                ),

            Visible = false
        }
    )

    applyCorner(
        Indicator,
        999
    )

    local Page = create(
        "ScrollingFrame",
        {
            Name =
                TabObject.Name
                .. "_Page",

            Parent =
                Window.Content,

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                ),

            CanvasSize =
                UDim2.new(),

            AutomaticCanvasSize =
                Enum.AutomaticSize.Y,

            ScrollBarThickness = 3,

            ScrollBarImageColor3 =
                Theme.Scrollbar
                or Theme.Border,

            Visible = false
        }
    )

    create(
        "UIPadding",
        {
            Parent = Page,

            PaddingTop =
                UDim.new(
                    0,
                    18
                ),

            PaddingBottom =
                UDim.new(
                    0,
                    18
                ),

            PaddingLeft =
                UDim.new(
                    0,
                    18
                ),

            PaddingRight =
                UDim.new(
                    0,
                    18
                )
        }
    )

    create(
        "UIListLayout",
        {
            Parent = Page,

            Padding =
                UDim.new(
                    0,
                    8
                ),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        }
    )

    TabObject.Button =
        Button

    TabObject.Page =
        Page

    TabObject.Indicator =
        Indicator

    TabObject.IconLabel =
        Icon

    TabObject.NameLabel =
        Name

    function TabObject:AddElement(Element)

        if not Element then
            return
        end

        for _, Existing in ipairs(self.Elements) do
            if Existing == Element then
                return Element
            end
        end

        table.insert(
            self.Elements,
            Element
        )

        if Element.Flag and self.OTC and self.OTC.RegisterFlag then
            self.OTC:RegisterFlag(Element.Flag, Element)
        end

        return Element
    end

    local function setIconColor(Color)

        if not Icon then
            return
        end

        if Icon:IsA("ImageLabel")
            or Icon:IsA("ImageButton") then

            Icon.ImageColor3 =
                Color

        elseif Icon:IsA("TextLabel")
            or Icon:IsA("TextButton") then

            Icon.TextColor3 =
                Color
        end
    end

    function TabObject:SetSelected(Value)

        self.Selected = Value

        local CurrentTheme =
            getTheme()

        if Value then

            Page.Visible = true
            Indicator.Visible = true

            tween(
                Button,
                0.2,
                {
                    BackgroundTransparency = 0,

                    BackgroundColor3 =
                        CurrentTheme.TabSelected
                        or CurrentTheme.Element
                }
            )

            tween(
                Name,
                0.2,
                {
                    TextColor3 =
                        CurrentTheme.Text
                }
            )

            setIconColor(
                CurrentTheme.Text
            )

        else

            Page.Visible = false
            Indicator.Visible = false

            tween(
                Button,
                0.2,
                {
                    BackgroundTransparency = 1
                }
            )

            tween(
                Name,
                0.2,
                {
                    TextColor3 =
                        CurrentTheme.SubText
                }
            )

            setIconColor(
                CurrentTheme.SubText
            )
        end
    end

    Button.MouseEnter:Connect(
        function()

            if TabObject.Selected then
                return
            end

            local CurrentTheme =
                getTheme()

            tween(
                Button,
                0.15,
                {
                    BackgroundTransparency = 0.15,

                    BackgroundColor3 =
                        CurrentTheme.TabHover
                        or CurrentTheme.Hover
                }
            )

            tween(
                Name,
                0.15,
                {
                    TextColor3 =
                        CurrentTheme.Text
                }
            )

            setIconColor(
                CurrentTheme.Text
            )
        end
    )

    Button.MouseLeave:Connect(
        function()

            if TabObject.Selected then
                return
            end

            local CurrentTheme =
                getTheme()

            tween(
                Button,
                0.15,
                {
                    BackgroundTransparency = 1
                }
            )

            tween(
                Name,
                0.15,
                {
                    TextColor3 =
                        CurrentTheme.SubText
                }
            )

            setIconColor(
                CurrentTheme.SubText
            )
        end
    )

    Button.MouseButton1Click:Connect(
        function()

            Window:SelectTab(
                TabObject
            )

        end
    )

    function TabObject:Select()
        Window:SelectTab(self)
    end

    function TabObject:CreateSection(Text)
        local CurrentTheme = getTheme()

        local SectionLabel = create("TextLabel", {
            Name = "Section",
            Parent = Page,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.GothamBold,
            Text = Text or "Section",
            TextColor3 = CurrentTheme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        })

        create("UIPadding", {
            Parent = SectionLabel,
            PaddingLeft = UDim.new(0, 12)
        })

        local Bar = create("Frame", {
            Name = "Bar",
            Parent = SectionLabel,
            BackgroundColor3 = CurrentTheme.Accent,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, -12, 0.5, 0),
            Size = UDim2.fromOffset(3, 14)
        })

        applyCorner(Bar, 999)

        local Line = create("Frame", {
            Name = "Line",
            Parent = SectionLabel,
            BackgroundColor3 = CurrentTheme.Border,
            BackgroundTransparency = 0.75,
            BorderSizePixel = 0,
            Position = UDim2.new(0, -12, 1, -1),
            Size = UDim2.new(1, 12, 0, 1)
        })

        local Object = {
            Type = "Section",
            Instance = SectionLabel,
            Label = SectionLabel
        }

        function Object:SetText(NewText)
            SectionLabel.Text = tostring(NewText)
        end

        function Object:RefreshTheme()
            if not self.Label or not self.Label.Parent then
                return
            end

            local CurrentTheme = getTheme()

            self.Label.TextColor3 = CurrentTheme.Text
            Bar.BackgroundColor3 = CurrentTheme.Accent
            Line.BackgroundColor3 = CurrentTheme.Border
        end

        self:AddElement(Object)

        return Object
    end

    function TabObject:CreateText(Text)
        local CurrentTheme = getTheme()

        local TextLabel = create("TextLabel", {
            Name = "Text",
            Parent = Page,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Gotham,
            Text = Text or "",
            TextColor3 = CurrentTheme.SubText,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        })

        local Object = {
            Type = "Text",
            Instance = TextLabel,
            Label = TextLabel
        }

        function Object:SetText(NewText)
            TextLabel.Text = tostring(NewText)
        end

        function Object:RefreshTheme()
            if not self.Label or not self.Label.Parent then
                return
            end

            self.Label.TextColor3 = getTheme().SubText
        end

        self:AddElement(Object)

        return Object
    end

    function TabObject:CreateDivider(Text)
        local CurrentTheme = getTheme()

        local Holder = create("Frame", {
            Name = "Divider",
            Parent = Page,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18)
        })

        local Line = create("Frame", {
            Name = "Line",
            Parent = Holder,
            BackgroundColor3 = CurrentTheme.Border,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1)
        })

        local Label

        if Text and Text ~= "" then
            Label = create("TextLabel", {
                Name = "Label",
                Parent = Holder,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 18),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Background,
                BorderSizePixel = 0,
                Font = Enum.Font.GothamMedium,
                Text = tostring(Text),
                TextColor3 = CurrentTheme.MutedText or CurrentTheme.SubText,
                TextSize = 11
            })

            create("UIPadding", {
                Parent = Label,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        end

        local Object = {
            Type = "Divider",
            Instance = Holder
        }

        function Object:RefreshTheme()
            if not Holder or not Holder.Parent then
                return
            end

            local CurrentTheme = getTheme()

            Line.BackgroundColor3 = CurrentTheme.Border

            if Label then
                Label.BackgroundColor3 = CurrentTheme.Background
                Label.TextColor3 = CurrentTheme.MutedText or CurrentTheme.SubText
            end
        end

        self:AddElement(Object)

        return Object
    end

    function TabObject:CreateSpace(Height)
        local Space = create("Frame", {
            Name = "Space",
            Parent = Page,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, tonumber(Height) or 10)
        })

        local Object = {
            Type = "Space",
            Instance = Space
        }

        self:AddElement(Object)

        return Object
    end

    -- Settings = { Title = "...", Content = "..." } or a plain string
    function TabObject:CreateParagraph(Settings)
        if type(Settings) == "string" then
            Settings = { Content = Settings }
        end

        Settings = Settings or {}

        local CurrentTheme = getTheme()

        local Card = create("Frame", {
            Name = "Paragraph",
            Parent = Page,
            BackgroundColor3 = CurrentTheme.Element,
            BackgroundTransparency = CurrentTheme.Transparency and CurrentTheme.Transparency.Element or 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })

        applyCorner(Card, CurrentTheme.Corners and CurrentTheme.Corners.Element or 8)
        applyStroke(Card, CurrentTheme)

        create("UIPadding", {
            Parent = Card,
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15)
        })

        create("UIListLayout", {
            Parent = Card,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local TitleLabel = create("TextLabel", {
            Name = "Title",
            Parent = Card,
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.GothamBold,
            Text = tostring(Settings.Title or ""),
            TextColor3 = CurrentTheme.Text,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = Settings.Title ~= nil and Settings.Title ~= ""
        })

        local ContentLabel = create("TextLabel", {
            Name = "Content",
            Parent = Card,
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Gotham,
            Text = tostring(Settings.Content or ""),
            TextColor3 = CurrentTheme.SubText,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        local Object = {
            Type = "Paragraph",
            Instance = Card
        }

        function Object:SetTitle(NewTitle)
            TitleLabel.Text = tostring(NewTitle)
            TitleLabel.Visible = NewTitle ~= nil and NewTitle ~= ""
        end

        function Object:SetContent(NewContent)
            ContentLabel.Text = tostring(NewContent)
        end

        function Object:RefreshTheme()
            if not Card or not Card.Parent then
                return
            end

            local CurrentTheme = getTheme()

            Card.BackgroundColor3 = CurrentTheme.Element
            Card.BackgroundTransparency = CurrentTheme.Transparency and CurrentTheme.Transparency.Element or 0
            applyCorner(Card, CurrentTheme.Corners and CurrentTheme.Corners.Element or 8)
            applyStroke(Card, CurrentTheme)
            TitleLabel.TextColor3 = CurrentTheme.Text
            ContentLabel.TextColor3 = CurrentTheme.SubText
        end

        self:AddElement(Object)

        return Object
    end

    local function createWithModule(ModuleName, Label)
        return function(self, Settings)
            Settings = Settings or {}

            local Module = self.OTC._Modules and self.OTC._Modules[ModuleName]

            if not Module then
                error("[OTC Hub] " .. Label .. " module is not loaded")
            end

            return Module.Create(self, self.OTC, Settings)
        end
    end

    TabObject.CreateKeybind = createWithModule("Keybind", "Keybind")
    TabObject.CreateColorPicker = createWithModule("ColorPicker", "ColorPicker")
    TabObject.CreateProgress = createWithModule("Progress", "Progress")

    function TabObject:CreateButton(Settings)

        Settings = Settings or {}

        local Module =
            self.OTC._Modules
            and self.OTC._Modules.Button

        if not Module then
            error(
                "[OTC Hub] Button module is not loaded"
            )
        end

        return Module.Create(
            self,
            self.OTC,
            Settings
        )
    end

    function TabObject:CreateToggle(Settings)

        Settings = Settings or {}

        local Module =
            self.OTC._Modules
            and self.OTC._Modules.Toggle

        if not Module then
            error(
                "[OTC Hub] Toggle module is not loaded"
            )
        end

        return Module.Create(
            self,
            self.OTC,
            Settings
        )
    end

    function TabObject:CreateSlider(Settings)

        Settings = Settings or {}

        local Module =
            self.OTC._Modules
            and self.OTC._Modules.Slider

        if not Module then
            error(
                "[OTC Hub] Slider module is not loaded"
            )
        end

        return Module.Create(
            self,
            self.OTC,
            Settings
        )
    end

    function TabObject:CreateDropdown(Settings)

        Settings = Settings or {}

        local Module =
            self.OTC._Modules
            and self.OTC._Modules.Dropdown

        if not Module then
            error(
                "[OTC Hub] Dropdown module is not loaded"
            )
        end

        return Module.Create(
            self,
            self.OTC,
            Settings
        )
    end

    function TabObject:CreateInput(Settings)

        Settings = Settings or {}

        local Module =
            self.OTC._Modules
            and self.OTC._Modules.Input

        if not Module then
            error(
                "[OTC Hub] Input module is not loaded"
            )
        end

        return Module.Create(
            self,
            self.OTC,
            Settings
        )
    end

    function TabObject:RefreshTheme()

        local CurrentTheme =
            getTheme()

        Button.BackgroundColor3 =
            CurrentTheme.Tab

        Indicator.BackgroundColor3 =
            CurrentTheme.Accent

        Page.ScrollBarImageColor3 =
            CurrentTheme.Scrollbar
            or CurrentTheme.Border

        applyCorner(
            Button,
            (CurrentTheme.Corners and CurrentTheme.Corners.Element)
                or 7
        )

        

        if self.Selected then

            Button.BackgroundTransparency = 0

            Button.BackgroundColor3 =
                CurrentTheme.TabSelected
                or CurrentTheme.Element

            Name.TextColor3 =
                CurrentTheme.Text

            setIconColor(
                CurrentTheme.Text
            )

        else

            Button.BackgroundTransparency = 1

            Name.TextColor3 =
                CurrentTheme.SubText

            setIconColor(
                CurrentTheme.SubText
            )
        end

        for _, Element in ipairs(
            self.Elements
        ) do

            if Element
                and type(Element) == "table"
                and type(Element.RefreshTheme) == "function" then

                local Success, ErrorMessage =
                    pcall(
                        function()
                            Element:RefreshTheme()
                        end
                    )

                if not Success then
                    warn(
                        "[OTC Hub] Failed to refresh element theme:",
                        ErrorMessage
                    )
                end
            end
        end
    end

    Window:AddTab(
        TabObject
    )

    if #Window.Tabs == 1 then
        Window:SelectTab(
            TabObject
        )
    end

    return TabObject
end

return Tab