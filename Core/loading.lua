local Loading = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

Loading.Config = {
    Title = "OTC HUB",
    Subtitle = "YOUR HUB. YOUR CONTROL.",

    Logo = "rbxassetid://95900623719417",

    Star = nil,
    Glyph = nil,

    MinimumDuration = 3.5,
}

local function Tween(Object, Time, Properties, Style, Direction)
    if not Object then
        return
    end

    local TweenObject = TweenService:Create(
        Object,
        TweenInfo.new(
            Time or 0.25,
            Style or Enum.EasingStyle.Quint,
            Direction or Enum.EasingDirection.Out
        ),
        Properties
    )

    TweenObject:Play()

    return TweenObject
end

local function New(Class, Properties, Parent)
    local Instance_ = Instance.new(Class)

    for Key, Value in pairs(Properties) do
        Instance_[Key] = Value
    end

    Instance_.Parent = Parent

    return Instance_
end

local function Corner(Object, Radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, Radius)
    }, Object)
end

local function Label(Parent, Properties)
    Properties.BackgroundTransparency = 1
    Properties.BorderSizePixel = 0
    Properties.AnchorPoint = Properties.AnchorPoint or Vector2.new(0.5, 0.5)
    Properties.Font = Properties.Font or Enum.Font.Gotham
    Properties.TextXAlignment = Properties.TextXAlignment or Enum.TextXAlignment.Center
    Properties.TextYAlignment = Enum.TextYAlignment.Center

    return New("TextLabel", Properties, Parent)
end

local function FadeOutGui(Root, Time)
    local function Fade(Object)
        if Object:IsA("GuiObject") then
            local Properties = {}

            if Object.BackgroundTransparency < 1 then
                Properties.BackgroundTransparency = 1
            end

            if Object:IsA("TextLabel")
                or Object:IsA("TextButton")
                or Object:IsA("TextBox") then

                if Object.TextTransparency < 1 then
                    Properties.TextTransparency = 1
                end
            end

            if Object:IsA("ImageLabel")
                or Object:IsA("ImageButton") then

                if Object.ImageTransparency < 1 then
                    Properties.ImageTransparency = 1
                end
            end

            if next(Properties) then
                Tween(Object, Time, Properties)
            end

        elseif Object:IsA("UIStroke") then
            if Object.Transparency < 1 then
                Tween(Object, Time, { Transparency = 1 })
            end
        end
    end

    Fade(Root)

    for _, Object in ipairs(Root:GetDescendants()) do
        Fade(Object)
    end
end

