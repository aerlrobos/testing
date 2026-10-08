local Players = game:GetService("Players")

local Theme = {}

local ROMAN_REIGNS_USERS = {
    [572117566] = true
}

local ROMAN_REIGNS_IMAGE =
    "rbxassetid://102159565539986"

local function IsRomanReignsUser()
    local Player = Players.LocalPlayer

    if not Player then
        return false
    end

    return ROMAN_REIGNS_USERS[Player.UserId] == true
end

Theme.BuiltIn = {

    ["Default"] = {
        Background = Color3.fromRGB(35, 35, 35),
        Secondary = Color3.fromRGB(55, 55, 55),
        Element = Color3.fromRGB(75, 75, 75),
        Hover = Color3.fromRGB(100, 100, 100),
        Pressed = Color3.fromRGB(120, 120, 120),

        Border = Color3.fromRGB(140, 140, 140),
        BorderHover = Color3.fromRGB(175, 175, 175),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(210, 210, 210),
        MutedText = Color3.fromRGB(150, 150, 150),

        Accent = Color3.fromRGB(255, 255, 255),
        AccentDark = Color3.fromRGB(190, 190, 190),
        AccentHover = Color3.fromRGB(255, 255, 255),

        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(235, 180, 70),
        Error = Color3.fromRGB(220, 70, 70),
        Info = Color3.fromRGB(80, 160, 220),

        Tab = Color3.fromRGB(45, 45, 45),
        TabHover = Color3.fromRGB(70, 70, 70),
        TabSelected = Color3.fromRGB(90, 90, 90),

        Button = Color3.fromRGB(75, 75, 75),
        ButtonHover = Color3.fromRGB(100, 100, 100),
        ButtonPressed = Color3.fromRGB(120, 120, 120),

        ToggleOff = Color3.fromRGB(60, 60, 60),
        ToggleOn = Color3.fromRGB(255, 255, 255),
        ToggleCircle = Color3.fromRGB(35, 35, 35),

        Input = Color3.fromRGB(45, 45, 45),
        InputHover = Color3.fromRGB(65, 65, 65),
        InputFocus = Color3.fromRGB(255, 255, 255),

        Dropdown = Color3.fromRGB(45, 45, 45),
        DropdownHover = Color3.fromRGB(65, 65, 65),
        DropdownSelected = Color3.fromRGB(255, 255, 255),

        SliderBackground = Color3.fromRGB(55, 55, 55),
        SliderFill = Color3.fromRGB(255, 255, 255),
        SliderKnob = Color3.fromRGB(240, 240, 240),

        PopupBackground = Color3.fromRGB(30, 30, 30),
        PopupBorder = Color3.fromRGB(100, 100, 100),

        NotificationBackground = Color3.fromRGB(40, 40, 40),
        NotificationBorder = Color3.fromRGB(255, 255, 255),

        Scrollbar = Color3.fromRGB(255, 255, 255),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(35, 35, 35),
                Color3.fromRGB(55, 55, 55),
                Color3.fromRGB(80, 80, 80)
            },

            TopBar = {
                Color3.fromRGB(40, 40, 40),
                Color3.fromRGB(70, 70, 70),
                Color3.fromRGB(100, 100, 100)
            },

            Sidebar = {
                Color3.fromRGB(30, 30, 30),
                Color3.fromRGB(55, 55, 55)
            },

            Element = {
                Color3.fromRGB(65, 65, 65),
                Color3.fromRGB(100, 100, 100)
            },

            Accent = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(200, 200, 200)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Red"] = {
        Background = Color3.fromRGB(75, 10, 15),
        Secondary = Color3.fromRGB(115, 15, 22),
        Element = Color3.fromRGB(150, 22, 30),
        Hover = Color3.fromRGB(190, 30, 40),
        Pressed = Color3.fromRGB(210, 40, 50),

        Border = Color3.fromRGB(230, 55, 65),
        BorderHover = Color3.fromRGB(255, 80, 90),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(235, 205, 205),
        MutedText = Color3.fromRGB(180, 130, 135),

        Accent = Color3.fromRGB(255, 65, 75),
        AccentDark = Color3.fromRGB(200, 30, 40),
        AccentHover = Color3.fromRGB(255, 100, 110),

        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(235, 180, 70),
        Error = Color3.fromRGB(255, 70, 70),
        Info = Color3.fromRGB(80, 160, 220),

        Tab = Color3.fromRGB(95, 12, 18),
        TabHover = Color3.fromRGB(140, 20, 28),
        TabSelected = Color3.fromRGB(180, 28, 38),

        Button = Color3.fromRGB(150, 22, 30),
        ButtonHover = Color3.fromRGB(190, 30, 40),
        ButtonPressed = Color3.fromRGB(210, 40, 50),

        ToggleOff = Color3.fromRGB(80, 20, 25),
        ToggleOn = Color3.fromRGB(255, 65, 75),
        ToggleCircle = Color3.fromRGB(255, 235, 235),

        Input = Color3.fromRGB(55, 8, 12),
        InputHover = Color3.fromRGB(100, 15, 20),
        InputFocus = Color3.fromRGB(255, 65, 75),

        Dropdown = Color3.fromRGB(55, 8, 12),
        DropdownHover = Color3.fromRGB(110, 18, 25),
        DropdownSelected = Color3.fromRGB(255, 65, 75),

        SliderBackground = Color3.fromRGB(85, 15, 20),
        SliderFill = Color3.fromRGB(255, 65, 75),
        SliderKnob = Color3.fromRGB(255, 100, 110),

        PopupBackground = Color3.fromRGB(50, 5, 10),
        PopupBorder = Color3.fromRGB(230, 55, 65),

        NotificationBackground = Color3.fromRGB(70, 10, 15),
        NotificationBorder = Color3.fromRGB(255, 65, 75),

        Scrollbar = Color3.fromRGB(255, 65, 75),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(75, 10, 15),
                Color3.fromRGB(130, 15, 22),
                Color3.fromRGB(190, 30, 40)
            },

            TopBar = {
                Color3.fromRGB(100, 10, 15),
                Color3.fromRGB(175, 20, 30),
                Color3.fromRGB(230, 55, 65)
            },

            Sidebar = {
                Color3.fromRGB(55, 5, 10),
                Color3.fromRGB(110, 15, 20)
            },

            Element = {
                Color3.fromRGB(115, 15, 22),
                Color3.fromRGB(190, 30, 40)
            },

            Accent = {
                Color3.fromRGB(255, 65, 75),
                Color3.fromRGB(255, 130, 140)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Green"] = {
        Background = Color3.fromRGB(8, 70, 30),
        Secondary = Color3.fromRGB(10, 110, 45),
        Element = Color3.fromRGB(15, 145, 58),
        Hover = Color3.fromRGB(25, 185, 75),
        Pressed = Color3.fromRGB(35, 205, 90),

        Border = Color3.fromRGB(55, 225, 105),
        BorderHover = Color3.fromRGB(85, 255, 135),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(205, 235, 215),
        MutedText = Color3.fromRGB(135, 180, 150),

        Accent = Color3.fromRGB(70, 255, 120),
        AccentDark = Color3.fromRGB(30, 195, 75),
        AccentHover = Color3.fromRGB(105, 255, 145),

        Success = Color3.fromRGB(80, 255, 130),
        Warning = Color3.fromRGB(235, 180, 70),
        Error = Color3.fromRGB(220, 70, 70),
        Info = Color3.fromRGB(80, 170, 220),

        Tab = Color3.fromRGB(8, 85, 35),
        TabHover = Color3.fromRGB(15, 130, 50),
        TabSelected = Color3.fromRGB(25, 175, 70),

        Button = Color3.fromRGB(15, 145, 58),
        ButtonHover = Color3.fromRGB(25, 185, 75),
        ButtonPressed = Color3.fromRGB(35, 205, 90),

        ToggleOff = Color3.fromRGB(10, 60, 30),
        ToggleOn = Color3.fromRGB(70, 255, 120),
        ToggleCircle = Color3.fromRGB(225, 255, 235),

        Input = Color3.fromRGB(5, 40, 20),
        InputHover = Color3.fromRGB(10, 80, 35),
        InputFocus = Color3.fromRGB(70, 255, 120),

        Dropdown = Color3.fromRGB(5, 40, 20),
        DropdownHover = Color3.fromRGB(10, 90, 38),
        DropdownSelected = Color3.fromRGB(70, 255, 120),

        SliderBackground = Color3.fromRGB(10, 80, 35),
        SliderFill = Color3.fromRGB(70, 255, 120),
        SliderKnob = Color3.fromRGB(120, 255, 155),

        PopupBackground = Color3.fromRGB(5, 45, 22),
        PopupBorder = Color3.fromRGB(55, 225, 105),

        NotificationBackground = Color3.fromRGB(7, 60, 28),
        NotificationBorder = Color3.fromRGB(70, 255, 120),

        Scrollbar = Color3.fromRGB(70, 255, 120),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(8, 70, 30),
                Color3.fromRGB(15, 120, 48),
                Color3.fromRGB(25, 185, 75)
            },

            TopBar = {
                Color3.fromRGB(10, 90, 35),
                Color3.fromRGB(25, 160, 65),
                Color3.fromRGB(55, 225, 105)
            },

            Sidebar = {
                Color3.fromRGB(5, 55, 25),
                Color3.fromRGB(10, 100, 40)
            },

            Element = {
                Color3.fromRGB(10, 110, 45),
                Color3.fromRGB(25, 185, 75)
            },

            Accent = {
                Color3.fromRGB(70, 255, 120),
                Color3.fromRGB(150, 255, 180)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Blue"] = {
        Background = Color3.fromRGB(8, 45, 100),
        Secondary = Color3.fromRGB(10, 70, 145),
        Element = Color3.fromRGB(15, 95, 185),
        Hover = Color3.fromRGB(30, 125, 220),
        Pressed = Color3.fromRGB(45, 145, 235),

        Border = Color3.fromRGB(70, 165, 255),
        BorderHover = Color3.fromRGB(105, 195, 255),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(205, 225, 245),
        MutedText = Color3.fromRGB(135, 170, 210),

        Accent = Color3.fromRGB(75, 155, 255),
        AccentDark = Color3.fromRGB(35, 105, 205),
        AccentHover = Color3.fromRGB(110, 185, 255),

        Success = Color3.fromRGB(80, 210, 130),
        Warning = Color3.fromRGB(235, 180, 70),
        Error = Color3.fromRGB(220, 70, 70),
        Info = Color3.fromRGB(75, 170, 255),

        Tab = Color3.fromRGB(8, 55, 115),
        TabHover = Color3.fromRGB(15, 90, 165),
        TabSelected = Color3.fromRGB(30, 120, 210),

        Button = Color3.fromRGB(15, 95, 185),
        ButtonHover = Color3.fromRGB(30, 125, 220),
        ButtonPressed = Color3.fromRGB(45, 145, 235),

        ToggleOff = Color3.fromRGB(10, 55, 110),
        ToggleOn = Color3.fromRGB(75, 155, 255),
        ToggleCircle = Color3.fromRGB(225, 240, 255),

        Input = Color3.fromRGB(5, 30, 70),
        InputHover = Color3.fromRGB(10, 65, 125),
        InputFocus = Color3.fromRGB(75, 155, 255),

        Dropdown = Color3.fromRGB(5, 30, 70),
        DropdownHover = Color3.fromRGB(10, 70, 140),
        DropdownSelected = Color3.fromRGB(75, 155, 255),

        SliderBackground = Color3.fromRGB(10, 65, 130),
        SliderFill = Color3.fromRGB(75, 155, 255),
        SliderKnob = Color3.fromRGB(115, 190, 255),

        PopupBackground = Color3.fromRGB(5, 35, 80),
        PopupBorder = Color3.fromRGB(70, 165, 255),

        NotificationBackground = Color3.fromRGB(7, 45, 95),
        NotificationBorder = Color3.fromRGB(75, 155, 255),

        Scrollbar = Color3.fromRGB(75, 155, 255),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(8, 45, 100),
                Color3.fromRGB(15, 80, 160),
                Color3.fromRGB(30, 125, 220)
            },

            TopBar = {
                Color3.fromRGB(8, 55, 120),
                Color3.fromRGB(25, 105, 190),
                Color3.fromRGB(70, 165, 255)
            },

            Sidebar = {
                Color3.fromRGB(5, 35, 80),
                Color3.fromRGB(10, 75, 145)
            },

            Element = {
                Color3.fromRGB(10, 70, 145),
                Color3.fromRGB(30, 125, 220)
            },

            Accent = {
                Color3.fromRGB(75, 155, 255),
                Color3.fromRGB(130, 200, 255)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Purple"] = {
        Background = Color3.fromRGB(55, 10, 95),
        Secondary = Color3.fromRGB(80, 15, 135),
        Element = Color3.fromRGB(110, 25, 175),
        Hover = Color3.fromRGB(145, 40, 220),
        Pressed = Color3.fromRGB(165, 55, 235),

        Border = Color3.fromRGB(190, 75, 255),
        BorderHover = Color3.fromRGB(220, 110, 255),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(225, 205, 240),
        MutedText = Color3.fromRGB(170, 130, 195),

        Accent = Color3.fromRGB(190, 90, 255),
        AccentDark = Color3.fromRGB(130, 45, 200),
        AccentHover = Color3.fromRGB(215, 125, 255),

        Success = Color3.fromRGB(80, 210, 130),
        Warning = Color3.fromRGB(235, 180, 70),
        Error = Color3.fromRGB(220, 70, 70),
        Info = Color3.fromRGB(100, 160, 230),

        Tab = Color3.fromRGB(65, 10, 110),
        TabHover = Color3.fromRGB(100, 20, 160),
        TabSelected = Color3.fromRGB(135, 35, 210),

        Button = Color3.fromRGB(110, 25, 175),
        ButtonHover = Color3.fromRGB(145, 40, 220),
        ButtonPressed = Color3.fromRGB(165, 55, 235),

        ToggleOff = Color3.fromRGB(60, 15, 100),
        ToggleOn = Color3.fromRGB(190, 90, 255),
        ToggleCircle = Color3.fromRGB(245, 230, 255),

        Input = Color3.fromRGB(35, 5, 65),
        InputHover = Color3.fromRGB(80, 15, 125),
        InputFocus = Color3.fromRGB(190, 90, 255),

        Dropdown = Color3.fromRGB(35, 5, 65),
        DropdownHover = Color3.fromRGB(90, 20, 145),
        DropdownSelected = Color3.fromRGB(190, 90, 255),

        SliderBackground = Color3.fromRGB(80, 20, 130),
        SliderFill = Color3.fromRGB(190, 90, 255),
        SliderKnob = Color3.fromRGB(220, 140, 255),

        PopupBackground = Color3.fromRGB(40, 5, 70),
        PopupBorder = Color3.fromRGB(190, 75, 255),

        NotificationBackground = Color3.fromRGB(50, 8, 85),
        NotificationBorder = Color3.fromRGB(190, 90, 255),

        Scrollbar = Color3.fromRGB(190, 90, 255),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(55, 10, 95),
                Color3.fromRGB(100, 20, 155),
                Color3.fromRGB(145, 40, 220)
            },

            TopBar = {
                Color3.fromRGB(70, 10, 120),
                Color3.fromRGB(130, 30, 190),
                Color3.fromRGB(190, 75, 255)
            },

            Sidebar = {
                Color3.fromRGB(35, 5, 65),
                Color3.fromRGB(80, 15, 125)
            },

            Element = {
                Color3.fromRGB(80, 15, 135),
                Color3.fromRGB(145, 40, 220)
            },

            Accent = {
                Color3.fromRGB(190, 90, 255),
                Color3.fromRGB(235, 160, 255)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Orange"] = {
        Background = Color3.fromRGB(100, 40, 5),
        Secondary = Color3.fromRGB(145, 60, 8),
        Element = Color3.fromRGB(185, 80, 10),
        Hover = Color3.fromRGB(220, 105, 15),
        Pressed = Color3.fromRGB(235, 120, 20),

        Border = Color3.fromRGB(255, 145, 35),
        BorderHover = Color3.fromRGB(255, 180, 70),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(245, 220, 190),
        MutedText = Color3.fromRGB(190, 145, 105),

        Accent = Color3.fromRGB(255, 155, 50),
        AccentDark = Color3.fromRGB(205, 100, 25),
        AccentHover = Color3.fromRGB(255, 185, 90),

        Success = Color3.fromRGB(80, 210, 130),
        Warning = Color3.fromRGB(255, 185, 60),
        Error = Color3.fromRGB(220, 70, 70),
        Info = Color3.fromRGB(80, 160, 220),

        Tab = Color3.fromRGB(110, 45, 5),
        TabHover = Color3.fromRGB(155, 70, 10),
        TabSelected = Color3.fromRGB(200, 95, 15),

        Button = Color3.fromRGB(185, 80, 10),
        ButtonHover = Color3.fromRGB(220, 105, 15),
        ButtonPressed = Color3.fromRGB(235, 120, 20),

        ToggleOff = Color3.fromRGB(90, 35, 5),
        ToggleOn = Color3.fromRGB(255, 155, 50),
        ToggleCircle = Color3.fromRGB(255, 240, 220),

        Input = Color3.fromRGB(55, 20, 3),
        InputHover = Color3.fromRGB(105, 40, 5),
        InputFocus = Color3.fromRGB(255, 155, 50),

        Dropdown = Color3.fromRGB(55, 20, 3),
        DropdownHover = Color3.fromRGB(115, 45, 5),
        DropdownSelected = Color3.fromRGB(255, 155, 50),

        SliderBackground = Color3.fromRGB(100, 40, 5),
        SliderFill = Color3.fromRGB(255, 155, 50),
        SliderKnob = Color3.fromRGB(255, 195, 100),

        PopupBackground = Color3.fromRGB(60, 20, 3),
        PopupBorder = Color3.fromRGB(255, 145, 35),

        NotificationBackground = Color3.fromRGB(85, 30, 5),
        NotificationBorder = Color3.fromRGB(255, 155, 50),

        Scrollbar = Color3.fromRGB(255, 155, 50),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(100, 40, 5),
                Color3.fromRGB(165, 70, 8),
                Color3.fromRGB(220, 105, 15)
            },

            TopBar = {
                Color3.fromRGB(110, 40, 5),
                Color3.fromRGB(190, 80, 10),
                Color3.fromRGB(255, 145, 35)
            },

            Sidebar = {
                Color3.fromRGB(60, 20, 3),
                Color3.fromRGB(120, 45, 5)
            },

            Element = {
                Color3.fromRGB(145, 60, 8),
                Color3.fromRGB(220, 105, 15)
            },

            Accent = {
                Color3.fromRGB(255, 155, 50),
                Color3.fromRGB(255, 205, 120)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Halloween"] = {
        Background = Color3.fromRGB(24, 5, 35),
        Secondary = Color3.fromRGB(45, 8, 65),
        Element = Color3.fromRGB(70, 12, 95),
        Hover = Color3.fromRGB(105, 20, 135),
        Pressed = Color3.fromRGB(130, 28, 160),

        Border = Color3.fromRGB(190, 55, 220),
        BorderHover = Color3.fromRGB(235, 95, 255),

        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(235, 205, 245),
        MutedText = Color3.fromRGB(170, 125, 185),

        Accent = Color3.fromRGB(255, 115, 0),
        AccentDark = Color3.fromRGB(190, 65, 0),
        AccentHover = Color3.fromRGB(255, 160, 35),

        Success = Color3.fromRGB(90, 220, 125),
        Warning = Color3.fromRGB(255, 170, 50),
        Error = Color3.fromRGB(240, 60, 60),
        Info = Color3.fromRGB(150, 100, 255),

        Tab = Color3.fromRGB(35, 5, 50),
        TabHover = Color3.fromRGB(65, 10, 90),
        TabSelected = Color3.fromRGB(100, 20, 125),

        Button = Color3.fromRGB(70, 12, 95),
        ButtonHover = Color3.fromRGB(105, 20, 135),
        ButtonPressed = Color3.fromRGB(130, 28, 160),

        ToggleOff = Color3.fromRGB(40, 8, 55),
        ToggleOn = Color3.fromRGB(255, 115, 0),
        ToggleCircle = Color3.fromRGB(255, 235, 205),

        Input = Color3.fromRGB(20, 3, 30),
        InputHover = Color3.fromRGB(55, 8, 75),
        InputFocus = Color3.fromRGB(255, 115, 0),

        Dropdown = Color3.fromRGB(20, 3, 30),
        DropdownHover = Color3.fromRGB(60, 10, 80),
        DropdownSelected = Color3.fromRGB(255, 115, 0),

        SliderBackground = Color3.fromRGB(55, 8, 75),
        SliderFill = Color3.fromRGB(255, 115, 0),
        SliderKnob = Color3.fromRGB(255, 175, 60),

        PopupBackground = Color3.fromRGB(25, 4, 38),
        PopupBorder = Color3.fromRGB(190, 55, 220),

        NotificationBackground = Color3.fromRGB(35, 5, 50),
        NotificationBorder = Color3.fromRGB(255, 115, 0),

        Scrollbar = Color3.fromRGB(255, 115, 0),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(25, 4, 40),
                Color3.fromRGB(75, 10, 105),
                Color3.fromRGB(145, 35, 145)
            },

            TopBar = {
                Color3.fromRGB(35, 5, 55),
                Color3.fromRGB(110, 15, 125),
                Color3.fromRGB(255, 115, 0)
            },

            Sidebar = {
                Color3.fromRGB(20, 3, 35),
                Color3.fromRGB(65, 8, 85)
            },

            Element = {
                Color3.fromRGB(60, 8, 85),
                Color3.fromRGB(175, 35, 150),
                Color3.fromRGB(255, 115, 0)
            },

            Accent = {
                Color3.fromRGB(255, 115, 0),
                Color3.fromRGB(255, 180, 30),
                Color3.fromRGB(170, 35, 210)
            }
        },

        Artwork = {
            Enabled = false,
            Image = "",
            ImageTransparency = 1,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    },

    ["Roman Reigns"] = {
        Background = Color3.fromRGB(5, 9, 10),
        Secondary = Color3.fromRGB(8, 25, 24),
        Element = Color3.fromRGB(12, 47, 43),
        Hover = Color3.fromRGB(20, 70, 64),
        Pressed = Color3.fromRGB(27, 88, 79),

        Border = Color3.fromRGB(52, 110, 98),
        BorderHover = Color3.fromRGB(82, 145, 125),

        Text = Color3.fromRGB(245, 245, 240),
        SubText = Color3.fromRGB(190, 202, 197),
        MutedText = Color3.fromRGB(125, 145, 140),

        Accent = Color3.fromRGB(215, 178, 75),
        AccentDark = Color3.fromRGB(150, 115, 38),
        AccentHover = Color3.fromRGB(240, 205, 105),
        AccentText = Color3.fromRGB(20, 18, 10),

        Success = Color3.fromRGB(80, 190, 125),
        Warning = Color3.fromRGB(230, 175, 60),
        Error = Color3.fromRGB(190, 55, 50),
        Info = Color3.fromRGB(70, 145, 160),

        Tab = Color3.fromRGB(7, 27, 26),
        TabHover = Color3.fromRGB(16, 58, 53),
        TabSelected = Color3.fromRGB(28, 82, 73),

        Button = Color3.fromRGB(12, 47, 43),
        ButtonHover = Color3.fromRGB(20, 70, 64),
        ButtonPressed = Color3.fromRGB(27, 88, 79),

        ToggleOff = Color3.fromRGB(8, 35, 33),
        ToggleOn = Color3.fromRGB(215, 178, 75),
        ToggleCircle = Color3.fromRGB(245, 235, 200),

        Input = Color3.fromRGB(4, 17, 18),
        InputHover = Color3.fromRGB(10, 40, 38),
        InputFocus = Color3.fromRGB(215, 178, 75),

        Dropdown = Color3.fromRGB(4, 17, 18),
        DropdownHover = Color3.fromRGB(12, 48, 45),
        DropdownSelected = Color3.fromRGB(215, 178, 75),

        SliderBackground = Color3.fromRGB(10, 38, 36),
        SliderFill = Color3.fromRGB(215, 178, 75),
        SliderKnob = Color3.fromRGB(240, 205, 105),

        PopupBackground = Color3.fromRGB(5, 14, 15),
        PopupBorder = Color3.fromRGB(52, 110, 98),

        NotificationBackground = Color3.fromRGB(7, 22, 22),
        NotificationBorder = Color3.fromRGB(215, 178, 75),

        Scrollbar = Color3.fromRGB(215, 178, 75),

        Transparency = {
            Main = 0,
            Secondary = 0,
            Element = 0,
            Popup = 0,
            Notification = 0
        },

        Stroke = {
            Enabled = true,
            Thickness = 1.5,
            Transparency = 0
        },

        Corners = {
            Main = 12,
            Element = 8,
            Button = 8,
            Input = 8,
            Dropdown = 8,
            Popup = 12,
            Notification = 9
        },

        Effects = {
            Glow = true,
            Shadow = true,
            Gradient = true,
            AnimatedGradient = true
        },

        Gradients = {
            Main = {
                Color3.fromRGB(5, 14, 15),
                Color3.fromRGB(8, 35, 33),
                Color3.fromRGB(12, 60, 54)
            },

            TopBar = {
                Color3.fromRGB(5, 20, 20),
                Color3.fromRGB(15, 55, 50),
                Color3.fromRGB(215, 178, 75)
            },

            Sidebar = {
                Color3.fromRGB(4, 16, 17),
                Color3.fromRGB(8, 35, 33)
            },

            Element = {
                Color3.fromRGB(8, 35, 33),
                Color3.fromRGB(20, 70, 64),
                Color3.fromRGB(215, 178, 75)
            },

            Accent = {
                Color3.fromRGB(150, 115, 38),
                Color3.fromRGB(215, 178, 75),
                Color3.fromRGB(240, 205, 105)
            }
        },

        Artwork = {
            Enabled = true,
            Image = ROMAN_REIGNS_IMAGE,
            ImageTransparency = 0.35,
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(1, -315, 1, -315),
            ZIndex = 1
        }
    }
}

