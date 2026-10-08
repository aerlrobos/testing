# OTC Hub v1 (i know it's AI idc i'm using only for me 😁)

<p align="center">
  <img src="OTC.png" width="180">
</p>

<h1 align="center">OTC Hub v1</h1>

<p align="center">
  A modern, modular and customizable Roblox Luau UI Library.
</p>

<p align="center">
  <b>Version 1.0.2</b> • <b>by Aerlro</b>
</p>

---

## ✨ Features

- 🎨 Advanced Theme System
- 🌈 Gradient support
- ✨ Animated gradients
- 💡 Glow and shadow effects
- 🖌️ Custom component colors
- 🔲 Custom corner radius
- 🧱 Custom strokes
- 🔔 Notification system
- 📑 Tabs
- 📦 Sections
- 🔘 Buttons
- 🔄 Toggles
- 🎚️ Sliders
- 📋 Dropdowns
- ☑️ Multi-select Dropdowns
- ⌨️ Inputs
- 🚩 Flags
- 🎬 Tween animations
- 🖼️ Lucide icon support
- 💾 Auto-save / Auto-load configuration support
- ⌨️ Configurable toggle key
- 🧩 Modular architecture
- ⚡ Raw GitHub loading
- 🎃 Halloween theme
- 🔴 Red theme
- 🟢 Green theme
- 🔵 Blue theme
- 🟣 Purple theme
- 🟠 Orange theme
- ⚪ Default theme

---

## 🆕 What's new in 1.0.2

- 🪟 Redesigned window: bigger (640x420), wider sidebar, animated accent line, smooth open animation
- ⌨️ **Keybind** element (keyboard + MB2/MB3, hold mode, saved with flags)
- 🎨 **Color Picker** element (saturation/value square, hue bar, hex input)
- 📊 **Progress** element
- ➖ **Divider**, 📄 **Paragraph**, ␣ **Space** (auto-sizing), `Text` and `Section` redesigned
- 🏷️ **Window tags** (`Window:CreateTag`)
- 💬 **Dialog / Popup** system (`Window:Dialog`)
- 🔔 Notification types: `Success`, `Warning`, `Error`, `Info`
- 💾 **Config system that actually saves**: `autoSave`, `autoLoad`, `OTC:SaveConfig()`, `OTC:LoadConfig()`
- 🚩 Dropdown now supports `Flag`
- 🌈 6 new themes: Midnight, Ocean, Rose, Mocha, Aurora, Light
- 🛠️ Fixes: toggle key no longer fires twice, `OTC:RegisterTheme` now exists, `loader.lua` fixed

### Keybind

```lua
MainTab:CreateKeybind({
    Name = "Fly",
    CurrentKeybind = "F",      -- string or Enum.KeyCode
    HoldToInteract = false,    -- true: Callback(true) on press, Callback(false) on release
    Flag = "FlyKey",
    Callback = function(KeyName) end,
    ChangedCallback = function(KeyName) end
})
```

Click the key box, then press a key. `Esc` cancels, `Backspace` clears.

### Color Picker

```lua
MainTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "EspColor",
    Callback = function(Color) end
})
```

### Progress

```lua
local Bar = MainTab:CreateProgress({ Name = "Loading", Range = {0, 100}, CurrentValue = 0 })
Bar:SetValue(50)
```

### Divider / Paragraph / Space

```lua
MainTab:CreateDivider("Settings")
MainTab:CreateParagraph({ Title = "Info", Content = "Long text that wraps." })
MainTab:CreateSpace(12)
```

### Tags

```lua
local Window = OTC:CreateWindow({ Name = "OTC Hub", Tags = { "Beta" } })
Window:CreateTag({ Title = "VIP", Color = Color3.fromRGB(255, 190, 60) })
```

### Dialog

```lua
Window:Dialog({
    Title = "Are you sure?",
    Content = "This cannot be undone.",
    Buttons = {
        { Title = "Cancel" },
        { Title = "Confirm", Style = "Primary", Callback = function() end }
    }
})
```

### Notification types

```lua
OTC:Notify({ Type = "Success", Content = "Saved!", Duration = 3 })
```

### Saving

```lua
local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Configuration = { autoSave = true, autoLoad = true, fileName = "OTC", customFolder = "OTC" }
})

OTC:SaveConfig("MyConfig")
OTC:LoadConfig("MyConfig")
print(OTC:ListConfigs())
```

