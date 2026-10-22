-- OTC UI v1.0.5 - Test / showcase script
-- This exercises core WindUI elements and OTC UI's private Roman Reigns theme.
-- Run in an environment that supports loadstring and game:HttpGet.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local WINDUI_VERSION = "1.6.66"
local WINDUI_URL = "https://github.com/Footagesus/WindUI/releases/download/" .. WINDUI_VERSION .. "/main.lua"
local WindUI = loadstring(game:HttpGet(WINDUI_URL))()
local IsRomanAllowed = LocalPlayer ~= nil and LocalPlayer.UserId == 572117566
local RomanImage = "rbxassetid://102159565539986"

if IsRomanAllowed and WindUI.AddTheme then
    WindUI:AddTheme({
        Name = "Roman Reigns",
        Accent = Color3.fromHex("#C6A04A"),
        Dialog = Color3.fromHex("#17130C"),
        Outline = Color3.fromHex("#8C6A25"),
        Text = Color3.fromHex("#F7F0DF"),
        Placeholder = Color3.fromHex("#B6A57F"),
        Background = Color3.fromHex("#0B0B0D"),
        Button = Color3.fromHex("#6D5018"),
        Icon = Color3.fromHex("#E2BE63"),
        Toggle = Color3.fromHex("#C6A04A"),
        Slider = Color3.fromHex("#C6A04A"),
        Checkbox = Color3.fromHex("#C6A04A"),
        Primary = Color3.fromHex("#C6A04A"),
        PanelBackground = Color3.fromHex("#17130C"),
        PanelBackgroundTransparency = 0.18,
        ElementBackground = Color3.fromHex("#242019"),
        ElementBackgroundTransparency = 0,
    })
end

local ThemeValues = {}
for themeName in pairs(WindUI:GetThemes()) do
    table.insert(ThemeValues, themeName)
end
table.sort(ThemeValues)

local Window = WindUI:CreateWindow({
    Title = "OTC UI",
    Author = "Aerlro",
    Folder = "OTC_UI_1_0_5",
    Icon = "rbxassetid://95900623719417",
    Theme = IsRomanAllowed and "Roman Reigns" or "Dark",
    NewElements = true,
    HideSearchBar = false,
    Size = UDim2.fromOffset(760, 560),
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
    OpenButton = {
        Enabled = true,
        Title = "Open OTC UI",
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.8,
    },
})

pcall(function()
    Window:Tag({
        Title = "v1.0.5",
        Icon = "check-circle",
        Color = Color3.fromHex("#C6A04A"),
        Border = true,
    })
end)