function Loading.Create(Total)
    Total = tonumber(Total) or 1

    if Total <= 0 then
        Total = 1
    end

    local Config = Loading.Config

    local Object = {}

    Object.Total = Total
    Object.Current = 0
    Object.Progress = 0
    Object.Closed = false
    Object.Finishing = false
    Object.IntroDone = false

    Object.StartTime = os.clock()
    Object.MinimumDuration = Config.MinimumDuration

    local Connections = {}

    local ScreenGui = New("ScreenGui", {
        Name = "OTC_Loading",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999999,
    })

    pcall(function()
        ScreenGui.Parent = CoreGui
    end)

    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    Object.ScreenGui = ScreenGui

    local Background = New("Frame", {
        Name = "Background",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 1,
        Active = true,
    }, ScreenGui)

    Object.Background = Background

    for Index = 1, 60 do
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, Index / 60, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.988,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, Background)
    end

    local Band = New("Frame", {
        Name = "ScanBand",
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(1, 0, 0, 80),
        Position = UDim2.fromScale(0, -0.2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, Background)

    New("UIGradient", {
        Rotation = 0,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.985),
            NumberSequenceKeypoint.new(0.5, 0.93),
            NumberSequenceKeypoint.new(0.85, 0.985),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, Band)

    local Frame = New("Frame", {
        Name = "Frame",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.73, 0.55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, Background)

    local Brackets = {}

    local function Bracket(AnchorX, AnchorY)
        local Length = 14

        local Horizontal = New("Frame", {
            AnchorPoint = Vector2.new(AnchorX, AnchorY),
            Position = UDim2.fromScale(AnchorX, AnchorY),
            Size = UDim2.fromOffset(Length, 1),
            BackgroundColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
        }, Frame)

        local Vertical = New("Frame", {
            AnchorPoint = Vector2.new(AnchorX, AnchorY),
            Position = UDim2.fromScale(AnchorX, AnchorY),
            Size = UDim2.fromOffset(1, Length),
            BackgroundColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
        }, Frame)

        table.insert(Brackets, Horizontal)
        table.insert(Brackets, Vertical)
    end

    Bracket(0, 0)
    Bracket(1, 0)
    Bracket(0, 1)
    Bracket(1, 1)

    local LogoY = 0.40

    local LogoGlow = New("ImageLabel", {
        Name = "LogoGlow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, LogoY),
        Size = UDim2.fromOffset(150, 150),
        BackgroundTransparency = 1,
        Image = Config.Logo,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10,
    }, Background)

    local Logo = New("ImageLabel", {
        Name = "Logo",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, LogoY),
        Size = UDim2.fromOffset(110, 110),
        BackgroundTransparency = 1,
        Image = Config.Logo,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 11,
    }, Background)

    local Star
    local StarIsImage = Config.Star ~= nil

    if StarIsImage then
        Star = New("ImageLabel", {
            Name = "Star",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.415, LogoY),
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1,
            Image = Config.Star,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 11,
        }, Background)
    else
        Star = Label(Background, {
            Name = "Star",
            Position = UDim2.fromScale(0.415, LogoY),
            Size = UDim2.fromOffset(60, 60),
            Text = "✦",
            TextSize = 12,
            TextColor3 = Color3.fromRGB(225, 225, 235),
            TextTransparency = 1,
            Font = Enum.Font.GothamBlack,
            ZIndex = 11,
        })
    end

    local Glyph
    local GlyphIsImage = Config.Glyph ~= nil

    if GlyphIsImage then
        Glyph = New("ImageLabel", {
            Name = "Glyph",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.585, LogoY),
            Size = UDim2.fromOffset(26, 26),
            BackgroundTransparency = 1,
            Image = Config.Glyph,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 11,
        }, Background)
    else
        Glyph = Label(Background, {
            Name = "Glyph",
            Position = UDim2.fromScale(0.585, LogoY),
            Size = UDim2.fromOffset(30, 30),
            Text = "$",
            TextSize = 20,
            TextColor3 = Color3.fromRGB(200, 200, 205),
            TextTransparency = 1,
            Font = Enum.Font.GothamBlack,
            ZIndex = 11,
        })
    end

    local LineY = 0.58

    local LeftLine = New("Frame", {
        Name = "LeftLine",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(0.395, LineY),
        Size = UDim2.fromOffset(0, 1),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Background)

    local RightLine = New("Frame", {
        Name = "RightLine",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.605, LineY),
        Size = UDim2.fromOffset(0, 1),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Background)

    local Title = Label(Background, {
        Name = "Title",
        Position = UDim2.fromScale(0.5, 0.65),
        Size = UDim2.fromOffset(500, 45),
        Text = "",
        TextSize = 32,
        TextColor3 = Color3.fromRGB(250, 250, 250),
        Font = Enum.Font.GothamBlack,
        ZIndex = 12,
    })

    local Subtitle = Label(Background, {
        Name = "Subtitle",
        Position = UDim2.fromScale(0.5, 0.705),
        Size = UDim2.fromOffset(500, 20),
        Text = "",
        TextSize = 10,
        TextColor3 = Color3.fromRGB(130, 130, 130),
        Font = Enum.Font.Gotham,
        ZIndex = 12,
    })

    local BarBackground = New("Frame", {
        Name = "ProgressBackground",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.776),
        Size = UDim2.fromOffset(200, 2),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 12,
    }, Background)

    Corner(BarBackground, 999)

    local Bar = New("Frame", {
        Name = "Progress",
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 13,
    }, BarBackground)

    Corner(Bar, 999)

    local Percentage = Label(Background, {
        Name = "Percentage",
        Position = UDim2.fromScale(0.5, 0.83),
        Size = UDim2.fromOffset(200, 16),
        Text = "0%",
        TextSize = 9,
        TextColor3 = Color3.fromRGB(110, 110, 110),
        TextTransparency = 1,
        ZIndex = 12,
    })

    local SkipHint = Label(Background, {
        Name = "SkipHint",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -52),
        Size = UDim2.fromOffset(220, 14),
        Text = "Press SPACE or click to skip",
        TextSize = 9,
        TextColor3 = Color3.fromRGB(95, 95, 95),
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 20,
    })

    local SkipButton = New("TextButton", {
        Name = "Skip",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -20),
        Size = UDim2.fromOffset(74, 26),
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "SKIP",
        TextColor3 = Color3.fromRGB(245, 245, 245),
        TextTransparency = 1,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 21,
    }, Background)

    Corner(SkipButton, 6)

    Object.Logo = Logo
    Object.LogoGlow = LogoGlow
    Object.Title = Title
    Object.Subtitle = Subtitle
    Object.Percentage = Percentage
    Object.Bar = Bar
    Object.BarBackground = BarBackground
    Object.SkipButton = SkipButton

    local Base = Object.StartTime

    table.insert(Connections, RunService.RenderStepped:Connect(function()
        if Object.Closed then
            return
        end

        local Time = os.clock() - Base

        local Cycle = (Time * 0.42) % 1.45

        Band.Position = UDim2.fromScale(0, Cycle - 0.2)

        if Object.IntroDone and not Object.Finishing then
            LogoGlow.ImageTransparency =
                0.9 + math.sin(Time * 2.5) * 0.03

            LogoGlow.Rotation = math.sin(Time * 0.45) * 2
        end

        if Object.IntroDone and not Object.Finishing and math.random() < 0.03 then
            Logo.Position = UDim2.new(
                0.5, math.random(-2, 2),
                LogoY, math.random(-1, 1)
            )
        else
            Logo.Position = UDim2.fromScale(0.5, LogoY)
        end
    end))

    function Object:Update(Current, StatusText, DetailText)
        if self.Closed then
            return
        end

        self.Current = math.clamp(tonumber(Current) or 0, 0, self.Total)

        local Progress = self.Current / self.Total

        self.Progress = Progress

        Percentage.Text = tostring(math.floor(Progress * 100)) .. "%"

        Tween(Bar, 0.3, {
            Size = UDim2.fromScale(Progress, 1)
        })
    end

    function Object:Finish(Instant)
        if self.Closed or self.Finishing then
            return
        end

        self.Finishing = true

        if not Instant then
            local Remaining =
                self.MinimumDuration - (os.clock() - self.StartTime)

            if Remaining > 0 then
                task.wait(Remaining)
            end
        end

        if self.Closed then
            return
        end

        self:Update(self.Total)

        task.wait(Instant and 0.1 or 0.3)

        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end

        table.clear(Connections)

        FadeOutGui(ScreenGui, 0.6)

        task.wait(0.7)

        self.Closed = true

        ScreenGui:Destroy()
    end

    function Object:Destroy()
        if self.Closed then
            return
        end

        self.Closed = true
        self.Finishing = true

        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end

        table.clear(Connections)

        ScreenGui:Destroy()
    end

    local function Skip()
        if Object.Closed or Object.Finishing then
            return
        end

        task.spawn(function()
            Object:Finish(true)
        end)
    end

    table.insert(Connections, SkipButton.MouseButton1Click:Connect(Skip))

    table.insert(Connections, UserInputService.InputBegan:Connect(function(Input, Processed)
        if Input.KeyCode == Enum.KeyCode.Space and not Processed then
            Skip()
        end
    end))

    table.insert(Connections, SkipButton.MouseEnter:Connect(function()
        Tween(SkipButton, 0.2, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) })
    end))

    table.insert(Connections, SkipButton.MouseLeave:Connect(function()
        Tween(SkipButton, 0.2, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) })
    end))

    local function Type(TextLabel, Text, Delay)
        for Index = 1, #Text do
            if Object.Closed then
                return
            end

            TextLabel.Text = string.sub(Text, 1, Index)

            task.wait(Delay)
        end
    end

    task.spawn(function()
        Tween(Logo, 0.8, { ImageTransparency = 0 })
        Tween(LogoGlow, 1, { ImageTransparency = 0.9 })

        task.wait(0.45)

        if Object.Closed then return end

        if StarIsImage then
            Tween(Star, 0.6, {
                Size = UDim2.fromOffset(40, 40),
                ImageTransparency = 0,
                Rotation = 0,
            }, Enum.EasingStyle.Back)
        else
            Star.Rotation = -90

            Tween(Star, 0.6, {
                TextSize = 46,
                TextTransparency = 0,
                Rotation = 0,
            }, Enum.EasingStyle.Back)
        end

        task.wait(0.25)

        if Object.Closed then return end

        if GlyphIsImage then
            Tween(Glyph, 0.5, { ImageTransparency = 0 })
        else
            Tween(Glyph, 0.5, { TextTransparency = 0 })
        end

        task.wait(0.3)

        if Object.Closed then return end

        Tween(LeftLine, 0.6, { Size = UDim2.fromOffset(100, 1) })
        Tween(RightLine, 0.6, { Size = UDim2.fromOffset(100, 1) })

        for _, Piece in ipairs(Brackets) do
            Tween(Piece, 0.6, { BackgroundTransparency = 0.4 })
        end

        task.wait(0.35)

        if Object.Closed then return end

        Type(Title, Config.Title, 0.07)

        task.wait(0.1)

        Type(Subtitle, Config.Subtitle, 0.025)

        if Object.Closed then return end

        Tween(BarBackground, 0.5, { BackgroundTransparency = 0.2 })
        Tween(Bar, 0.5, { BackgroundTransparency = 0 })
        Tween(Percentage, 0.5, { TextTransparency = 0 })

        Object.IntroDone = true

        task.wait(0.8)

        if Object.Closed then return end

        Tween(SkipHint, 0.6, { TextTransparency = 0 })

        Tween(SkipButton, 0.6, {
            BackgroundTransparency = 0.1,
            TextTransparency = 0,
        })
    end)

    Object:Update(0)

    return Object
end

return Loading