--// v1.0.2 - new themes (built from a small palette on top of Default)
local function DeepCopy(Value)
    if type(Value) ~= "table" then
        return Value
    end

    local Copy = {}

    for Key, Item in pairs(Value) do
        Copy[Key] = DeepCopy(Item)
    end

    return Copy
end

local function BuildTheme(P)
    local T = DeepCopy(Theme.BuiltIn.Default)

    T.Background = P.Background
    T.Secondary = P.Secondary
    T.Element = P.Element
    T.Hover = P.Hover
    T.Pressed = P.Pressed
    T.Border = P.Border
    T.BorderHover = P.BorderHover
    T.Text = P.Text
    T.SubText = P.SubText
    T.MutedText = P.MutedText
    T.Accent = P.Accent
    T.AccentDark = P.AccentDark
    T.AccentHover = P.Accent:Lerp(Color3.new(1, 1, 1), 0.2)
    T.AccentText = P.AccentText

    T.Tab = P.Secondary
    T.TabHover = P.Hover
    T.TabSelected = P.Element

    T.Button = P.Element
    T.ButtonHover = P.Hover
    T.ButtonPressed = P.Pressed

    T.ToggleOff = P.Pressed
    T.ToggleOn = P.Accent
    T.ToggleCircle = P.CircleColor or P.Text

    T.Input = P.Secondary
    T.InputHover = P.Hover
    T.InputFocus = P.Accent

    T.Dropdown = P.Secondary
    T.DropdownHover = P.Hover
    T.DropdownSelected = P.Accent

    T.SliderBackground = P.Pressed
    T.SliderFill = P.Accent
    T.SliderKnob = P.CircleColor or P.Text

    T.PopupBackground = P.Background
    T.PopupBorder = P.Border
    T.NotificationBackground = P.Secondary
    T.NotificationBorder = P.Accent
    T.Scrollbar = P.Accent

    T.Stroke = {
        Enabled = true,
        Thickness = 1,
        Transparency = 0.3
    }

    T.Corners = {
        Main = 14,
        Element = 10,
        Button = 10,
        Input = 10,
        Dropdown = 10,
        Popup = 14,
        Notification = 12
    }

    T.Gradients = {
        Main = {
            P.Background,
            P.Background:Lerp(P.Accent, 0.07)
        },
        TopBar = P.TopBarGradient or {
            P.Secondary,
            P.Secondary:Lerp(P.Accent, 0.16)
        },
        Sidebar = {
            P.Secondary,
            P.Background:Lerp(P.Secondary, 0.5)
        },
        Element = {
            P.Element,
            P.Element:Lerp(P.Accent, 0.08)
        },
        Accent = P.AccentGradient or {
            P.Accent,
            P.AccentDark
        }
    }

    return T