Every element with a `Flag` is saved (toggles, sliders, inputs, dropdowns, keybinds, color pickers) together with the selected theme.

---

## 📦 Installation


Load OTC Hub directly from GitHub:

```lua
local OTC = loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/otc.lua"))()
```

After loading the library, create a window:

```lua
local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "by Aerlro",
    Theme = "Default"
})
```

---

## 🪟 Create Window

```lua
local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "by Aerlro",
    Theme = "Default"
})
```

### Window Settings

| Setting | Type | Description |
|---|---|---|
| `Name` | string | Window name |
| `Subtitle` | string | Text displayed under the title |
| `Theme` | string | Theme used by the window |

Example:

```lua
local Window = OTC:CreateWindow({
    Name = "My Script",
    Subtitle = "by Aerlro",
    Theme = "Purple"
})
```

---

## 📑 Create Tab

```lua
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "home"
})
```

Another example:

```lua
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings"
})
```

---

## 📦 Create Section

```lua
MainTab:CreateSection("Main Features")
```

---

## 📝 Create Text

```lua
MainTab:CreateText("Welcome to OTC Hub!")
```

With longer text:

```lua
MainTab:CreateText("This is an example of the OTC Hub text element.")
```

---

## 🔘 Button

```lua
MainTab:CreateButton({
    Name = "Test Button",
    Description = "Click this button to test OTC Hub.",
    Callback = function()
        print("Button clicked!")
    end
})
```

---

## 🔄 Toggle

```lua
MainTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Automatically farms resources",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})
```

### Toggle without description

```lua
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        print("Infinite Jump:", Value)
    end
})
```

---

## 🎚️ Slider

```lua
MainTab:CreateSlider({
    Name = "Walkspeed",
    Description = "Change your walkspeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Flag = "Walkspeed",
    Callback = function(Value)
        print("Walkspeed:", Value)
    end
})
```

---

## 📋 Dropdown

```lua
MainTab:CreateDropdown({
    Name = "Select Player",
    Description = "Select a player",
    Options = {"Player 1", "Player 2", "Player 3"},
    CurrentOption = "Player 1",
    MultiSelect = false,
    Callback = function(Value)
        print("Selected:", Value)
    end
})
```

---

## ☑️ Multi-Select Dropdown

```lua
MainTab:CreateDropdown({
    Name = "Select Features",
    Description = "Select multiple features",
    Options = {"Auto Farm", "Auto Collect", "Auto Sell"},
    CurrentOption = {},
    MultiSelect = true,
    Callback = function(Value)
        print("Selected features:", Value)
    end
})
```

---

## ⌨️ Input

```lua
MainTab:CreateInput({
    Name = "Username",
    Description = "Enter a username",
    PlaceholderText = "Enter username...",
    CurrentValue = "",
    Flag = "Username",
    Callback = function(Value)
        print("Username:", Value)
    end
})
```

---

## 🔔 Notifications

OTC Hub includes a built-in notification system.

```lua
OTC:Notify({
    Title = "OTC Hub",
    Content = "Hello from OTC Hub!",
    Duration = 4
})
```

### Notification with the OTC logo

```lua
OTC:Notify({
    Title = "OTC Hub",
    Content = "This notification uses the OTC logo.",
    Duration = 4,
    Icon = "rbxassetid://104463753775983"
})
```

### Custom notification icon

You can use your own Roblox asset:

```lua
OTC:Notify({
    Title = "Custom Icon",
    Content = "This notification uses a custom icon.",
    Duration = 4,
    Icon = "rbxassetid://1234567890"
})
```

---

## 🎨 Themes

OTC Hub includes multiple built-in themes.

Available themes:

```text
Default
Red
Green
Blue
Purple
Orange
Halloween
Midnight
Ocean
Rose
Mocha
Aurora
Light
```

Get all themes:

```lua
local Themes = OTC:GetThemes()
print(Themes)
```

---

## 🔄 Change Theme

Change the theme while the UI is running:

```lua
OTC:SetTheme("Purple")
```

Example:

```lua
MainTab:CreateButton({
    Name = "Purple Theme",
    Callback = function()
        OTC:SetTheme("Purple")
    end
})
```

Another example:

```lua
MainTab:CreateButton({
    Name = "Halloween Theme",
    Callback = function()
        OTC:SetTheme("Halloween")
    end
})
```

---

## 🎨 Custom Themes

