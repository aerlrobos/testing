--[[
    OTC Hub v1
    Animation System
    by Aerlro
]]

local Animation = {}

local TweenService = game:GetService("TweenService")

Animation.DefaultTime = 0.25
Animation.DefaultStyle = Enum.EasingStyle.Quint
Animation.DefaultDirection = Enum.EasingDirection.Out

local function getInfo(Time, Style, Direction)
    return TweenInfo.new(
        Time or Animation.DefaultTime,
        Style or Animation.DefaultStyle,
        Direction or Animation.DefaultDirection
    )
end

function Animation:Tween(Object, Properties, Time, Style, Direction)
    if not Object then
        return nil
    end

    local Tween = TweenService:Create(
        Object,
        getInfo(Time, Style, Direction),
        Properties
    )

    Tween:Play()

    return Tween
end

function Animation:FadeIn(Object, Time)
    if not Object then
        return
    end

    if Object:IsA("GuiObject") then
        Object.Visible = true
    end

    if Object:IsA("TextLabel")
        or Object:IsA("TextButton")
        or Object:IsA("TextBox") then

        Object.TextTransparency = 1

        return self:Tween(Object, {
            TextTransparency = 0
        }, Time)
    end

    if Object:IsA("ImageLabel")
        or Object:IsA("ImageButton") then

        Object.ImageTransparency = 1

        return self:Tween(Object, {
            ImageTransparency = 0
        }, Time)
    end

    if Object:IsA("GuiObject") then
        Object.BackgroundTransparency = 1

        return self:Tween(Object, {
            BackgroundTransparency = 0
        }, Time)
    end
end

function Animation:FadeOut(Object, Time)
    if not Object then
        return
    end

    if Object:IsA("TextLabel")
        or Object:IsA("TextButton")
        or Object:IsA("TextBox") then

        return self:Tween(Object, {
            TextTransparency = 1
        }, Time)
    end

    if Object:IsA("ImageLabel")
        or Object:IsA("ImageButton") then

        return self:Tween(Object, {
            ImageTransparency = 1
        }, Time)
    end

    if Object:IsA("GuiObject") then
        return self:Tween(Object, {
            BackgroundTransparency = 1
        }, Time)
    end
end

function Animation:Slide(Object, Position, Time)
    if not Object then
        return
    end

    return self:Tween(Object, {
        Position = Position
    }, Time)
end

function Animation:Resize(Object, Size, Time)
    if not Object then
        return
    end

    return self:Tween(Object, {
        Size = Size
    }, Time)
end

function Animation:Scale(Object, Scale, Time)
    if not Object then
        return
    end

    local UIScale = Object:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Scale = 1
        UIScale.Parent = Object
    end

    return self:Tween(UIScale, {
        Scale = Scale
    }, Time)
end

function Animation:Pulse(Object, Time, Amount)
    if not Object then
        return
    end

    Amount = Amount or 1.04

    local UIScale = Object:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Scale = 1
        UIScale.Parent = Object
    end

    local Up = self:Tween(UIScale, {
        Scale = Amount
    }, Time or 0.12)

    if Up then
        Up.Completed:Connect(function()
            self:Tween(UIScale, {
                Scale = 1
            }, Time or 0.12)
        end)
    end
end

function Animation:Hover(Button, NormalSize, HoverSize)
    if not Button then
        return
    end

    NormalSize = NormalSize or Button.Size
    HoverSize = HoverSize or UDim2.new(
        NormalSize.X.Scale,
        NormalSize.X.Offset + 2,
        NormalSize.Y.Scale,
        NormalSize.Y.Offset + 2
    )

    Button.MouseEnter:Connect(function()
        self:Tween(Button, {
            Size = HoverSize
        }, 0.15)
    end)

    Button.MouseLeave:Connect(function()
        self:Tween(Button, {
            Size = NormalSize
        }, 0.15)
    end)
end

function Animation:Press(Button)
    if not Button then
        return
    end

    Button.MouseButton1Down:Connect(function()
        self:Scale(Button, 0.96, 0.08)
    end)

    Button.MouseButton1Up:Connect(function()
        self:Scale(Button, 1, 0.12)
    end)
end

function Animation:Appear(Object, Direction, Distance, Time)
    if not Object then
        return
    end

    Direction = Direction or "Bottom"
    Distance = Distance or 20
    Time = Time or 0.3

    local OriginalPosition = Object.Position

    local StartPosition

    if Direction == "Top" then
        StartPosition = OriginalPosition + UDim2.fromOffset(0, -Distance)

    elseif Direction == "Bottom" then
        StartPosition = OriginalPosition + UDim2.fromOffset(0, Distance)

    elseif Direction == "Left" then
        StartPosition = OriginalPosition + UDim2.fromOffset(-Distance, 0)

    elseif Direction == "Right" then
        StartPosition = OriginalPosition + UDim2.fromOffset(Distance, 0)

    else
        StartPosition = OriginalPosition
    end

    Object.Position = StartPosition

    local IsText =
        Object:IsA("TextLabel")
        or Object:IsA("TextButton")
        or Object:IsA("TextBox")

    local IsImage =
        Object:IsA("ImageLabel")
        or Object:IsA("ImageButton")

    if IsText then
        Object.TextTransparency = 1

    elseif IsImage then
        Object.ImageTransparency = 1

    else
        Object.BackgroundTransparency = 1
    end

    self:Tween(Object, {
        Position = OriginalPosition
    }, Time)

    if IsText then
        self:Tween(Object, {
            TextTransparency = 0
        }, Time)

    elseif IsImage then
        self:Tween(Object, {
            ImageTransparency = 0
        }, Time)

    else
        self:Tween(Object, {
            BackgroundTransparency = 0
        }, Time)
    end
end

function Animation:Destroy(Object, Time)
    if not Object then
        return
    end

    local Tween = self:Tween(Object, {
        Size = UDim2.fromScale(0, 0)
    }, Time or 0.2)

    if Tween then
        Tween.Completed:Connect(function()
            if Object then
                Object:Destroy()
            end
        end)
    end
end

return Animation