end

local function RGB(R, G, B)
    return Color3.fromRGB(R, G, B)
end

Theme.BuiltIn["Midnight"] = BuildTheme({
    Background = RGB(13, 17, 28),
    Secondary = RGB(18, 24, 40),
    Element = RGB(26, 34, 56),
    Hover = RGB(36, 47, 78),
    Pressed = RGB(46, 60, 98),
    Border = RGB(52, 66, 110),
    BorderHover = RGB(88, 112, 190),
    Text = RGB(240, 244, 255),
    SubText = RGB(170, 182, 214),
    MutedText = RGB(110, 122, 155),
    Accent = RGB(88, 134, 255),
    AccentDark = RGB(56, 96, 210),
    AccentText = RGB(255, 255, 255)
})

Theme.BuiltIn["Ocean"] = BuildTheme({
    Background = RGB(7, 25, 30),
    Secondary = RGB(10, 36, 43),
    Element = RGB(14, 50, 60),
    Hover = RGB(20, 68, 80),
    Pressed = RGB(26, 86, 100),
    Border = RGB(30, 110, 125),
    BorderHover = RGB(60, 170, 185),
    Text = RGB(232, 252, 255),
    SubText = RGB(160, 208, 215),
    MutedText = RGB(100, 150, 158),
    Accent = RGB(0, 210, 200),
    AccentDark = RGB(0, 150, 150),
    AccentText = RGB(4, 22, 26)
})