You can register your own theme:

```lua
OTC:RegisterTheme("Custom", {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Element = Color3.fromRGB(35, 35, 35),
    Hover = Color3.fromRGB(50, 50, 50),
    Pressed = Color3.fromRGB(65, 65, 65),
    Border = Color3.fromRGB(100, 100, 100),
    BorderHover = Color3.fromRGB(150, 150, 150),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(190, 190, 190),
    MutedText = Color3.fromRGB(130, 130, 130),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDark = Color3.fromRGB(180, 180, 180),
    AccentHover = Color3.fromRGB(220, 220, 220),
    AccentText = Color3.fromRGB(0, 0, 0)
})
```

Then activate it:

```lua
OTC:SetTheme("Custom")
```

---

## 🌈 Gradients

OTC Hub supports gradients for different UI components.

Supported gradient areas include:

```text
Main
TopBar
Sidebar
Element
Accent
```

Themes can define multiple colors using `ColorSequence`.

Example:

```lua
Gradients = {
    Main = {
        Enabled = true,
        Colors = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 0))
        }),
        Rotation = 45
    }
}
```

---

## ✨ Animated Gradients

OTC Hub supports animated gradients.

Enable them through the theme:

```lua
Effects = {
    Glow = true,
    Shadow = true,
    Gradient = true,
    AnimatedGradient = true
}
```

---

## 🚩 Flags

Elements can use flags.

Example:

```lua
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print(Value)
    end
})
```

Retrieve the flag:

```lua
local Value = OTC:GetFlag("AutoFarm")
print(Value)
```

Set a flag:

```lua
OTC:SetFlag("AutoFarm", true)
```

---

## 🎬 Tween

OTC Hub includes a tween helper:

```lua
OTC:Tween(Object, 0.25, {
    BackgroundTransparency = 0
})
```

Custom easing:

```lua
OTC:Tween(
    Object,
    0.35,
    {
        Size = UDim2.new(0, 300, 0, 100)
    },
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)
```

---

## 🧹 Connections

OTC Hub can manage connections:

```lua
local Connection = OTC:Connect(
    game:GetService("RunService").Heartbeat:Connect(function()
        print("Running")
    end)
)
```

Disconnect everything:

```lua
OTC:DisconnectAll()
```

---

## 🖼️ OTC Logo

The default OTC logo asset is:

```text
rbxassetid://104463753775983
```

The repository logo is:

```text
OTC.png
```

Repository:

https://github.com/Aerlro/OTC-Hub-v1

---

## 🧪 Complete Example

```lua
local OTC = loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/otc.lua"))()

local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "by Aerlro",
    Theme = "Purple"
})

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "home"
})

MainTab:CreateSection("Main Features")

MainTab:CreateText("Welcome to OTC Hub!")

MainTab:CreateButton({
    Name = "Test Button",
    Description = "Test the OTC button.",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Automatically farms resources",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

MainTab:CreateSlider({
    Name = "Walkspeed",
    Description = "Change your walkspeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Flag = "Walkspeed",
    Callback = function(Value)
        print("Walkspeed:", Value)
    end
})

MainTab:CreateDropdown({
    Name = "Player",
    Description = "Select a player",
    Options = {"Player 1", "Player 2", "Player 3"},
    CurrentOption = "Player 1",
    MultiSelect = false,
    Callback = function(Value)
        print("Player:", Value)
    end
})

MainTab:CreateDropdown({
    Name = "Features",
    Description = "Select multiple features",
    Options = {"Auto Farm", "Auto Collect", "Auto Sell"},
    CurrentOption = {},
    MultiSelect = true,
    Callback = function(Value)
        print("Features:", Value)
    end
})

MainTab:CreateInput({
    Name = "Username",
    Description = "Enter a username",
    PlaceholderText = "Enter username...",
    CurrentValue = "",
    Flag = "Username",
    Callback = function(Value)
        print("Username:", Value)
    end
})

MainTab:CreateSection("Notifications")

MainTab:CreateButton({
    Name = "Test Notification",
    Description = "Show an OTC notification.",
    Callback = function()
        OTC:Notify({
            Title = "OTC Hub",
            Content = "Notification test!",
            Duration = 4
        })
    end
})

MainTab:CreateButton({
    Name = "Halloween Theme",
    Callback = function()
        OTC:SetTheme("Halloween")
    end
})
```

---

## 🧪 Theme Test