local Main = Window:Tab({ Title = "Main", Icon = "house", IconShape = "Square" })
local Elements = Window:Tab({ Title = "Elements", Icon = "layout-grid", IconShape = "Square" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings", IconShape = "Square" })
local About = Window:Tab({ Title = "About", Icon = "info", IconShape = "Square" })

Main:Paragraph({
    Title = "OTC UI v1.0.5",
    Desc = "WindUI-powered interface with the OTC UI identity and theme integration.",
    Image = "rbxassetid://95900623719417",
    ImageSize = 48,
})
Main:Button({
    Title = "Test Notification",
    Desc = "Verify notification support.",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({ Title = "OTC UI", Content = "Notifications are working.", Duration = 3, Icon = "check-circle" })
    end,
})
Main:Button({
    Title = "Test Popup",
    Desc = "Verify popup and button callbacks.",
    Icon = "message-square",
    Callback = function()
        WindUI:Popup({
            Title = "OTC UI Popup",
            Icon = "shield-check",
            Content = "The popup system is working.",
            Buttons = {
                { Title = "OK", Variant = "Primary", Callback = function() print("[OTC UI] Popup confirmed") end },
                { Title = "Cancel", Variant = "Secondary" },
            },
        })
    end,
})

Elements:Section({ Title = "Element Showcase", Desc = "These controls test the upstream WindUI element implementations." })
Elements:Button({ Title = "Button", Desc = "Click to print a test message.", Icon = "mouse-pointer-click", Callback = function() print("[OTC UI] Button callback OK") end })
Elements:Toggle({ Title = "Toggle", Desc = "Test toggle state and callback.", Value = false, Callback = function(value) print("[OTC UI] Toggle:", value) end })
Elements:Slider({ Title = "Slider", Desc = "Test slider movement.", Step = 1, Value = { Min = 0, Max = 100, Default = 35 }, Callback = function(value) print("[OTC UI] Slider:", value) end })
Elements:Dropdown({ Title = "Dropdown", Desc = "Choose a sample value.", Values = { "Alpha", "Bravo", "Charlie" }, Value = "Alpha", Callback = function(value) print("[OTC UI] Dropdown:", value) end })
Elements:Dropdown({ Title = "Multi Dropdown", Desc = "Choose multiple sample values.", Values = { "Alpha", "Bravo", "Charlie" }, Value = { "Alpha" }, Multi = true, Callback = function(value) print("[OTC UI] Multi Dropdown:", value) end })
Elements:Input({ Title = "Input", Desc = "Type a test value.", Placeholder = "Write here...", Callback = function(value) print("[OTC UI] Input:", value) end })
Elements:Colorpicker({ Title = "Color Picker", Desc = "Test color selection.", Default = Color3.fromHex("#C6A04A"), Callback = function(value) print("[OTC UI] Color:", value) end })
Elements:Keybind({ Title = "Keybind", Desc = "Press a key to test the callback.", Value = "G", Callback = function(value) print("[OTC UI] Keybind:", value) end })

Settings:Section({ Title = "Appearance", Desc = "Switch between built-in themes and the private Roman Reigns theme." })
Settings:Dropdown({
    Title = "Theme",
    Desc = IsRomanAllowed and "Roman Reigns is enabled for this account." or "Roman Reigns theme is private.",
    Values = ThemeValues,
    Value = IsRomanAllowed and "Roman Reigns" or "Dark",
    Callback = function(value)
        if value == "Roman Reigns" and not IsRomanAllowed then
            WindUI:Notify({ Title = "Private Theme", Content = "Roman Reigns is not available for this account.", Duration = 4, Icon = "lock" })
            return
        end
        if value == "Roman Reigns" and not IsRomanAllowed then
            return
        end
        local success = WindUI:SetTheme(value) ~= nil
        WindUI:Notify({ Title = "OTC UI", Content = success and ("Theme set to " .. value) or "Could not apply this theme.", Duration = 3 })
    end,
})
Settings:Button({ Title = "Test current theme", Icon = "palette", Callback = function() print("[OTC UI] Theme:", WindUI:GetCurrentTheme()) end })
Settings:Button({ Title = "Destroy test window", Desc = "Close this showcase window.", Icon = "trash-2", Callback = function() Window:Destroy() end })

if IsRomanAllowed then
    local Roman = Window:Tab({ Title = "Tribal Chief", Icon = "crown", IconShape = "Square" })
    Roman:Paragraph({
        Title = "Head of the Table",
        Desc = "Private Roman Reigns theme artwork. Visible only to the authorized user ID.",
        Image = RomanImage,
        ImageSize = 180,
        Thumbnail = RomanImage,
    })
    Roman:Button({ Title = "Apply Roman Reigns Theme", Icon = "crown", Callback = function() WindUI:SetTheme("Roman Reigns") end })
end

About:Paragraph({
    Title = "Powered by WindUI",
    Desc = "WindUI is developed by Footagesus and distributed under the MIT License. OTC UI v1.0.5 is an integration layer, not a claim of original ownership of WindUI.",
})
About:Button({ Title = "Show library versions", Icon = "info", Callback = function()
    WindUI:Notify({ Title = "Version info", Content = "OTC UI 1.0.5 | WindUI " .. WINDUI_VERSION, Duration = 5 })
end })

print("[OTC UI] Test script loaded. OTC UI 1.0.5 / WindUI " .. WINDUI_VERSION)