Theme.BuiltIn["Rose"] = BuildTheme({
    Background = RGB(28, 12, 20),
    Secondary = RGB(40, 17, 29),
    Element = RGB(58, 24, 42),
    Hover = RGB(80, 32, 58),
    Pressed = RGB(102, 40, 74),
    Border = RGB(130, 52, 92),
    BorderHover = RGB(210, 100, 150),
    Text = RGB(255, 240, 246),
    SubText = RGB(220, 170, 194),
    MutedText = RGB(160, 110, 130),
    Accent = RGB(255, 92, 160),
    AccentDark = RGB(205, 60, 120),
    AccentText = RGB(255, 255, 255)
})

Theme.BuiltIn["Mocha"] = BuildTheme({
    Background = RGB(24, 19, 16),
    Secondary = RGB(34, 27, 22),
    Element = RGB(48, 38, 31),
    Hover = RGB(66, 52, 42),
    Pressed = RGB(84, 67, 54),
    Border = RGB(110, 88, 70),
    BorderHover = RGB(180, 145, 110),
    Text = RGB(250, 243, 235),
    SubText = RGB(200, 184, 166),
    MutedText = RGB(140, 126, 112),
    Accent = RGB(222, 170, 110),
    AccentDark = RGB(176, 128, 76),
    AccentText = RGB(30, 22, 14)
})

