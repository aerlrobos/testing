--[[
    OTC Hub v1.0.3
    Popup / Dialog (modal card over a dimmed backdrop)
    by Aerlro
]]

local TweenService = game:GetService("TweenService")

local Popup = {}

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

--[[
    Data = {
        Title = "Title",
        Content = "Text",
        Accent = Color3 (optional),
        Dismissable = true,
        Buttons = {
            { Title = "Cancel" },
            { Title = "Confirm", Style = "Primary", Callback = function() end }
        }
    }
]]
function Popup.Create(ScreenGui, OTC, Data)
    Data = Data or {}

    local Theme = OTC:GetTheme()
    local Accent = Data.Accent or Theme.Accent
    local Dismissable = Data.Dismissable ~= false
    local Buttons = Data.Buttons

    if type(Buttons) ~= "table" or #Buttons == 0 then
        Buttons = { { Title = "OK", Style = "Primary" } }
    end

    local Object = {}
    local Closed = false

    local Overlay = create("TextButton", {
        Name = "OTC_Popup",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        AutoButtonColor = false,
        Active = true,
        ZIndex = 200
    })

    local Card = create("Frame", {
        Name = "Card",
        Parent = Overlay,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(360, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.PopupBackground or Theme.Background,
        BorderSizePixel = 0,
        Active = true
    })

    local Scale = create("UIScale", { Parent = Card, Scale = 0.9 })

    create("UICorner", {
        Parent = Card,
        CornerRadius = UDim.new(0, Theme.Corners and Theme.Corners.Popup or 12)
    })

    local Stroke = create("UIStroke", {
        Parent = Card,
        Color = Theme.PopupBorder or Theme.Border,
        Thickness = Theme.Stroke and Theme.Stroke.Thickness or 1
    })

    create("UIPadding", {
        Parent = Card,
        PaddingTop = UDim.new(0, 18),
        PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 18),
        PaddingRight = UDim.new(0, 18)
    })

    create("UIListLayout", {
        Parent = Card,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local AccentBar = create("Frame", {
        Name = "AccentBar",
        Parent = Card,
        LayoutOrder = 1,
        BackgroundColor3 = Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(36, 3)
    })

    create("UICorner", { Parent = AccentBar, CornerRadius = UDim.new(1, 0) })

    local TitleLabel = create("TextLabel", {
        Name = "Title",
        Parent = Card,
        LayoutOrder = 2,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.GothamBold,
        Text = tostring(Data.Title or "OTC Hub"),
        TextColor3 = Theme.Text,
        TextSize = 17,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ContentLabel = create("TextLabel", {
        Name = "Content",
        Parent = Card,
        LayoutOrder = 3,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.Gotham,
        Text = tostring(Data.Content or ""),
        TextColor3 = Theme.SubText,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Visible = (Data.Content ~= nil and Data.Content ~= "")
    })

    local Row = create("Frame", {
        Name = "Buttons",
        Parent = Card,
        LayoutOrder = 4,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34)
    })

    create("UIListLayout", {
        Parent = Row,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function Object:Close()
        if Closed then
            return
        end

        Closed = true

        tween(Overlay, 0.18, { BackgroundTransparency = 1 })
        tween(Scale, 0.18, { Scale = 0.9 })

        task.delay(0.2, function()
            if Overlay then
                Overlay:Destroy()
            end
        end)
    end

    for Index, ButtonData in ipairs(Buttons) do
        local Primary = ButtonData.Style == "Primary"
        local Danger = ButtonData.Style == "Danger"

        local FillColor = Theme.Element
        local TextColor = Theme.Text

        if Primary then
            FillColor = Accent
            TextColor = Theme.AccentText or Theme.Background
        elseif Danger then
            FillColor = Theme.Error or Color3.fromRGB(220, 70, 70)
            TextColor = Color3.new(1, 1, 1)
        end

        local Button = create("TextButton", {
            Name = "Button_" .. Index,
            Parent = Row,
            LayoutOrder = Index,
            BackgroundColor3 = FillColor,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 34),
            AutoButtonColor = false,
            Font = Enum.Font.GothamMedium,
            Text = tostring(ButtonData.Title or "OK"),
            TextColor3 = TextColor,
            TextSize = 13
        })

        create("UICorner", {
            Parent = Button,
            CornerRadius = UDim.new(0, Theme.Corners and Theme.Corners.Button or 8)
        })

        create("UIPadding", {
            Parent = Button,
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16)
        })

        Button.MouseEnter:Connect(function()
            tween(Button, 0.12, {
                BackgroundTransparency = 0.15
            })
        end)

        Button.MouseLeave:Connect(function()
            tween(Button, 0.12, {
                BackgroundTransparency = 0
            })
        end)

        Button.MouseButton1Click:Connect(function()
            Object:Close()

            if type(ButtonData.Callback) == "function" then
                local Success, Error = pcall(ButtonData.Callback)

                if not Success then
                    warn("[OTC Hub] Popup callback error:", Error)
                end
            end
        end)
    end

    if Dismissable then
        Overlay.MouseButton1Click:Connect(function()
            Object:Close()
        end)
    end

    Object.Overlay = Overlay
    Object.Card = Card

    tween(Overlay, 0.2, { BackgroundTransparency = 0.45 })
    tween(Scale, 0.25, { Scale = 1 })

    return Object
end

return Popup
