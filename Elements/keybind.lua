--[[
    OTC Hub v1.0.2
    Keybind element
    by Aerlro
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Keybind = {}

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

local MOUSE_KEYS = {
    MouseButton2 = Enum.UserInputType.MouseButton2,
    MouseButton3 = Enum.UserInputType.MouseButton3
}

local function ToKey(Value)
    if typeof(Value) == "EnumItem" then
        if Value == Enum.KeyCode.Unknown then
            return nil
        end

        return Value
    end

    if type(Value) == "string" then
        if MOUSE_KEYS[Value] then
            return MOUSE_KEYS[Value]
        end

        local Success, Item = pcall(function()
            return Enum.KeyCode[Value]
        end)

        if Success and Item and Item ~= Enum.KeyCode.Unknown then
            return Item
        end
    end

    return nil
end

local function KeyName(Key)
    if not Key then
        return "None"
    end

    local Short = {
        MouseButton2 = "MB2",
        MouseButton3 = "MB3",
        LeftControl = "LCtrl",
        RightControl = "RCtrl",
        LeftShift = "LShift",
        RightShift = "RShift",
        LeftAlt = "LAlt",
        RightAlt = "RAlt",
        Backquote = "`"
    }

    return Short[Key.Name] or Key.Name
end

--[[
    Settings = {
        Name = "Fly",
        Description = "optional",
        CurrentKeybind = "F",          -- string or Enum.KeyCode
        HoldToInteract = false,        -- true: Callback(true) on press, Callback(false) on release
        Flag = "FlyKey",
        Callback = function(KeyName) end,
        ChangedCallback = function(KeyName) end
    }
]]
function Keybind.Create(Tab, OTC, Settings)
    Settings = Settings or {}

    local function getTheme()
        return OTC._Themes[OTC.CurrentTheme]
            or OTC._Themes[Tab.Window.Theme]
            or OTC._Themes.Default
    end

    local Theme = getTheme()

    local Name = Settings.Name or "Keybind"
    local Description = Settings.Description
    local Flag = Settings.Flag
    local Hold = Settings.HoldToInteract == true
    local Callback = Settings.Callback or function() end
    local Changed = Settings.ChangedCallback or function() end

    local CurrentKey = ToKey(Settings.CurrentKeybind)
    local Listening = false
    local Connections = {}

    local Frame = create("Frame", {
        Name = "Keybind",
        Parent = Tab.Page,
        BackgroundColor3 = Theme.Element,
        BackgroundTransparency = Theme.Transparency and Theme.Transparency.Element or 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Description and 62 or 48)
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
        Position = Description and UDim2.fromOffset(15, 7) or UDim2.new(0, 15, 0.5, -12),
        Size = UDim2.new(1, -125, 0, 24),
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
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 31),
            Size = UDim2.new(1, -125, 0, 20),
            Font = Enum.Font.Gotham,
            Text = Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
    end

    local KeyButton = create("TextButton", {
        Name = "Key",
        Parent = Frame,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(92, 28),
        BackgroundColor3 = Theme.Input or Theme.Background,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = KeyName(CurrentKey),
        TextColor3 = Theme.Text,
        TextSize = 12
    })

    create("UICorner", {
        Parent = KeyButton,
        CornerRadius = UDim.new(0, Theme.Corners and Theme.Corners.Input or 8)
    })

    local KeyStroke = create("UIStroke", {
        Parent = KeyButton,
        Color = Theme.Border,
        Thickness = 1
    })

    local function setKey(Key, RunChanged)
        CurrentKey = Key
        KeyButton.Text = KeyName(Key)

        if Flag then
            OTC:SetFlag(Flag, Key and Key.Name or "None")
        end

        if RunChanged then
            local Success, Error = pcall(Changed, Key and Key.Name or "None")

            if not Success then
                warn("[OTC Hub] Keybind changed callback error:", Error)
            end
        end
    end

    local function stopListening()
        Listening = false

        local CurrentTheme = getTheme()

        KeyButton.Text = KeyName(CurrentKey)
        tween(KeyStroke, 0.15, { Color = CurrentTheme.Border })
        tween(KeyButton, 0.15, { BackgroundColor3 = CurrentTheme.Input or CurrentTheme.Background })
    end

    local function matches(Input)
        if not CurrentKey then
            return false
        end

        if CurrentKey.EnumType == Enum.KeyCode then
            return Input.KeyCode == CurrentKey
        end

        return Input.UserInputType == CurrentKey
    end

    KeyButton.MouseButton1Click:Connect(function()
        if Listening then
            stopListening()
            return
        end

        Listening = true
        KeyButton.Text = "..."

        local CurrentTheme = getTheme()

        tween(KeyStroke, 0.15, { Color = CurrentTheme.Accent })
        tween(KeyButton, 0.15, { BackgroundColor3 = CurrentTheme.Hover or CurrentTheme.Element })
    end)

    table.insert(Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
        if Listening then
            if Input.UserInputType == Enum.UserInputType.Keyboard then
                if Input.KeyCode == Enum.KeyCode.Escape then
                    stopListening()
                elseif Input.KeyCode == Enum.KeyCode.Backspace then
                    setKey(nil, true)
                    stopListening()
                else
                    setKey(ToKey(Input.KeyCode), true)
                    stopListening()
                end
            elseif MOUSE_KEYS[Input.UserInputType.Name] then
                setKey(Input.UserInputType, true)
                stopListening()
            end

            return
        end

        if Processed or not matches(Input) then
            return
        end

        if Hold then
            pcall(Callback, true)
        else
            local Success, Error = pcall(Callback, CurrentKey and CurrentKey.Name or "None")

            if not Success then
                warn("[OTC Hub] Keybind callback error:", Error)
            end
        end
    end))

    table.insert(Connections, UserInputService.InputEnded:Connect(function(Input)
        if Hold and not Listening and matches(Input) then
            pcall(Callback, false)
        end
    end))

    Frame.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            for _, Connection in ipairs(Connections) do
                Connection:Disconnect()
            end

            table.clear(Connections)
        end
    end)

    Frame.MouseEnter:Connect(function()
        local CurrentTheme = getTheme()
        tween(Stroke, 0.15, { Color = CurrentTheme.BorderHover or CurrentTheme.Border })
    end)

    Frame.MouseLeave:Connect(function()
        tween(Stroke, 0.15, { Color = getTheme().Border })
    end)

    if Flag then
        OTC:SetFlag(Flag, CurrentKey and CurrentKey.Name or "None")
    end

    local Object = {}

    Object.Type = "Keybind"
    Object.Instance = Frame
    Object.Flag = Flag

    function Object:SetValue(Value)
        setKey(ToKey(Value), true)
    end

    function Object:GetValue()
        return CurrentKey and CurrentKey.Name or "None"
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

        KeyButton.BackgroundColor3 = CurrentTheme.Input or CurrentTheme.Background
        KeyButton.TextColor3 = CurrentTheme.Text
        KeyStroke.Color = Listening and CurrentTheme.Accent or CurrentTheme.Border
    end

    function Object:Destroy()
        if Frame and Frame.Parent then
            Frame:Destroy()
        end
    end

    Tab:AddElement(Object)

    return Object
end

return Keybind