```lua
local OTC = loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/otc.lua"))()

local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "Theme Test",
    Theme = "Default"
})

local MainTab = Window:CreateTab({
    Name = "Theme Test",
    Icon = "palette"
})

MainTab:CreateSection("Theme")

MainTab:CreateText("Select a theme to test the OTC Hub theme system.")

MainTab:CreateDropdown({
    Name = "Theme",
    Description = "Select an OTC Hub theme",
    Options = OTC:GetThemes(),
    CurrentOption = OTC.CurrentTheme,
    MultiSelect = false,
    Callback = function(Value)
        local ThemeName = Value
        if type(Value) == "table" then
            ThemeName = Value[1]
        end
        if not ThemeName then return end
        OTC:SetTheme(ThemeName)
    end
})

MainTab:CreateSection("Button")

MainTab:CreateButton({
    Name = "Test Button",
    Description = "Test button colors and hover.",
    Callback = function()
        print("Button test")
    end
})

MainTab:CreateSection("Toggle")

MainTab:CreateToggle({
    Name = "Test Toggle",
    Description = "Test toggle colors.",
    CurrentValue = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

MainTab:CreateSection("Slider")

MainTab:CreateSlider({
    Name = "Test Slider",
    Description = "Test slider.",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        print("Slider:", Value)
    end
})

MainTab:CreateSection("Dropdown")

MainTab:CreateDropdown({
    Name = "Test Dropdown",
    Description = "Test dropdown.",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    MultiSelect = false,
    Callback = function(Value)
        print("Dropdown:", Value)
    end
})

MainTab:CreateDropdown({
    Name = "Multi Dropdown",
    Description = "Test multi-select.",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {},
    MultiSelect = true,
    Callback = function(Value)
        print("Multi Dropdown:", Value)
    end
})

MainTab:CreateSection("Input")

MainTab:CreateInput({
    Name = "Test Input",
    Description = "Test text input.",
    PlaceholderText = "Type something...",
    CurrentValue = "",
    Callback = function(Value)
        print("Input:", Value)
    end
})

MainTab:CreateSection("Notifications")

MainTab:CreateButton({
    Name = "Test Notification",
    Description = "Show a notification.",
    Callback = function()
        OTC:Notify({
            Title = "OTC Hub",
            Content = "Notification test.",
            Duration = 4
        })
    end
})
```

---

## 📁 Project Structure

```text
OTC-Hub-v1/
├── otc.lua
├── loader.lua
├── example.lua
├── OTC.png
├── Core/
│   ├── tab.lua
│   ├── window.lua
│   ├── theme.lua
│   ├── animation.lua
│   ├── notification.lua
│   ├── config.lua
│   ├── popup.lua
│   └── lucide.lua
└── Elements/
    ├── button.lua
    ├── toggle.lua
    ├── slider.lua
    ├── dropdown.lua
    ├── input.lua
    ├── keybind.lua
    ├── colorpicker.lua
    └── progress.lua
```

---

## 🧩 Modules

### Core

```text
Core/tab.lua
Core/window.lua
Core/theme.lua
Core/animation.lua
Core/notification.lua
Core/lucide.lua
```

### Elements

```text
Elements/button.lua
Elements/toggle.lua
Elements/slider.lua
Elements/dropdown.lua
Elements/input.lua
```

---

## 🎨 Built-in Themes

### Default

Neutral gray UI with white accents.

### Red

Saturated red interface with bright red accents.

### Green

Saturated green interface with bright green accents.

### Blue

Saturated blue interface with bright blue accents.

### Purple

Saturated purple interface with bright purple accents.

### Orange

Saturated orange interface with bright orange accents.

### Halloween

Purple, orange and dark Halloween-inspired theme.

---

## ⚙️ Configuration

OTC Hub supports automatic configuration settings through the window configuration system.

Example:

```lua
local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "by Aerlro",
    Theme = "Default",
    Configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "OTC",
        customFolder = "OTC"
    }
})
```

---

## 🔗 Repository

GitHub:

https://github.com/Aerlro/OTC-Hub-v1

Raw Loader:

https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/otc.lua

---

## 👤 Author

**Aerlro**

OTC Hub v1 is developed by Aerlro.

---

## 📜 License

This project is provided for educational and development purposes.

Do not claim the project as your own.

---

<p align="center">
  <b>OTC Hub v1</b>
  <br>
  by Aerlro
</p>