Theme.BuiltIn["Aurora"] = BuildTheme({
    Background = RGB(10, 12, 24),
    Secondary = RGB(15, 18, 36),
    Element = RGB(22, 26, 52),
    Hover = RGB(32, 38, 76),
    Pressed = RGB(44, 52, 100),
    Border = RGB(60, 70, 140),
    BorderHover = RGB(110, 130, 255),
    Text = RGB(240, 244, 255),
    SubText = RGB(176, 186, 226),
    MutedText = RGB(112, 122, 166),
    Accent = RGB(120, 90, 255),
    AccentDark = RGB(80, 60, 200),
    AccentText = RGB(255, 255, 255),
    TopBarGradient = {
        RGB(15, 18, 36),
        RGB(40, 30, 90),
        RGB(15, 60, 90)
    },
    AccentGradient = {
        RGB(0, 220, 255),
        RGB(140, 80, 255),
        RGB(255, 80, 200)
    }
})

Theme.BuiltIn["Light"] = BuildTheme({
    Background = RGB(244, 246, 250),
    Secondary = RGB(232, 236, 244),
    Element = RGB(255, 255, 255),
    Hover = RGB(238, 242, 250),
    Pressed = RGB(224, 230, 242),
    Border = RGB(205, 212, 226),
    BorderHover = RGB(150, 165, 200),
    Text = RGB(24, 28, 40),
    SubText = RGB(84, 92, 112),
    MutedText = RGB(130, 138, 156),
    Accent = RGB(70, 110, 240),
    AccentDark = RGB(50, 84, 200),
    AccentText = RGB(255, 255, 255),
    CircleColor = RGB(255, 255, 255)
})

-- custom themes: missing keys fall back to Default
function Theme:Register(Name, Data)
    if type(Name) ~= "string" or type(Data) ~= "table" then
        return false
    end

    if Theme.IsPrivate(Name) then
        warn("[OTC Hub] This theme name is reserved")
        return false
    end

    local NewTheme = DeepCopy(Theme.BuiltIn.Default)

    for Key, Value in pairs(Data) do
        NewTheme[Key] = DeepCopy(Value)
    end

    Theme.BuiltIn[Name] = NewTheme

    return true
end

-- the "Roman Reigns" theme belongs to the owner only: for everybody else it is
-- removed from the theme table, so it cannot be listed, selected, saved or loaded
if not IsRomanReignsUser() then
    Theme.BuiltIn["Roman Reigns"] = nil
end

function Theme.IsPrivate(Name)
    return Name == "Roman Reigns"
end

function Theme.IsOwner()
    return IsRomanReignsUser()
end

function Theme.IsAllowed(Name)
    if not Theme.IsPrivate(Name) then
        return true
    end

    return IsRomanReignsUser()
end

function Theme.Get(Name, Player)
    if not Theme.IsAllowed(Name, Player) then
        return Theme.BuiltIn.Default
    end

    return Theme.BuiltIn[Name]
end

function Theme.List(Player)
    local List = {}

    for Name in pairs(Theme.BuiltIn) do
        if Theme.IsAllowed(Name, Player) then
            table.insert(List, Name)
        end
    end

    table.sort(List, function(A, B)
        if A == "Default" then
            return true
        end

        if B == "Default" then
            return false
        end

        return A < B
    end)

    return List
end

function Theme.Exists(Name, Player)
    return Theme.BuiltIn[Name] ~= nil
        and Theme.IsAllowed(Name, Player)
end

function Theme.GetNames(Player)
    return Theme.List(Player)
end

return Theme